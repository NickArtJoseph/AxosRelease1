public class FinancialAccountSFDC2TriggerHandler extends TriggerHandler {
	/** Map of records before changes */
	private Map<Id, Financial_Account_SFDC2__c> oldMap;
	/** Map of records with changes */
	private Map<Id, Financial_Account_SFDC2__c> newMap;
	/**List of records with changes; typically used for beforeInsert */
	private List<Financial_Account_SFDC2__c> newList;
	
	/** Constructor */
	public FinancialAccountSFDC2TriggerHandler() {
		this.oldMap = (Map<Id, Financial_Account_SFDC2__c>) Trigger.oldMap;
		this.newMap = (Map<Id, Financial_Account_SFDC2__c>) Trigger.newMap;
		this.newList = (List<Financial_Account_SFDC2__c>) Trigger.new;
	}

	/**
	* Process beforeInsert logic
	*/
	public override void beforeInsert() {  }
	
	/**
	* Process beforeUpdate logic
	*/
	public override void beforeUpdate() {
		handleCampaignWorkflowTrigger();
	}
	
	/**
	* Process afterInsert logic
	*/
	public override void afterInsert() {  }
	
	/**
	* Process afterUpdate logic
	*/
	public override void afterUpdate() {
		handleCampaignAutomation(newMap.values());
	}
	
	private void handleCampaignWorkflowTrigger(){
		List<Financial_Account_SFDC2__c> faToHandle = new List<Financial_Account_SFDC2__c>();
		for(Financial_Account_SFDC2__c fa : newMap.values()) {
			if(fa.CampaignAutomationTriggerSFDC2__c) {
				faToHandle.add(fa);
				fa.CampaignAutomationTriggerSFDC2__c = false;
			}
		}
		
		if(faToHandle.size() > 0) {
			handleCampaignAutomation(faToHandle);
		}
	}
	
	private void handleCampaignAutomation(List<Financial_Account_SFDC2__c> records) {
		List<Id> finAcctUpdates = new List<Id>();
		List<String> fieldsToCheck = new List<String>{
													   'Status__c',
													   'Product_Class__c',
													   'Maturity_Date__c',
													   'Open_Date__c',
													   'Signature_Card_Received__c',
													   'Department__c',
													   'Funding_Date__c',
													   'Zero_Balance_Flag__c',
													   'Zero_Balance_Date__c'
														};
		for(Financial_Account_SFDC2__c fa : records) {
			Financial_Account_SFDC2__c oldFa = oldMap.get(fa.Id);
			for(String fieldName : fieldsToCheck) {
				if(fa.get(fieldName) != oldFa.get(fieldName)) {
					finAcctUpdates.add(fa.Id);
					break;
				}
			}
		}
		
		if(finAcctUpdates.size() > 0) {
			//retrieve link records and submit for further scrutiny
			List<String> linkIds = new List<String>();
			for(Financial_Account_Contact_Link_SFDC2__c link : [SELECT Id FROM Financial_Account_Contact_Link_SFDC2__c WHERE Financial_Account__c in :finAcctUpdates]) {
				linkIds.add(link.Id);	
			}
			if(linkIds.size() > 0) {
				CampaignMemberAutomationHandler.handleCampaignMemberAutomation(linkIds);
			}
		}
	}
}