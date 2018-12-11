trigger OpportunityTrigger on Opportunity (before insert, before update, after insert) {
    if(!TriggerLoopExecutionControl_cls.hasAlreadyBeenExecuted('OpportunityTrigger')){
      if(!TriggerValidator.isAlreadyRun()) {
        new OpportunityTriggerHandler().run();
      }
    }
}