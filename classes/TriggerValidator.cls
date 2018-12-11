global class TriggerValidator {
  private static Boolean isTest = false;
  private static Set<String> triggerContextsRun = new Set<String>();
  
  public static Boolean isAlreadyRun() {
    //return duplicateRun;
    if(isTest) {
      //allow multiple calls during unit testing
      return false;
    }
    String ctx = determineContext();
    if(triggerContextsRun.contains(ctx)) {
        System.debug('**** TriggerValidator: already ran context: ' + ctx);
        return true;
    } else {
        System.debug('**** TriggerValidator: running context: ' + ctx);
        triggerContextsRun.add(ctx);
        return false;
    }
  }
  
  public static void setIsTest() {
    isTest = true;
  }
  
  public static void reset() {
    triggerContextsRun = new Set<String>();
  }
  
  private static String determineContext() {
   String ctx = '';
   if(Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) {
        ctx = 'before insert';
    } else if(Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) {
        ctx = 'before update';
    } else if(Trigger.isExecuting && Trigger.isBefore && Trigger.isDelete) {
        ctx = 'before delete';
    } else if(Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) {
        ctx = 'after insert';
    } else if(Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate) {
        ctx = 'after update';
    } else if(Trigger.isExecuting && Trigger.isAfter && Trigger.isDelete) {
        ctx = 'after delete';
    } else if(Trigger.isExecuting && Trigger.isAfter && Trigger.isUndelete) {
        ctx = 'after undelete';
    }
    return ctx;
  }
}