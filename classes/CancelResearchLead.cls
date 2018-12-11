global class CancelResearchLead {
    
    webservice static void returnLead(String leadId, String UserId) {
        Lead l = [Select RecordTypeId, Name, OwnerId, Return_Owner_SFDC2__c, Return_Record_Type_SFDC2__c from Lead where Id = :leadId];
        l.RecordTypeId = l.Return_Record_Type_SFDC2__c;
        l.OwnerId = l.Return_Owner_SFDC2__c; 
        l.Return_Record_Type_SFDC2__c = NULL;
        l.Return_Owner_SFDC2__c = NULL;
        Update l;
        String rtId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Standard Task').getRecordTypeId();
        task t = new task();
        t.OwnerId = UserId;
        t.Status = 'Completed';
        t.RecordTypeId = rtId;
        t.Priority = 'Normal';
        t.WhoId = l.Id;
        t.Subject = 'Research Cancelled';
        Insert t;
        
        
        /*  Step-1 : Query Research Group members 
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
        String emailBody = 'The Research Request for '+ l.Name+'  has been cancelled by the requestor \n';
        emailBody += '\n'+ baseUrl + '/' + l.Id;
        
        // Construct an email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(mailToAddresses);
        mail.setSubject('Research Request Cancelled for '+l.Name);
        mail.setPlainTextBody(emailBody);   
        
        try {
                       
            // Send Email to the research group
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
        } catch(Exception ex) {
           System.debug('Exception'+ex);           
        }
        
        
    }
}