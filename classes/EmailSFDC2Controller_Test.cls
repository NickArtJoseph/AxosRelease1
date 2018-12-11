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
private class EmailSFDC2Controller_Test {

    static testMethod void emailTest() {
		
		// set up test data
 	    RecordType acctRt = [select Id from RecordType where SObjectType='Account' and DeveloperName='Business_Consumer_Person_Account' limit 1];
 	  	RecordType leadRt = [select Id from RecordType where SObjectType='Lead' and DeveloperName='Consumer_Deposits' limit 1];   
    	Account account = new Account(FirstName='testFirst', LastName='testLast', RecordTypeId=acctRt.Id, SFDC2__c=true);
    	Lead lead = new Lead(FirstName='testFirst', LastName='testLast', RecordTypeId=leadRt.Id, SFDC2__c=true);
    	insert account;
    	insert lead;
    	
    	System.assertEquals(true, account.SFDC2__c, 'Error inserting account.');
    	System.assertEquals(true, lead.SFDC2__c, 'Error inserting lead.');
    	
		Email_SFDC2__c acctEmail = new Email_SFDC2__c(Account__c=account.id, Email__c='test@test.com', Email_Type__c='Other Personal');
		Email_SFDC2__c leadEmail = new Email_SFDC2__c(Lead__c=lead.id, Email__c='test@test.com', Email_Type__c='Other Personal');
		insert acctEmail;
		insert leadEmail;

		System.assertEquals(account.Id, acctEmail.Account__c, 'Error inserting Account email.');
		System.assertEquals(lead.Id, leadEmail.Lead__c, 'Error inserting Lead email.');
		        
		// start test
		Test.startTest();
		
		// test save page
		Test.setCurrentPage(Page.EmailSFDC2Save);

		EmailSFDC2Controller acctSaveController = new EmailSFDC2Controller(new ApexPages.StandardController(acctEmail));
		PageReference acctSavePage = acctSaveController.getViewPage(acctEmail, 'EmailSFDC2View');
		System.assertEquals(acctSavePage.getURL(), acctSaveController.onSave().getURL(), 'Unexpected after-save page reference for Account Email');

		EmailSFDC2Controller leadSaveController = new EmailSFDC2Controller(new ApexPages.StandardController(leadEmail));
		PageReference leadSavePage = leadSaveController.getViewPage(leadEmail, 'EmailSFDC2View');
		System.assertEquals(leadSavePage.getURL(), leadSaveController.onSave().getURL(), 'Unexpected after-save page reference for Lead Email');
		
		// test view page
		Test.setCurrentPage(Page.EmailSFDC2View);

		EmailSFDC2Controller acctViewController = new EmailSFDC2Controller(new ApexPages.StandardController(acctEmail));
		PageReference acctEditPage = acctViewController.getEditPage(acctEmail, 'EmailSFDC2Save', 'EmailSFDC2View', account.id);
		System.assertEquals(acctEditPage.getURL(), acctViewController.onEdit().getURL(), 'Unexpected edit page reference for Account Email');

		EmailSFDC2Controller leadViewController = new EmailSFDC2Controller(new ApexPages.StandardController(leadEmail));
		PageReference leadEditPage = leadViewController.getEditPage(leadEmail, 'EmailSFDC2Save', 'EmailSFDC2View', lead.id);
		System.assertEquals(leadEditPage.getURL(), leadViewController.onEdit().getURL(), 'Unexpected edit page reference for Lead Email');

		// test new page
		PageReference origPage = Page.EmailSFDC2New;
		origPage.getParameters().put('retURL','/' + account.id);
		Test.setCurrentPageReference(origPage);
		
		Email_SFDC2__c newEmail = new Email_SFDC2__c(Account__c=account.id, Email__c='test@test.com', Email_Type__c='Other Personal');
		EmailSFDC2Controller newController = new EmailSFDC2Controller(new ApexPages.StandardController(newEmail));
		PageReference newPage = new PageReference('/' + account.id);
		System.assertEquals(newPage.getURL(), newController.saveNew().getURL(), 'Incorrect return page on new Email');
		
		// end test
		Test.stopTest();
			
    }
}