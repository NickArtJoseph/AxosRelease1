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
private class CICertChecklistAdminController_Test {

	@isTest
    static void testCICertChecklistAdminController() {
        Account acct = TestDataFactory.createAndInsertTestBusinessAccount();
        //Test using C&I - General Opportunity type
        Opportunity opp = new Opportunity(AccountId=acct.Id, 
        									Name='Test', 
        									RecordTypeId='012i0000001AcDB',
                                            CI_Rate_Type__c = 'Fixed',
                                            CI_Rate__c = 1,
        									StageName='Closed Won',
        									CloseDate=Date.today());
        insert opp;
        
        C_I_Checklist_Item_Admin__c citem = new C_I_Checklist_Item_Admin__c(
        									Opportunity__c=opp.Id,
        									Certification_Type__c='Annual Certification',
        									Checklist_Item_Name__c='Test',
        									Name='Test',
        									Grace_Period__c=1
        									);
        insert citem;
        
        PageReference ref = Page.CICertChecklistAdmin;
        ref.getParameters().put('id', opp.Id);
        ref.getParameters().put('ctype', 'Annual Certification');
        Test.setCurrentPage(ref);
        
        CICertChecklistAdminController ctr = new CICertChecklistAdminController();
        System.assertEquals(opp.Id, ctr.getOpportunity().Id);
        System.assertEquals('/' + opp.Id, ctr.returnToOpp().getUrl());
        System.assertEquals('Annual Certification', ctr.getCertificationTypeName());
        System.assert(ctr.getChecklistItemNames().size() > 0);
        System.assert(ctr.getChecklistItemOptions().size() > 0);
        
        ctr.addItem();
        System.assertEquals(null, ctr.selectedItem);
        
        ctr.selectedItem = 'Test2';
        ctr.addItem();
        ctr.saveChecklistItem(); //will fail
        System.assertEquals(1, ctr.RequiredChecklistItemList.size());
        
        ctr.modifyChecklistItem.Grace_Period__c = 5;
        ctr.saveChecklistItem(); //will succeed
        System.assertEquals(2, ctr.RequiredChecklistItemList.size());
        
        ctr.checklistId = citem.Id;
        ctr.editChecklistItem();
        ctr.cancelChecklistItem();
        System.assertEquals(null, ctr.checklistId);
        
        ctr.checklistId = citem.Id;
        ctr.editChecklistItem();
        ctr.modifyChecklistItem.Grace_Period__c = 100;
        ctr.saveChecklistItem();
        
        ctr.checklistId = citem.Id;
        ctr.deleteChecklistItem();
    }
}