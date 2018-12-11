@isTest 
private class UDB_Case_Details_Test {
	
	static string instance = System.Url.getSalesforceBaseUrl().toExternalForm();
	
	static String createTestRecords() {
    	Case caseTest = new Case(
     		Origin = 'UDB',
     		Priority = 'Standard',
     		Status = 'New',
     		UDB_CIF__c = 'xxx111',
     		Description = 'Running Test',
            recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('UDB Inquiry').getRecordTypeId());

        insert caseTest;

        return caseTest.UDB_CIF__c;
    }

    @isTest static void testGetCaseByCIF() {
    	String cif = createTestRecords();

    	RestRequest request = new RestRequest();
    	request.requestURI = instance+'/services/apexrest/UDB_Case_Details/'+cif;
    	request.httpMethod = 'GET';
    	RestContext.request = request;

    	List<Case> testCIF = UDB_Case_Details.getUDBCaseByCIF();

    	System.assert(testCIF != null);
    }    
}