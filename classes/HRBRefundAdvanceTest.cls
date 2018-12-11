@isTest
private class HRBRefundAdvanceTest {
    static final String DEV  = 'CS13';
    static final String QA   = 'CS65';
    static final String UAT  = 'CS8';
    static final String PROD = 'NA46';


    static final String HRB_TEST_URL = 'https://bsltst.hrblock.net/ra/confirmapplication';
    static final String HRB_LNP_URL = 'https://lnpbesl2.hrblock.com/ra/confirmapplication';
    static final String HRB_PROD_URL = 'https://besl.hrblock.com/ra/confirmapplication';

    static final String HEROKU_DEV_URL = 'https://dev.topdialer.loan/applicant';
    static final String HEROKU_QA_URL = 'https://test.topdialer.loan/applicant';
    static final String HEROKU_UAT_URL = 'https://staging.topdialer.loan/applicant';
    static final String HEROKU_PROD_URL = 'https://api.topdialer.loan/applicant';

    // None of these work, because all methods are tied to callouts. 
    // full coverage from the callout tests, though
     @testSetup static void setup() {
        Test.setMock(HttpCalloutMock.class, new MockHRBResponseGnr8r());
        HRB_Refund_Advance__c h = new HRB_Refund_Advance__c();
        h.SSN_TIN__c = '000000000';
        h.Refund_Advance_Application_ID__c = 'MOCKTEST_ADVANCE_APPLICATION_ID';
        insert h;   
    }

    @isTest
    static void testInsert(){
        //Test.setMock(HttpCalloutMock.class, new MockHRBResponseGnr8r());
        Test.setMock(HttpCalloutMock.class, new MockHerokuResponseGnr8r());
        
        HRB_Refund_Advance__c h = new HRB_Refund_Advance__c();
        h.SSN_TIN__c = '000000000';
        Datetime dt = System.Datetime.now();
        // System.debug('TEST' + dt.format('Ymd_HMS'));        
        //h.Refund_Advance_Application_ID__c = 'TEST'+ dt.format('Ymd_HMS');
        h.Refund_Advance_Application_ID__c ='MOCKTEST_ADVANCE_APPLICATION_ID';
        insert h;
        System.assertNotEquals(Null, h.Id);
        System.assertEquals('000000000', h.SSN_TIN__c);
        //System.assertEquals('TEST'+dt.format('Ymd_HMS'), h.Refund_Advance_Application_ID__c);
        System.assertEquals('MOCKTEST_ADVANCE_APPLICATION_ID', h.Refund_Advance_Application_ID__c);
        HRBRefundStatus__c status = [SELECT Id, CreatedAt__c, CompletedAt__c, isCompleted__c FROM HRBRefundStatus__c WHERE HRB_Refund_Advance__c = :h.Id];
        System.assertNotEquals(Null, status);
        System.assertEquals(Null, status.CompletedAt__c);
        System.assertEquals(False, status.isCompleted__c);      
    }
   
    @isTest
    static void testUpdate(){
        Test.setMock(HttpCalloutMock.class, new MockHRBResponseGnr8r());
        //Test.setMock(HttpCalloutMock.class, new MockHerokuResponseGnr8r());
        
        HRB_Refund_Advance__c h = new HRB_Refund_Advance__c();
        h.SSN_TIN__c = '000000000';
        Datetime dt = System.Datetime.now();
        // System.debug('TEST' + dt.format('Ymd_HMS'));        
        //h.Refund_Advance_Application_ID__c = 'TEST'+ dt.format('Ymd_HMS');
        h.Refund_Advance_Application_ID__c ='MOCKTEST_ADVANCE_APPLICATION_ID';
        
        insert h;
        h.City__c = 'San Diego';
        update h;       
    }
    
    @isTest
    static void testAutoUpdate(){
        Test.setMock(HttpCalloutMock.class, new MockHRBResponseGnr8r());
        //Test.setMock(HttpCalloutMock.class, new MockHerokuResponseGnr8r());

        HRB_Refund_Advance__c h = new HRB_Refund_Advance__c();
        h.SSN_TIN__c = '000000000';
        Datetime dt = System.Datetime.now();
        // System.debug('TEST' + dt.format('Ymd_HMS'));        
        //h.Refund_Advance_Application_ID__c = 'TEST'+ dt.format('Ymd_HMS');
        h.Refund_Advance_Application_ID__c ='MOCKTEST_ADVANCE_APPLICATION_ID';
        
        insert h;
        h.DecisionBy__c = 'AUTO';
        h.AutoDecision__c = 'APD';
        h.HRBDecision__c = h.AutoDecision__c;
        update h;
        System.assertEquals(h.AutoDecision__c, h.HRBDecision__c);       
    }   
    
    @isTest
    static void testHerokuURL(){
       //HRBRefundAdvanceTriggerHandler h = HRBRefundAdvanceTriggerHandler();
        String url = '';
        url = HRBRefundAdvanceTriggerHandler.herokuURL(DEV,true);
        System.assertEquals(url, HEROKU_DEV_URL);
        url = HRBRefundAdvanceTriggerHandler.herokuURL('CS17',true);
        System.assertEquals(url, HEROKU_DEV_URL);
        url = HRBRefundAdvanceTriggerHandler.herokuURL(QA,true);
        System.assertEquals(url, HEROKU_QA_URL);
        url = HRBRefundAdvanceTriggerHandler.herokuURL(UAT,true);
        System.assertEquals(url, HEROKU_UAT_URL);

        //production
        url = HRBRefundAdvanceTriggerHandler.herokuURL('BOFI',false);
        System.assertEquals(url, HEROKU_PROD_URL);
        url = HRBRefundAdvanceTriggerHandler.herokuURL(PROD,false);
        System.assertEquals(url, HEROKU_PROD_URL);
    }


    @isTest
    static void testBlockURL(){
        //HRBRefundAdvanceTriggerHandler h = HRBRefundAdvanceTriggerHandler();
        String url = '';
        url = HRBRefundAdvanceTriggerHandler.blockURL(DEV,true);
        System.assertEquals(url, HRB_TEST_URL);
        url = HRBRefundAdvanceTriggerHandler.blockURL('CS17',true);
        System.assertEquals(url, HRB_TEST_URL);
        url = HRBRefundAdvanceTriggerHandler.blockURL(QA,true);
        System.assertEquals(url, HRB_TEST_URL);
     //   url = HRBRefundAdvanceTriggerHandler.blockURL(UAT,true);
     //   System.assertEquals(url, HRB_LNP_URL);

        // production
        url = HRBRefundAdvanceTriggerHandler.blockURL('BOFI',false);
        System.assertEquals(url, HRB_PROD_URL);
        url = HRBRefundAdvanceTriggerHandler.blockURL(PROD,false);
        System.assertEquals(url, HRB_PROD_URL);
    }

    @isTest
    static void testNegativeAutoUpdate(){
        Test.setMock(HttpCalloutMock.class, new MockHRBResponseGnr8r());
        //Test.setMock(HttpCalloutMock.class, new MockHerokuResponseGnr8r());

        HRB_Refund_Advance__c h = new HRB_Refund_Advance__c();
        h.SSN_TIN__c = '000000000';
        Datetime dt = System.Datetime.now();
        // System.debug('TEST' + dt.format('Ymd_HMS'));        
        //h.Refund_Advance_Application_ID__c = 'TEST'+ dt.format('Ymd_HMS');
        h.Refund_Advance_Application_ID__c ='MOCKTEST_ADVANCE_APPLICATION_ID';
        
        insert h;
        h.AutoDecision__c = 'APD';
        h.DecisionBy__c = 'MANUAL';
        // h.ManualDecision__c = 'DCL';
        // h.HRBDecision__c = h.ManualDecision__c;
        update h;
        
        // make sure that HRBDecision__c does not get set by AUTO
        System.assertNotEquals(h.AutoDecision__c, h.HRBDecision__c);        
    }

    @isTest
    static void testInvalidDecision(){
        Test.setMock(HttpCalloutMock.class, new MockHRBResponseGnr8r());
        HRB_Refund_Advance__c h = new HRB_Refund_Advance__c();
        h.SSN_TIN__c = '000000000';
        Datetime dt = System.Datetime.now();
        h.Refund_Advance_Application_ID__c ='MOCKTEST_ADVANCE_APPLICATION_ID';
        h.AutoDecision__c = 'APL';
        h.ManualDecision__c = 'DPL';

        insert h;
        System.assertNotEquals(h.HRBDecision__c,'APL');
        System.assertNotEquals(h.HRBDecision__c,'DPL');
    }
    
    @isTest
    static void testUpdateStatusFields(){
        Test.setMock(HttpCalloutMock.class, new MockHRBResponseGnr8r());
        //Test.setMock(HttpCalloutMock.class, new MockHerokuResponseGnr8r());

        HRB_Refund_Advance__c h = new HRB_Refund_Advance__c();
        h.SSN_TIN__c = '000000000';
        Datetime dt = System.Datetime.now();
        // System.debug('TEST' + dt.format('Ymd_HMS'));        
        //h.Refund_Advance_Application_ID__c = 'TEST'+ dt.format('Ymd_HMS');
        h.Refund_Advance_Application_ID__c ='MOCKTEST_ADVANCE_APPLICATION_ID';
        
        insert h;
        //Now update with AutoDecision = APD and Decision_By = MANUAL
        h.DecisionBy__c = 'MANUAL';
        h.AutoDecision__c = 'APD';
        update h;
        HRBRefundStatus__c status = [SELECT Id, AutoDecisionAt__c, CompletedAt__c, isCompleted__c FROM HRBRefundStatus__c WHERE HRB_Refund_Advance__c = :h.Id];
        System.assertNotEquals(h.AutoDecision__c, h.HRBDecision__c);
        System.assertEquals(Null, h.HRBDecision__c);
        System.assertNotEquals(Null, status.AutoDecisionAt__c);
        System.assertNotEquals(True, status.isCompleted__c);
        System.assertEquals(Null, status.CompletedAt__c);
        
    }

    

}