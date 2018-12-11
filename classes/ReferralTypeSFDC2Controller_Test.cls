/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class ReferralTypeSFDC2Controller_Test {

    static testMethod void referralTest() {

		// Set up test data for calling record
		Account account = TestDataFactory.createAndInsertTestPersonAccount();
		RecordType referToType = [select id from RecordType where SObjectType='Opportunity' and Name='Dealership Recruiting SFDC2'];

		Profile userProfile = new Profile();
		Profile adminProfile = new Profile();
		for(Profile prof : [select id, Name from Profile where Name in ('Enterprise User', 'System Administrator')]) {
			if(prof.Name == 'System Administrator') {
				adminProfile = prof;
			} else if (prof.Name == 'Enterprise User') {
				userProfile = prof;
			}
		}		
		User mgr = new User(alias='test532', profileId=adminProfile.Id, lastName='testLast64532', firstName='testFirst', userName='test64532@test.com.test',
							 email='test64532@test.com', CommunityNickname='test6453', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
							 EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
		insert mgr;
		User user = new User(alias='tesrt45', profileId=userProfile.Id, lastName='testLarst6452', firstName='testrFirst', userName='test645@test.com.test',
							 email='test6r45@test.com', CommunityNickname='tesrt645', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
							 EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', ManagerId=mgr.Id, Department='Test', Division='Test', Trained_SFDC2__c=true);
		insert user;
        
		ReferralTypeSFDC2Controller controller;
		
		System.runAs(user) {
		
			PageReference pr = new PageReference('/apex/ReferralTypeSFDC2?accountId=' + account.id + '&retURL=%2F' + account.id );
			Test.setCurrentPageReference(pr);
	        
	        controller = new ReferralTypeSFDC2Controller();
	        
	        // Test Record Type PickList values
	        List<SelectOption> oppRTs = new List<SelectOption>();
			for(RecordTypeInfo info: Opportunity.SObjectType.getDescribe().getRecordTypeInfos()) {
    			if((info.getName() == 'Advisor Recruiting SFDC2'
                    || info.getName() == 'Advisory SFDC2'
                    || info.getName() == 'Auto Loan Indirect SFDC2'
                    || info.getName() == 'Business Banking SFDC2'
                    || info.getName() == 'Consumer Deposits SFDC2'
                    || info.getName() == 'Dealership Recruiting SFDC2'
                    || info.getName() == 'Virtus SFDC2'
                    || info.getName() == 'Epiq SFDC2'
                    || info.getName() == 'Dealer Services - Applicant SFDC2'
                    || info.getName() == 'ULP SFDC2'                         
    			    || info.getName() == 'HBD SFDC2')
    			  && info.isAvailable() == false) {
        			oppRTs.add(new SelectOption(info.getRecordTypeId(), info.getName()));
    			}
			}
	        List<SelectOption> pickListRTs = controller.ReferToList;
	        for (SelectOption oppRT : oppRTs) {
	        	String rtName = null;
	        	for (SelectOption so : pickListRTs) {
	        		if (so.getValue() == oppRT.getValue()) rtName = so.getLabel();
	        	}
	        	System.assertEquals(oppRT.getLabel(), rtName, 'Missing/Incorrect Record Type in PickList.');
	        }
            
            System.assertEquals(true, controller.checkAccess, 'Non-Admin SFDC2 user misidentified.');
		}
        
        System.assertEquals(false, controller.checkUser, 'Non-Opportunity holder misidentified.'); 
        
		// Test New Record URL
		User refUser = [select Id, Name, UserRole.Name from User where id=:UserInfo.getUserId()];
		controller.ReferTo = referToType.id;
		PageReference createPr = controller.create();
		PageReference returnPr = new PageReference('/'+account.id);
		System.assertEquals(createPr.getURL(), returnPr.getURL(), 'Unexpected Opportunity record creation URL');
		List<Opportunity> createdOpps = [select id from Opportunity where AccountId=:account.id];
		System.assertEquals(1, createdOpps.size(), 'Opportunity not created');
		
		// Test Return URL
		PageReference cancelPr = new PageReference('/'+account.id);
		System.assertEquals(cancelPr.getURL(), controller.cancel().getURL(), 'Unexpected cancel (return) URL');
			        
    }
}