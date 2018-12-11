@RestResource(urlMapping='/Bofi_HRB_Refund/*')
global with sharing class Bofi_HRB_RefundController {    
    
    @HttpPost
    global static ID createHRB_Refund(String Application_Status, String City, String Client_Preferred_Phone, Integer Current_Year_Tax_Refund_Amount, Datetime Date_And_Timestamp_Received, Date Date_Of_Birth, Date Date_Processed, String Filing_Status, String First_Name, String Last_Name, String Middle_Name, String Refund_Advance_Application_ID, String SSN_TIN, String State, String Street, String Zip_Code) {
        HRB_Refund_Advance__c thisHRB_Refund = new HRB_Refund_Advance__c(
                    //Application_Status__c = Application_Status,
                    City__c = City,
                    Client_Preferred_Phone__c = Client_Preferred_Phone,
                    Current_Year_Tax_Refund_Amount__c = Current_Year_Tax_Refund_Amount,
                    CreatedAt__c = Date_And_Timestamp_Received,
                    Date_And_Timestamp_Received__c = Date_And_Timestamp_Received,
                    Date_Of_Birth__c = Date_Of_Birth,
                    Date_Processed__c = Date_Processed,
                    Filing_Status__c = Filing_Status,
                    First_Name__c = First_Name,
                    Last_Name__c = Last_Name,
                    Middle_Name__c = Middle_Name,
                    Refund_Advance_Application_ID__c = Refund_Advance_Application_ID,
                    SSN_TIN__c = SSN_TIN,
                    State__c = State,
                    Street__c = Street,
                    Zip_Code__c = Zip_Code);
                    
            insert thisHRB_Refund; 

       return thisHRB_Refund.Id; 
     
    }  
}