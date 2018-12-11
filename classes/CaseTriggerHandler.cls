/**
* @description <p>Handler class for CaseTriggerHandler functionality</p>
* @author Erik Ramirez, Unosquare for BofI Federal 
*/

public class CaseTriggerHandler extends TriggerHandler {
  /** List of Case prior to insert */
  private List<Case> newList;
  private List<Case> oldList;
   public static Boolean firstRunAfterUpdate = true;
  /** Map of Case prior to insert */  
  private Map<Id, Case> newMap;
  private Map<Id, Case> oldMap;  
  // Static value for particular Milestone   
  //private static String MILESTONE_NAME = 'Case Resolved';  
    
  /** Constructor */
  public CaseTriggerHandler() {
    this.newList = (List<Case>) Trigger.new;
    this.oldList = (List<Case>) Trigger.old;
    this.newMap = (Map<Id, Case>) Trigger.newMap;
    this.oldMap = (Map<Id, Case>) Trigger.oldMap;  
  }
   
    /**
    * Process beforeInsert logic
    */
    public override void beforeInsert() {

        validateContactSelection();
        updatedUDBCaseCIFNumber(newList); 
    }    
    
    
    /**
    * Process afterInsert logic
    */
    public override void afterInsert() {

              assigmentRule(newList);
        runAssignmentRulesForEmailToCases(newList);
        runAfterInsertFutureActionDate(newList);
        

    }

    /*
    ** Process before update logic and validations
    */

    public override void beforeUpdate(){
      validateContactSelection();
       validateClosedTaskinCase();
    }

    /**
    * Process afterInsert logic
    */
    public override void afterUpdate() {
        if(system.isFuture()) return;
    runAfterUpdateFutureActionDate(newList);
    }

    /*
    This method is for uodated a Case with CIF number into Case, then 
    the Case will be updated with the Account and Constact CIF realted value. 
  */
    
    public static void assigmentRule(List<Case> ltsCases){
        
        List<Case> caseList = new List<Case>();
        for (Case caseObj : ltsCases) {
            if (caseObj.OwnerId  == UserInfo.getUserId() ) {
                caseList.add(new Case(id = caseObj.id));
            }
        }
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule = true;
        Database.update(caseList, dmo);        
        
    }
    public static void updatedUDBCaseCIFNumber(List<Case> ltsCases){
        //Validate de RecordType value
        Id idUDBRT = [Select id from RecordType where DeveloperName = 'UDB_Inquiry'].id;
        boolean flag = false;
        for(case c: ltsCases ){
            if(c.RecordTypeId == idUDBRT &&  c.UDB_CIF__c != null &&  c.UDB_CIF__c !='Test CIF'){ 
                List<Contact> cont = [  Select id, Account.Id from Contact where Account.CIF_SFDC2__c =: c.UDB_CIF__c limit 1];
                if(cont.size() > 0){ c.AccountId = cont[0].Account.Id;  c.ContactId = cont[0].id; flag = true; }
                List<Account> acc = [  Select id from Account where CIF_SFDC2__c =: c.UDB_CIF__c limit 1];
                if(acc.size() > 0 && flag == false){  c.AccountId = cont[0].Account.Id; }
                
            }
        }
        
    }



  public static void runAssignmentRulesForEmailToCases (List<Case> caseIds) {

     //Creating the DMLOptions for "Assign using active assignment rules" checkbox
     Database.DMLOptions dmlOpts = new Database.DMLOptions();
     dmlOpts.assignmentRuleHeader.useDefaultRule= true;

     List<Case> cList = [Select Id from Case WHERE ID IN: caseIds AND Origin like 'Email%'];
     for(case c: cList ){ c.setOptions(dmlOpts );
     }
     update cList;
  }    

    public static void runAfterInsertFutureActionDate(List<Case> caseIds){
        
        Set<Id> casesToUpdate = new Set<Id>();
        Set<Id> casesMilestoneToUpdate = new Set<Id>();
        for (Case c : caseIds) {
          
              if(c.future_Action_Date__c == null){
                  System.debug('No tiene future Date');
                  casesToupdate.add(c.Id); 
              }else{
                  System.debug('Tiene future Date');
                  casesMilestoneToUpdate.add(c.Id);    
              }

        }
        if (!casesToUpdate.isEmpty()) {
           System.debug('Entro al metodo copyTargetDate');
           copyTargetDate(casesToUpdate);
        }
        if (!casesMilestoneToUpdate.isEmpty()) {
           System.debug('Entro al metodo copyFutureActionDate');
           copyFutureActionDate(casesMilestoneToUpdate);
        }        
    }
    
    public static void runAfterUpdateFutureActionDate(List<Case> caseIds){
        Set<Id> casesToUpdate = new Set<Id>();
        Set<Id> casesMilestoneToUpdate = new Set<Id>();
        if (firstRunAfterUpdate) {
            firstRunAfterUpdate = false;
            for (Case c : caseIds) {

                  if(c.future_Action_Date__c == null){
                      System.debug('No tiene future Date');
                      casesToupdate.add(c.Id); 
                  }else{
                      System.debug('Tiene future Date');
                      casesMilestoneToUpdate.add(c.Id);    
                  }

            }
            if (!casesToUpdate.isEmpty()) {
               System.debug('Entro al metodo copyTargetDate');
               copyTargetDate(casesToUpdate);
            }
            if (!casesMilestoneToUpdate.isEmpty()) {
               System.debug('Entro al metodo copyFutureActionDate');
               copyFutureActionDate(casesMilestoneToUpdate);
            }
        } 
        
    }

    
  /* 
  *   @future method to help to update future_Action_Date__c   into Case, after the Case Milestone is created
  */
  @future
  public static void copyTargetDate(Set<Id> caseIds) {
    List<Case> casesToUpdate = new List<Case>();

    for (CaseMilestone milestone : [ select CaseId, MilestoneType.Name, TargetDate
                     from CaseMilestone
                     where CaseId in :caseIds and IsCompleted = false ORDER BY TargetDate ASC  ]) {
                                             
        DateTime soonestMliestones =[ select   TargetDate from CaseMilestone where CaseId  =: milestone.caseId and IsCompleted = false ORDER BY TargetDate ASC LIMIT 1].TargetDate;
                         casesToUpdate.add(new Case( Id = milestone.CaseId, next_sla_due__c = soonestMliestones ));
                                             
    }
     System.debug(' casesToUpdate-->' + casesToUpdate);
    if (!casesToUpdate.isEmpty()) {
      update casesToUpdate;
    }
  }
    
   /* 
  *   @future method to help to update StartDate   into Case Milestone if Case have future_Action_Date__c populated
  */    
  @future
  public static void copyFutureActionDate(Set<Id> caseIds) {
    List<CaseMilestone> casesMilestoneToUpdate = new List<CaseMilestone>();
    Datetime futureActionD = System.Now();
    for (Case c : [ select Id,  future_Action_Date__c from Case where id in :caseIds ]) {
            
            if(!Test.isRunningTest()){
                CaseMilestone cm  =  [select id,TargetResponseInMins,startDate,TargetDate,CaseId  from CaseMilestone where CaseId =: c.Id limit 1];     
                id bh = [SELECT Id FROM BusinessHours WHERE IsDefault=true and Name = 'BOFI Servicing'].Id; futureActionD = c.future_Action_Date__c;
                System.debug('1.future_Action_Date__c'+futureActionD);
                Long interval = cm.TargetResponseInMins * 60000; Datetime newStartDateBA = BusinessHours.add(bh, futureActionD, -interval); cm.StartDate = newStartDateBA;   casesMilestoneToUpdate.add(cm);
            }
    }

    if (!casesMilestoneToUpdate.isEmpty()) {
      update casesMilestoneToUpdate; List<Case> casesToUpdate = new List<Case>(); for (CaseMilestone milestone :casesMilestoneToUpdate  ){  casesToUpdate.add(new Case(  Id = milestone.CaseId, next_sla_due__c = futureActionD));                          }  update casesToUpdate;
            
    }
        
        
  }

  /*
    Performs the validation when a case is created. If selected account is not related with selected contact, a validation message will be shown to user.
  */

  public void validateContactSelection(){
    for(Case iterator:newList){
      if(!validateCaseRelationship(iterator)){
        iterator.addError('The Contact and Account are not associated. Please make the correct association.');
      }
    }
  }       

  /*
    Query over the case's chosen account related contacts (both directly related and by AccountContactRelation) and verify whether the chosen contact is one of them or not.
  */

  public Boolean validateCaseRelationship(Case caseInstance){
    Set<Id> setValidContactId  = new Set<Id>();
    Boolean blnIsEverythingOk = true;
    if(caseInstance.ContactId != null){
      if(caseInstance.AccountId != null){
        //Queries over the contacts related to the case's chosen account.
        List<Contact> lstRelatedContacts = new List<Contact>();
        try{lstRelatedContacts = [SELECT Id FROM Contact WHERE AccountId =: caseInstance.AccountId];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
        for(Contact iterator:lstRelatedContacts){
          setValidContactId.add(iterator.Id);
        }
        //Queries over AccountContactRelation to take those related contacts.
        List<AccountContactRelation> lstACRelations = new List<AccountContactRelation>();
        try{lstACRelations = [SELECT Id, ContactId FROM AccountContactRelation WHERE AccountId=: caseInstance.AccountId];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
        for(AccountContactRelation iterator:lstACRelations){
          setValidContactId.add(iterator.ContactId);
        }
        if(!setValidContactId.contains(caseInstance.ContactId)){
          blnIsEverythingOk = false;
        }
      }
    }
    return blnIsEverythingOk;
  }     
	    /**
		Method for avoid close a Case with Open Task
        Created by: Astrid 
    */
    public void validateClosedTaskinCase(){
        
        Set<String> recordTypeEPIQ = new Set<String>(); 
        recordTypeEPIQ.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('FS: Banking').getRecordTypeId());
        recordTypeEPIQ.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('FS: Client Management').getRecordTypeId());
        recordTypeEPIQ.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('FS: Client Status Update').getRecordTypeId());
        recordTypeEPIQ.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('FS: Conversion').getRecordTypeId());
        recordTypeEPIQ.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('FS: Hardware').getRecordTypeId());
        recordTypeEPIQ.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('FS: Other').getRecordTypeId());

        //Map of open tasks related to the cases
        Map<Id, Task> taskMap = new Map<Id, Task>();
        //query open tasks related to cases and populate map
        
        for(Task t : [SELECT Id, WhatId FROM Task WHERE IsClosed=false AND WhatId IN :newList ]) {
            taskMap.put(t.WhatId, t);
        }
        Boolean openTask = taskMap.size() > 0;
        //if(taskMap.size() > 0) openTask = true;
        
        //iterate through updated cases and add errors if open tasks exist
        for(Case caseTN : newList) {
          System.debug('----'+caseTN.IsClosed);
            if(oldMap.get(caseTN.Id).Status != newMap.get(caseTN.Id).Status && newMap.get(caseTN.Id).Status == 'Closed' ) {
            //check if the case has any open tasks and has just been changed to closed
            if(openTask && recordTypeEPIQ.contains(caseTN.RecordTypeId)) caseTN.addError('Please complete all your tasks in order to close this case');

        }
        
        }
    }
    

}