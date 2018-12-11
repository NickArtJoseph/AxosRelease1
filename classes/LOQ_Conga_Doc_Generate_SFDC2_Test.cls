@isTest
public class LOQ_Conga_Doc_Generate_SFDC2_Test {

     static testmethod void generateDocTest(){
        
        Id opprecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('CRESL SFDC2').getRecordTypeId();
        Account acc = new Account(Name='test');
        insert acc;
       
       Opportunity opp = new Opportunity(
            StageName = 'Open',
            CloseDate = Date.today(),
            AccountId = acc.Id,
           RecordTypeId = opprecordTypeId,
            Name = 'Test Opportunity Triggers'
            
        );
        insert opp;
        APXTConga4__Conga_Merge_Query__c ccq = new APXTConga4__Conga_Merge_Query__c(APXTConga4__Name__c = 'C&I: LOQ Opportunity Fields');
        insert ccq;
        Loan_Ops_Questionnaire__c LOQFrm = new Loan_Ops_Questionnaire__c(Opportunity__c = opp.Id,  Collateral_Type__c = 'Real Estate' ,  Term_Type__c = 'Term', Interest_Rate_Type__c = 'Adjustable' ,
                                                                         Borrower_Relationship__c = 'Direct', Property_Type__c = 'SFR', Collateral_Secured__c = 'Secured', Addl_LOQ_Options__c = 'Committed loan',
                                                                          Collateral_Type_RE__c = 'Notes' , LOQ_Status__c = 'LOQ Approved');

        insert LOQFrm;      
        Test.startTest();
        LOQ_Conga_Doc_Generate_SFDC2.generateDocument(String.valueOf(LOQFrm.Id));
        Test.stopTest();
    }
    
}