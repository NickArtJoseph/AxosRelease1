@isTest
private class Bofi_HRB_DecisionControllerTest {
	
	@isTest static void test_createCase() {
        Test.setMock(HttpCalloutMock.class, new MockHRBResponseGnr8r());
        //Test.setMock(HttpCalloutMock.class, new MockHerokuResponseGnr8r());
        HRB_Refund_Advance__c h = new HRB_Refund_Advance__c();
        h.SSN_TIN__c = '000000000';
        //h.Refund_Advance_Application_ID__c = 'TEST_Refund_Advance_Application_ID__c';
        h.Refund_Advance_Application_ID__c ='MOCKTEST_ADVANCE_APPLICATION_ID';        
        insert h;

        Bofi_HRB_DecisionController.createCase('MOCKTEST_ADVANCE_APPLICATION_ID', 'DCL', '99', 'You have a bunch of offsets','AUTO');
	}
	
	
}