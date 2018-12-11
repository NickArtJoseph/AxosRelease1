public class CampaignMemberAutomationHandler {
    //list of campaign names used in automation
    public static List<String> campaignNames = new List<String>{
    														'30 Day CD Maturity',
    														'30 Day No Signature Card',
    														'45 Day No Signature Card',
    														'10 Day Unfunded Accounts',
    														'30 Day Unfunded Accounts',
    														'45 Day Unfunded Accounts',
    														'10 Day Zero Balance',
    														'30 Day Zero Balance',
    														'45 Day Zero Balance',
    														'Consumer Deposits Welcome List'
    													};
    
    //map of id/campaign for campaigns used in automation
    static Id cRTID = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Service Campaign').getRecordTypeId();
    static Map<Id, Campaign> campaignRecordMap = new Map<Id, Campaign>([SELECT Id, Name FROM Campaign WHERE Name in :campaignNames AND RecordTypeId = :cRTID]);
    
    /**
    * For the supplied Financial Account Contact Link records, determines whether criteria
    * are met to automatically add a Contact to a campaign controlled by this automation or
    * change the status of an existing campaign member
    * @param linkIds list of Financial Account Contact Link records to check
    */
    @future
    public static void handleCampaignMemberAutomation(List<String> linkIds) {
    	//create a map of Contacts and their associated financial account links
    	
    	//first, locate all financial account links for each contact
    	Set<Id> initialContactIds = new Set<Id>();
    	for(Financial_Account_Contact_Link_SFDC2__c link : [SELECT Contact__c FROM Financial_Account_Contact_Link_SFDC2__c WHERE Id IN : linkIds]) {
    		initialContactIds.add(link.Contact__c);
    	}
    	
    	Map<Id, List<Financial_Account_Contact_Link_SFDC2__c>> contactFinAcctLinks = new Map<Id, List<Financial_Account_Contact_Link_SFDC2__c>>();
        for(Financial_Account_Contact_Link_SFDC2__c link : [
                                                            SELECT
                                                                Id,
                                                                Contact__c,
                                                                Contact__r.DoNotCall,
                                                                Financial_Account__c,
                                                                Financial_Account__r.Status__c,
                                                                Financial_Account__r.Product_Class__c,
                                                                Financial_Account__r.Maturity_Date__c,
                                                                Financial_Account__r.Department__c,
                                                                Financial_Account__r.Open_Date__c,
                                                                Financial_Account__r.Signature_Card_Received__c,
                                                                Financial_Account__r.Funding_Date__c,
                                                                Financial_Account__r.Zero_Balance_Flag__c,
                                                                Financial_Account__r.Zero_Balance_Date__c
                                                            FROM
                                                                Financial_Account_Contact_Link_SFDC2__c
                                                            WHERE
                                                                Contact__c in :initialContactIds]) {
            if(!contactFinAcctLinks.containsKey(link.Contact__c)) {
            	contactFinAcctLinks.put(link.Contact__c, new List<Financial_Account_Contact_Link_SFDC2__c>());
            }
            contactFinAcctLinks.get(link.Contact__c).add(link);
        }
    	
    	List<CampaignMember> toUpsert = new List<CampaignMember>();
            
        Map<Id, Map<String, Set<Id>>> x30DayCDMaturityMap = determineCampaignEligibility('30 Day CD Maturity', contactFinAcctLinks);
        Map<Id, Map<String, Set<Id>>> x30DayNoSigMap = determineCampaignEligibility('30 Day No Signature Card', contactFinAcctLinks);
        Map<Id, Map<String, Set<Id>>> x45DayNoSigMap = determineCampaignEligibility('45 Day No Signature Card', contactFinAcctLinks);
        Map<Id, Map<String, Set<Id>>> x10DayUnfundedMap = determineCampaignEligibility('10 Day Unfunded Accounts', contactFinAcctLinks);
        Map<Id, Map<String, Set<Id>>> x30DayUnfundedMap = determineCampaignEligibility('30 Day Unfunded Accounts', contactFinAcctLinks);
        Map<Id, Map<String, Set<Id>>> x45DayUnfundedMap = determineCampaignEligibility('45 Day Unfunded Accounts', contactFinAcctLinks);
        Map<Id, Map<String, Set<Id>>> x10DayZeroMap = determineCampaignEligibility('10 Day Zero Balance', contactFinAcctLinks);
        Map<Id, Map<String, Set<Id>>> x30DayZeroMap = determineCampaignEligibility('30 Day Zero Balance', contactFinAcctLinks);
        Map<Id, Map<String, Set<Id>>> x45DayZeroMap = determineCampaignEligibility('45 Day Zero Balance', contactFinAcctLinks);
        Map<Id, Map<String, Set<Id>>> xWelcomeListMap = determineCampaignEligibility('Consumer Deposits Welcome List', contactFinAcctLinks);
        Map<Id, Map<String, Set<Id>>> fullMap = new Map<Id, Map<String, Set<Id>>>();
        fullMap.putAll(x30DayCDMaturityMap);
        fullMap.putAll(x30DayNoSigMap);
        fullMap.putAll(x45DayNoSigMap);
        fullMap.putAll(x10DayUnfundedMap);
        fullMap.putAll(x30DayUnfundedMap);
        fullMap.putAll(x45DayUnfundedMap);
        fullMap.putAll(x10DayZeroMap);
        fullMap.putAll(x30DayZeroMap);
        fullMap.putAll(x45DayZeroMap);
        fullMap.putAll(xWelcomeListMap);
        Set<Id> contactIdsToVerify = new Set<Id>();
        Set<Id> existingMembersId = new Set<Id>();
        for(Map<String, Set<Id>> campaignMemberElig : fullMap.values()) {
        	for(Set<Id> idSet : campaignMemberElig.values()) {
        		contactIdsToVerify.addAll(idSet);
        	}
        }
        
        for(CampaignMember cm : [SELECT Id, CampaignId, ContactId, Status FROM CampaignMember WHERE CampaignId in :fullMap.keySet() AND ContactId in :contactIdsToVerify]) {
       		if(fullMap.get(cm.CampaignId).get('Add').contains(cm.ContactId)) {
       			fullMap.get(cm.CampaignId).get('Add').remove(cm.ContactId);
        	}
        	if(fullMap.get(cm.CampaignId).get('Expire').contains(cm.ContactId)) {
        		cm.Status = 'Expired';
        		toUpsert.add(cm);
        		fullMap.get(cm.CampaignId).get('Expire').remove(cm.ContactId);
        	}
        	fullMap.get(cm.CampaignId).get('Expire').remove(cm.ContactId);
        }
        
        //cycle back through map to determine if new Campaign Members need to be created
        for(Id campaignId : fullMap.keySet()) {
        	for(Id contactId : fullMap.get(campaignId).get('Add')) {
        		toUpsert.add(new CampaignMember(CampaignId=campaignId,ContactId=contactId,Status='Attempting Contact'));	
        	}
        }
        
        //to reduce DML operations, we'll use upsert to (a) insert new Campaign Members and
        //(b) update the status of existing Campaign Members
        if(toUpsert.size() > 0) {
        	Schema.SObjectField f = CampaignMember.Fields.Id;
			Database.upsertResult[] cr = Database.upsert(toUpsert, f, false);
        	for(Database.upsertResult ur : cr) {
        		if(!ur.isSuccess()) {
        			System.debug('Could not load Campaign Member: ' + ur.getErrors());
        		}
        	}
        }
    }
    
    /**
    * Provided a campaign name, determines if a Contact/Person Account and it's linked Financial Accounts
    * qualify to be added to the campaign
    * @param campaignName name of campaign to check
    * @param links map of contact ids with list of corresponding financial account links
    * @return map of campaign ids with corresponding map of contact ids to "Add" and contact ids to "Expire"
    */
    private static Map<Id, Map<String, Set<Id>>> determineCampaignEligibility(String campaignName, Map<Id,List<Financial_Account_Contact_Link_SFDC2__c>> links) {
    	System.debug('Determine eligibility for campaign: ' + campaignName);
    	//Campaign Id -> Add/Expire -> Set of Contact Ids
    	Map<Id, Map<String, Set<Id>>> campaignEligContactMap = new Map<Id, Map<String, Set<Id>>>();
    	
    	Id campaignId;
    	for(Campaign c : campaignRecordMap.values()) {
    		if(c.Name == campaignName) {
    			campaignId = c.Id;
    		}
    	}
    	
    	if(campaignId == null) {
    		return campaignEligContactMap;
    	}
    	
    	campaignEligContactMap.put(campaignId, new Map<String, Set<Id>>{
    													'Add' => new Set<Id>(),
    													'Expire' => new Set<Id>()
    												  });
    	
	   	//retrieve Financial_Account_Campaign_Link_SFDC2__c records to determine which financial accounts have
    	//already been added to campaigns
    	Map<Id, List<Financial_Account_Campaign_Link_SFDC2__c>> finAcctCmpMap = new Map<Id, List<Financial_Account_Campaign_Link_SFDC2__c>>();
    	for(Id cId : campaignRecordMap.keySet()) {
    		finAcctCmpMap.put(cId, new List<Financial_Account_Campaign_Link_SFDC2__c>());
    	}
    	for(Financial_Account_Campaign_Link_SFDC2__c clink : [SELECT Financial_Account__c, Campaign__c FROM Financial_Account_Campaign_Link_SFDC2__c WHERE Campaign__c = :campaignId]) {
    		if(!finAcctCmpMap.containsKey(clink.Campaign__c)) {
    			finAcctCmpMap.put(clink.Campaign__c, new List<Financial_Account_Campaign_Link_SFDC2__c>());
    		}
    		finAcctCmpMap.get(clink.Campaign__c).add(clink);
    	}
    	System.debug('Existing Financial Account Campaign Link records: ' + finAcctCmpMap);
    	Map<Id,Set<Id>> campaignFinMap = new Map<Id,Set<Id>>();
        for(Id cId : links.keySet()) {
        	System.debug('Processing financial accounts for contact: ' + cId);
        	Boolean isElig = false;
        	if(campaignName == '30 Day CD Maturity') {
        		//isElig = check30DayCDMaturityCampaignElig(links.get(cId));
        		for(Financial_Account_Contact_Link_SFDC2__c link : links.get(cId)) {
        			Boolean isLinkElig = check30DayCDMaturityCampaignElig(link);
        			if(isLinkElig) {
        				//this financial account signals need to be in campaign
        				isElig = true;
        				if(!campaignFinMap.containsKey(campaignId)) {
        					campaignFinMap.put(campaignId, new Set<Id>());
        				}
        				campaignFinMap.get(campaignId).add(link.Financial_Account__c);
        			}
        		}
        	}
        	if(campaignName == '30 Day No Signature Card') {
        		//isElig = check30DayNoSigCampaignElig(links.get(cId));
        		for(Financial_Account_Contact_Link_SFDC2__c link : links.get(cId)) {
        			Boolean isLinkElig = check30DayNoSigCampaignElig(link);
        			if(isLinkElig) {
        				//this financial account signals need to be in campaign
        				isElig = true;
        				if(!campaignFinMap.containsKey(campaignId)) {
        					campaignFinMap.put(campaignId, new Set<Id>());
        				}
        				campaignFinMap.get(campaignId).add(link.Financial_Account__c);
        			}
        		}
        	}
        	if(campaignName == '45 Day No Signature Card') {
        		//isElig = check45DayNoSigCampaignElig(links.get(cId));
        		for(Financial_Account_Contact_Link_SFDC2__c link : links.get(cId)) {
        			Boolean isLinkElig = check45DayNoSigCampaignElig(link);
        			if(isLinkElig) {
        				//this financial account signals need to be in campaign
        				isElig = true;
        				if(!campaignFinMap.containsKey(campaignId)) {
        					campaignFinMap.put(campaignId, new Set<Id>());
        				}
        				campaignFinMap.get(campaignId).add(link.Financial_Account__c);
        			}
        		}
        	}
        	if(campaignName == '10 Day Unfunded Accounts') {
        		//isElig = check10DayUnfundedCampaignElig(links.get(cId));
        		for(Financial_Account_Contact_Link_SFDC2__c link : links.get(cId)) {
        			Boolean isLinkElig = check10DayUnfundedCampaignElig(link);
        			if(isLinkElig) {
        				//this financial account signals need to be in campaign
        				isElig = true;
        				if(!campaignFinMap.containsKey(campaignId)) {
        					campaignFinMap.put(campaignId, new Set<Id>());
        				}
        				campaignFinMap.get(campaignId).add(link.Financial_Account__c);
        			}
        		}
        	}
        	if(campaignName == '30 Day Unfunded Accounts') {
        		//isElig = check30DayUnfundedCampaignElig(links.get(cId));
        		for(Financial_Account_Contact_Link_SFDC2__c link : links.get(cId)) {
        			Boolean isLinkElig = check30DayUnfundedCampaignElig(link);
        			if(isLinkElig) {
        				//this financial account signals need to be in campaign
        				isElig = true;
        				if(!campaignFinMap.containsKey(campaignId)) {
        					campaignFinMap.put(campaignId, new Set<Id>());
        				}
        				campaignFinMap.get(campaignId).add(link.Financial_Account__c);
        			}
        		}
        	}
        	if(campaignName == '45 Day Unfunded Accounts') {
        		//isElig = check45DayUnfundedCampaignElig(links.get(cId));
        		for(Financial_Account_Contact_Link_SFDC2__c link : links.get(cId)) {
        			Boolean isLinkElig = check45DayUnfundedCampaignElig(link);
        			if(isLinkElig) {
        				//this financial account signals need to be in campaign
        				isElig = true;
        				if(!campaignFinMap.containsKey(campaignId)) {
        					campaignFinMap.put(campaignId, new Set<Id>());
        				}
        				campaignFinMap.get(campaignId).add(link.Financial_Account__c);
        			}
        		}
        	}
        	if(campaignName == '10 Day Zero Balance') {
        		//isElig = check10DayZeroCampaignElig(links.get(cId));
        		for(Financial_Account_Contact_Link_SFDC2__c link : links.get(cId)) {
        			Boolean isLinkElig = check10DayZeroCampaignElig(link);
        			if(isLinkElig) {
        				//this financial account signals need to be in campaign
        				isElig = true;
        				if(!campaignFinMap.containsKey(campaignId)) {
        					campaignFinMap.put(campaignId, new Set<Id>());
        				}
        				campaignFinMap.get(campaignId).add(link.Financial_Account__c);
        			}
        		}
        	}
        	if(campaignName == '30 Day Zero Balance') {
        		//isElig = check30DayZeroCampaignElig(links.get(cId));
        		for(Financial_Account_Contact_Link_SFDC2__c link : links.get(cId)) {
        			Boolean isLinkElig = check30DayZeroCampaignElig(link);
        			if(isLinkElig) {
        				//this financial account signals need to be in campaign
        				isElig = true;
        				if(!campaignFinMap.containsKey(campaignId)) {
        					campaignFinMap.put(campaignId, new Set<Id>());
        				}
        				campaignFinMap.get(campaignId).add(link.Financial_Account__c);
        			}
        		}
        	}
        	if(campaignName == '45 Day Zero Balance') {
        		//isElig = check45DayZeroCampaignElig(links.get(cId));
        		for(Financial_Account_Contact_Link_SFDC2__c link : links.get(cId)) {
        			Boolean isLinkElig = check45DayZeroCampaignElig(link);
        			if(isLinkElig) {
        				//this financial account signals need to be in campaign
        				isElig = true;
        				if(!campaignFinMap.containsKey(campaignId)) {
        					campaignFinMap.put(campaignId, new Set<Id>());
        				}
        				campaignFinMap.get(campaignId).add(link.Financial_Account__c);
        			}
        		}
        	}
        	if(campaignName == 'Consumer Deposits Welcome List') {
        		//isElig = checkWelcomeListCampaignElig(links.get(cId));
        		for(Financial_Account_Contact_Link_SFDC2__c link : links.get(cId)) {
        			Boolean isLinkElig = checkWelcomeListCampaignElig(link);
        			if(isLinkElig) {
        				//this financial account signals need to be in campaign
        				isElig = true;
        				if(!campaignFinMap.containsKey(campaignId)) {
        					campaignFinMap.put(campaignId, new Set<Id>());
        				}
        				campaignFinMap.get(campaignId).add(link.Financial_Account__c);
        			}
        		}
        	}
        	if(isElig) {
        		campaignEligContactMap.get(campaignId).get('Add').add(cId);
        		//for multiple financial accounts related to a single individual, do not expire
        		//a campaign member if at least one financial account is eligible
        		campaignEligContactMap.get(campaignId).get('Expire').remove(cId);
        	} else {
        		campaignEligContactMap.get(campaignId).get('Expire').add(cId);
        	}
        }
        
        System.debug('Campaign/Financial Account Eligible Map: ' + campaignFinMap);
        
        //cycle through financial accounts that resulted in add to Campaigns and determine
        //if links/activities need to be created
        //determine if this financial account was already a reason for person to be in campaign
        List<sObject> toInsert = new List<sObject>();
        Map<Id, Set<Id>> campFinToAddMap = new Map<Id, Set<Id>>();
        System.debug('finAcctCmpMap: ' + finAcctCmpMap);
        for(Id cId : campaignFinMap.keySet()) {
        	campFinToAddMap.put(cId, new Set<Id>());
        	for(Id fId : campaignFinMap.get(cId)) {
        		Boolean createLink = true;
        		for(Financial_Account_Campaign_Link_SFDC2__c clink : finAcctCmpMap.get(cId)) {
        			if(clink.Financial_Account__c == fId) {
        				createLink = false;
        				break;
        			}
        		}
        		if(createLink) {
        			campFinToAddMap.get(cId).add(fId);
        		}
        	}
        }
        //if financial account was not previously identified as being in an existing campaign
		//then create link and activity
        for(Id cId : campFinToAddMap.keySet()) {
        	for(Id fId : campFinToAddMap.get(cId)) {
				Financial_Account_Campaign_Link_SFDC2__c facl = new Financial_Account_Campaign_Link_SFDC2__c();
				facl.Campaign__c = cId;
				facl.Financial_Account__c = fId;
				toInsert.add(facl);
				Task t = new Task();
				t.Subject = campaignRecordMap.get(cId).Name;
				t.Type = 'Campaign Member Status: Attempting Contact';
				t.Status = 'Completed';
				t.WhatId = fId;
				t.OwnerId = UserTriggerHandler.APIAccountId;
				t.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Standard Task').getRecordTypeId();
				toInsert.add(t);
        	}
        }
        if(toInsert.size() > 0) {
        	//sort sObject list to reduce potential for chunking error
        	toInsert.sort();
        	insert toInsert;
        }
        
        return campaignEligContactMap;
    }
    
    /**
    * Provided a list of Financial Account Contact Links, determines if any meet the criteria to be added
    * to the 30 Day CD Maturity campaign
    * @param links list of Financial Account Contact Links for a specific person
    * @return true if person meets criteria; false otherwise
    */
    private static boolean check30DayCDMaturityCampaignElig(Financial_Account_Contact_Link_SFDC2__c link) {
    	Date x30DaysOut = Date.today().addDays(30);
        Boolean isEligible = false;
	    if(!link.Contact__r.DoNotCall &&
	        link.Financial_Account__r.Status__c == 'Active' &&
	        link.Financial_Account__r.Product_Class__c == 'CD' &&
	        link.Financial_Account__r.Maturity_Date__c <= x30DaysOut &&
	        link.Financial_Account__r.Maturity_Date__c >= Date.today()
	    ) {
	        isEligible = true;
        }
        return isEligible;
    }
    
    /**
    * Provided a list of Financial Account Contact Links, determines if any meet the criteria to be added
    * to the 30 Day No Signature Card campaign
    * @param links list of Financial Account Contact Links for a specific person
    * @return true if person meets criteria; false otherwise
    */
    private static boolean check30DayNoSigCampaignElig(Financial_Account_Contact_Link_SFDC2__c link) {
    	Date x30DaysOut = Date.today().addDays(-30);
        Date x45DaysOut = Date.today().addDays(-45);
        Boolean isEligible = false;
        if(!link.Contact__r.DoNotCall &&
            link.Financial_Account__r.Status__c == 'Open' &&
            link.Financial_Account__r.Department__c == 'Consumer Deposits' &&
            !link.Financial_Account__r.Signature_Card_Received__c &&
            link.Financial_Account__r.Open_Date__c <= x30DaysOut &&
            link.Financial_Account__r.Open_Date__c >= x45DaysOut
        ) {
            isEligible = true;
        }
        return isEligible;
    }
    
    /**
    * Provided a list of Financial Account Contact Links, determines if any meet the criteria to be added
    * to the 45 Day No Signature Card campaign
    * @param links list of Financial Account Contact Links for a specific person
    * @return true if person meets criteria; false otherwise
    */
    private static boolean check45DayNoSigCampaignElig(Financial_Account_Contact_Link_SFDC2__c link) {
    	Date x45DaysOut = Date.today().addDays(-45);
        Date x60DaysOut = Date.today().addDays(-60);
        Boolean isEligible = false;
        if(!link.Contact__r.DoNotCall &&
	        link.Financial_Account__r.Status__c == 'Open' &&
	        link.Financial_Account__r.Department__c == 'Consumer Deposits' &&
	        !link.Financial_Account__r.Signature_Card_Received__c &&
	        link.Financial_Account__r.Open_Date__c <= x45DaysOut &&
	        link.Financial_Account__r.Open_Date__c >= x60DaysOut
	    ) {
	        isEligible = true;
        }
        return isEligible;
    }
    
    /**
    * Provided a list of Financial Account Contact Links, determines if any meet the criteria to be added
    * to the 10 Day Unfunded Account campaign
    * @param links list of Financial Account Contact Links for a specific person
    * @return true if person meets criteria; false otherwise
    */
    private static boolean check10DayUnfundedCampaignElig(Financial_Account_Contact_Link_SFDC2__c link) {
    	Date x10DaysOut = Date.today().addDays(-10);
        Date x30DaysOut = Date.today().addDays(-30);
        Boolean isEligible = false;
        if(!link.Contact__r.DoNotCall &&
            link.Financial_Account__r.Status__c == 'Open' &&
            link.Financial_Account__r.Department__c == 'Consumer Deposits' &&
            link.Financial_Account__r.Funding_Date__c == null &&
            link.Financial_Account__r.Open_Date__c <= x10DaysOut &&
            link.Financial_Account__r.Open_Date__c >= x30DaysOut
        ) {
	        isEligible = true;
	    }
        return isEligible;
    }
    
    /**
    * Provided a list of Financial Account Contact Links, determines if any meet the criteria to be added
    * to the 30 Day Unfunded Account campaign
    * @param links list of Financial Account Contact Links for a specific person
    * @return true if person meets criteria; false otherwise
    */
    private static boolean check30DayUnfundedCampaignElig(Financial_Account_Contact_Link_SFDC2__c link) {
        Date x30DaysOut = Date.today().addDays(-30);
        Date x45DaysOut = Date.today().addDays(-45);
        Boolean isEligible = false;
	    if(!link.Contact__r.DoNotCall &&
	        link.Financial_Account__r.Status__c == 'Open' &&
	        link.Financial_Account__r.Department__c == 'Consumer Deposits' &&
	        link.Financial_Account__r.Funding_Date__c == null &&
	        link.Financial_Account__r.Open_Date__c <= x30DaysOut &&
	        link.Financial_Account__r.Open_Date__c >= x45DaysOut
	    ) {
	        isEligible = true;
        }
        return isEligible;
    }
    
    /**
    * Provided a list of Financial Account Contact Links, determines if any meet the criteria to be added
    * to the 45 Day Unfunded Account campaign
    * @param links list of Financial Account Contact Links for a specific person
    * @return true if person meets criteria; false otherwise
    */
    private static boolean check45DayUnfundedCampaignElig(Financial_Account_Contact_Link_SFDC2__c link) {
        Date x45DaysOut = Date.today().addDays(-45);
        Date x60DaysOut = Date.today().addDays(-60);
        Boolean isEligible = false;
	    if(!link.Contact__r.DoNotCall &&
	        link.Financial_Account__r.Status__c == 'Open' &&
	        link.Financial_Account__r.Department__c == 'Consumer Deposits' &&
	        link.Financial_Account__r.Funding_Date__c == null &&
	        link.Financial_Account__r.Open_Date__c <= x45DaysOut &&
	        link.Financial_Account__r.Open_Date__c >= x60DaysOut
	    ) {
	        isEligible = true;
	    }
        return isEligible;
    }
    
    /**
    * Provided a list of Financial Account Contact Links, determines if any meet the criteria to be added
    * to the 10 Day Zero Balance campaign
    * @param links list of Financial Account Contact Links for a specific person
    * @return true if person meets criteria; false otherwise
    */
    private static boolean check10DayZeroCampaignElig(Financial_Account_Contact_Link_SFDC2__c link) {
        Date x10DaysOut = Date.today().addDays(-10);
        Date x30DaysOut = Date.today().addDays(-30);
        Boolean isEligible = false;
        if(!link.Contact__r.DoNotCall &&
            link.Financial_Account__r.Status__c == 'Open' &&
            link.Financial_Account__r.Department__c == 'Consumer Deposits' &&
            link.Financial_Account__r.Zero_Balance_Flag__c &&
            link.Financial_Account__r.Zero_Balance_Date__c <= x10DaysOut &&
            link.Financial_Account__r.Zero_Balance_Date__c >= x30DaysOut
        ) {
            isEligible = true;
        }
        return isEligible;
    }
    
    /**
    * Provided a list of Financial Account Contact Links, determines if any meet the criteria to be added
    * to the 30 Day Zero Balance campaign
    * @param links list of Financial Account Contact Links for a specific person
    * @return true if person meets criteria; false otherwise
    */
    private static boolean check30DayZeroCampaignElig(Financial_Account_Contact_Link_SFDC2__c link) {
        Date x30DaysOut = Date.today().addDays(-30);
        Date x45DaysOut = Date.today().addDays(-45);
        Boolean isEligible = false;
	    if(!link.Contact__r.DoNotCall &&
	        link.Financial_Account__r.Status__c == 'Open' &&
	        link.Financial_Account__r.Department__c == 'Consumer Deposits' &&
	        link.Financial_Account__r.Zero_Balance_Flag__c &&
	        link.Financial_Account__r.Zero_Balance_Date__c <= x30DaysOut &&
	        link.Financial_Account__r.Zero_Balance_Date__c >= x45DaysOut
	    ) {
	        isEligible = true;
	    }
        return isEligible;
    }
    
    /**
    * Provided a list of Financial Account Contact Links, determines if any meet the criteria to be added
    * to the 45 Day Zero Balance campaign
    * @param links list of Financial Account Contact Links for a specific person
    * @return true if person meets criteria; false otherwise
    */
    private static boolean check45DayZeroCampaignElig(Financial_Account_Contact_Link_SFDC2__c link) {
        Date x45DaysOut = Date.today().addDays(-45);
        Date x60DaysOut = Date.today().addDays(-60);
        Boolean isEligible = false;
	    if(!link.Contact__r.DoNotCall &&
	        link.Financial_Account__r.Status__c == 'Open' &&
	        link.Financial_Account__r.Department__c == 'Consumer Deposits' &&
	        link.Financial_Account__r.Zero_Balance_Flag__c &&
	        link.Financial_Account__r.Zero_Balance_Date__c <= x45DaysOut &&
	        link.Financial_Account__r.Zero_Balance_Date__c >= x60DaysOut
	    ) {
	        isEligible = true;
	    }
        return isEligible;
    }
    
    /**
    * Provided a list of Financial Account Contact Links, determines if any meet the criteria to be added
    * to the Consumer Deposits Welcome List campaign
    * @param links list of Financial Account Contact Links for a specific person
    * @return true if person meets criteria; false otherwise
    */
    private static boolean checkWelcomeListCampaignElig(Financial_Account_Contact_Link_SFDC2__c link) {
        Date x0DaysOut = Date.today();
        Date x10DaysOut = Date.today().addDays(-10);
        Boolean isEligible = false;
	    if(!link.Contact__r.DoNotCall &&
	        link.Financial_Account__r.Status__c == 'Open' &&
	        link.Financial_Account__r.Department__c == 'Consumer Deposits' &&
	        link.Financial_Account__r.Funding_Date__c == null &&
	        link.Financial_Account__r.Open_Date__c <= x0DaysOut &&
	        link.Financial_Account__r.Open_Date__c >= x10DaysOut
	    ) {
	        isEligible = true;
	    }
        return isEligible;
    }
}