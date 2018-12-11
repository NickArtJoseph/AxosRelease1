trigger AddressSfdc2Trigger on Address_SFDC2__c (after insert, after update, before update, before insert, before delete) {
    new AddressSfdc2TriggerHandler().run();
}