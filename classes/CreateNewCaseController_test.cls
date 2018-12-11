@isTest
public class CreateNewCaseController_test {
    @isTest
    static void testCreateNewCaseController(){
        
        
        
        
        Id caseRT = [Select id from RecordType where Name = 'LS General Request' and  SobjectType = 'Case' ].Id;
        
        Case tCA = new Case();
         
        tCA.RecordTypeId = caseRT;
        tCa.Priority = 'Standard' ;
        tCA.Status = 'New';
        tCA.Origin = 'Inbound Call';
        tCA.LS_Request_Type__c = 'Name Change - request';
        insert tCA;
        
        test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.CreateNewCase')); 
        System.currentPageReference().getParameters().put('rtdevName', 'LS_General_Request');
        /**
        System.currentPageReference().getParameters().put('lkfield', '00N0H00000Ivp3W');
        System.currentPageReference().getParameters().put('lknm', 'pg:myForm:newAccount:j_id31:j_id33:6:j_id34');
        System.currentPageReference().getParameters().put('frm', 'pg%3AmyForm');
		*/
        ApexPages.StandardController sc = new ApexPages.StandardController(tCA);
        CreateNewCaseController  tNewCase = new CreateNewCaseController(sc);
        tNewCase.doCancel();
        
        test.stopTest();
        
        
    }
}