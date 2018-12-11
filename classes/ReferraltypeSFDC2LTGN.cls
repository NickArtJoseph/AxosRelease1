public class ReferraltypeSFDC2LTGN {
    @AuraEnabled
 public static ReferralTypeData getInitData(String accountId){
        ReferralTypeData refTypData = new ReferralTypeData();
        refTypData.checkUser = checkUser(accountId);
        refTypData.referToList = getRecTypes();
        refTypData.checkAccess = (refTypData.referToList.size() > 0) ? true : false;
        return refTypData;  
                
    }
    
    public static Boolean checkUser(String accountId){
        List<Opportunity> opps = [select Id, OwnerId from Opportunity where Id=:accountId and IsClosed=false];
        if (opps == null) {
            return false;
        } else {
            for (Opportunity opp : opps) {
                if (opp.OwnerId == UserInfo.getUserId()) return true;
            }
            return false;
        }
    }
    
    @AuraEnabled
    public static void create(String accountId, String refTo, String Notes) {
		User user = [select Id, Name, UserRole.Name from User where id=:UserInfo.getUserId()];
        System.debug('refTo: ' + refTo);
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(refTo).getRecordTypeId();
        Opportunity opps = [select AccountId from Opportunity where Id=:accountId];
		Opportunity opp = new Opportunity(Name='Referral from ' + user.UserRole.Name, AccountId=opps.AccountId, CloseDate=Date.Today().addMonths(1),
										  Referred_By_SFDC2__c=user.Id, Referrer_Notes_SFDC2__c=Notes, RecordTypeId=recordTypeId,
										  LeadSource='Cross-Sell', StageName='1 - New', isReferred__c=true);
        TriggerLoopExecutionControl_cls.setAlreadyBeenExecuted('OpportunityTrigger');
        TriggerLoopExecutionControl_cls.setAlreadyBeenExecuted('AccountTrigger');
        insert opp;
        System.debug('88888 '+refTo);
        String queueName = [select Queue_Name__c from Manager_SFDC2__mdt  where RecordType_Name__c =:refTo ].Queue_Name__c;

        queueName = '%'+queueName+'%';

        Group referralQueue = [select Id,Name,OwnerId,RelatedId,Type,(select UserOrGroupId from GroupMembers) from Group where Name like :queueName and type = 'Queue'];
        System.debug('Referal Queue Items: ' + referralQueue);
        List<Id> publicGrpsIds = new List<Id>();
        for(GroupMember gm : referralQueue.GroupMembers) {
            publicGrpsIds.add(gm.UserOrGroupId);
            System.debug('List from public groups Ids: ' + publicGrpsIds);
        }


        List<Group> referralGroup = [select Id, Name, OwnerId, RelatedId, Type,(select UserOrGroupId, Group.Type, Group.RelatedId from GroupMembers) from Group where Id in : publicGrpsIds];
        System.debug('Referral Group: ' + referralGroup);

        List<Id> groupUserIds = new List<Id>();
        for(Group rfGroup : referralGroup) {
            for(GroupMember gpMmbr : rfGroup.GroupMembers) {
                if(gpMmbr.Group.Type == 'Role') {
                    groupUserIds.add(gpMmbr.Group.RelatedId);
                }
                else {
                    groupUserIds.add(gpMmbr.UserOrGroupId);
                }
            }
        }

        for(Group theGroup : [select RelatedId from Group where Id in :groupUserIds]) {
            groupUserIds.add(theGroup.RelatedId);
        }
        System.debug(groupUserIds);

        List<String> mailToReferredGroup = new List<String>();
        for(User usr : [select Email from User where UserRoleId in :publicGrpsIds or Id in :publicGrpsIds]) {
            mailToReferredGroup.add(usr.Email);
        }

        System.debug('Email address: ' + mailToReferredGroup);

        String instance = System.URL.getSalesforceBaseUrl().toExternalForm();
        String emailBody = opp.Referrer_Notes_SFDC2__c+'\n';
        emailBody += instance+'/'+opp.Id;

        System.debug(emailBody);

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(mailToReferredGroup);
        mail.setSubject('Opportunity Referral for ' + opp.Name);
        mail.setPlainTextBody(emailBody);

        try {
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
        }
        catch(Exception e) {
            System.debug('Error: ' + e);
        }
	}
    
    @AuraEnabled
    public static List<Map<String, String>> getRecordTypes() {
        
        System.debug('getRecordTypes starting...');
        
        List<Map<String, String>> items = new List<Map<String, String>>();
        for (RecordType rt : [
            SELECT id, name
            FROM RecordType
            WHERE SobjectType = 'IP__c'
        ]) {
            items.add(new Map<String, String>{'value' => rt.Id, 'label' => rt.Name});
        }
        return items;
    }    
    
    
    
    
    public static List<String> getRecTypes(){
        List<String> referToList = new List<String>();
        for(RecordTypeInfo info: Opportunity.SObjectType.getDescribe().getRecordTypeInfos()) {
            if((   info.getName() == 'Advisor Recruiting SFDC2'
                || info.getName() == 'Advisory SFDC2'
                || info.getName() == 'Auto Loan Indirect SFDC2'
                || info.getName() == 'Business Banking SFDC2'
                || info.getName() == 'CRESL SFDC2'
                || info.getName() == 'Commercial Banking SFDC2'
                || info.getName() == 'Consumer Deposits SFDC2'
                || info.getName() == 'Consumer Wholesale SFDC2'
                || info.getName() == 'Consumer Direct SFDC2'
                || info.getName() == 'Dealer Services - Applicant SFDC2'
                || info.getName() == 'Dealership Recruiting SFDC2'
                || info.getName() == 'EQF SFDC2'
                || info.getName() == 'Epiq SFDC2'
                || info.getName() == 'Factoring SFDC2'
                || info.getName() == 'HBD SFDC2'
                || info.getName() == 'IPL SFDC2'
                || info.getName() == 'NRELF SFDC2'
                || info.getName() == 'RELF SFDC2'
                || info.getName() == 'ULP SFDC2'
                || info.getName() == 'Virtus SFDC2'                
               )
               && info.isAvailable() == false) {
                   referToList.add(info.getName());
               }
        }
        return referToList;
    }
    
    public static void sendMail() {
        // Send email to opp Queue
    }

    public class ReferralTypeData{
        @AuraEnabled public String referTo;
        @AuraEnabled public Boolean checkUser;
        @AuraEnabled public Boolean checkAccess;
        @AuraEnabled public List<String> referToList;
    }
}