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
private class CICertificationDisplayController_Test {

	/** Tests the CICertificationDisplayController class used by the CICertificationDisplay component*/
	@isTest
    static void testCICertificationDisplayController() {
    	Account acct = TestDataFactory.createAndInsertTestBusinessAccount();
    	//Test using C&I - General Opportunity type
        Opportunity opp = new Opportunity(AccountId=acct.Id, 
        									Name='Test', 
        									RecordTypeId='012i0000001AcDB',
                                            CI_Rate_Type__c = 'Fixed',
                                            CI_Rate__c = 1,
        									StageName='Closed Won',
        									CloseDate=Date.today());
       insert opp;
       
       CICertificationDisplayController ctr = new CICertificationDisplayController();
       ctr.oppId = opp.Id;
       RecordType rt = [SELECT Id, Name FROM RecordType WHERE SObjectType='CI_Certification__c' LIMIT 1];
       ctr.certRTId = rt.Id;
       System.assertEquals(rt.Name, ctr.certRecordTypeName);
       System.assertEquals(rt.Name + 's', ctr.getBlockTitle());
       System.assertEquals(0, ctr.CertificationList.size());
       
       CI_Certification__c cert = TestDataFactory.createTestCICertification(opp);
       cert.RecordTypeId = rt.Id;
       insert cert;
    	
        ctr = new CICertificationDisplayController();
        ctr.oppId = opp.Id;
        ctr.certRTId = rt.Id;
        System.assertEquals(1, ctr.CertificationList.size());
    }
}