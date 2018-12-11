trigger PhoneSfdc2Trigger on Phone_SFDC2__c (after insert, after update, before update, before insert, before delete) {
    new PhoneSfdc2TriggerHandler().run();
}