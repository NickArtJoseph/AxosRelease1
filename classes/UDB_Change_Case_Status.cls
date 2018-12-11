@RestResource(urlMapping='/UDB_Change_Case_Status/*')
global with sharing class UDB_Change_Case_Status {
	
	@HttpPost 
	global static String updateStatus() {		
		RestRequest req = RestContext.request;
		String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
		String caseId = req.params.get('id');
		String caseStatus = req.params.get('status');
		String msg;
		Case c;

		if(caseId != null || caseId != '' && caseStatus != '' || caseStatus != null) {
			c = [select Id,  Status, Re_opened_Counter__c from Case where Id =:caseId];
		
			c.Status = caseStatus;
			if(c.Re_opened_Counter__c == null) 
				c.Re_opened_Counter__c = 0;
			if(c.Status == 'Re-opened') {
				c.Re_opened_Counter__c = c.Re_opened_Counter__c + 1;
			}
			update c;
			return c.Status;
		}
		else{
			msg = 'Invalid ID';
			return msg;
		}
	}
}