/**
* @description <p>Handler class for OpportunityTrigger functionality</p>
* @author Mike Crosby, BofI Federal 
*/
public class OpportunityTriggerHandler extends TriggerHandler {
  /** Map of Opps before changes */
  private Map<Id, Opportunity> oldOppMap;
  /** Map of Opps with changes */
  private Map<Id, Opportunity> newOppMap;
  /** List of Opps before insert */
  private List<Opportunity> newOppList;

  /** Record Type ID for Consumer Deposits Opportunity */
  public static Id CD_OPP_RECORDTYPEID = '012i0000001AbiI';
  
  /** Profiles able to manually change Opportunity Stage */
  /*public static Set<String> stageChangeProfileSet = new Set<String>{'Consumer Deposits Management', 
                                                                    'System Administrator', 
                                                                    'API Service Account'};
  */
  
  /** 
  * Map of Consumer Deposits Sales Call Attempts values with corresponding Stages
  * (NOTE: key value must be lower case) 
  */
  public static Map<String, String> CD_MAP_SALESCALLSTAGES = 
      new Map<String, String>{
                              'bad phone number' => 'Closed - Sale Lost',
                              'attempt 1' => 'Open',
                              'attempt 2' => 'Open',
                              'attempt 3 - voicemail' => 'Open',
                              'attempt 4 - not contacted' => 'Closed - Sale Lost',
                              'contacted - sale won' => 'Sale Won',
                              'contacted - call back' => 'Open',
                              'contacted - not interested' => 'Closed - Sale Lost' 
                             };
  

  /** 
  * Map of Consumer Deposits Service Call Attempts values with corresponding Stages
  * (NOTE: key value must be lower case) 
  */
  public static Map<String, String> CD_MAP_SERVICECALLSTAGES = 
      new Map<String, String>{
                              'bad phone number' => 'Closed - Sale Lost',
                              'attempt 1' => 'Open',
                              'attempt 2' => 'Open',
                              'attempt 3 - voicemail' => 'Closed - Sale Lost',
                              'hang up' => 'Closed - Sale Lost',
                              'suspicious activity' => 'Closed - Sale Lost',
                              'contacted' => 'Closed - Service',
                              'contacted - call back' => 'Open',
                              'contacted - closing account' => 'Closed - Service',
                              'contacted - commit to fund' => 'Closed - Service',
                              'service call abandoned' => 'Closed - Sale Lost' 
                             };
  

  /** Constructor */
  public OpportunityTriggerHandler() {
    this.oldOppMap = (Map<Id, Opportunity>) Trigger.oldMap;
    this.newOppMap = (Map<Id, Opportunity>) Trigger.newMap;
    this.newOppList = (List<Opportunity>) Trigger.new;
  }
  
 /**
  * Process beforeUpdate logic
  */
  public override void beforeUpdate() {
      
    //checkConsumerDepositsStageChange(this.oldOppMap, this.newOppList);
    handleConsumerDepositsCallAttemptUpdate(this.oldOppMap, this.newOppList);
    //SFDC2
    reassignOppToQueue();
    //SFDC2
    auto30DayCrossSell();
     //SFDC2
    restrictOppOwner(this.oldOppMap, this.newOppList, UserInfo.getUserId());
      
  }
  
  /**
  * Process beforeInsert logic
  */
  public override void beforeInsert() {
    //C&I restriction to Account   
    restrictAssignOppC_ItoAccC_I( this.newOppList);
    
    handleConsumerDepositsCallAttemptUpdate(null, this.newOppList);
    //Ticket #68303
    handleSFRetailOriginatorAutoPop();
    //SFDC 2.0
    //handleContactToPersonAccountConvert();
  }
  
  /**
  * Process afterInsert logic
  */
  
    
    public override void afterInsert() {
    //SFDC 2.0
    handleOpportunityQueueAssignment();
  }
  
    //** SFDC2 Restrict Opportunity Owner change Validation **//
    
    public void restrictOppOwner(Map<Id, Opportunity> oldOppMap, List<Opportunity> newOppList, String userId){
    
        // Roles & Profiles
        Set<String> profiles = new Set<String> {'System Administrator','API Service Account','Enterprise User'};
      //
      /*
        Set<String> representatives = new Set<String>{'Financial Advisor Rep', 'C&I - EQF', 'C&I - Factoring', 'C&I - LF & CRESL','Consumer Deposits','Dealer Services Rep','Business Banking','Virtus Rep', 'HBD'};
        Set<String> managers = new Set<String>{'Research Manager', 'C&I Manager - EQF', 'C&I Manager - Factoring', ' C&I Manager - LF & CRESL' ,'Financial Advisor Mgr','Consumer Deposits Manager','Dealer Services Manager','Business Banking Manager','Virtus Manager', 'HBD Manager'};
        */
        Set<String> representatives = new Set<String> ();
        Set<String> managers = new Set<String> ();
        
        for(Manager_SFDC2__mdt  m : [select Manager_Role__c, None_Manager_Role__c from  Manager_SFDC2__mdt where Manager_Role__c != null]){
            managers.add(m.Manager_Role__c);
            representatives.add(m.None_Manager_Role__c);
        }     
            
        // Variable initialization
        List<Opportunity> listOfOppChangeOwnr = new List<Opportunity>();
        List<Opportunity_Queue__c> listOfOppQueues = new List<Opportunity_Queue__c>();
        Map<String, Opportunity_Queue__c> oppQueMap = new Map<String, Opportunity_Queue__c>();
        List<String> oppIds = new List<String>();
        Boolean noPermission = false;
        
        User usr = [SELECT Profile.Name, UserRole.Name FROM User WHERE Id = :userId];
        User apiserv = [SELECT Id FROM User WHERE Profile.Name = 'API Service Account' Limit 1];
      //  Id apiserv = [SELECT Id FROM User WHERE Profile.Name = 'API Service Account'].Id;
        // Identify records is pertaining to change owner
        System.debug('newOppList'+newOppList);
        for(Opportunity opp : newOppList){
            if(opp.OwnerId != oldOppMap.get(opp.Id).OwnerId && opp.SFDC2__c){
                listOfOppChangeOwnr.add(opp);
                oppIds.add(opp.Id);
            }
        }
        
        // query Opportunities that are sent for referal 
        for(Opportunity_Queue__c oppQue : [SELECT Opportunity__c, OwnerId FROM Opportunity_Queue__c WHERE Opportunity__c IN :oppIds]){
            oppQueMap.put(oppQue.Opportunity__c, oppQue);
        }
        
        for(Opportunity opp : listOfOppChangeOwnr){
            String oppOldOwnerId = oldOppMap.get(opp.Id).OwnerId;
            //Id oppOldOwnerId = oldOppMap.get(opp.Id).OwnerId;
            if(!profiles.contains(usr.Profile.Name)){
                noPermission = true;
            }
            if(oppQueMap.get(opp.id) != Null && String.valueOf(oppQueMap.get(opp.Id).OwnerId).startsWith('00G') && oppOldOwnerId == apiserv.Id){
                if(representatives.contains(usr.UserRole.Name)){
                    if(usr.Id != opp.OwnerId)
                        noPermission = true;
                }
            }else {
                //if(!managers.contains(usr.UserRole.Name) && representatives.contains(usr.UserRole.Name) && usr.Id != opp.OwnerId && oppOldOwnerId != apiserv.Id)
                if(!managers.contains(usr.UserRole.Name) && representatives.contains(usr.UserRole.Name) && oppOldOwnerId != apiserv.Id)
                    noPermission = true;
            }
            //Boolean OppQueCheck = oppQueMap.get(opp.Id) != NULL ? String.valueOf(oppQueMap.get(opp.Id).OwnerId).startsWith('00G') : FALSE;
            //System.debug('OppQuemap'+String.valueOf(oppQueMap.get(opp.Id).OwnerId));
            
            if(opp.OwnerId == apiserv.Id) {
               // if(String.valueOf(usr.Id).startsWith('005') && representatives.contains(usr.UserRole.Name) && usr.Id != opp.OwnerId)
                 //   noPermission = true;
                //else
                    noPermission = false;   
            }
            
            if(noPermission)
                opp.addError('Dont have permission to change owner.');
        }
    }
    
  /**
  * Specialty Finance: Auto-populate Originator field for Retail opps if blank upon creation
  */
  private void handleSFRetailOriginatorAutoPop() {
    Map<Id, RecordType> sfRetailRT = new Map<Id, RecordType>([SELECT Id FROM RecordType WHERE SObjectType = 'Opportunity' AND Name like 'Specialty Finance - Retail%' AND IsActive = true]);
    Id origRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Specialty Finance - Originator').getRecordTypeId();
    Account[] annuitantAcct = [SELECT Id FROM Account WHERE Name = 'Annuitants Federal Bank' AND RecordTypeId = :origRTId];
    
    if(sfRetailRT.size() > 0 && annuitantAcct.size() > 0) {
      for(Opportunity o : newOppList) {
          if(sfRetailRT.get(o.RecordTypeId) != null &&
              o.Originator__c == null) {
            o.Originator__c = annuitantAcct[0].Id;
          }
      }
    }
  }
  
  /**
  * Handles Consumer Deposits requirement that only CD management and Sys Admins
  * can manually update Stage
  * @param oldMap map of pre-update values
  * @param newList list of post-update values
  */
  /*private void checkConsumerDepositsStageChange(Map<Id, Opportunity> oldMap, List<Opportunity> newList) {
    Profile p = [SELECT Name FROM Profile WHERE Id = :Userinfo.getProfileId()][0];
    
    for(Opportunity newOpp : newList) {
      if(newOpp.RecordTypeId == OpportunityTriggerHandler.CD_OPP_RECORDTYPEID) {
        
          Opportunity oldOpp = oldMap.get(newOpp.Id);
          if(oldOpp.StageName != newOpp.StageName &&
             !stageChangeProfileSet.contains(p.Name) &&
             !newOpp.CD_WF_StageChange__c) {
            newOpp.addError(' Consumer Deposits: You do not have proper permissions to manually change the Opportunity Stage. ' +
                'Please contact your manager for assistance.');
          }
          newOpp.CD_WF_StageChange__c = false;
      }
    }
  }*/
  
  /**
  * SFDC 2.0: When a Virtus/Business Banking Opportunity has the Cross-Sell tickbox checked, 
  * determine if cross-sell opportunity should be created and do so
  */
  private void auto30DayCrossSell() {
    Id virtusRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Virtus SFDC2').getRecordTypeId();
    Id bbRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Business Banking SFDC2').getRecordTypeId();
    
    //locate accounts associated with triggered opps for further inspection
    Map<Id, Set<Id>> acctIdsToLookup = new Map<Id, Set<Id>>();
    for(Opportunity o : newOppList) {
        if(o.Cross_Sell_SFDC2__c &&
            (
              o.RecordTypeId == virtusRTId ||
              o.RecordTypeId == bbRTId
            )
          ) {
          if(!acctIdsToLookup.containsKey(o.AccountId)) {
            acctIdsToLookup.put(o.AccountId, new Set<Id>());
          }
          acctIdsToLookup.get(o.AccountId).add(o.RecordTypeId);
          //reset tickbox trigger field
          o.Cross_Sell_SFDC2__c = false;    
        }
    }
    
    //if the account does not have any open opps or any opps with a stage between 2 - 7, then
    //the account should have a cross-sell opportunity created
    List<Account> acctCrossSellList = new List<Account>();
    for(Account a : [SELECT 
                        Id,
                        (SELECT
                            Financial_Account_Balance__c
                         FROM
                            Financial_Account_Contact_Links__pr
                         WHERE
                            Financial_Account_Balance__c >= 50000
                        ),
                        (SELECT 
                            Current_Balance__c 
                         FROM 
                            Financial_Account_Links__r 
                         WHERE 
                            Current_Balance__c >= 50000),
                        (SELECT 
                            Id
                         FROM 
                            Opportunities 
                         WHERE 
                            IsClosed = false AND 
                            StageName != '1 - New'
                         )
                      FROM
                        Account
                      WHERE
                        Id in :acctIdsToLookup.keySet()
                         ]) {
        if(a.Opportunities.size() == 0) {
            //create cross-sell opp
            acctCrossSellList.add(a);
        }
    }
    
    List<String> createBBCrossSellList = new List<String>();
    List<String> createVirtusCrossSellList = new List<String>();
    List<String> createCDCrossSellList = new List<String>();
    for(Account a : acctCrossSellList) {
        for(Id rId : acctIdsToLookup.get(a.Id)) {
            if(rId == virtusRTId) {
                createBBCrossSellList.add(a.Id);
            } else if (rId == bbRTId) {
                if(a.Financial_Account_Contact_Links__pr.size() > 0 || a.Financial_Account_Links__r.size() > 0) {
                    createVirtusCrossSellList.add(a.Id);
                } else {
                    createCDCrossSellList.add(a.Id);
                }
            }
        }
    }
    if(createBBCrossSellList.size() > 0) {
        createBBCrossSell(createBBCrossSellList);
    }
    if(createVirtusCrossSellList.size() > 0) {
        createVirtusCrossSell(createVirtusCrossSellList);
    }
    if(createCDCrossSellList.size() > 0) {
        createCDCrossSell(createCDCrossSellList);
    }
  }
  
  /**
  * SFDC 2.0: Future method to handle creation of Business Banking cross-sell opps
  * @param idList list of account ids to create opportunities for
  */
  @future
  private static void createBBCrossSell(List<String> idList) {
    List<Opportunity> newOpps = new List<Opportunity>();
    for(String id : idList) {
        Opportunity o = new Opportunity();
        o.AccountId = id;
        o.StageName = '1 - New';
        o.Name = 'Cross-Sell from Virtus';
        o.CloseDate = Date.today().addDays(30);
        o.LeadSource = 'Cross-Sell';
        o.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Business Banking SFDC2').getRecordTypeId();
        o.OwnerId = UserTriggerHandler.APIAccountId;
        o.Opportunity_Queue__c = true;
        newOpps.add(o);
    }
    
    if(newOpps.size() > 0) {
        insert newOpps;
    }
  }
  
  /**
  * SFDC 2.0: Future method to handle creation of Virtus cross-sell opps
  * @param idList list of account ids to create opportunities for
  */
  @future
  private static void createVirtusCrossSell(List<String> idList) {
    List<Opportunity> newOpps = new List<Opportunity>();
    for(String id : idList) {
        Opportunity o = new Opportunity();
        o.AccountId = id;
        o.StageName = '1 - New';
        o.Name = 'Cross-Sell from Business Banking';
        o.CloseDate = Date.today().addDays(30);
        o.LeadSource = 'Cross-Sell';
        o.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Virtus SFDC2').getRecordTypeId();
        o.OwnerId = UserTriggerHandler.APIAccountId;
        o.Opportunity_Queue__c = true;
        newOpps.add(o);
    }
    
    if(newOpps.size() > 0) {
        insert newOpps;
    }
  }
  
  /**
  * SFDC 2.0: Future method to handle creation of Consumer Deposits cross-sell opps
  * @param idList list of account ids to create opportunities for
  */
  @future
  private static void createCDCrossSell(List<String> idList) {
    List<Opportunity> newOpps = new List<Opportunity>();
    for(String id : idList) {
        Opportunity o = new Opportunity();
        o.AccountId = id;
        o.StageName = '1 - New';
        o.Name = 'Cross-Sell from Business Banking';
        o.CloseDate = Date.today().addDays(30);
        o.LeadSource = 'Cross-Sell';
        o.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Consumer Deposits SFDC2').getRecordTypeId();
        o.OwnerId = UserTriggerHandler.APIAccountId;
        o.Opportunity_Queue__c = true;
        newOpps.add(o);
    }
    
    if(newOpps.size() > 0) {
        insert newOpps;
    }
  }
  
  /**
  * SFDC 2.0: When an Opportunity has Reassign To Queue ticked, reassign record to API Service Account
  * and create a new Opportunity Queue record with ownership assigned to business unit
  * corresponding to owner's role
  */
  private void reassignOppToQueue() {
    for(Opportunity o : newOppList) {
        //determine if the Opp is owned by a user who is a member of a role corresponding
        //to a business opp queue
        if(o.Reassign_To_Queue_SFDC2__c &&
            o.Owner_Role_SFDC2__c != null &&
            o.Owner_Role_SFDC2__c != '') {
            String queueName = UserTriggerHandler.roleOppQueueMap.get(o.Owner_Role_SFDC2__c);
            if(queueName != null) {
                for(Group queue : UserTriggerHandler.queueMap.values()) {
                    if(queue.DeveloperName == queueName) {
                        //l.OwnerId = queue.Id;
                        o.OwnerId = UserTriggerHandler.APIAccountId;
                        o.Opportunity_Queue__c = true;
                        Opportunity_Queue__c oq = new Opportunity_Queue__c();
                        oq.Opportunity__c = o.Id;
                        oq.OwnerId = queue.Id;
                        toInsert.add(oq);
                        break;
                    }
                }
            }
        }
        //reset checkbox field
        o.Reassign_To_Queue_SFDC2__c = false;
    }
  }
  
  /**
  * Handles Consumer Deposits requirement that the Opportunity Stage value
  * is updated based on the Sales Call Attempts field and Service Call Attempts
  * field
  * @param oldMap map of pre-update values
  * @param newList list of post-update values
  */
  private void handleConsumerDepositsCallAttemptUpdate(Map<Id, Opportunity> oldMap, List<Opportunity> newList) {
    for(Opportunity newOpp : newList) {
      //only process Consumer Deposits opportunities
      if(newOpp.RecordTypeId == OpportunityTriggerHandler.CD_OPP_RECORDTYPEID) {
      
          Opportunity oldOpp = new Opportunity();
          
          if(oldMap != null) {
             oldOpp = oldMap.get(newOpp.Id);
          }
          
          //first check to see if Sales Call Attempts changed
          if(oldOpp.Sales_Call_Attempts__c != newOpp.Sales_Call_Attempts__c && newOpp.Sales_Call_Attempts__c != null) {
            String newStage = OpportunityTriggerHandler.CD_MAP_SALESCALLSTAGES.get(newOpp.Sales_Call_Attempts__c.toLowerCase());
            if(newStage != null) {
                newOpp.StageName = newStage;
            }
          }
          //if Sales did not update attempt, check to see if Service Call Attempts changed
          else if (oldOpp.Service_Call_Attempts__c != newOpp.Service_Call_Attempts__c && newOpp.Service_Call_Attempts__c != null) {
            String newStage = OpportunityTriggerHandler.CD_MAP_SERVICECALLSTAGES.get(newOpp.Service_Call_Attempts__c.toLowerCase());
            if(newStage != null) {
               newOpp.StageName = newStage;
            }
          }
      }
    }
  }
  
  
  /**
  * SFDC 2.0: Requirement is to assign new RMI Opportunities not converted from Leads to a custom queue
  */
    private void handleOpportunityQueueAssignment() {
        System.debug('handleOpportunityQueueAssignment');
        Set<String> leadSources = new Set<String>{'RMI','Cross-Sell','Application'};
            
            for(Opportunity o : newOppMap.values()) {
                System.debug(o.LeadSource);
                System.debug(leadSources.contains(o.LeadSource));
                System.debug(o.Created_From_Lead__c);
                if(leadSources.contains(o.LeadSource) && !o.Created_From_Lead__c) {                    
                    Opportunity_Queue__c oq = new Opportunity_Queue__c();
                    oq.Opportunity__c = o.Id;                    
                    toInsert.add(oq);                  
                }
            }
    }
  
  /**
  * SFDC 2.0: Requirement is to convert Contact associated with Consumer Deposits and Virtus
  * Opportunities to a Person Account upon opportunity creation
  */
 /* private void handleContactToPersonAccountConvert() {
    System.debug('**** Checking Contact to Person Account Conversation beforeInsert');

    Id personAccountRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business/Consumer Person Account').getRecordTypeId();
    Id consumerDepRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Consumer Deposits SFDC2').getRecordTypeId();
    Id virtusRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Virtus SFDC2').getRecordTypeId();
    Set<Id> checkIds = new Set<Id>{personAccountRTId, consumerDepRTId, virtusRTId};

    Set<Id> contactsToConvert = new Set<Id>();
    for(Opportunity o : newOppList) {
        if(checkIds.contains(o.RecordTypeId) && o.Contact__c != null && o.AccountId != null) {
            System.debug('Adding contact to convert');
            contactsToConvert.add(o.Contact__c);
        }
    }
    System.debug('**** contactsToConvert.size()=' + contactsToConvert.size());
    if(contactsToConvert.size() > 0) {
        Map<Id,Account> convertedContactMap = convertContactsToPersonAccounts(contactsToConvert, personAccountRTId);
        if(convertedContactMap.size() > 0) {
            List<Account> acctsToInsert = convertedContactMap.values();

            for(Account acct : [SELECT PersonContactId FROM Account WHERE Id in :acctsToInsert]) {
                for(Opportunity o : newOppList) {
                    if(o.Contact__c == acct.PersonContactId) {
                        o.AccountId = acct.Id;
                        o.Contact__c = null;
                    }
                }
            }
        }
    }
  }
  */
  /**
  * SFDC 2.0: Converts a list of Contacts to Person Accounts of the record type specified
  * @param acctContacts map where key = Account Id and value = Contact Id
  * @param rtId Person Account record type to be converted to
  * @returns map of converted Person Accounts with key of original Contact Id
  */
 /* public static Map<Id,Account> convertContactsToPersonAccounts(Set<Id> acctContacts, Id rtId) {
    Map<Id,Account> returnMap = new Map<Id,Account>();
    
    //first step is to create initial Account for each Contact
    List<Account> acctsToInsert = new List<Account>();
    Map<Id,Contact> contactsToConvert = new Map<Id, Contact>([SELECT AccountId, Account.Name, OwnerId, CIF_SFDC2__c FROM Contact WHERE Id in :acctContacts]); 
    for(Id cId : contactsToConvert.keySet()) {
        acctsToInsert.add(new Account(Name='Convert_' + cId, OwnerId = contactsToConvert.get(cId).OwnerId, CIF_SFDC2__c = contactsToConvert.get(cId).CIF_SFDC2__c));
    }
    insert acctsToInsert;
    
    //next step to associate Contacts with new Accounts
    List<Contact> contactsToUpdate = new List<Contact>();
    List<Account> accountsToUpdate = new List<Account>();
    for(Account acct : [SELECT Name, OwnerId FROM Account WHERE Id in :acctsToInsert]) {
        Id cId = Id.valueOf(acct.Name.substring(acct.Name.indexOf('_') + 1));
        contactsToUpdate.add(new Contact(Id=cId,AccountId=acct.Id, OwnerId = acct.OwnerId, Employer_SFDC2__c = contactsToConvert.get(cId).Account.Name, Trigger_Conversion_SFDC2__c = false));
               Account acctToUpdate = new Account(Id=acct.Id, RecordTypeId=rtId);
        accountsToUpdate.add(acctToUpdate);
        returnMap.put(cId, acctToUpdate);
    }
    update contactsToUpdate;
    
      
    //final step is to change the record type for the Account
    update accountsToUpdate;
    
    return returnMap;
  } */
    
    //** SFDC2 C&I  Any user outside the C&I BU cannot create an Opportunity on an account 
    //if on that same account an Opportunity with C&I record type already exists in Stage 2-7**//
    
    public void restrictAssignOppC_ItoAccC_I( List<Opportunity> newOppList){

        // C&I Opportunities developerName RecordTypes 
        Set<String> CI_RecordType = new Set<String> {'CRESL_SFDC2','EQF_SFDC2','Factoring_SFDC2','NRELF_SFDC2' ,'RELF_SFDC2', 'IPL_SFDC2'};
            
            for(Opportunity opp: newOppList){
                List<Opportunity> oppCI = [select id, StageName, RecordType.DeveloperName from Opportunity where accountID =: opp.accountID ];
                boolean referral = false;
                if(opp.Name.contains('Referral')) referral = true;
                String devNameRTOpp = [Select DeveloperName from RecordType where id =: opp.RecordTypeId].DeveloperName;
                if(oppCI.size() > 0 ){
                    for(Opportunity oppAcc : oppCI){
                        //SFDC2 validation 
                        if((CI_RecordType.contains(oppAcc.RecordType.DeveloperName) && !CI_RecordType.contains(devNameRTOpp) 
                           && (oppAcc.StageName <> '0 - Closed - Lost' || oppAcc.StageName <> '1 - New' || oppAcc.StageName <> '8 - Boarded/Funded/Won') ) && !referral){                             
                            opp.addError('You only can Associated C&I Opportunity at this Account ');                            
                        }
                        
                    }
                    
                }
                            
            }    
                
    }
           
}