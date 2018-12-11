trigger AssignedPaymentTrigger on Assigned_Payments__c (before insert, before update) {
  new AssignedPaymentTriggerHandler().run();
}