public class TakeOwnership_LGTN_SFDC2 {
    
    //public TakeOwnership_LGTN_SFDC2() {}
    
    @AuraEnabled
    public static String changeOwner(String oppQueueId) {
        Opportunity_Queue__c oppQueue = [SELECT Opportunity__c, Owner.Name FROM Opportunity_Queue__c WHERE Id = :oppQueueId LIMIT 1];
        string RoleName = [Select Name From UserRole where Id = :UserInfo.getUserRoleId()].Name;
        System.debug(oppQueue.Owner.Name+ ' oppQueue.Owner.Name' +RoleName);    
        
        if(oppQueue.Owner.Name == 'C&I CRESL SFDC2' && (RoleName != 'C&I Manager - LF & CRESL' && RoleName != 'C&I - LF & CRESL' ))  return 'Error : Dont have permission to take ownership';
        if(oppQueue.Owner.Name == 'C&I EQF SFDC2' && (RoleName != 'C&I Manager - EQF' && RoleName != 'C&I - EQF' ))  return 'Error : Dont have permission to take ownership';
        if(oppQueue.Owner.Name == 'C&I Factoring SFDC2' && (RoleName != 'C&I Manager - Factoring' && RoleName != 'C&I - Factoring' ))  return 'Error : Dont have permission to take ownership';
        if(oppQueue.Owner.Name == 'C&I RELF SFDC2' && (RoleName != 'C&I Manager - LF & CRESL' && RoleName != 'C&I - LF & CRESL' ))  return 'Error : Dont have permission to take ownership';
        if(oppQueue.Owner.Name == 'C&I NRELF SFDC2' && (RoleName != 'C&I Manager - LF & CRESL' && RoleName != 'C&I - LF & CRESL' ))  return 'Error : Dont have permission to take ownership';
        if(oppQueue.Owner.Name == 'Consumer Deposits Opportunity Queue' && (RoleName != 'Consumer Deposits Manager' && RoleName != 'Consumer Deposits' ))  return 'Error : Dont have permission to take ownership';
        if(oppQueue.Owner.Name == 'Advisor Opportunity Queue' && (RoleName != 'Financial Advisor Mgr' && RoleName != 'Financial Advisor Rep' ))  return 'Error : Dont have permission to take ownership';
        if(oppQueue.Owner.Name == 'Auto-Lending Opportunity Queue' && (RoleName != 'Dealer Services Rep' && RoleName != 'Dealer Services Manager' ))  return 'Error : Dont have permission to take ownership';
        if(oppQueue.Owner.Name == 'Business Banking Opportunity Queue' && (RoleName != 'Business Banking Manager' && RoleName != 'Business Banking' ))  return 'Error : Dont have permission to take ownership';
        if(oppQueue.Owner.Name == 'HBD Opportunity Queue' && (RoleName != 'HBD Manager' && RoleName != 'HBD' ))  return 'Error : Dont have permission to take ownership';
        if(oppQueue.Owner.Name == 'Virtus Opportunity Queue' && (RoleName != 'Virtus Manager' && RoleName != 'Virtus Rep' ))  return 'Error : Dont have permission to take ownership';
        
        Opportunity opp = new Opportunity(Id = oppQueue.Opportunity__c);
        opp.OwnerId = UserInfo.getUserId();
        update opp;
        
        oppQueue.ownerId = UserInfo.getUserId();
        update oppQueue;
        return opp.Id;
        
    }
}