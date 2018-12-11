global class BatchableRecordDelete implements Database.Batchable<sObject>{
    global final String Query;
	
	global BatchableRecordDelete(String q) {
		Query = q;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(Query);
    }

    global void execute(Database.BatchableContext BC,List<sObject> scope){
        delete scope;
    }

    global void finish(Database.BatchableContext BC){}
}