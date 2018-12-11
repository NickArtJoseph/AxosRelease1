trigger ContactTrigger on Contact (before insert, before update, after insert, after update) {
    if(!TriggerLoopExecutionControl_cls.hasAlreadyBeenExecuted('ContactTrigger')){
        new ContactTriggerHandler().run();
    }
}