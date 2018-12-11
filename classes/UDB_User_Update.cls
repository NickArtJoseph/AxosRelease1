@RestResource(urlMapping='/UDB_User_Update/*')
global with sharing class UDB_User_Update {
	
	@HttpPost 
	global static string updateData(String caseId) {
		RestRequest req = RestContext.request;
		String msg;

		if(caseId != null || caseId != '') {
			Case c = [select Id, IsVisibleSelfService__c from Case where Id =: caseId];
			List<UDB_Secure_Messaging__c> sm = [select Customer_Read__c from UDB_Secure_Messaging__c where Related_To__r.Id =: caseId and Customer_Read__c = null];
			for(UDB_Secure_Messaging__c msgs : sm) {
				msgs.Customer_Read__c = System.now();
				update msgs;
			}
			c.IsVisibleSelfService__c = false;
			update c;
			
			msg = 'Updated Case Data';
		}
		else {
			msg = 'Invalid Case Id.';
		}
		return msg;
	}
}