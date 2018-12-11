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
private class CIChecklistItemTriggerHandler_Test {

	/**
	* Tests the trigger functionality contained in the CIChecklistItemTriggerHandler class
	*/
	@isTest
    static void testCIChecklistItemTriggerHandler() {
        Account acct = TestDataFactory.createAndInsertTestBusinessAccount();
    	//Test using C&I - General Opportunity type
    	User u = [SELECT Id FROM User WHERE Profile.Name LIKE 'C&I%' AND IsActive = true LIMIT 1];
        Opportunity opp = new Opportunity(AccountId=acct.Id, 
        									Name='Test', 
        									RecordTypeId='012i0000001AcDB',
                                            CI_Rate_Type__c = 'Fixed',
                                            CI_Rate__c = 1,
        									StageName='Closed Won',
        									CloseDate=Date.today(),
        									OwnerId = u.Id);
       insert opp;
       RecordType rt = [SELECT Id, Name FROM RecordType WHERE SObjectType='CI_Certification__c' LIMIT 1];       
       CI_Certification__c cert = TestDataFactory.createTestCICertification(opp);
       cert.RecordTypeId = rt.Id;
       insert cert;
       
       C_I_Checklist_Item__c citem = new C_I_Checklist_Item__c(Name='Test', Certification__c=cert.Id,Status__c='Requested', Grace_Period__c=1);
       insert citem;
       
       cert = [SELECT AllItemsReceived__c FROM CI_Certification__c WHERE Id = :cert.Id];
       System.assertEquals(false, cert.AllItemsReceived__c);
       
       citem.Status__c = 'Received';
       update citem;
       
       cert = [SELECT AllItemsReceived__c FROM CI_Certification__c WHERE Id = :cert.Id];
       System.assertEquals(true, cert.AllItemsReceived__c);
       
       citem.Status__c = 'Resubmitted';
       update citem;
       
       cert = [SELECT AllItemsReceived__c FROM CI_Certification__c WHERE Id = :cert.Id];
       System.assertEquals(false, cert.AllItemsReceived__c);
    }
}