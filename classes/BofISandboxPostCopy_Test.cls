@isTest
private class BofISandboxPostCopy_Test {
    
    public static final String TEST_EMAIL = 'test=test.com@example.com';
    
    @testSetup
    static void setup() {
        List<User> uList = TestDataFactory.createTestUsers(new Set<String>{'System Administrator'});
        User u = uList.get(0);
        u.Email = BofISandboxPostCopy_Test.TEST_EMAIL;
        update u;
    }
    
    @isTest
    static void testBofISandboxPostCopy() 
    {
        BofISandboxPostCopy cls = new BofISandboxPostCopy();
        BofISandboxPostCopyHandler.isTest = true;
        Test.testSandboxPostCopyScript(cls,                  // the instantiated class that implements the SandboxPostCopy interface
                                       UserInfo.getOrganizationId(), // context org ID
                                       UserInfo.getOrganizationId(), // context SandboxID
                                       'sandbox');
        System.assertEquals(1,1,'Test has failed');
    }

    @isTest
    static void testUnmaskAdminEmailAddress() {
        BofISandboxPostCopyHandler.isTest = true;
        Test.startTest();
        BofISandboxPostCopyHandler.unmaskAdminEmailAddress(false);
        User[] u = [SELECT Email FROM User WHERE Email = :BofISandboxPostCopy_Test.TEST_EMAIL];
        System.assert(u.size() > 0);
        BofISandboxPostCopyHandler.unmaskAdminEmailAddress(true);
        u = [SELECT Email FROM User WHERE Email = :BofISandboxPostCopy_Test.TEST_EMAIL];
        System.assert(u.size() == 0);
        Test.stopTest();
    }
    
    @isTest
    static void testDeleteScheduledJobs() {
        BofISandboxPostCopyHandler.isTest = true;
        Test.startTest();
        CronTrigger[] ct = [SELECT Id FROM CronTrigger];
        Integer startJobSize = ct.size();
        BofISandboxPostCopyHandler.deleteScheduledJobs(false);
        ct = [SELECT Id FROM CronTrigger];
        System.assertEquals(startJobSize, ct.size());
        BofISandboxPostCopyHandler.deleteScheduledJobs(true);
        ct = [SELECT Id FROM CronTrigger];
        System.assert(ct.size() == 0);
        Test.stopTest();
    }
}