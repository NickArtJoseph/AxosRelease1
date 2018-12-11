@isTest
private class TPOAccountDailyTouchScheduler_Test {
	@isTest
    static void testTPOAccountDailyTouchScheduler() {
       
        Test.startTest();
        String cronExp = '0 0 0 15 1 ? ' + String.valueOf(System.today().year()+1);
        System.debug('****** ' + cronExp);
        TPOAccountDailyTouchScheduler sch = new TPOAccountDailyTouchScheduler();
        String jobId = System.schedule('testTPOAccountDailyTouchScheduler', cronExp, sch);
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT 
                            Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger 
                          WHERE id = :jobId];
        // Verify the expressions are the same
        System.assertEquals(cronExp, ct.CronExpression);

        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);

        Test.stopTest();
    }
    
    @isTest
    static void testTPOAccountDailyTouchHandler() {
        RecordType tpoRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'TPO_Account' AND IsActive=true and sObjectType='Account' LIMIT 1];
        Account acct1 = TestDataFactory.createTestBusinessAccount();
        Account acct2 = TestDataFactory.createTestBusinessAccount();
		acct1.RecordTypeId = tpoRT.Id;
        acct2.RecordTypeId = tpoRT.Id;
        acct1.Document_Status__c = 'Recertification Required';
        acct2.Document_Status__c = 'Recertification Required';
        acct1.SFR_TPO_IPL_Account_Type__c = 'Warehouse';
        acct2.SFR_TPO_IPL_Account_Type__c = 'Warehouse';
        acct1.NMLSID__c = '00000';
        acct2.NMLSID__c = '00001';
        acct1.TPOToggleWorkflow__c = '1';
        acct2.TPOToggleWorkflow__c = '2';
        List<Account> testAcctList = new List<Account>{acct1,acct2};
        insert testAcctList;
        
        Test.startTest();
        TPOAccountDailyTouchHandler handler = new TPOAccountDailyTouchHandler();
        database.executeBatch(handler);
        Test.stopTest();

        //Scheduled job will trigger after test; verify update of toggle field
        for(Account a : [SELECT Id, TPOToggleWorkflow__c FROM Account WHERE Id in :testAcctList]) {
            if(a.Id == acct1.Id) {
                System.assertEquals('2', a.TPOToggleWorkflow__c, 'Account 1 record was not toggled');
            } else if (a.Id == acct2.Id) {
                System.assertEquals('1', a.TPOToggleWorkflow__c, 'Account 2 record was not toggled');
            }
        }
    }
}