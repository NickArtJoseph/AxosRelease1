@isTest
private class LeadTriggerHandler_Test {

   /**
    * SFDC 2.0: Set up test records
    */
    @testSetup
    static void init() {
        //create test users for roles that will trigger lead reassignments
        List<User> testUserList = new List<User>();
        Set<String> testProfile = new Set<String>{'Enterprise User'};
        User tUser = TestDataFactory.createTestUsers(testProfile)[0];
        for(String r : UserTriggerHandler.roleLeadQueueMap.keySet()) {
            User testUser = tUser.clone();
            testUser.Username = 'test@testusertrigger.org.' + r;
            testUser.CommunityNickname = r;
            Id roleId;
            for(UserRole ur : UserTriggerHandler.roleMap.values()) {
                if(ur.DeveloperName == r) {
                    roleId = ur.Id;
                    break;
                }
            } 
            testUser.UserRoleId = roleId;
            testUserList.add(testUser);
        }
        System.debug('Adding test users: ' + testUserList.size());
        System.assert(testUserList.size() > 0);
        insert testUserList;
    }

    /**
    * Handles test for handleLeadReassignment functionality
    */
    @isTest
    static void testHandleLeadReassignment() {
        TriggerValidator.setIsTest();
        
        List<User> testUserList = [SELECT UserRoleId, UserRole.Name FROM User WHERE Username LIKE 'test@testusertrigger.org.%'];
        System.assert(testUserList.size() > 0);
        //for every test user, create a test Lead record and assign ownership to that user
        User apiUser = [select Id from user where profile.name = 'API Service Account' limit 1][0];
        List<Lead> testLeadList = new List<Lead>();
        for(User u : testUserList) {
            Lead l = new Lead(FirstName='Test',
                                LastName='Contact',
                                Email='testcontact@test.com',
                                Company='Test' + u.id,
                                OwnerId = u.Id);
            testLeadList.add(l);
        }
        insert testLeadList;

        //ensure that inserted records belong to users
        List<Lead> afterInsertList = [SELECT OwnerId, Owner.Type, Owner.UserRole.DeveloperName FROM Lead WHERE Id IN :testLeadList]; 
        for(Lead l : afterInsertList) {
            System.assertEquals('User', l.Owner.Type);
        }
        
        Test.startTest();
        for(Lead l : afterInsertList) {
            l.Reassign_To_Queue_SFDC2__c = true;
        }
        update afterInsertList;
        Test.stopTest();
        
        List<Lead> afterUpdateList = [SELECT OwnerId, Owner.Type FROM Lead WHERE Id IN :testLeadList];
        for(Lead l : afterUpdateList) {
            System.assertNotEquals('User', l.Owner.Type);
            Lead priorLead;
            for(Lead pl : afterInsertList) {
                if(pl.Id == l.Id) {
                    priorLead = pl;
                    break;
                }
            }
            System.assertNotEquals(null, priorLead);
            String ownerRoleName = priorLead.Owner.UserRole.DeveloperName;
            String queueName = UserTriggerHandler.queueMap.get(l.OwnerId).DeveloperName;
            System.assertEquals(UserTriggerHandler.roleLeadQueueMap.get(ownerRoleName), queueName);
        }
    }

  /**
  * Tests the reassignLeadOwner_CD method that is triggered beforeUpdate for Leads
  */
  @isTest
  static void testReassignLeadOwner_CD() {
    //set up a test queue for Leads
    Group q;
    QueueSobject qs;
    User u;
    Lead l;
    GroupMember gm;
    
    System.runAs(new User(Id = UserInfo.getUserId())) {
        q = new Group(Name='TEST-Consumer Deposits Queue', Type='Queue');
        insert q;
        qs = new QueueSobject(QueueId=q.Id,SobjectType='Lead');
        insert qs;
    
        //create test lead
        RecordType rt = [SELECT Id FROM RecordType WHERE DeveloperName = 'Consumer_Deposits' AND SobjectType = 'Lead' LIMIT 1];
        UserRole ur = [SELECT Id from UserRole WHERE DeveloperName = 'Consumer_Deposits' LIMIT 1];
        l = new Lead(FirstName='Test',LastName='Lead',RecordTypeId=rt.Id,OwnerId=q.Id);
        insert l;
        
 //       List<User> userList = [SELECT Id FROM User WHERE Profile.Name = 'Consumer Deposits Team' AND IsActive = true LIMIT 1];
        List<User> userList = [SELECT Id FROM User WHERE UserRole.Name = 'Consumer Deposits' AND IsActive = true LIMIT 1];
        u = userList.get(0);
        
        gm = new GroupMember(GroupId=q.Id,UserorGroupId=u.Id);
        insert gm;
    }
    
    System.Test.startTest();
    //test updating a field as a non-Consumer Deposits user
    l.FirstName = 'Test1';
    update l;
    l = [SELECT Id, OwnerId FROM Lead WHERE Id = :l.Id];
    System.assertEquals(q.Id, l.OwnerId);
    
    //test updating a field as a Consumer Deposits user
    l.LastName = 'Lead2';
    System.runAs(u){
      update l;
    }
    System.Test.stopTest();
    
    l = [SELECT Id, OwnerId from Lead WHERE Id = :l.Id];
    System.assertEquals(u.Id, l.OwnerId);
  }
  
  /** Tests creation of custom Phone objects on Lead phone field modification */
  @isTest
  static void testUpdateLeadPhoneListSfdc2() {
    TriggerValidator.setIsTest();

    List<Lead> leads1 = new List<Lead>();
    List<Lead> leads2 = new List<Lead>();
    
    System.debug('Inserting two sets of 20 leads to test Phone object creation.');
    
    RecordType rt = [select Id from RecordType where SObjectType='Lead' and DeveloperName = 'Consumer_Deposits_SFDC2'];
    RecordType phoneRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Phone_SFDC2__c' AND Name = 'Lead Phone'];
    
    // Create set of test leads with phone number fields populated
    for (Integer i=0; i<40; i++) {
        String uniqueLastName = 'Person' + i;
        Lead lead = new Lead(FirstName = 'Test', 
                             LastName = uniqueLastName, 
                             SFDC2__c = true,
                             Phone = '1234567890',
                             MobilePhone = '2345678901',
                             Fax = '4567890123',
                             RecordTypeId = rt.Id);
        if (i<20) {
            leads1.add(lead);
        } else {
            leads2.add(lead);
        }
    }
    insert leads1;
    insert leads2;
    
    for (Lead lead: leads1) {
        System.assertEquals(true, lead.SFDC2__c, 'Test Lead lost SFDC2 status in set 1.');
    }
    for (Lead lead: leads2) {
        System.assertEquals(true, lead.SFDC2__c, 'Test Lead lost SFDC2 status in set 2.');
    }

    // Add a set of Phone objects to the first account in the list
    List<Phone_SFDC2__c> phones = new List<Phone_SFDC2__c>();
    for (Integer i=0; i<3; i++) {
        Phone_SFDC2__c phone = new Phone_SFDC2__c(Lead__c = leads1.get(0).Id, RecordTypeId = phoneRecordType.Id);
        if (i==0) {
            phone.Phone__c = '9087654321';
            phone.Phone_Type__c = 'Other Home';
        }
        if (i==1) {
            phone.Phone__c = '1098765432';
            phone.Phone_Type__c = 'Other Mobile';
        }
        if (i==2) {
            phone.Phone__c = '3456789012';
            phone.Phone_Type__c = 'Other Fax';
        }
        phones.add(phone);
    }
    insert phones;
    
    // Modify each phone field to hold a new value in the first 10 leads.
    // (For the first account, these numbers will already exist as Phone objects.)
    // After the update, these leads should have three Phone objects corresponding to
    //   the original phone field values.
    for (Integer i=0; i<20; i++) {      
        leads1.get(i).Phone = '9087654321';
        leads1.get(i).MobilePhone = '1098765432';
        leads1.get(i).Fax = '3456789012';
    }

    // Modify each phone field to hold a value previously held by another phone field in the remaining leads.
    // After the update these leads should have no Phone objects.
    for (Integer i=0; i<20; i++) {      
        leads2.get(i).Phone = '4567890123';
        leads2.get(i).MobilePhone = '1234567890';
        leads2.get(i).Fax = '2345678901';
    }
    
    Test.startTest();
    update leads1;
    update leads2;
    Test.stopTest();
    
    leads1 = [SELECT Id, Phone, MobilePhone, Fax, 
            (SELECT Phone__c FROM Phones__r WHERE Lead__c IN :leads1 )
            FROM Lead WHERE Id IN :leads1];

    leads2 = [SELECT Id, Phone, MobilePhone, Fax, 
            (SELECT Phone__c FROM Phones__r WHERE Lead__c IN :leads2 )
            FROM Lead WHERE Id IN :leads2];

    // Assert that the correct number of Phone objects exist for each Lead.
    for (Integer i=0; i<20; i++) {
        System.assertEquals(3, leads1.get(i).Phones__r.size(), 'Incorrect number of Phone objects for first lead set.');
        System.assertEquals(0, leads2.get(i).Phones__r.size(), 'Incorrect number of Phone objects for second lead set.');
    }
    
  }

  /** Tests creation of custom Email objects on Lead email field modification */
  @isTest
  static void testUpdateLeadEmailListSfdc2() {
    TriggerValidator.setIsTest();

    List<Lead> leads1 = new List<Lead>();
    
    System.debug('Inserting two sets of 20 leads to test Email object creation.');
    
    RecordType rt = [select Id from RecordType where SObjectType='Lead' and DeveloperName = 'Consumer_Deposits_SFDC2'];
    RecordType emailRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Email_SFDC2__c' AND Name = 'Lead Email'];

    // Create set of test leads with email address fields populated
    for (Integer i=0; i<20; i++) {
        String uniqueLastName = 'Person' + i;
        Lead lead = new Lead(FirstName = 'Test', 
                             LastName = uniqueLastName, 
                             SFDC2__c = true,
                             Email = 'test1@test.com',
                             RecordTypeId = rt.Id);
        leads1.add(lead);
    }
    insert leads1;
    
    for (Lead lead: leads1) {
        System.assertEquals(true, lead.SFDC2__c, 'Test Lead lost SFDC2 status in set 1.');
    }

    // Add a set of Email objects to the first lead in the list
    List<Email_SFDC2__c> emails = new List<Email_SFDC2__c>();
    for (Integer i=0; i<1; i++) {
        Email_SFDC2__c email = new Email_SFDC2__c(Lead__c = leads1.get(0).Id, RecordTypeId = emailRecordType.Id);
        if (i==0) {
            email.Email__c = 'test2@test.com';
            email.Email_Type__c = 'Other Personal';
        }
        emails.add(email);
    }
    insert emails;
    
    // Modify each email field to hold a new value.
    // (For the first lead, these emails will already exist as Email objects.)
    // After the update, these leads should have one Email object corresponding to
    //   the original email field value.
    for (Integer i=0; i<20; i++) {      
        leads1.get(i).Email = 'test2@test.com';
    }
    
    Test.startTest();
    update leads1;
    Test.stopTest();
    
    leads1 = [SELECT Id, Email, 
            (SELECT Email__c FROM Email_Addresses__r WHERE Lead__c IN :leads1 )
            FROM Lead WHERE Id IN :leads1];

    // Assert that the correct number of Email objects exist for each Lead.
    for (Integer i=0; i<20; i++) {
        System.assertEquals(1, leads1.get(i).Email_Addresses__r.size(), 'Incorrect number of Email objects for first lead set.');
    }
    
  }

  /** Tests creation of custom Address objects on Lead address field modification */
  @isTest
  static void testUpdateLeadAddressListSfdc2() {
    TriggerValidator.setIsTest();

    List<Lead> leads1 = new List<Lead>();
    List<Lead> leads2 = new List<Lead>();
    
    System.debug('Inserting two sets of 20 leads to test Address object creation.');
    
    RecordType rt = [select Id from RecordType where SObjectType='Lead' and DeveloperName = 'Consumer_Deposits_SFDC2'];
    RecordType addressRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Address_SFDC2__c' AND Name = 'Lead Address'];

    // Create set of test leads with address fields populated
    for (Integer i=0; i<20; i++) {
        String uniqueLastName = 'Person' + i;
        Lead lead = new Lead(FirstName = 'Test', 
                             LastName = uniqueLastName, 
                             SFDC2__c = true,
                             Street = '123 Main Street', 
                             City = 'Springfield', 
                             Country = 'USA', 
                             State = 'MA', 
                             PostalCode = '12345',
                             Primary_Mortgage_Lender_SFDC2__c = 'Nationwide',
                             Primary_Loan_Type_SFDC2__c = '35 year fixed',
                             Primary_Purchase_Amount_SFDC2__c = 250000.00,
                             RecordTypeId = rt.Id);
        leads1.add(lead);
    }
    insert leads1;
    
    for (Lead lead: leads1) {
        System.assertEquals(true, lead.SFDC2__c, 'Test Lead lost SFDC2 status in set 1.');
    }

    // Add a set of Address objects to the first lead in the list
    List<Address_SFDC2__c> addresses = new List<Address_SFDC2__c>();
    for (Integer i=0; i<1; i++) {
        Address_SFDC2__c address = new Address_SFDC2__c(Lead__c = leads1.get(0).Id, RecordTypeId = addressRecordType.Id);
        if (i==0) {
            address.Address_Type__c = 'Other';
            address.Street__c = '789 Main Street';
            address.City__c = 'Hartford';
            address.Country__c = 'USA';
            address.State__c = 'CT';
            address.Postal_Code__c = '54321';
            address.Mortgage_Lender__c = 'Other Bank 1';
            address.Loan_Type__c = '50 year variable';
            address.Purchase_Amount__c = 376500.00;
        }
        addresses.add(address);
    }
    insert addresses;
    
    // Modify each set of address fields to hold new values.
    // (For the first lead, these addresses will already exist as Address objects.)
    // After the update, these leads should have one Address object corresponding to
    //   the original address field values.
    for (Integer i=0; i<20; i++) {      
        leads1.get(i).Street = '789 Main Street';
        leads1.get(i).City = 'Hartford';
        leads1.get(i).Country = 'USA';
        leads1.get(i).State = 'CT';
        leads1.get(i).PostalCode = '54321';
        leads1.get(i).Primary_Mortgage_Lender_SFDC2__c = 'Other Bank 1';
        leads1.get(i).Primary_Loan_Type_SFDC2__c = '50 year variable';
        leads1.get(i).Primary_Purchase_Amount_SFDC2__c = 376500.00;
    }
    
    Test.startTest();
    update leads1;
    Test.stopTest();
    
    leads1 = [SELECT id, Street, City, Country, State, PostalCode,
                Primary_Loan_Type_SFDC2__c, Primary_Mortgage_Lender_SFDC2__c, Primary_Purchase_Amount_SFDC2__c, Primary_Purchase_Date_SFDC2__c,
              (SELECT Street__c, City__c, Country__c, State__c, Postal_Code__c FROM Addresses__r WHERE Lead__c IN :leads1 )
              FROM Lead WHERE Id IN :leads1];

    // Assert that the correct number of Address objects exist for each Lead.
    for (Integer i=0; i<20; i++) {
        System.assertEquals(1, leads1.get(i).Addresses__r.size(), 'Incorrect number of Address objects for first lead set.');
    }
    
  }
  
  /** Test handling of custom field and object creation/update during Lead conversion */
  @isTest
  static void testCustomLeadConversionHandler() {
    TriggerValidator.setIsTest(); 
      
    Lead personLead = new Lead(FirstName = 'Test_First', 
                               LastName = 'Test_Last',
                               Date_Of_Birth__c = date.newInstance(2014, 9, 15), 
                               LeadSource = 'Customer Referral',
                               RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Consumer Deposits SFDC2').getRecordTypeId(),
                               SFDC2__c = true,
                               Status = 'Contacted/Converted',
                               Opportunity_NameSFDC2__c='Test');

    Lead businessLead = new Lead(FirstName = 'Test_First', 
                               LastName = 'Test_Last',
                               Company = 'Test_Company',
                               Date_Of_Birth__c = date.newInstance(2014, 9, 15), 
                               LeadSource = 'Bloomberg BNA',
                               Email = 'abc@abc.com',
                               RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Business Banking SFDC2').getRecordTypeId(),
                               SFDC2__c = true,
                               Status = 'Contacted/Converted',
                               Opportunity_NameSFDC2__c='Test');

    insert personLead;
    insert businessLead;
    
        
    List<Phone_SFDC2__c> phones = new List<Phone_SFDC2__c>();
    List<Email_SFDC2__c> emails = new List<Email_SFDC2__c>();
    List<Address_SFDC2__c> addrs = new List<Address_SFDC2__c>();
    
    // Add five custom phone, email and address objects for each lead
    for (Integer i=0; i<5; i++) {
        phones.add(new Phone_SFDC2__c(Lead__c = personLead.Id,
                                      Phone__c = '987654321'+i,
                                      Phone_Type__c = 'Other Home'));
        emails.add(new Email_SFDC2__c(Lead__c = personLead.Id,
                                      Email__c = 'test'+ i + '@test.com',
                                      Email_Type__c = 'Other Personal'));
        addrs.add(new Address_SFDC2__c(Lead__c = personLead.Id,
                                       Street__c = 'test_street'+i,
                                       Address_Type__c = 'Other'));
        phones.add(new Phone_SFDC2__c(Lead__c = businessLead.Id,
                                      Phone__c = '987654321'+i,
                                      Phone_Type__c = 'Other Business'));
        emails.add(new Email_SFDC2__c(Lead__c = businessLead.Id,
                                      Email__c = 'test'+ i + '@test.com',
                                      Email_Type__c = 'Other Business'));
        addrs.add(new Address_SFDC2__c(Lead__c = businessLead.Id,
                                       Street__c = 'test_street'+i,
                                       Address_Type__c = 'Other'));
    }

    insert phones;
    insert emails;
    insert addrs;
    
    // Convert leads
    Test.startTest();
    
    for (Integer i=0; i<1; i++) {
        Database.LeadConvert lc = new Database.LeadConvert();
        
        if (i==0) {
            lc.setLeadId(personLead.Id);
        } else {
            //lc.setLeadId(businessLead.Id);          
        }
                  
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true and MasterLabel = 'Contacted/Converted' limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        lc.setDoNotCreateOpportunity(true);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess(), 'Failed lead conversion ' + i);
        
        phones = [Select Id from Phone_SFDC2__c where Account__c = :lcr.getAccountId()];
        System.assertEquals(5, phones.size(), 'Incorrect number of phone records in account ' + i);
    
        emails = [Select Id from Email_SFDC2__c where Account__c = :lcr.getAccountId()];
        System.assertEquals(5, emails.size(), 'Incorrect number of phone records in account ' + i);
    
        addrs = [Select Id from Address_SFDC2__C where Account__c = :lcr.getAccountId()];
        System.assertEquals(5, addrs.size(), 'Incorrect number of phone records in account ' + i);
        
    }
    
        Lead pltest= [Select ConvertedAccountId from Lead where Id = :personLead.Id];
        Account patest= [Select AccountSource from Account where Id = :pltest.ConvertedAccountId];
        System.assertEquals(personLead.LeadSource, patest.AccountSource, 'Incorrect match');

        /*Lead bltest= [Select ConvertedAccountId from Lead where Id = :businessLead.Id];
        Account batest= [Select AccountSource from Account where Id = :bltest.ConvertedAccountId];
        System.assertEquals(businessLead.LeadSource, batest.AccountSource, 'Incorrect match');*/
      
    Test.stopTest();
    

  }
  
  
  /**
   * Test Update SFDC2 Checkbox
   */
  @IsTest
  static void testUpdateSFDC2Checkbox() {
    
    List<Lead> leads = new List<Lead>();
    
    List<Id> sfdc2Ids = new List<Id>();
    sfdc2Ids.add(Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Advisor Firm SFDC2').getRecordTypeId());
    sfdc2Ids.add(Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Business Banking SFDC2').getRecordTypeId());
    sfdc2Ids.add(Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Consumer Deposits SFDC2').getRecordTypeId());
    sfdc2Ids.add(Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Dealer Services - Dealer SFDC2').getRecordTypeId());
    sfdc2Ids.add(Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Enterprise Lead').getRecordTypeId());
    sfdc2Ids.add(Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Prospecting Business').getRecordTypeId());
    sfdc2Ids.add(Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Prospecting Consumer').getRecordTypeId());
    sfdc2Ids.add(Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Virtus SFDC2').getRecordTypeId());
    
    Id nonSFDC2Id = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('HRB Lead').getRecordTypeId();

    // Add SFDC Leads
    for (Id id: sfdc2Ids) {
        for (Integer i=0; i<20; i++) {
            leads.add(new Lead(firstName='test'+i, lastName='test '+id, status='New', SFDC2__c=false, recordTypeId=id));
        }
    }
    
    // Add non-SFDC Leads
    for (Integer i=0; i<20; i++) {
        leads.add(new Lead(firstName='test_nonSFDC2', lastName='test'+i, status='New', SFDC2__c=true, recordTypeId=nonSFDC2Id));
    }
    
    insert leads;
    
    leads = [select Id, SFDC2__c, firstName, RecordTypeId from Lead where Id IN :leads];
    
    // Assert SFDC2 values for SFDC2 and non-SFDC2 records after insert
    for (Lead lead: leads) {
        if (lead.firstName!='test_nonSFDC2') {
            System.assertEquals(true, lead.SFDC2__c, 'Unexpected SFDC2 value for record type id ' + lead.id + ' after insert');
        } else {
            System.assertEquals(false, lead.SFDC2__c, 'Unexpected SFDC2 value for record type id ' + lead.id + ' after insert');
        }
    }

    // Update SFDC2 status for all Leads
    for (Lead lead: leads) {
        if (lead.firstName=='test_nonSFDC2') {
            lead.SFDC2__c = true;
        } else {
            lead.SFDC2__c = false;
        }
    }   
    update leads;   
    
    leads = [select Id, SFDC2__c, firstName, RecordTypeId from Lead where Id IN :leads];
    
    // Assert SFDC2 values for SFDC2 and non-SFDC2 records after insert
    for (Lead lead: leads) {
        if (lead.firstName!='test_nonSFDC2') {
            System.assertEquals(true, lead.SFDC2__c, 'Unexpected SFDC2 value for record type id ' + lead.id + ' after update');
        } else {
            System.assertEquals(false, lead.SFDC2__c, 'Unexpected SFDC2 value for record type id ' + lead.id + ' after update');
        }
    }
    
  }
  
  @isTest
  static void testHandlePrimaryCampaign() {
    TriggerValidator.setIsTest(); 
    
    Campaign c = new Campaign();
    c.Name='TestPrimaryCampaign';
    insert c;
    
    Lead personLead = new Lead(FirstName = 'Test_First', 
                               LastName = 'Test_Last',
                               Date_Of_Birth__c = date.newInstance(2014, 9, 15), 
                               LeadSource = 'Customer Referral',
                               RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Consumer Deposits SFDC2').getRecordTypeId(),
                               SFDC2__c = true,
                               Status = 'New',
                               Opportunity_NameSFDC2__c='Test',
                               Primary_Campaign_SFDC2__c=c.Id);
	insert personLead;
	Test.startTest();
	personLead.Status = 'Contacted/Converted';
	update personLead;
	Test.stopTest();
	
	personLead = [SELECT IsConverted, ConvertedOpportunity.CampaignId FROM Lead WHERE Id = :personLead.Id];
	System.assertEquals(c.Id, personLead.ConvertedOpportunity.CampaignId);
  }
}