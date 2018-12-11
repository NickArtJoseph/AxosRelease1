/**
* @description <p>Handler class for LoanOpsQstnrTrigger functionality</p>
* @author Mike Crosby, BofI Federal 
*/
public class LoanOpsQstnrTriggerHandler extends TriggerHandler {

  /** Map of records before changes */
  private Map<Id, Loan_Ops_Questionnaire__c> oldObjMap;
  /** Map of records with changes */
  private Map<Id, Loan_Ops_Questionnaire__c> newObjMap;
  
  /** Constructor */
  public LoanOpsQstnrTriggerHandler() {
    this.oldObjMap = (Map<Id, Loan_Ops_Questionnaire__c>) Trigger.oldMap;
    this.newObjMap = (Map<Id, Loan_Ops_Questionnaire__c>) Trigger.newMap;
  }
    
  /**
  * Process beforeUpdate logic
  */
  public override void beforeUpdate() {
    validateLOQApproval();
  }
  
  /**
   * Ensures that required fields of LOQ are completed before Approval is allowed 
   * 
   */
  private void validateLOQApproval() {
      for(Loan_Ops_Questionnaire__c loq : newObjMap.values()) {
          Loan_Ops_Questionnaire__c oldLOQ = oldObjMap.get(loq.Id);
          if(loq.ApprovalSubmitted__c && !oldLOQ.ApprovalSubmitted__c) {
              System.debug('**** ApprovalSubmitted=true');
              //approval submitted, validate required fields
              String errMsg = 'This Loan Ops Questionnaire cannot yet be approved because the following required field(s) must contains a value ';
              List<String> reqFieldList = new List<String>();
              System.debug('**** C&I Loan Type=' + loq.C_I_Loan_Type__c);
              Schema.DescribeSObjectResult loqObj = Schema.SObjectType.Loan_Ops_Questionnaire__c;
              if(loq.C_I_Loan_Type__c == null) {
                  reqFieldList.add(Schema.SObjectType.Loan_Ops_Questionnaire__c.fields.C_I_Loan_Type__c.getLabel());
              }
              System.debug('**** Call Report Code=' + loq.Call_Report_Code__c);
              if(loq.Call_Report_Code__c == null) {
                  reqFieldList.add(Schema.SObjectType.Loan_Ops_Questionnaire__c.fields.Call_Report_Code__c.getLabel());
              }
              System.debug('**** Collateral Code/Description=' + loq.Collateral_Code_Description__c);
              if(loq.Collateral_Code_Description__c == null) {
                  reqFieldList.add(Schema.SObjectType.Loan_Ops_Questionnaire__c.fields.Collateral_Code_Description__c.getLabel());
              }
              System.debug('**** Purpose Code=' + loq.Purpose_Code__c);
              if(loq.Purpose_Code__c == null) {
                  reqFieldList.add(Schema.SObjectType.Loan_Ops_Questionnaire__c.fields.Purpose_Code__c.getLabel());
              }
              
              if(reqFieldList.size() > 0) {
                  loq.addError(errMsg + reqFieldList + '. Please return to the original LOQ and complete the required fields <a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + loq.Id + '">' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + loq.Id +'</a>');
                  loq.ApprovalSubmitted__c = false;
              }
          }
      }
  }
}