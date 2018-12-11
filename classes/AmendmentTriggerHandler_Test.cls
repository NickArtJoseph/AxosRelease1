/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class AmendmentTriggerHandler_Test {

	@isTest
    static void testUpdateOppModSummaryFields() {
        Account acct = TestDataFactory.createAndInsertTestBusinessAccount();
        //create test C&I - Lender Finance opportunity [record type id = 012i0000001AcDC]
        Opportunity opp = new Opportunity(Name='Test',
        								  AccountId=acct.Id,
        								  RecordTypeId='012i0000001AcDC', 
        								  StageName='Closed Won',
        								  SubStage__c='Loan Funded/Available',
                                          CI_Rate_Type__c = 'Fixed',
                                          CI_Rate__c = 1,
        								  CloseDate = Date.today(),
        								  CI_Projected_Close_Date__c = Date.today());
		insert opp;
		Amendment__c amend = new Amendment__c(Opportunity__c=opp.Id,
											  RE__c='Test',
											  Additional_Fees__c='1',
											  Collateral__c='2',
											  Extension_Options__c='3',
											  Guarantors__c='4',
											  Guarantor_Types__c='5',
											  Loan_Amount__c=6,
											  Loan_Structure__c='Revolving',
											  Other__c='7',
											  Rate__c=8,
											  Term__c='9');
		insert amend;
		opp = [SELECT
				CI_Additional_Fees_Amend__c,
				CI_Collateral_Amend__c,
				CI_Extension_Options_Amend__c,
				CI_Guarantors_Amend__c,
				CI_Guarantor_Types_Amend__c,
				CI_Loan_Amount_Amend__c,
				CI_Loan_Structure_Amend__c,
				CI_Other_Amend__c,
				CI_Rate_Amend__c,
				CI_Term_Amend__c
				FROM Opportunity
				WHERE Id = :opp.Id];
		System.assertEquals(null, opp.CI_Additional_Fees_Amend__c);
		System.assertEquals(null, opp.CI_Collateral_Amend__c);
		System.assertEquals(null, opp.CI_Extension_Options_Amend__c);
		System.assertEquals(null, opp.CI_Guarantors_Amend__c);
		System.assertEquals(null, opp.CI_Guarantor_Types_Amend__c);
		System.assertEquals(null, opp.CI_Loan_Amount_Amend__c);
		System.assertEquals(null, opp.CI_Loan_Structure_Amend__c);
		System.assertEquals(null, opp.CI_Other_Amend__c);
		System.assertEquals(null, opp.CI_Rate_Amend__c);
		System.assertEquals(null, opp.CI_Term_Amend__c);
		
		System.Test.startTest();
		amend.Approval_Status__c = 'Approved';
		update amend;
		System.Test.stopTest();
		
		opp = [SELECT
				CI_Additional_Fees_Amend__c,
				CI_Collateral_Amend__c,
				CI_Extension_Options_Amend__c,
				CI_Guarantors_Amend__c,
				CI_Guarantor_Types_Amend__c,
				CI_Loan_Amount_Amend__c,
				CI_Loan_Structure_Amend__c,
				CI_Other_Amend__c,
				CI_Rate_Amend__c,
				CI_Term_Amend__c
				FROM Opportunity
				WHERE Id = :opp.Id];
		System.assertEquals('1', opp.CI_Additional_Fees_Amend__c);
		System.assertEquals('2', opp.CI_Collateral_Amend__c);
		System.assertEquals('3', opp.CI_Extension_Options_Amend__c);
		System.assertEquals('4', opp.CI_Guarantors_Amend__c);
		System.assertEquals('5', opp.CI_Guarantor_Types_Amend__c);
		System.assertEquals(6, opp.CI_Loan_Amount_Amend__c);
		System.assertEquals('Revolving', opp.CI_Loan_Structure_Amend__c);
		System.assertEquals('7', opp.CI_Other_Amend__c);
		System.assertEquals(8, opp.CI_Rate_Amend__c);
		System.assertEquals('9', opp.CI_Term_Amend__c);
    }
}