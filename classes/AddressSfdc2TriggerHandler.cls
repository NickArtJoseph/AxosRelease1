/**
 * @description <P>Handler class for Address_SFDC2__c object functionality
 * @author Matt Dawson, BofI Federal
 */
public class AddressSfdc2TriggerHandler extends TriggerHandler {
    
    /** Map of new/updated Address_SFDC2__c objects with changes */
    private Map<Id, Address_SFDC2__c> newAddrMap;
	
	/** Map of updated/deleted Address_SFDC2__c objects without changes */
    private Map<Id, Address_SFDC2__c> oldAddrMap;

	/** List of new/updated Address_SFDC2__c objects with changes */
    private List<Address_SFDC2__c> newAddrList;
    
    /** Profile Id for System Admins **/
    private static Id adminProfileId = '00ei0000000qJ9OAAU';
        
    /** Constructor */
    public AddressSfdc2TriggerHandler() {
    	this.newAddrMap = (Map<Id, Address_SFDC2__c>) Trigger.newMap;
		this.oldAddrMap = (Map<Id, Address_SFDC2__c>) Trigger.oldMap;
    	this.newAddrList = (List<Address_SFDC2__c>) Trigger.new;
    }
    
    /** Process after insert logic */
    public override void afterInsert() {
    	updatePrimaryAddresses(this.newAddrMap);
    }
    
    /** Process after update logic */
    public override void afterUpdate() {
    	updatePrimaryAddresses(this.newAddrMap);
    }
    
    /** Process before insert logic */
    public override void beforeInsert() {
    	blockJhAddressInserts();
    }

	/** Process before update logic */
	public override void beforeUpdate() {
		blockJhAddressChanges();
    	blockJhAddressInserts();
	}

	/** Process before delete logic */
	public override void beforeDelete() {
		blockJhAddressChanges();
	}
    
    /**
     * Block changes to a JH Address record
     */
    private void blockJhAddressChanges() {
    	for (Address_SFDC2__c addr : this.oldAddrMap.values()) {
    		if (addr.Address_Type__c == null) continue;
    		if (addr.Address_Type__c.equals('JH Address') && UserInfo.getProfileId() != adminProfileId) {
    			if (Trigger.isDelete) {
   					addr.addError('JH Address objects cannot be changed or deleted.');
    			} else {
   					this.newAddrMap.get(addr.Id).addError('JH Address objects cannot be changed or deleted.');
    			}
    		}
    	}
    }
    
    /**
     * Block inserts of JH Address records
     */
    private void blockJhAddressInserts() {
    	for (Address_SFDC2__c addr : this.newAddrList) {
    		if (addr.Address_Type__c == null) continue;
    		if (addr.Address_Type__c.equals('JH Address') && UserInfo.getProfileId() != adminProfileId) {
    			addr.addError('JH Address objects cannot created manually.');
    		}
    	}
    }

    /**
     * Check Address_SFDC2__c objects for 'Primary' type and update master record
     * primary address fields.
     * @param newAddrMap map of new/updated address objects
     */
    private void updatePrimaryAddresses(Map<Id, Address_SFDC2__c> newAddrMap) {
    	
     	// List of Addresses with Account and Lead ids
        List<Address_SFDC2__c> addresses = [select Account__r.Id, Lead__r.Id from Address_SFDC2__c where id IN :newAddrMap.keySet()];

        // List of Account Ids associated with addresses
		List<Id> accountIds = new List<Id>();
		for (Address_SFDC2__c address: addresses) accountIds.add(address.Account__r.Id);
        
        // List of Accounts to update
    	List<Account> accountsToUpdate = new List<Account>();
     	
    	// Set appropriate Account primary email field values
    	for (Account account : [select id, PersonMailingStreet, PersonMailingCity, PersonMailingCountry, PersonMailingState, PersonMailingPostalCode,
  										Mailing_Loan_Type_SFDC2__pc, Mailing_Mortgage_Lender_SFDC2__pc, Mailing_Purchase_Amount_SFDC2__pc, Mailing_Purchase_Date_SFDC2__pc,
  										BillingStreet, BillingCity, BillingCountry, BillingState, BillingPostalCode, Billing_Loan_Type_SFDC2__c, 
  										Billing_Mortgage_Lender_SFDC2__c, Billing_Purchase_Amount_SFDC2__c, Billing_Purchase_Date_SFDC2__c, isPersonAccount,
							    	(select id, Street__c, City__c, Country__c, State__c, Postal_Code__c, Address_Type__c, Mortgage_Lender__c, Loan_Type__c, 
							    		Purchase_Date__c, Purchase_Amount__c from Addresses__r where id IN :newAddrMap.keySet())
  									 from Account where SFDC2__c = true and id IN :accountIds ]) {
			Boolean updateAccount = false;
			for (Address_SFDC2__c addr : account.Addresses__r) {
				if (addr.Address_Type__c.equals('Primary')) {
					if (account.isPersonAccount) {
						account.PersonMailingStreet 			  = addr.Street__c;
						account.PersonMailingCity	 			  = addr.City__c;
						account.PersonMailingCountry 			  = addr.Country__c;
						account.PersonMailingState 				  = addr.State__c;
						account.PersonMailingPostalCode 		  = addr.Postal_Code__c;
						account.Mailing_Mortgage_Lender_SFDC2__pc = addr.Mortgage_Lender__c;
						account.Mailing_Loan_Type_SFDC2__pc 	  = addr.Loan_Type__c;
						account.Mailing_Purchase_Date_SFDC2__pc   = addr.Purchase_Date__c;
						account.Mailing_Purchase_Amount_SFDC2__pc = addr.Purchase_Amount__c;
						updateAccount = true;
					} else {
						account.BillingStreet 			 		 = addr.Street__c;
						account.BillingCity	 			 		 = addr.City__c;
						account.BillingCountry 			 		 = addr.Country__c;
						account.BillingState 				 	 = addr.State__c;
						account.BillingPostalCode 		 		 = addr.Postal_Code__c;
						account.Billing_Mortgage_Lender_SFDC2__c = addr.Mortgage_Lender__c;
						account.Billing_Loan_Type_SFDC2__c 		 = addr.Loan_Type__c;
						account.Billing_Purchase_Date_SFDC2__c 	 = addr.Purchase_Date__c;
						account.Billing_Purchase_Amount_SFDC2__c = addr.Purchase_Amount__c;		
						updateAccount = true;				
					}
				} 
			}
			if (updateAccount) accountsToUpdate.add(account);
    	}
    	
    	update accountsToUpdate;

    	// List of Lead Ids associated with email addresses
    	List<Id> leadIds = new List<Id>();
    	for (Address_SFDC2__c address: addresses) leadIds.add(address.Lead__r.Id);
    	
    	// List of Leads to update
    	List<Lead> leadsToUpdate = new List<Lead>();

    	// Set appropriate Lead primary email field values
    	for (Lead lead : [select id, Street, City, Country, State, PostalCode, Primary_Loan_Type_SFDC2__c, Primary_Mortgage_Lender_SFDC2__c, 
    						Primary_Purchase_Amount_SFDC2__c, Primary_Purchase_Date_SFDC2__c,
							(select id, Street__c, City__c, Country__c, State__c, Postal_Code__c, Address_Type__c, Mortgage_Lender__c, Loan_Type__c, 
							    Purchase_Date__c, Purchase_Amount__c from Addresses__r where id IN :newAddrMap.keySet())
  							from Lead where SFDC2__c = true and IsConverted = false and id IN :leadIds ]) {
			Boolean updateAddress = false;
			for (Address_SFDC2__c addr : lead.Addresses__r) {
				if (addr.Address_Type__c.equals('Primary')) {
					lead.Street 			  				= addr.Street__c;
					lead.City	 			  				= addr.City__c;
					lead.Country 			  				= addr.Country__c;
					lead.State 				  				= addr.State__c;
					lead.PostalCode 		  				= addr.Postal_Code__c;
					lead.Primary_Mortgage_Lender_SFDC2__c 	= addr.Mortgage_Lender__c;
					lead.Primary_Loan_Type_SFDC2__c 	  	= addr.Loan_Type__c;
					lead.Primary_Purchase_Date_SFDC2__c   	= addr.Purchase_Date__c;
					lead.Primary_Purchase_Amount_SFDC2__c 	= addr.Purchase_Amount__c;
					updateAddress = true;
				} 
			}
			if (updateAddress) leadsToUpdate.add(lead);
    	}
    	
    	update leadsToUpdate;

    }    
    
    
}