@isTest
private class SchedulableRecordCleanup_Test {

	@isTest
    static void testSchedulableRecordCleanup() {
        Opportunity_Queue__c oq = new Opportunity_Queue__c();
        insert oq;
        Id oqId = oq.Id;
        
        Test.startTest();
        String sch = '0 0 23 * * ? ';
        SchedulableRecordCleanup src = new SchedulableRecordCleanup();
        System.schedule('TestRecordCleanup', sch, src);
        src.execute(null);
        Test.stopTest();
        Opportunity_Queue__c[] oqs = [SELECT Id FROM Opportunity_Queue__c WHERE Id = :oqId];
        System.assertEquals(0, oqs.size());
    }
}