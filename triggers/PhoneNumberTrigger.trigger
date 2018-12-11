trigger PhoneNumberTrigger on Phone_Number__c (before update, after insert) {
	new PhoneNumberTriggerHandler().run();
}