/**
 * SFDC2: Controller for VF pages designed to send Accounts for research
 * and return them to the requesting business units
 */
global without sharing class RequestAccountResearchSFDC2Controller {
    
    public Account account {get; set;}
    public String requestType {get; set;}
    public String notes {get; set;}
    
    /** Constructor */
    public RequestAccountResearchSFDC2Controller(ApexPages.StandardController controller) {
    	account = (Account) controller.getRecord();
    }
    
    /**
     * Return a list of request types for the Request Type picklist
	 * @return Set of picklist values
	 */     
    public List<SelectOption> RequestTypeList {
    	get {
    		List<SelectOption> requestTypeList = new List<SelectOption>();
    		requestTypeList.add(new SelectOption('PHONE','Bad phone numbers'));
    		requestTypeList.add(new SelectOption('EMAIL','Bad emails'));
    		requestTypeList.add(new SelectOption('ADDRESS','Bad addresses'));
    		requestTypeList.add(new SelectOption('NOT_WITH_COMPANY','Person no longer with company'));
    		requestTypeList.add(new SelectOption('NOT_DECISION_MAKER','Person not a decision maker'));
    		requestTypeList.add(new SelectOption('LINKEDIN','LinkedIn URL is bad'));
    		return requestTypeList;
    	}
    	set;
    }
    
    /**
     * Send an Account for research
     * @return Page reference for Account record view
     */
    public PageReference sendAccount() {
    	
		PageReference pr = new PageReference('/' + account.Id);
    	String rtId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Research Activity').getRecordTypeId();
        Account acc = [Select OwnerId, Name, RecordTypeId From Account Where Id = :account.Id];
		List<User> users = [select Id from User where UserRole.Name = 'Research Manager'];
		List<Phone_SFDC2__c> phones = [select Id from Phone_SFDC2__c where Account__c = :account.id and Phone_Status__c != 'Bad'];		
		List<Email_SFDC2__c> emails = [select Id from Email_SFDC2__c where Account__c = :account.id and Email_Status__c != 'Bad'];		

		// Make sure someone has the Research Manager role
		if (users.size() == 0) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'No user can be found with the role of Research Manager. Please contact support.'));
			return null;
		}
		
		// Make sure all the phone numbers have been tried
		if (phones.size() > 0 && requestType == 'PHONE') {
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'One or more phone numbers associated with this Account are not marked as \'Bad\'. '
			                       + 'Please attempt contact using all available phone numbers before requesting further research.'));
			return null;
		}
		
		// Make sure all the email addresses have been tried
		if (emails.size() > 0 && requestType == 'EMAIL') {
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'One or more email addresses associated with this Account are not marked as \'Bad\'. '
			                       + 'Please attempt contact using all available email addresses before requesting further research.'));
			return null;			
		}
		
		// Make sure this is not a JH customer
		if (account.CIF_SFDC2__c != null && account.CIF_SFDC2__c != '') {
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Research cannot be performed for an Account with a Jack Henry customer record.'));
			return null;	
		}
		
		// Make sure the research request type is selected
		if (requestType == null) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please select a reseach type.'));
			return null;				
		}
		
		// Add research request detail to Account
		if (notes != null) account.Research_Request_Notes_SFDC2__c = Notes;
		if (requestType != null) account.Research_Request_Type_SFDC2__c = requestType;
		account.Research_Requested_By_SFDC2__c = UserInfo.getUserId();

    	// Update RecordType and set user to Research Manager
		try {
			updateAccount(users.get(0).Id);
		} catch (Exception e) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error updating Account: ' + e.getMessage()));
			return null;				
		}	
		
    	// Create an activity detailing the research experience
    	String taskDesc = 'Requested by ' + UserInfo.getUserName() + ' (' + UserInfo.getUserId() + ') on ' +  System.now() + ' for ' + requestType + '. '; 
    	Task researchTask = new Task(OwnerId='005i0000001wnZb', WhatId=account.Id, Status='Not Started', RecordTypeId=rtId, Description=taskDesc, Subject='Research');
    	insert researchTask;

            /*Send Email to Research Manager regarding Research request*/
          
          List<String> mailToAddresses = new List<String>();
        
        for(User u : [SELECT Email FROM User WHERE UserRole.Name = 'Research Manager' ]){
            mailToAddresses.add(u.Email);
        }
        
        System.debug(mailToAddresses);
        
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        String emailBody = 'The Research for '+ acc.Name+' has been requested.';
        emailBody += '\n'+ notes +'\n';
        emailBody += baseUrl + '/' + acc.Id;
        
        // Construct an email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(mailToAddresses);
        mail.setSubject('Research Request for '+acc.Name);
        mail.setPlainTextBody(emailBody);   
        
        try {
                       
            // Send Email to the research group
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
        } catch(Exception ex) {
           System.debug('Exception'+ex);           
        }
          
        
        
        
		return pr;

    }
    
    /**
     * Send a researched Account back to the requesting business unit
     * @return Page reference to Account record view
     */
    public PageReference returnAccount() {
    	
    	String rtId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Research Activity').getRecordTypeId();
    	
    	User reqUser = [select Id, Name from User where Id = :account.Research_Requested_By_SFDC2__c];
    	List<Task> researchTasks = [select Id, OwnerId, Description from Task 
    							where WhatId=:account.Id AND Status!='Completed' AND RecordTypeId=:rtId];
    	
    	// Make sure Account owner is requesting return
    	if (account.OwnerId != UserInfo.getUserId()) {
    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Only the Account owner may return researched Accounts.'));
			return null;
    	}
    	
    	// Update RecordType and set user to API Service Account
    	updateAccount('005i0000001wnZb');
    	
    	// Update or create the research activity for this request
    	Task researchTask = null;
    	if (researchTasks.size() == 0) {
	    	String taskDesc = 'Requested ' + account.Research_Request_Type_SFDC2__c + '. '; 
	    	researchTask = new Task(OwnerId='005i0000001wnZb', WhatId=account.Id, Status='Not Started', RecordTypeId=rtId, Description=taskDesc, Subject='Research');
	    	insert researchTask;    		
    	} else {
    		researchTask = researchTasks.get(0);
    	}
    	
    	researchTask.Description += '\r\nReturned by ' + UserInfo.getUserName() + ' (' + UserInfo.getUserId() + ') on ' + System.now() + '. ';
    	researchTask.Status = 'Completed';
    	researchTask.OwnerId = UserInfo.getUserId();
    	update researchTask;

		// Redirect the user to the newly created activity
    	PageReference pr = new PageReference('/' + researchTask.Id);    	
    	return pr;
    	
    }
    
   
    
    /**
     * Update the Account record type based on the current record type
     * @param newOwnerId Id to assign Account to
     */
    private void updateAccount(Id newOwnerId) { 

		List<String> recordTypeNames = new List<String> {'Prospecting_Consumer_PA_SFDC2', 'Prospecting_Business_Consumer_PA_SFDC2','Prospecting_Business_SFDC2', 
											'Business_Consumer_Person_Account', 'Consumer_Person_Account_SFDC2', 'Business_Account_SFDC2'};
		
		Map<Id,RecordType> recordTypes = new Map<Id,RecordType>([select Id, DeveloperName from RecordType where SObjectType='Account' and DeveloperName IN :recordTypeNames]);
		
		// Assign the appropriate new Record Type
		for (RecordType recordType : RecordTypes.values()) {
			if ((recordType.DeveloperName=='Prospecting_Business_Consumer_PA_SFDC2' && recordTypes.get(account.RecordTypeId).DeveloperName=='Business_Consumer_Person_Account') ||
			    (recordType.DeveloperName=='Prospecting_Consumer_PA_SFDC2' && recordTypes.get(account.RecordTypeId).DeveloperName=='Consumer_Person_Account_SFDC2') ||
			    (recordType.DeveloperName=='Prospecting_Business_SFDC2' && recordTypes.get(account.RecordTypeId).DeveloperName=='Business_Account_SFDC2') ||
			    (recordType.DeveloperName=='Business_Consumer_Person_Account' && recordTypes.get(account.RecordTypeId).DeveloperName=='Prospecting_Business_Consumer_PA_SFDC2') ||
			    (recordType.DeveloperName=='Consumer_Person_Account_SFDC2' && recordTypes.get(account.RecordTypeId).DeveloperName=='Prospecting_Consumer_PA_SFDC2') ||
			    (recordType.DeveloperName=='Business_Account_SFDC2' && recordTypes.get(account.RecordTypeId).DeveloperName=='Prospecting_Business_SFDC2')) { 
			    account.RecordTypeId=recordType.Id; 
			    break;
			}
		}
		
		if (newOwnerId != null) account.OwnerId = newOwnerId;
		
		try { 	
			update account;
		} catch (Exception e) {
			throw e;
		}		    
    }   

    
     /* Cancel Research Request for Account*/
    
      webservice static void cancelresearch(String accountId, String UserId)
      {
          Account acc = [Select OwnerId, Name, RecordTypeId From Account Where Id = :accountId];
                 
          List<String> recordTypeNames = new List<String> {'Prospecting_Consumer_PA_SFDC2', 'Prospecting_Business_Consumer_PA_SFDC2','Prospecting_Business_SFDC2', 
											'Business_Consumer_Person_Account', 'Consumer_Person_Account_SFDC2', 'Business_Account_SFDC2'};
		
		Map<Id,RecordType> recordTypes = new Map<Id,RecordType>([select Id, DeveloperName from RecordType where SObjectType='Account' and DeveloperName IN :recordTypeNames]);
		
		// Assign the appropriate new Record Type
		for (RecordType recordType : recordTypes.values()) {
			if ((recordType.DeveloperName=='Prospecting_Business_Consumer_PA_SFDC2' && recordTypes.get(acc.RecordTypeId).DeveloperName=='Business_Consumer_Person_Account') ||
			    (recordType.DeveloperName=='Prospecting_Consumer_PA_SFDC2' && recordTypes.get(acc.RecordTypeId).DeveloperName=='Consumer_Person_Account_SFDC2') ||
			    (recordType.DeveloperName=='Prospecting_Business_SFDC2' && recordTypes.get(acc.RecordTypeId).DeveloperName=='Business_Account_SFDC2') ||
			    (recordType.DeveloperName=='Business_Consumer_Person_Account' && recordTypes.get(acc.RecordTypeId).DeveloperName=='Prospecting_Business_Consumer_PA_SFDC2') ||
			    (recordType.DeveloperName=='Consumer_Person_Account_SFDC2' && recordTypes.get(acc.RecordTypeId).DeveloperName=='Prospecting_Consumer_PA_SFDC2') ||
			    (recordType.DeveloperName=='Business_Account_SFDC2' && recordTypes.get(acc.RecordTypeId).DeveloperName=='Prospecting_Business_SFDC2')) { 
			    acc.RecordTypeId=recordType.Id; 
			    break;
			}
		}
		
		if (UserId != null) acc.OwnerId = UserId;
		
		try { 	
			update acc;
		} catch (Exception e) {
			throw e;
		}		    
         
        String rtId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Standard Task').getRecordTypeId();
        task t = new task();
        t.OwnerId = UserId;
        t.Status = 'Completed';
        t.RecordTypeId = rtId;
        t.Priority = 'Normal';
        t.WhatId = acc.Id;
        t.Subject = 'Research Cancelled';
        Insert t;
        
          
        /*Send Email to Research Manager regarding Cancel Research request*/
          
          List<String> mailToAddresses = new List<String>();
        
        for(User u : [SELECT Email FROM User WHERE UserRole.Name = 'Research Manager' ]){
            mailToAddresses.add(u.Email);
        }
        
        System.debug(mailToAddresses);
        
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        String emailBody = 'The Research Request for '+ acc.Name+'  has been cancelled by the requestor \n';
        emailBody += '\n'+ baseUrl + '/' + acc.Id;
        
        // Construct an email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(mailToAddresses);
        mail.setSubject('Research Request Cancelled for '+acc.Name);
        mail.setPlainTextBody(emailBody);   
        
        try {
                       
            // Send Email to the research group
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
        } catch(Exception ex) {
           System.debug('Exception'+ex);           
        }
          
          
      }
        
    
    
	/**
	 * Return to Lead record view after an error message has been displayed
	 * @return Page reference for Lead record view
	 */
	public PageReference cancel() {
		return new PageReference('/' + account.Id);
	}

}