@isTest
public class CaseCheckListController_test {
     @isTest
    static void testCaseCheckListController_test() {
        Test.startTest();

        Id idCRESL = [Select id from RecordType where DeveloperName = 'RLOC_Draw_Cases' and SobjectType ='Case'].Id;
        Case ca = new Case( Status='New',Origin  = 'Inbound Call' );
        insert ca;        
        CaseCheckListController.getCase(ca.Id);
        
        CaseCheckListController.saveCase(ca);
        
        Test.stopTest();
       
        
        
    }
}