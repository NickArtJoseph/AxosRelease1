trigger AddressTrigger on Address__c (after insert, after update) {
	new AddressTriggerHandler().run();
}