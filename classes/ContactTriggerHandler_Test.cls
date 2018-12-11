@isTest
private class ContactTriggerHandler_Test {

  /**
  * Tests the reassignContactOwner method that is triggered in the beforeInsert, beforeUpdate for Contacts
  */
  @isTest
  static void testReassignContactOwner() {
  	//create 2 test users--profiles don't matter at this time
  	User[] testUsers = TestDataFactory.createTestUsers(new Set<String>{'System Administrator','Standard User'});
  	
  	//create a test custom setting for a specific account record type
  	RecordType[] rt = [select Id from RecordType where SobjectType = 'Account' and IsActive = true and IsPersonType = false limit 2];
  	Account_Contact_Owner_Sync__c cs = new Account_Contact_Owner_Sync__c(Name='Test',Account_Record_Type_ID__c=rt[1].Id);
  	insert cs;
  	
  	//create a test business account and set the owner to the first test user
  	Account a1 = TestDataFactory.createTestBusinessAccount();
  	a1.OwnerId = testUsers.get(0).Id;
  	a1.RecordTypeId = rt[0].Id;
  	//create a test business account and set the owner to the second test user, and set record type to the test synch record type
  	Account a2 = TestDataFactory.createTestBusinessAccount();
  	a2.OwnerId = testUsers.get(1).Id;
  	a2.RecordTypeId = rt[1].Id;
  	Account[] accts = new Account[]{a1,a2};
  	insert accts;
  	
  	//create a test contact for the first account and set the owner to the first test user
  	Contact c1 = TestDataFactory.createTestContact(accts[0]);
  	c1.OwnerId = testUsers[0].Id;
  	//create a test contact for the second account and set the owner to the first test user
  	Contact c2 = TestDataFactory.createTestContact(accts[1]);
  	c2.OwnerId = testUsers[0].Id;
  	Contact[] cts = new Contact[]{c1,c2};
  	
  	Test.startTest();
  	insert cts;
  	for(Contact c : [select AccountId, Account.OwnerId, OwnerId from Contact where Id in :cts]) {
  		//ensure that the second contact owner was changed to the account owner
  		if(c.AccountId == accts[1].Id) {
  			System.assertEquals(testUsers[1].Id, c.OwnerId, 'The contact owner was not set to the account owner');
  		}
  	}
  	//attempt to update the second contact's owner--this should not be committed
  	cts[1].OwnerId = testUsers[0].Id;
  	update cts;
  	Test.stopTest();
  	for(Contact c : [select AccountId, Account.OwnerId, OwnerId from Contact where Id in :cts]) {
  		//ensure that the second contact owner is still synched account owner
  		if(c.AccountId == accts[1].Id) {
  			System.assertEquals(testUsers[1].Id, c.OwnerId, 'The contact owner should not have updated');
  		}
  	}
  }
  
  /**
   * SFDC2: Test bulk conversion of Contacts to Person Accounts using the Trigger_Conversion_SFDC2__c flag
   */
 /* @isTest
  static void testBulkContactCoversion() {
  	
  	RecordType contactRT = [select Id from RecordType where SObjectType = 'Contact' and DeveloperName = 'Business_SFDC2' limit 1];
  	RecordType accountRT = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Business_Account_SFDC2' limit 1];

	System.AssertNotEquals(null, contactRT, 'Missing SFDC2 Business Contact Record Type');
	System.AssertNotEquals(null, accountRT, 'Missing SFDC2 Business Account Record Type');

	System.debug('Inserting 20 Accounts with Contacts to test bulk conversion to Hybrid Person Accounts');
	
	List<Account> accts = new List<Account>();
	List<Contact> contacts = new List<Contact>();
	
	for (Integer i=0; i<10; i++) {
		Account acct = new Account(SFDC2__c = true,
	  							   Name = 'Business Test Account' + i,
	  							   RecordTypeId = accountRT.Id);
		accts.add(acct);
	}
	
	insert accts;
	
	for (Integer i=0; i<10; i++) {
		for (Integer j=0; j<10; j++) {
			Contact contact = new Contact(FirstName = 'Business Test',
										  LastName = 'Test Contact ' + i + ' '  + j,
										  AccountId = accts.get(i).Id,
										  RecordTypeId = contactRT.Id);
			if(i<5) contact.Trigger_Conversion_SFDC2__c = true;
			contacts.add(contact);
		}
	}
	
	Test.startTest();
	insert contacts;
	
	List<Contact> unconvertedContacts = [select Id, Trigger_Conversion_SFDC2__c from Contact where Id IN :contacts and IsPersonAccount=false];
	List<Account> convertedAccounts = [select Id from Account where PersonContactId IN :contacts];
	
	System.assertEquals(50, unconvertedContacts.size(), 'Unexpected number of unconverted Contacts after insert');
	System.assertEquals(50, convertedAccounts.size(), 'Unexpected number of converted Accounts after insert');
  	
  	Boolean toggle = true;
  	for (Contact contact : unconvertedContacts) {
  		if (toggle) {
  			contact.Trigger_Conversion_SFDC2__c = true;
  			toggle = false;
  		} else {
  			toggle = true;
  		}
  	}
  	update unconvertedContacts;
	Test.stopTest();
  	
	unconvertedContacts = [select Id, Trigger_Conversion_SFDC2__c from Contact where Id IN :contacts and IsPersonAccount=false];
	convertedAccounts = [select Id from Account where PersonContactId IN :contacts];
	
	System.assertEquals(25, unconvertedContacts.size(), 'Unexpected number of unconverted Contacts after update');
	System.assertEquals(75, convertedAccounts.size(), 'Unexpected number of converted Accounts after update');
  	
  }
  */
    @isTest
    static void testHandleDoNotCallUpdateSFDC2() {
        Id acctRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account SFDC2').getRecordTypeId();
        Id contRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Business SFDC2').getRecordTypeId();
        Id finRTId = Schema.SObjectType.Financial_Account_SFDC2__c.getRecordTypeInfosByName().get('CD').getRecordTypeId();
		
		Account acct = new Account();
		acct.Name = 'Test';
		acct.RecordTypeId = acctRTId;
		insert acct;
		
		Contact c = new Contact();
		c.AccountId = acct.Id;
		c.LastName = 'Test';
		c.RecordTypeId = contRTId;
		c.DoNotCall = false;
		insert c;
		
		Financial_Account_SFDC2__c fa = new Financial_Account_SFDC2__c();
		fa.Name = 'TEST 0000';
		fa.Status__c = 'Active';
		fa.Product_Class__c = 'CD';
		fa.RecordTypeId = finRTId;
		fa.Maturity_Date__c = Date.today().addDays(30);
		insert fa;
		
		Financial_Account_Contact_Link_SFDC2__c link = new Financial_Account_Contact_Link_SFDC2__c();
		link.Financial_Account__c = fa.Id;
		link.Contact__c = c.Id;
		link.CIF_JHA_LINK__c = '30DayCDTEST1111';
		insert link;
		for(CampaignMember cm : [SELECT Campaign.Name, Status FROM CampaignMember WHERE ContactId = :c.Id]) {
			System.assertEquals('Attempting Contact', cm.Status);
			//ensure 30 Day CD Maturity Campaign
			if(cm.ContactId == c.Id) {
				System.assertEquals('30 Day CD Maturity', cm.Campaign.Name);
			}
		}
		
		Test.startTest();
		c.DoNotCall = true;
		update acct;
		Test.stopTest();
		for(CampaignMember cm : [SELECT Campaign.Name, Status FROM CampaignMember WHERE ContactId = :c.Id]) {
			System.assertEquals('Expired', cm.Status);
			//ensure 30 Day CD Maturity Campaign
			if(cm.ContactId == c.Id) {
				System.assertEquals('30 Day CD Maturity', cm.Campaign.Name);
			}
		}
    }
}