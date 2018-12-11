trigger ApplicationTrigger on Application_SFDC2__c (after update) {
    if(!TriggerLoopExecutionControl_cls.hasAlreadyBeenExecuted('ApplicationTrigger')) {
        new ApplicationTriggerHandler().run();
    }
}