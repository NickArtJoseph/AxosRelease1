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
private class BulkOpportunityCreateController_Test {

    /**
    * Tests the BulkOpportunityCreateController class
    */
    @isTest(SeeAllData='true')
    static void testBulkOpportunityCreateController() {
        BulkOpportunityCreateController ctr = new BulkOpportunityCreateController();
        
        ctr.isTest = true;
        
        //verify initial variables
        System.assertNotEquals(null, ctr.getBulkReportId());
        System.assertNotEquals(null, ctr.oppModel);
        System.assertEquals(null, ctr.selectedReport);
        System.assertEquals(-1, ctr.newOpportunityCount);
        System.assertEquals(null, ctr.bulkCreationDateTime);
        System.assertNotEquals(0, ctr.ownerOptions.size());
        System.assertEquals(0, ctr.selectedOwners.size());
        
        //verify option lists
        System.assert(ctr.getReportOptions().size() > 1, ctr.getReportOptions().size());
        
        System.assertEquals(null, ctr.rerender());
        ctr.oppModel.Name = 'Test';
        ctr.oppModel.LeadSource = 'Other';
        ctr.oppModel.Deposit_Relationship__c = 'Welcome List';
        ctr.oppModel.StageName = 'Open';
        ctr.oppModel.CloseDate = Date.today();
        
        //try creating opportunities--should fail due to missing data
        ctr.createOpportunities();
        System.assertEquals(-1, ctr.newOpportunityCount);
        
        //try setting both Service/Sales Call Attempts fields--will fail
        ctr.oppModel.Service_Call_Attempts__c = 'Attempt 1';
        ctr.oppModel.Sales_Call_Attempts__c = 'Attempt 1';
        ctr.createOpportunities();
        System.assertEquals(-1, ctr.newOpportunityCount);
        ctr.oppModel.Sales_Call_Attempts__c = null; //allow for progression
        
        //set owner type to first option
        ctr.selectedOwners.add(ctr.ownerOptions.get(1));
        ctr.createOpportunities();
        System.assertEquals(-1, ctr.newOpportunityCount);
        
        //set report
        ctr.selectedReport = ctr.getReportOptions().get(1).getValue();
        ctr.rerender();
        ctr.selectedReportFields.add(new SelectOption('Account.Id', '[Account] Id'));
        ctr.createOpportunities();
        
        System.assert(ctr.newOpportunityCount >= 0);
    }
}