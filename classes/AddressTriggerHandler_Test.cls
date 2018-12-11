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
private class AddressTriggerHandler_Test {

  /**
  * Tests the handleCurrentAddress method that is triggered in the afterInsert and afterUpdate for Address object
  */
  @isTest
  static void testHandleCurrentAddress() {
  	Account a = TestDataFactory.createAndInsertTestPersonAccount();
  	
  	Address__c add1 = new Address__c(Account_Name__c=a.Id,Address_Line__c='123 Elm St',City__c='San Diego',State__c='CA',Zip__c='92122',Status__c=AddressTriggerHandler.STATUS_CURRENTADDRESS);
  	Address__c add2 = new Address__c(Account_Name__c=a.Id,Address_Line__c='987 Pine Ave',City__c='Washington',State__c='DC',Zip__c='20012',Status__c=AddressTriggerHandler.STATUS_FORMERADDRESS);
  	Address__c[] add = new Address__c[]{add1,add2};
  	insert add;
  	test.startTest();
  	a = [SELECT PersonMailingStreet, PersonMailingCity, PersonMailingState, PersonMailingPostalCode FROM Account where Id = :a.Id];
  	System.assertEquals('123 Elm St', a.PersonMailingStreet);
  	System.assertEquals('San Diego', a.PersonMailingCity);
  	System.assertEquals('CA', a.PersonMailingState);
  	System.assertEquals('92122', a.PersonMailingPostalCode);
  	add[1].Status__c = AddressTriggerHandler.STATUS_CURRENTADDRESS;
  	update add;
  	test.stopTest();
  	a = [SELECT PersonMailingStreet, PersonMailingCity, PersonMailingState, PersonMailingPostalCode FROM Account where Id = :a.Id];
  	System.assertEquals('987 Pine Ave', a.PersonMailingStreet);
  	System.assertEquals('Washington', a.PersonMailingCity);
  	System.assertEquals('DC', a.PersonMailingState);
  	System.assertEquals('20012', a.PersonMailingPostalCode);
  	for(Address__c address : [SELECT Status__c FROM Address__c WHERE Id in :add]) {
  	  if(address.Id == add[0].Id) {
  	  	System.assertEquals(AddressTriggerHandler.STATUS_FORMERADDRESS, address.Status__c);
  	  } else if (address.Id == add[1].Id) {
  	  	System.assertEquals(AddressTriggerHandler.STATUS_CURRENTADDRESS, address.Status__c);
  	  }
  	}
  }
}