trigger CaseTrigger on Case (after insert, after update, before insert, before update) {
    new CaseTriggerHandler().run();
}