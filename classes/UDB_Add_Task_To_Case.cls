@RestResource(urlMapping='/UDB_Add_Task_To_Case/*')
global with sharing class UDB_Add_Task_To_Case {
	
	@HttpPost
	global static String insertMessage() {
		RestRequest req = RestContext.request;
		String caseId = req.params.get('id');
		String messageSubject = req.params.get('tSubject');
		List<UDB_Secure_Messaging__c> messageList = new List<UDB_Secure_Messaging__c>();
		String msg;
		Case c;
		UDB_Secure_Messaging__c sm = new UDB_Secure_Messaging__c();

		if(caseId != null || caseId != '') {


			c = [select Id, caseNumber from Case where Id =:caseId];
			
			sm.Related_To__c = c.Id;
			sm.Description__c = messageSubject;
			sm.Customer_Read__c = System.now();
			sm.ActivityDate__c = System.today();
			insert sm;

			for(UDB_Secure_Messaging__c notRead : [select Id, Customer_Read__c from UDB_Secure_Messaging__c where Related_To__r.Id =: c.Id and Customer_Read__c = null]) {
				messageList.add(notRead);
			}
			if(messageList.size() > 0) {
				c.IsVisibleSelfService__c = true;
				update c;
			}

			msg = 'USDB Secure Message was created Message comments:' + sm.Description__c;
			return msg;
		}
		else { 
			msg = 'Error while adding messages, please review the Case Id';
			return msg;
		}
	}
}