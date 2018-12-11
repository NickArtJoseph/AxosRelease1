@isTest 
private class UDBCaseHistory_Test {
  
  static string instance = System.Url.getSalesforceBaseUrl().toExternalForm();
  
  static Id createTestRecords() {
      Case caseTest = new Case(
         Origin = 'UDB',
         Priority = 'Standard',
         Status = 'New',
         UDB_CIF__c = 'xxx111',
         Description = 'Running Test',
            recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('UDB Inquiry').getRecordTypeId());

        insert caseTest;

        return caseTest.Id;
    }

    @isTest static void testGetCaseByCIF() {
      ID cid = createTestRecords();

      RestRequest request = new RestRequest();
      request.requestURI = instance+'/services/apexrest/UDBCaseHistory/'+cid;
      request.httpMethod = 'GET';
      RestContext.request = request;

      Case testCase = UDBCaseHistory.getUDBCaseDetail();

      System.assert(testCase != null);
    }    
}