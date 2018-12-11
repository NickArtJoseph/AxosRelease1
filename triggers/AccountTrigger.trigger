trigger AccountTrigger on Account (before update, before insert, after update, after insert) {
    if(!TriggerLoopExecutionControl_cls.hasAlreadyBeenExecuted('AccountTrigger')){
       if(!TriggerValidator.isAlreadyRun()) {
         new AccountTriggerHandler().run();
       }
       new AccountRetriggerHandler().run();
    }
}