/**
* @description <p>Handler class for LeadTrigger functionality</p>
* @author Mike Crosby, BofI Federal 
*/
public class LeadTriggerHandler extends TriggerHandler{

  /** Map of Leads before changes */
  private Map<Id, Lead> oldLeadMap;
  /** Map of Leads with changes */
  private Map<Id, Lead> newLeadMap;
  /** List of new Leads */
  private List<Lead> newLeads;
  /** SFDC 2.0 : Lead status that triggers automated 2.0 conversion */
  public static final String AutoConvertStatus = 'Contacted/Converted';

  /** Constructor */
  public LeadTriggerHandler() {
    this.oldLeadMap = (Map<Id, Lead>) Trigger.oldMap;
    this.newLeadMap = (Map<Id, Lead>) Trigger.newMap;
    this.newLeads = (List<Lead>) Trigger.new;
  }

/**
  * Process beforeUpdate logic
  */
  public override void beforeUpdate() {
    if(this.newLeads[0].isFromApplication__c == false) {
        updateSFDC2Checkbox(this.newLeads);
        reassignLeadOwner_CD(this.oldLeadMap, this.newLeadMap);
        updatePhoneListSfdc2(this.oldLeadMap, this.newLeadMap);
        updateEmailListSfdc2(this.oldLeadMap, this.newLeadMap);
        updateAddressListSfdc2(this.oldLeadMap, this.newLeadMap);
        //SFDC2 - MC - checks to see if Lead needs to be reassigned to Business Unit queue
        reassignLeadToQueue();
    }
  }
  
  /**
   * Process afterUpdate logic
   */
  public override void afterUpdate() {
    handleLeadConversion(this.oldLeadMap, this.newLeadMap);
    if(this.newLeads[0].isFromApplication__c == false) {
        // 2.0 auto lead conversion
        handleAutoConvertLead();
    }
  }
  /**
  * Process afterInsert logic    
  */  
  public override void afterInsert() {
    assignmentRule(this.newLeads);
  } 
    
  /**
   * Process beforeInsert logic
   */
  public override void beforeInsert() {
    updateSFDC2Checkbox(this.newLeads);
  }   
  
  /*
    The Lead Assignment rules are applied for all the Record Types in SFDC2 
  in the afterInsert event
  */
    
    public static void assignmentRule(List<Lead> ltsLeads){
        
        
        Set<String> setMgr = new Set<String>();
          
          for (Manager_SFDC2__mdt rtName : [Select RecordType_Name__c from Manager_SFDC2__mdt where Re_Assign_Lead__c = true]){       
              setMgr.add(Schema.SObjectType.Lead.getRecordTypeInfosByName().get(rtName.RecordType_Name__c).getRecordTypeId()); 
          }
 

        List<Lead> leadList = new List<Lead>();

        //list<Manager_SFDC2__mdt> lstToReAssign = [SELECT RecordType_DeveloperName__c, RecordType_Name__c, Re_Assign_Lead__c FROM Manager_SFDC2__mdt WHERE Re_Assign_Lead__c = true ];
		System.debug('*******************Metodo After');
        for (Lead leadObj : ltsLeads) {
          if (leadObj.OwnerId  == UserInfo.getUserId() && setMgr.contains(leadObj.RecordTypeId)) {

            leadList.add(new Lead(id = leadObj.id));
          }
        }
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.assignmentRuleHeader.useDefaultRule = true;
        Database.update(leadList, dml);        
    }
   
  /**
  * SFDC 2.0 MC: When the Lead Status changes to Contacted/Converted, auto-convert
  * the Lead
  */
  private void handleAutoConvertLead() {
    Set<String> leadIdSet = new Set<String>();
    for(Lead l : newLeadMap.values()) {
        Lead oldLead = oldLeadMap.get(l.Id);
        //determine if this lead should auto convert
        if(!l.IsConverted &&
            l.SFDC2__c &&
            l.Status == LeadTriggerHandler.AutoConvertStatus) {
            leadIdSet.add(l.Id);
        }
    }
    if(!leadIdSet.isEmpty()) {
        List<String> leadList = new List<String>();
        leadList.addAll(leadIdSet);
        autoConvertLeads(leadList);
    }
  }
  
  /**
  * SFDC 2.0 MC: Future method to handle auto conversion of leads
  * @param idList list of lead ids to convert
  */
  @future
  private static void autoConvertLeads(List<String> idList) {
        List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
        Map<Id, Lead> leadConvertMap = new Map<Id, Lead>([
          SELECT Name, Opportunity_NameSFDC2__c, Primary_Campaign_SFDC2__c, OwnerId, Account_Record_Type_SFDC2__c, RecordTypeId , IPL_Channel_SFDC2__c
          FROM Lead 
          WHERE Id IN :idList
        ]);

        for(Lead l : leadConvertMap.values()) {
            Database.LeadConvert lc = new Database.LeadConvert();
            String oppName = l.Opportunity_NameSFDC2__c;
            if(oppName == null || oppName == '') {
                oppName = l.Name;
            }
               
            lc.setLeadId(l.Id);
            lc.setOpportunityName(oppName);
            lc.setConvertedStatus(LeadTriggerHandler.AutoConvertStatus);
            lc.setOwnerId(l.OwnerId);
            lc.setSendNotificationEmail(true);
            leadConverts.add(lc);
        }

        if (!leadConverts.isEmpty()) {
            // Record type ID for C&I SFDC2
            //Id rtId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('C&I SFDC2').getRecordTypeId();
            // Map of Account Record Types
            Map<String, RecordType> mapAccountRecordTypesByName = UtilsSFDC2.getRecordTypesMap('Account', 'Name');

            List<Database.LeadConvertResult> lcrList = Database.convertLead(leadConverts);
            List<sObject> futureUpdate = new List<sObject>();
            for(Database.LeadConvertResult lcr : lcrList) {
              Lead currentLead = leadConvertMap.get(lcr.getLeadId());

              // Don't process non successful conversions or Lead record types different from C&I SFDC2
              if(lcr.isSuccess() == false) {
                continue;
              }

              // Assign account Record Type and Owner
                Account a = new Account(Id=lcr.getAccountId());
                RecordType selectedAccountRecType = mapAccountRecordTypesByName.get(currentLead.Account_Record_Type_SFDC2__c);
                /*****IPL SFDC2 assingment*******/
                id idIPLRT = [Select id from RecordType where Name = 'IPL SFDC2' and SobjectType = 'Lead'].Id; 
                if(currentLead.RecordTypeId   == idIPLRT && currentLead.IPL_Channel_SFDC2__c == 'Direct'){
                    selectedAccountRecType = [Select id, IsPersonType, DeveloperName, Name from RecordType where Name = 'Consumer Person Account SFDC2'];
                }else if(currentLead.RecordTypeId   == idIPLRT && currentLead.IPL_Channel_SFDC2__c == 'Broker is Customer'){
                    selectedAccountRecType = [Select id, IsPersonType, DeveloperName, Name from RecordType where Name = 'Business/Consumer Person Account'];
                }
                /*****IPL SFDC2 assingment*******/
              if (selectedAccountRecType != null) { 
                a.RecordTypeId = selectedAccountRecType.Id; 
                // Update Contact Owner just for Non Person Account types
                if (selectedAccountRecType.IsPersonType == true) {
                  update a;
                } else {
                  Contact c = new Contact(Id=lcr.getContactId());
                  c.OwnerId = UserTriggerHandler.APIAccountId;
                  futureUpdate.add(c);
                }
              } else {
                  
                Contact c = new Contact(Id=lcr.getContactId());
                c.OwnerId = UserTriggerHandler.APIAccountId;
                futureUpdate.add(c);
              }

              // Update Account Owner
              a.OwnerId = UserTriggerHandler.APIAccountId;
              a.SFDC2__c = true;
              futureUpdate.add(a);

              // Assign Opportunity Campaign
              Opportunity o = new Opportunity(Id=lcr.getOpportunityId());
              o.CampaignId = leadConvertMap.get(lcr.getLeadId()).Primary_Campaign_SFDC2__c;
              futureUpdate.add(o);
            }

            if(!futureUpdate.isEmpty()) {
              update futureUpdate;
            }
        }
    }
  
  /**
  * SFDC 2.0 MC: When a Lead has Reassign To Queue ticked, reassign record to business unit
  * corresponding to owner's role
  */
  private void reassignLeadToQueue() {
    for(Lead l : newLeads) {
        //determine if the Lead is owned by a user who is a member of a role corresponding
        //to a business lead queue
        if(l.Reassign_To_Queue_SFDC2__c &&
            l.Owner_Role_SFDC2__c != null &&
            l.Owner_Role_SFDC2__c != '') {
            String queueName = UserTriggerHandler.roleLeadQueueMap.get(l.Owner_Role_SFDC2__c);
            if(queueName != null) {
                for(Group queue : UserTriggerHandler.queueMap.values()) {
                    if(queue.DeveloperName == queueName) {
                        l.OwnerId = queue.Id;
                        break;
                    }
                }
            }
        }
        //reset checkbox field
        l.Reassign_To_Queue_SFDC2__c = false;
    }
  }
  
 /**
  * For Consumer Deposits, when a Lead owned by a queue is updated by a member of the Consumer Deposits Team role,
  * reassign ownership to that user.
  * @param oldMap map of initial state Leads
  * @param newMap map of changed Leads
  */
  private void reassignLeadOwner_CD(Map<Id,Lead> oldMap, Map<Id,Lead> newMap) {
    // Filter to allow Sharepoint controller create leads without the reassignment
	if(!String.isBlank(UserInfo.getUserRoleId())){
      
        //determine the user's role
        UserRole ur = [SELECT DeveloperName FROM UserRole WHERE Id = :UserInfo.getUserRoleId()];
        
        //retrieve the Consumer Deposits Lead record type Id
        Id rtId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Consumer Deposits').getRecordTypeId();
        //RecordType rt = [SELECT Id FROM RecordType WHERE DeveloperName = 'Consumer_Deposits' AND SobjectType = 'Lead'];
        
        if(ur != null &&  (ur.DeveloperName == 'Consumer_Deposits' || ur.DeveloperName == 'Consumer_Deposits_Manager')  && rtId != null) {
            for(Lead lead : newMap.values()) {
                String ownerId = Id.valueOf(lead.OwnerId);
                //if the record is a Consumer Deposits Lead and is not owned by a User, set the current user as the owner
                if(lead.RecordTypeId == rtId &&
                    !ownerId.startsWith('005') && lead.isFromApplication__c != true) {
                        lead.OwnerId = Userinfo.getUserId();
                }
            }
        }
	}
  }
  
  /**
  * When phone fields change on a Lead, update the list of custom Phone objects to include
  * the original phone number. (Except when the object is associated with an account.)
  * @param oldLeadMap map of original state Leads
  * @param newLeadMap map of changed Leads
  */
  private void updatePhoneListSfdc2(Map<Id,Lead> oldLeadMap, Map<Id,Lead> newLeadMap) {

    // Get original Lead phone fields and related Phone objects
    List<Lead> leadsWithPhones = [select id, Phone, MobilePhone, Fax,
                                  (select id, Lead__c, Phone__c, Phone_Status__c, Phone_Type__c from Phones__r where 
                                         Lead__c IN :newLeadMap.keySet() and Account__c = null)
                                  from Lead where id IN :newLeadMap.keySet() and SFDC2__c = true];
    
    // Prepare collection of Phone objects to insert and delete 
    List<Phone_SFDC2__c> phonesToInsert = new List<Phone_SFDC2__c>();
    List<Phone_SFDC2__c> phonesToDelete = new List<Phone_SFDC2__c>();
    
    Boolean foundRecord = false;
    String currPhone = null;
    String newPhone = null;
    String phoneType = null;

    // Loop through Leads and create Phone objects when phone fields have been updated
    for (Lead lead : leadsWithPhones) {

        // Skip converted Leads
        if (newLeadMap.get(lead.id).IsConverted) continue;

        // Mark any Phone objects that are now a primary phone field value for deletion
        for (Phone_SFDC2__c phone : lead.Phones__r) {
            if (phone.Phone__c == newLeadMap.get(lead.id).Phone ||
                phone.Phone__c == newLeadMap.get(lead.id).MobilePhone ||
                phone.Phone__c == newLeadMap.get(lead.id).Fax) {
                    phonesToDelete.add(phone); 
                    continue;
                }       
        }
        
        // Search each phone field for changes
        for (Integer i = 0; i<3; i++) {
            if (i==0) {currPhone = oldLeadMap.get(lead.id).Phone; newPhone = newLeadMap.get(lead.id).Phone; if (newLeadMap.get(lead.id).Company == null) {phoneType = 'Other Home';} else {phoneType = 'Other Business';}}
            if (i==1) {currPhone = oldLeadMap.get(lead.id).MobilePhone; newPhone = newLeadMap.get(lead.id).MobilePhone; phoneType = 'Other Mobile';}
            if (i==2) {currPhone = oldLeadMap.get(lead.id).Fax; newPhone = newLeadMap.get(lead.id).Fax; phoneType = 'Other Fax';}

            // Find phone field values that have changed
            if (currPhone != newPhone && currPhone != null && currPhone != '') {

                // Make sure a Phone object does not already exist for this phone number
                foundRecord = false;
                for (Phone_SFDC2__c phone : lead.Phones__r) {
                    if (phone.Phone__c == currPhone) foundRecord = true;
                }

                // Do not add a Phone object if a different Lead phone field has the original phone number value
                if (currPhone == newLeadMap.get(lead.id).Phone ||
                    currPhone == newLeadMap.get(lead.id).MobilePhone ||
                    currPhone == newLeadMap.get(lead.id).Fax ) foundRecord = true;

                // Create new Phone objects as necessary
                if (!foundRecord) {
                    Phone_SFDC2__c phone = new Phone_SFDC2__c();
                    phone.Lead__c = lead.Id;
                    phone.Phone__c = currPhone;
                    phone.Phone_Type__c = phoneType;
                    phone.Phone_Status__c = 'Verified';
                    phonesToInsert.add(phone);
                }
            }   
        }
    }
    
    insert phonesToInsert;
    delete phonesToDelete;
    
  }

  /**
  * When email address fields on a Lead change, update the related Emails list
  * to include the original email address (Except when the object is associated with an Account)
  * @param oldLeadMap map of original state Leads
  * @param newLeadMap map of changed Leads
  */
  private void updateEmailListSfdc2(Map<Id,Lead> oldLeadMap, Map<Id,Lead> newLeadMap) {
    
    // Get original Lead email fields and related Email objects
    List<Lead> leadsWithEmails = [select id, Email,
                                  (select id, Lead__c, Email__c, Email_Status__c, Email_Type__c from Email_Addresses__r where 
                                      Lead__c IN :newLeadMap.keySet() and Account__c = null) 
                                  from Lead where id IN :newLeadMap.keySet() and SFDC2__c = true];
                                         
    // Prepare collection of Email objects to insert and delete 
    List<Email_SFDC2__c> emailsToInsert = new List<Email_SFDC2__c>();
    List<Email_SFDC2__c> emailsToDelete = new List<Email_SFDC2__c>();
    
    Boolean foundRecord = false;
    String currEmail = null;
    String newEmail = null;
    String emailType = null;
    
    // Loop through Leads and create Email objects when email fields have been updated
    for (Lead lead : leadsWithEmails) {

        // Skip converted Leads
        if (newLeadMap.get(lead.id).IsConverted) continue;

        // Mark any email addresses that are now in a primary field for deletion
        for (Email_SFDC2__c email : lead.Email_Addresses__r) {
            if (email.Email__c == newLeadMap.get(lead.id).Email) {
                    emailsToDelete.add(email); 
                    continue;
            }                       
        }

        // Search each email field for changes
        for (Integer i = 0; i<1; i++) {
            if (i==0) {currEmail = oldLeadMap.get(lead.id).Email; newEmail = newLeadMap.get(lead.id).Email; if (newLeadMap.get(lead.id).Company == null) {emailType = 'Other Personal';} else {emailType = 'Other Business';}}

            // Find email field values that have changed
            if (currEmail != newEmail && currEmail != null && currEmail != '') {

                // Make sure a Email object does not already exist for this email address
                foundRecord = false;
                for (Email_SFDC2__c email : lead.Email_Addresses__r) {
                    if (email.Email__c == currEmail) foundRecord = true;
                }

                // Do not add an Email object if a different Account email field has the original email address value
                if (currEmail == newLeadMap.get(lead.id).Email) foundRecord = true;

                // Create new Email objects as necessary
                if (!foundRecord) {
                    Email_SFDC2__c email = new Email_SFDC2__c();
                    email.Lead__c = lead.Id;
                    email.Email__c = currEmail;
                    email.Email_Type__c = emailType;
                    email.Email_Status__c = 'Verified';
                    emailsToInsert.add(email);
                }
            }   
        }
    }
    
    insert emailsToInsert;
    delete emailsToDelete;
    
  }

  /**
   * When address fields on a Lead change, update the Address related list to include
   * the original address (Except when the Address is associated with an Account.)
   * @param oldAcctMap map of original state Accounts
   * @param newAcctMap map of changed Accounts
   */
  private void updateAddressListSfdc2(Map<Id,Lead> oldLeadMap, Map<Id,Lead> newLeadMap) {
    
    // Get original Lead addresss fields and related Address objects
    List<Lead> leadsWithAddresses = [select id, Street, City, Country, State, PostalCode, Primary_Loan_Type_SFDC2__c, Primary_Mortgage_Lender_SFDC2__c, 
                                     Primary_Purchase_Amount_SFDC2__c, Primary_Purchase_Date_SFDC2__c,
                                     (select id, Lead__c, Street__c, City__c, Country__c, State__c, Postal_Code__c, Address_Type__c,
                                            Mortgage_Lender__c, Loan_Type__c, Purchase_Date__c, Purchase_Amount__c from Addresses__r where 
                                            Lead__c IN :newLeadMap.keySet() and Account__c = null) 
                                     from Lead where id IN :newLeadMap.keySet() and SFDC2__c = true];
                                         
    // Prepare collection of Address objects to insert and delete   
    List<Address_SFDC2__c> addressesToInsert = new List<Address_SFDC2__c>();
    List<Address_SFDC2__c> addressesToDelete = new List<Address_SFDC2__c>();
    
    Boolean foundRecord = false;
    String currStreet = null;
    String currCity = null;
    String currCountry = null;
    String currState = null;
    String currPostalCode = null;
    String currLender = null;
    String currLoanType = null;
    Date currPurchaseDate = null;
    Double currPurchaseAmount = null;

    String newStreet = null;
    String newCity = null;
    String newCountry = null;
    String newState = null;
    String newPostalCode = null;
    String newLender = null;
    String newLoanType = null;
    Date newPurchaseDate = null;
    Double newPurchaseAmount = null;

    String addressType = null;
    
    // Loop through Leads and create Address objects when address fields have been updated
    for (Lead lead : leadsWithAddresses) {

        // Skip converted leads
        if (newLeadMap.get(lead.id).IsConverted) continue;

        // Mark any Address object that is now a primary field value for deletion
        for (Address_SFDC2__c address : lead.Addresses__r) {
            if (address.Street__c == newLeadMap.get(lead.id).Street && address.City__c == newLeadMap.get(lead.id).City && address.Postal_Code__c == newLeadMap.get(lead.id).PostalCode
                && address.Mortgage_Lender__c == newLeadMap.get(lead.id).Primary_Mortgage_Lender_SFDC2__c && address.Loan_Type__c == newLeadMap.get(lead.id).Primary_Loan_Type_SFDC2__c
                && address.Purchase_Date__c == newLeadMap.get(lead.id).Primary_Purchase_Date_SFDC2__c && address.Purchase_Amount__c == newLeadMap.get(lead.id).Primary_Purchase_Amount_SFDC2__c) {
                    addressesToDelete.add(address); 
                    continue;
            }               
        }

        // Search each address field for changes
        for (Integer i = 0; i<1; i++) {
            if (i==0) {
                currStreet          = oldLeadMap.get(lead.id).Street; 
                currCity            = oldLeadMap.get(lead.id).City; 
                currCountry         = oldLeadMap.get(lead.id).Country; 
                currState           = oldLeadMap.get(lead.id).State; 
                currPostalCode      = oldLeadMap.get(lead.id).PostalCode; 
                currLender          = oldLeadMap.get(lead.id).Primary_Mortgage_Lender_SFDC2__c;
                currLoanType        = oldLeadMap.get(lead.id).Primary_Loan_Type_SFDC2__c;
                currPurchaseDate    = oldLeadMap.get(lead.id).Primary_Purchase_Date_SFDC2__c;
                currPurchaseAmount  = oldLeadMap.get(lead.id).Primary_Purchase_Amount_SFDC2__c;
                newStreet           = newLeadMap.get(lead.id).Street; 
                newCity             = newLeadMap.get(lead.id).City; 
                newCountry          = newLeadMap.get(lead.id).Country; 
                newState            = newLeadMap.get(lead.id).State; 
                newPostalCode       = newLeadMap.get(lead.id).PostalCode; 
                newLender           = newLeadMap.get(lead.id).Primary_Mortgage_Lender_SFDC2__c;
                newLoanType         = newLeadMap.get(lead.id).Primary_Loan_Type_SFDC2__c;
                newPurchaseDate     = newLeadMap.get(lead.id).Primary_Purchase_Date_SFDC2__c;
                newPurchaseAmount   = newLeadMap.get(lead.id).Primary_Purchase_Amount_SFDC2__c;
                addressType = 'Other';
            }

            // Find address field values that have changed
            if ((currStreet != newStreet && currStreet != null && currStreet != '')
                || (currCity != newCity && currCity != null && currCity != '')
                || (currPostalCode != newPostalCode && currPostalCode != null && currPostalCode != '')) {

                // Make sure a Address object does not already exist for this address
                foundRecord = false;
                for (Address_SFDC2__c address : lead.Addresses__r) {
                    if (address.Street__c == currStreet && address.City__c == currCity && address.Postal_Code__c == currPostalCode
                        && address.Mortgage_Lender__c == currLender && address.Loan_Type__c == currLoanType
                        && address.Purchase_Date__c == currPurchaseDate && address.Purchase_Amount__c == currPurchaseAmount) foundRecord = true;
                }

                // Do not add an Address object if a different Account address fields have the original address value
                if (currStreet == newLeadMap.get(lead.id).Street && currCity == newLeadMap.get(lead.id).City && currPostalCode == newLeadMap.get(lead.id).PostalCode
                    && currLender == newLeadMap.get(lead.id).Primary_Mortgage_Lender_SFDC2__c && currLoanType == newLeadMap.get(lead.id).Primary_Loan_Type_SFDC2__c
                    && currPurchaseDate == newLeadMap.get(lead.id).Primary_Purchase_Date_SFDC2__c && currPurchaseAmount == newLeadMap.get(lead.id).Primary_Purchase_Amount_SFDC2__c) foundRecord = true;

                // Create new Address objects as necessary
                if (!foundRecord) {
                    Address_SFDC2__c address = new Address_SFDC2__c();
                    address.Lead__c = lead.Id;
                    address.Street__c = currStreet;
                    address.City__c = currCity;
                    address.Country__c = currCountry;
                    address.State__c = currState;
                    address.Postal_Code__c = currPostalCode;
                    address.Loan_Type__c = currLoanType;
                    address.Mortgage_Lender__c = currLender;
                    address.Purchase_Date__c = currPurchaseDate;
                    address.Purchase_Amount__c = currPurchaseAmount;
                    address.Address_Type__c = addressType;
                    addressesToInsert.add(address);
                }
            }   
        }
    }
    
    insert addressesToInsert;
    delete addressesToDelete;
    
  }
  
  /**
   * Handle custom field updates and updating Account lookups on custom objects after Lead conversion
   * @param oldAcctMap map of original state Accounts
   * @param newAcctMap map of changed Accounts
   */
  private void handleLeadConversion(Map<Id,Lead> oldLeadMap, Map<Id,Lead> newLeadMap) {
    
    // Get converted Leads in SFDC2 with associated custom objects
    List<Lead> newLeads = [select id, Street, City, Country,Email, State, PostalCode, Primary_Loan_Type_SFDC2__c, Primary_Mortgage_Lender_SFDC2__c, 
                                Primary_Purchase_Amount_SFDC2__c, Primary_Purchase_Date_SFDC2__c, Corporation_Type_HBD__c, Other_Corporation__c,
                                convertedAccountId, convertedContactId, convertedOpportunityId, Date_of_Birth__c, LeadSource, Opportunity_NameSFDC2__c,
                                (select id, Account__c from Phones__r where Lead__c IN :newLeadMap.keySet() and Account__c = null), 
                                (select id, Account__c from Email_Addresses__r where Lead__c IN :newLeadMap.keySet() and Account__c = null), 
                                (select id, Account__c from Addresses__r where Lead__c IN :newLeadMap.keySet() and Account__c = null) 
                            from Lead where id IN :newLeadMap.keySet() and SFDC2__c = true and IsConverted = true];

    // Assemble converted id sets
    Set<Id> convertedAccountIds = new Set<Id>();
    Set<Id> convertedContactIds = new Set<Id>();
    Set<Id> convertedOpportunityIds = new Set<Id>();
    
    for (Lead lead: newLeads) {
        if (lead.convertedAccountId != null) convertedAccountIds.add(lead.convertedAccountId);
        if (lead.convertedContactId != null) convertedContactIds.add(lead.convertedContactId);
        if (lead.convertedOpportunityId != null) convertedOpportunityIds.add(lead.convertedOpportunityId);
    }
    
    // Get records associated with converted ids
    List<Account> accounts = [select Id, RecordTypeId, PersonMailingStreet, PersonMailingCity, PersonMailingCountry, PersonMailingState, PersonMailingPostalCode,
                                Mailing_Loan_Type_SFDC2__pc, Mailing_Mortgage_Lender_SFDC2__pc, Mailing_Purchase_Amount_SFDC2__pc, 
                                Mailing_Purchase_Date_SFDC2__pc, Email__c, BillingStreet, BillingCity, BillingCountry, BillingState, BillingPostalCode,
                                Billing_Loan_Type_SFDC2__c, Billing_Mortgage_Lender_SFDC2__c, Billing_Purchase_Amount_SFDC2__c, Billing_Purchase_Date_SFDC2__c,
                                Corporation_Type__c, Other_Corporation__c, 
                                isPersonAccount, PersonBirthdate, AccountSource from Account where Id IN :convertedAccountIds];
    Map<Id, Account> accountMap = new Map<Id, Account>(accounts);
    
    List<Contact> contacts = [select Id, RecordTypeId, Birthdate from Contact where Id IN :convertedContactIds];
    Map<Id, Contact> contactMap = new Map<Id, Contact>(contacts);
    
    //List<Opportunity> opportunities = [select Id, RecordTypeId from Opportunity where Id IN :convertedOpportunityIds];
    //Map<Id, Opportunity> opportunityMap = New Map<Id, Opportunity>(opportunities);
    
    List<Account> accountsToUpdate = new List<Account>();
    List<Contact> contactsToUpdate = new List<Contact>();
    List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
    List<Phone_SFDC2__c> phonesToUpdate = new List<Phone_SFDC2__c>();
    List<Email_SFDC2__c> emailsToUpdate = new List<Email_SFDC2__c>();
    List<Address_SFDC2__c> addrsToUpdate = new List<Address_SFDC2__c>();
    
    // Get record types for Accounts and Contacts
    Id businessAccountRtId =    Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account SFDC2').getRecordTypeId();
    Id personAccountRtId =      Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer Person Account SFDC2').getRecordTypeId();
    RecordType contactRT =      [select id from RecordType where Name = 'Business SFDC2' and SObjectType = 'Contact'];
    
    // Loop through updated Leads, find those that whose conversion triggered this update, and set RecordTypes and Lookup values on related records
    for (Lead lead : newLeads) {
             
        // Find newly converted Leads
        if (oldLeadMap.get(lead.id).IsConverted == false) {
        
            // Update Account lookup for Phone objects
            for (Phone_SFDC2__c phone : lead.Phones__r) {
                phone.Account__c = lead.ConvertedAccountId;
                phonesToUpdate.add(phone);
            }

            // Update Account lookup for Email objects              
            for (Email_SFDC2__c email : lead.Email_Addresses__r) {
                email.Account__c = lead.ConvertedAccountId;
                emailsToUpdate.add(email);
            }
            
            // Update Account lookup for Address objects
            for (Address_SFDC2__c addr : lead.Addresses__r) {
                addr.Account__c = lead.ConvertedAccountId;
                addrsToUpdate.add(addr);
            }
            
            // Set Account fields and record type
            Account account = accountMap.get(lead.convertedAccountId);
            if (account.IsPersonAccount) {
                account.RecordTypeId = personAccountRtId;
                account.PersonMailingStreet     = lead.Street;
                account.PersonMailingCity       = lead.City;
                account.PersonMailingState      = lead.State;
                account.PersonMailingCountry    = lead.Country;
                account.PersonMailingPostalCode = lead.PostalCode;
                account.Mailing_Loan_Type_SFDC2__pc         = lead.Primary_Loan_Type_SFDC2__c;
                account.Mailing_Mortgage_Lender_SFDC2__pc   = lead.Primary_Mortgage_Lender_SFDC2__c;
                account.Mailing_Purchase_Amount_SFDC2__pc   = lead.Primary_Purchase_Amount_SFDC2__c;
                account.Mailing_Purchase_Date_SFDC2__pc     = lead.Primary_Purchase_Date_SFDC2__c;
                account.PersonBirthdate         = lead.Date_of_Birth__c;
                account.AccountSource           = lead.LeadSource;  
            } else {
                account.RecordTypeId = businessAccountRtId;
                account.Email__c                = lead.Email;
                account.BillingStreet           = lead.Street;
                account.BillingCity             = lead.City;
                account.BillingState            = lead.State;
                account.BillingCountry          = lead.Country;
                account.BillingPostalCode       = lead.PostalCode;
                account.Billing_Loan_Type_SFDC2__c          = lead.Primary_Loan_Type_SFDC2__c;
                account.Billing_Mortgage_Lender_SFDC2__c    = lead.Primary_Mortgage_Lender_SFDC2__c;
                account.Billing_Purchase_Amount_SFDC2__c    = lead.Primary_Purchase_Amount_SFDC2__c;
                account.Billing_Purchase_Date_SFDC2__c      = lead.Primary_Purchase_Date_SFDC2__c;  
                account.AccountSource           = lead.LeadSource;
                account.Corporation_Type__c               = lead.Corporation_Type_HBD__c;
                account.Other_Corporation__c              = lead.Other_Corporation__c;                
            }
            accountsToUpdate.add(account);
            
            // Set Contact record type
            Contact contact = contactMap.get(lead.convertedContactId);
            contact.RecordType = contactRT;
            contactsToUpdate.add(contact);
            
        }
        
    }
    
    // Update objects as necessary
    if (accountsToUpdate.size() > 0) update accountsToUpdate;
    if (contactsToUpdate.size() > 0) update contactsToUpdate;
    if (opportunitiesToUpdate.size() > 0) update opportunitiesToUpdate;
    if (phonesToUpdate.size() > 0) update phonesToUpdate;
    if (emailsToUpdate.size() > 0) update emailsToUpdate;
    if (addrsToUpdate.size() > 0) update addrsToUpdate;
        
  }

  /**
   * Update SFDC2 checkbox based on Lead record type
   * @param newLeads list of updated or inserted Leads
   */
    /**
   * Update SFDC2 checkbox based on Lead record type
   * @param newLeads list of updated or inserted Leads
   */
    private void updateSFDC2Checkbox(List<Lead> newLeads) {
        
        Set<Id> sfdc2Ids = new set<Id>();
        for (Manager_SFDC2__mdt rtName : [Select RecordType_Name__c from Manager_SFDC2__mdt where isLeadRT_SFDC2__c = true]){       
            sfdc2Ids.add(Schema.SObjectType.Lead.getRecordTypeInfosByName().get(rtName.RecordType_Name__c).getRecordTypeId()); 
        }
        for(Lead lead: newLeads) {
            //Sync with Marketo field Update
            
            if( sfdc2Ids.contains(lead.RecordTypeId))  { 
                lead.SFDC2__c = true; 
                if(lead.Email != Null && !lead.HasOptedOutOfEmail   )lead.Sync_with_Marketo__c = true;
            }
            else  lead.SFDC2__c = false;
        }
    } 
}