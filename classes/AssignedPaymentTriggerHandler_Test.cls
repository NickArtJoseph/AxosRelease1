@isTest
private class AssignedPaymentTriggerHandler_Test {

    @testSetup
    static void setup() {
        //set up test records
        Account a = TestDataFactory.createTestPersonAccount();
        a.RecordTypeId = '012i0000001AM01';
        insert a;
        
        Opportunity o = new Opportunity();
        o.AccountId = a.Id;
        o.Name = a.Id + ' Opportunity';
        o.StageName = 'Pricing';
        o.CloseDate = System.Date.today();
        insert o;
    }
    
    @isTest
    static void testCalculateLastPaymentDate() {
        Opportunity o = [SELECT Id FROM Opportunity LIMIT 1][0];
        //lump sum
        Assigned_Payments__c lumpSum = new Assigned_Payments__c(Opportunity__c=o.Id,Payment_Frequency__c='lump sum',First_Payment_Date__c=Date.today(),Percent_Increase__c=0,Amount__c=1);
        //weekly: 2 payments
        Assigned_Payments__c weekly = new Assigned_Payments__c(Opportunity__c=o.Id,Payment_Frequency__c='weekly',Number_of_Payments__c=2,First_Payment_Date__c=Date.today(),Percent_Increase__c=0,Amount__c=1);
        //annual: 2 payments
        Assigned_Payments__c annual = new Assigned_Payments__c(Opportunity__c=o.Id,Payment_Frequency__c='annual',Number_of_Payments__c=2,First_Payment_Date__c=Date.today(),Percent_Increase__c=0,Amount__c=1);
        //semiannual: 2 payments
        Assigned_Payments__c semiAnnual = new Assigned_Payments__c(Opportunity__c=o.Id,Payment_Frequency__c='semiannual',Number_of_Payments__c=2,First_Payment_Date__c=Date.today(),Percent_Increase__c=0,Amount__c=1);
        //quarterly: 2 payments
        Assigned_Payments__c quarterly = new Assigned_Payments__c(Opportunity__c=o.Id,Payment_Frequency__c='quarterly',Number_of_Payments__c=2,First_Payment_Date__c=Date.today(),Percent_Increase__c=0,Amount__c=1);
        //monthly: 2 payments
        Assigned_Payments__c monthly = new Assigned_Payments__c(Opportunity__c=o.Id,Payment_Frequency__c='monthly',Number_of_Payments__c=2,First_Payment_Date__c=Date.today(),Percent_Increase__c=0,Amount__c=1);
        
        Assigned_Payments__c[] aps = new Assigned_Payments__c[]{lumpSum,weekly,annual,semiAnnual,quarterly,monthly};
        Test.startTest();
        insert aps;
        Date newDate = Date.today();
        newDate = newDate.toStartOfMonth();
        aps[0].First_Payment_Date__c = newDate;
        update aps;
        Test.stopTest();
        
        for(Assigned_Payments__c ap : [SELECT Id, Last_Payment_Date__c FROM Assigned_Payments__c WHERE Id in :aps]) {
            if(ap.Id == aps[0].Id) {
                //lump sump
                Date testDate = Date.today();
                testDate = testDate.toStartOfMonth();
                System.assertEquals(testDate, ap.Last_Payment_Date__c,'Wrong date for lump sum');
            } else if(ap.Id == aps[1].Id) {
                //weekly
                Date compareDate = Date.today();
                compareDate = compareDate.addDays(7);
                System.assertEquals(compareDate, ap.Last_Payment_Date__c,'Wrong date for weekly');
            } else if(ap.Id == aps[2].Id) {
                //annual
                Date compareDate = Date.today();
                compareDate = compareDate.addYears(1);
                System.assertEquals(compareDate, ap.Last_Payment_Date__c,'Wrong date for annual');
            } else if(ap.Id == aps[3].Id) {
                //semiannual
                Date compareDate = Date.today();
                compareDate = compareDate.addMonths(6);
                System.assertEquals(compareDate, ap.Last_Payment_Date__c,'Wrong date for semiannual');
            } else if(ap.Id == aps[4].Id) {
                //quarterly
                Date compareDate = Date.today();
                compareDate = compareDate.addMonths(3);
                System.assertEquals(compareDate, ap.Last_Payment_Date__c,'Wrong date for quarterly');
            } else if(ap.Id == aps[5].Id) {
                //monthly
                Date compareDate = Date.today();
                compareDate = compareDate.addMonths(1);
                System.assertEquals(compareDate, ap.Last_Payment_Date__c,'Wrong date for monthly');
            } 
        }
        
    }
}