/**
* @description <p>Handler class for ContacttTrigger functionality</p>
* @author Mike Crosby, BofI Federal 
*/
public class ContactTriggerHandler extends TriggerHandler{

  /** Map of Contacts before changes */
  private Map<Id, Contact> oldContMap;
  /** Map of Contacts with changes */
  private Map<Id, Contact> newContMap;
  /** List of Contact with changes */
  private List<Contact> newContList;
  
  /** Constructor */
  public ContactTriggerHandler() {
  	this.oldContMap = (Map<Id, Contact>) Trigger.oldMap;
  	this.newContMap = (Map<Id, Contact>) Trigger.newMap;
  	this.newContList = Trigger.new;
  }
  
  /**
  * Process beforeUpdate logic
  */
  public override void beforeUpdate() {
  	reassignContactOwner(newContList);
  }
  
  /**
  * Process beforeInsert logic
  */
  public override void beforeInsert() {
  	reassignContactOwner(newContList);
  }
  
  /**
   * Process afterUpdate logic
   */
  public override void afterUpdate() {
	// convertFlaggedContactsSFDC2(this.newContList);
	handleDoNotCallUpdateSFDC2();	
  }
  
  /**
   * Process afterInsert logic
   */
  public override void afterInsert() {
	// convertFlaggedContactsSFDC2(this.newContList);  	
  }
  
  /**
  * When the Do Not Call checkbox is toggled, trigger check to determine whether Contact
  * should be added to or expired from a campaign
  */
  private void handleDoNotCallUpdateSFDC2() {
  	//list of ids to verify for expiration
  	Set<Id> doNotCallList = new Set<Id>();
  	//list of ids to verify for campaign member addition
  	Set<Id> potentialCMList = new Set<Id>();
  	
  	for(Contact c : newContMap.values()) {
  		if(c.SFDC2__c) {
	  		Contact oldC = oldContMap.get(c.Id);
	  		if(c.DoNotCall != oldC.DoNotCall) {
	  			potentialCMList.add(c.Id);
	  		}
  		}
  	}
  	
  	//only contacts related to Financial Accounts should be considered for campaign updates
  	if(potentialCMList.size() > 0) {
  		List<String> membersToExpire = new List<String>();
  		List<String> finAcctLinksToVerify = new List<String>();
  		for(Financial_Account_Contact_Link_SFDC2__c links : [SELECT Contact__c from Financial_Account_Contact_Link_SFDC2__c WHERE Contact__c in :potentialCMList]) {
			if (potentialCMList.contains(links.Contact__c)) {
  				finAcctLinksToVerify.add(links.Id);
  			}
  		}
  		
  		if(finAcctLinksToVerify.size() > 0) {
  			CampaignMemberAutomationHandler.handleCampaignMemberAutomation(finAcctLinksToVerify);
  		}
  	}
  }
  
  /**
  * When Contacts related to specific Account record types inserted/updated, ensure that the Owner is synched with the Account Owner
  * @param newContList list of changed Contacts
  */
  private void reassignContactOwner(List<Contact> newContList) {
  	System.debug('**** reassignContactOwner');
    //Establish a map of Account Record Type IDs whose Contact record owners should be synched
    Set<String> acctRTSet = new Set<String>();
  	for(Account_Contact_Owner_Sync__c cs : [
  											select Account_Record_Type_ID__c
  											from Account_Contact_Owner_Sync__c
  										   ]) {
		acctRTSet.add(cs.Account_Record_Type_ID__c);
		System.debug('**** Record Type Id to sync = ' + cs.Account_Record_Type_ID__c);
	}
  	
  	//establish a set of Account Ids for the affected Contacts that match the record type IDs for synching
  	Set<Id> acctIdSet = new Set<Id>();
  	for(Contact c : newContList) {
  		acctIdSet.add(c.AccountId);
  	}
  	Map<Id,Account> acctMap = new Map<Id,Account>([select Id, OwnerId from Account where Id in :acctIdSet and RecordTypeId in :acctRTSet]);
  	
  	//any contacts related to an Account found in the map will need to have the Owner synched
  	for(Contact c : newContList) {
  		if(c.AccountId != null &&
  			acctMap.containsKey(c.AccountId) &&
  			c.OwnerId != acctMap.get(c.AccountId).OwnerId) {
  				c.OwnerId = acctMap.get(c.AccountId).OwnerId;
  		}
  	}
  }
  
  /**
   * SFDC2: When the ETL flags a set of Contact records using the Trigger_Conversion_SFDC2__c flag,
   * convert the Contacts to Hybrid Person Accounts
   */
 /* private void convertFlaggedContactsSFDC2(List<Contact> contacts) {
  	
  	Set<Id> contactsToConvert = new Set<Id>();
    Id personAccountRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business/Consumer Person Account').getRecordTypeId();
  	
  	for(Contact contact: contacts) {
  		if(contact.SFDC2__c && contact.Trigger_Conversion_SFDC2__c && contact.IsPersonAccount == false) contactsToConvert.add(contact.Id);
  	}
  	
  	Map<Id,Account> convertedAccounts = OpportunityTriggerHandler.convertContactsToPersonAccounts(contactsToConvert, personAccountRTId);
  	
  } 
 */ 
}