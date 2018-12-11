trigger UDBSecureMessagingTrigger on UDB_Secure_Messaging__c (after insert) {
	new UDBSecureMessagingTriggerHandler().run();
}