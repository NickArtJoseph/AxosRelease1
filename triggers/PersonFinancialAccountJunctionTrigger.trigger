trigger PersonFinancialAccountJunctionTrigger on Person_Financial_Account_Junction__c (after insert, after update, after delete) {
  new PersonFinancialAcctJuncTriggerHandler().run();
}