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
private class PhoneNumberTriggerHandler_Test {

  /** Tests the handleManualNeustarTrigger method for updates */
  @isTest
  static void testHandleManualNeustarTrigger() {
  	List<Id> rtIdList = new List<Id>(); 
  	rtIdList.addAll(AccountTriggerHandler.neustarSpecFinRTIdSet);
  	Id sfRTid = rtIdList[0];
  	
  	Account sfAcc = TestDataFactory.createTestPersonAccount();
  	sfAcc.RecordTypeId = sfRTId;
  	sfAcc.Research_Status_Person__c = '';
  	
  	insert sfAcc;
  	
  	Phone_Number__c phone = new Phone_Number__c();
  	phone.Account_Name__c = sfAcc.Id;
  	phone.Phone_Number__c = '5555551212';
  	insert phone;
  	
  	phone.Neustar_Trigger__c = true;
  	
  	try {
  		Test.startTest();
  		update phone;
  		Test.stopTest();
  	} catch (DMLException de) {Test.stopTest();}
  	finally {}
  	
  	Webservice_Callout__c[] callout = [SELECT ID FROM Webservice_Callout__c WHERE Account__c = :sfAcc.Id AND Phone_Number__c = :phone.Id AND Job_Name__c = 'NeustarQueueableJob'];
  	System.assert(callout.size() > 0);
  }
}