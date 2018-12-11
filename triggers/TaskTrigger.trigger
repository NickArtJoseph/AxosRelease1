trigger TaskTrigger on Task (before insert, after insert, after update, after delete) {
  new TaskTriggerHandler().run();
}