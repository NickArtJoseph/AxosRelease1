public class FinAcctContactLinkTriggerHandler extends TriggerHandler {
	/** Map of records before changes */
	private Map<Id, Financial_Account_Contact_Link_SFDC2__c> oldMap;
	/** Map of records with changes */
	private Map<Id, Financial_Account_Contact_Link_SFDC2__c> newMap;
	/**List of records with changes; typically used for beforeInsert */
	private List<Financial_Account_Contact_Link_SFDC2__c> newList;
	
	/** Constructor */
	public FinAcctContactLinkTriggerHandler() {
		this.oldMap = (Map<Id, Financial_Account_Contact_Link_SFDC2__c>) Trigger.oldMap;
		this.newMap = (Map<Id, Financial_Account_Contact_Link_SFDC2__c>) Trigger.newMap;
		this.newList = (List<Financial_Account_Contact_Link_SFDC2__c>) Trigger.new;
	}

	/**
	* Process beforeInsert logic
	*/
	public override void beforeInsert() {  }
	
	/**
	* Process beforeUpdate logic
	*/
	public override void beforeUpdate() {  }
	
	/**
	* Process afterInsert logic
	*/
	public override void afterInsert() { 
		handleCampaignAutomation();
	 }
	
	/**
	* Process afterUpdate logic
	*/
	public override void afterUpdate() {  }
	
	/**
	* When a connection is made between a Contact and a Financial Account, check to see if
	* the Contact should be added to a campaign
	*/
	private void handleCampaignAutomation() {
		List<String> linksToCheck = new List<String>();
		for(Id linkId : newMap.keySet()) {
			linksToCheck.add(linkId);
		}
		
		CampaignMemberAutomationHandler.handleCampaignMemberAutomation(linksToCheck);
	}
	
}