trigger LeadTrigger on Lead (before update, before insert, after insert, after update) {
    if(!TriggerLoopExecutionControl_cls.hasAlreadyBeenExecuted('LeadTrigger')){
        new LeadTriggerHandler().run();
    }
}