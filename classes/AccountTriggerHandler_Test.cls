@isTest
private class AccountTriggerHandler_Test {

  /**
  * Tests the reassignContactOwners method that is triggered in the afterUpdate for Accounts
  */
  @isTest
  static void testReassignContactOwners() {
    TriggerValidator.setIsTest();
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
    //create a test contact for the second account and set the owner to the second test user
    Contact c2 = TestDataFactory.createTestContact(accts[1]);
    c2.OwnerId = testUsers[1].Id;
    Contact[] cts = new Contact[]{c1,c2};
    insert cts;
    
    //switch ownership for the two test accounts
    Test.startTest();
    accts[0].OwnerId = testUsers[1].Id;
    accts[1].OwnerId = testUsers[0].Id;
    update accts;
    Test.stopTest();
    
    //verify appropriate contact ownership changes
    accts = [select OwnerId from Account where Id in :accts];
    for(Contact c : [select AccountId, OwnerId from Contact where AccountId in :accts]) {
        if(c.AccountId == accts[0].Id) {
            //the first account contact should not have an ownership change
            //System.assertNotEquals(accts[0].OwnerId, c.OwnerId, 'Non-synching Account inappropriately had Contact ownership change');
        } else if(c.AccountId == accts[1].Id) {
            //the second account contact should have an ownership change
            System.assertEquals(accts[1].OwnerId, c.OwnerId, 'Synching Account did not have Contact ownership change');
        }
    }
  }

  /**
  * Tests the checkSpecFinOwnerChange method that is triggered beforeUpdate for Accounts
  */
  @isTest
  static void testCheckSpecFinOwnerChange() {
    TriggerValidator.setIsTest();
    //create a new Account record
    Account acc = new Account(Name='Test');
    
    Test.startTest();
    insert acc;
    acc = [Select Id, Name, Send_Owner_Change_Notification__c from Account where Id = :acc.Id];
    System.assertEquals(false, acc.Send_Owner_Change_Notification__c, 'Send Owner Change Notification should not be set to true on account creation');
    
    //establish test users based on the flagged profiles that trigger the field update
    List<User> userList = TestDataFactory.createTestUsers(AccountTriggerHandler.flaggedSpecFinProfiles);
    
    //test 1: as admin, change owner to one of the flagged profile users; this should not cause a field update
    acc.OwnerId = userList.get(0).Id;
    update acc;
    acc = [Select Id, Name, Send_Owner_Change_Notification__c from Account where Id = :acc.Id];
    System.assertEquals(false, acc.Send_Owner_Change_Notification__c, 'Send Owner Change Notification should not be set to true when modified by non-flagged profiles');
    
    //test 2: run as a flagged profile and modify owner; this should cause a field update
    System.runAs(userList.get(0)) {
        acc.OwnerId = userList.get(1).Id;
        update acc;
    }
    acc = [Select Id, Name, Send_Owner_Change_Notification__c from Account where Id = :acc.Id];
    System.assertEquals(true, acc.Send_Owner_Change_Notification__c, 'Send Owner Change Notification should be set to true when modified by flagged profiles');
    
    Test.stopTest();
  }
  
  /**
  * Tests the capturePriorOwner method that is triggered beforeUpdate for Accounts
  */
  @isTest
  static void testCapturePriorOwner() {
    TriggerValidator.setIsTest();
    //create a new Account record
    Account acc = new Account(Name='Test');
    insert acc;
    
    acc = [Select Id, OwnerId, Prior_Owner__c From Account Where Id = :acc.Id];
    System.assertNotEquals(null, acc.OwnerId, 'Test account owner is null');
    System.assertEquals(null, acc.Prior_Owner__c, 'Test account prior owner is not null');
    
    //establish test users
    List<User> userList = TestDataFactory.createTestUsers(AccountTriggerHandler.flaggedSpecFinProfiles);
    
    Id preTestOwnerId = acc.OwnerId;
    Test.startTest();
    acc.OwnerId = userList.get(0).Id;
    update acc;
    Test.stopTest();
    
    acc = [Select Id, OwnerId, Prior_Owner__c From Account Where Id = :acc.Id];
    
    System.assertEquals(userList.get(0).Id, acc.OwnerId, 'Owner was not updated');
    System.assertEquals(preTestOwnerId, acc.Prior_Owner__c, 'Prior Owner was not updated');
  }
  
  /** Tests the updateLexisNexisCalloutStatus method for inserts */
  @isTest
  static void testUpdateLexisNexisCalloutStatus_Insert() {
    TriggerValidator.setIsTest();
    List<Id> rtIdList = new List<Id>(); 
    rtIdList.addAll(AccountTriggerHandler.lxnxSpecFinRTIdSet);
    Id sfRTid = rtIdList[0];
    
    Account sfAcc = TestDataFactory.createTestPersonAccount();
    sfAcc.RecordTypeId = sfRTid;
    sfAcc.Social_Security_Number_Person__c = '999-99-9999';
    sfAcc.Research_Status_Person__c = 'New Unresearched';
    
    Account nonSfAcc = TestDataFactory.createTestPersonAccount();
    nonSfAcc.Social_Security_Number_Person__c = '999-99-9999';
    nonSfAcc.Research_Status_Person__c = 'New Researched';
    
    Account[] accts = new List<Account>{sfAcc, nonSfAcc};
    
    try {
        Test.startTest();
        insert accts;
        Test.stopTest();
    } catch (DMLException de) {Test.stopTest();}
    
    Id nonSfAccId = accts[1].Id;
    for(Account acc : [SELECT Id, SF_LexisNexis_Callout_Status__c FROM Account WHERE Id in :accts]) {
        if(acc.Id == accts[0].Id) {
            System.assertEquals('Queued', acc.SF_LexisNexis_Callout_Status__c);
        } else if (acc.Id == accts[1].Id) {
            System.assertNotEquals('Queued', acc.SF_LexisNexis_Callout_Status__c);
        }
    }
    
  }
  
  /** Tests the updateLexisNexisCalloutStatus method for updates */
  @isTest
  static void testUpdateLexisNexisCalloutStatus_Update() {
    TriggerValidator.setIsTest();
    List<Id> rtIdList = new List<Id>(); 
    rtIdList.addAll(AccountTriggerHandler.lxnxSpecFinRTIdSet);
    Id sfRTid = rtIdList[0];
    
    Account nonSfAcc = TestDataFactory.createTestPersonAccount();
    nonSfAcc.RecordTypeId = sfRTId;
    nonSfAcc.Social_Security_Number_Person__c = '999-99-9999';
    nonSfAcc.Research_Status_Person__c = 'Hard to Find';
    
    insert nonSfAcc;
    
    nonSfAcc.Research_Status_Person__c = 'Needs Research';
    
    try {
        Test.startTest();
        update nonSfAcc;
        Test.stopTest();
    } catch (DMLException de) {Test.stopTest();}
    
    for(Account acc : [SELECT Id, SF_LexisNexis_Callout_Status__c FROM Account WHERE Id = :nonSfAcc.Id]) {
        System.assertEquals('Queued', acc.SF_LexisNexis_Callout_Status__c);
    }
  }
  
  /** Tests the triggerUpdateSFNeustarCallout method for updates */
  @isTest
  static void testTriggerUpdateSFNeustarCallout() {
    TriggerValidator.setIsTest();
    List<Id> rtIdList = new List<Id>(); 
    rtIdList.addAll(AccountTriggerHandler.neustarSpecFinRTIdSet);
    Id sfRTid = rtIdList[0];
    
    Account sfAcc = TestDataFactory.createTestPersonAccount();
    sfAcc.RecordTypeId = sfRTId;
    sfAcc.OwnerId = AccountTriggerHandler.SF_OUTBOUNDOWNERID;
    sfAcc.Research_Status_Person__c = '';
    
    insert sfAcc;
    
    Phone_Number__c phone = new Phone_Number__c();
    phone.Account_Name__c = sfAcc.Id;
    phone.Phone_Number__c = '5555551212';
    insert phone;
    
    sfAcc.Research_Status_Person__c = 'New Researched';
    
    try {
        Test.startTest();
        update sfAcc;
        Test.stopTest();
    } catch (DMLException de) {Test.stopTest();}
    
    Webservice_Callout__c[] callout = [SELECT ID FROM Webservice_Callout__c WHERE Account__c = :sfAcc.Id AND Job_Name__c = 'NeustarQueueableJob'];
    sfAcc = [SELECT Id, Owner.Name, Research_Status_Person__c, RecordType.Name FROM Account WHERE Id = :sfAcc.Id];
    System.debug(sfAcc);
    System.assert(callout.size() > 0);
  }
  
  /** Tests the handleManualNeustarTrigger method for updates */
  @isTest
  static void testHandleManualNeustarTrigger() {
    TriggerValidator.setIsTest();
    List<Id> rtIdList = new List<Id>(); 
    rtIdList.addAll(AccountTriggerHandler.neustarSpecFinRTIdSet);
    Id sfRTid = rtIdList[0];
    
    Account sfAcc = TestDataFactory.createTestPersonAccount();
    sfAcc.RecordTypeId = sfRTId;
    sfAcc.Research_Status_Person__c = '';
    
    insert sfAcc;
    
    Phone_Number__c phone = new Phone_Number__c();
    phone.Account_Name__c = sfAcc.Id;
    phone.Phone_Number__c = '5555551212';
    insert phone;
    
    sfAcc.Neustar_Trigger__c = true;
    
    try {
        Test.startTest();
        update sfAcc;
        Test.stopTest();
    } catch (DMLException de) {Test.stopTest();}
    finally {}
    
    Webservice_Callout__c[] callout = [SELECT ID FROM Webservice_Callout__c WHERE Account__c = :sfAcc.Id AND Job_Name__c = 'NeustarQueueableJob'];
    sfAcc = [SELECT Id, Owner.Name, Research_Status_Person__c, RecordType.Name FROM Account WHERE Id = :sfAcc.Id];
    System.debug(sfAcc);
    System.assert(callout.size() > 0);
  }
  
  /** 
  * SFDC 2.0: Tests the restriction of editing Accounts if the user is not an open Opp owner
  * or a System Admin
  */
  @isTest
  static void testRestrictSFDC2AccountUpdates() {
  	User[] testUsers = TestDataFactory.createTestUsers(new Set<String>{'Enterprise User', 'API Service Account'});
  	User runUser;
  	User apiUser;
  	for(User u : [SELECT LastName FROM User WHERE Id = :testUsers]) {
  		if(u.LastName.contains('Enterprise User')) {
  			runUser = u;
  		} else if (u.LastName.contains('API Service Account')) {
  			apiUser = u;
  		}
  	}
  	System.debug(runUser);
  	System.assertNotEquals(null, runUser, 'Unable to create test Enterprise User');
  	System.assertNotEquals(null, apiUser, 'Unable to create test API User');
  	Account editAccount = new Account();
  	editAccount.SFDC2__c = true;
  	editAccount.Name = 'Test1';
  	editAccount.OwnerId = apiUser.Id;
  	Account lock1Account = new Account();
  	lock1Account.SFDC2__c = true;
  	lock1Account.Name = 'Test2';
  	lock1Account.OwnerId = apiUser.Id;
  	Account lock2Account = new Account();
  	lock2Account.SFDC2__c = true;
  	lock2Account.Name = 'Test3';
  	lock2Account.OwnerId = apiUser.Id;
  	Account[] accts = new List<Account>{editAccount, lock1Account, lock2Account};
  	insert accts;
  	
  	RecordType[] rt = [SELECT Id FROM RecordType WHERE SObjectType='Opportunity' AND IsActive = true AND Description = 'SFDC2' limit 1];
  	System.assert(rt.size() > 0, 'Unable to locate SFDC2 Opportunity record type');
	
  	Opportunity openOpp = new Opportunity();
  	openOpp.Name = 'Test1';
  	openOpp.RecordTypeId = rt[0].Id;
  	openOpp.StageName = '1 - New';
  	openOpp.CloseDate = Date.today();
  	openOpp.AccountId = accts[1].Id;
  	openOpp.OwnerId = runUser.Id;
  	Opportunity closed1Opp = new Opportunity();
  	closed1Opp.Name = 'Test2';
  	closed1Opp.RecordTypeId = rt[0].Id;
  	closed1Opp.StageName = '0 - Closed - Lost';
  	closed1Opp.CloseDate = Date.today();
  	closed1Opp.AccountId = accts[1].Id;
  	closed1Opp.OwnerId = runUser.Id;
  	Opportunity closed2Opp = new Opportunity();
  	closed2Opp.Name = 'Test3';
  	closed2Opp.RecordTypeId = rt[0].Id;
  	closed2Opp.StageName = '1 - New';
  	closed2Opp.CloseDate = Date.today();
  	closed2Opp.AccountId = accts[2].Id;
  	closed2Opp.OwnerId = apiUser.Id;
  	Opportunity[] opps = new List<Opportunity>{openOpp, closed1Opp, closed2Opp};
  	insert opps;
  	
  	Test.startTest();
  	System.runAs(runUser){
  		accts[0].Name = 'TestGood';
  		accts[1].Name = 'TestBad';
  		accts[2].Name = 'TestBad';
  		Database.SaveResult[] srList = Database.update(accts, false);
  		for(Database.SaveResult sr : srList) {
  			if(sr.getId() == accts[0].Id) {
  				System.assert(sr.isSuccess(), 'Did not update Account that should have been editable');
  			} else {
  				System.assert(!sr.isSuccess(), 'Wrongly updated a locked Account');
  			}
  		}
  	}
  	Test.stopTest();
  }
  
  /** Tests creation of custom Phone objects on Account phone field modification */
  @isTest
  static void testUpdatePhoneListSfdc2() {
  	TriggerValidator.setIsTest();

	List<Account> accts1 = new List<Account>();
	List<Account> accts2 = new List<Account>();
  	
	RecordType acctRt = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Business_Consumer_Person_Account' limit 1];
    RecordType phoneRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Phone_SFDC2__c' AND Name = 'Account Phone'];

  	System.debug('Inserting two sets of 20 accounts to test Phone object creation.');
  	
  	// Create set of test person accounts with phone number fields populated
  	for (Integer i=0; i<40; i++) {
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
	  	if (i<20) {
	  		accts1.add(acct);
	  	} else {
	  		accts2.add(acct);
	  	}
  	}
  	insert accts1;
  	insert accts2;
  	
  	for (Account acct: accts1) {
  		System.assertEquals(true, acct.SFDC2__c, 'Test Account lost SFDC2 status in set 1.');
  	}
  	for (Account acct: accts2) {
  		System.assertEquals(true, acct.SFDC2__c, 'Test Account lost SFDC2 status in set 2.');
  	}

  	// Add a set of Phone objects to the first account in the list
  	List<Phone_SFDC2__c> phones = new List<Phone_SFDC2__c>();
  	for (Integer i=0; i<6; i++) {
  		Phone_SFDC2__c phone = new Phone_SFDC2__c(Account__c = accts1.get(0).Id, RecordTypeId = phoneRecordType.Id);
  		if (i==0) phone.Phone__c = '7654321098';
  		if (i==1) phone.Phone__c = '1098765432';
  		if (i==2) phone.Phone__c = '2109876543';
  		if (i==3) phone.Phone__c = '3210987654';
  		if (i==4) phone.Phone__c = '4321098765';
  		if (i==5) phone.Phone__c = '5432109876';
		phones.add(phone);
  	}
  	insert phones;
  	
  	// Modify each phone field to hold a new value in the first 10 accounts.
  	// (For the first account, these numbers will already exist as Phone objects.)
  	// After the update, these accounts should have five Phone objects corresponding to
  	//   the original phone field values.
  	for (Integer i=0; i<20; i++) {  	
	  	accts1.get(i).Phone = '7654321098';
	  	accts1.get(i).PersonMobilePhone = '1098765432';
	  	accts1.get(i).PersonHomePhone = '5432109876';
	  	accts1.get(i).PersonOtherPhone = '2109876543';
	  	accts1.get(i).Fax = '3210987654';
	  	accts1.get(i).Business_Phone_SFDC2__pc = '4321098765';
  	}

  	// Modify each phone field to hold a value previously held by another phone field in the remaining accounts.
  	// After the update these accounts should have no Phone objects.
  	for (Integer i=0; i<20; i++) {  	
	  	accts2.get(i).Phone = '6789012345';
	  	accts2.get(i).PersonMobilePhone = '1234567890';
	  	accts2.get(i).PersonHomePhone = '5678901234';
	  	accts2.get(i).PersonOtherPhone = '2345678901';
	  	accts2.get(i).Fax = '3456789012';
	  	accts2.get(i).Business_Phone_SFDC2__pc = '4567890123';
  	}
  	
  	Test.startTest();
  	update accts1;
  	update accts2;
  	Test.stopTest();
  	
  	accts1 = [SELECT Id, Phone, PersonMobilePhone, PersonHomePhone, PersonOtherPhone, Fax, Business_Phone_SFDC2__pc, 
  			(SELECT Phone__c FROM Phones__r WHERE Account__c IN :accts1 )
  			FROM Account WHERE Id IN :accts1];

  	accts2 = [SELECT Id, Phone, PersonMobilePhone, PersonHomePhone, PersonOtherPhone, Fax, Business_Phone_SFDC2__pc, 
  			(SELECT Phone__c FROM Phones__r WHERE Account__c IN :accts2)
  			FROM Account WHERE Id IN :accts2];

	// Assert that the correct number of Phone objects exist for each Account.
	for (Integer i=0; i<20; i++) {
		System.assertEquals(6, accts1.get(i).Phones__r.size(), 'Incorrect number of Phone objects for first account set.');
		System.assertEquals(0, accts2.get(i).Phones__r.size(), 'Incorrect number of Phone objects for second account set.');
	}
  	
  }
  
  /** Tests creation of custom Email objects on Account email field modification */
  @isTest
  static void testUpdateEmailListSfdc2() {
  	TriggerValidator.setIsTest();

    RecordType personAccountRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Business/Consumer Person Account'];
    RecordType emailRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Email_SFDC2__c' AND Name = 'Account Email'];

	List<Account> accts1 = new List<Account>();
	List<Account> accts2 = new List<Account>();
  	
  	System.debug('Inserting two sets of 20 accounts to test Email object creation.');
  	
  	// Create set of test person accounts with email address fields populated
  	for (Integer i=0; i<40; i++) {
  		String uniqueLastName = 'Person' + i;
	  	Account acct = new Account(FirstName = 'Test', 
	  							   LastName = uniqueLastName, 
	  							   SFDC2__c = true,
	  							   PersonEmail = 'test1@test.com',
	  							   Business_Email_SFDC2__pc = 'test2@test.com',
	  							   RecordTypeId = personAccountRecordType.Id);
	  	if (i<20) {
	  		accts1.add(acct);
	  	} else {
	  		accts2.add(acct);
	  	}
  	}
  	insert accts1;
  	insert accts2;
  	
  	for (Account acct: accts1) {
  		System.assertEquals(true, acct.SFDC2__c, 'Test Account lost SFDC2 status in set 1.');
  	}
  	for (Account acct: accts2) {
  		System.assertEquals(true, acct.SFDC2__c, 'Test Account lost SFDC2 status in set 2.');
  	}

  	// Add a set of Email objects to the first account in the list
  	List<Email_SFDC2__c> emails = new List<Email_SFDC2__c>();
  	for (Integer i=0; i<2; i++) {
  		Email_SFDC2__c email = new Email_SFDC2__c(Account__c = accts1.get(0).Id, RecordTypeId = emailRecordType.Id);
  		if (i==0) email.Email__c = 'test3@test.com';
  		if (i==1) email.Email__c = 'test4@test.com';
  		email.Email_Type__c = 'Other Personal';
		emails.add(email);
  	}
  	insert emails;
  	
  	// Modify each email field to hold a new value in the first 10 accounts.
  	// (For the first account, these emails will already exist as Email objects.)
  	// After the update, these accounts should have two Email objects corresponding to
  	//   the original email field values.
  	for (Integer i=0; i<20; i++) {  	
	  	accts1.get(i).PersonEmail = 'test3@test.com';
	  	accts1.get(i).Business_Email_SFDC2__pc= 'test4@test.com';
  	}

  	// Modify each email field to hold a value previously held by another email field in the remaining accounts.
  	// After the update these accounts should have no Email objects.
  	for (Integer i=0; i<20; i++) {  	
	  	accts2.get(i).PersonEmail = 'test2@test.com';
	  	accts2.get(i).Business_Email_SFDC2__pc= 'test1@test.com';
  	}
  	
  	Test.startTest();
  	update accts1;
  	update accts2;
  	Test.stopTest();
  	
  	accts1 = [SELECT Id, PersonEmail, Business_Email_SFDC2__pc, 
  			(SELECT Email__c FROM Email_Addresses__r WHERE Account__c IN :accts1 )
  			FROM Account WHERE Id IN :accts1];

  	accts2 = [SELECT Id, PersonEmail, Business_Email_SFDC2__pc, 
  			(SELECT Email__c FROM Email_Addresses__r WHERE Account__c IN :accts2)
  			FROM Account WHERE Id IN :accts2];

	// Assert that the correct number of Email objects exist for each Account.
	for (Integer i=0; i<20; i++) {
		System.assertEquals(2, accts1.get(i).Email_Addresses__r.size(), 'Incorrect number of Email objects for first account set.');
		System.assertEquals(0, accts2.get(i).Email_Addresses__r.size(), 'Incorrect number of Email objects for second account set.');
	}
  	
  }

  /** Tests creation of custom Address objects on Account address field modification */
  @isTest
  static void testUpdateAddressListSfdc2() {
  	TriggerValidator.setIsTest();

	List<Account> accts1 = new List<Account>();
	List<Account> accts2 = new List<Account>();
  	
  	System.debug('Inserting two sets of 20 accounts to test Address object creation.');
  	
    RecordType personAccountRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Business/Consumer Person Account'];
    RecordType addressRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Address_SFDC2__c' AND Name = 'Account Address'];
  	
  	// Create set of test person accounts with address fields populated
  	for (Integer i=0; i<40; i++) {
  		String uniqueLastName = 'Person' + i;
	  	Account acct = new Account(RecordTypeId = personAccountRecordType.Id,
	  							   FirstName = 'Test', 
	  							   LastName = uniqueLastName, 
	  							   SFDC2__c = true,
	  							   PersonMailingStreet = '123 Main Street', 
	  							   PersonMailingCity = 'Springfield', 
	  							   PersonMailingCountry = 'USA', 
	  							   PersonMailingState = 'MA', 
	  							   PersonMailingPostalCode = '12345',
  								   BillingStreet = '456 Main Street', 
  								   BillingCity = 'Providence', 
  								   BillingCountry = 'USA', 
  								   BillingState = 'RI', 
  								   BillingPostalCode = '67890');
	  	if (i<20) {
	  		accts1.add(acct);
	  	} else {
	  		accts2.add(acct);
	  	}
  	}
  	insert accts1;
  	insert accts2;
  	
  	for (Account acct: accts1) {
  		System.assertEquals(true, acct.SFDC2__c, 'Test Account lost SFDC2 status in set 1.');
  	}
  	for (Account acct: accts2) {
  		System.assertEquals(true, acct.SFDC2__c, 'Test Account lost SFDC2 status in set 2.');
  	}
  	
  	// Add a set of Address objects to the first account in the list
  	List<Address_SFDC2__c> addresses = new List<Address_SFDC2__c>();
  	for (Integer i=0; i<2; i++) {
  		Address_SFDC2__c address = new Address_SFDC2__c(Account__c = accts1.get(0).Id, RecordTypeId = addressRecordType.Id);
  		if (i==0) {
  			address.Address_Type__c = 'Other';
  			address.Street__c = '789 Main Street';
  			address.City__c = 'Hartford';
  			address.Country__c = 'USA';
  			address.State__c = 'CT';
  			address.Postal_Code__c = '54321';
  		}
  		if (i==1) {
  			address.Address_Type__c = 'Other';
  			address.Street__c = '012 Main Street';
  			address.City__c = 'Montpelier';
  			address.Country__c = 'USA';
  			address.State__c = 'VT';
  			address.Postal_Code__c = '09876';
  		}
  		addresses.add(address);
  	}
  	insert addresses;
  	
  	// Modify each set of address fields to hold new values in the first 10 accounts.
  	// (For the first account, these addresses will already exist as Address objects.)
  	// After the update, these accounts should have two Address objects corresponding to
  	//   the original address field values.
  	for (Integer i=0; i<20; i++) {  	
	  	accts1.get(i).PersonMailingStreet = '789 Main Street';
  		accts1.get(i).PersonMailingCity = 'Hartford';
  		accts1.get(i).PersonMailingCountry = 'USA';
  		accts1.get(i).PersonMailingState = 'CT';
  		accts1.get(i).PersonMailingPostalCode = '54321';
	  	accts1.get(i).BillingStreet = '012 Main Street';
  		accts1.get(i).BillingCity = 'Montpelier';
  		accts1.get(i).BillingCountry = 'USA';
  		accts1.get(i).BillingState = 'VT';
  		accts1.get(i).BillingPostalCode = '09876';
  	}

  	// Modify each address field to hold a value previously held by another address field in the remaining accounts.
  	// After the update these accounts should have no Address objects.
  	for (Integer i=0; i<20; i++) {  	
	  	accts2.get(i).PersonMailingStreet = '456 Main Street';
  		accts2.get(i).PersonMailingCity = 'Providence';
  		accts2.get(i).PersonMailingCountry = 'USA';
  		accts2.get(i).PersonMailingState = 'RI';
  		accts2.get(i).PersonMailingPostalCode = '67890';
	  	accts2.get(i).BillingStreet = '123 Main Street';
  		accts2.get(i).BillingCity = 'Springfield';
  		accts2.get(i).BillingCountry = 'USA';
  		accts2.get(i).BillingState = 'MA';
  		accts2.get(i).BillingPostalCode = '12345';
  	}
  	
  	Test.startTest();
  	update accts1;
  	update accts2;
  	Test.stopTest();
  	
  	accts1 = [SELECT Id, PersonMailingStreet, PersonMailingCity, PersonMailingCountry, PersonMailingState, PersonMailingPostalCode,
  					 BillingStreet, BillingCity, BillingCountry, BillingState, BillingPostalCode, 
  			(SELECT Street__c, City__c, Country__c, State__c, Postal_Code__c FROM Addresses__r WHERE Account__c IN :accts1 )
  			FROM Account WHERE Id IN :accts1];

  	accts2 = [SELECT Id, PersonMailingStreet, PersonMailingCity, PersonMailingCountry, PersonMailingState, PersonMailingPostalCode,
  					 BillingStreet, BillingCity, BillingCountry, BillingState, BillingPostalCode, 
  			(SELECT Street__c, City__c, Country__c, State__c, Postal_Code__c FROM Addresses__r WHERE Account__c IN :accts2)
  			FROM Account WHERE Id IN :accts2];

	// Assert that the correct number of Address objects exist for each Account.
	for (Integer i=0; i<20; i++) {
		System.assertEquals(2, accts1.get(i).Addresses__r.size(), 'Incorrect number of Address objects for first account set row ' + i + '.');
		System.assertEquals(0, accts2.get(i).Addresses__r.size(), 'Incorrect number of Address objects for second account set row ' + i + '.');
	}
  	
  }
  
  /**
   * Test update of SFDC2 checkbox
   */
  @IsTest
  static void testUpdateSFDC2Checkbox () {
  	
  	List<Account> sfdc2Accounts = new List<Account>();
  	
  	Id businessAccountId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account SFDC2').getRecordTypeId();
  	Id hybridAccountId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business/Consumer Person Account').getRecordTypeId();
  	Id consumerAccountId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer Person Account SFDC2').getRecordTypeId();
  	Id nonSfdc2Id= Schema.SObjectType.Account.getRecordTypeInfosByName().get('WLD').getRecordTypeId();
  	Id prospectingBusinessAccountId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospecting Business').getRecordTypeId();
  	Id prospectingHybridAccountId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospecting Business/Consumer PA').getRecordTypeId();
  	Id prospectingConsumerAccountId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospecting Consumer PA').getRecordTypeId();
  	
  	for(Integer i = 0; i<20; i++) {
  		sfdc2Accounts.add(new Account(name='test business account ' + i, RecordTypeId=businessAccountId, SFDC2__c=false));
  		sfdc2Accounts.add(new Account(firstName='test', lastName='hybrid account ' + i, RecordTypeId=hybridAccountId, SFDC2__c=false));
  		sfdc2Accounts.add(new Account(firstName='test', lastName='consumer account ' + i, RecordTypeId=consumerAccountId, SFDC2__c=false));
  		sfdc2Accounts.add(new Account(name='test prospecting business account ' + i, RecordTypeId=prospectingBusinessAccountId, SFDC2__c=false));
  		sfdc2Accounts.add(new Account(firstName='test', lastName='prospecting hybrid account ' + i, RecordTypeId=prospectingHybridAccountId, SFDC2__c=false));
  		sfdc2Accounts.add(new Account(firstName='test', lastName='prospecting consumer account ' + i, RecordTypeId=prospectingConsumerAccountId, SFDC2__c=false));
  		sfdc2Accounts.add(new Account(name='test non SFDC2 business account ' + i, RecordTypeId=nonSfdc2Id, SFDC2__c=true));
  	}

	insert sfdc2Accounts;
	
	sfdc2Accounts = [select Id, SFDC2__c, RecordTypeId from Account where Id IN :sfdc2Accounts];
	
	// Check value of the SFDC2 checkbox
	for (Account account: sfdc2Accounts) {
		if (account.RecordTypeId != nonSfdc2Id) {
			System.assertEquals(true, account.SFDC2__c, 'Unexpected SFDC2 status for recordTypeId ' + account.RecordTypeId + ' after insert ');
		} else {
			System.assertEquals(false, account.SFDC2__c, 'Unexpected SFDC2 status for recordTypeId ' + account.RecordTypeId + ' after insert ');
		}
	}

	// Manually update SFDC2 checkbox
	for (Account account: sfdc2Accounts) {
		if (account.RecordTypeId != nonSfdc2Id) {
			account.SFDC2__c = false;
		} else {
			account.SFDC2__c = true;
		}
	}

	Test.startTest();
	update sfdc2Accounts;
	Test.stopTest();	
	
	sfdc2Accounts = [select Id, SFDC2__c, RecordTypeId from Account where Id IN :sfdc2Accounts];

	// Check value of the SFDC2 checkbox
	for (Account account: sfdc2Accounts) {
		if (account.RecordTypeId != nonSfdc2Id) {
			System.assertEquals(true, account.SFDC2__c, 'Unexpected SFDC2 status for recordTypeId ' + account.RecordTypeId + ' after insert ');
		} else {
			System.assertEquals(false, account.SFDC2__c, 'Unexpected SFDC2 status for recordTypeId ' + account.RecordTypeId + ' after insert ');
		}
	}

  }
  
  /**
  * SFDC2: Tests the functionality of triggerMortgageCrossSellOppCreation
  */
  /* @isTest
  static void testTriggerMortgageCrossSellOppCreation() {
  	Account a = new Account();
  	a.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer Person Account SFDC2').getRecordTypeId();
  	a.FirstName ='Test';
  	a.LastName ='Account';
  	a.Edisclosure_Accepted_Person__c = false;
  	insert a;
  	a = [SELECT Person_Contact_Id__c FROM Account WHERE Id = :a.Id];
  	Financial_Account_SFDC2__c fa = new Financial_Account_SFDC2__c();
  	fa.Name = 'TEST Account';
  	fa.Department__c = 'Mortgage Lending';
  	insert fa;
  	Financial_Account_Contact_Link_SFDC2__c facl = new Financial_Account_Contact_Link_SFDC2__c();
  	facl.Contact__c = a.Person_Contact_Id__c;
  	facl.Financial_Account__c = fa.Id;
  	facl.CIF_JHA_LINK__c = '0000^TEST';
  	insert facl;
  	Campaign c = new Campaign();
  	c.Name = '250 Consumer Deposit Campaign';
  	insert c;
  	CampaignMemberStatus cms = new CampaignMemberStatus();
  	cms.CampaignId = c.Id;
  	cms.Label = 'Attempting Contact';
  	insert cms;
  	
  	Test.startTest();
  	a.Edisclosure_Accepted_Person__c = true;
  	update a;
  	Test.stopTest();
  	
  	a = [SELECT 
  			Id,
  			(SELECT
  				Id
  			 FROM
  			 	Opportunities
  			 WHERE
  			 	Name = 'Cross Sell from Mortgage'),
  			(SELECT
  				Id
  			 FROM
  			 	PersonCampaignMembers
  			 WHERE
  			 	Campaign.Name = '250 Consumer Deposit Campaign')
  		 FROM 
  		 	Account 
  		 WHERE 
  		 	Id = :a.Id];
	System.assertEquals(1, a.Opportunities.size());
	System.assertEquals(1, a.PersonCampaignMembers.size());
  }  */
  
  	@isTest
    static void testHandleDoNotCallUpdateSFDC2() {
        Id acctRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer Person Account SFDC2').getRecordTypeId();
        Id finRTId = Schema.SObjectType.Financial_Account_SFDC2__c.getRecordTypeInfosByName().get('CD').getRecordTypeId();
		
		Account acct = new Account();
		acct.LastName = 'Test';
		acct.RecordTypeId = acctRTId;
		acct.Occupation_SFDC2__pc = 'Tester';
		acct.PersonDoNotCall = false;
		insert acct;
		acct = [SELECT Person_Contact_Id__c FROM Account WHERE Id = :acct.Id];
		
		Financial_Account_SFDC2__c fa = new Financial_Account_SFDC2__c();
		fa.Name = 'TEST 0000';
		fa.Status__c = 'Active';
		fa.Product_Class__c = 'CD';
		fa.RecordTypeId = finRTId;
		fa.Maturity_Date__c = Date.today().addDays(30);
		insert fa;
		
		Financial_Account_Contact_Link_SFDC2__c link = new Financial_Account_Contact_Link_SFDC2__c();
		link.Financial_Account__c = fa.Id;
		link.Contact__c = acct.Person_Contact_Id__c;
		link.CIF_JHA_LINK__c = '30DayCDTEST1111';
		insert link;
		for(CampaignMember cm : [SELECT Campaign.Name, Status FROM CampaignMember WHERE ContactId = :acct.Person_Contact_Id__c]) {
			System.assertEquals('Attempting Contact', cm.Status);
			//ensure 30 Day CD Maturity Campaign
			if(cm.ContactId == acct.Person_Contact_Id__c) {
				System.assertEquals('30 Day CD Maturity', cm.Campaign.Name);
			}
		}
		
		Test.startTest();
		acct.PersonDoNotCall = true;
		update acct;
		Test.stopTest();
		CampaignMember[] cm = [SELECT Campaign.Name, Status FROM CampaignMember WHERE ContactId = :acct.Person_Contact_Id__c];
		System.assertEquals(0, cm.size());
    }
}