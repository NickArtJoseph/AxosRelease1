@isTest
private class Case_Attachment_Test {

	static string instance = System.Url.getSalesforceBaseUrl().toExternalForm();

	@isTest static void testGetAttachment() {
		Case c = new Case(
			Origin = 'UDB',
	        Priority = 'Standard',
	        Status = 'New',
	        UDB_CIF__c = 'Test_CIF_att',
	        Description = 'Running Test',
	        recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('UDB Inquiry').getRecordTypeId()
		);
		insert c;
	
		Blob bodyBlob = Blob.valueOf('Test_Att');
	
		Attachment a = new Attachment(
			ParentId = c.Id,
			Body = bodyBlob,
			Name = 'Test_Att'
		);
		
		insert a;

		String fileName = a.Name;
		String caseId = c.Id;

		System.debug('CASE ID: ' + caseId);
		System.debug('FILE NAME: ' + fileName);

		RestRequest req = new RestRequest();
    	req.httpMethod = 'GET';
    	req.params.put('id', caseId);
    	req.params.put('file', fileName);
    	req.requestURI = '/services/apexrest/UDB_Case_Attachments?';
    	
    	RestContext.request = req;
    	System.debug('What has the request ' + req.requestURI + req.params);

    	String attachment = Case_Attachments.getAttachment();

    	System.assert(attachment != null);
	}
}