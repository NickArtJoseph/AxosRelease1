@RestResource(urlMapping='/UDB_Case_Details/*')
global with sharing class UDB_Case_Details {
    @HttpGet
    global static List<Case> getUDBCaseByCIF(){
        RestRequest request = RestContext.request;
        String cif =  request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);

        List<Case> casesFromCIF;

        if(cif != null && cif != '') {
            casesFromCIF = [select CaseNumber,Subject,Status,Origin,Priority,Id,UDB_Case_Description__c,RecordType.Name,Owner.Name,UDB_Subject__c,IsVisibleSelfService__c,
                            CreatedDate,LastModifiedDate,(select LastModifiedDate from Case.UDB_Secure_Messagings__r order by LastActivityDate) from Case where CIF_Number__c =: cif or UDB_CIF__c =: cif];
        }

        if(casesFromCIF.size() > 0) {
            return casesFromCIF;
        }
        else {
            return casesFromCIF;
        }
    }
}