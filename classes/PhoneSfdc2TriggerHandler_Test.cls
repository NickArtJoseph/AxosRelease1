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
private class PhoneSfdc2TriggerHandler_Test {

	/** Tests update of primary phone fields when a custom phone object is created */
	@isTest
    static void testPrimaryPhoneUpdate() {
        TriggerValidator.setIsTest();
        
        List<Account> accounts = new List<Account>();
        List<Lead> leads = new List<Lead>();
        
        System.debug('SFDC2.0: Setting up 40 accounts and leads to test update of primary phone fields');
        
        RecordType acctRt = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Business_Consumer_Person_Account' limit 1];
        RecordType leadRt = [select Id from RecordType where SObjectType = 'Lead' and DeveloperName = 'Consumer_Deposits_SFDC2' limit 1];
        
        // Add person accounts with phone numbers populated
        for (Integer i = 0; i<40; i++) {
  			String uniqueLastName = 'Person' + i;
	  		Account acct = new Account(FirstName = 'Test', 
	  							   	   LastName = uniqueLastName, 
	  							   	   SFDC2__c = true,
	  							   	   Phone = '1234567890',
	  							       PersonMobilePhone = '2345678901',
	  							       PersonHomePhone = '6789012345',
	  							       PersonOtherPhone = '3456789012',
	  							       Fax = '4567890123',
	  							       Business_Phone_SFDC2__pc = '5678901234',
	  							       RecordTypeId = acctRt.Id);
			accounts.add(acct);
	  		Lead lead = new Lead(FirstName = 'Test', 
	  							 LastName = uniqueLastName, 
	  							 SFDC2__c = true,
	  							 Phone = '1234567890',
	  							 MobilePhone = '2345678901',
	  							 Fax = '4567890123',
	  							 RecordTypeId = leadRt.Id);
			leads.add(lead);

	  	}
	  	
	  	insert accounts;
	  	insert leads;
	  	
	  	// Add a list of phone objects to each account and lead, set to 'other' (used to test update)
		List<Phone_SFDC2__c> phones1 = new List<Phone_SFDC2__c>();
	  	for (Integer i = 0; i<20; i++) {
			phones1.add(new Phone_SFDC2__c(Account__c = accounts.get(i).Id, Phone__c = '1234567891', Phone_Type__c = 'Other Home'));
			phones1.add(new Phone_SFDC2__c(Account__c = accounts.get(i).Id, Phone__c = '2345678902', Phone_Type__c = 'Other Mobile'));
			phones1.add(new Phone_SFDC2__c(Account__c = accounts.get(i).Id, Phone__c = '3456789013', Phone_Type__c = 'Other Fax'));
			phones1.add(new Phone_SFDC2__c(Account__c = accounts.get(i).Id, Phone__c = '4567890124', Phone_Type__c = 'Other Business'));
			phones1.add(new Phone_SFDC2__c(Lead__c = leads.get(i).Id, Phone__c = '1234567891', Phone_Type__c = 'Other Home'));
			phones1.add(new Phone_SFDC2__c(Lead__c = leads.get(i).Id, Phone__c = '2345678902', Phone_Type__c = 'Other Mobile'));
			phones1.add(new Phone_SFDC2__c(Lead__c = leads.get(i).Id, Phone__c = '3456789013', Phone_Type__c = 'Other Fax'));
	  	}

		insert phones1;
		
		// Update phone objects to be primary
		for (Phone_SFDC2__c phone : phones1) {
			if (phone.Phone_Type__c.equals('Other Home')) phone.Phone_Type__c = 'Primary Home';
			if (phone.Phone_Type__c.equals('Other Mobile')) phone.Phone_Type__c = 'Primary Mobile';
			if (phone.Phone_Type__c.equals('Other Fax')) phone.Phone_Type__c = 'Primary Fax';
			if (phone.Phone_Type__c.equals('Other Business')) phone.Phone_Type__c = 'Primary Business';
		}      

	  	// Add a list of phone objects to each account, set to 'primary' (used to test insert)
		List<Phone_SFDC2__c> phones2 = new List<Phone_SFDC2__c>();
	  	for (Integer i = 20; i<40; i++) {
			phones2.add(new Phone_SFDC2__c(Account__c = accounts.get(i).Id, Phone__c = '1234567891', Phone_Type__c = 'Primary Home'));
			phones2.add(new Phone_SFDC2__c(Account__c = accounts.get(i).Id, Phone__c = '2345678902', Phone_Type__c = 'Primary Mobile'));
			phones2.add(new Phone_SFDC2__c(Account__c = accounts.get(i).Id, Phone__c = '3456789013', Phone_Type__c = 'Primary Fax'));
			phones2.add(new Phone_SFDC2__c(Account__c = accounts.get(i).Id, Phone__c = '4567890124', Phone_Type__c = 'Primary Business'));
			phones2.add(new Phone_SFDC2__c(Lead__c = leads.get(i).Id, Phone__c = '1234567891', Phone_Type__c = 'Primary Home'));
			phones2.add(new Phone_SFDC2__c(Lead__c = leads.get(i).Id, Phone__c = '2345678902', Phone_Type__c = 'Primary Mobile'));
			phones2.add(new Phone_SFDC2__c(Lead__c = leads.get(i).Id, Phone__c = '3456789013', Phone_Type__c = 'Primary Fax'));
	  	}
		
		Test.startTest();
		update phones1; 
		insert phones2;
		Test.stopTest();
		
		accounts = [SELECT Id, Phone, PersonMobilePhone, PersonHomePhone, PersonOtherPhone, Fax, Business_Phone_SFDC2__pc, 
  			(SELECT Phone__c FROM Phones__r WHERE Account__c IN :accounts )
  			FROM Account WHERE Id IN :accounts];

		leads = [SELECT Id, Phone, MobilePhone, Fax, 
  			(SELECT Phone__c FROM Phones__r WHERE Lead__c IN :leads )
  			FROM Lead WHERE Id IN :leads];

		for (Integer i=0; i<40; i++) {
			System.assertEquals('1234567891',accounts.get(i).PersonHomePhone, 'Failed to update account primary home phone.');
			System.assertEquals('2345678902',accounts.get(i).PersonMobilePhone, 'Failed to update account primary mobile phone.');
			System.assertEquals('3456789013',accounts.get(i).Fax, 'Failed to update account primary fax.');
			System.assertEquals('4567890124',accounts.get(i).Business_Phone_SFDC2__pc, 'Failed to update primary business phone.');
			System.assertEquals('1234567891',leads.get(i).Phone, 'Failed to update lead primary home phone.');
			System.assertEquals('2345678902',leads.get(i).MobilePhone, 'Failed to update lead primary mobile phone.');
			System.assertEquals('3456789013',leads.get(i).Fax, 'Failed to update lead primary fax.');
		}
    }
}