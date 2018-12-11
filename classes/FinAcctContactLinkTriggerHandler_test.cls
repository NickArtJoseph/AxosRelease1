@isTest
private class FinAcctContactLinkTriggerHandler_test {
	@isTest
    static void testHandleCampaignAutomation() {
        Id acctRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer Person Account SFDC2').getRecordTypeId();
        Id finRTId = Schema.SObjectType.Financial_Account_SFDC2__c.getRecordTypeInfosByName().get('CD').getRecordTypeId();
		
		Account acct = new Account();
		acct.LastName = 'Test';
		acct.RecordTypeId = acctRTId;
		acct.Occupation_SFDC2__pc = 'Tester';
		acct.PersonDoNotCall = false;
		insert acct;
		acct = [SELECT Person_Contact_Id__c FROM Account WHERE Id = :acct.Id];
		
		Financial_Account_SFDC2__c fa = new Financial_Account_SFDC2__c();
		fa.Name = 'TEST 0000';
		fa.Status__c = 'Active';
		fa.Product_Class__c = 'CD';
		fa.RecordTypeId = finRTId;
		fa.Maturity_Date__c = Date.today().addDays(30);
		insert fa;
		
		Financial_Account_Contact_Link_SFDC2__c link = new Financial_Account_Contact_Link_SFDC2__c();
		link.Financial_Account__c = fa.Id;
		link.Contact__c = acct.Person_Contact_Id__c;
		link.CIF_JHA_LINK__c = '30DayCDTEST1111';
		
		Test.startTest();
		insert link;
		Test.stopTest();
    }
}