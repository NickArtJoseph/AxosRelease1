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
private class AddressSfdc2TriggerHandler_Test {

	/** Test update primary address */
	@isTest
    static void testPrimaryAddressUpdate() {
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
	  							   PersonMailingStreet = '123 Main Street', 
  							   	   PersonMailingCity = 'Springfield', 
  							   	   PersonMailingCountry = 'USA', 
  							   	   PersonMailingState = 'MA', 
  							   	   PersonMailingPostalCode = '12345',
  							   	   Mailing_Mortgage_Lender_SFDC2__pc = 'Nationwide',
  							   	   Mailing_Loan_Type_SFDC2__pc = '35 year fixed',
  							   	   Mailing_Purchase_Amount_SFDC2__pc = 250000.00);
        	} else {
  				String uniqueCompanyName = 'Company' + i;
	  			acct = new Account(RecordTypeId = businessAccountRecordType.Id,
								   Name = uniqueCompanyName,
	  							   SFDC2__c = true,
		  						   BillingStreet = '123 Main Street', 
	  							   BillingCity = 'Springfield', 
	  							   BillingCountry = 'USA', 
	  							   BillingState = 'MA', 
	  							   BillingPostalCode = '12345',
	  							   Billing_Mortgage_Lender_SFDC2__c = 'Nationwide',
	  							   Billing_Loan_Type_SFDC2__c = '35 year fixed',
	  							   Billing_Purchase_Amount_SFDC2__c = 250000.00);
        	}					  
			accounts.add(acct);
  			String uniqueLastName = 'Person' + i;
	  		Lead lead = new Lead(RecordTypeId = leadRecordType.Id,
                				 FirstName = 'Test', 
	  							 LastName = uniqueLastName, 
	  							 SFDC2__c = true,
	  							 Street = '123 Main Street', 
  							   	 City = 'Springfield', 
  							   	 Country = 'USA', 
  							   	 State = 'MA', 
  							   	 PostalCode = '12345',
  							   	 Primary_Mortgage_Lender_SFDC2__c = 'Nationwide',
  							   	 Primary_Loan_Type_SFDC2__c = '35 year fixed',
  							   	 Primary_Purchase_Amount_SFDC2__c = 250000.00);
			leads.add(lead);
	  	}
	  	
	  	insert accounts;
	  	insert leads;
	  	
	  	// Add a list of address objects to each account and lead, set to 'other' (used to test update)
		List<Address_SFDC2__c> addrs1 = new List<Address_SFDC2__c>();
	  	for (Integer i = 0; i<20; i++) {
			addrs1.add(new Address_SFDC2__c(Account__c = accounts.get(i).Id, 
										   Address_Type__c = 'Other',
							  			   Street__c = '789 Main Street',
							  			   City__c = 'Hartford',
							  			   Country__c = 'USA',
							  			   State__c = 'CT',
							  			   Postal_Code__c = '54321',
							  			   Mortgage_Lender__c = 'Other Bank 1',
							  			   Loan_Type__c = '50 year variable',
							  			   Purchase_Amount__c = 376500.00));
			addrs1.add(new Address_SFDC2__c(Lead__c = leads.get(i).Id, 
										   Address_Type__c = 'Other',
							  			   Street__c = '789 Main Street',
							  			   City__c = 'Hartford',
							  			   Country__c = 'USA',
							  			   State__c = 'CT',
							  			   Postal_Code__c = '54321',
							  			   Mortgage_Lender__c = 'Other Bank 1',
							  			   Loan_Type__c = '50 year variable',
							  			   Purchase_Amount__c = 376500.00));
	  	}

		insert addrs1;
		
		// Update address objects to be primary
		for (Address_SFDC2__c addr : addrs1) {
			addr.Address_Type__c = 'Primary';
		}      

	  	// Add a list of address objects to each account and lead, set to 'primary' (used to test insert)
		List<Address_SFDC2__c> addrs2 = new List<Address_SFDC2__c>();
	  	for (Integer i = 20; i<40; i++) {
			addrs2.add(new Address_SFDC2__c(Account__c = accounts.get(i).Id, 
										   Address_Type__c = 'Primary',
							  			   Street__c = '789 Main Street',
							  			   City__c = 'Hartford',
							  			   Country__c = 'USA',
							  			   State__c = 'CT',
							  			   Postal_Code__c = '54321',
							  			   Mortgage_Lender__c = 'Other Bank 1',
							  			   Loan_Type__c = '50 year variable',
							  			   Purchase_Amount__c = 376500.00));
			addrs2.add(new Address_SFDC2__c(Lead__c = leads.get(i).Id, 
										   Address_Type__c = 'Primary',
							  			   Street__c = '789 Main Street',
							  			   City__c = 'Hartford',
							  			   Country__c = 'USA',
							  			   State__c = 'CT',
							  			   Postal_Code__c = '54321',
							  			   Mortgage_Lender__c = 'Other Bank 1',
							  			   Loan_Type__c = '50 year variable',
							  			   Purchase_Amount__c = 376500.00));
	  	}
		
		Test.startTest();
		update addrs1; 
		insert addrs2;
		Test.stopTest();
		
		accounts = [SELECT Id, PersonMailingStreet, PersonMailingCity, PersonMailingState, PersonMailingCountry, PersonMailingPostalCode,
		            Mailing_Mortgage_Lender_SFDC2__pc, Mailing_Loan_Type_SFDC2__pc, Mailing_Purchase_Amount_SFDC2__pc,
		            BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode, Billing_Mortgage_Lender_SFDC2__c,
		            Billing_Loan_Type_SFDC2__c, Billing_Purchase_Amount_SFDC2__c
  					FROM Account WHERE Id IN :accounts];

		leads = [SELECT Id, Street, City, State, Country, PostalCode,
		            Primary_Mortgage_Lender_SFDC2__c, Primary_Loan_Type_SFDC2__c, Primary_Purchase_Amount_SFDC2__c
  					FROM Lead WHERE Id IN :leads];

		for (Integer i=0; i<40; i++) {
			if (math.mod(i, 20) < 10) {
				System.assertEquals('789 Main Street',	accounts.get(i).PersonMailingStreet, 	'Failed to update primary personal street address.');
				System.assertEquals('Hartford',			accounts.get(i).PersonMailingCity, 		'Failed to update primary personal city.');
				System.assertEquals('USA',				accounts.get(i).PersonMailingCountry, 	'Failed to update primary personal country.');
				System.assertEquals('CT',				accounts.get(i).PersonMailingState, 	'Failed to update primary personal state.');
				System.assertEquals('54321',			accounts.get(i).PersonMailingPostalCode,'Failed to update primary personal postal code.');
				System.assertEquals('Other Bank 1',		accounts.get(i).Mailing_Mortgage_Lender_SFDC2__pc,	'Failed to update primary personal mortgage lender.');
				System.assertEquals('50 year variable',	accounts.get(i).Mailing_Loan_Type_SFDC2__pc,		'Failed to update primary personal loan type.');
				System.assertEquals(376500.00,			accounts.get(i).Mailing_Purchase_Amount_SFDC2__pc,	'Failed to update primary personal purchase amount.');
			} else {
				System.assertEquals('789 Main Street',	accounts.get(i).BillingStreet, 			'Failed to update primary business street address.');
				System.assertEquals('Hartford',			accounts.get(i).BillingCity, 			'Failed to update primary business city.');
				System.assertEquals('USA',				accounts.get(i).BillingCountry, 		'Failed to update primary business country.');
				System.assertEquals('CT',				accounts.get(i).BillingState, 			'Failed to update primary business state.');
				System.assertEquals('54321',			accounts.get(i).BillingPostalCode,		'Failed to update primary business postal code.');
				System.assertEquals('Other Bank 1',		accounts.get(i).Billing_Mortgage_Lender_SFDC2__c,	'Failed to update primary business mortgage lender.');
				System.assertEquals('50 year variable',	accounts.get(i).Billing_Loan_Type_SFDC2__c,			'Failed to update primary business loan type.');
				System.assertEquals(376500.00,			accounts.get(i).Billing_Purchase_Amount_SFDC2__c,	'Failed to update primary business purchase amount.');				
			}
			System.assertEquals('789 Main Street',	leads.get(i).Street, 	'Failed to update Lead primary personal street address.');
			System.assertEquals('Hartford',			leads.get(i).City, 		'Failed to update Lead primary personal city.');
			System.assertEquals('USA',				leads.get(i).Country, 	'Failed to update Lead primary personal country.');
			System.assertEquals('CT',				leads.get(i).State, 	'Failed to update Lead primary personal state.');
			System.assertEquals('54321',			leads.get(i).PostalCode,'Failed to update Lead primary personal postal code.');
			System.assertEquals('Other Bank 1',		leads.get(i).Primary_Mortgage_Lender_SFDC2__c,	'Failed to update Lead primary personal mortgage lender.');
			System.assertEquals('50 year variable',	leads.get(i).Primary_Loan_Type_SFDC2__c,		'Failed to update Lead primary personal loan type.');
			System.assertEquals(376500.00,			leads.get(i).Primary_Purchase_Amount_SFDC2__c,	'Failed to update Leadprimary personal purchase amount.');
		}
		     
    }
}