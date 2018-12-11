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
private class AccountSFDC2RollupSummaryExtension_Test {

    @isTest
    static void testAccountSFDC2RollupSummaryExtension() {

        Account account1 = TestDataFactory.createAndInsertTestPersonAccount();		
        Account account2 = TestDataFactory.createAndInsertTestBusinessAccount();
        
        account1 = [select Id, PersonContactId from Account where Id = :account1.Id];
        System.debug('Test person account contact id: ' + account1.PersonContactId);
        
        Task task1 = TestDataFactory.createTestTask(account1); //create a task for today
        task1.Type = 'Call';
        task1.Status = 'Completed';
        
        Task task2 = TestDataFactory.createTestTask(account1); //create a task for last year
        task2.ActivityDate = Date.newInstance(Date.today().year() - 1, Date.today().month(), Date.today().day());
        task2.Type = 'Call';
        task2.Status = 'Completed';
        
        Task[] tasks = new Task[]{task1, task2};
        insert tasks;

		// create an opportunity for today
        Opportunity opp1 = new Opportunity(Name='Test',StageName='Open',CloseDate=Date.today(),AccountId=account2.Id);
		insert opp1;

		// create an opportunity for last year
        Opportunity opp2 = new Opportunity(Name='Test',StageName='Open',CloseDate=Date.today(),AccountId=account2.Id);
		insert opp2;
		Test.setCreatedDate(opp2.Id, DateTime.newInstance(Date.today().year() - 1, Date.today().month(), Date.today().day()));
			
        // Financial Accounts
        Financial_Account_SFDC2__c financialAccount_dd = new Financial_Account_SFDC2__c(JH_Master_Table__c = 'DD', Balance__c = 100.00);
        Financial_Account_SFDC2__c financialAccount_cd = new Financial_Account_SFDC2__c(JH_Master_Table__c = 'CD', Balance__c = 200.00);
        Financial_Account_SFDC2__c financialAccount_ln = new Financial_Account_SFDC2__c(JH_Master_Table__c = 'LN', Balance__c = 300.00);
        insert financialAccount_dd;
        insert financialAccount_cd;
        insert financialAccount_ln;

		// Primary account holder links        
        Financial_Account_Link_SFDC2__c fal_dd_p = new Financial_Account_Link_SFDC2__c(Account__c = account2.Id, Financial_Account__c = financialAccount_dd.Id, CIF_JHA_LINK__c = '123', Relationship__c = 'Primary');
        Financial_Account_Link_SFDC2__c fal_cd_p = new Financial_Account_Link_SFDC2__c(Account__c = account2.Id, Financial_Account__c = financialAccount_cd.Id, CIF_JHA_LINK__c = '234', Relationship__c = 'Primary');
        Financial_Account_Link_SFDC2__c fal_ln_p = new Financial_Account_Link_SFDC2__c(Account__c = account2.Id, Financial_Account__c = financialAccount_ln.Id, CIF_JHA_LINK__c = '345', Relationship__c = 'Primary');
		insert fal_dd_p;
        insert fal_cd_p;
        insert fal_ln_p;

        // Joint account holder links
        Financial_Account_Contact_Link_SFDC2__c fal_dd_s = new Financial_Account_Contact_Link_SFDC2__c(Contact__c = account1.PersonContactId, Financial_Account__c = financialAccount_dd.Id, CIF_JHA_LINK__c = '456', Relationship__c = 'Joint');
        Financial_Account_Contact_Link_SFDC2__c fal_cd_s = new Financial_Account_Contact_Link_SFDC2__c(Contact__c = account1.PersonContactId, Financial_Account__c = financialAccount_cd.Id, CIF_JHA_LINK__c = '567', Relationship__c = 'Joint');
        Financial_Account_Contact_Link_SFDC2__c fal_ln_s = new Financial_Account_Contact_Link_SFDC2__c(Contact__c = account1.PersonContactId, Financial_Account__c = financialAccount_ln.Id, CIF_JHA_LINK__c = '678', Relationship__c = 'Joint');
		insert fal_dd_s;
        insert fal_cd_s;
        insert fal_ln_s;
        
        // Test account1      
		Test.setCurrentPage(Page.AccountSFDC2RollupSummary);
        ApexPages.currentPage().getParameters().put('id',account1.Id);
        ApexPages.Standardcontroller c_ctr = new ApexPages.StandardController(account1);
        AccountSFDC2RollupSummaryExtension c_ext = new AccountSFDC2RollupSummaryExtension(c_ctr);
        
        System.assertEquals(0, c_ext.numLTDOpportunities);
        System.assertEquals(0, c_ext.numQTDOpportunities);
        System.assertEquals(2, c_ext.numLTDCalls);
        System.assertEquals(1, c_ext.numQTDCalls);
        System.assertEquals(1, c_ext.numDepositAccounts);
        System.assertEquals(1, c_ext.numCDAccounts);
        System.assertEquals(1, c_ext.numLoanAccounts);
        System.assertEquals(100.00, c_ext.balanceDepositAccounts);
        System.assertEquals(200.00, c_ext.balanceCDAccounts);
        System.assertEquals(300.00, c_ext.balanceLoanAccounts);

        // Test account2
        Test.setCurrentPage(Page.AccountSFDC2RollupSummary);
        ApexPages.currentPage().getParameters().put('id',account2.Id);
        ApexPages.Standardcontroller b_ctr = new ApexPages.StandardController(account2);
        AccountSFDC2RollupSummaryExtension b_ext = new AccountSFDC2RollupSummaryExtension(b_ctr);
        
        System.assertEquals(2, b_ext.numLTDOpportunities);
        System.assertEquals(1, b_ext.numQTDOpportunities);
        System.assertEquals(0, b_ext.numLTDCalls);
        System.assertEquals(0, b_ext.numQTDCalls);
        System.assertEquals(1, b_ext.numDepositAccounts);
        System.assertEquals(1, b_ext.numCDAccounts);
        System.assertEquals(1, b_ext.numLoanAccounts);
        System.assertEquals(100.00, b_ext.balanceDepositAccounts);
        System.assertEquals(200.00, b_ext.balanceCDAccounts);
        System.assertEquals(300.00, b_ext.balanceLoanAccounts);
        
    }

}