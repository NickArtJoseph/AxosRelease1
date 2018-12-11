@isTest
private without sharing class BOFI_IFL_ControllerTest {

    @testSetup 
    public static void setup() {
        Test.setMock(HttpCalloutMock.class, new MockHRBResponseGnr8r());
        
        USER Queue = [SELECT Id, Name from USER WHERE Name = 'HRB-API1'];
        HRB_Refund_Advance__c h = new HRB_Refund_Advance__c();
        h.SSN_TIN__c = '000000000';
        h.Refund_Advance_Application_ID__c = 'MOCKTEST_ADVANCE_APPLICATION_ID';
        insert h;
        h.DecisionBy__c = 'MANUAL';
        h.OwnerId = Queue.Id;
        update h;
    }
    @isTest
    static void test_constructor(){
        Test.startTest();
            BOFI_IFL_Controller id = new BOFI_IFL_Controller();
        Test.stopTest();
    }

    @isTest    
    static void test_setup(){
        // setup creates a record, avaialble for tests
        Test.startTest();
            HRB_Refund_Advance__c h = [SELECT OwnerId, Id, Name,SSN_TIN__c from HRB_Refund_Advance__c WHERE Refund_Advance_Application_ID__c = 'MOCKTEST_ADVANCE_APPLICATION_ID' ];
        Test.stopTest();
        System.assertEquals('000000000', h.SSN_TIN__c);        
    }

    @isTest static void test_owner(){
        // setup sets owner of reecord to the queue id
        USER Queue = [SELECT Id, Name from USER WHERE Name = 'HRB-API1'];        
        HRB_Refund_Advance__c h = [SELECT OwnerId, Id, Name,SSN_TIN__c from HRB_Refund_Advance__c WHERE Refund_Advance_Application_ID__c = 'MOCKTEST_ADVANCE_APPLICATION_ID' ];
        System.assertEquals(Queue.Id, h.OwnerId);        
    }
    

	@isTest static void test_usr() {
		// Is the current user name the same as the current user, when testing?
        Test.startTest();
            BOFI_IFL_Controller t = new BOFI_IFL_Controller();
        Test.stopTest();
        System.assertEquals(UserInfo.getName(), t.usr());
	}
	

    @isTest static void test_getRecords() {
        // Implement test code
        Test.startTest();
            setup();
            BOFI_IFL_Controller t = new BOFI_IFL_Controller();
            List<HRBRefundStatus__c> records = t.getRecords();
        Test.stopTest();
    }

     @isTest static void test_UpdStatusToAccept() {
        // Implement test code
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHRBResponseGnr8r());
            BOFI_IFL_Controller ifl = new BOFI_IFL_Controller();
            setup();
            String hrbId = [select Id from HRB_Refund_Advance__c where Refund_Advance_Application_ID__c = 'MOCKTEST_ADVANCE_APPLICATION_ID' limit 1].Id;
            String theId = [select Id from HRBRefundStatus__c where HRB_Refund_Advance__c =: hrbId].Id;
            ifl.RecId = theId;
            ifl.UpdStatusToAccept();
        Test.stopTest();   
    }


    @isTest static void test_UpdStatusToReject() {
        // Implement test code
        Test.startTest();
           Test.setMock(HttpCalloutMock.class, new MockHRBResponseGnr8r());
            BOFI_IFL_Controller ifl = new BOFI_IFL_Controller();
            setup();
            String hrbId = [select Id from HRB_Refund_Advance__c where Refund_Advance_Application_ID__c = 'MOCKTEST_ADVANCE_APPLICATION_ID' limit 1].Id;
            String theId = [select Id from HRBRefundStatus__c where HRB_Refund_Advance__c =: hrbId].Id;
            ifl.RecId = theId;
            ifl.UpdStatusToReject();
        Test.stopTest();
    }    


    @isTest static void test_quit() {
        // Implement test code
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHRBResponseGnr8r());
            BOFI_IFL_Controller ifl = new BOFI_IFL_Controller();
            setup();
            String hrbId = [select Id from HRB_Refund_Advance__c where Refund_Advance_Application_ID__c = 'MOCKTEST_ADVANCE_APPLICATION_ID' limit 1].Id;
            String theId = [select Id from HRBRefundStatus__c where HRB_Refund_Advance__c =: hrbId].Id;
            ifl.RecId = theId;
            ifl.quit();
        Test.stopTest();
    }
}