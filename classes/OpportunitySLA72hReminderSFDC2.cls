/*******************************************************************************
Developed by: Unosquare
Author: Daniel Peñaloza
Project: BOFI - C&I
Description: Apex class with invocable method to call from Process Builder
             to generate Opportunity 72h SLA Reminder Date.

--------- ---------- -------------------------- -----------------------------------
Version   Date       Author                     Change Description
--------- ---------- -------------------------- -----------------------------------
   1.0    29/01/2018 Daniel Peñaloza            Class created
*******************************************************************************/

public class OpportunitySLA72hReminderSFDC2 {

	/**
     * Invocable method used to set Opportunity 72h Reminder Date
     * @param lstOpportunities List of Opportunities to process
     */
    @InvocableMethod(label='SFDC2: Set Opportunity 72h Reminder Date' description='SFDC2: Set Opportunity 72h Reminder Date')
    public static void setBoardingForm24hReminderDates(Opportunity[] lstOpportunities) {
    	SFDC2SLAReminderSettings__mdt defaultReminderTimes = UtilsSFDC2.getSLAReminderTimes();

        // Get Business hours ID and current Datetime
        BusinessHours bh = [SELECT Id, Name FROM BusinessHours WHERE Name = 'BOFI Servicing' LIMIT 1];
        Datetime currentDatetime = System.now();

        Map<Id, Datetime> map72hReminderDates = new Map<Id, Datetime>();

        // Calculate Reminder Dates for Boarding Forms
        for(Opportunity opp : lstOpportunities) {
        	Datetime reminderDate72h = null;
        	if (defaultReminderTimes.Opp_Proj_Close_Date_Reminder_Time__c == 0) {
        		reminderDate72h = BusinessHours.add(bh.Id, currentDatetime, 0);
        	} else {
        		reminderDate72h = BusinessHours.add(bh.Id, opp.CI_Projected_Close_Date__c, -hoursToMilliseconds(defaultReminderTimes.Opp_Proj_Close_Date_Reminder_Time__c));
        	}

            map72hReminderDates.put(opp.Id, reminderDate72h);
        }

        // Update boarding forms asynchronously
        updateOpportunitiesAsync(map72hReminderDates);
    }

    /**
     * Update Boarding forms asynchronously
     * @param map72hReminderDates Map with 24h reminder dates
     */
    @future
    private static void updateOpportunitiesAsync(Map<Id, Datetime> map72hReminderDates) {
        Opportunity[] lstOpportunities = [
            SELECT Id, SFDC2_72hReminderDate__c
            FROM Opportunity
            WHERE Id IN :map72hReminderDates.keySet()
        ];

        for(Opportunity opp : lstOpportunities) {
            opp.SFDC2_72hReminderDate__c = map72hReminderDates.get(opp.Id);
        }

        update lstOpportunities;
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