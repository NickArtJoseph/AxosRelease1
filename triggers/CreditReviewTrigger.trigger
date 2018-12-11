trigger CreditReviewTrigger on WLD_Credit_Review__c (before insert, before update, after insert, after update) {
    new CreditReviewTriggerHandler().run();
}