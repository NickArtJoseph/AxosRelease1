/**
* @description <p>Handler class for "touching" TPO Accounts by toggling hidden field on Account records
* to ensure that time-based workflows using formula date fields as entry criteria are recalculated daily</p>
* @author Mike Crosby, BofI Federal 
*/
global class TPOAccountDailyTouchHandler implements Database.Batchable<sObject> {
	
    global TPOAccountDailyTouchHandler() {}
    
	//Query method.
	global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('**** Querying TPO Accounts to Update');
		return Database.getQueryLocator([SELECT Id, TPOToggleWorkflow__c FROM Account WHERE RecordType.DeveloperName = 'TPO_Account']);
	}
    
    //Execute Method.
	global void execute(Database.BatchableContext BC, List<Account> accList) {
        System.debug('**** Toggling TPO workflow field');
        for(Account acc : accList) {
            if(acc.TPOToggleWorkflow__c == '1') {
                acc.TPOToggleWorkflow__c = '2';
            } else {
                acc.TPOToggleWorkflow__c = '1';
            }
        }
        update accList;
    }
    
    //Finish method to execute at last.
    global void finish(Database.BatchableContext BC) {}
}