/**
* @description <p>Handler class for AccountTrigger functionality</p>
* @author Mike Crosby, BofI Federal 
*/
public class AccountTriggerHandler extends TriggerHandler{
    
    /** Map of Accounts before changes */
    private Map<Id, Account> oldAcctMap;
    /** Map of Accounts with changes */
    private Map<Id, Account> newAcctMap;
    /** List of Accounts with changes */
    private List<Account> newAcctList;
    
    public static Set<Id> sfPersonAcctRecordIds = new Set<Id> { 
        '012i0000001QBMU', //IGT Winners
            '012i0000001AM00', //Lottery Winners
            '012i0000001AM01'  //SS Annuitants
            }; 
                
                public static Set<String> flaggedSpecFinProfiles = new Set<String> {
                    'Specialty Finance - Lottery Sales Manager',
                        'Specialty Finance - Lottery Sales Rep',
                        'Specialty Finance - Structured Settlement Manager',
                        'Specialty Finance - Structured Settlement Rep'
                        };
                            public static Set<Id> lxnxSpecFinRTIdSet = new Set<Id>(sfPersonAcctRecordIds); 
    public static Set<Id> neustarSpecFinRTIdSet = new Set<Id>(sfPersonAcctRecordIds);
    
    public static final String SF_OUTBOUNDOWNERID = '005i0000006ne2Z';  //SF Outbound Account Pool id
    
    
    /** Constructor */
    public AccountTriggerHandler() {
        this.oldAcctMap = (Map<Id, Account>) Trigger.oldMap;
        this.newAcctMap = (Map<Id, Account>) Trigger.newMap;
        this.newAcctList = (List<Account>) Trigger.new;
    }
    
    /**
* Process beforeInsert logic
*/
    public override void beforeInsert() {
        updateSFDC2Checkbox(this.newAcctList);
        updateLexisNexisCalloutStatus(null, newAcctList);
    }
    
    /**
* Process beforeUpdate logic
*/
    public override void beforeUpdate() {
        updateSFDC2Checkbox(this.newAcctList);
        restrictSFDC2AccountUpdates();
        updatePhoneListSfdc2(oldAcctMap, newAcctMap);
        updateEmailListSfdc2(oldAcctMap, newAcctMap);
        updateAddressListSfdc2(oldAcctMap, newAcctMap);
        checkSpecFinOwnerChange(this.oldAcctMap, this.newAcctMap);
        updateLexisNexisCalloutStatus(oldAcctMap, newAcctList);
        handleManualNeustarTrigger(oldAcctMap, newAcctMap);
        handleManualLexisNexisTrigger(oldAcctMap, newAcctMap);
        restrictAccOwner(this.oldAcctMap, this.newAcctList, Userinfo.getUserId());
    }
    
    /**
* Process afterInsert logic
*/
    public override void afterInsert() {
        triggerInsertSFLexisNexisCallout(this.newAcctMap);
       // Contactpersonaccconv(this.newAcctList);
        //SFDC2
        //  triggerMortgageCrossSellOppCreation();
    }
    
    /**
* Process afterUpdate logic
*/
    public override void afterUpdate() {
        reassignContactOwners(this.oldAcctMap, this.newAcctMap);
        triggerUpdateSFLexisNexisCallout(this.oldAcctmap, this.newAcctMap);
        triggerUpdateSFNeustarCallout(this.oldAcctMap, this.newAcctMap);
        //SFDC2
        // triggerMortgageCrossSellOppCreation();
        handleDoNotCallUpdateSFDC2();
    }
    
    
    // SFDC2: Restrict Account Owner validation 
    public void restrictAccOwner(Map<Id, Account> oldAcctMap, List<Account> newAcctList, String userId){
        // Set Roles & Profiles
        Set<String> profiles = new Set<String>{'Enterprise User','System Administrator','API Service Account'};
            Set<String> managers = new Set<String>{'Research Manager', 'C&I Manager - EQF', 'C&I Manager - Factoring', 'C&I Manager - LF & CRESL','Financial Advisor Mgr','Consumer Deposits Manager', 'Consumer Wholesale Manager','Researcher','Dealer Services Manager','Business Banking Manager','Virtus Manager', 'HBD Manager'};
                Set<String> nonManagers = new Set<String>{'Financial Advisor Rep', 'C&I - EQF', 'C&I - Factoring', 'C&I - LF & CRESL','Consumer Deposits','Dealer Services Rep', 'Consumer Wholesale','Business Banking','Virtus Rep', 'HBD'};
                    
                    // Variable initialization
                    List<Account> aChangeOwner = new List<Account>();
        List<String> aId = new List<String>();
        Boolean allowed = false;
        
        User usr = [SELECT Profile.Name, UserRole.Name FROM User WHERE Id =:userId];
        User apiServ = [SELECT Id FROM User WHERE Profile.Name = 'API Service Account' limit 1];
        User researchmgr = [SELECT Id FROM User WHERE UserRole.Name = 'Research Manager' limit 1];
        for(Account acc : newAcctList){
            if(acc.OwnerId != oldAcctMap.get(acc.Id).OwnerId && acc.SFDC2__c){
                aChangeOwner.add(acc);
                aId.add(acc.Id);
            }
        }
        
        for(Account acc : aChangeOwner){
            String oldOwnerId = oldAcctMap.get(acc.Id).OwnerId;
            
            if(!profiles.contains(usr.Profile.Name)){
                allowed=true;
            }
            if(oldOwnerId == apiServ.Id){
                if(nonManagers.contains(usr.UserRole.Name)){
                    if(usr.Id != acc.OwnerId){
                        allowed=true;
                    }
                }
            }    
            else{
                if(!managers.contains(usr.UserRole.Name) && nonManagers.contains(usr.UserRole.Name) && usr.Id != acc.OwnerId && oldOwnerId != apiServ.Id){
                    allowed=true;
                }
            }
            
            if(acc.OwnerId == apiServ.Id || acc.OwnerId == researchmgr.Id){
                allowed=false;
            }
            
            if(allowed)
                acc.addError('Dont have priviliges to change owner');
        }
    }
    
    /**
* When the Do Not Call checkbox is toggled, trigger check to determine whether Person Account
* should be added to or expired from a campaign
*/
    private void handleDoNotCallUpdateSFDC2() {
        //list of ids to verify for campaign member addition
        Set<Id> potentialCMList = new Set<Id>();
        
        for(Account a : newAcctMap.values()) {
            if(a.SFDC2__c && a.IsPersonAccount) {
                Account oldA = oldAcctMap.get(a.Id);
                if(a.PersonDoNotCall != oldA.PersonDoNotCall) {
                    potentialCMList.add(a.Person_Contact_Id__c);
                }
            }
        }
        
        //only contacts related to Financial Accounts should be considered for campaign updates
        if(potentialCMList.size() > 0) {
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
* SFDC2: Creates a cross-sell opportunity if Account meets criteria
*/
    /* private void triggerMortgageCrossSellOppCreation() {
List<Id> acctIdList = new List<Id>();
for(Account a : this.newAcctMap.values()) {
Account oldA;
if(this.oldAcctMap == null) {
oldA = new Account();
} else {
oldA = this.oldAcctMap.get(a.Id);
}
if(a.Edisclosure_Accepted_Person__c &&
a.SFDC2__c &&
(oldA == null || !oldA.Edisclosure_Accepted_Person__c)   
) {
acctIdList.add(a.Id);
}
}

//for accounts that potentially need a cross-sell, perform further investigation of linked records
Id cdRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Consumer Deposits SFDC2').getRecordTypeId();
List<String> crossSellIds = new List<String>();
for(Account a : [SELECT 
Id, 
(SELECT 
Financial_Account_Department__c 
FROM 
Financial_Account_Contact_Links__pr 
WHERE Financial_Account_Department__c = 'Mortgage Lending'),
(SELECT
Id
FROM 
Opportunities 
WHERE 
(IsClosed = false AND 
RecordTypeId = :cdRTId) OR
Name = 'Cross Sell from Mortgage')
FROM
Account
WHERE
Id in :acctIdList]) 

{
if(a.Financial_Account_Contact_Links__pr.size() > 0 &&
a.Opportunities.size() == 0) {
//create a mortgage cross sell
crossSellIds.add(a.Id);
}
}

if(crossSellIds.size() > 0) {
futureMortgageCrossSellOppCreation(crossSellIds);
}
} */
    
    /**
* SFDC2: Future method to trigger Opp creation for Mortgage Cross Sell
* @param idList list of Account ids to potentially create opps for
*/
    @future
    static private void futureMortgageCrossSellOppCreation(List<String> idList) {
        Id cdRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Consumer Deposits SFDC2').getRecordTypeId();
        //do not create opps if (1) there is already an open Consumer Deposit opportuntity or (2)
        //a Mortgage cross sell opp already exists
        List<Opportunity> newOpps = new List<Opportunity>();
        List<CampaignMember> newCMs = new List<CampaignMember>();
        Campaign[] c = [SELECT Id, (SELECT ContactId FROM CampaignMembers) FROM Campaign WHERE Name = '250 Consumer Deposit Campaign' LIMIT 1];
        Map<Id,Account> acctContactLookup = new Map<Id,Account>([SELECT Id, Person_Contact_Id__c FROM Account WHERE Id in :idList]);
        for(Account a : acctContactLookup.values()) {
            Opportunity o = new Opportunity();
            o.AccountId = a.Id;
            o.StageName = '1 - New';
            o.Name = 'Cross Sell from Mortgage';
            o.CloseDate = Date.today().addDays(30);
            o.LeadSource = 'Cross-Sell';
            o.RecordTypeId = cdRTId;
            o.OwnerId = UserTriggerHandler.APIAccountId;
            o.Opportunity_Queue__c = true;
            newOpps.add(o);
            
            if(c.size() > 0) {
                Boolean hasCM = false;
                for(CampaignMember existingCM : c[0].CampaignMembers) {
                    if(existingCM.ContactId == a.Person_Contact_Id__c) {
                        hasCM = true;
                        break;
                    }
                }
                if(!hasCM) {
                    CampaignMember cm = new CampaignMember();
                    cm.CampaignId = c[0].Id;
                    cm.ContactId = a.Person_Contact_Id__c;
                    cm.Status = 'Attempting Contact';
                    newCMs.add(cm);
                }
            }
        }
        
        if(newOpps.size() > 0) {
            insert newOpps;
        }
        if(newCMs.size() > 0) {
            insert newCMs;
        }
    }
    
    /**
* Set LexisNexis Callout Status to Queued is eligible for callout
* @param oldAcctMap Map of Account records prior to change
* @param newAcctList list of Account records post change
*/
    private void updateLexisNexisCalloutStatus(Map<Id,Account> oldAcctMap, List<Account> newAcctList) {
        for(Account acct : newAcctList) {
            Account oldAcct = null;
            if(oldAcctMap != null) {
                oldAcct = oldAcctMap.get(acct.Id);
            }
            if(isLexisNexisCalloutEligible(oldAcct, acct)) {
                acct.SF_LexisNexis_Callout_Status__c = 'Queued';
            }
        }
    }
    
    /**
* For Specialty Finance person accounts, trigger a callout to Lexis Nexis to retrieve personal
* data if the Account record meets the expected criteria
* @param newAcctMap map of inserted Accounts
*/
    private void triggerInsertSFLexisNexisCallout(Map<Id,Account> newAcctMap) {
        for(Account acct : newAcctMap.values()) {
            if(isLexisNexisCalloutEligible(null, acct)) {
                addSFLexisNexisAccountJob(acct);
            }
        }
    }
    
    /**
* For Specialty Finance person accounts, trigger a callout to Lexis Nexis to retrieve personal
* data if the Account record meets the expected criteria
* @param oldAcctMap map of initial state Accounts
* @param newAcctMap map of changed Accounts
*/
    private void triggerUpdateSFLexisNexisCallout(Map<Id,Account> oldAcctMap, Map<Id,Account> newAcctMap) {
        for(Account acct : newAcctMap.values()) {
            Account oldAcct = oldAcctMap.get(acct.Id);
            if(isLexisNexisCalloutEligible(oldAcct, acct)) {
                addSFLexisNexisAccountJob(acct);
            }
        }
    }
    
    /**
* For Specialty Finance person accounts, trigger a callout to LexisNexis
* data if LexisNexis Trigger field is set to true
* @param oldAcctMap map of initial state Accounts
* @param newAcctMap map of changed Accounts
*/
    private void handleManualLexisNexisTrigger(Map<Id,Account> oldAcctMap, Map<Id,Account> newAcctMap) {
        for(Account acct : newAcctMap.values()) {
            if(acct.LexisNexis_Trigger__c && acct.Social_Security_Number_Person__c!= null) {
                addSFLexisNexisAccountJob(acct);
                acct.LexisNexis_Trigger__c = false;
            }
        }   
    }
    
    /**
* For Specialty Finance person accounts, trigger a callout to Neustar to retrieve phone/address scoring
* data if Neustar Trigger field is set to true
* @param oldAcctMap map of initial state Accounts
* @param newAcctMap map of changed Accounts
*/
    private void handleManualNeustarTrigger(Map<Id,Account> oldAcctMap, Map<Id,Account> newAcctMap) {
        for(Account acct : newAcctMap.values()) {
            if(acct.Neustar_Trigger__c) {
                addSFNeustarJob(acct);
                acct.Neustar_Trigger__c = false;
            }
        }   
    }
    
    /**
* For Specialty Finance person accounts, trigger a callout to Neustar to retrieve phone/address scoring
* data if the Account record meets the expected criteria
* @param oldAcctMap map of initial state Accounts
* @param newAcctMap map of changed Accounts
*/
    private void triggerUpdateSFNeustarCallout(Map<Id,Account> oldAcctMap, Map<Id,Account> newAcctMap) {
        for(Account acct : newAcctMap.values()) {
            Account oldAcct = oldAcctMap.get(acct.Id);
            if(isNeustarCalloutEligible(oldAcct, acct)) {
                System.debug('**** Spec Fin account eligible for Neustar Callout');
                addSFNeustarJob(acct);
            }
        }
    }
    
    /**
* Tests Account change to determine if it warrants a callout to Neustar
* @param oldAcct Account record prior to change
* @param newAcct Account record post change
*/
    private Boolean isNeustarCalloutEligible(Account oldAcct, Account newAcct) {
        //Verify there is an Account record to check
        if(newAcct == null) {
            return false;
        }
        
        //Account record type must match one of the Specialty Finance record types that can trigger the API call
        if(!neustarSpecFinRTIdSet.contains(newAcct.RecordTypeId)) {
            return false;
        }
        
        //Research Status must be New Researched
        if(newAcct.Research_Status_Person__c != 'New Researched') {
            return false;
        }
        
        //Owner must be Outbound Account Pool
        if(newAcct.OwnerId != AccountTriggerHandler.SF_OUTBOUNDOWNERID) {
            return false;
        }
        
        //check for field changes
        if(oldAcct.Research_Status_Person__c == newAcct.Research_Status_Person__c &&
           oldAcct.OwnerId == newAcct.OwnerId
          ){
              return false;      
          }
        
        //only trigger if there are Address and/or Phone records
        Account tmpAcc = [SELECT Id, (SELECT Id, Name FROM Phone_Numbers__r LIMIT 1), (SELECT Id, Name from Address__r LIMIT 1) FROM Account WHERE Id = :newAcct.Id];
        if(tmpAcc.Phone_Numbers__r.size() == 0 && tmpAcc.Address__r.size() == 0) {
            return false;
        }
        
        return true;
    }
    
    /**
* Tests Account change to determine if it warrants a callout to LexisNexis
* @param oldAcct Account record prior to change
* @param newAcct Account record post change
*/
    private Boolean isLexisNexisCalloutEligible(Account oldAcct, Account newAcct) {
        //Verify there is an Account record to check
        if(newAcct == null) {
            return false;
        }
        
        //Account record type must match one of the Specialty Finance record types that can trigger the API call
        if(!lxnxSpecFinRTIdSet.contains(newAcct.RecordTypeId)) {
            return false;
        }
        
        //Account must have an SSN value
        String ssn = newAcct.Social_Security_Number_Person__c;
        if(ssn == null) {
            return false;
        }
        
        //SSN value must be 9 digits and numeric
        ssn = ssn.replace('-','').trim();
        if(ssn.length() != 9 || !ssn.isNumeric()) {
            return false;
        }
        
        //handle inserts
        if(oldAcct == null) {
            //Only New Unresearched accounts will trigger call
            if(newAcct.Research_Status_Person__c != 'New Unresearched') {
                return false;
            }   
        } else {
            //handle updates
            //only Accounts whose Research Status is changed from a non-qualifying status to a qualifying status will trigger call
            if(
                (newAcct.Research_Status_Person__c != 'New Unresearched' && newAcct.Research_Status_Person__c != 'Needs Research') || 
                (oldAcct.Research_Status_Person__c == 'New Unresearched' || oldAcct.Research_Status_Person__c == 'Needs Research')
            ){
                return false;       
            }
        }
        
        return true;
    }
    
    /**
* Creates queueable Neustar job for the account
* @param acct Account record to submit to Neustar API
*/
    private void addSFNeustarJob(Account acct) {
        System.debug('**** Adding Neustar callout job');
        try
        {
            ID jobID = System.enqueueJob(new NeustarQueueableJob(acct));
            toInsert.add(new Webservice_Callout__c(Job_ID__c = jobID, 
                                                   Job_Name__c = 'NeustarQueueableJob',
                                                   Account__c = acct.Id,
                                                   Status__c = 'Queued'));
        } catch(Exception e) {
            System.debug('**** ERROR: Unable to add Neustar job to queue: ' + e.getMessage());
        }
    }
    
    /**
* Creates queueable LexisNexis job for the account
* @param acct Account record to submit to LexisNexis API
*/
    private void addSFLexisNexisAccountJob(Account acct) {
        System.debug('**** Adding LexisNexis callout job');
        try
        {
            ID jobID = System.enqueueJob(new LexisNexisAccountQueueableJob(acct));
            toInsert.add(new Webservice_Callout__c(Job_ID__c = jobID, 
                                                   Job_Name__c = 'LexisNexisAccountQueueableJob',
                                                   Account__c = acct.Id,
                                                   Status__c = 'Queued'));
        } catch(Exception e) {
            System.debug('**** ERROR: Unable to add LexisNexis job to queue: ' + e.getMessage());
        }
    }
    
    /**
* When Accounts of specific record types are reassigned, ensure that all associated Contacts are also reassigned
* @param oldAcctMap map of initial state Accounts
* @param newAcctMap map of changed Accounts
*/
    private void reassignContactOwners(Map<Id,Account> oldAcctMap, Map<Id,Account> newAcctMap) {
        System.debug('**** reassignContactOwners');
        //Establish a map of Account Record Type IDs whose Contact record owners should be synched
        Set<String> acctRTSet = new Set<String>();
        for(Account_Contact_Owner_Sync__c cs : [
            select Account_Record_Type_ID__c
            from Account_Contact_Owner_Sync__c
        ]) {
            acctRTSet.add(cs.Account_Record_Type_ID__c);
            System.debug('**** Record Type Id to sync = ' + cs.Account_Record_Type_ID__c);
        }
        
        Set<Id> acctIdSet = new Set<Id>();
        List<Contact> contactsToUpdate = new List<Contact>();
        
        //build a set of Account ids that have ownership changes and whose record type id is configured for synching
        for(Account a : newAcctMap.values()) {
            System.debug('**** Account Record Type Id =' + a.RecordTypeId);
            
            Account oldAcct = oldAcctMap.get(a.Id);
            if(oldAcct.OwnerId != a.OwnerId && 
               acctRTSet.contains(a.RecordTypeId)) {
                   System.debug('**** Synching all contacts for Account \'' + a.Name + '\'');
                   acctIdSet.add(a.Id);
               }
        }
        
        //for all Contacts associated with affected Accounts, ensure that the owner ids match
        for(Contact[] cArray : [select Id, OwnerId, AccountId from Contact where AccountId in :acctIdSet]) {
            for(Contact c : cArray) {
                Account a = newAcctMap.get(c.AccountId);
                if(c.OwnerId != a.OwnerId) {
                    //if the owner ids do not match, set the Contact owner id to the Account owner id
                    c.OwnerId = a.OwnerId;
                    toUpdate.add(c);
                }
            }
        }
    }
    
    private void checkSpecFinOwnerChange(Map<Id,Account> oldAcctMap, Map<Id,Account> newAcctMap) {
        //if the current user does not have a flagged profile, no need to continue processing
        Map<Id,User> flaggedModifiersMap = new Map<Id,User> ( [
            SELECT  Id
            FROM    User
            WHERE   Id = :Userinfo.getUserId() AND
            Profile.Name IN :flaggedSpecFinProfiles
        ]);
        
        if(flaggedModifiersMap == null || flaggedModifiersMap.size() == 0) {
            return;
        }
        
        for(Account newAcct : newAcctMap.values()) {
            //if owner has changed and record has not yet been flagged, then flag record
            Account oldAcct = oldAcctMap.get(newAcct.id);
            if(oldAcct.OwnerId != newAcct.OwnerId && !newAcct.Send_Owner_Change_Notification__c) {
                newAcct.Send_Owner_Change_Notification__c = true;
            }
        }
    }
    
    /**
* When phone fields change on an Account, update the list of custom Phone objects to include
* the original phone number.
* @param oldAcctMap map of original state Accounts
* @param newAcctMap map of changed Accounts
*/
    private void updatePhoneListSfdc2(Map<Id,Account> oldAcctMap, Map<Id,Account> newAcctMap) {
        
        // Get original Account phone fields and related Phone objects
        List<Account> acctsWithPhones = [select id, Phone, PersonMobilePhone, PersonHomePhone, PersonOtherPhone, Fax, Business_Phone_SFDC2__pc, isPersonAccount,
                                         (select id, Account__c, Phone__c, Phone_Status__c, Phone_Type__c from Phones__r where 
                                          Account__c IN :oldAcctMap.keySet() ) from Account where id IN :oldAcctMap.keySet() and SFDC2__c = true];
        
        // Prepare collection of Phone objects to insert and delete 
        List<Phone_SFDC2__c> phonesToInsert = new List<Phone_SFDC2__c>();
        List<Phone_SFDC2__c> phonesToDelete = new List<Phone_SFDC2__c>();
        
        Boolean foundRecord = false;
        String currPhone = null;
        String newPhone = null;
        String phoneType = null;
        
        // Loop through Accounts and create Phone objects when phone fields have been updated
        for (Account acct : acctsWithPhones) {
            
            // Mark any Phone objects that are now a primary phone field value for deletion
            for (Phone_SFDC2__c phone : acct.Phones__r) {
                if (phone.Phone__c == newAcctMap.get(acct.id).Phone ||
                    phone.Phone__c == newAcctMap.get(acct.id).PersonMobilePhone ||
                    phone.Phone__c == newAcctMap.get(acct.id).PersonHomePhone ||
                    phone.Phone__c == newAcctMap.get(acct.id).PersonOtherPhone ||
                    phone.Phone__c == newAcctMap.get(acct.id).Fax ||
                    phone.Phone__c == newAcctMap.get(acct.id).Business_Phone_SFDC2__pc) {
                        if (Phone.Phone_Type__c.Substring (0,2) != 'JH') phonesToDelete.add(phone); 
                        continue;
                    }       
            }
            
            // Search each phone field for changes
            for (Integer i = 0; i<6; i++) {
                if (i==0) {currPhone = oldAcctMap.get(acct.id).Phone; newPhone = newAcctMap.get(acct.id).Phone; phoneType = 'Other Business';}
                if (i==1) {currPhone = oldAcctMap.get(acct.id).PersonMobilePhone; newPhone = newAcctMap.get(acct.id).PersonMobilePhone; phoneType = 'Other Mobile';}
                if (i==2) {currPhone = oldAcctMap.get(acct.id).PersonHomePhone; newPhone = newAcctMap.get(acct.id).PersonHomePhone; phoneType = 'Other Home';}
                if (i==3) {currPhone = oldAcctMap.get(acct.id).PersonOtherPhone; newPhone = newAcctMap.get(acct.id).PersonOtherPhone; phoneType = 'Other Home';}
                if (i==4) {currPhone = oldAcctMap.get(acct.id).Fax; newPhone = newAcctMap.get(acct.id).Fax; phoneType = 'Other Fax';}
                if (i==5) {currPhone = oldAcctMap.get(acct.id).Business_Phone_SFDC2__pc; newPhone = newAcctMap.get(acct.id).Business_Phone_SFDC2__pc; phoneType = 'Other Business';}
                
                // Find phone field values that have changed
                if (currPhone != newPhone && currPhone != null && currPhone != '') {
                    
                    // Make sure a Phone object does not already exist for this phone number
                    foundRecord = false;
                    for (Phone_SFDC2__c phone : acct.Phones__r) {
                        if (phone.Phone__c == currPhone) foundRecord = true;
                    }
                    
                    // Do not add a Phone object if a different Account phone field has the original phone number value
                    if (currPhone == newAcctMap.get(acct.id).Phone ||
                        currPhone == newAcctMap.get(acct.id).PersonMobilePhone ||
                        currPhone == newAcctMap.get(acct.id).PersonHomePhone ||
                        currPhone == newAcctMap.get(acct.id).PersonOtherPhone ||
                        currPhone == newAcctMap.get(acct.id).Fax ||
                        currPhone == newAcctMap.get(acct.id).Business_Phone_SFDC2__pc) foundRecord = true;
                    
                    // Create new Phone objects as necessary
                    if (!foundRecord) {
                        Phone_SFDC2__c phone = new Phone_SFDC2__c();
                        phone.Account__c = acct.Id;
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
* When email address fields on an Account change, update the related Emails list
* to include the original email address
* @param oldAcctMap map of original state Accounts
* @param newAcctMap map of changed Accounts
*/
    private void updateEmailListSfdc2(Map<Id,Account> oldAcctMap, Map<Id,Account> newAcctMap) {
        
        // Get original Account email fields and related Email objects
        List<Account> acctsWithEmails = [select id, PersonEmail, Business_Email_SFDC2__pc, Email__c, isPersonAccount, LastName,
                                         (select id, Account__c, Email__c, Email_Status__c, Email_Type__c from Email_Addresses__r where 
                                          Account__c IN :oldAcctMap.keySet() ) from Account where id IN :oldAcctMap.keySet() and SFDC2__c = true];
        
        // Prepare collection of Email objects to insert and delete 
        List<Email_SFDC2__c> emailsToInsert = new List<Email_SFDC2__c>();
        List<Email_SFDC2__c> emailsToDelete = new List<Email_SFDC2__c>();
        
        Boolean foundRecord = false;
        String currEmail = null;
        String newEmail = null;
        String emailType = null;
        
        // Loop through Accounts and create Email objects when email fields have been updated
        for (Account acct : acctsWithEmails) {
            
            // Mark any email addresses that are now in a primary field for deletion
            for (Email_SFDC2__c email : acct.Email_Addresses__r) {
                if (email.Email__c == newAcctMap.get(acct.id).PersonEmail ||
                    email.Email__c == newAcctMap.get(acct.id).Business_Email_SFDC2__pc ||
                    email.Email__c == newAcctMap.get(acct.id).Email__c) {
                        if (Email.Email_Type__c.Substring (0,2) != 'JH') emailsToDelete.add(email); 
                        continue;
                    }                       
            }
            
            // Search each email field for changes
            for (Integer i = 0; i<3; i++) {
                if (i<2 && !acct.isPersonAccount) continue;
                if (i==0) {currEmail = oldAcctMap.get(acct.id).PersonEmail; newEmail = newAcctMap.get(acct.id).PersonEmail; emailType = 'Other Personal';}
                if (i==1) {currEmail = oldAcctMap.get(acct.id).Business_Email_SFDC2__pc; newEmail = newAcctMap.get(acct.id).Business_Email_SFDC2__pc; emailType = 'Other Business';}
                if (i==2) {currEmail = oldAcctMap.get(acct.id).Email__c; newEmail = newAcctMap.get(acct.id).Email__c; emailType = 'Other Business';}
                
                System.debug('Current email: ' + currEmail + ', new email: ' + newEmail + ' LastName: ' + acct.LastName);
                
                // Find email field values that have changed
                if (currEmail != newEmail && currEmail != null && currEmail != '') {
                    
                    // Make sure a Email object does not already exist for this email address
                    foundRecord = false;
                    for (Email_SFDC2__c email : acct.Email_Addresses__r) {
                        if (email.Email__c == currEmail) foundRecord = true;
                    }
                    
                    // Do not add an Email object if a different Account email field has the original email address value
                    if (currEmail == newAcctMap.get(acct.id).PersonEmail ||
                        currEmail == newAcctMap.get(acct.id).Business_Email_SFDC2__pc ||
                        currEmail == newAcctMap.get(acct.id).Email__c) foundRecord = true;
                    
                    // Create new Email objects as necessary
                    if (!foundRecord) {
                        Email_SFDC2__c email = new Email_SFDC2__c();
                        email.Account__c = acct.Id;
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
    * SFDC 2.0: Requirement is to not allow updates to Account except by Admins and owners of
    * open Opportunities associated to SFDC2 Accounts
    */
    private void restrictSFDC2AccountUpdates() {
        Set<String> adminProfiles = new Set<String>{'System Administrator', 'API Service Account', 'Marketo Service Account'};
            Profile currUserProfile = [SELECT Name FROM Profile WHERE Id = :Userinfo.getProfileId()];
        //Adding IPL permission to Edit Accounts
        Set<String> researchRoles = new Set<String>{'Research_Manager_SFDC2','Researcher_SFDC2', 'IPL_Manager_SFDC2', 'IPL_SFDC2'};
            UserRole[] currUserRole = [SELECT DeveloperName FROM UserRole WHERE Id = :Userinfo.getUserRoleId()];
        System.debug(Userinfo.getName() + ' : ' + currUserProfile);
        Boolean isAdmin = null;
        
        If (currUserRole.size()>0) {
            isAdmin = adminProfiles.contains(currUserProfile.Name) || researchRoles.contains(currUserRole[0].DeveloperName);
        } else {
            isAdmin = adminProfiles.contains(currUserProfile.Name);
        }
		Boolean isFive9 = false;	
        Id cpaSFDC2 = [Select id from RecordType where DeveloperName = 'Consumer_Person_Account_SFDC2'].Id;
        Id baSFDC2 = [Select id from RecordType where DeveloperName = 'Business_Consumer_Person_Account'].Id;
        for(Account a : [SELECT Id, Name, Is_Converted__c, (SELECT OwnerId FROM Opportunities WHERE IsClosed = false), RecordTypeId  FROM Account WHERE SFDC2__c = true AND Id in : oldAcctMap.keySet()]) {
            System.debug(a.Name + ' : Opps=' + a.Opportunities.size());
           
            System.debug('RecordTypeId=' + a.RecordTypeId);
            if (a.RecordTypeId == cpaSFDC2 || a.RecordTypeId == baSFDC2) isFive9 = true; 
            Boolean invalidEdit = true;
            if(isAdmin) {
                invalidEdit = false;
            } else {
                if(a.Opportunities.size() > 0) {
                    for(Opportunity o : a.Opportunities) {
                        if(o.OwnerId == Userinfo.getUserId() || a.Is_Converted__c) {
                            invalidEdit = false;
                            break;
                        }
                    }
                }
                else if(a.Is_Converted__c){
                    invalidEdit = false;
                }
            }
            
            
            if(invalidEdit && !isFive9) {
                newAcctMap.get(a.Id).addError('Only system administrators and open Opportunity owners may edit this Account record');
            }
        }
    }
    
    
    /**
* When address fields on an Account change, update the Address related list to include
* the original address
* @param oldAcctMap map of original state Accounts
* @param newAcctMap map of changed Accounts
*/
    private void updateAddressListSfdc2(Map<Id,Account> oldAcctMap, Map<Id,Account> newAcctMap) {
        
        // Get original Account addresss fields and related Address objects
        List<Account> acctsWithAddresses = [select id, PersonMailingStreet, PersonMailingCity, PersonMailingCountry, PersonMailingState, PersonMailingPostalCode,
                                            Mailing_Loan_Type_SFDC2__pc, Mailing_Mortgage_Lender_SFDC2__pc, Mailing_Purchase_Amount_SFDC2__pc, Mailing_Purchase_Date_SFDC2__pc,
                                            BillingStreet, BillingCity, BillingCountry, BillingState, BillingPostalCode,
                                            Billing_Loan_Type_SFDC2__c, Billing_Mortgage_Lender_SFDC2__c, Billing_Purchase_Amount_SFDC2__c, Billing_Purchase_Date_SFDC2__c, isPersonAccount,
                                            (select id, Account__c, Street__c, City__c, Country__c,  State__c, Postal_Code__c, Address_Type__c,
                                             Mortgage_Lender__c, Loan_Type__c, Purchase_Date__c, Purchase_Amount__c from Addresses__r where 
                                             Account__c IN :oldAcctMap.keySet() ) from Account where id IN :oldAcctMap.keySet() and SFDC2__c = true];
        
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
        
        // Loop through Accounts and create Address objects when address fields have been updated
        for (Account acct : acctsWithAddresses) {
            
            // Mark any Address object that is now a primary field value for deletion
            for (Address_SFDC2__c address : acct.Addresses__r) {
                if ((address.Street__c == newAcctMap.get(acct.id).PersonMailingStreet && address.City__c == newAcctMap.get(acct.id).PersonMailingCity && address.Postal_Code__c == newAcctMap.get(acct.id).PersonMailingPostalCode
                     && address.Mortgage_Lender__c == newAcctMap.get(acct.id).Mailing_Mortgage_Lender_SFDC2__pc && address.Loan_Type__c == newAcctMap.get(acct.id).Mailing_Loan_Type_SFDC2__pc
                     && address.Purchase_Date__c == newAcctMap.get(acct.id).Mailing_Purchase_Date_SFDC2__pc && address.Purchase_Amount__c == newAcctMap.get(acct.id).Mailing_Purchase_Amount_SFDC2__pc) ||
                    (address.Street__c == newAcctMap.get(acct.id).BillingStreet && address.City__c == newAcctMap.get(acct.id).BillingCity && address.Postal_Code__c == newAcctMap.get(acct.id).BillingPostalCode
                     && address.Mortgage_Lender__c == newAcctMap.get(acct.id).Billing_Mortgage_Lender_SFDC2__c && address.Loan_Type__c == newAcctMap.get(acct.id).Billing_Loan_Type_SFDC2__c
                     && address.Purchase_Date__c == newAcctMap.get(acct.id).Billing_Purchase_Date_SFDC2__c && address.Purchase_Amount__c == newAcctMap.get(acct.id).Billing_Purchase_Amount_SFDC2__c)) {
                         if (address.Address_Type__c.Substring(0,2) != 'JH')  addressesToDelete.add(address); 
                         continue;
                     }               
            }
            
            // Search each address field for changes
            for (Integer i = 0; i<2; i++) {
                if (i==0) {
                    currStreet          = oldAcctMap.get(acct.id).PersonMailingStreet; 
                    currCity            = oldAcctMap.get(acct.id).PersonMailingCity; 
                    currCountry         = oldAcctMap.get(acct.id).PersonMailingCountry; 
                    currState           = oldAcctMap.get(acct.id).PersonMailingState; 
                    currPostalCode      = oldAcctMap.get(acct.id).PersonMailingPostalCode; 
                    currLender          = oldAcctMap.get(acct.id).Mailing_Mortgage_Lender_SFDC2__pc;
                    currLoanType        = oldAcctMap.get(acct.id).Mailing_Loan_Type_SFDC2__pc;
                    currPurchaseDate    = oldAcctMap.get(acct.id).Mailing_Purchase_Date_SFDC2__pc;
                    currPurchaseAmount  = oldAcctMap.get(acct.id).Mailing_Purchase_Amount_SFDC2__pc;
                    newStreet           = newAcctMap.get(acct.id).PersonMailingStreet; 
                    newCity             = newAcctMap.get(acct.id).PersonMailingCity; 
                    newCountry          = newAcctMap.get(acct.id).PersonMailingCountry; 
                    newState            = newAcctMap.get(acct.id).PersonMailingState; 
                    newPostalCode       = newAcctMap.get(acct.id).PersonMailingPostalCode; 
                    newLender           = newAcctMap.get(acct.id).Mailing_Mortgage_Lender_SFDC2__pc;
                    newLoanType         = newAcctMap.get(acct.id).Mailing_Loan_Type_SFDC2__pc;
                    newPurchaseDate     = newAcctMap.get(acct.id).Mailing_Purchase_Date_SFDC2__pc;
                    newPurchaseAmount   = newAcctMap.get(acct.id).Mailing_Purchase_Amount_SFDC2__pc;
                    addressType = 'Other';
                }
                if (i==1) {
                    currStreet          = oldAcctMap.get(acct.id).BillingStreet; 
                    currCity            = oldAcctMap.get(acct.id).BillingCity; 
                    currCountry         = oldAcctMap.get(acct.id).BillingCountry; 
                    currState           = oldAcctMap.get(acct.id).BillingState; 
                    currPostalCode      = oldAcctMap.get(acct.id).BillingPostalCode; 
                    currLender          = oldAcctMap.get(acct.id).Billing_Mortgage_Lender_SFDC2__c;
                    currLoanType        = oldAcctMap.get(acct.id).Billing_Loan_Type_SFDC2__c;
                    currPurchaseDate    = oldAcctMap.get(acct.id).Billing_Purchase_Date_SFDC2__c;
                    currPurchaseAmount  = oldAcctMap.get(acct.id).Billing_Purchase_Amount_SFDC2__c;
                    newStreet           = newAcctMap.get(acct.id).BillingStreet; 
                    newCity             = newAcctMap.get(acct.id).BillingCity; 
                    newCountry          = newAcctMap.get(acct.id).BillingCountry; 
                    newState            = newAcctMap.get(acct.id).BillingState; 
                    newPostalCode       = newAcctMap.get(acct.id).BillingPostalCode; 
                    newLender           = newAcctMap.get(acct.id).Billing_Mortgage_Lender_SFDC2__c;
                    newLoanType         = newAcctMap.get(acct.id).Billing_Loan_Type_SFDC2__c;
                    newPurchaseDate     = newAcctMap.get(acct.id).Billing_Purchase_Date_SFDC2__c;
                    newPurchaseAmount   = newAcctMap.get(acct.id).Billing_Purchase_Amount_SFDC2__c;
                    addressType = 'Other';
                }
                
                // Find address field values that have changed
                if ((currStreet != newStreet && currStreet != null && currStreet != '')
                    || (currCity != newCity && currCity != null && currCity != '')
                    || (currPostalCode != newPostalCode && currPostalCode != null && currPostalCode != '')) {
                        
                        // Make sure a Address object does not already exist for this address
                        foundRecord = false;
                        for (Address_SFDC2__c address : acct.Addresses__r) {
                            if (address.Street__c == currStreet && address.City__c == currCity && address.Postal_Code__c == currPostalCode
                                && address.Mortgage_Lender__c == currLender && address.Loan_Type__c == currLoanType
                                && address.Purchase_Date__c == currPurchaseDate && address.Purchase_Amount__c == currPurchaseAmount) foundRecord = true;
                        }
                        
                        // Do not add an Address object if a different Account address fields have the original address value
                        if ((currStreet == newAcctMap.get(acct.id).PersonMailingStreet && currCity == newAcctMap.get(acct.id).PersonMailingCity && currPostalCode == newAcctMap.get(acct.id).PersonMailingPostalCode
                             && currLender == newAcctMap.get(acct.id).Mailing_Mortgage_Lender_SFDC2__pc && currLoanType == newAcctMap.get(acct.id).Mailing_Loan_Type_SFDC2__pc
                             && currPurchaseDate == newAcctMap.get(acct.id).Mailing_Purchase_Date_SFDC2__pc && currPurchaseAmount == newAcctMap.get(acct.id).Mailing_Purchase_Amount_SFDC2__pc) ||
                            (currStreet == newAcctMap.get(acct.id).BillingStreet && currCity == newAcctMap.get(acct.id).BillingCity && currPostalCode == newAcctMap.get(acct.id).BillingPostalCode
                             && currLender == newAcctMap.get(acct.id).Billing_Mortgage_Lender_SFDC2__c && currLoanType == newAcctMap.get(acct.id).Billing_Loan_Type_SFDC2__c
                             && currPurchaseDate == newAcctMap.get(acct.id).Billing_Purchase_Date_SFDC2__c && currPurchaseAmount == newAcctMap.get(acct.id).Billing_Purchase_Amount_SFDC2__c)) foundRecord = true;
                        
                        // Create new Address objects as necessary
                        if (!foundRecord) {
                            Address_SFDC2__c address = new Address_SFDC2__c();
                            address.Account__c = acct.Id;
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
* Update SFDC2 checkbox based on the Account record type
* @param newAcctList List of Accounts with changes
*/
    public void updateSFDC2Checkbox(List<Account> newAcctList) {
        
        Id businessAccountId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account SFDC2').getRecordTypeId();
        Id hybridAccountId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business/Consumer Person Account').getRecordTypeId();
        Id consumerAccountId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer Person Account SFDC2').getRecordTypeId();
        Id prospectingBusinessAccountId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospecting Business').getRecordTypeId();
        Id prospectingHybridAccountId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospecting Business/Consumer PA').getRecordTypeId();
        Id prospectingConsumerAccountId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospecting Consumer PA').getRecordTypeId();
        
        for (Account account: newAcctList) {
            if (account.RecordTypeId == businessAccountId || account.RecordTypeId == hybridAccountId || account.RecordTypeId == consumerAccountId ||
                account.RecordTypeId == prospectingBusinessAccountId || account.RecordTypeId == prospectingHybridAccountId ||
                account.RecordTypeId == prospectingConsumerAccountId) {
                    account.SFDC2__c = true;
                } else {
                    account.SFDC2__c = false;
                }
        }
        
    }
    
    /**
This class creates child Financial Accounts to a person accounts.
*/
 /*   public void Contactpersonaccconv(List<Account> accList){
        
        Set<Id> setOfContIds = new Set<Id>();
        List<Financial_Account_Link_SFDC2__c> listOfFinancialAccounts = new List<Financial_Account_Link_SFDC2__c>();
        Map<String, String> mapofacccontIDs = new Map<String, String>();
        List<AccountContactRelation> listofaccconrel = new List<AccountContactRelation>();
        for(Account pa : accList){
            Id cId = Id.valueOf(pa.Name.substring(pa.Name.indexOf('_') + 1));
            setOfContIds.add(cId);
            mapofacccontIDs.put(cId, pa.Id);
        }
        
        for(Contact c : [SELECT Id, Name, AccountId, BirthDate, CleanStatus, Department,
                         DoNotCall, Email, Fax, LeadSource, MailingCity, MailingState, MailingCountry, MailingPostalCode, MailingStreet, Phone, Description,
                         (SELECT Name, CIF_JHA_Link__c, Financial_Account__c, Relationship__c
                          FROM Financial_Account_Contact_Links__r) , (SELECT AccountId,ContactId,Roles FROM AccountContactRelations)
                         FROM Contact WHERE Id IN :setOfContIds]){
                             for(Financial_Account_Contact_Link_SFDC2__c finAccCont : c.Financial_Account_Contact_Links__r){
                                 Financial_Account_Link_SFDC2__c finAcc = new Financial_Account_Link_SFDC2__c();
                                 finAcc.CIF_JHA_Link__c = finAccCont.CIF_JHA_Link__c;
                                 finAcc.Financial_Account__c = finAccCont.Financial_Account__c;
                                 finAcc.Relationship__c = finAccCont.Relationship__c;
                                 finAcc.Account__c = mapofacccontIDs.get(c.Id);
                                 listOfFinancialAccounts.add(finAcc); 
                             }
                             for(AccountContactRelation acr: c.AccountContactRelations) {
                                  AccountContactRelation Accconrel = new AccountContactRelation();
                                 Accconrel.AccountId = mapofacccontIDs.get(c.Id);
                                  Accconrel.ContactId = c.Id;
                                 listofaccconrel.add(Accconrel);
                                
                             }
                          
                         }
        
         Database.Insert(listOfFinancialAccounts);
         Database.Insert(listofaccconrel);
    }  */
    
    
    
}