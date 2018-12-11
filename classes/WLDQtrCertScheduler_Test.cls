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
private class WLDQtrCertScheduler_Test {

    @isTest
    static void testWLDQtrCertScheduler() {
        Account acct1 = TestDataFactory.createTestBusinessAccount();
        Account acct2 = TestDataFactory.createTestBusinessAccount();
        acct1.Account_Status__c = 'Active';
        List<Account> testAcctList = new List<Account>{acct1,acct2};
        insert testAcctList;
        
        Id qcRecordTypeId;
        Id acRecordTypeId;
        
        for(RecordType rt : [SELECT DeveloperName FROM RecordType WHERE SobjectType='WLD_Certification__c' AND IsActive=true]) {
            if(rt.DeveloperName == 'Account_Certification') {
                acRecordTypeId = rt.Id;
            } else if(rt.DeveloperName == 'Quarterly_Certification') {
                qcRecordTypeId = rt.Id;
            }
        }
        System.assertNotEquals(null, qcRecordTypeId, 'Unable to locate Quarterly Certification record type');
        System.assertNotEquals(null, acRecordTypeId, 'Unable to locate Account Certification record type');
        
        //set up test Account Certifications
        //to help ensure QCs are tested, set run date/time to 1/15
        Datetime runDateTime = Datetime.newInstance(Date.newInstance(Date.today().year()+1, 1, 15), Time.newInstance(0, 0, 0, 0));
        WLD_Certification__c cert1 = new WLD_Certification__c(Account__c=acct1.Id, RecordTypeId=acRecordTypeId, QLR_Year__c=String.valueOf(Date.today().year()), Status__c='6 - Signature Submitted (Approved)');
        WLD_Certification__c[] certs = new List<WLD_Certification__c>{cert1};
        insert certs;
        
        Test.startTest();
        String cronExp = '0 0 0 15 1 ? ' + String.valueOf(System.today().year()+1);
        System.debug('****** ' + cronExp);
        WLDQtrCertScheduler sch = new WLDQtrCertScheduler();
        sch.isTest = true;
        String jobId = System.schedule('testWLDQtrCertScheduler', cronExp, sch);
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT 
                            Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger 
                          WHERE id = :jobId];
        // Verify the expressions are the same
        System.assertEquals(cronExp, ct.CronExpression);

        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);

        // Verify the next time the job will run
        //System.assertEquals(String.valueOf(System.today().year()+1) + '-1-15 00:00:00', String.valueOf(ct.NextFireTime));
        System.assertEquals(0,
            [SELECT Id FROM WLD_Certification__c WHERE Account__c in :testAcctList AND RecordTypeId = :qcRecordTypeId].size());

        Test.stopTest();

        //Scheduled job will trigger after test; verify creation of certification records
        List<WLD_Certification__c> certList = [SELECT Id, Name FROM WLD_Certification__c WHERE Account__c in :testAcctList AND RecordTypeId = :qcRecordTypeId];
        System.debug(certList.size());
        //System.assertEquals(1, certList.size(), certList);
    }
}