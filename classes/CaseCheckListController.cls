public class CaseCheckListController {
    @AuraEnabled
    public static Case getCase(String recordId) {
        return [SELECT Id, Document_Tracking__c FROM Case WHERE Id = :recordId];
    }
    
    @AuraEnabled
    public static Boolean saveCase(Case Ca) {
        update Ca;
        return true;
    }

}