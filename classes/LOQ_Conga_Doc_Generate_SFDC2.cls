public class LOQ_Conga_Doc_Generate_SFDC2 {

    @AuraEnabled
    public static String generateDocument(String LOQId){
        system.debug('LOQId' +LOQId);
        Loan_Ops_Questionnaire__c LOQFrm = [SELECT Name, LOQ_Status__c FROM Loan_Ops_Questionnaire__c WHERE Id = :LOQId];
        if(LOQFrm.LOQ_Status__c != 'LOQ Approved')
            return 'Warning: LOQ status should be approved.';
        APXTConga4__Conga_Merge_Query__c Congaquery = [SELECT Id FROM APXTConga4__Conga_Merge_Query__c WHERE APXTConga4__Name__c = 'C&I: LOQ Opportunity Fields'];
        String retURL = '';
        String orgId = UserInfo.getOrganizationId();
        
        retURL = '/apex/APXTConga4__Conga_Composer' + '?sessionId=' + UserInfo.getSessionId() + '&serverUrl=' + URL.getSalesforceBaseUrl().toExternalForm()
            +orgId+'&id=' + LOQId + '&DefaultPDF=0&SC0=1&SC1=Attachments&BML=' + LOQFrm.Name + 'Boarding Form Questionnaire Creation&QueryId=' 
            + Congaquery.Id + '&OFN=' + LOQFrm.Name + '+ Boarding+Form+Questionnaire&TemplateId= a0Ni000001wxUqt';
        return retURL;
    }
}