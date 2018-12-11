/**
* @description <p>Schedulable class for CI Certification creation; expected to be run on a monthly basis</p>
* @author Mike Crosby, BofI Federal 
*/
global class CICertificationScheduler implements Schedulable {
  
  global boolean isTest = false;
  
    global void execute(SchedulableContext sc) {
        CronTrigger ct = [SELECT 
                            Id, CronExpression, TimesTriggered, StartTime, NextFireTime
                          FROM CronTrigger 
                          WHERE id = :sc.getTriggerId()];
        CICertificationCreationHandler handler = new CICertificationCreationHandler();
        if(!isTest) {
          Date runDate = Date.today();
          runDate = runDate.addDays(1);
          handler.run(runDate);
        } else {
          handler.run(ct.NextFireTime.date());
        }
    }
}