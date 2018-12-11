@IsTest

private class Bofi_UBDCaseController_Test {
 

    @isTest static void testGetCaseById() {

        Id recordId = createTestRecord();

        // Set up a test request
        RestRequest request = new RestRequest();

        request.requestUri =
            'https://bofi--sfdc2qa.cs67.my.salesforce.com/services/apexrest/Bofi_UBDCases/'
            + recordId;

        request.httpMethod = 'GET';

        RestContext.request = request;

        // Call the method to test
        Id thisCase_Id = Bofi_UBDCaseController.getUBDCaseById();

        // Verify results
        System.assert(thisCase_Id != null);

        System.assertEquals(recordId, thisCase_Id);

    }
    
    @isTest static void testcreateUBDCase() {

        // Call the method to test
        ID thisCaseId = Bofi_UBDCaseController.createUBDCase(
            '1-2345', 'Category', 'Sub category', 'Test Description', 'Test CIF', 'New', '9068765432', 'Test@test.com', 'Computer', 'Google Chrome', '9');

        // Verify results
        System.assert(thisCaseId != null);

        Case thisCase = [SELECT Id,Description FROM Case WHERE Id=:thisCaseId];

        System.assert(thisCase != null);

        System.assertEquals(thisCase.Description, 'Test Description');

    }

 
    // Helper method

    static Id createTestRecord() {

        // Create test record
        Case caseTest = new Case(
                    UDB_User_ID__c='1-2345', 
                    UDB_Dropdown_1__c='Category', 
                    UDB_Dropdown_2__c='Sub category', 
                    //Subject=Body_of_the_message, 
                    Description='Test Description',
                    UDB_CIF__c='Test CIF', 
                    Status='New', 
                    UDB_Phone__c='9068765432', 
                    UDB_Email__c='Test@test.com',
                    Device_Type__c='Computer',
                    Browser_Type__c='Google Chrome',
                    Browser_Version__c='9',                    
                    Origin='UDB',
                    recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('UDB Inquiry').getRecordTypeId());

        insert caseTest;

        return caseTest.Id;
    } 
    static Id createTestRecord1() {

        // Create test record
        Case caseTest1 = new Case(
                    UDB_User_ID__c='1-2345', 
                    UDB_Dropdown_1__c='Category', 
                    UDB_Dropdown_2__c='Sub category', 
                    //Subject=Body_of_the_message, 
                    Description='Test Description',
                    UDB_CIF__c='Test CIF', 
                    Status='New', 
                    UDB_Phone__c='9068765432', 
                    UDB_Email__c='Test@test.com',
                    Device_Type__c='Computer',
                    Browser_Type__c='Google Chrome',
                    Browser_Version__c='9',                    
                    Origin='UDB',
                    recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('UDB Inquiry').getRecordTypeId());

        insert caseTest1;

        return caseTest1.Id;
    } 
}