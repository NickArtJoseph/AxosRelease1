@isTest
public class BF_Conga_Doc_Generate_SFDC2_Test {
    
    static testmethod void generateDocTest(){
        
               Id recordTypeId = Schema.SObjectType.Boarding_Form__c.getRecordTypeInfosByName().get('Pre LOQ Approval').getRecordTypeId();
               Id opprecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('CRESL SFDC2').getRecordTypeId();
        Account acc = new Account(Name='test');
        insert acc;
       
       Opportunity opp = new Opportunity(
            StageName = '1 - New',
            CloseDate = Date.today(),
            AccountId = acc.Id,
           RecordTypeId = opprecordTypeId,
            Name = 'Test Opportunity Triggers'
            
        );
        insert opp;
        APXTConga4__Conga_Merge_Query__c ccq = new APXTConga4__Conga_Merge_Query__c(APXTConga4__Name__c = 'C&I SFDC2: Guarantors to BF');

        APXTConga4__Conga_Merge_Query__c ccq1 = new APXTConga4__Conga_Merge_Query__c(APXTConga4__Name__c = 'C&I SFDC2: Borrowers to BF');
        APXTConga4__Conga_Template__c    cct =  new APXTConga4__Conga_Template__c ( APXTConga4__Name__c  = 'C&I Boarding Form Lightning', APXTConga4__Template_Type__c = 'Document');
        insert ccq;
        insert ccq1;
        insert cct;
        system.debug('ccq' +ccq.Id);
        Loan_Ops_Questionnaire__c LOQFrm = new Loan_Ops_Questionnaire__c(Opportunity__c = opp.Id);
        insert LOQFrm;
        Boarding_Form__c brdFrm = new Boarding_Form__c(Opportunity__c = opp.Id, RecordTypeId = recordTypeId, BF_Status__c = 'BF Approved', Related_LOQ__c = LOQFrm.Id);

        insert brdFrm;      
        Test.startTest();
        BF_Conga_Doc_Generate_SFDC2.generateDocument(String.valueOf(brdFrm.Id));
        Test.stopTest();
    }
}