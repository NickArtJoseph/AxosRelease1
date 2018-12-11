public class BF_Conga_Doc_Generate_SFDC2 {

    @AuraEnabled
    public static String generateDocument(String boardingFormId){
        
        Boarding_Form__c brdFrm = [SELECT Name, BF_Status__c FROM Boarding_Form__c WHERE Id = :boardingFormId];
        if(brdFrm.BF_Status__c != 'BF Approved')
            return 'Warning: Boarding form status should be approved.';
        
        String Congaquery;
        String Congaquery1;
       // if(!test.isRunningTest()){
            Congaquery = [SELECT Id FROM APXTConga4__Conga_Merge_Query__c WHERE APXTConga4__Name__c = 'C&I SFDC2: Borrowers to BF' limit 1].Id;
        	Congaquery1 = [SELECT Id FROM APXTConga4__Conga_Merge_Query__c WHERE APXTConga4__Name__c = 'C&I SFDC2: Guarantors to BF' limit 1].Id;
            String template = [select Id from APXTConga4__Conga_Template__c where APXTConga4__Name__c  = 'C&I Boarding Form Lightning'].Id;
        //}
       
        //a0Ni000001wxUq5
        String retURL = '';
        String orgId = UserInfo.getOrganizationId();
        
        retURL = '/apex/APXTConga4__Conga_Composer' + '?sessionId=' + UserInfo.getSessionId() + '&serverUrl=' + URL.getSalesforceBaseUrl().toExternalForm() +orgId+'&id=' + boardingFormId + '&DefaultPDF=0&SC0=1&SC1=Attachments&BML=' + brdFrm.Name + ' Boarding Form Creation&TemplateGroup=CI_BF&OFN=' + brdFrm.Name +
                 '+Boarding+Form&TemplateId=' + template + '&QueryId=[Borrowers]' + Congaquery+ ',[Guarantors]' + Congaquery1;

        return retURL;
    }
}