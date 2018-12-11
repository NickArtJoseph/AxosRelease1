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
private class CICertificationScheduler_Test {

    /** Tests both the CICertificationScheduler and CICertificationCreationHandler classes */
    @isTest
    static void testCICertificationScheduler() {
        Account acct = TestDataFactory.createAndInsertTestBusinessAccount();
        
        //Test using C&I - General Opportunity type
        User u = [SELECT Id FROM User WHERE Profile.Name LIKE 'C&I%' AND IsActive = true LIMIT 1];
        Opportunity opp = new Opportunity(AccountId=acct.Id, 
                                            Name='Test', 
                                            RecordTypeId='012i0000001AcDB',
                                            CI_Rate_Type__c = 'Fixed',
                                            CI_Rate__c = 1,
                                            StageName='Closed Won',
                                            CI_Annual_Certification_Required__c=true,
                                            CI_Quarterly_Certification_Required__c=true,
                                            CI_Monthly_Certification_Required__c=true,
                                            CloseDate=Date.today(),
                                            OwnerId=u.Id);
        insert opp;
        
        C_I_Checklist_Item_Admin__c citemAnnual = new C_I_Checklist_Item_Admin__c(
                                            Opportunity__c=opp.Id,
                                            Certification_Type__c='Annual Certification',
                                            Checklist_Item_Name__c='TestAnnual',
                                            Name='TestAnnual',
                                            Grace_Period__c=1
                                            );
        C_I_Checklist_Item_Admin__c citemQuarterly = new C_I_Checklist_Item_Admin__c(
                                            Opportunity__c=opp.Id,
                                            Certification_Type__c='Quarterly Certification',
                                            Checklist_Item_Name__c='TestQuarterly',
                                            Name='TestQuarterly',
                                            Grace_Period__c=1
                                            );
        C_I_Checklist_Item_Admin__c citemMonthly = new C_I_Checklist_Item_Admin__c(
                                            Opportunity__c=opp.Id,
                                            Certification_Type__c='Monthly Certification',
                                            Checklist_Item_Name__c='TestMonthly',
                                            Name='TestMonthly',
                                            Grace_Period__c=1
                                            );
        List<C_I_Checklist_Item_Admin__c> citems = new List<C_I_Checklist_Item_Admin__c>{citemAnnual, citemQuarterly, citemMonthly};
        insert citems;
        
        Test.startTest();
        //December will trigger monthly, quarterly and annual certification creations
        String cronExp = '0 0 0 1 12 ? ' + String.valueOf(System.today().year() + 1);
        System.debug('****** ' + cronExp);
        CICertificationScheduler sch = new CICertificationScheduler();
        sch.isTest = true;
        String jobId = System.schedule('testCICertificationScheduler', cronExp, sch);
        
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
        System.assertEquals(0,
            [SELECT Id FROM CI_Certification__c WHERE Opportunity__c = :opp.id].size());

        Test.stopTest();

        //Scheduled job will trigger after test; verify creation of certification records
        List<CI_Certification__c> certList = [SELECT Id, Name FROM CI_Certification__c WHERE Opportunity__c = :opp.Id];
        System.assertEquals(3, certList.size(), certList);
    }
}