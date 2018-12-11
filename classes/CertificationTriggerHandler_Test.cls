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
private class CertificationTriggerHandler_Test {

  /**
  * Tests the handleStatusHistoryCreation trigger functionality
  */
  @isTest
  static void testHandleStatusHistoryCreation() {
    Account acct = TestDataFactory.createAndInsertTestBusinessAccount();
    WLD_Certification__c cert = TestDataFactory.createTestCertification(acct, TestDataFactory.CertificationType.ACCOUNT);
    cert.Status__c = 'Test1';
    
    System.test.startTest();
    insert cert;
    cert.Status__c = 'Test2';
    update cert;
    System.test.stopTest();
  }
    
  /**
  * Tests the populateContactEmailFields method that is triggered in the afterUpdate for Accounts
  */
  @isTest
  static void testPopulateContactEmailFields() {
  	//Create test Account for WLD
  	String wldRTId = '012i0000001QAvX';  	
  	Account a = TestDataFactory.createTestBusinessAccount();
  	a.Contact_Email__c = 'test@test.com';
  	a.Contact_Email_2__c = 'test2@test.com';
  	a.RecordTypeId = wldRTId;
  	insert a;
  	
  	//create a test Certification record for the Account
  	Test.startTest();
  	WLD_Certification__c cert = new WLD_Certification__c(Account__c=a.Id,QLR_Year__c=String.valueOf(Date.today().year()),Name='Test');
  	insert cert;
  	Test.stopTest();
  	
  	for(WLD_Certification__c c : [SELECT Contact_Email__c, Contact_Email_2__c FROM WLD_Certification__c WHERE Account__c = :a.Id]) {
  		System.assertEquals('test@test.com', c.Contact_Email__c);
  		System.assertEquals('test2@test.com', c.Contact_Email_2__c);
  	}
  }
  
  /**
  * Tests the processAnalystCallUpdate method that is triggered in the afterinsert, afterUpdate for Certifications
  */
  @isTest
  static void testProcessAnalystCallUpdate() {
  	//Create test Account for WLD
  	String wldRTId = '012i0000001QAvX';  	
  	Account a = TestDataFactory.createTestBusinessAccount();
  	a.Contact_Email__c = 'test@test.com';
  	a.RecordTypeId = wldRTId;
  	insert a;
  	
  	//create a test Certification record for the Account
  	Test.startTest();
  	WLD_Certification__c cert1 = new WLD_Certification__c(Account__c=a.Id,QLR_Year__c=String.valueOf(Date.today().year()),Name='Test', Hedging_Reports__c='Requested');
  	WLD_Certification__c cert2 = new WLD_Certification__c(Account__c=a.Id,QLR_Year__c=String.valueOf(Date.today().year()),Name='Test', Hedging_Reports__c='Analyst Call');
  	WLD_Certification__c[] certs = new List<WLD_Certification__c>{cert1,cert2}; 
  	insert certs;
  	cert2 = certs.get(0);
  	cert2.Hedging_Reports__c = 'Analyst Call';
  	update cert2;
  	Test.stopTest();
  	
  }
}