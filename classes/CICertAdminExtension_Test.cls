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
private class CICertAdminExtension_Test {

    /** Tests CICertAdmin_Extension */
    @isTest
    static void testCICertAdminExtension() {
        Account acct = TestDataFactory.createAndInsertTestBusinessAccount();
        //Test using C&I - General Opportunity type
        Opportunity opp = new Opportunity(AccountId=acct.Id, 
                                            Name='Test', 
                                            RecordTypeId='012i0000001AcDB',
                                            StageName='Closed Won',
                                            CI_Rate_Type__c = 'Fixed',
                                            CI_Rate__c = 1,
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
        
        CICertAdmin_Extension ext = new CICertAdmin_Extension(new ApexPages.StandardController(opp));
        System.assertEquals(CICertAdmin_Extension.PageMode.READ.name(), ext.getModeName());
        ext.editCertMgmt();
        System.assertEquals(CICertAdmin_Extension.PageMode.EDIT.name(), ext.getModeName());
        ext.cancelCertMgmt();
        System.assertEquals(CICertAdmin_Extension.PageMode.READ.name(), ext.getModeName());
        
        ext.editCertMgmt();
        ext.opp.CI_Annual_Certification_Required__c = true;
        ext.saveCertMgmt();
        
        opp = [SELECT CI_Annual_Certification_Required__c FROM Opportunity WHERE Id = :opp.Id];
        //System.assertEquals(true, opp.CI_Annual_Certification_Required__c);
        
        ext.certTypeName = 'Annual Certification';
        ext.manage();
        System.assertEquals(1, ext.getAnnualChecklistItems().size());
        System.assertEquals(null, ext.getQuarterlyChecklistItems());
        System.assertEquals(null, ext.getMonthlyChecklistItems());
    }
}