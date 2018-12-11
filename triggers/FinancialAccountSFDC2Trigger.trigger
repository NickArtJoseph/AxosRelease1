trigger FinancialAccountSFDC2Trigger on Financial_Account_SFDC2__c (before update, after update) {
  if(!TriggerValidator.isAlreadyRun()) {
    new FinancialAccountSFDC2TriggerHandler().run();
  }
}