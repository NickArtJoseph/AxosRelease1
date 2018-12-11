@isTest
private class UDB_Add_Task_To_Case_Test {
	static string instance = System.Url.getSalesforceBaseUrl().toExternalForm();

	static String createTestRecords() {
    	Case caseTest = new Case(
     		Origin = 'UDB',
     		Priority = 'Standard',
     		Status = 'New',
     		Description = 'Running Test',
            recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('UDB Inquiry').getRecordTypeId());

        insert caseTest;

        return caseTest.Id;
    }
    @isTest 
    static void testInsertTask() {
    	String caseId = createTestRecords();
    	String tSubject = 'Subject test';

    	RestRequest request = new RestRequest();
    	request.params.put('id', caseId);
    	request.params.put('tSubject', tSubject);
    	request.requestURI = '/services/apexrest/UDB_Case_Details?';
    	request.httpMethod = 'POST';
    	RestContext.request = request;

    	String testInsert = UDB_Add_Task_To_Case.insertMessage();
    }    
}