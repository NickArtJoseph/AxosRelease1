@isTest
public class CustomFinancialAccountLookup_test {
    
    /*

https://bofi--uat--c.cs77.visual.force.com/apex/CustomFinancialAccountLookup?relatedACc=0010H00002J7b4H&lkfield=00N0H00000Ivp3W&lknm=pg:myForm:newAccount:j_id31:j_id33:6:j_id34&frm=pg%3AmyForm&lksearch=&lksrch=
*/
    @isTest
    static void testCustomFinancialAccountLookupController(){
        
        Id accBA = [Select id from RecordType where Name = 'Business Account SFDC2' ].Id;
        Account acc = new Account ();
        acc.RecordTypeId = accBA;
        acc.Name = 'TestCase';
        acc.CIF_SFDC2__c = '123XYZ';
        insert acc;
        
        Id facRTId = [Select id from RecordType where Name = 'Deposits' and  SobjectType = 'Financial_Account_SFDC2__c' ].Id;
        

          Financial_Account_SFDC2__c  facc = new Financial_Account_SFDC2__c ();
          facc.Name = 'Basic Business Checking 5700';
          
          facc.RecordTypeId  = facRTId;
     
          insert facc;
        
        

        
        Financial_Account_Link_SFDC2__c fa = new Financial_Account_Link_SFDC2__c();
        fa.Account__c = acc.Id; 
        fa.CIF_JHA_LINK__c = 'AAA345178^200100155700^D';
        fa.Financial_Account__c  = facc.id;
        
        insert fa;
        
        Test.setCurrentPageReference(new PageReference('Page.CustomFinancialAccountLookup')); 
        System.currentPageReference().getParameters().put('relatedACc', acc.Id);
        System.currentPageReference().getParameters().put('lkfield', '00N0H00000Ivp3W');
        System.currentPageReference().getParameters().put('lknm', 'pg:myForm:newAccount:j_id31:j_id33:6:j_id34');
        System.currentPageReference().getParameters().put('frm', 'pg%3AmyForm');
        
        CustomFinancialAccountLookupController cfa = new CustomFinancialAccountLookupController();
        
            cfa.getItems();
        cfa.getFilters() ;
        cfa.dateSelected();
        cfa.getLkUpId() ;
        cfa.getLknm() ;
        cfa.getNxt() ;
        cfa.Firstbtn() ; 
        cfa.Nxtbtn() ;
        cfa.lstbtn() ;
        cfa.getPrv() ;
        cfa.dateSelected();
        cfa.getFormTag();  
 
            
     }
    
}