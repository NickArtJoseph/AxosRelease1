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
private class RequestAccountResearchSFDC2Ctlr_Test {

	/**
	 * Test logic for sending requests for Account research
	 */
    static testMethod void researchAccountRequestTest() {

        RecordType enterpriseRT = [select Id from RecordType where SObjectType='Account' and DeveloperName='Consumer_Person_Account_SFDC2'];
        RecordType prospectRT = [select Id from RecordType where SObjectType='Account' and DeveloperName='Prospecting_Consumer_PA_SFDC2'];
            
		Account account = new Account (FirstName='Test', LastName='Test', RecordTypeId=enterpriseRT.Id);
		insert account;

        // start test
        Test.startTest();
        
        RequestAccountResearchSFDC2Controller controller;
        
		// --- test request research page
		Test.setCurrentPage(Page.RequestAccountResearchSFDC2);
		controller = new RequestAccountResearchSFDC2Controller(new ApexPages.StandardController(account));
        controller.requestType = 'PHONE';    
            
        // request Account research
		controller.sendAccount();
            
        // confirm updated record type
		System.assertEquals(prospectRT.Id, account.RecordTypeId, 'Unexpected record type for researching consumer Account.');
        
        // --- test cancel button
		PageReference cancelPage = new PageReference('/' + account.Id);
		System.assertEquals(cancelPage.getURL(), controller.cancel().getURL(), 'Unexpected return URL for cancel button.');
        
        // stop test
        Test.stopTest();
        
    }
    
    /**
     * Test logic for sending requests for Account research under failure conditions
     */
    static testMethod void researchAccountRequestFailureTest() {

        RecordType enterpriseRT = [select Id from RecordType where SObjectType='Account' and DeveloperName='Consumer_Person_Account_SFDC2'];
        RecordType prospectRT = [select Id from RecordType where SObjectType='Account' and DeveloperName='Prospecting_Consumer_PA_SFDC2'];
            
		Account account = new Account (FirstName='Test', LastName='Test', RecordTypeId=enterpriseRT.Id);
		insert account;

        // start test
        Test.startTest();
        
        RequestAccountResearchSFDC2Controller controller;
        
        // --- test unused phone numbers
        Phone_SFDC2__c phone = new Phone_SFDC2__c(Account__c=account.Id, Phone__c='(987) 654-1234', Phone_Status__c='Unverified', Phone_Type__c='Other Business');
        insert phone;

        Test.setCurrentPage(Page.RequestAccountResearchSFDC2);
        controller = new RequestAccountResearchSFDC2Controller(new ApexPages.StandardController(account));
        controller.requestType = 'PHONE';    
        
        // Try requesting research
        controller.sendAccount();
        
        // Confirm no change to record type
        System.assertEquals(enterpriseRT.Id, account.RecordTypeId, 'Unexpected record type for unused phone number case.');
        
        // --- test unused email addresses
        Email_SFDC2__c email = new Email_SFDC2__c(Account__c=account.Id, Email__c='test@test.com', Email_Status__c='Unverified', Email_Type__c='Other Business');
        insert email;

        Test.setCurrentPage(Page.RequestAccountResearchSFDC2);
        controller = new RequestAccountResearchSFDC2Controller(new ApexPages.StandardController(account));
        controller.requestType = 'EMAIL';    
        
        // Try requesting research
        controller.sendAccount();
        
        // Confirm no change to record type
        System.assertEquals(enterpriseRT.Id, account.RecordTypeId, 'Unexpected record type for unused email case.');

        delete email;
        
        // -- test JH customer request
        account = new Account (FirstName='Test', LastName='Test', RecordTypeId=enterpriseRT.Id, CIF_SFDC2__c='TEST1234');
		insert account;

        Test.setCurrentPage(Page.RequestAccountResearchSFDC2);
        controller = new RequestAccountResearchSFDC2Controller(new ApexPages.StandardController(account));
        controller.requestType = 'PHONE';    
        
        // Try requesting research
        controller.sendAccount();
        
        // Confirm no change to record type
        System.assertEquals(enterpriseRT.Id, account.RecordTypeId, 'Unexpected record type for Jack Henry customer case.');
    	
    	// stop test
    	Test.stopTest();
    	
    }
    
    /**
     * Test logic for returning researched Accounts to the requesting business unit
     */
    static testMethod void returnAccountTest() {
    	
        // set up test data
        User userBU, userRM;
        try {
            userBU = [select id from User where IsActive=True and Profile.Name='Enterprise User' and UserRole.Name!='Research Manager' LIMIT 1];
            userRM = [select id from User where IsActive=True and Profile.Name='Enterprise User' and UserRole.Name='Research Manager' LIMIT 1];
        } catch (QueryException qe) {
            System.debug(qe);
            return;
        }

        RecordType enterpriseRT = [select Id from RecordType where SObjectType='Account' and DeveloperName='Consumer_Person_Account_SFDC2'];
        RecordType prospectRT = [select Id from RecordType where SObjectType='Account' and DeveloperName='Prospecting_Consumer_PA_SFDC2'];
            
		Account account = new Account (FirstName='Test', LastName='Test', RecordTypeId=prospectRT.Id, OwnerId=userRM.Id, Research_Requested_By_SFDC2__c=userBU.Id);
		insert account;

        // start test
        Test.startTest();
        
        RequestAccountResearchSFDC2Controller controller;
    	
    	System.runAs(userRM) {
    		
    		// --- test return of researched record
        	Test.setCurrentPage(Page.RequestAccountResearchSFDC2);
        	controller = new RequestAccountResearchSFDC2Controller(new ApexPages.StandardController(account));
        
        	// Return Account
        	controller.returnAccount();
        
        	// Confirm change to record type
        	System.assertEquals(enterpriseRT.Id, account.RecordTypeId, 'Unexpected record type for returned Account.');
    		System.assertEquals('005i0000001wnZb', account.OwnerId, 'Unexpected Account record owner after return.');
    		
    	}

		account = new Account (FirstName='Test', LastName='Test', RecordTypeId=prospectRT.Id, OwnerId=userRM.Id, Research_Requested_By_SFDC2__c=userBU.Id);
		insert account;
        RecordType oppRT = [SELECT Id FROM RecordType WHERE SObjectType='Opportunity' AND DeveloperName='Consumer_Deposits_SFDC2'];
		Opportunity opp = new Opportunity (Name='Test', AccountId=account.Id, RecordTypeId=oppRT.Id, OwnerId=userBU.Id, StageName='5 - Pending Review', CloseDate=date.today());
        insert opp;
        
    	System.runAs(userBU) {
    		
    		// --- test return of researched record
        	Test.setCurrentPage(Page.RequestAccountResearchSFDC2);
        	controller = new RequestAccountResearchSFDC2Controller(new ApexPages.StandardController(account));
        
        	// Return Account
        	controller.returnAccount();
        
        	// Confirm change to record type
        	System.assertEquals(prospectRT.Id, account.RecordTypeId, 'Unexpected record type after non-owner attempted return.');
    		System.assertEquals(userRM.Id, account.OwnerId, 'Unexpected Account record owner after non-owner attempted return.');
    		
    	}

		// stop the test
		Test.stopTest();
		    	
    }
    
    
    //* Cancel Research Request for Account*//
    
    static testmethod void cancelResearchforAccount(){
        
        User userBU, userRM, userAdmin;
        try {
            userBU = [select id from User where IsActive=True and Profile.Name='Enterprise User' and UserRole.Name!='Research Manager' LIMIT 1];
            userRM = [select id from User where IsActive=True and Profile.Name='Enterprise User' and UserRole.Name='Research Manager' LIMIT 1];
            userAdmin = [select id from User where IsActive=True and Profile.Name='System Administrator' LIMIT 1];
        } catch (QueryException qe) {
            System.debug(qe);
            return;
        }
        
        RecordType enterpriseRT = [select Id from RecordType where SObjectType='Account' and DeveloperName='Business_Account_SFDC2'];
        RecordType prospectRT = [select Id from RecordType where SObjectType='Account' and DeveloperName='Prospecting_Business_SFDC2'];
        
        Account account;
        System.runAs(userAdmin){
        account = new Account (Name='Test', RecordTypeId=enterpriseRT.Id, Research_Requested_By_SFDC2__c=userBU.Id);
        insert account;
        }
       // Account account = new Account (AccountName='Test', RecordTypeId=prospectRT.Id, OwnerId=userRM.Id, Research_Requested_By_SFDC2__c=userBU.Id);
       // insert account;
        
        Test.startTest();
        RequestAccountResearchSFDC2Controller.cancelresearch(account.Id, userBU.Id);
        Test.stopTest();
    }

   
    
}