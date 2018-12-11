@isTest
private class TaskTriggerHandler_Test {

	/**
    * SFDC 2.0: Set up test records
    */
    @testSetup
    static void init() {
        //create test user
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
  * Tests the populatePersonAccountWithInsideSalesCallData method that is triggered afterInsert for Tasks
  */
  @isTest
  static void testPopulatePersonAccountWithInsideSalesCallData() {
      Account testBusinessAccount = TestDataFactory.createAndInsertTestBusinessAccount();
      Phone_Number__c testBusinessPhone = TestDataFactory.createAndInsertTestPhoneNumber(testBusinessAccount);
      Account testPersonAccount = TestDataFactory.createAndInsertTestPersonAccount();
      Phone_Number__c testPersonPhone = TestDataFactory.createAndInsertTestPhoneNumber(testPersonAccount);
      List<Task> testTasks = new List<Task>{
        TestDataFactory.createTestTask(testBusinessAccount),
        TestDataFactory.createTestTask(testBusinessPhone),
        TestDataFactory.createTestTask(testPersonAccount),
        TestDataFactory.createTestTask(testPersonPhone),
        TestDataFactory.createTestTask(testPersonPhone)
      };
      testTasks.get(0).qbdialer__Call_Dial_Number__c = 1;
      testTasks.get(0).qbdialer__Call_Date_Time__c = Datetime.now();
      testTasks.get(0).qbdialer__ImpressionId__c = 1;
      testTasks.get(1).qbdialer__Call_Dial_Number__c = 1;
      testTasks.get(1).qbdialer__Call_Date_Time__c = Datetime.now();
      testTasks.get(1).qbdialer__ImpressionId__c = 2;
      testTasks.get(2).qbdialer__Call_Dial_Number__c = 1;
      testTasks.get(2).qbdialer__Call_Date_Time__c = Datetime.now();
      testTasks.get(2).qbdialer__ImpressionId__c = 3;
      testTasks.get(3).qbdialer__Call_Dial_Number__c = 1;
      testTasks.get(3).qbdialer__Call_Date_Time__c = Datetime.now();
      testTasks.get(3).qbdialer__ImpressionId__c = 4;
      testTasks.get(4).qbdialer__Call_Dial_Number__c = 0;
      testTasks.get(4).qbdialer__Call_Date_Time__c = Datetime.now();
      testTasks.get(4).CallType = 'Inbound';
      testTasks.get(4).qbdialer__ImpressionId__c = 5;
      
      System.Test.startTest();
      insert testTasks;
      testTasks.get(4).qbdialer__Call_Dial_Number__c = 2;
      update testTasks;
      System.Test.stopTest();
      
      List<Id> testAccountIds = new List<Id>{testBusinessAccount.Id, testPersonAccount.Id};
      for(Account a : [
                       Select Id, Current_Rep_Dials__c, qbdialer__Dials__c, qbdialer__LastCallTime__c, qbdialer__Dials__pc, qbdialer__LastCallTime__pc 
                       From Account 
                       Where Id in :testAccountIds
                      ]) {
        if(a.Id == testBusinessAccount.Id) {
          System.assertEquals(2, a.qbdialer__Dials__c, 'Business Account dials was not updated');
          System.assertEquals(2, a.Current_Rep_Dials__c, 'Current Rep Dials was not incremented');
        }
        if(a.Id == testPersonAccount.Id) {
          System.assertEquals(2, a.qbdialer__Dials__c, 'Person Account dials was not updated');
          System.assertEquals(2, a.Current_Rep_Dials__c, 'Current Rep Dials was not incremented');
        }
      }
  }
  

  @isTest
  static void testHandleIsVisibleSelfService() {
    Task testTask  = TestDataFactory.createTestTaskUDB();
    System.Test.startTest();
    insert testTask;
    System.Test.stopTest();
  }

  /**
  * Tests the updating of Account sales status and phone number status values
  */
  @isTest
  static void testUpdatePhoneNumber() {
    Account testPersonAccount = TestDataFactory.createAndInsertTestPersonAccount();
    Phone_Number__c testPersonPhone = TestDataFactory.createAndInsertTestPhoneNumber(testPersonAccount);
    Task testTask = TestDataFactory.createTestTask(testPersonPhone);
    testTask.CallDisposition = 'Correct Contact';
    testTask.Status = 'Completed';
    
    System.Test.startTest();
    insert testTask;
    System.Test.stopTest();
        
    testPersonAccount = [
                        SELECT  Id,
                                Sales_Status_Person__c
                        FROM    Account
                        WHERE   Id = :testPersonAccount.Id
                    ];
        
    system.assertEquals( 'Contact Made', testPersonAccount.Sales_Status_Person__c );
        
    testPersonPhone =   [
                            SELECT  Status__c
                            FROM    Phone_Number__c
                            WHERE   Id = :testPersonPhone.Id
                        ];
        
    system.assertEquals( testTask.CallDisposition, testPersonPhone.Status__c );
  }
  
  /**
  * Tests the handleNeustarFieldPopulation
  */
  @isTest
  static void testHandleNeustarFieldPopulation() {
    Account testPersonAccount = TestDataFactory.createAndInsertTestPersonAccount();
    Phone_Number__c testPersonPhone = TestDataFactory.createTestPhoneNumber(testPersonAccount);
    testPersonPhone.Neustar_MPIC_Phone_Score__c = 90;
    testPersonPhone.Neustar_Phone_Validation__c = 50;
    insert testPersonPhone;
    
    Task testTask = TestDataFactory.createTestTask(testPersonPhone);
    
    System.Test.startTest();
    insert testTask;
    System.Test.stopTest();
        
    testTask =  [
                        SELECT  Neustar_MPIC_Phone_Score__c,
                                Neustar_Phone_Validation__c
                        FROM    Task
                        WHERE   Id = :testTask.Id
                    ];
        
    system.assertEquals(90, testTask.Neustar_MPIC_Phone_Score__c);
    system.assertEquals(50, testTask.Neustar_Phone_Validation__c);
  }
  
  /**
  * Tests the handleEmailToSalesforceType
  */
  @isTest
  static void testHandleEmailToSalesforceType() {
    Account testPersonAccount = TestDataFactory.createAndInsertTestPersonAccount();
    
    Task testTask = TestDataFactory.createTestTask(testPersonAccount,1,false)[0];
    testTask.Subject = 'Email: Test';
    testTask.Type = null;
    
    System.Test.startTest();
    insert testTask;
    System.Test.stopTest();
        
    testTask =  [
                        SELECT  Type
                        FROM    Task
                        WHERE   Id = :testTask.Id
                    ];
        
    system.assertEquals('Email', testTask.Type);
  }
  
  /**
  * Tests the handleParentLastActivityDateUpdate
  */
  @isTest
  static void testHandleParentLastActivityDateUpdate() {
  	TriggerValidator.setIsTest();
  	List<User> testUserList = [SELECT UserRoleId, UserRole.Name FROM User WHERE Username LIKE 'test@testusertrigger.org.%'];
  	User u = testUserList[0];
    Lead l = new Lead(FirstName='Test',
  							LastName='Contact',
  							Email='testcontact@test.com',
  							Company = 'Test Company',
  							Last_Activity_SFDC2__c = Date.today().addDays(-10),
  							SFDC2__c = true,
  							OwnerId=u.Id);
  	insert l;
  	l = [SELECT Last_Activity_SFDC2__c, Owner.Name FROM Lead WHERE Id = :l.Id];
  	System.assertEquals(Date.today().addDays(-10), l.Last_Activity_SFDC2__c);
  	System.debug('Lead Owner = ' + l.Owner.Name);
  	
  	Account a = TestDataFactory.createAndInsertTestBusinessAccount();
  	Opportunity o = new Opportunity(AccountId=a.Id, Name='Test', StageName='Open', LeadSource='Advisor', CloseDate=Date.today(), Last_Activity_SFDC2__c=Date.today().addDays(-10), OwnerId = u.Id);
  	insert o;
  	o = [SELECT Last_Activity_SFDC2__c, Owner.Name FROM Opportunity WHERE Id = :o.Id];
  	System.assertEquals(Date.today().addDays(-10), o.Last_Activity_SFDC2__c);
  	System.debug('Opportunity Owner = ' + o.Owner.Name);
  	
    List<Task> testTask = TestDataFactory.createTestTask(l,1,true);
    testTask.add(new Task(OwnerId=u.Id, WhatId=o.Id, Subject='Test Task', Priority='Low', Status='New', Type='Call', CallType='Outbound', ActivityDate=Date.today()));
    
    System.runAs(u) {
	    System.Test.startTest();
	    insert testTask;
	    System.Test.stopTest();
    }
        
    l = [SELECT Last_Activity_SFDC2__c FROM Lead WHERE Id = :l.Id];
    o = [SELECT Last_Activity_SFDC2__c FROM Opportunity WHERE Id = :o.Id];
        
    System.assertEquals(Date.today(), l.Last_Activity_SFDC2__c);
    System.assertEquals(Date.today(), o.Last_Activity_SFDC2__c);
  }
}