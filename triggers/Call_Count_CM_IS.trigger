trigger Call_Count_CM_IS on Task (after insert) {
    Call_Count_IS_TriggerHandler.rollupDials(Trigger.new);
}