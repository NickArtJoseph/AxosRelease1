/**
* @description <p>Schedulable class for CI Certification creation; expected to be run on a monthly basis</p>
* @author Mike Crosby, BofI Federal 
*/
global class WLDQtrCertScheduler implements Schedulable {
    global Boolean isTest = false;
    
    global void execute(SchedulableContext sc) {
        CronTrigger ct = [SELECT 
                            Id, CronExpression, TimesTriggered, StartTime, NextFireTime
                          FROM CronTrigger 
                          WHERE id = :sc.getTriggerId()];
        WLDQtrCertCreationHandler handler = new WLDQtrCertCreationHandler();
        if(isTest)
        {
            handler.run(ct.NextFireTime.date());
        } else {
            handler.run(Date.today());
        }
    }
}