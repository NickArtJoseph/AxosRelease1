@isTest
private class LoanOpsQstnrTriggerHandler_Test {
	@testSetup
    static void setup() {
        //set up test records
        Account a = TestDataFactory.createAndInsertTestBusinessAccount();
        Opportunity o = new Opportunity();
        o.AccountId = a.Id;
        o.RecordTypeId='012i0000001AcDB';
        o.Name = a.Id + ' Opportunity';
        o.StageName = 'On-Hold';
        o.SubStage__c = 'Sponsorship';
        o.CloseDate = System.Date.today();
        o.CI_Projected_Close_Date__c = System.Date.today();
        o.CI_Rate_Type__c = 'Fixed';
        o.CI_Rate__c = 1;
        insert o;
        Loan_Ops_Questionnaire__c loq = new Loan_Ops_Questionnaire__c();
        loq.Opportunity__c = o.Id;
        loq.LOQ_Status__c = 'LOQ In Progress';
        insert loq;
    }
    
    @isTest
    static void testValidateLOQApproval() {
        Loan_Ops_Questionnaire__c loq = [SELECT Id FROM Loan_Ops_Questionnaire__c LIMIT 1][0];
        loq.Collateral_Type__c = 'Real Estate';
        loq.Term_Type__c = 'Term';
        loq.Interest_Rate_Type__c = 'Fixed';
        loq.Borrower_Relationship__c = 'Direct';
        loq.Collateral_Secured__c = 'Secured';
        loq.Property_Type__c = 'SFR';
        loq.Collateral_Type_RE__c = 'Notes';
        loq.Addl_LOQ_Options__c = '3rd Party Agent';
        loq.LOQ_Status__c = 'LOQ Submitted for approval';
        update loq;
        
        loq.ApprovalSubmitted__c = true;
        try {
            update loq;
            System.assert(false, 'LOQ should now allow ApprovalSubmitted field to be set to TRUE if required fields are blank');
        } catch (Exception e) {}
        
        loq.C_I_Loan_Type__c = '1A';
        loq.Call_Report_Code__c = '4';
        loq.Purpose_Code__c = '37 - Direct';
        loq.Collateral_Code_Description__c = '110 - SFR Construction';
        
        update loq;
    }
}