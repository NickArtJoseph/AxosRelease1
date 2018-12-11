public class CheckListController {
    @AuraEnabled
    public static Opportunity getOpportunity(String recordId) {
        return [SELECT Id, Document_Tracking_checklist__c FROM Opportunity WHERE Id = :recordId];
    }
    
    @AuraEnabled
    public static Boolean saveOpportunity(Opportunity opp) {
        update opp;
        return true;
    }
}