/**
* @description <p>Handler class for AssignedPaymentTrigger functionality</p>
* @author Mike Crosby, BofI Federal 
*/
public class AssignedPaymentTriggerHandler extends TriggerHandler{
  /** Map of Assigned Payments before changes */
  private Map<Id, Assigned_Payments__c> oldMap;
  /** Map of Assigned Payments with changes */
  private Map<Id, Assigned_Payments__c> newMap;
  /** List of Assigned Payments with changes */
  private List<Assigned_Payments__c> newList;
  
  /** Constructor */
  public AssignedPaymentTriggerHandler() {
  	this.oldMap = (Map<Id, Assigned_Payments__c>) Trigger.oldMap;
  	this.newMap = (Map<Id, Assigned_Payments__c>) Trigger.newMap;
  	this.newList = Trigger.new;
  }

  /**
  * Process beforeUpdate logic
  */
  public override void beforeUpdate() {
  	calculateLastPaymentDate();
  }
  
  /**
  * Process beforeInsert logic
  */
  public override void beforeInsert() {
  	calculateLastPaymentDate();
  }
    
  private void calculateLastPaymentDate() {
      for(Assigned_Payments__c ap : newList) {
          Assigned_Payments__c oldAp = new Assigned_Payments__c();
          if(oldMap != null) {
              oldAp = oldMap.get(ap.Id);
          }
          if(ap.First_Payment_Date__c != oldAp.First_Payment_Date__c || ap.Payment_Frequency__c != oldAp.Payment_Frequency__c || ap.Number_of_Payments__c != oldAp.Number_of_Payments__c) {
                 Integer numOfPayments = Integer.valueOf(ap.Number_of_Payments__c);
                 Date startDate = ap.First_Payment_Date__c;
                 //recalculate Last Payment Date value
                 if(ap.Payment_Frequency__c == 'lump sum') {
                     ap.Last_Payment_Date__c = startDate;
                 } else if (ap.Payment_Frequency__c == 'weekly') {
                     ap.Last_Payment_Date__c = startDate.addDays((numOfPayments-1) * 7);
                 } else if (ap.Payment_Frequency__c == 'annual') {
                     ap.Last_Payment_Date__c = startDate.addYears(numOfPayments-1);
                 } else if (ap.Payment_Frequency__c == 'semiannual') {
                     ap.Last_Payment_Date__c = startDate.addMonths((numOfPayments-1) * 6);
                 } else if (ap.Payment_Frequency__c == 'quarterly') {
                     ap.Last_Payment_Date__c = startDate.addMonths((numOfPayments-1) * 3);
                 } else if (ap.Payment_Frequency__c == 'monthly') {
                     ap.Last_Payment_Date__c = startDate.addMonths(numOfPayments-1);
                 }
          }
      }      
  }
}