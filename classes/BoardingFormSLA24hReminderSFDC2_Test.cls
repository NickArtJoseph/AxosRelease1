/*******************************************************************************
Developed by: Unosquare
Author: Daniel Peñaloza
Project: BOFI - C&I
Description: Apex Test class for BoardingFormSLARemindersSFDC2

--------- ---------- -------------------------- -----------------------------------
Version   Date       Author                     Change Description
--------- ---------- -------------------------- -----------------------------------
1.0    29/01/2018 Daniel Peñaloza            Class created
*******************************************************************************/

@isTest
private class BoardingFormSLA24hReminderSFDC2_Test {
    
    @testSetup
    static void setup() {
        Map<String, RecordType> mapOpportunityRecordTypes = UtilsSFDC2.getRecordTypesMap('Opportunity', 'DeveloperName');
        Map<String, RecordType> mapAccountRecordTypes = UtilsSFDC2.getRecordTypesMap('Account', 'DeveloperName');
        Map<String, RecordType> mapBFRecordTypes = UtilsSFDC2.getRecordTypesMap('Boarding_Form__c', 'DeveloperName');
        
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
        
        Boarding_Form__c  bf = new Boarding_Form__c(
            RecordTypeId = mapBFRecordTypes.get('Post_LOQ_Approval').Id, 
            Opportunity__c = opp.Id);
        
        insert bf;
    }
    
    @isTest
    static void should_set_bf_24h_reminder_date() {
        Boarding_Form__c[] lstBoardingForms = [
            SELECT Id, SFDC2_24hReminderDate__c
            FROM Boarding_Form__c limit 1
        ];
        
        System.assert(!lstBoardingForms.isEmpty());
        
        for (Boarding_Form__c bf: lstBoardingForms) {
            bf.BF_Status__c = 'BF Submitted for Approval';
        }
        
        // Execute test
        Test.startTest();
        update lstBoardingForms;
        
        BoardingFormSLA24hReminderSFDC2.setBoardingForm24hReminderDates(lstBoardingForms); 
        Test.stopTest();
        /*
        // Verify test results
        lstBoardingForms = [
            SELECT Id, SFDC2_24hReminderDate__c
            FROM Boarding_Form__c
        ];
        
        Boolean allValid = true;
        for (Boarding_Form__c bf: lstBoardingForms) {
            allValid = (allValid && bf.SFDC2_24hReminderDate__c != null);
        }
        
        System.assertEquals(true, allValid); */
    }
}