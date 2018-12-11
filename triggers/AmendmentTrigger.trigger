trigger AmendmentTrigger on Amendment__c (after update) {
	new AmendmentTriggerHandler().run();
}