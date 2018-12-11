@isTest
public class CaseTriggerHandler_test {
  
    @isTest    
    static void testUpdateFutureDateOrStartDate() {
        Test.startTest();

          Financial_Account__c  f_acc = new Financial_Account__c ();
          f_acc.Name = 'financial Acc Test';
          insert f_acc;
        
      Datetime dtF  = System.now();
      Case caseTest = new Case();
      caseTest.Subject = 'Test Case';
      caseTest.Priority = 'VIP';
      caseTest.Status = 'New';
      caseTest.Origin = 'Web';
      caseTest.Future_Action_Date__c = dtF+5;
      insert caseTest;
         
      Case caseTest2 = new Case();
      caseTest2.Subject = 'Test Case';
      caseTest2.Priority = 'VIP';
      caseTest2.Status = 'New';
      caseTest2.Origin = 'Web';
      insert caseTest2;
        

      Test.stopTest();
        
  }    
    
    
    @isTest    
    static void testCIFUpDate() {
        Test.startTest();

        
        Id accid = [Select id from RecordType where DeveloperName = 'Business_Account_SFDC2' limit 1].Id;
        Id conid = [Select id from RecordType where DeveloperName = 'Business_SFDC2' limit 1].Id;
        Id caseid = [Select id from RecordType where DeveloperName = 'UDB_Inquiry' limit 1].Id;  
        
        Account acc = new Account ();
        acc.Name = 'TestCase';
        acc.CIF_SFDC2__c = '123XYZ';
        insert acc;
        
        Contact cont = new Contact();
        cont.LastName = 'TestCont';
        cont.CIF_SFDC2__c = '123XYZ';
        cont.AccountId = acc.Id;
        insert cont;

      Datetime dtF  = System.now();
      Case caseTest = new Case();
      caseTest.RecordTypeId = caseId;  
      caseTest.Subject = 'Test Case';
      caseTest.Priority = 'Standard';
      caseTest.Status = 'New';
      caseTest.Origin = 'UDB';
      caseTest.UDB_CIF__c = '123XYZ';
      insert caseTest;
         

        

      Test.stopTest();
        
  }

}