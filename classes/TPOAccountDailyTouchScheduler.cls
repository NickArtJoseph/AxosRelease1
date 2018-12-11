/**
* @description <p>Schedulable class for TPO Account records to ensure formula fields for time-based workflow
criteria are recalculated daily; expected to be run on a daily basis</p>
* @author Mike Crosby, BofI Federal 
*/
global class TPOAccountDailyTouchScheduler implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        TPOAccountDailyTouchHandler handler = new TPOAccountDailyTouchHandler();
        database.executeBatch(handler);
    }
}