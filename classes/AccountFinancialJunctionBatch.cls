global class AccountFinancialJunctionBatch implements Database.Batchable<sObject> {
	Map<Id, Person_Financial_Account_Junction__c> juncMap;

	global AccountFinancialJunctionBatch(Map<Id, Person_Financial_Account_Junction__c> juncMap) {
		this.juncMap = juncMap;
	}
	
	//Query method.
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator([SELECT Id, CIF_JHA_LINK__c, Person_Account__c, Financial_Account__c FROM Person_Financial_Account_Junction__c WHERE Id IN : juncMap.keySet()]);
	}
	
	//Execute Method.
	global void execute(Database.BatchableContext BC, List<Person_Financial_Account_Junction__c> juncList) {
		List<String> acctCifList = new List<String>();
		List<String> finJhaList = new List<String>();
		for(Person_Financial_Account_Junction__c junc : juncList) {
			String[] idArray = junc.CIF_JHA_LINK__c.split('\\|');
			acctCifList.add(idArray[0]);
			finJhaList.add(idArray[1]);
		}
		Map<String, Id> acctCifSfMap = new Map<String, Id>();
		for(Account acct : [SELECT Id, CIF_Person__c FROM Account WHERE RecordTypeId = '012i0000001AblM' AND CIF_Person__c IN :acctCifList]) {
			acctCifSfMap.put(acct.CIF_Person__c, acct.Id);
		}
		Map<String, Id> finJhaSfMap = new Map<String, Id>();
		for(Financial_Account__c fin : [SELECT Id, JHA_RECORD_ID__c FROM Financial_Account__c WHERE JHA_RECORD_ID__c IN :finJhaList]) {
			finJhaSfMap.put(fin.JHA_RECORD_ID__c, fin.Id);
		}
		List<Person_Financial_Account_Junction__c> toUpdate = new List<Person_Financial_Account_Junction__c>();
		for(Person_Financial_Account_Junction__c junc : juncList) {
			String[] idArray = junc.CIF_JHA_LINK__c.split('\\|');
			String acctId = acctCifSfMap.get(idArray[0]);
			String finId = finJhaSfMap.get(idArray[1]);
			if(acctId != null && finId != null) {
				junc.Person_Account__c = acctId;
				junc.Financial_Account__c = finId;
				toUpdate.add(junc);
			}
		}
		if(toUpdate.size() > 0) {
			update toUpdate;
		}
	}
	
	//Finish method to execute at last.
	global void finish(Database.BatchableContext BC) {
		//Send an email to the User after your batch completes
		/*Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {'salesforcesupport@bofi.com'};
		mail.setToAddresses(toAddresses);
		mail.setSubject('Salesforce: Consumer Deposits Data Load Completed');
		mail.setPlainTextBody('The batch Apex Job Processed Successfully');
		try {
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		} catch (Exception e) {}*/
	}
}