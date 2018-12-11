trigger QuickTextTrigger on QuickText (after insert, after update) {
	new QuickTextTriggerHandler().run();
}