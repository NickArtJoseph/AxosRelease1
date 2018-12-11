/**
* @description <p>Handler class for AmendmentTrigger functionality</p>
* @author Mike Crosby, BofI Federal 
*/
public with sharing class AmendmentTriggerHandler extends TriggerHandler {
  /** Map of Amendments before changes */
  private Map<Id, Amendment__c> oldAmendMap;
  /** Map of Amendments with changes */
  private Map<Id, Amendment__c> newAmendMap;
  
  /** Constructor */
  public AmendmentTriggerHandler() {
  	this.oldAmendMap = (Map<Id, Amendment__c>) Trigger.oldMap;
  	this.newAmendMap = (Map<Id, Amendment__c>) Trigger.newMap;
  }
  
  /**
  * Process afterUpdate logic
  */
  public override void afterUpdate() {
  	updateOppModSummaryFields(this.oldAmendMap, this.newAmendMap);
  }
  
  /**
  * When Amendments are approved, update respective fields in Modification Summary on parent Opportunity
  * @param oldAmendMap map of initial state Amendments
  * @param newAmendMap map of changed Amendments
  */
  private void updateOppModSummaryFields(Map<Id, Amendment__c> oldMap, Map<Id, Amendment__c> newMap) {
  	for(Amendment__c amend : newMap.values()) {
  		Amendment__c oldAmend = oldMap.get(amend.Id);
  		if(amend.Approval_Status__c == 'Approved' && oldAmend.Approval_Status__c != 'Approved') {
  			Opportunity opp = new Opportunity(Id=amend.Opportunity__c);
  			opp.CI_Additional_Fees_Amend__c = amend.Additional_Fees__c;
  			opp.CI_Extension_Options_Amend__c = amend.Extension_Options__c;
  			opp.CI_Guarantor_Types_Amend__c = amend.Guarantor_Types__c;
  			opp.CI_Guarantors_Amend__c = amend.Guarantors__c;
  			opp.CI_Loan_Amount_Amend__c = amend.Loan_Amount__c;
  			opp.CI_Loan_Structure_Amend__c = amend.Loan_Structure__c;
  			opp.CI_Other_Amend__c = amend.Other__c;
  			opp.CI_Rate_Amend__c = amend.Rate__c;
  			opp.CI_Term_Amend__c = amend.Term__c;
  			opp.CI_Collateral_Amend__c = amend.Collateral__c;
  			toUpdate.add(opp);
  		}
  	}
  }
}