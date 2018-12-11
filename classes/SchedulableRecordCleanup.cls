global class SchedulableRecordCleanup implements Schedulable{
    global void execute(SchedulableContext sc){
        String queryOppQueue = 'select id from Opportunity_Queue__c where Opportunity__c = null and LastModifiedDate != LAST_N_DAYS:15';
        if(Test.isRunningTest()) {
        	queryOppQueue = 'select id from Opportunity_Queue__c where Opportunity__c = null';
        }
        BatchableRecordDelete delOppQueue = new BatchableRecordDelete(queryOppQueue);
        Id BatchProcessId = Database.ExecuteBatch(delOppQueue);
    }
}