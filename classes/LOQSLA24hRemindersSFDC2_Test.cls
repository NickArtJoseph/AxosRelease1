/*******************************************************************************
Developed by: Unosquare
Author: Daniel Peñaloza
Project: BOFI - C&I
Description: Apex Test class for LOQSLARemindersSFDC2

--------- ---------- -------------------------- -----------------------------------
Version   Date       Author                     Change Description
--------- ---------- -------------------------- -----------------------------------
   1.0    29/01/2018 Daniel Peñaloza            Class created
   1.1    06/03/2018 Erik Ramirez               Add the required values for Submitted for approval 
*******************************************************************************/

@isTest
private class LOQSLA24hRemindersSFDC2_Test {

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
        Loan_Ops_Questionnaire__c loq = new Loan_Ops_Questionnaire__c();
        loq.Opportunity__c = opp.id;
        insert loq;
        
                
    }

    @isTest
    static void should_set_loq_reminder_dates() {
        Loan_Ops_Questionnaire__c[] lstLOQs = [
            SELECT Id, SFDC2_24hReminderDate__c
            FROM Loan_Ops_Questionnaire__c limit 1
        ];

        System.assert(!lstLOQs.isEmpty());
        LOQSLA24hRemindersSFDC2.setLOQ24hReminderDate(lstLOQs);
        
/*
        for (Loan_Ops_Questionnaire__c loq: lstLOQs) {
            loq.Collateral_Type__c       = 'Real Estate' ;
            loq.Term_Type__c             = 'Term';
            loq.Interest_Rate_Type__c    = 'Adjustable' ;
            loq.Borrower_Relationship__c = 'Direct' ;
            loq.Property_Type__c         = 'SFR' ;
            loq.Collateral_Secured__c    = 'Secured';
            loq.Addl_LOQ_Options__c      = 'Committed loan';
            loq.Collateral_Type_RE__c    = 'Notes' ;
            loq.LOQ_Status__c            = 'LOQ Submitted for approval';
        }

        // Execute test
        Test.startTest();
            update lstLOQs;
        Test.stopTest();

        // Verify test results
        lstLOQs = [
            SELECT Id, SFDC2_24hReminderDate__c
            FROM Loan_Ops_Questionnaire__c
        ];

        Boolean allValid = true;
        for (Loan_Ops_Questionnaire__c loq: lstLOQs) {
            allValid = (allValid && loq.SFDC2_24hReminderDate__c != null);
        }

        System.assertEquals(true, allValid);
*/   
}


}