@RestResource(urlMapping='/Bofi_UBDCases/*')
global with sharing class Bofi_UBDCaseController {    
      
    @HttpGet
    global static String getUBDCaseById() {
        RestRequest request = RestContext.request;
        // get the caseId from the end of the URL
        String caseId = request.requestURI.substring( request.requestURI.lastIndexOf('/')+1);
        Case result;
        if(caseId != null && caseId != ''){
          result =  [SELECT CaseNumber,Subject,Status,Origin,Priority,Id,Description FROM Case WHERE Id = :caseId];
         
        }
            if (result != null){
                        return result.Id;
            }
            else{
            return 'No Records Found in SF For the Request'+request+'; First Create A Case And The Get The Record.';
            }     
    } 
      
    @HttpPost    
    global static ID createUBDCase(String User_ID, String Category, String Sub_category, String Body_of_the_message, String CIF, String Status, String Phone_Number_related_to_Account, String Email_related_to_Account, String Device_Type, String Browser_Type, String Browser_Version) {
        Case thisCase = new Case(
                    UDB_User_ID__c=User_ID, 
                    UDB_Dropdown_1__c=Category, 
                    UDB_Dropdown_2__c=Sub_category, 
                    //Subject=Body_of_the_message, 
                    Description=Body_of_the_message,
                    UDB_CIF__c=CIF, 
                    Status=Status, 
                    UDB_Phone__c=Phone_Number_related_to_Account, 
                    UDB_Email__c=Email_related_to_Account,
                    Device_Type__c=Device_Type,
                    Browser_Type__c=Browser_Type,
                    Browser_Version__c=Browser_Version,
                    
                    Origin='UDB',
                    recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('UDB Inquiry').getRecordTypeId());
        insert thisCase;

     //   return 'The New Case Id Created in SF is:--'+thisCase.Id;
     return thisCase.Id;
    }     
}