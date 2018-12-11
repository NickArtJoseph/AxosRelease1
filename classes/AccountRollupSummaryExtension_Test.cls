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
private class AccountRollupSummaryExtension_Test {

	/**
	* Tests the AccountRollupSummaryExtension class
	*/
	@isTest
    static void testAccountRollupSummaryExtension() {
        //create test account
        Account a = TestDataFactory.createAndInsertTestPersonAccount();
        Task t1 = TestDataFactory.createTestTask(a); //create a task for today
        t1.Type = 'Call';
        t1.Status = 'Completed';
        
        Task t2 = TestDataFactory.createTestTask(a); //create a task for last year
        t2.ActivityDate = Date.newInstance(Date.today().year() - 1, Date.today().month(), Date.today().day());
        t2.Type = 'Call';
        t2.Status = 'Completed';
        
        Task[] tasks = new Task[]{t1, t2};
        insert tasks;

        Opportunity o = new Opportunity(Name='Test',StageName='Open',CloseDate=Date.today(),AccountId=a.Id);
        insert o;
        
        ApexPages.currentPage().getParameters().put('id',a.Id);
        ApexPages.Standardcontroller ctr = new ApexPages.StandardController(a);
        AccountRollupSummaryExtension ext = new AccountRollupSummaryExtension(ctr);
        
        System.assertEquals(1, ext.opportunityQTD);
        System.assertEquals(1, ext.opportunityLTD);
        System.assertEquals(1, ext.callsQTD);
        System.assertEquals(2, ext.callsLTD);
    }
}