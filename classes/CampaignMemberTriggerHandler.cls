/**
* @description <p>Handler class for CampaignMemberTrigger functionality</p>
* @author Mike Crosby, BofI Federal 
*/
public class CampaignMemberTriggerHandler extends TriggerHandler {

	/** Map of Campaign Members before changes */
	private Map<Id, CampaignMember> oldMap;
	/** Map of Campaign Members with changes */
	private Map<Id, CampaignMember> newMap;
  
	/** Constructor */
    public CampaignMemberTriggerHandler() {
        this.oldMap = (Map<Id, CampaignMember>) Trigger.oldMap;
        this.newMap = (Map<Id, CampaignMember>) Trigger.newMap;
    }

	/**
	* Process afterInsert logic
	*/
	public override void afterInsert() {
		//SFDC2
		handlePrimaryCampaignLeadPopulation();
	}

    /**
	* Process afterUpdate logic
	*/
    public override void afterUpdate() {
		TrackSpecialtyFinanceEmailStatus();
        //User u = [Select Id From User where Name = 'Jonathan London' and UserRole.Name = 'Consumer Deposits Manager'] ;
        //SFDC2
		//If (u.Id != UserInfo.getUserId())
		handleExpiredContactedMembers();
    }
    
    /**
    * SFDC2: When a Lead is added as a campaign member, populate the Primary Campaign field if
    * not already populated
    */
    private void handlePrimaryCampaignLeadPopulation() {
    	Map<Id,Id> leadCampaignIdMap = new Map<Id,Id>();
    	for(CampaignMember m : newMap.values()) {
    		if(m.LeadId != null) {
    			leadCampaignIdMap.put(m.LeadId, m.CampaignId);
    		}
    	}
    	if(leadCampaignIdMap.size() > 0) {
    		for(Lead l : [SELECT Primary_Campaign_SFDC2__c FROM Lead WHERE SFDC2__c = true AND Primary_Campaign_SFDC2__c = '' AND Id in :leadCampaignIdMap.keySet()]) {
   				toUpdate.add(new Lead(Id=l.Id, Primary_Campaign_SFDC2__c=leadCampaignIdMap.get(l.Id)));
    		}
    	}
    }
    
    /**
    * SFDC2: For Expired or Contacted campaign members, delete member from Campaign
    */
    private void handleExpiredContactedMembers() {
    	Map<Id,List<CampaignMember>> contactMemberMap = new Map<Id,List<CampaignMember>>();
    	Map<Id,List<CampaignMember>> campaignMemberMap = new Map<Id,List<CampaignMember>>();
        Id idUsrJL = [SELECT Id FROM User WHERE Name = 'Jonathan London'].Id;
        Map<Id,Campaign> campaignMap = new Map<Id,Campaign>([Select Id From Campaign Where CreatedById =:idUsrJL]);
    	for(CampaignMember m : newMap.values()) {
            if( !campaignMap.containsKey(m.CampaignId) &&  m.ContactId != null &&
    		   (m.Status == 'Expired' || m.Status == 'Contacted')
    		   ) {                                                 
    		   	if(!contactMemberMap.containsKey(m.ContactId)) {
    		   		contactMemberMap.put(m.ContactId, new List<CampaignMember>());
    		   	}
    		   	if(!campaignMemberMap.containsKey(m.CampaignId)) {
    		   		campaignMemberMap.put(m.CampaignId, new List<CampaignMember>());
    		   	}
    			contactMemberMap.get(m.ContactId).add(m);
    			campaignMemberMap.get(m.CampaignId).add(m);
    		}
    	}
       
        System.debug('campaignMemberMap' +campaignMemberMap);
    	Set<Id> financialIdSet = new Set<Id>();
    	//map of SFDC2 contact ids with their associated financial account ids
    	Map<Id,List<Id>> contactFinMap = new Map<Id,List<Id>>();
    	for(Contact c : [SELECT Id, (SELECT Id, Financial_Account__c FROM Financial_Account_Contact_Links__r) FROM Contact WHERE Id in :contactMemberMap.keySet() AND Account.SFDC2__c = true]) {
    		toDelete.addAll((List<Sobject>)contactMemberMap.get(c.Id));
    		contactFinMap.put(c.Id, new List<Id>());
    		for(Financial_Account_Contact_Link_SFDC2__c link : c.Financial_Account_Contact_Links__r) {
    			contactFinMap.get(c.Id).add(link.Financial_Account__c);
    			financialIdSet.add(link.Financial_Account__c);
    		}
    	}
    	for(Financial_Account_Campaign_Link_SFDC2__c link : [SELECT Campaign__c, Campaign__r.Name, Financial_Account__c FROM Financial_Account_Campaign_Link_SFDC2__c WHERE Campaign__c in :campaignMemberMap.keySet() AND Financial_Account__c in :financialIdSet]) {
    		toDelete.add(link);
    		for(CampaignMember member : campaignMemberMap.get(link.Campaign__c)) {
    			for(Id finId : contactFinMap.get(member.ContactId)) {
    				if(link.Financial_Account__c == finId) {
    					Task t = new Task();
						t.Subject = link.Campaign__r.Name;
						t.Type = 'Campaign Member Status: ' + member.Status;
						t.Status = 'Completed';
						t.WhatId = finId;
						t.OwnerId = UserTriggerHandler.APIAccountId;
						t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Standard Task').getRecordTypeId();
						toInsert.add(t);
    				}
    			}
    		}
    	}
    }
    
    /**
     * Specialty Finance - SF Sprint 3 [8.22 - 9.2]
     * Based on changes to Activity field, the Email Status field on the Account should be updated
     */
    private void TrackSpecialtyFinanceEmailStatus() {
        Set<Id> sfRecordTypeIdSet = new Set<Id>();
        for(RecordType rt : [SELECT Id FROM RecordType WHERE DeveloperName LIKE 'Specialty_Finance%' AND IsActive = true AND (IsPersonType = true OR SObjectType = 'Contact')]) {
            sfRecordTypeIdSet.add(rt.Id);
        }
        Map<Id, Account> acctsToUpdate = new Map<Id, Account>();
        for(CampaignMember m : newMap.values()) {
            //only concerned about Campaign Members that are Contacts
            if(m.ContactId != null) {
                CampaignMember om = oldMap.get(m.Id);
                //only concerned about changing status to a non-null/blank value
				if(m.et4ae5__Activity__c != om.et4ae5__Activity__c &&
                  	!(m.et4ae5__Activity__c == '' || m.et4ae5__Activity__c == null)) {
                    Account a = new Account(Recent_Email_Status_Specialty_Finance__c=m.et4ae5__Activity__c);
                    if (m.et4ae5__Activity__c == 'Bounced') {
                        a.Email_Bounced_Specialty_Finance__c=true;
                    }
                    acctstoUpdate.put(m.ContactId, a);
                }
            }
        }
        
        if(acctsToUpdate.size() > 0) {
            for(Contact c : [SELECT AccountId FROM Contact WHERE Id in :acctsToUpdate.keySet() AND Account.RecordTypeId in :sfRecordTypeIdSet]) {
                Account a = acctsToUpdate.get(c.Id);
                a.Id = c.AccountId;
                toUpdate.add(a);
            }
        }
    }
}