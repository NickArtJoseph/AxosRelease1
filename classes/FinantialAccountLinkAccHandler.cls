/***

    Author: René Ayala Medina
    Description: Class to handle all the possible DML events for the records of the "Financial_Account_Link_SFDC2__c" custom object
    
    Version Developer             Date          Description
    0.1     René Ayala Medina RAM 07/02/2018    Class created
    0.2     René Ayala Medina RAM 07/02/2018    Building
    1.0     René Ayala Medina RAM 07/05/2018    Documentation and testing

***/

public class FinantialAccountLinkAccHandler extends TriggerHandler{

	public Integer limitDML{get{if(Test.isRunningTest()){return 4;}else{return 95;}}}

	/*
		Overrides:
		After Insert event
	*/
	
	public override void afterInsert() { 
		if(accountsInvolved(Trigger.new) < limitDML){
			UDB_UpdateBrandsCounter_cls.updateBrandCounterFields(getAccountsToUpdateBrandCounters(Trigger.new));
		}else{
			String strQueryOverAccountsToProcess = 'SELECT Id FROM Account';
			UDB_UpdateBrandsCounter_bch batchInstance = new UDB_UpdateBrandsCounter_bch(strQueryOverAccountsToProcess);
			Database.executeBatch(batchInstance,50);
		}
	}

	/*
		Overrides:
		After Delete event
	*/
	
	public override void afterDelete(){
		if(accountsInvolved(Trigger.old) < limitDML){
			UDB_UpdateBrandsCounter_cls.updateBrandCounterFields(getAccountsToUpdateBrandCounters(Trigger.old));
		}else{
			String strQueryOverAccountsToProcess = 'SELECT Id FROM Account';
			UDB_UpdateBrandsCounter_bch batchInstance = new UDB_UpdateBrandsCounter_bch(strQueryOverAccountsToProcess);
			Database.executeBatch(batchInstance,50);
		}
	}

	/*
		Overrides:
		After Undelete event
	*/

	public override void afterUndelete(){
		if(accountsInvolved(Trigger.new) < limitDML){
			UDB_UpdateBrandsCounter_cls.updateBrandCounterFields(getAccountsToUpdateBrandCounters(Trigger.new));
		}else{
			String strQueryOverAccountsToProcess = 'SELECT Id FROM Account';
			UDB_UpdateBrandsCounter_bch batchInstance = new UDB_UpdateBrandsCounter_bch(strQueryOverAccountsToProcess);
			Database.executeBatch(batchInstance,50);
		}
	}
	
	/*
		Method to determinate which accounts are those which need to be updated in its brand counter fields
	*/

	private Set<Id> getAccountsToUpdateBrandCounters(List<Financial_Account_Link_SFDC2__c> lstRecordsToAnalize){
		Set<Id> setAccountsToBeUpdated = new Set<Id>();
		for(Financial_Account_Link_SFDC2__c iterator:lstRecordsToAnalize){
			setAccountsToBeUpdated.add(iterator.Account__c);
		}
		return setAccountsToBeUpdated; 
	}

	private Integer accountsInvolved(List<Financial_Account_Link_SFDC2__c> lstLinkRecords){
		Set<Id> setAccsIDs = new Set<Id>();
		for(Financial_Account_Link_SFDC2__c iterator:lstLinkRecords){
			setAccsIDs.add(iterator.Account__c);
		}
		return setAccsIDs.size();
	}

}