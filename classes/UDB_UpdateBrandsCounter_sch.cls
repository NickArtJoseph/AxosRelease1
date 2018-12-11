/***

    Author: René Ayala Medina
    Description: APEX schedulable class to summarize the brands of the related financial accounts and set that summary to the numeric fields in "Account" object. 
    
    Version Developer             Date          Description
    0.1     René Ayala Medina RAM 07/05/2018    Class created
    0.2     René Ayala Medina RAM 07/05/2018    Building the class
    1.0     René Ayala Medina RAM 07/05/2018    Documentation and testing

***/

global class UDB_UpdateBrandsCounter_sch implements Schedulable{
    
    global void execute(SchedulableContext sc){
        //All the accounts in the database which hasn't been summarized will be processed.
        String strQueryOverAccountsToProcess = 'SELECT Id FROM Account WHERE FinAccsSummProcessed__c = false';
        UDB_UpdateBrandsCounter_bch batchInstance = new UDB_UpdateBrandsCounter_bch(strQueryOverAccountsToProcess);
        Database.executeBatch(batchInstance,200);
    }
    
}