@isTest 
private class UDB_Change_Case_Status_Test {
	
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
    @isTest static void testUpdateCaseStatus() {
    	String caseId = createTestRecords();
    	String newStatus = 'In Progress';
    	System.debug('THE CASE ID' + caseId);
    	RestRequest request = new RestRequest();
    	request.params.put('id', caseId);
    	request.params.put('status', newStatus);
    	request.requestURI = '/services/apexrest/UDB_Case_Details?';
    	request.httpMethod = 'POST';
    	RestContext.request = request;

    	System.debug(RestContext.request);
    	String testUpdate = UDB_Change_Case_Status.updateStatus();

    	System.assert(testUpdate == 'In Progress');
    }    
}