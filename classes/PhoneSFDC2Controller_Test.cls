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
private class PhoneSFDC2Controller_Test {

    static testMethod void phoneTest() {
		
		// set up test data
    	Account account = new Account(name='test');
    	Lead lead = new Lead(FirstName='testFirst', LastName='testLast');
    	insert account;
    	insert lead;
		Phone_SFDC2__c acctPhone = new Phone_SFDC2__c(Account__c=account.id, Phone__c='(987) 654-3210');
		Phone_SFDC2__c leadPhone = new Phone_SFDC2__c(Lead__c=lead.id, Phone__c='(987) 654-3210');
		insert acctPhone;
		insert leadPhone;
		        
		// start test
		Test.startTest();
		
		// test save page
		Test.setCurrentPage(Page.PhoneSFDC2Save);

		PhoneSFDC2Controller acctSaveController = new PhoneSFDC2Controller(new ApexPages.StandardController(acctPhone));
		PageReference acctSavePage = acctSaveController.getViewPage(acctPhone, 'PhoneSFDC2View');
		System.assertEquals(acctSavePage.getURL(), acctSaveController.onSave().getURL(), 'Unexpected after-save page reference for Account Phone');

		PhoneSFDC2Controller leadSaveController = new PhoneSFDC2Controller(new ApexPages.StandardController(leadPhone));
		PageReference leadSavePage = leadSaveController.getViewPage(leadPhone, 'PhoneSFDC2View');
		System.assertEquals(leadSavePage.getURL(), leadSaveController.onSave().getURL(), 'Unexpected after-save page reference for Lead Phone');
		
		// test view page
		Test.setCurrentPage(Page.PhoneSFDC2View);

		PhoneSFDC2Controller acctViewController = new PhoneSFDC2Controller(new ApexPages.StandardController(acctPhone));
		PageReference acctEditPage = acctViewController.getEditPage(acctPhone, 'PhoneSFDC2Save', 'PhoneSFDC2View', account.id);
		System.assertEquals(acctEditPage.getURL(), acctViewController.onEdit().getURL(), 'Unexpected edit page reference for Account Phone');

		PhoneSFDC2Controller leadViewController = new PhoneSFDC2Controller(new ApexPages.StandardController(leadPhone));
		PageReference leadEditPage = leadViewController.getEditPage(leadPhone, 'PhoneSFDC2Save', 'PhoneSFDC2View', lead.id);
		System.assertEquals(leadEditPage.getURL(), leadViewController.onEdit().getURL(), 'Unexpected edit page reference for Lead Phone');

		// test new page
		PageReference origPage = Page.PhoneSFDC2New;
		origPage.getParameters().put('retURL','/' + account.id);
		Test.setCurrentPageReference(origPage);
		
		Phone_SFDC2__c newPhone = new Phone_SFDC2__c(Phone__c='(987) 654-3210');
		PhoneSFDC2Controller newController = new PhoneSFDC2Controller(new ApexPages.StandardController(newPhone));
		PageReference newPage = new PageReference('/' + account.id);
		System.assertEquals(newPage.getURL(), newController.saveNew().getURL(), 'Incorrect return page on new Phone');
		
		// end test
		Test.stopTest();
			
    }
}