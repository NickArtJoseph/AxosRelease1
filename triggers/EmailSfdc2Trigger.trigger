trigger EmailSfdc2Trigger on Email_SFDC2__c (after insert, after update, before update, before insert, before delete) {
    new EmailSfdc2TriggerHandler().run();
}