/**
* @description <p>Handler class for CreditReviewTrigger functionality</p>
* @author Mike Crosby, BofI Federal 
*/
public class CreditReviewTriggerHandler extends TriggerHandler {

  /** Map of Credit Reviews before changes */
  private Map<Id, WLD_Credit_Review__c> oldCredMap;
  /** Map of Credit Reviews with changes */
  private Map<Id, WLD_Credit_Review__c> newCredMap;
  /** List of Credit Reviews with changes */
  private List<WLD_Credit_Review__c> newCredList;

  /** Constructor */
  public CreditReviewTriggerHandler() {
    this.oldCredMap = (Map<Id, WLD_Credit_Review__c>) Trigger.oldMap;
    this.newCredMap = (Map<Id, WLD_Credit_Review__c>) Trigger.newMap;
    this.newCredList = Trigger.new;
  }

  /**
  * Process beforeUpdate logic
  */
  public override void beforeUpdate() {
    handleCreditReviewApproved(this.oldCredMap, this.newCredMap);
    //handleCreditReviewDenied(this.oldCredMap,this.newCredMap);
  }
  
  /**
  * Process beforeInsert logic
  */
  public override void beforeInsert() {
    handleCreditReviewUniquenessForCert(newCredList);
  }

  /**
  * Process afterUpdate logic
  */
  public override void afterUpdate() {
    handleStatusHistoryCreation(this.oldCredMap, this.newCredMap);
    handleCertFieldUpdates(this.oldCredMap, this.newCredMap);
  }
  
  /**
  * Process afterInsert logic
  */
  public override void afterInsert() {
    handleStatusHistoryCreation(null, this.newCredMap);
    handleCertFieldUpdates(null, this.newCredMap);
  }

  /**
  * Performs any necessary field updates on related Certification record
  * @param oldMap map of initial state Credit Reviews
  * @param newMap map of changed Credit Reviews
  */
  private void handleCertFieldUpdates(Map<Id,WLD_Credit_Review__c> oldMap, Map<Id,WLD_Credit_Review__c> newMap) {
    Map<Id, WLD_Certification__c> certsToUpdate = new Map<Id, WLD_Certification__c>();
    
    for(WLD_Credit_Review__c rev : newMap.values()) {
        Boolean hasCertUpdates = false;
        WLD_Certification__c cert;
        //since there could be updates pending for the certification, we need to determine if an update already exists
        for(Sobject obj : toUpdate) {
          if(obj.Id == rev.Certification__c) {
            cert = (WLD_Certification__c)obj;
            hasCertUpdates = true;
            break;
          }
        }
        if(cert == null) {
          cert = new WLD_Certification__c(Id=rev.Certification__c);
        }
        WLD_Credit_Review__c oldRev;
        if(oldMap != null) {
          oldRev = oldMap.get(rev.Id);
        }
        if((oldRev == null && rev.Obligor_Score__c != null) ||
            (oldRev != null && rev.Obligor_Score__c != oldRev.Obligor_Score__c)) {
          cert.Obligor_Score__c = rev.Obligor_Score__c;
        }
        if((oldRev == null && rev.Risk_Rating__c != null) ||
            (oldRev != null && rev.Risk_Rating__c != oldRev.Risk_Rating__c)) {
          cert.Risk_Rating__c = rev.Risk_Rating__c;
        }
        if((oldRev == null && rev.Credit_Status__c != null) ||
            (oldRev!= null && rev.Credit_Status__c != oldRev.Credit_Status__c)) {
            cert.Credit_Review_Status__c = rev.Credit_Status__c;
        }
        if(!hasCertUpdates) {
          toUpdate.add(cert);
        }
      }
  }

  /**
  * Ensures that only one Credit Review is created for a Certification
  * @param newCredList list of new Credit Reviews
  */
  private void handleCreditReviewUniquenessForCert(List<WLD_Credit_Review__c> credList) {
    Map<Id,WLD_Credit_Review__c> certCredMap = new Map<Id,WLD_Credit_Review__c>();
    for(WLD_Credit_Review__c cr : credList) {
        if(certCredMap.containsKey(cr.Certification__c)) {
            cr.addError('Attempt to create Credit Review for a Certification that already has one');
        } else {
            certCredMap.put(cr.Certification__c, cr);
        }
    }
    
    for(WLD_Certification__c cert : [
                                SELECT Id, (
                                            SELECT Id from Credit_Reviews__r
                                            )
                                FROM WLD_Certification__c
                                WHERE Id in :certCredMap.keySet()]) {
        if(cert.Credit_Reviews__r.size() > 0) {
            certCredMap.get(cert.Id).addError('Attempt to create Credit Review for a Certification that already has one');
        }
    }
  }

  /**
  * If the Credit Review is approved, update Certification status to Completed
  * @param oldMap map of initial state Credit Reviews
  * @param newMap map of changed Credit Reviews
  */
  private void handleCreditReviewApproved(Map<Id,WLD_Credit_Review__c> oldMap, Map<Id,WLD_Credit_Review__c> newMap) {
    List<Id> cIdToUpdate = new List<Id>();
    for(WLD_Credit_Review__c rev : newMap.values()) {
        WLD_Credit_Review__c oldRev = oldMap.get(rev.Id);
        if(oldRev.TriggerApprovedProcess__c != rev.TriggerApprovedProcess__c &&
            rev.TriggerApprovedProcess__c) {
            cIdToUpdate.add(rev.Certification__c);
            rev.TriggerApprovedProcess__c = false;
        }
    }
    
    if(cIdToUpdate.size() > 0) {
        updateCertificationStatus(cIdToUpdate, 'Completed');
    }
  }
  
  /**
  * If the Credit Review is rejected, update Certification status to Denied
  * @param oldMap map of initial state Credit Reviews
  * @param newMap map of changed Credit Reviews
  */
  /*private void handleCreditReviewDenied(Map<Id,WLD_Credit_Review__c> oldMap, Map<Id,WLD_Credit_Review__c> newMap) {
    List<Id> cIdToUpdate = new List<Id>();
    for(WLD_Credit_Review__c rev : newMap.values()) {
        WLD_Credit_Review__c oldRev = oldMap.get(rev.Id);
        if(oldRev.TriggerDeniedProcess__c != rev.TriggerDeniedProcess__c &&
            rev.TriggerDeniedProcess__c) {
            cIdToUpdate.add(rev.Certification__c);
            rev.TriggerDeniedProcess__c = false;
        }
    }
    
    if(cIdToUpdate.size() > 0) {
        updateCertificationStatus(cIdToUpdate, 'Denied');
    }
  }*/
  
  private void updateCertificationStatus(List<Id> certToUpdateList, String status) {
    for(Id i : certToUpdateList) {
        WLD_Certification__c cert = new WLD_Certification__c();
        cert.Id = i;
        cert.Status__c = status;
        toUpdate.add(cert);
    }
  }
  
  /**
  * If the Status field of the Credit Review changes, create a Status History record
  * @param oldCertMap map of the initial state Credit Reviews
  * @param newCertMap map of changed Credit Reviews
  */
  private void handleStatusHistoryCreation(Map<Id,WLD_Credit_Review__c> oldMap, Map<Id,WLD_Credit_Review__c> newMap) {
    //determine which reviews have a status update
    Set<Id> idSet = new Set<Id>();
    for(WLD_Credit_Review__c newCred : newMap.values()) {
        if(oldMap == null) {
            //after insert
            idSet.add(newCred.Id);
        } else {
            //after update
            WLD_Credit_Review__c oldCred = oldMap.get(newCred.Id);
            if(newCred.Credit_Status__c != oldCred.Credit_Status__c) {
              idSet.add(newCred.Id);
            }
        }
    }
    
    if(idSet.size() > 0) {
        List<WLD_Status_History__c> historyToAdd = new List<WLD_Status_History__c>();
        for(Id i : idSet) {
          //create status history record
          WLD_Status_History__c sh = new WLD_Status_History__c();
          sh.Credit_Review__c = i;
          sh.Name = newMap.get(i).Credit_Status__c;
          sh.Status_Date_Time__c = Datetime.now();
          historyToAdd.add(sh);
        }
        insert historyToAdd;
        
        //perform any necessary linking between histories
        for(WLD_Credit_Review__c cred : [
                                        SELECT Id,
                                            (
                                              SELECT Id, Name, Status_Date_Time__c
                                              FROM Status_History__r
                                              ORDER BY Status_Date_Time__c DESC, Id DESC
                                              LIMIT 2
                                             )
                                        FROM WLD_Credit_Review__c
                                        WHERE Id in :idSet]) {
            
            if(cred.Status_History__r.size() > 1) {
                WLD_Status_History__c histToUpdate = cred.Status_History__r[1];
                histToUpdate.Next_Status__c = cred.Status_History__r[0].Id;
                toUpdate.add(histToUpdate);
            }                               
        }
    }
  }
}