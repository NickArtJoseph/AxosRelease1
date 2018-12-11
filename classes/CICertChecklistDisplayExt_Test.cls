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
private class CICertChecklistDisplayExt_Test {

	@isTest
    static void testCICertChecklistDisplayExt() {
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
       RecordType rt = [SELECT Id, Name FROM RecordType WHERE SObjectType='CI_Certification__c' LIMIT 1];       
       CI_Certification__c cert = TestDataFactory.createTestCICertification(opp);
       cert.RecordTypeId = rt.Id;
       insert cert;
       
       C_I_Checklist_Item__c citem = new C_I_Checklist_Item__c(Name='Test', Certification__c=cert.Id,Status__c='Requested', Grace_Period__c=1);
       insert citem;
       
       PageReference ref = Page.CICertChecklistDisplay;
       ref.getParameters().put('id', cert.Id);
       Test.setCurrentPageReference(ref);
       CICertChecklistDisplayExt ext = new CICertChecklistDisplayExt(new Apexpages.StandardController(cert));
       System.assertEquals(1, ext.getChecklistItems().size());
       
       System.assertEquals(true, ext.isEditor);
       
       ext.editItem();
       System.assertEquals(null, ext.modifyItem);
       
       ext.selectedItemId = citem.id;
       ext.selectedItemStatus = 'Requested';
       ext.editItem();
       System.assertEquals(citem.Id, ext.modifyItem.Id);
       System.assertEquals('Requested', ext.modifyItem.Status__c);
       System.assertEquals(true, ext.isEdit);
       ext.cancelItem();
       System.assertEquals(null, ext.modifyItem);
       System.assertEquals(false, ext.isEdit);
       
       ext.selectedItemId = citem.id;
       ext.selectedItemStatus = 'Requested';
       ext.editItem();
       ext.modifyItem.Status__c = 'Received';
       ext.saveItem();
       citem = [SELECT Status__c FROM C_I_Checklist_Item__c WHERE Id = :citem.Id];
       System.assertEquals('Received', citem.Status__c);
       ext.getReadyForApprovalImage();
    }
}