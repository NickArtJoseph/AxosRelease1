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
private class AddressSFDC2Controller_Test {

    static testMethod void addressTest() {
		
		// set up test data
    	Account account = new Account(name='test');
    	Lead lead = new Lead(FirstName='testFirst', LastName='testLast');
    	insert account;
    	insert lead;
		Address_SFDC2__c acctAddress = new Address_SFDC2__c(Account__c=account.id, Street__c='123 Main Street', Address_Type__c='Other');
		Address_SFDC2__c leadAddress = new Address_SFDC2__c(Lead__c=lead.id, Street__c='123 Main Street', Address_Type__c='Other');
		insert acctAddress;
		insert leadAddress;
		        
		// start test
		Test.startTest();
		
		// test save page
		Test.setCurrentPage(Page.AddressSFDC2Save);

		AddressSFDC2Controller acctSaveController = new AddressSFDC2Controller(new ApexPages.StandardController(acctAddress));
		PageReference acctSavePage = acctSaveController.getViewPage(acctAddress, 'AddressSFDC2View');
		System.assertEquals(acctSavePage.getURL(), acctSaveController.onSave().getURL(), 'Unexpected after-save page reference for Account Address');

		AddressSFDC2Controller leadSaveController = new AddressSFDC2Controller(new ApexPages.StandardController(leadAddress));
		PageReference leadSavePage = leadSaveController.getViewPage(leadAddress, 'AddressSFDC2View');
		System.assertEquals(leadSavePage.getURL(), leadSaveController.onSave().getURL(), 'Unexpected after-save page reference for Lead Address');
		
		// test view page
		Test.setCurrentPage(Page.AddressSFDC2View);

		AddressSFDC2Controller acctViewController = new AddressSFDC2Controller(new ApexPages.StandardController(acctAddress));
		PageReference acctEditPage = acctViewController.getEditPage(acctAddress, 'AddressSFDC2Save', 'AddressSFDC2View', account.id);
		System.assertEquals(acctEditPage.getURL(), acctViewController.onEdit().getURL(), 'Unexpected edit page reference for Account Address');

		AddressSFDC2Controller leadViewController = new AddressSFDC2Controller(new ApexPages.StandardController(leadAddress));
		PageReference leadEditPage = leadViewController.getEditPage(leadAddress, 'AddressSFDC2Save', 'AddressSFDC2View', lead.id);
		System.assertEquals(leadEditPage.getURL(), leadViewController.onEdit().getURL(), 'Unexpected edit page reference for Lead Address');

		// test new page
		PageReference origPage = Page.AddressSFDC2New;
		origPage.getParameters().put('retURL','/' + account.id);
		Test.setCurrentPageReference(origPage);
		
		Address_SFDC2__c newAddress = new Address_SFDC2__c(Account__c=account.id, Street__c='123 Main Street', Address_Type__c='Other');
		AddressSFDC2Controller newController = new AddressSFDC2Controller(new ApexPages.StandardController(newAddress));
		PageReference newPage = new PageReference('/' + account.id);
		System.assertEquals(newPage.getURL(), newController.saveNew().getURL(), 'Incorrect return page on new Address');
		
		// end test
		Test.stopTest();
			
    }
}