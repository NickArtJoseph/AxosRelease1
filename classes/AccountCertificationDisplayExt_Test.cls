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
private class AccountCertificationDisplayExt_Test {

	/**
	* Tests the AccountCertificationDisplayExtension class
	*/
	@isTest
    static void testAccountCertificationDisplayExtension() {
        //create test account
        Account a = TestDataFactory.createAndInsertTestBusinessAccount();
        List<RecordType> recordTypes = [
        								SELECT DeveloperName
        								FROM RecordType
        								WHERE SobjectType = 'WLD_Certification__c'
        								];
        System.assert(recordTypes.size() > 0, 'No record types defined for Certification object');
        
        //test with no Account defined
        AccountCertificationDisplayExtension ext = new AccountCertificationDisplayExtension(new ApexPages.StandardController(new Account()));
        
        //set up with test Account record
        ApexPages.currentPage().getParameters().put('id',a.Id);
        ApexPages.Standardcontroller ctr = new ApexPages.StandardController(a);
        ext = new AccountCertificationDisplayExtension(ctr);
        
        System.assertEquals(0, ext.AccountCertifications.size(), 'Account should not have any Account Certifications');
        System.assertEquals(0, ext.QuarterlyCertifications.size(), 'Account should not have any Quarterly Certifications');
        System.assertEquals(false, ext.shouldRedirect);
        PageReference ref = ext.newAccountCertification();
        System.assertEquals(null, ref);
        System.assert(ext.shouldRedirect);
        Boolean hasRt = false;
        for(RecordType rt : recordTypes) {
        	if(rt.DeveloperName == 'Account_Certification') {
        		System.assert(ext.redirectURL.contains(rt.Id), 'Issue retrieving initial Account Certification url');
        		hasRt = true;
        		break;
        	}
        }
        if(!hasRt) {
        	System.assert(false, 'Account_Certification record type not found');
        }
        ref = ext.newQuarterlyCertification();
        System.assertEquals(null, ref);
        hasRt = false;
        for(RecordType rt : recordTypes) {
        	if(rt.DeveloperName == 'Quarterly_Certification') {
        		System.assert(ext.redirectURL.contains(rt.Id), 'Issue retrieving Quarterly Certification url');
        		hasRt = true;
        		break;
        	}
        }
        if(!hasRt) {
        	System.assert(false, 'Quarterly_Certification record type not found');
        }
        
        List<WLD_Certification__c> certs = new List<WLD_Certification__c>();
        Id acRt;
        Id qcRt;
        for(RecordType rt : recordTypes) {
        	if(rt.DeveloperName == 'Account_Certification') {
        		acRt = rt.Id;
        	} else if (rt.DeveloperName == 'Quarterly_Certification') {
        		qcRt = rt.Id;
        	}
        }
        WLD_Certification__c ac = new WLD_Certification__c(Name='Test',Account__c=a.Id,QLR_Year__c=String.valueOf(Date.today().year()), RecordTypeId=acRt);
        WLD_Certification__c qc = new WLD_Certification__c(Name='Test',Account__c=a.Id,QLR_Year__c=String.valueOf(Date.today().year()), RecordTypeId=qcRt, QLR_Quarter__c='QTR 1');
        certs.add(ac);
        certs.add(qc);
        insert certs;
        
        ext = new AccountCertificationDisplayExtension(ctr);
        System.assertEquals(1, ext.AccountCertifications.size(), 'Account should have 1 Account Certification');
        System.assertEquals(1, ext.QuarterlyCertifications.size(), 'Account should have 1 Quarterly Certification');
        ref = ext.newAccountCertification();
        hasRt = false;
        for(RecordType rt : recordTypes) {
        	if(rt.DeveloperName == 'Account_Recertification') {
        		System.assert(ext.redirectURL.contains(rt.Id), 'Issue retrieving Account Recertification url');
        		hasRt = true;
        		break;
        	}
        }
        if(!hasRt) {
        	System.assert(false, 'Account_Recertification record type not found');
        }
    }
}