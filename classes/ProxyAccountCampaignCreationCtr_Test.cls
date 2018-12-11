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
private class ProxyAccountCampaignCreationCtr_Test {

    @isTest(SeeAllData='true')
    static void testProxyAccountCampaignCreationController() {
        if(CD_Proxy_Account_Campaign_Config__c.getAll().values().size() > 0) {
            //delete current custom setting so that we can perform all necessary testing
            delete CD_Proxy_Account_Campaign_Config__c.getAll().values();
            
            ProxyAccountCampaignCreationController ctr = new ProxyAccountCampaignCreationController();
            System.assertEquals(null, ctr.config);          
        }
        
        //set up sample custom setting
        //Consumer Deposits campaign record type id: 012i0000001APtz
        //Consumer Deposits report with proper first column: 00Oi0000005p46d
        //Sample report with improper first column: 00Oi0000006G5rN
        CD_Proxy_Account_Campaign_Config__c config = new CD_Proxy_Account_Campaign_Config__c();
        config.Name='Test';
        config.Campaign_Owner_Id__c=Userinfo.getUserId();
        config.Campaign_Record_Type_Id__c='012i0000001APtz';
        config.Report_Id_List__c='00Oi0000005p46d,00Oi0000006G5rN';
        insert config;
        
        Account acct = TestDataFactory.createTestPersonAccount();
        //Consumer Deposits Person Account
        acct.RecordTypeId = '012i0000001AblM';
        acct.CIF_Person__c = 'TEST';
        insert acct;
        
        Financial_Account__c fin = new Financial_Account__c();
        fin.JHA_RECORD_ID__c = 'TEST';
        fin.Name = 'Test';
        fin.Open_Date__c = Date.today().addDays(-1);
        fin.Promo_Code__c = 'proxy';
        insert fin;
        
        Person_Financial_Account_Junction__c perfin = new Person_Financial_Account_Junction__c();
        perfin.Person_Account__c = acct.id;
        perfin.Financial_Account__c = fin.id;
        perfin.CIF_JHA_LINK__c = 'TEST|TEST';
        insert perfin;
        
        ProxyAccountCampaignCreationController ctr = new ProxyAccountCampaignCreationController();
        ctr.isTest = true;
        System.assertNotEquals(null, ctr.config);
        System.assertNotEquals(0, ctr.reportStateList.size());
        ctr.createCampaigns();
        
        List<ProxyAccountCampaignCreationController.CampaignReportState> crs = ctr.reportStateList;
        System.assert(true, crs.get(0).IsValidReport);
    }
}