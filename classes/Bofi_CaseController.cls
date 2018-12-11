/***

    Author: Jaime Terrats
    Description: REST Service that allows actions over Case standard object
    
    Version Developer             Date           Description
    1.0     Jaime Terrats JT      02/22/2018     REST service created: Allows cases creation and retrieving
    1.1     René Ayala Medina RAM 04/16/2018     Standards and best practices were applied.
    1.2     René Ayala Medina RAM 06/12/2018     Brand name support added
   
***/

@RestResource(urlMapping='/Bofi_Cases/*')
global class Bofi_CaseController {
      
    /*
        Method that listens to the POST http method.
        It receives data related to the new case to create as well as the parent account to relate a contact.
    */

    @HttpPost
    global static ID createCase(String User_ID, String Salesforce_ID, String Category, String UDB_Subject, String Body_of_the_message, String CIF, String Status, String Phone_Number_related_to_Account, String Email_related_to_Account, String Brand) {        
        Id accountConId = null;
        Id caseId = null;

        //Provided contact is searched. If found, it is assign to the new case
        if(Salesforce_ID != null){
            if(!String.isBlank(Salesforce_ID)){
                Contact contactInstance = new Contact();
                try{contactInstance = [SELECT Id FROM Contact WHERE AccountId = :Salesforce_ID LIMIT 1];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
                if(contactInstance.Id != null){
                    accountConId = contactInstance.Id;
                }
            }
        }
        //New case is created
        Case caseInstance = new Case(
            UDB_User_ID__c = User_ID,  
            AccountId = Salesforce_ID, 
            UDB_Dropdown_1__c = Category, 
            UDB_Subject__c = UDB_Subject, 
            UDB_Case_Description__c = Body_of_the_message,
            UDB_CIF__c = CIF, 
            Status = Status, 
            UDB_Phone__c = Phone_Number_related_to_Account, 
            UDB_Email__c = Email_related_to_Account,
            ContactId = accountConId,
            Origin = Label.UDB_OriginWhenCreatingCaseWSUDB_cl,
            recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('UDB Inquiry').getRecordTypeId(),
            Brand__c = Brand
        );
        Database.SaveResult srInstance =  Database.insert(caseInstance,false);
        if(srInstance.isSuccess()){
            caseId = caseInstance.Id;
        }
        return caseId; 
    } 

}