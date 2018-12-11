/**
* @description <p>Handler class for AddressTrigger functionality</p>
* @author Mike Crosby, BofI Federal 
*/
public class AddressTriggerHandler extends TriggerHandler {
  /** Map of Addresses before changes */
  private Map<Id, Address__c> oldAddressMap;
  /** Map of Addresses with changes */
  private Map<Id, Address__c> newAddressMap;
  /** Current Address Status */
  public final static String STATUS_CURRENTADDRESS = 'Current Mailing';
  /** Former Address Status */
  public final static String STATUS_FORMERADDRESS = 'Former';
  
  /** Constructor */
  public AddressTriggerHandler() {
  	this.oldAddressMap = (Map<Id, Address__c>) Trigger.oldMap;
  	this.newAddressMap = (Map<Id, Address__c>) Trigger.newMap;
  }
  
  /**
  * Process afterUpdate logic
  */
  public override void afterUpdate() {
  	handleCurrentAddress(oldAddressMap, newAddressMap);
  }
  
  /**
  * Process afterInsert logic
  */
  public override void afterInsert() {
  	handleCurrentAddress(null, newAddressMap);
  }
  
  /**
  * When Address records are set to Current Mailing, (1) ensure that associated Account records are updated with the current address
  * and (2) all other "Current Mailing" Address records are set to "Former" 
  * @param oldAcctMap map of initial state Accounts
  * @param newAcctMap map of changed Accounts
  */
  private void handleCurrentAddress(Map<Id,Address__c> oldMap, Map<Id,Address__c> newMap) {
  	Map<Id,Address__c> accountAddressIdMap = new Map<Id,Address__c>();

	//for addresses created or updated with Current Mailing status, update the corresponding Account record with the address
	for(Address__c a : newMap.values()) {
      if(!accountAddressIdMap.containsKey(a.Account_Name__c) &&
      	  ((oldMap == null ||
	     	(oldMap != null && oldMap.get(a.Id).Status__c != a.Status__c)) && a.Status__c == AddressTriggerHandler.STATUS_CURRENTADDRESS)) {
	    accountAddressIdMap.put(a.Account_Name__c, a);
	    toUpdate.add(new Account(Id=a.Account_Name__c, PersonMailingStreet=a.Address_Line__c, PersonMailingCity=a.City__c, PersonMailingState=a.State__c, PersonMailingPostalCode=a.Zip__c));
	  }
  	}
  	
  	if(accountAddressIdMap.size() == 0) {
  		//no records to update
  		return;
  	}
  	
  	//locate Address records associated with updated Accounts to ensure that statuses are set to "Former"
  	for(Address__c[] addresses : [
  									SELECT Account_Name__c, Status__c 
  									FROM Address__c 
  									WHERE Account_Name__c in :accountAddressIdMap.keyset() AND 
  									Status__c = :AddressTriggerHandler.STATUS_CURRENTADDRESS
  								  ]) {
  	  for(Address__c a : addresses) {
  	  	if(a.Id != accountAddressIdMap.get(a.Account_Name__c).Id) {
  	  	  //set any other Address record to "Former" if it currently has current mailing address status
  	  	  toUpdate.add(new Address__c(Id=a.Id, Status__c=AddressTriggerHandler.STATUS_FORMERADDRESS));
  	  	}
  	  }
  	}
  }
}