/***

    Author: René Ayala Medina
    Description: APEX batchable class to summarize the brands of the related financial accounts and set that summary to the numeric fields in "Account" object. 
    
    Version Developer             Date          Description
    0.1     René Ayala Medina RAM 07/05/2018    Class created
    0.2     René Ayala Medina RAM 07/05/2018    Building the class
    1.0     René Ayala Medina RAM 07/05/2018    Documentation and testing

***/

global class UDB_UpdateBrandsCounter_bch implements Database.Batchable<sObject> {
	
	private String query;
	
	global UDB_UpdateBrandsCounter_bch(String strQuerySttmntFromSc) {
		 query = strQuerySttmntFromSc;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<Account> lstAccsToProcess) {
   		//All account that hasn't been summarized are processed.
		Set<Id> setAccsIDs = new Set<Id>();
		for(Account iterator:lstAccsToProcess){
			setAccsIDs.add(iterator.Id);
		}
		if(!setAccsIDs.isEmpty()){
			UDB_UpdateBrandsCounter_cls.updateBrandCounterFields(setAccsIDs);
		}
	}
	
	global void finish(Database.BatchableContext BC) {}
	
}