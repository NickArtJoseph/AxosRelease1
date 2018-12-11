@isTest
public class CheckListController_Test {
  @isTest
    static void testCheckListController() {
        Test.startTest();
     //create a test account
        Account a = new Account(Name='Test');
        insert a;
        Id idCRESL = [Select id from RecordType where DeveloperName = 'CRESL_SFDC2' and SobjectType ='Opportunity'].Id;
        Opportunity o = new Opportunity(AccountId=a.Id, Name='Test', StageName='3 - Committed to Complete Application', C_I_Sub_Stage__c = 'Terms Negotiation', LeadSource='Other', CloseDate=Date.today() ,  RecordTypeId=idCRESL, Document_Tracking_checklist__c = 'Construction Loan');
        insert o;        
        CheckListController.getOpportunity(o.Id);
        
        CheckListController.saveOpportunity(o);
        
        Test.stopTest();
       
        
        
    }
}