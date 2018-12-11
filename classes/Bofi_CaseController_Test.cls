/***

    Author: Jaime Terrats
    Description: Test class to validate the behavior of the SFDC custom REST web service that creates cases with the provided data inputs.
    
    Version Developer             Date          Description
    1.0     Jaime Terrats JT      02/22/2018    Test class created
    1.1     René Ayala Medina RAM 06/12/2018    Brand name support was added
   
***/

@IsTest
private class Bofi_CaseController_Test {
    
    @isTest static void testcreateUBDCase() {
        String recordId = createTestAccount();
        // Call the method to test
        ID thisCaseId = Bofi_CaseController.createCase(
            '1-2345',recordId, 'Category', 'Subject', 'Test Description', 'Test CIF', 'New', '9068765432', 'Test@test.com','Bank X'
        );
        // Verify results
        System.assert(thisCaseId != null);
        Case thisCase = [SELECT Id,UDB_Case_Description__c FROM Case WHERE Id=:thisCaseId];
        System.assert(thisCase != null);
        System.assertEquals(thisCase.UDB_Case_Description__c, 'Test Description');

    }
 
    // Helper method

    static Id createTestRecord() {
        // Create test record
        Case caseTest = new Case(
            UDB_User_ID__c='1-2345', 
            UDB_Dropdown_1__c='Category', 
            UDB_Subject__c='Subject', 
            //Subject=Body_of_the_message, 
            UDB_Case_Description__c='Test Description',
            UDB_CIF__c='Test CIF', 
            Status='New', 
            UDB_Phone__c='9068765432', 
            UDB_Email__c='Test@test.com',
            Device_Type__c='Computer',
            Browser_Type__c='Google Chrome',
            Browser_Version__c='9',                    
            Origin='UDB',
            recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('UDB Inquiry').getRecordTypeId()
        );
        insert caseTest;
        return caseTest.Id;
    } 
    static Id createTestRecord1() {
        // Create test record
        Case caseTest1 = new Case(
            UDB_User_ID__c='1-2345', 
            UDB_Dropdown_1__c='Category', 
            UDB_Subject__c='Subject', 
            //Subject=Body_of_the_message, 
            UDB_Case_Description__c='Test Description',
            UDB_CIF__c='Test CIF', 
            Status='New', 
            UDB_Phone__c='9068765432', 
            UDB_Email__c='Test@test.com',
            Device_Type__c='Computer',
            Browser_Type__c='Google Chrome',
            Browser_Version__c='9',                    
            Origin='UDB',
            recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('UDB Inquiry').getRecordTypeId()
        );
        insert caseTest1;
        return caseTest1.Id;
    } 
    
    static Id createTestAccount() {
        // Create test record
        Account accountTest = new Account(
            Name = 'test'
        );
        insert accountTest;
        Contact contactRecord = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test@email.com',
            AccountId = accountTest.Id
        );
        Database.insert(contactRecord);
        return accountTest.Id;
    } 
}