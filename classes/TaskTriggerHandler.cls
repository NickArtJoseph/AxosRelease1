/**
* @description <p>Handler class for TaskTrigger functionality</p>
* @author Mike Crosby, BofI Federal 
*/
public class TaskTriggerHandler extends TriggerHandler {

  /** Map of Tasks before changes */
  private Map<Id, Task> oldTaskMap;
  /** Map of Tasks with changes */
  private Map<Id, Task> newTaskMap;
  /** List of Tasks prior to insert */
  private List<Task> newList;
  
  /** Constructor */
  public TaskTriggerHandler() {
    this.oldTaskMap = (Map<Id, Task>) Trigger.oldMap;
    this.newTaskMap = (Map<Id, Task>) Trigger.newMap;
    this.newList = (List<Task>) Trigger.new;
  }
  
  /**
  * Process beforeInsert logic
  */
  public override void beforeInsert() {
    handleNeustarFieldPopulation();
    handleEmailToSalesforceType();
  }
  
  /**
  * Process afterInsert logic
  */
  public override void afterInsert() {
    handleTasksAssociatedWithPhoneNumbers(null, this.newTaskMap);
    //SFDC2
    handleParentLastActivityDateUpdate();
    handleIsVisibleSelfService();
  }
  
  /**
  * Process afterUpdate logic
  */
  public override void afterUpdate() {
    handleTasksAssociatedWithPhoneNumbers(this.oldTaskMap, this.newTaskMap);
    //SFDC2
    handleParentLastActivityDateUpdate();
  }
  
  /**
  * Handles logic for update the parent Lead or Opportunity with the Last Activity Date value
  * for use with reassignment based on 30 day inactivity
  */
  private void handleParentLastActivityDateUpdate() {
  	Map<Id, Profile> profileMap = new Map<Id, Profile>([SELECT Name FROM Profile WHERE (Name = 'System Administrator' OR Name LIKE 'Marketing%' or Name LIKE 'Salesforce%')]);
  	if(!profileMap.containsKey(UserInfo.getProfileId())) {
	  	Set<String> idSet = new Set<String>();
	  	for(Task t : newTaskMap.values()) {
	  		if(t.WhoId != null && ((String)t.WhoId).startsWith('00Q')) {
	  			idSet.add(t.WhoId);
	  		}
	  		if(t.WhatId != null && ((String)t.WhatId).startsWith('006')) {
	  			idSet.add(t.WhatId);
	  		}
	  	}
	  	for(String objId : idSet) {
	  		if(objId.startsWith('00Q')) {
	  			toUpdate.add(new Lead(Id=objId, Last_Activity_SFDC2__c = Date.today()));
	  		} else if (objId.startsWith('006')) {
	  			toUpdate.add(new Opportunity(Id=objId, Last_Activity_SFDC2__c = Date.today()));
	  		}
	  	}
  	}
  }
  

  private void handleIsVisibleSelfService() {
    String rtId = Schema.SobjectType.Task.getRecordTypeInfosByName().get('UDB Comment').getRecordTypeId();
    List<Task> taskList =  new List<Task>();
    String caseId;
    Case c;
    for(Task setIsVisble : [select Customer_Read__c, WhatId from Task where Id =:newList and Customer_Read__c = null and RecordTypeId =: rtId]) {
      caseId = setIsVisble.WhatId;
      System.debug('Whats the caseId: ' + caseId);
      taskList.add(setIsVisble);
    }

    if(taskList.size() > 0 ) {
      c = [select Id, IsVisibleSelfService__c from case where Id =: caseId];
      c.IsVisibleSelfService__c = true;
      update c;
    }
  }

  /**
  * Handles logic for setting Type field to Email when Task is created from Email to Salesforce functionality
  */
  private void handleEmailToSalesforceType() {
    for(Task t : newList) {
        if(t.Subject != null && t.Subject.startsWith('Email:') && (t.Type == null || t.Type == '')) {
            t.Type = 'Email';
        }
    }
  }
    
  /**
  * Handles the logic for populating Spec Finance Neustar fields with phone data
  */
  private void handleNeustarFieldPopulation() {
    Set<Id> relatedPhoneSet = new Set<Id>();
    for(Task t : newList) {
        if(t.WhatId != null && t.WhatId.getSObjectType() == Schema.Phone_Number__c.getSobjectType()) {
            relatedPhoneSet.add(t.WhatId);
        }
    }
    
    if(relatedPhoneSet.size() > 0) {
        for(Phone_Number__c ph : [SELECT Neustar_MPIC_Phone_Score__c, Neustar_Phone_Validation__c FROM Phone_Number__c WHERE Id in :relatedPhoneSet]) {
            for(Task t : newList) {
                if(t.WhatId == ph.Id) {
                    t.Neustar_MPIC_Phone_Score__c = ph.Neustar_MPIC_Phone_Score__c;
                    t.Neustar_Phone_Validation__c = ph.Neustar_Phone_Validation__c;
                }
            }
        }
    }
  }
  
  /**
  * Handles logic for Tasks that are associated with custom Phone Number records including InsideSales data
  * @param oldMap map of Tasks with values before save
  * @param newMap map of Tasks with values after save
  */
  private void handleTasksAssociatedWithPhoneNumbers(Map<Id,Task> oldMap, Map<Id,Task> newMap) {
    Map<Id,Phone_Number__c> phoneNumberUpdateMap = updatePhoneNumberStatusOnClosedTask(newMap.values());
    Map<Id,Account> accountStatusUpdateMap = updateAccountSalesStatusOnConfirmed(newMap.values());
    Map<Id,Account> accountInsideSalesUpdateMap = populateAccountWithInsideSalesCallData(oldMap, newMap);
    
    toUpdate.addAll((List<sObject>)phoneNumberUpdateMap.values());
    
    if(accountInsideSalesUpdateMap == null || accountInsideSalesUpdateMap.size() == 0) {
        toUpdate.addAll((List<sObject>)accountStatusUpdateMap.values());
    }
    else {
      for(Account account : accountInsideSalesUpdateMap.values()) {
        if(accountStatusUpdateMap.containsKey(account.Id)) {
          account.Sales_Status_Person__c = accountStatusUpdateMap.get(account.Id).Sales_Status_Person__c;
        }
        toUpdate.add((sObject)account);
      }
    }
  }
  
  /**
  * <i>Written by prior developer, may need to review</i>
  */
  private Map<Id, Phone_Number__c> updatePhoneNumberStatusOnClosedTask(List<Task> tasks) {
    Map<Id,Phone_Number__c> phoneNumbersMap = new Map<Id, Phone_Number__c>();
    // Create a map of Phone Number id to Status.
    Map<Id,String> phoneNumberStatusMap = new Map<Id,String>();
        
    for( Task task : tasks ) {
            
      // Check to see if this Task 
      //  1) Is related to a Phone Number
      //  2) Has a disposition set.
      //  3) Is Closed
      if( task.WhatId != null &&
          task.WhatId.getSObjectType() == Phone_Number__c.Schema.SObjectType &&
          !String.isBlank( task.CallDisposition ) &&
          task.IsClosed
         ) {
              
        // Add phone number id and disposition
        phoneNumberStatusMap.put( task.WhatId, task.CallDisposition );
      }
    }
        
    // Ignore if there aren't any Phone Numbers to update.
    if(phoneNumberStatusMap.size() == 0 ) {
      return phoneNumbersMap;
    }
        
    // Query for the Phone Numbers to update.
    phoneNumbersMap = new Map<Id,Phone_Number__c>   ( [
                                                       SELECT   Id,
                                                                Account_Name__c,
                                                                Status__c
                                                       FROM Phone_Number__c
                                                       WHERE    Id IN :phoneNumberStatusMap.keySet()
                                                       ] );
        
    // Update the Status on the Phone Number records.
    for( Phone_Number__c phoneNumber : phoneNumbersMap.values() ) {
      phoneNumber.Status__c = phoneNumberStatusMap.get( phoneNumber.Id );
    }
        
    return phoneNumbersMap;
  }
  
  /**
  * <i>Written by prior developer, may need to review</i>
  */
  private Map<Id, Account> updateAccountSalesStatusOnConfirmed(List<Task> tasks) {
    Map<Id, Account> accountsToUpdate = new Map<Id, Account>();
    // Create a set for confirmed Accounts
    Set<Id> confirmedAccounts = new Set<Id>();
    for( Task task : tasks ) {

      // Check to see if this Task 
      //  1) Is related to a Phone Number
      //  2) Has a disposition set.
      //  3) Disposition = Correct Contact
      if( task.WhatId != null &&
          task.WhatId.getSObjectType() == Phone_Number__c.Schema.SObjectType &&
          !String.isBlank( task.CallDisposition ) &&
          task.IsClosed &&
          task.CallDisposition.toUppercase().equals( 'CORRECT CONTACT' ) 
         ) {
          confirmedAccounts.add(task.AccountId);
      }
    }
     
    // Check to see if there are any confirmed Accounts.
    if( confirmedAccounts.size() > 0 ) {
           
      // Query for the Accounts to update.
      for(Account account : [
                                 SELECT Id, Sales_Status_Person__c
                                 FROM   Account
                                 WHERE  Id IN :confirmedAccounts
                                ]
                                ) {
        // Update the Accounts with the appropriate Sales Status.
        if( String.isBlank( account.Sales_Status_Person__c ) ||
            ( !String.isBlank( account.Sales_Status_Person__c ) && account.Sales_Status_Person__c.equals( 'No Contact' ) ) 
           ) {
          account.Sales_Status_Person__c = 'Contact Made';
          accountsToUpdate.put(account.Id, account);
        }
      }
    }
   return accountsToUpdate;
  }
  
  /**
  * For calls triggered through InsideSales, Dials and LastCallTime are not 
  * properly updated due to custom Phone Number object. 
  * This method identifies Tasks created via this process and updates the corresponding
  * Account with the latest call data
  * @param oldMap map of Tasks records before update
  * @param newMap map of Task records after update
  */
  private Map<Id, Account> populateAccountWithInsideSalesCallData(Map<Id,Task> oldMap, Map<Id,Task> newMap) {
    //establish a map of Tasks that were updated from InsideSales
    Map<Id, Task> tasksToProcess = new Map<Id, Task>();
    Map<Id,Account> accountMap = new Map<Id,Account>();
    Set<Id> accountIdSet = new Set<Id>();
    //MCC 2015-03-02 - added functionality to increment Current Rep Dials on outbound task creation
    Map<Id,Integer>currentRepDialsMap = new Map<Id,Integer>();
    Boolean updateCurrentRepDials = false;
    
    for(Task newTask : newMap.values())
    {
      if(newTask.AccountId == null) {
        //skip Tasks not associated with Accounts
        continue;
      }
      if(oldMap == null)
      {
        //handle newly created tasks
        System.debug('Handling inserted tasks');
        if(newTask.qbdialer__ImpressionId__c != null) {
          if(newTask.CallType == 'Outbound' || newTask.CallType == 'Inbound') {
            accountIdSet.add(newTask.AccountId);
            tasksToProcess.put(newTask.Id, newTask);
          }
          //MCC 2015-03-02 - added functionality to increment Current Rep Dials on outbound task creation
          if(newTask.CallType == 'Outbound') {
            if(!currentRepDialsMap.containsKey(newTask.AccountId)) {
                currentRepDialsMap.put(newTask.AccountId,0);
            }
            currentRepDialsMap.put(newTask.AccountId, currentRepDialsMap.get(newTask.AccountId) + 1);
            updateCurrentRepDials = true;
          }
        }
      }
      else
      {
        //handle updated tasks
        System.debug('Handling updated tasks');
        Task oldTask = oldMap.get(newTask.Id);
        if((oldTask.qbdialer__Call_Dial_Number__c != newTask.qbdialer__Call_Dial_Number__c ||
           oldTask.qbdialer__Call_Date_Time__c != newTask.qbdialer__Call_Date_Time__c) &&
           newTask.qbdialer__ImpressionId__c != null &&
           (newTask.CallType == 'Outbound' || newTask.CallType == 'Inbound'))
        {
          accountIdSet.add(newTask.AccountId);
          tasksToProcess.put(newTask.Id, newTask);
        }
      }
    }

    if(tasksToProcess.size() == 0)
    {
      //no Tasks related to InsideSales to process 
      System.debug('No tasks affected by InsideSales');
      return accountMap;
    }

    System.debug('Tasks to process: ' + tasksToProcess.size());

    //MCC 2015-03-02 - added functionality to increment Current Rep Dials on outbound task creation
    //need to look up existing Current Rep Dials values for existing Accounts
    if(updateCurrentRepDials)
    {
        for(Account a : [
                         select 
                           Id, Current_Rep_Dials__c 
                         from Account 
                         where Id in :currentRepDialsMap.keySet()
                        ]) {
          if(!accountMap.containsKey(a.Id)) {
            accountMap.put(a.Id, a);            
          }
          Decimal dials = 0;
          if(a.Current_Rep_Dials__c != null) {
            dials = a.Current_Rep_Dials__c;
          }
          accountMap.get(a.Id).Current_Rep_Dials__c = dials + currentRepDialsMap.get(a.Id);
        }
    }

    //For all accounts related to the tasks, aggregate the call count and find the max calldatetime to populate on
    //the account [Note: InsideSales CallDialNumber on task does not appear to be reliable--delay in reporting call
    //count and the call count does not seem to be precise]
    List<AggregateResult> taskAggregationForAccounts = 
                         [
                          Select AccountId, 
                          CallType,
                          max(qbdialer__Call_Date_time__c) maxdate, 
                          count(qbdialer__ImpressionId__c) cnt 
                          From Task 
                          Where AccountId in :accountIdSet and
                          CallType in ('Outbound', 'Inbound') 
                          group by AccountId, CallType
                         ];
    if(taskAggregationForAccounts.size() == 0) {
      System.debug('No accounts located');
      return accountMap;
    }
    
    System.debug('Located ' + taskAggregationForAccounts.size() + ' accounts to update');
    
    //since the aggregate results are broken out by calltype (inbound vs outbound) create a set
    //so that we can update the appropriate fields on the affected account based on calltype
    
    for(AggregateResult ar : taskAggregationForAccounts) {
      Id accountId = (Id)ar.get('AccountId');
      String callType = (String)ar.get('CallType');
      Decimal callCount = (Decimal)ar.get('cnt');
      Datetime lastCall = (Datetime)ar.get('maxdate');
      
      if(!accountMap.containsKey(accountId)) {
        accountMap.put(accountId, new Account(Id=accountId));
      }
      if(callType.toLowerCase() == 'outbound')
      {
        //only count outbound calls for Dials value
        accountMap.get(accountId).qbdialer__Dials__c = callCount;
      }
      if(accountMap.get(accountId).qbdialer__LastCallTime__c == null ||
         accountMap.get(accountId).qbdialer__LastCallTime__c < lastCall) {
        //capture latest call time regardless of inbound/outbound
        accountMap.get(accountId).qbdialer__LastCallTime__c = lastCall;
      }
    }
    return accountMap;
  }
  
}