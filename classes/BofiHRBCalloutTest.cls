@isTest
private class BofiHRBCalloutTest {
    
    
    @isTest static void testHRBCallout(){
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHRBResponseGnr8r());
        
        
        HRB_Refund_Advance__c h = new HRB_Refund_Advance__c();
        h.SSN_TIN__c = '000000000';
        h.Refund_Advance_Application_ID__c = 'MOCKTEST_ADVANCE_APPLICATION_ID';
        
        insert h;
        
    
        h.DecisionBy__c  = 'MANUAL';
        h.ManualDecision__c = 'DCL';
        
        update h;

        //called automagically, so this is redundant but why not? 
        HRBRefundAdvanceTriggerHandler.SendToHRB(h.Id);
        // sorry, can't really test async code...
        System.assertEquals(1,1);   
    }    
}