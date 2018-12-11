/**
* SFDC2: Controller for VF pages used to send Leads for research
* and return them to the requesting business units
*/
public without sharing class RequestLeadResearchSFDC2Controller {
    
    public Lead lead {get; set;}
    public String requestType {get; set;}
    public String notes {get; set;}
    public Group researchGroup;
    
    /** Constructor */
    public RequestLeadResearchSFDC2Controller(ApexPages.StandardController controller) {
        lead = (Lead) controller.getRecord();
        researchGroup = [SELECT Id, Name FROM Group WHERE Type='Queue' AND Name='Research Queue'];
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
* Send a Lead for research
* @param rtName Prospecting record type to send to
* @return Page reference for Lead record view
*/	
    public PageReference sendLead() {
        
        PageReference pr = new PageReference('/' + lead.Id);
        String rtId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Research Activity').getRecordTypeId();
        
        String rtName = null;
        if (lead.RecordTypeId == Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Advisor Firm').getRecordTypeId() ||
            lead.RecordTypeId == Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Business Banking').getRecordTypeId() || 
            lead.RecordTypeId == Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Dealer Services - Dealer').getRecordTypeId()) {
                rtName = 'Prospecting_Business_SFDC2';
            } else {
                rtName = 'Prospecting_Consumer_SFDC2';
            }
        
        RecordType rt = [select Id from RecordType where SObjectType='Lead' and DeveloperName=:rtName];
        List<User> users = [select Id from User where UserRole.Name = 'Research Manager'];
        List<Phone_SFDC2__c> phones = [select Id from Phone_SFDC2__c where Lead__c = :lead.id and Phone_Status__c != 'Bad'];		
        List<Email_SFDC2__c> emails = [select Id from Email_SFDC2__c where Lead__c = :lead.id and Email_Status__c != 'Bad'];		
        
        // Make sure someone has the Research Manager role
        if (users.size() == 0) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'No user can be found with the role of Research Manager. Please contact support.'));
            return null;
        }
        
        // Make sure all the phone numbers have been tried
        if (phones.size() > 0 && requestType == 'PHONE') {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'One or more phone numbers associated with this Lead are not marked as \'Bad\'. '
                                                       + 'Please attempt contact using all available phone numbers before requesting further reasearch.'));
            return null;
        }
        
        // Make sure all the email addresses have been tried
        if (emails.size() > 0 && requestType == 'EMAIL') {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'One or more email addresses associated with this Lead are not marked as \'Bad\'. '
                                                       + 'Please attempt contact using all available email addresses before requesting further reasearch.'));
            return null;
        }
        
        // Make sure the Lead Owner is the one requesting research
        if (lead.OwnerId != UserInfo.getUserId()) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Only the Lead owner may request research.'));
            return null;
        }
        
        // Update the lead record for research
        lead.Return_Owner_SFDC2__c = lead.OwnerId;
        lead.Return_Record_Type_SFDC2__c = lead.RecordTypeId;
        lead.Research_Request_Type_SFDC2__c = requestType;
        lead.Research_Request_Notes_SFDC2__c = notes;
        //lead.OwnerId = users.get(0).Id;
        lead.OwnerId = researchGroup.Id;
        lead.RecordTypeId = rt.Id;
        
        String profileId = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'].Id;
        If(profileId == UserInfo.getProfileId()){
            lead.ConvertLeadSFDC2__c = true;
        }
        
        /*
*  Step-1 : Query Research Group members 
*  Step-2 : Store all group member email Id in a list variable
*  Step-3 : Send Email to all the group members
*/
        Group researchQueue = [SELECT DeveloperName,Id,Name,OwnerId,RelatedId,Type,(SELECT UserOrGroupId FROM GroupMembers) FROM Group WHERE DeveloperName = 'Research_Queue'];
        System.debug(researchQueue );
        List<Id> listOfpublicGroupIds = new List<Id>();
        for(GroupMember grupmemb : researchQueue.GroupMembers){
            listOfpublicGroupIds.add(grupmemb.UserOrGroupId);
        }
        
        List<Group> researchGroupList = [SELECT DeveloperName,Id,Name,OwnerId,RelatedId,Type,(SELECT UserOrGroupId,Group.Type,Group.RelatedId FROM GroupMembers) FROM Group WHERE Id IN :listOfpublicGroupIds];
        
        System.debug(researchGroupList);
        
        List<Id> listOfGroupUserIds = new List<Id>();
        for(Group rsgroup : researchGroupList){
            for(GroupMember grupmemb : rsgroup.GroupMembers){
                if(grupmemb.Group.Type == 'Role')
                    listOfGroupUserIds.add(grupmemb.Group.RelatedId);
                else
                    listOfGroupUserIds.add(grupmemb.UserOrGroupId);
            }   
        }
        for (Group g:[Select RelatedId From Group Where Id IN : listOfGroupUserIds]){
            listOfGroupUserIds.add(g.RelatedId);
        }
        List<String> mailToAddresses = new List<String>();
        
        for(User u : [SELECT Email FROM User WHERE UserRoleId IN :listOfGroupUserIds OR Id IN :listOfGroupUserIds]){
            mailToAddresses.add(u.Email);
        }
        
        System.debug(mailToAddresses);
        
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        String emailBody = lead.Research_Request_Notes_SFDC2__c+ '\n';
        emailBody += baseUrl + '/' + lead.Id;
        
        // Construct an email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(mailToAddresses);
        mail.setSubject('New Research Request');
        mail.setPlainTextBody(emailBody);   
        
        try {
            update lead;
            
            // Send Email to the research group
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
        } catch(Exception ex) {
            ApexPages.addMessages(ex);
            return null;
        }
        
        // Create an activity detailing the research experience
        String taskDesc = 'Requested by ' + UserInfo.getUserName() + ' (' + UserInfo.getUserId() + ') on ' +  System.now() + ' for ' + requestType + '. '; 
        Task researchTask = new Task(OwnerId='005i0000001wnZb', WhoId=lead.Id, Status='Not Started', RecordTypeId=rtId, Description=taskDesc, Subject='Research');
        insert researchTask;
        
        return pr;
        
    }
    
    /**
* Return a researched Lead to the requesting business unit
* @return Page reference for Lead record view
*/
    public PageReference returnLead() {
        
        String rtId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Research Activity').getRecordTypeId();
        
        User reqUser = [select Id, Name from User where Id = :lead.Return_Owner_SFDC2__c];
        List<Task> researchTasks = [select Id, OwnerId, Description from Task 
                                    where WhoId=:lead.Id AND Status!='Completed' AND RecordTypeId=:rtId];
        
        if (lead.OwnerId != UserInfo.getUserId()) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Only the Lead owner may return researched Leads.'));
            return null;
        }
        
        // Update lead record
        lead.RecordTypeId = lead.Return_Record_Type_SFDC2__c;
        lead.OwnerId = lead.Return_Owner_SFDC2__c;
        lead.Return_Owner_SFDC2__c = null;
        lead.Return_Record_Type_SFDC2__c = null;
        lead.Status = 'Researched';
        try {
            update lead;
        } catch(Exception ex) {
            ApexPages.addMessages(ex);
            return null;
        }
        
        // Update or create the research activity for this request
        Task researchTask = null;
        if (researchTasks.size() == 0) {
            String taskDesc = 'Requested ' + lead.Research_Request_Type_SFDC2__c + '. '; 
            researchTask = new Task(OwnerId='005i0000001wnZb', WhoId=lead.Id, Status='Not Started', RecordTypeId=rtId, Description=taskDesc, Subject='Research');
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
* Return to Lead record view after an error message has been displayed
* @return Page reference for Lead record view
*/
    public PageReference cancel() {
        return new PageReference('/' + lead.Id);
    }
    
}