/***

    Author: René Ayala Medina
    Description: Test class to validate the integration SFDC - Marketo to send alerts when a secure message is created.
    
    Version Developer             Date          Description
    0.1     René Ayala Medina RAM 05/02/2018    Class created
    0.2     René Ayala Medina RAM 05/02/2018    Building the class
    1.0     René Ayala Medina RAM 06/07/2018    Documentation and testing
    1.1     René Ayala Medina RAM 06/11/2018    New test methods and testing (update lead brand)

***/

@isTest
private class UDB_SecureMessagingMarketoMethods_tst {

    /*
        Method to initialized the test data
    */
    
    @testSetup static void initData(){
        List<Contact> lstContactsToInsert = new List<Contact>{
            new Contact(
                FirstName = 'Test',
                LastName = 'Contact 1',
                Email = 'test@emil1.com'
            ),
            new Contact(
                FirstName = 'Test',
                LastName = 'Contact 2',
                Email = 'test@emil2.com'
            )
        };
        Database.insert(lstContactsToInsert);
        List<Case> lstCasesToInsert = new List<Case>{
            new Case(
                Subject = 'Test case 1',
                Status = 'New',
                ContactId = lstContactsToInsert.get(0).Id,
                UDB_CIF__c = 'XXX215',
                Brand__c = 'Bank x'
            ),
            new Case(
                Subject = 'Test case 1',
                Status = 'New',
                ContactId = lstContactsToInsert.get(1).Id,
                UDB_CIF__c = 'XXX213',
                Brand__c = 'Bank x'
            )
        };
        Database.insert(lstCasesToInsert);
    }

    /*
        The scenario where the message is -successfully- sent is validated #0.
    */
    
    @isTest static void shouldSendMessage0() {
        Test.loadData(MarketoAuthCreds__c.SObjectType, 'MarketoAuthCSV');
        UDB_SecureMessagingMarketoMethods_cls.testModeWS0 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS1 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS2 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS3 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS4 = 1;
        List<Case> lstCases = [SELECT Id FROM Case];
        List<Contact> lstContacts = [SELECT Id FROM Contact];
        UDB_Secure_Messaging__c secureMessageInstance = new UDB_Secure_Messaging__c(
            ActivityDate__c = Date.today(),
            Assigned_To__c = UserInfo.getUserId(),
            Description__c = 'Test',
            Priority__c = 'Normal',
            Status__c = 'In Progress',
            Type__c = 'Call',
            Related_To__c = lstCases.get(0).Id,
            Name__c = lstContacts.get(0).Id
        );
        Test.startTest();
            Database.insert(secureMessageInstance);
            UDB_SecureMessagingMarketoMethods_cls.sendMarketoEmail(new List<Id>{secureMessageInstance.Id});
        Test.stopTest();
    }

    /*
        The scenario where the message is -successfully- sent is validated #1.
    */
    
    @isTest static void shouldSendMessage1() {
        Test.loadData(MarketoAuthCreds__c.SObjectType, 'MarketoAuthCSV');
        UDB_SecureMessagingMarketoMethods_cls.testModeWS0 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS1 = 5;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS2 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS3 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS4 = 1;
        UDB_SecureMessagingMarketoMethods_cls.blnIsProductiveOrgSetTest = false;
        List<Case> lstCases = [SELECT Id FROM Case];
        List<Contact> lstContacts = [SELECT Id FROM Contact];
        UDB_Secure_Messaging__c secureMessageInstance = new UDB_Secure_Messaging__c(
            ActivityDate__c = Date.today(),
            Assigned_To__c = UserInfo.getUserId(),
            Description__c = 'Test',
            Priority__c = 'Normal',
            Status__c = 'In Progress',
            Type__c = 'Call',
            Related_To__c = lstCases.get(0).Id,
            Name__c = lstContacts.get(0).Id
        );
        Test.startTest();
            Database.insert(secureMessageInstance);
            UDB_SecureMessagingMarketoMethods_cls.sendMarketoEmail(new List<Id>{secureMessageInstance.Id});
        Test.stopTest();
    }

    /*
        The scenario where the message is -successfully- sent is validated #2.
    */
    
    @isTest static void shouldSendMessage2() {
        Test.loadData(MarketoAuthCreds__c.SObjectType, 'MarketoAuthCSV');
        UDB_SecureMessagingMarketoMethods_cls.testModeWS0 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS1 = 5;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS2 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS3 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS4 = 1;
        UDB_SecureMessagingMarketoMethods_cls.blnIsProductiveOrgSetTest = true;
        List<Case> lstCases = [SELECT Id FROM Case];
        List<Contact> lstContacts = [SELECT Id FROM Contact];
        UDB_Secure_Messaging__c secureMessageInstance = new UDB_Secure_Messaging__c(
            ActivityDate__c = Date.today(),
            Assigned_To__c = UserInfo.getUserId(),
            Description__c = 'Test',
            Priority__c = 'Normal',
            Status__c = 'In Progress',
            Type__c = 'Call',
            Related_To__c = lstCases.get(0).Id,
            Name__c = lstContacts.get(0).Id
        );
        Test.startTest();
            Database.insert(secureMessageInstance);
            UDB_SecureMessagingMarketoMethods_cls.sendMarketoEmail(new List<Id>{secureMessageInstance.Id});
        Test.stopTest();
    } 

    /*
        Method that validates when the access token fails getting retrieved #0
    */

    @isTest static void shouldNotRetrieveAccToken0() {
        UDB_SecureMessagingMarketoMethods_cls.blnIsProductiveOrgSetTest = true;
        Test.loadData(MarketoAuthCreds__c.SObjectType, 'MarketoAuthCSV');
        UDB_SecureMessagingMarketoMethods_cls.testModeWS0 = 0;
        List<Case> lstCases = [SELECT Id FROM Case];
        List<Contact> lstContacts = [SELECT Id FROM Contact];
        UDB_Secure_Messaging__c secureMessageInstance = new UDB_Secure_Messaging__c(
            ActivityDate__c = Date.today(),
            Assigned_To__c = UserInfo.getUserId(),
            Description__c = 'Test',
            Priority__c = 'Normal',
            Status__c = 'In Progress',
            Type__c = 'Call',
            Related_To__c = lstCases.get(0).Id,
            Name__c = lstContacts.get(0).Id
        );
        Test.startTest();
            Database.insert(secureMessageInstance);
            UDB_SecureMessagingMarketoMethods_cls.sendMarketoEmail(new List<Id>{secureMessageInstance.Id});
        Test.stopTest();
    }

    /*
        Method that validates when the access token fails getting retrieved #1
    */

    @isTest static void shouldNotRetrieveAccToken1() {
        UDB_SecureMessagingMarketoMethods_cls.blnIsProductiveOrgSetTest = true;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS0 = 1;
        List<Case> lstCases = [SELECT Id FROM Case];
        List<Contact> lstContacts = [SELECT Id FROM Contact];
        UDB_Secure_Messaging__c secureMessageInstance = new UDB_Secure_Messaging__c(
            ActivityDate__c = Date.today(),
            Assigned_To__c = UserInfo.getUserId(),
            Description__c = 'Test',
            Priority__c = 'Normal',
            Status__c = 'In Progress',
            Type__c = 'Call',
            Related_To__c = lstCases.get(0).Id,
            Name__c = lstContacts.get(0).Id
        );
        Test.startTest();
            Database.insert(secureMessageInstance);
            UDB_SecureMessagingMarketoMethods_cls.sendMarketoEmail(new List<Id>{secureMessageInstance.Id});
        Test.stopTest();
    }

    /*
        Method that validates when the lead ID fails getting retrieved #0
    */

    @isTest static void shouldNotRetrieveLeadID0() {
        UDB_SecureMessagingMarketoMethods_cls.blnIsProductiveOrgSetTest = true;
        Test.loadData(MarketoAuthCreds__c.SObjectType, 'MarketoAuthCSV');
        UDB_SecureMessagingMarketoMethods_cls.testModeWS0 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS1 = 0;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS2 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS3 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS4 = 1;
        List<Case> lstCases = [SELECT Id FROM Case];
        List<Contact> lstContacts = [SELECT Id FROM Contact];
        UDB_Secure_Messaging__c secureMessageInstance = new UDB_Secure_Messaging__c(
            ActivityDate__c = Date.today(),
            Assigned_To__c = UserInfo.getUserId(),
            Description__c = 'Test',
            Priority__c = 'Normal',
            Status__c = 'In Progress',
            Type__c = 'Call',
            Related_To__c = lstCases.get(0).Id,
            Name__c = lstContacts.get(0).Id
        );
        Test.startTest();
            Database.insert(secureMessageInstance);
            UDB_SecureMessagingMarketoMethods_cls.sendMarketoEmail(new List<Id>{secureMessageInstance.Id});
        Test.stopTest();
    }

    /*
        Method that validates when the lead ID fails getting retrieved #1
    */

    @isTest static void shouldNotRetrieveLeadID1() {
        UDB_SecureMessagingMarketoMethods_cls.blnIsProductiveOrgSetTest = true;
        Test.loadData(MarketoAuthCreds__c.SObjectType, 'MarketoAuthCSV');
        UDB_SecureMessagingMarketoMethods_cls.testModeWS0 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS1 = 2;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS2 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS3 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS4 = 1;
        List<Case> lstCases = [SELECT Id FROM Case];
        List<Contact> lstContacts = [SELECT Id FROM Contact];
        UDB_Secure_Messaging__c secureMessageInstance = new UDB_Secure_Messaging__c(
            ActivityDate__c = Date.today(),
            Assigned_To__c = UserInfo.getUserId(),
            Description__c = 'Test',
            Priority__c = 'Normal',
            Status__c = 'In Progress',
            Type__c = 'Call',
            Related_To__c = lstCases.get(0).Id,
            Name__c = lstContacts.get(0).Id
        );
        Test.startTest();
            Database.insert(secureMessageInstance);
            UDB_SecureMessagingMarketoMethods_cls.sendMarketoEmail(new List<Id>{secureMessageInstance.Id});
        Test.stopTest();
    }

    /*
        Method that validates when the lead ID fails getting retrieved #2
    */

    @isTest static void shouldNotRetrieveLeadID2() {
        UDB_SecureMessagingMarketoMethods_cls.blnIsProductiveOrgSetTest = true;
        Test.loadData(MarketoAuthCreds__c.SObjectType, 'MarketoAuthCSV');
        UDB_SecureMessagingMarketoMethods_cls.testModeWS0 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS1 = 3;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS2 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS3 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS4 = 1;
        List<Case> lstCases = [SELECT Id FROM Case];
        List<Contact> lstContacts = [SELECT Id FROM Contact];
        UDB_Secure_Messaging__c secureMessageInstance = new UDB_Secure_Messaging__c(
            ActivityDate__c = Date.today(),
            Assigned_To__c = UserInfo.getUserId(),
            Description__c = 'Test',
            Priority__c = 'Normal',
            Status__c = 'In Progress',
            Type__c = 'Call',
            Related_To__c = lstCases.get(0).Id,
            Name__c = lstContacts.get(0).Id
        );
        Test.startTest();
            Database.insert(secureMessageInstance);
            UDB_SecureMessagingMarketoMethods_cls.sendMarketoEmail(new List<Id>{secureMessageInstance.Id});
        Test.stopTest();
    }

    /*
        Method that validates when the lead ID fails getting retrieved #3
    */

    @isTest static void shouldNotRetrieveLeadID3() {
        UDB_SecureMessagingMarketoMethods_cls.blnIsProductiveOrgSetTest = true;
        Test.loadData(MarketoAuthCreds__c.SObjectType, 'MarketoAuthCSV');
        UDB_SecureMessagingMarketoMethods_cls.testModeWS0 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS1 = 4;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS2 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS3 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS4 = 1;
        List<Case> lstCases = [SELECT Id FROM Case];
        List<Contact> lstContacts = [SELECT Id FROM Contact];
        UDB_Secure_Messaging__c secureMessageInstance = new UDB_Secure_Messaging__c(
            ActivityDate__c = Date.today(),
            Assigned_To__c = UserInfo.getUserId(),
            Description__c = 'Test',
            Priority__c = 'Normal',
            Status__c = 'In Progress',
            Type__c = 'Call',
            Related_To__c = lstCases.get(0).Id,
            Name__c = lstContacts.get(0).Id
        );
        Test.startTest();
            Database.insert(secureMessageInstance);
            UDB_SecureMessagingMarketoMethods_cls.sendMarketoEmail(new List<Id>{secureMessageInstance.Id});
        Test.stopTest();
    }

    /*
        Method that validates when the lead brand update fails #0
    */

    @isTest static void shouldNotUpdateLeadBrandID0() {
        UDB_SecureMessagingMarketoMethods_cls.blnIsProductiveOrgSetTest = true;
        Test.loadData(MarketoAuthCreds__c.SObjectType, 'MarketoAuthCSV');
        UDB_SecureMessagingMarketoMethods_cls.testModeWS0 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS1 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS2 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS3 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS4 = 0;
        List<Case> lstCases = [SELECT Id FROM Case];
        List<Contact> lstContacts = [SELECT Id FROM Contact];
        UDB_Secure_Messaging__c secureMessageInstance = new UDB_Secure_Messaging__c(
            ActivityDate__c = Date.today(),
            Assigned_To__c = UserInfo.getUserId(),
            Description__c = 'Test',
            Priority__c = 'Normal',
            Status__c = 'In Progress',
            Type__c = 'Call',
            Related_To__c = lstCases.get(0).Id,
            Name__c = lstContacts.get(0).Id
        );
        Test.startTest();
            Database.insert(secureMessageInstance);
            UDB_SecureMessagingMarketoMethods_cls.sendMarketoEmail(new List<Id>{secureMessageInstance.Id});
        Test.stopTest();
    }

    /*
        Method that validates when the lead brand update fails #1
    */

    @isTest static void shouldNotUpdateLeadBrandID1() {
        UDB_SecureMessagingMarketoMethods_cls.blnIsProductiveOrgSetTest = true;
        Test.loadData(MarketoAuthCreds__c.SObjectType, 'MarketoAuthCSV');
        UDB_SecureMessagingMarketoMethods_cls.testModeWS0 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS1 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS2 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS3 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS4 = 2;
        List<Case> lstCases = [SELECT Id FROM Case];
        List<Contact> lstContacts = [SELECT Id FROM Contact];
        UDB_Secure_Messaging__c secureMessageInstance = new UDB_Secure_Messaging__c(
            ActivityDate__c = Date.today(),
            Assigned_To__c = UserInfo.getUserId(),
            Description__c = 'Test',
            Priority__c = 'Normal',
            Status__c = 'In Progress',
            Type__c = 'Call',
            Related_To__c = lstCases.get(0).Id,
            Name__c = lstContacts.get(0).Id
        );
        Test.startTest();
            Database.insert(secureMessageInstance);
            UDB_SecureMessagingMarketoMethods_cls.sendMarketoEmail(new List<Id>{secureMessageInstance.Id});
        Test.stopTest();
    }

    /*
        Method that validates when the lead brand update fails #2
    */

    @isTest static void shouldNotUpdateLeadBrandID2() {
        UDB_SecureMessagingMarketoMethods_cls.blnIsProductiveOrgSetTest = true;
        Test.loadData(MarketoAuthCreds__c.SObjectType, 'MarketoAuthCSV');
        UDB_SecureMessagingMarketoMethods_cls.testModeWS0 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS1 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS2 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS3 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS4 = 3;
        List<Case> lstCases = [SELECT Id FROM Case];
        List<Contact> lstContacts = [SELECT Id FROM Contact];
        UDB_Secure_Messaging__c secureMessageInstance = new UDB_Secure_Messaging__c(
            ActivityDate__c = Date.today(),
            Assigned_To__c = UserInfo.getUserId(),
            Description__c = 'Test',
            Priority__c = 'Normal',
            Status__c = 'In Progress',
            Type__c = 'Call',
            Related_To__c = lstCases.get(0).Id,
            Name__c = lstContacts.get(0).Id
        );
        Test.startTest();
            Database.insert(secureMessageInstance);
            UDB_SecureMessagingMarketoMethods_cls.sendMarketoEmail(new List<Id>{secureMessageInstance.Id});
        Test.stopTest();
    }

    /*
        Method that validates when the lead brand update fails #3
    */

    @isTest static void shouldNotUpdateLeadBrandID3() {
        UDB_SecureMessagingMarketoMethods_cls.blnIsProductiveOrgSetTest = true;
        Test.loadData(MarketoAuthCreds__c.SObjectType, 'MarketoAuthCSV');
        UDB_SecureMessagingMarketoMethods_cls.testModeWS0 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS1 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS2 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS3 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS4 = 4;
        List<Case> lstCases = [SELECT Id FROM Case];
        List<Contact> lstContacts = [SELECT Id FROM Contact];
        UDB_Secure_Messaging__c secureMessageInstance = new UDB_Secure_Messaging__c(
            ActivityDate__c = Date.today(),
            Assigned_To__c = UserInfo.getUserId(),
            Description__c = 'Test',
            Priority__c = 'Normal',
            Status__c = 'In Progress',
            Type__c = 'Call',
            Related_To__c = lstCases.get(0).Id,
            Name__c = lstContacts.get(0).Id
        );
        Test.startTest();
            Database.insert(secureMessageInstance);
            UDB_SecureMessagingMarketoMethods_cls.sendMarketoEmail(new List<Id>{secureMessageInstance.Id});
        Test.stopTest();
    }

    /*
        Method that validates when the campaing ID fails getting retrieved #0
    */

    @isTest static void shouldNotRetrieveCampaignID0() {
        UDB_SecureMessagingMarketoMethods_cls.blnIsProductiveOrgSetTest = true;
        Test.loadData(MarketoAuthCreds__c.SObjectType, 'MarketoAuthCSV');
        UDB_SecureMessagingMarketoMethods_cls.testModeWS0 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS1 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS2 = 0;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS3 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS4 = 1;
        List<Case> lstCases = [SELECT Id FROM Case];
        List<Contact> lstContacts = [SELECT Id FROM Contact];
        UDB_Secure_Messaging__c secureMessageInstance = new UDB_Secure_Messaging__c(
            ActivityDate__c = Date.today(),
            Assigned_To__c = UserInfo.getUserId(),
            Description__c = 'Test',
            Priority__c = 'Normal',
            Status__c = 'In Progress',
            Type__c = 'Call',
            Related_To__c = lstCases.get(0).Id,
            Name__c = lstContacts.get(0).Id
        );
        Test.startTest();
            Database.insert(secureMessageInstance);
            UDB_SecureMessagingMarketoMethods_cls.sendMarketoEmail(new List<Id>{secureMessageInstance.Id});
        Test.stopTest();
    }

    /*
        Method that validates when the campaing ID fails getting retrieved #1
    */

    @isTest static void shouldNotRetrieveCampaignID1() {
        UDB_SecureMessagingMarketoMethods_cls.blnIsProductiveOrgSetTest = true;
        Test.loadData(MarketoAuthCreds__c.SObjectType, 'MarketoAuthCSV');
        UDB_SecureMessagingMarketoMethods_cls.testModeWS0 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS1 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS2 = 2;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS3 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS4 = 1;
        List<Case> lstCases = [SELECT Id FROM Case];
        List<Contact> lstContacts = [SELECT Id FROM Contact];
        UDB_Secure_Messaging__c secureMessageInstance = new UDB_Secure_Messaging__c(
            ActivityDate__c = Date.today(),
            Assigned_To__c = UserInfo.getUserId(),
            Description__c = 'Test',
            Priority__c = 'Normal',
            Status__c = 'In Progress',
            Type__c = 'Call',
            Related_To__c = lstCases.get(0).Id,
            Name__c = lstContacts.get(0).Id
        );
        Test.startTest();
            Database.insert(secureMessageInstance);
            UDB_SecureMessagingMarketoMethods_cls.sendMarketoEmail(new List<Id>{secureMessageInstance.Id});
        Test.stopTest();
    }

    /*
        Method that validates when the campaing ID fails getting retrieved #2
    */

    @isTest static void shouldNotRetrieveCampaignID2() {
        UDB_SecureMessagingMarketoMethods_cls.blnIsProductiveOrgSetTest = true;
        Test.loadData(MarketoAuthCreds__c.SObjectType, 'MarketoAuthCSV');
        UDB_SecureMessagingMarketoMethods_cls.testModeWS0 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS1 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS2 = 3;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS3 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS4 = 1;
        List<Case> lstCases = [SELECT Id FROM Case];
        List<Contact> lstContacts = [SELECT Id FROM Contact];
        UDB_Secure_Messaging__c secureMessageInstance = new UDB_Secure_Messaging__c(
            ActivityDate__c = Date.today(),
            Assigned_To__c = UserInfo.getUserId(),
            Description__c = 'Test',
            Priority__c = 'Normal',
            Status__c = 'In Progress',
            Type__c = 'Call',
            Related_To__c = lstCases.get(0).Id,
            Name__c = lstContacts.get(0).Id
        );
        Test.startTest();
            Database.insert(secureMessageInstance);
            UDB_SecureMessagingMarketoMethods_cls.sendMarketoEmail(new List<Id>{secureMessageInstance.Id});
        Test.stopTest();
    }

    /*
        Method that validates when the campaing ID fails getting retrieved #3
    */

    @isTest static void shouldNotRetrieveCampaignID3() {
        UDB_SecureMessagingMarketoMethods_cls.blnIsProductiveOrgSetTest = true;
        Test.loadData(MarketoAuthCreds__c.SObjectType, 'MarketoAuthCSV');
        UDB_SecureMessagingMarketoMethods_cls.testModeWS0 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS1 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS2 = 4;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS3 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS4 = 1;
        List<Case> lstCases = [SELECT Id FROM Case];
        List<Contact> lstContacts = [SELECT Id FROM Contact];
        UDB_Secure_Messaging__c secureMessageInstance = new UDB_Secure_Messaging__c(
            ActivityDate__c = Date.today(),
            Assigned_To__c = UserInfo.getUserId(),
            Description__c = 'Test',
            Priority__c = 'Normal',
            Status__c = 'In Progress',
            Type__c = 'Call',
            Related_To__c = lstCases.get(0).Id,
            Name__c = lstContacts.get(0).Id
        );
        Test.startTest();
            Database.insert(secureMessageInstance);
            UDB_SecureMessagingMarketoMethods_cls.sendMarketoEmail(new List<Id>{secureMessageInstance.Id});
        Test.stopTest();
    }

    /*
        Method that validates when the campaign isn't retrieved #0
    */

    @isTest static void shouldNotTriggerCampaign0() {
        UDB_SecureMessagingMarketoMethods_cls.blnIsProductiveOrgSetTest = true;
        Test.loadData(MarketoAuthCreds__c.SObjectType, 'MarketoAuthCSV');
        UDB_SecureMessagingMarketoMethods_cls.testModeWS0 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS1 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS2 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS3 = 0;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS4 = 1;
        List<Case> lstCases = [SELECT Id FROM Case];
        List<Contact> lstContacts = [SELECT Id FROM Contact];
        UDB_Secure_Messaging__c secureMessageInstance = new UDB_Secure_Messaging__c(
            ActivityDate__c = Date.today(),
            Assigned_To__c = UserInfo.getUserId(),
            Description__c = 'Test',
            Priority__c = 'Normal',
            Status__c = 'In Progress',
            Type__c = 'Call',
            Related_To__c = lstCases.get(0).Id,
            Name__c = lstContacts.get(0).Id
        );
        Test.startTest();
            Database.insert(secureMessageInstance);
            UDB_SecureMessagingMarketoMethods_cls.sendMarketoEmail(new List<Id>{secureMessageInstance.Id});
        Test.stopTest();
    }

    /*
        Method that validates when the campaign isn't retrieved #1
    */

    @isTest static void shouldNotTriggerCampaign1() {
        UDB_SecureMessagingMarketoMethods_cls.blnIsProductiveOrgSetTest = true;
        Test.loadData(MarketoAuthCreds__c.SObjectType, 'MarketoAuthCSV');
        UDB_SecureMessagingMarketoMethods_cls.testModeWS0 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS1 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS2 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS3 = 2;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS4 = 1;
        List<Case> lstCases = [SELECT Id FROM Case];
        List<Contact> lstContacts = [SELECT Id FROM Contact];
        UDB_Secure_Messaging__c secureMessageInstance = new UDB_Secure_Messaging__c(
            ActivityDate__c = Date.today(),
            Assigned_To__c = UserInfo.getUserId(),
            Description__c = 'Test',
            Priority__c = 'Normal',
            Status__c = 'In Progress',
            Type__c = 'Call',
            Related_To__c = lstCases.get(0).Id,
            Name__c = lstContacts.get(0).Id
        );
        Test.startTest();
            Database.insert(secureMessageInstance);
            UDB_SecureMessagingMarketoMethods_cls.sendMarketoEmail(new List<Id>{secureMessageInstance.Id});
        Test.stopTest();
    }

    /*
        Method that validates when the campaign isn't retrieved #2
    */

    @isTest static void shouldNotTriggerCampaign2() {
        UDB_SecureMessagingMarketoMethods_cls.blnIsProductiveOrgSetTest = true;
        Test.loadData(MarketoAuthCreds__c.SObjectType, 'MarketoAuthCSV');
        UDB_SecureMessagingMarketoMethods_cls.testModeWS0 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS1 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS2 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS3 = 3;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS4 = 1;
        List<Case> lstCases = [SELECT Id FROM Case];
        List<Contact> lstContacts = [SELECT Id FROM Contact];
        UDB_Secure_Messaging__c secureMessageInstance = new UDB_Secure_Messaging__c(
            ActivityDate__c = Date.today(),
            Assigned_To__c = UserInfo.getUserId(),
            Description__c = 'Test',
            Priority__c = 'Normal',
            Status__c = 'In Progress',
            Type__c = 'Call',
            Related_To__c = lstCases.get(0).Id,
            Name__c = lstContacts.get(0).Id
        );
        Test.startTest();
            Database.insert(secureMessageInstance);
            UDB_SecureMessagingMarketoMethods_cls.sendMarketoEmail(new List<Id>{secureMessageInstance.Id});
        Test.stopTest();
    }

    /*
        Method that validates when the campaign isn't retrieved #3
    */

    @isTest static void shouldNotTriggerCampaign3() {
        UDB_SecureMessagingMarketoMethods_cls.blnIsProductiveOrgSetTest = true;
        Test.loadData(MarketoAuthCreds__c.SObjectType, 'MarketoAuthCSV');
        UDB_SecureMessagingMarketoMethods_cls.testModeWS0 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS1 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS2 = 1;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS3 = 4;
        UDB_SecureMessagingMarketoMethods_cls.testModeWS4 = 1;
        List<Case> lstCases = [SELECT Id FROM Case];
        List<Contact> lstContacts = [SELECT Id FROM Contact];
        UDB_Secure_Messaging__c secureMessageInstance = new UDB_Secure_Messaging__c(
            ActivityDate__c = Date.today(),
            Assigned_To__c = UserInfo.getUserId(),
            Description__c = 'Test',
            Priority__c = 'Normal',
            Status__c = 'In Progress',
            Type__c = 'Call',
            Related_To__c = lstCases.get(0).Id,
            Name__c = lstContacts.get(0).Id
        );
        Test.startTest();
            Database.insert(secureMessageInstance);
            UDB_SecureMessagingMarketoMethods_cls.sendMarketoEmail(new List<Id>{secureMessageInstance.Id});
        Test.stopTest();
    }

    /*
        The scenario where the message is not send due to the user (UDB integration) is validated.
    */

    @isTest static void shouldNotTriggerMessageSending() {
        UDB_SecureMessagingMarketoMethods_cls.blnIsProductiveOrgSetTest = true;
        Test.loadData(MarketoAuthCreds__c.SObjectType, 'MarketoAuthCSV');
        List<Case> lstCases = [SELECT Id FROM Case];
        List<Contact> lstContacts = [SELECT Id FROM Contact];
        User udbIntegrationUserInstance = new User();
        try{udbIntegrationUserInstance = [SELECT Id, Name FROM User WHERE FirstName =: 'UDB' AND LastName =: 'Integration'];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
        if(udbIntegrationUserInstance.Id != null){
            List<SObject> lstSOs = new List<SObject>();
            for(Case iterator:lstCases){
                iterator.OwnerId = udbIntegrationUserInstance.Id;
                lstSOs.add(iterator);
            }
            for(Contact iterator:lstContacts){
                iterator.OwnerId = udbIntegrationUserInstance.Id;
                lstSOs.add(iterator);
            }
            Database.update(lstSOs);
            System.runAs(udbIntegrationUserInstance){
                UDB_Secure_Messaging__c secureMessageInstance = new UDB_Secure_Messaging__c(
                    ActivityDate__c = Date.today(),
                    Assigned_To__c = UserInfo.getUserId(),
                    Description__c = 'Test',
                    Priority__c = 'Normal',
                    Status__c = 'In Progress',
                    Type__c = 'Call',
                    Related_To__c = lstCases.get(0).Id,
                    Name__c = lstContacts.get(0).Id
                );
                Test.startTest();
                    Database.insert(secureMessageInstance);
                    UDB_SecureMessagingMarketoMethods_cls.sendMarketoEmail(new List<Id>{secureMessageInstance.Id});
                Test.stopTest();
            }
        }
    }

    /*
        Sub-wrappers are covered since there is no way to cover them in an ordinary flow
    */

    @isTest static void instantiateRemainingWrappers() {
        UDB_SecureMessagingMarketoMethods_cls.CampaignQueryResult campaignQueryResultInstance = new UDB_SecureMessagingMarketoMethods_cls.CampaignQueryResult();
        UDB_SecureMessagingMarketoMethods_cls.LeadIdResult leadIdResultInstance = new UDB_SecureMessagingMarketoMethods_cls.LeadIdResult();
        UDB_SecureMessagingMarketoMethods_cls.TriggerCampaignResult triggerCampaignResultInstance = new UDB_SecureMessagingMarketoMethods_cls.TriggerCampaignResult();
        UDB_SecureMessagingMarketoMethods_cls.WSError wSErrorInstance = new UDB_SecureMessagingMarketoMethods_cls.WSError();
        UDB_SecureMessagingMarketoMethods_cls.UpdtLeadReslt updtLeadResltInstance = new UDB_SecureMessagingMarketoMethods_cls.UpdtLeadReslt();
    }
    
}