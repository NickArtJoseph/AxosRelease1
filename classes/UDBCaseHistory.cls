@RestResource(urlMapping='/UDBCaseHistory/*')
global with sharing class UDBCaseHistory {
    @HttpGet
    global static Case getUDBCaseDetail(){
        RestRequest request = RestContext.request;
        RestResponse res = RestContext.response;
        String cid =  request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);

        List<Case> caseHistory;

        if(cid != null && cid != '') {
            caseHistory = [SELECT casenumber, subject, contact.name, contact.email,LastReferencedDate,UDB_Case_Description__c,Status,CreatedDate, UDB_Subject__c, IsVisibleSelfService__c,                       
                       (SELECT CreatedBy.Name, CreatedDate, Field, NewValue, OldValue                     FROM Histories    ORDER BY CreatedDate      ASC),
                       (SELECT CreatedBy.Name, CreatedDate, Name                                          FROM Attachments  ORDER BY CreatedDate      ASC),
                       (SELECT Owner.Name, ActivityDateTime, Subject, IsVisibleInSelfService              FROM Events       WHERE ActivityDateTime <=:System.Now()   ORDER BY ActivityDateTime ASC),
                      (select Owner.Name, LastModifiedDate, Name, Description__c, Customer_Read__c       from Case.UDB_Secure_Messagings__r where ActivityDate__c <=:System.Today() order by LastModifiedDate) 
                FROM Case 
                WHERE id =:cid];

        }
        if(caseHistory.size() > 0) {
            return caseHistory[0];
        }
        else {
            res.statusCode = 404;
            return null;
        }
    }
}