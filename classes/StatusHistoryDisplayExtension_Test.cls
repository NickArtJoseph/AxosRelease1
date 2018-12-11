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
private class StatusHistoryDisplayExtension_Test {

	/**
	* Tests the statusHistoryDisplayExtension class
	*/
	@isTest
    static void testStatusHistoryDisplayExtension() {
        Account acct = TestDataFactory.createAndInsertTestBusinessAccount();
        WLD_Certification__c cert = TestDataFactory.createAndInsertTestCertification(acct, TestDataFactory.CertificationType.ACCOUNT);
        WLD_Credit_Review__c cred = TestDataFactory.createTestCreditReview(cert);
        insert cred;
        
        //set up with test Certification record
        ApexPages.currentPage().getParameters().put('id',cert.Id);
        ApexPages.Standardcontroller ctr = new ApexPages.StandardController(cert);
        StatusHistoryDisplayExtension ext = new StatusHistoryDisplayExtension(ctr);
        
        System.assertEquals(1, ext.getStatusHistory().size(),'Unable to retrieve Certification histories');
        
        ApexPages.currentPage().getParameters().put('id',cred.Id);
        ctr = new ApexPages.StandardController(cred);
        ext = new StatusHistoryDisplayExtension(ctr);
        
        System.assertEquals(1, ext.getStatusHistory().size(),'Unable to retrieve Credit Review histories');
    }
}