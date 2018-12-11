/***

    Author: René Ayala Medina
    Description: Trigger to handle all the possible DML events for the records of the "Financial_Account_Link_SFDC2__c" custom object
    
    Version Developer             Date          Description
    0.1     René Ayala Medina RAM 07/02/2018    Trigger created
    0.2     René Ayala Medina RAM 07/02/2018    Building
    1.0     René Ayala Medina RAM 07/05/2018    Documentation and testing

***/

trigger FinantialAccountLinkAcc_tgr on Financial_Account_Link_SFDC2__c (
    before insert, 
    before update, 
    before delete, 
    after insert, 
    after update, 
    after delete, 
    after undelete){/*

    //The trigger handler is always executed when the trigger hasn't been invoked previously in the same transaction.

    if(!TriggerLoopExecutionControl_cls.hasAlreadyBeenExecuted('AccountLinkToFinancialsTrigger')){
        new FinantialAccountLinkAccHandler().run();     
    }*/
}