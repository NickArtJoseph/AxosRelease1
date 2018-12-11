@isTest
public class QuickTextTriggerHandler_Test {
    @isTest 
    static void insertNewQuickTextRecord(){
        QuickText newQuickText = new QuickText();
        newQuickText.Name = 'Insert Test';
        newQuickText.Message = 'Insert Test';
        newQuickText.Category = 'Insert Test';
        newQuickText.Business_Units__c = 'Advisor';
        insert newQuickText;
        
    }
    @isTest
    static void updateNewQuickTextRecord(){
        QuickText newQuickText = new QuickText();
        newQuickText.Name = 'Update Test';
        newQuickText.Message = 'Update Test';
        newQuickText.Category = 'Update Test';
        newQuickText.Business_Units__c = 'Advisor';
        insert newQuickText;
        
        newQuickText.Business_Units__c = 'Business Banking';
        update newQuickText;
    }
}