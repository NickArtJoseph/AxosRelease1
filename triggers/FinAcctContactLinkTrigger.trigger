trigger FinAcctContactLinkTrigger on Financial_Account_Contact_Link_SFDC2__c (after insert) {
  if(!TriggerValidator.isAlreadyRun()) {
    new FinAcctContactLinkTriggerHandler().run();
  }
}