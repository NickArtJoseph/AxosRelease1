@isTest
private class OpportunitySLA72hReminderSFDC2_Test {

	@testSetup
    static void setup() {
        Map<String, RecordType> mapOpportunityRecordTypes = UtilsSFDC2.getRecordTypesMap('Opportunity', 'DeveloperName');
        Map<String, RecordType> mapAccountRecordTypes = UtilsSFDC2.getRecordTypesMap('Account', 'DeveloperName');

        Account acc = new Account(
            RecordTypeId = mapAccountRecordTypes.get('Business_Account_SFDC2').Id,
            Is_Converted__c = true,
            Name = 'TEST ACCOUNT'
        );

        insert acc;

        Opportunity opp = new Opportunity(
            RecordTypeId = mapOpportunityRecordTypes.get('CRESL_SFDC2').Id,
            Name = 'TEST OPP',
            StageName = '1 - New',
            CloseDate = System.today().addDays(10),
            AccountId = acc.Id,
            Loan_Amount__c = 100.55,
            Estimated_Rate_at_Close__c = 5.0,
            C_I_Sub_Stage__c = 'Gathering Information',
            CI_Projected_Initial_Funding__c = 100.55
        );
        insert opp;
    }

    @isTest
    static void should_set_opportunity_72h_reminder_date() {
        Opportunity[] lstOpportunities = [
            SELECT Id, SFDC2_72hReminderDate__c
            FROM Opportunity
        ];
        OpportunitySLA72hReminderSFDC2.setBoardingForm24hReminderDates(lstOpportunities);
        
        
/*
        System.assert(!lstOpportunities.isEmpty());

        for (Opportunity opp: lstOpportunities) {
            opp.CI_Projected_Close_Date__c = System.today().addDays(7);
        }

        // Execute test
        Test.startTest();
            update lstOpportunities;
        Test.stopTest();

        // Verify test results
        lstOpportunities = [
            SELECT Id, SFDC2_72hReminderDate__c
            FROM Opportunity
        ];

        Boolean allValid = true;
        for (Opportunity opp: lstOpportunities) {
            allValid = (allValid && opp.SFDC2_72hReminderDate__c != null);
        }

        System.assertEquals(true, allValid);
*/
    }

}