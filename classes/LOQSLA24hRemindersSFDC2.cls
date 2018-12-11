/*******************************************************************************
Developed by: Unosquare
Author: Daniel Peñaloza
Project: BOFI - C&I
Description: Apex class with invocable method to call from Process Builder
             to generate LOQ 24h SLA Reminder Date.

--------- ---------- -------------------------- -----------------------------------
Version   Date       Author                     Change Description
--------- ---------- -------------------------- -----------------------------------
   1.0    29/01/2018 Daniel Peñaloza            Class created
*******************************************************************************/

public class LOQSLA24hRemindersSFDC2 {

    /**
     * Invocable method used to set LOQ Reminder Dates
     * @param lstLOQs List of LOQs to process
     */
    @InvocableMethod(label='SFDC2: Set LOQ 24h Reminder Date' description='SFDC2: Set LOQ 24h Reminder Date')
    public static void setLOQ24hReminderDate(Loan_Ops_Questionnaire__c[] lstLOQs) {
        SFDC2SLAReminderSettings__mdt defaultReminderTimes = UtilsSFDC2.getSLAReminderTimes();

        // Get Business hours ID and current Datetime
        BusinessHours bh = [SELECT Id, Name FROM BusinessHours WHERE Name = 'BOFI Servicing' LIMIT 1];
        Datetime currentDatetime = System.now();

        Map<Id, Datetime> map24hReminderDates = new Map<Id, Datetime>();

        // Calculate Reminder Dates for LOQs
        for(Loan_Ops_Questionnaire__c loq: lstLOQs) {
            Long reminderTime = (defaultReminderTimes.LOQ_Approval_Reminder_Time__c == 0) ? 0 : hoursToMilliseconds(defaultReminderTimes.LOQ_Approval_Reminder_Time__c);
            Datetime reminderDate24h = BusinessHours.add(bh.Id, currentDatetime, reminderTime);
            map24hReminderDates.put(loq.Id, reminderDate24h);
        }

        // Update boarding forms asynchronously
        updateLOQsAsync(map24hReminderDates);
    }

    /**
     * Update Boarding forms asynchronously
     * @param map24hReminderDates Map with 24h reminder dates
     */
    @future
    private static void updateLOQsAsync(Map<Id, Datetime> map24hReminderDates) {
        Loan_Ops_Questionnaire__c[] lstLOQs = [
            SELECT Id, SFDC2_24hReminderDate__c
            FROM Loan_Ops_Questionnaire__c
            WHERE Id IN :map24hReminderDates.keySet()
        ];

        for(Loan_Ops_Questionnaire__c loq : lstLOQs) {
            loq.SFDC2_24hReminderDate__c = map24hReminderDates.get(loq.Id);
        }

        update lstLOQs;
    }

    /**
     * Convert hours to milliseconds
     * @param  hours Hours to convert
     * @return       Converted milliseconds
     */
    private static Integer hoursToMilliseconds(Decimal hours) {
        Integer intHours = (Integer) hours;
        return intHours * 60 * 60 * 1000;
    }

}