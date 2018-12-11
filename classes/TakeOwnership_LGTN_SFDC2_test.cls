@isTest
public class TakeOwnership_LGTN_SFDC2_test {
    static testmethod void changeOwner(){
        
        Account account = TestDataFactory.createAndInsertTestPersonAccount();
        RecordType referToType = [select id from RecordType where SObjectType='Opportunity' and Name='Dealership Recruiting SFDC2'];
        Opportunity opp = new Opportunity(
            Name = 'test',
            StageName = '1-New',
            CloseDate=Date.today(),
            AccountId = account.Id,
            RecordTypeId = referToType.Id);
        insert opp;
        
        Opportunity_Queue__c oppQue = new Opportunity_Queue__c(Opportunity__c = opp.Id);
        insert oppQue;
        TakeOwnership_LGTN_SFDC2.changeOwner(String.valueOf(oppQue.Id));
    }
}