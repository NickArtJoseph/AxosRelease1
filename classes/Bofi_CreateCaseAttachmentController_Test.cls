@IsTest

private class Bofi_CreateCaseAttachmentController_Test {
 
    @isTest static void testcreateUBDCaseAttachment() {
         Id recordId = createTestRecord();
        RestRequest request = new RestRequest();
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'text/plain');
        request.requestBody = Blob.valueOf('{'+
        '   \"casedetails\": {'+
        '       \"CaseIdForAttach\": \"'+recordId+'\"'+
        '   },'+
        '  '+
        ' \"attachments\": [{'+
        '       \"Body\": \"d29ybGQ=\",       '+
        '                                                \"ContentType\": \"text/plain\",       '+
        '                                                \"Name\": \"hello.txt\"'+
        '   }, '+
        '                                {'+
        '       \"Body\": \"iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAA\",      '+
        '                                                 \"ContentType\": \"image/png\",       '+
        '                                                \"Name\": \"picture.png\"'+
        '   }]'+
        '}');
        RestContext.request = request;

        // Call the method to test
        String thisCaseId = Bofi_CreateCaseAttachmentController.doPost();  
        
     //   System.assert(thisCaseId != null);
     //   System.assertEquals('An Attachment Records Created in SF For the Requested Case Id :--'+thisCaseId, 'An Attachment Records Created in SF For the Requested Case Id :--'+recordId);        

    }  
    
    static Id createTestRecord() {

        // Create test record
        Case caseTest = new Case(
                    UDB_User_ID__c='1-2345', 
                    UDB_Dropdown_1__c='Category', 
                    UDB_Subject__c='Subject', 
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
}