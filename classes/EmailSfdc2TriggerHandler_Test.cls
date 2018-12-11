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
private class EmailSfdc2TriggerHandler_Test {

	/** Test update of primary email on Account */
	@isTest
    static void testPrimaryEmailUpdate() {
        TriggerValidator.setIsTest();
        
        List<Account> accounts = new List<Account>();
        List<Lead> leads = new List<Lead>();
        
        System.debug('SFDC2.0: Setting up 20 leads, 20 person accounts and 20 accounts to test update of primary address fields');
        
        RecordType personAccountRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Business/Consumer Person Account'];
        RecordType businessAccountRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Business Account SFDC2'];
        RecordType leadRecordType = [SELECT Id FROM RecordType WHERE SObjectType='Lead' AND Name = 'Consumer Deposits SFDC2'];
         // Add person accounts with email addresses populated
        for (Integer i = 0; i<40; i++) {
        	Account acct = null;
        	if (math.mod(i, 20) < 10) {
  				String uniqueLastName = 'Person' + i;
	  			acct = new Account(RecordTypeId = personAccountRecordType.Id,
	  							   FirstName = 'Test', 
	  							   LastName = uniqueLastName, 
	  							   SFDC2__c = true,
	  							   PersonEmail = 'test1@test.com',
	  							   Business_Email_SFDC2__pc = 'test2@test.com');
        	} else {
  				String uniqueCompanyName = 'Company' + i;
	  			acct = new Account(RecordTypeId = businessAccountRecordType.Id,
								   Name = uniqueCompanyName,
	  							   SFDC2__c = true,
	  							   Email__c = 'test1@test.com');
        	}					  
			accounts.add(acct);

  			String uniqueLastName = 'Person' + i;
	  		Lead lead = new Lead(RecordTypeId = leadRecordType.Id,
                				 FirstName = 'Test',
								 LastName = uniqueLastName,
	  							 SFDC2__c = true,
	  							 Email = 'test1@test.com');
			leads.add(lead);
	  	}
	  	
	  	insert accounts;
	  	insert leads;
	  	
	  	// Add a list of email objects to each account and lead, set to 'other' (used to test update)
		List<Email_SFDC2__c> emails1 = new List<Email_SFDC2__c>();
	  	for (Integer i = 0; i<20; i++) {
	  		if (i<10) {
				emails1.add(new Email_SFDC2__c(Account__c = accounts.get(i).Id,											    
										   Email__c = 'test3@test.com', 
										   Email_Type__c = 'Other Personal'));
	  		}
			emails1.add(new Email_SFDC2__c(Account__c = accounts.get(i).Id, 
										   Email__c = 'test4@test.com', 
										   Email_Type__c = 'Other Business'));
			emails1.add(new Email_SFDC2__c(Lead__c = leads.get(i).Id, 
										   Email__c = 'test4@test.com', 
										   Email_Type__c = 'Other Personal'));
	  	}

		insert emails1;
		
		// Update email objects to be primary
		for (Email_SFDC2__c email : emails1) {
			if (email.Email_Type__c.equals('Other Personal')) email.Email_Type__c = 'Primary Personal';
			if (email.Email_Type__c.equals('Other Business')) email.Email_Type__c = 'Primary Business';
		}      

	  	// Add a list of email objects to each account, set to 'primary' (used to test insert)
		List<Email_SFDC2__c> emails2 = new List<Email_SFDC2__c>();
	  	for (Integer i = 20; i<40; i++) {
	  		if (i<30) {
				emails2.add(new Email_SFDC2__c(Account__c = accounts.get(i).Id, 
										   Email__c = 'test3@test.com', 
										   Email_Type__c = 'Primary Personal'));
	  		}
			emails2.add(new Email_SFDC2__c(Account__c = accounts.get(i).Id, 
										   Email__c = 'test4@test.com', 
										   Email_Type__c = 'Primary Business'));
			emails2.add(new Email_SFDC2__c(Lead__c = leads.get(i).Id, 
										   Email__c = 'test4@test.com', 
										   Email_Type__c = 'Primary Personal'));
	  	}
		
		Test.startTest();
		update emails1; 
		insert emails2;
		Test.stopTest();
		
		accounts = [SELECT Id, PersonEmail, Business_Email_SFDC2__pc, Email__c, 
  			(SELECT Email__c FROM Email_Addresses__r WHERE Account__c IN :accounts )
  			FROM Account WHERE Id IN :accounts];

		leads = [SELECT Id, Email, 
  			(SELECT Email__c FROM Email_Addresses__r WHERE Lead__c IN :leads )
  			FROM Lead WHERE Id IN :leads];

		for (Integer i=0; i<40; i++) {
			if (math.mod(i, 20) < 10) {
				System.assertEquals('test3@test.com',accounts.get(i).PersonEmail, 'Failed to update primary personal email address.');
				System.assertEquals('test4@test.com',accounts.get(i).Business_Email_SFDC2__pc, 'Failed to update primary business email address on Person Account.');
			} else {
				System.assertEquals('test4@test.com',accounts.get(i).Email__c, 'Failed to update primary business email address on Business Account.');
			}
			System.assertEquals('test4@test.com',leads.get(i).Email, 'Failed to update primary email address on Lead.');
		}
    }
}