trigger CIChecklistItemTrigger on C_I_Checklist_Item__c (after update) {
	new CIChecklistItemTriggerHandler().run();
}