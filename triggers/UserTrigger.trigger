trigger UserTrigger on User (after update) {
	if(!TriggerValidator.isAlreadyRun()) {
    	new UserTriggerHandler().run();
	}
}