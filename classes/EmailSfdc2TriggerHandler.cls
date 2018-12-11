/**
 * @description <P>Handler class for Email_SFDC2__c object functionality
 * @author Matt Dawson, BofI Federal
 */
public class EmailSfdc2TriggerHandler extends TriggerHandler {
    
    /** Map of new/updated Email_SFDC2__c objects with changes */
    private Map<Id, Email_SFDC2__c> newEmailMap;
    
    /** Map of updated/deleted Email_SFDC2__c objects without changes */
    private Map<Id, Email_SFDC2__c> oldEmailMap;

	/** List of new/update Email_SFDC2__c objects with changes */
	private List<Email_SFDC2__c> newEmailList;
    
    /** Profile Id for System Admins **/
    private static Id adminProfileId = '00ei0000000qJ9OAAU';

    /** Constructor */
    public EmailSfdc2TriggerHandler() {
    	this.newEmailMap = (Map<Id, Email_SFDC2__c>) Trigger.newMap;
		this.oldEmailMap = (Map<Id, Email_SFDC2__c>) Trigger.oldMap;
		this.newEmailList = (List<Email_SFDC2__c>) Trigger.new;
    }
    
    /** Process the after insert logic */
    public override void afterInsert() {
    	updatePrimaryEmailAddresses(this.newEmailMap);
    }
    
    /** Process the after update logic */
    public override void afterUpdate() {
    	updatePrimaryEmailAddresses(this.newEmailMap);    	
    }

    /** Process before insert logic */
    public override void beforeInsert() {
    	blockJhEmailInserts();
    }

	/** Process before update logic */
	public override void beforeUpdate() {
		blockJhEmailChanges();
    	blockJhEmailInserts();
	}

	/** Process before delete logic */
	public override void beforeDelete() {
		blockJhEmailChanges();
	}
    
    /**
     * Block changes to a JH Email record
     */
    private void blockJhEmailChanges() {
    	for (Email_SFDC2__c email : this.oldEmailMap.values()) {
    		if (email.Email_Type__c == null) continue;
    		if (email.Email_Type__c.equals('JH Email') && UserInfo.getProfileId() != adminProfileId) {
    			if (Trigger.isDelete) {
   					email.addError('JH Email objects cannot be changed or deleted.');
    			} else {
   					this.newEmailMap.get(email.Id).addError('JH Email objects cannot be changed or deleted.');
    			}
    		}
    	}
    }
    
    /**
     * Block inserts of JH Email records
     */
    private void blockJhEmailInserts() {
    	for (Email_SFDC2__c email : this.newEmailList) {
    		if (email.Email_Type__c == null) continue;
    		if (email.Email_Type__c.equals('JH Email') && UserInfo.getProfileId() != adminProfileId) {
    			email.addError('JH Email objects cannot created manually.');
    		}
    	}
    }
    
    /**
     * Check Email_SFDC2__c objects for 'Primary' type and update master record
     * primary email fields.
     * @param newEmailMap map of new/updated email objects
     */
    private void updatePrimaryEmailAddresses(Map<Id, Email_SFDC2__c> newEmailMap) {
    	
		// List of Emails with Account and Lead ids
        List<Email_SFDC2__c> emails = [select Account__r.Id, Lead__r.Id from Email_SFDC2__c where id IN :newEmailMap.keySet()];

        // List of Account Ids associated with email addresses
		List<Id> accountIds = new List<Id>();
		for (Email_SFDC2__c email: emails) accountIds.add(email.Account__r.Id);
        
        // List of Accounts to update
    	List<Account> accountsToUpdate = new List<Account>();
   	
     	// Set appropriate Account primary email field values
    	for (Account account : [select id, PersonEmail, Business_Email_SFDC2__pc, isPersonAccount,
							    	(select id, Email__c, Email_Type__c from Email_Addresses__r where id IN :newEmailMap.keySet())
  									 from Account where id IN :accountIds and SFDC2__c = true ]) {
			boolean updateAccount = false;
			for (Email_SFDC2__c email : account.Email_Addresses__r) {
				if (email.Email_Type__c.equals('Primary Personal')) {
					account.PersonEmail = email.Email__c;
					updateAccount = true;
				} else if (email.Email_Type__c.equals('Primary Business')) {
					if (account.isPersonAccount) {
						account.Business_Email_SFDC2__pc = email.Email__c;
						updateAccount = true;
					} else {
						account.Email__c = email.Email__c;
						updateAccount = true;
					}
				}
			}
			if (updateAccount) accountsToUpdate.add(account);
    	}
    	
    	update accountsToUpdate;

        // List of Lead Ids associated with email addresses
		List<Id> leadIds = new List<Id>();
		for (Email_SFDC2__c email: emails) leadIds.add(email.Lead__r.Id);
        
        // List of Leads to update
    	List<Lead> leadsToUpdate = new List<Lead>();

     	// Set appropriate Lead primary email field values
    	for (Lead lead : [select id, Email,
							(select id, Email__c, Email_Type__c from Email_Addresses__r where id IN :newEmailMap.keySet())
  							from Lead where SFDC2__c = true and IsConverted = false and id IN :leadIds ]) {
			Boolean updateLead = false;
			for (Email_SFDC2__c email : lead.Email_Addresses__r) {
				if (email.Email_Type__c.equals('Primary Personal')) {
					lead.Email = email.Email__c;
					updateLead = true;
				} else if (email.Email_Type__c.equals('Primary Business')) {
					lead.Email = email.Email__c;
					updateLead = true;
				}
			}
			if (updateLead) leadsToUpdate.add(lead);
    	}
    	
    	update leadsToUpdate;

    }  

    
}