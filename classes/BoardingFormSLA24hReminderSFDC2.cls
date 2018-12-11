/*******************************************************************************
Developed by: Unosquare
Author: Daniel Peñaloza
Project: BOFI - C&I
Description: Apex class with invocable method to call from Process Builder
             to generate BF 24h SLA Reminder Date.

--------- ---------- -------------------------- -----------------------------------
Version   Date       Author                     Change Description
--------- ---------- -------------------------- -----------------------------------
   1.0    29/01/2018 Daniel Peñaloza            Class created
*******************************************************************************/

public class BoardingFormSLA24hReminderSFDC2 {

    /**
     * Invocable method used to set Boarding Form 24h Reminder Date
     * @param lstBoardingForms List of boarding forms to process
     */
    @InvocableMethod(label='SFDC2: Set BF 24h Reminder Date' description='SFDC2: Set BF 24h Reminder Date')
    public static void setBoardingForm24hReminderDates(Boarding_Form__c[] lstBoardingForms) {
        SFDC2SLAReminderSettings__mdt defaultReminderTimes = UtilsSFDC2.getSLAReminderTimes();

        // Get Business hours ID and current Datetime
        BusinessHours bh = [SELECT Id, Name FROM BusinessHours WHERE Name = 'BOFI Servicing' LIMIT 1];
        Datetime currentDatetime = System.now();
        

        Map<Id, Datetime> map24hReminderDates = new Map<Id, Datetime>();

        // Calculate Reminder Dates for Boarding Forms
        for(Boarding_Form__c bf : lstBoardingForms) {
            Long reminderTime = (defaultReminderTimes.BF_Approval_Reminder_Time__c == 0) ? 0 : hoursToMilliseconds(defaultReminderTimes.BF_Approval_Reminder_Time__c);
            Datetime reminderDate24h = BusinessHours.add(bh.Id, currentDatetime, reminderTime);
            map24hReminderDates.put(bf.Id, reminderDate24h);
        }

        // Update boarding forms asynchronously
        updateBoardingFormsAsync(map24hReminderDates);
    }

    /**
     * Update Boarding forms asynchronously
     * @param map24hReminderDates Map with 24h reminder dates
     */
    @future
    private static void updateBoardingFormsAsync(Map<Id, Datetime> map24hReminderDates) {
        Boarding_Form__c[] lstBoardingForms = [
            SELECT Id, SFDC2_24hReminderDate__c
            FROM Boarding_Form__c
            WHERE Id IN :map24hReminderDates.keySet()
        ];

        for(Boarding_Form__c bf : lstBoardingForms) {
            bf.SFDC2_24hReminderDate__c = map24hReminderDates.get(bf.Id);
        }

        update lstBoardingForms;
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