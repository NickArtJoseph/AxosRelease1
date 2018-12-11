/**
* @description <p>Handler class for PhoneNumberTrigger functionality</p>
* @author Mike Crosby, BofI Federal 
*/
public with sharing class PhoneNumberTriggerHandler extends TriggerHandler{
  /** Map of Phone Numbers before changes */
  private Map<Id, Phone_Number__c> oldMap;
  /** Map of Phone Numbers with changes */
  private Map<Id, Phone_Number__c> newMap;
  
  /** Constructor */
  public PhoneNumberTriggerHandler() {
    this.oldMap = (Map<Id, Phone_Number__c>) Trigger.oldMap;
    this.newMap = (Map<Id, Phone_Number__c>) Trigger.newMap;
  }
  
  /**
  * Process beforeUpdate logic
  */
  public override void beforeUpdate() {
    handleManualNeustarTrigger(oldMap, newMap);
  }
    public override void afterInsert() {
        handlesfdc2personaccount(newMap);
    }
  /**
  * Trigger a callout to Neustar to retrieve phone attribute data if Neustar Trigger field is set to true
  */
  private void handleManualNeustarTrigger(Map<Id, Phone_Number__c> oldPhoneMap, Map<Id, Phone_Number__c> newPhoneMap) {
  	for(Phone_Number__c ph : newPhoneMap.values()) {
		if(ph.Neustar_Trigger__c) {
			addSFNeustarJob(ph);
			ph.Neustar_Trigger__c = false;
		}
	}
  }
  
    /* Handle neustar for 2.0 person accounts */
    private void handlesfdc2personaccount (Map<Id, Phone_Number__c> newPhoneMap) {
    Id paRTId = Schema.SObjectType.Phone_Number__c.getRecordTypeInfosByName().get('Person Account SFDC2').getRecordTypeId();
  	for(Phone_Number__c ph : newPhoneMap.values()) {
		if(ph.Neustar_Trigger__c && ph.RecordTypeId == paRTId) {
			addSFNeustarJob(ph);
			ph.Neustar_Trigger__c = false;
		}
	}
  }
    
  /**
  * Creates queueable Neustar job for the phone number
  * @param ph Phone Number record to submit to Neustar API
  */
  private void addSFNeustarJob(Phone_Number__c ph) {
  	ID jobID = System.enqueueJob(new NeustarQueueableJob(ph));
    toInsert.add(new Webservice_Callout__c(Job_ID__c = jobID, 
    										Job_Name__c = 'NeustarQueueableJob',
                                            Account__c = ph.Account_Name__c,
                                            Phone_Number__c = ph.Id,
											Status__c = 'Queued'));
  } 
}