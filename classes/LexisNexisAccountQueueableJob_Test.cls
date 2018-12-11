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
private class LexisNexisAccountQueueableJob_Test {

	@isTest
    static void testLexisNexisAccountQueueableJob_CalloutFailure() {
    	List<Id> sfRTidList = new List<Id>();
    	sfRTidList.addAll(AccountTriggerHandler.lxnxSpecFinRTIdSet);
    	Id sfRTid = sfRTidList[0];
    	
        Account acct = TestDataFactory.createTestPersonAccount();
        acct.RecordTypeId = sfRTid;
        acct.Research_Status_Person__c = 'New Unresearched';
        acct.Social_Security_Number_Person__c = '999-99-9999';
        
		Test.startTest();
        insert acct;
        TestDataFactory.SingleRequestMock callout = null;
        LexisNexisAccountQueueableJob job = new LexisNexisAccountQueueableJob(acct, true, callout);
        System.enqueueJob(job);

		Test.stopTest();
		
		for(Account acc : [SELECT SF_LexisNexis_Callout_Status__c, SF_LexisNexis_Callout_Date_Time__c FROM Account WHERE Id = :acct.Id]) {
			System.assertEquals('Failed', acc.SF_LexisNexis_Callout_Status__c);
			System.assertNotEquals(null, acc.SF_LexisNexis_Callout_Date_Time__c);
		}
    }

	@isTest
    static void testLexisNexisAccountQueueableJob_InvalidLogin() {
    	List<Id> sfRTidList = new List<Id>();
    	sfRTidList.addAll(AccountTriggerHandler.lxnxSpecFinRTIdSet);
    	Id sfRTid = sfRTidList[0];
    	
        Account acct = TestDataFactory.createTestPersonAccount();
        acct.RecordTypeId = sfRTid;
        acct.Research_Status_Person__c = 'New Unresearched';
        acct.Social_Security_Number_Person__c = '999-99-9999';
        
		Test.startTest();
        insert acct;
        TestDataFactory.SingleRequestMock callout = new TestDataFactory.SingleRequestMock(
            									  0,
                                                 'Error',
                                                 '<html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/><title>ESP - Access Denied</title><script type=\'text/javascript\'>function closeWin() { var f=top.frames[\'header\']; if (f) f.onUserIdChanged(null); top.opener=top; top.close(); }</script></head><body onload="javascript:closeWin();"><b>Access Denied -- Valid username and password required!</b></body></html>',
                                                 null);
        LexisNexisAccountQueueableJob job = new LexisNexisAccountQueueableJob(acct, true, callout);
        System.enqueueJob(job);
		
		Test.stopTest();
		
		for(Account acc : [SELECT SF_LexisNexis_Callout_Status__c, SF_LexisNexis_Callout_Date_Time__c FROM Account WHERE Id = :acct.Id]) {
			System.assertEquals('KO', acc.SF_LexisNexis_Callout_Status__c);
			System.assertNotEquals(null, acc.SF_LexisNexis_Callout_Date_Time__c);
		}
    }
    
	@isTest
    static void testLexisNexisAccountQueueableJob_ValidCallout() {
    	List<Id> sfRTidList = new List<Id>();
    	sfRTidList.addAll(AccountTriggerHandler.lxnxSpecFinRTIdSet);
    	Id sfRTid = sfRTidList[0];
    	
        Account acct = TestDataFactory.createTestPersonAccount();
        acct.RecordTypeId = sfRTid;
        acct.Research_Status_Person__c = 'New Unresearched';
        acct.Social_Security_Number_Person__c = '999-99-9999';
        
		Test.startTest();
        insert acct;
        TestDataFactory.SingleRequestMock callout = new TestDataFactory.SingleRequestMock(
            									  200,
                                                 'Success',
                                                 '<?xml version="1.0" encoding="UTF-8"?><BpsSearchResponseEx><response><Header><Status>0</Status><TransactionId>0000000000001</TransactionId></Header><SubjectTotalCount>1</SubjectTotalCount><Records><Record><Type>subject</Type><Verified>0</Verified><UniqueId>000000000001</UniqueId><Age>99</Age><Name><First>TEST</First><Middle>A</Middle><Last>PERSON</Last><Prefix>MR</Prefix></Name><Gender>Male</Gender><Address><StreetNumber>123</StreetNumber><StreetPreDirection>N</StreetPreDirection><StreetName>ELM</StreetName><StreetSuffix>ST</StreetSuffix><City>SAN DIEGO</City><State>CA</State><Zip5>92122</Zip5><Zip4>0000</Zip4></Address><DOB><Year>1900</Year><Month>01</Month><Day>01</Day></DOB><Deceased>Y</Deceased><DOD><Year>1999</Year><Month>01</Month><Day>01</Day></DOD><PhoneInfo><Phone10>8586492000</Phone10></PhoneInfo><SSNInfo><SSN>99999XXXX</SSN><Valid>yes</Valid><IssuedLocation>United States</IssuedLocation><IssuedStartDate><Month>19</Month><Day>35</Day></IssuedStartDate><IssuedEndDate><Month>19</Month><Day>99</Day></IssuedEndDate></SSNInfo><DateFirstSeen><Year>2008</Year><Month>05</Month></DateFirstSeen><DateLastSeen><Year>2008</Year><Month>05</Month></DateLastSeen><SubjectSSNIndicator>yes</SubjectSSNIndicator></Record></Records></response></BpsSearchResponseEx>',
                                                 null);
        LexisNexisAccountQueueableJob job = new LexisNexisAccountQueueableJob(acct, true, callout);
        System.enqueueJob(job);
		
		Test.stopTest();
		
		for(Account acc : [SELECT SF_LexisNexis_Callout_Status__c, SF_LexisNexis_Callout_Date_Time__c FROM Account WHERE Id = :acct.Id]) {
			System.assertEquals('OK', acc.SF_LexisNexis_Callout_Status__c);
			System.assertNotEquals(null, acc.SF_LexisNexis_Callout_Date_Time__c);
		}
    }
  
}