/**
 * @description <P>Handler class for Phone_SFDC2__c functionality
 * @author Matt Dawson, BofI Federal
 */
public class PhoneSfdc2TriggerHandler extends TriggerHandler {
    
    /** Map of new/updated Phone_SFDC2__c objects with changes */
    private Map<Id, Phone_SFDC2__c> newPhoneMap;
    
    /** Map of updated/deleted Phone_SFDC2__c objects without changes */
    private Map<Id, Phone_SFDC2__c> oldPhoneMap;
    
    /** List of new/updated Phone_SFDC2__c objects with changes */
    private List<Phone_SFDC2__c> newPhoneList;
    
    /** Profile Id for System Admins **/
    private static Id adminProfileId = '00ei0000000qJ9OAAU';

    /** Constructor */
    public PhoneSfdc2TriggerHandler() {
    	this.newPhoneMap = (Map<Id, Phone_SFDC2__c>) Trigger.newMap;
		this.oldPhoneMap = (Map<Id, Phone_SFDC2__c>) Trigger.oldMap;
		this.newPhoneList = (List<Phone_SFDC2__c>) Trigger.new;
    }
    
    /** Process after insert logic */
    public override void afterInsert() {
    	updatePrimaryPhoneNumbers(this.newPhoneMap);
    }
    
    /** Process after update logic */
    public override void afterUpdate() {
    	updatePrimaryPhoneNumbers(this.newPhoneMap);    	
    }
    
    /** Process before insert logic */
    public override void beforeInsert() {
    	blockJhPhoneInserts();
    }

	/** Process before update logic */
	public override void beforeUpdate() {
		blockJhPhoneChanges();
    	blockJhPhoneInserts();
	}

	/** Process before delete logic */
	public override void beforeDelete() {
		blockJhPhoneChanges();
	}
    
    /**
     * Block changes to a JH Phone record
     */
    private void blockJhPhoneChanges() {
    	for (Phone_SFDC2__c phone : this.oldPhoneMap.values()) {
    		if (phone.Phone_Type__c == null) continue;
    		if ((phone.Phone_Type__c.equals('JH Cell') || phone.Phone_Type__c.equals('JH Fax')) && UserInfo.getProfileId() != adminProfileId) {
    			if (Trigger.isDelete) {
   					phone.addError('JH Phone objects cannot be changed or deleted.');
    			} else {
   					this.newPhoneMap.get(phone.Id).addError('JH Phone objects cannot be changed or deleted.');
    			}
    		}
    	}
    }
    
    /**
     * Block inserts of JH Phone records
     */
    private void blockJhPhoneInserts() {
    	for (Phone_SFDC2__c phone : this.newPhoneList) {
    		if (phone.Phone_Type__c == null) continue;
    		if ((phone.Phone_Type__c.equals('JH Cell') || phone.Phone_Type__c.equals('JH Fax')) && UserInfo.getProfileId() != adminProfileId) {
    			phone.addError('JH Phone objects cannot created manually.');
    		}
    	}
    }
    /**
     * Check Phone_SFDC2__c objects for 'Primary' type and update master record
     * primary phone fields.
     * @param newPhoneMap map of new/updated phone objects
     */
    private void updatePrimaryPhoneNumbers(Map<Id, Phone_SFDC2__c> newPhoneMap) {
    	
		// List of Phones with Account and Lead ids
        List<Phone_SFDC2__c> phones = [select Account__r.Id, Lead__r.Id from Phone_SFDC2__c where id IN :newPhoneMap.keySet()];

        // List of Account Ids associated with phone numbers
		List<Id> accountIds = new List<Id>();
		for (Phone_SFDC2__c phone: phones) accountIds.add(phone.Account__r.Id);
        
        // List of Accounts to update
    	List<Account> accountsToUpdate = new List<Account>();
    	
    	// Set appropriate Account primary phone field values
    	for (Account account : [select id, Phone, PersonMobilePhone, PersonHomePhone, PersonOtherPhone, Fax, Business_Phone_SFDC2__pc, isPersonAccount, 
							    	(select id, Phone__c, Phone_Type__c from Phones__r where id IN :newPhoneMap.keySet())
  									 from Account where id IN :accountIds and SFDC2__c=true]) {
  			Boolean updateAccount = false;
			for (Phone_SFDC2__c phone : account.Phones__r) {
				if (phone.Phone_Type__c.equals('Primary Home')) {
					account.PersonHomePhone = phone.Phone__c;
					updateAccount = true;
				}  else if (phone.Phone_Type__c.equals('Primary Business') && account.isPersonAccount) {
					account.Business_Phone_SFDC2__pc = phone.Phone__c;
					updateAccount = true;
				}  else if (phone.Phone_Type__c.equals('Primary Business') && !account.isPersonAccount) {
					account.Phone = phone.Phone__c;
					updateAccount = true;
				}  else if (phone.Phone_Type__c.equals('Primary Mobile')) {
					account.PersonMobilePhone = phone.Phone__c;
					updateAccount = true;
				}  else if (phone.Phone_Type__c.equals('Primary Fax')) {
					account.Fax = phone.Phone__c;
					updateAccount = true;
				}
			}
			if (updateAccount) accountsToUpdate.add(account);
    	}
    	
    	update accountsToUpdate;
    	
    	// List of Lead Ids associated with phone numbers
    	List<Id> leadIds = new List<Id>();
    	for (Phone_SFDC2__c phone: phones) leadIds.add(phone.Lead__r.Id);
    	
    	// List of Leads to update
    	List<Lead> leadsToUpdate = new List<Lead>();
    	
    	// Set appropriate Lead primary phone field values
    	for (Lead lead : [select id, Phone, MobilePhone, Fax,
							(select id, Phone__c, Phone_Type__c from Phones__r where id IN :newPhoneMap.keySet())
  							from Lead where SFDC2__c = true and IsConverted = false and id IN :leadIds ]) {
			Boolean updateLead = false;
			for (Phone_SFDC2__c phone : lead.Phones__r) {
				if (phone.Phone_Type__c.equals('Primary Home')) {
					lead.Phone = phone.Phone__c;
					updateLead = true;
				}  else if (phone.Phone_Type__c.equals('Primary Business')) {
					lead.Phone = phone.Phone__c;
					updateLead = true;
				}  else if (phone.Phone_Type__c.equals('Primary Mobile')) {
					lead.MobilePhone = phone.Phone__c;
					updateLead = true;
				}  else if (phone.Phone_Type__c.equals('Primary Fax')) {
					lead.Fax = phone.Phone__c;
					updateLead = true;
				}
			}
			if (updateLead) leadsToUpdate.add(lead);
    	}
    	
    	update leadsToUpdate;
    }

}