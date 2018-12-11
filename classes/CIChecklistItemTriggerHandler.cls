/**
* @description <p>Handler class for TaskTrigger functionality</p>
* @author Mike Crosby, BofI Federal 
*/
public with sharing class CIChecklistItemTriggerHandler extends TriggerHandler {
	
  /** Map of CI Checklist Items before changes */
  private Map<Id, C_I_Checklist_Item__c> oldItemMap;
  /** Map of CI Checklist Items with changes */
  private Map<Id, C_I_Checklist_Item__c> newItemMap;
  
  /** Constructor */
  public CIChecklistItemTriggerHandler() {
  	this.oldItemMap = (Map<Id, C_I_Checklist_Item__c>) Trigger.oldMap;
  	this.newItemMap = (Map<Id, C_I_Checklist_Item__c>) Trigger.newMap;
  }
  
  /**
  * Process afterUpdate logic
  */
  public override void afterUpdate() {
  	handleCheckReceivedStatus(this.oldItemMap, this.newItemMap);
  }
  
  /**
  * Determines if all checklist items have been marked as 'Received' and sets flag on
  * parent certification indicating ready for approval submission
  * @param oldMap map of items with values before save
  * @param newMap map of items with values after save
  */
  private void handleCheckReceivedStatus(Map<Id,C_I_Checklist_Item__c> oldMap, Map<Id,C_I_Checklist_Item__c> newMap) {
  	Set<Id> certIdsToCheck = new Set<Id>();
  	Set<Id> certIdsToUpdate = new Set<Id>();
  	for(C_I_Checklist_Item__c citem : newMap.values()) {
  		C_I_Checklist_Item__c oldItem = oldMap.get(citem.Id);
  		if(citem.Status__c == 'Received' && oldItem.Status__c != 'Received') {
  			//status changed to Received
  			certIdsToCheck.add(citem.Certification__c);
  		} else if(citem.Status__c != 'Received') {
  			//remove any cert ids that we know don't need to be checked
  			certIdsToCheck.remove(citem.Certification__c);
  			toUpdate.add(new CI_Certification__c(Id=citem.Certification__c, AllItemsReceived__c=false));
  		}
  	}
  	if(certIdsToCheck.size() > 0) {
  		//rather than check checklist items for Received, locate any items not marked as received
  		//and those certifications will be removed from the update
  		for(C_I_Checklist_Item__c citem : [SELECT Certification__c from C_I_Checklist_Item__c WHERE Certification__c in :certIdsToCheck and Status__c != 'Received']) {
  			certIdsToCheck.remove(citem.Certification__c);
  		}
  		for(Id certId : certIdsToCheck) {
  			//all remaining certifications should be marked as ready for approval submittal
  			certIdsToUpdate.add(certId);
  		}
  		if(certIdsToUpdate.size() > 0) {
  			for(Id certId : certIdsToUpdate) {
  				toUpdate.add(new CI_Certification__c(Id=certId, AllItemsReceived__c=true));
  			}
  		}
  	}
  }
}