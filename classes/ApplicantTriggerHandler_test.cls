@isTest
private class ApplicantTriggerHandler_test {
    
    @testSetUp 
    static void testSetup() {
        Database.insert(new campaign(Name = 'Incomplete Application'));
        Database.insert(new campaign(Name = 'Abandoned Enrollment Opps'));
        Id partId = [select Id from RecordType where DeveloperName = 'Business_Consumer_Person_Account'].Id;
        Id lrtId = [select Id from RecordType where DeveloperName = 'Dealer_Services_Applicant_SFDC2' and SObjectType = 'Lead'].Id;
       
        Account a = new Account(
            FirstName = 'Test',
            LastName = 'Account',
            PersonHomePhone = '(123) 123-1234',
            PersonMobilePhone =  '(678) 678-6789',
            PersonEmail = 'test.contact@test.com',
            RecordTypeId = partId
        );

        insert a;

        Account a2 = new Account(
                FirstName = 'Test Enrollment',
                LastName = 'Account',
                PersonHomePhone = '(123) 123-1234',
                PersonMobilePhone =  '(678) 678-6789',
                PersonEmail = 'test.contact@test.com',
                RecordTypeId = partId
            );

        insert a2;

        Account a3 = new Account(
                FirstName = 'Test Enrollment 2',
                LastName = 'Account',
                PersonHomePhone = '(123) 123-1234',
                PersonMobilePhone =  '(678) 678-6789',
                PersonEmail = 'test.contact@test.com',
                RecordTypeId = partId
            );

        insert a3;

    }

    @isTest
    static void testProcessTCIApplicationForPersonAccount() {
        Test.startTest();
            Id tciRTId = [select Id from RecordType where DeveloperName = 'TCI' and SObjectType = 'Applicant_SFDC2__c'].Id;
            Id apptciRTId = [select Id from RecordType where DeveloperName = 'TCI' and SObjectType = 'Application_SFDC2__c'].Id;
            Application_SFDC2__c app = new Application_SFDC2__c(
                Name = 'Test Application',
                Application_Status__c = 'Pending',
                RecordTypeId = apptciRTId
            );
            insert app;
            Applicant_SFDC2__c applnt = new Applicant_SFDC2__c(
                Application_Id__c = app.Id,
                First_Name__c = 'Test',
                Last_Name__c = 'Account',
                Email__c = 'test.contact@test.com',
                RecordTypeId =  tciRTId
            );
            insert applnt;
        Test.stopTest();
    }

    @isTest
    static void testProcessTCIApplicationForPersonAccount2() {
        Test.startTest();
            Id tciRTId = [select Id from RecordType where DeveloperName = 'TCI' and SObjectType = 'Applicant_SFDC2__c'].Id;
            Id apptciRTId = [select Id from RecordType where DeveloperName = 'TCI' and SObjectType = 'Application_SFDC2__c'].Id;
            Application_SFDC2__c app = new Application_SFDC2__c(
                Name = 'Test Application',
                Application_Status__c = 'Approved',
                RecordTypeId = apptciRTId
            );
            insert app;
            Applicant_SFDC2__c applnt = new Applicant_SFDC2__c(
                Application_Id__c = app.Id,
                First_Name__c = 'Test',
                Last_Name__c = 'Account',
                Email__c = '',
                Cell_Phone__c = '(678) 678-6789',
                RecordTypeId =  tciRTId
            );
            insert applnt;
        Test.stopTest();
    }

    @isTest
    static void testProcessTCIApplicationForPersonAccount3() {
        Test.startTest();
            Id tciRTId = [select Id from RecordType where DeveloperName = 'TCI' and SObjectType = 'Applicant_SFDC2__c'].Id;
            Id apptciRTId = [select Id from RecordType where DeveloperName = 'TCI' and SObjectType = 'Application_SFDC2__c'].Id;
            Application_SFDC2__c app = new Application_SFDC2__c(
                Name = 'Test Application',
                Application_Status__c = 'Counter Offer',
                RecordTypeId = apptciRTId
            );
            insert app;
            Applicant_SFDC2__c applnt = new Applicant_SFDC2__c(
                Application_Id__c = app.Id,
                First_Name__c = 'Test',
                Last_Name__c = 'Account',
                Email__c = '',
                Cell_Phone__c = '(678) 678-6789',
                RecordTypeId =  tciRTId
            );
            insert applnt;
        Test.stopTest();
    }
    
    @isTest
    static void testProcessTCIApplicationForCreateLead() {
        Test.startTest();
            Id tciRTId = [select Id from RecordType where DeveloperName = 'TCI' and SObjectType = 'Applicant_SFDC2__c'].Id;
            Id apptciRTId = [select Id from RecordType where DeveloperName = 'TCI' and SObjectType = 'Application_SFDC2__c'].Id;
            Application_SFDC2__c app = new Application_SFDC2__c(
                Name = 'Test Application',
                Application_Status__c = 'Pending',
                RecordTypeId = apptciRTId
            );
            insert app;
            Applicant_SFDC2__c applnt = new Applicant_SFDC2__c(
                Application_Id__c = app.Id,
                First_Name__c = 'New',
                Last_Name__c = 'Lead',
                Email__c = 'new.lead@test.com',
                RecordTypeId =  tciRTId
            );
            insert applnt;
        Test.stopTest();
    }

    @isTest
    static void testProcessTCIApplicationForLeadConversion() {
        Test.startTest();
        Id tciRTId = [select Id from RecordType where DeveloperName = 'TCI' and SObjectType = 'Applicant_SFDC2__c'].Id;
        Id apptciRTId = [select Id from RecordType where DeveloperName = 'TCI' and SObjectType = 'Application_SFDC2__c'].Id;

        Application_SFDC2__c app = new Application_SFDC2__c(
                Name = 'Test Application Lead Conversion',
                Application_Status__c = 'Approved',
                RecordTypeId = apptciRTId
            );

        insert app;

        Applicant_SFDC2__c applnt = new Applicant_SFDC2__c(
                Application_Id__c = app.Id,
                First_Name__c = 'Test 3',
                Last_Name__c = 'Lead 3',
                Email__c = 'test.lead@test.com',
                RecordTypeId =  tciRTId
            );

        insert applnt;
        Test.stopTest();
    }

}