@isTest
private class FinancialAccountSFDC2TriggerHandler_test {
	@isTest
    static void test30DayCDMaturityAutomation() {
    	TriggerValidator.setIsTest();
        Id acctRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer Person Account SFDC2').getRecordTypeId();
        Id finRTId = Schema.SObjectType.Financial_Account_SFDC2__c.getRecordTypeInfosByName().get('CD').getRecordTypeId();
		
		Account acct = new Account();
		acct.LastName = 'Test';
		acct.RecordTypeId = acctRTId;
		acct.Occupation_SFDC2__pc = 'Tester';
		insert acct;
		acct = [SELECT Person_Contact_Id__c FROM Account WHERE Id = :acct.Id];
		
		Financial_Account_SFDC2__c fa = new Financial_Account_SFDC2__c();
		fa.Name = 'TEST 0000';
		fa.Status__c = 'Active';
		fa.Product_Class__c = 'CD';
		fa.RecordTypeId = finRTId;
		fa.Maturity_Date__c = Date.today().addDays(30);
		fa.Funding_Date__c = Date.today();
		insert fa;
		
		Financial_Account_Contact_Link_SFDC2__c link = new Financial_Account_Contact_Link_SFDC2__c();
		link.Financial_Account__c = fa.Id;
		link.Contact__c = acct.Person_Contact_Id__c;
		link.CIF_JHA_LINK__c = '30DayCDTEST1111';
		insert link;
		for(CampaignMember cm : [SELECT Campaign.Name, Status FROM CampaignMember WHERE ContactId = :acct.Person_Contact_Id__c]) {
			System.assertEquals('Attempting Contact', cm.Status);
			//ensure 30 Day CD Maturity Campaign
			if(cm.ContactId == acct.Person_Contact_Id__c) {
				System.assertEquals('30 Day CD Maturity', cm.Campaign.Name);
			}
		}
		
		Test.startTest();
		fa.Maturity_Date__c = Date.today().addDays(45);
		update fa;
		Test.stopTest();
		CampaignMember[] cm = [SELECT Campaign.Name, Status FROM CampaignMember WHERE ContactId = :acct.Person_Contact_Id__c];
		System.assertEquals(0, cm.size());
    }
    
    @isTest
    static void test30DayNoSigAutomation() {
    	TriggerValidator.setIsTest();
        Id acctRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer Person Account SFDC2').getRecordTypeId();
        Id finRTId = Schema.SObjectType.Financial_Account_SFDC2__c.getRecordTypeInfosByName().get('CD').getRecordTypeId();
		
		Account acct = new Account();
		acct.LastName = 'Test';
		acct.RecordTypeId = acctRTId;
		acct.Occupation_SFDC2__pc = 'Tester';
		insert acct;
		acct = [SELECT Person_Contact_Id__c FROM Account WHERE Id = :acct.Id];
		
		Financial_Account_SFDC2__c fa = new Financial_Account_SFDC2__c();
		fa.Name = 'TEST 0000';
		fa.Status__c = 'Open';
		fa.Department__c = 'Consumer Deposits';
		fa.Signature_Card_Received__c = false;
		fa.RecordTypeId = finRTId;
		fa.Open_Date__c = Date.today().addDays(-35);
		fa.Funding_Date__c = Date.today();
		insert fa;
		
		Financial_Account_Contact_Link_SFDC2__c link = new Financial_Account_Contact_Link_SFDC2__c();
		link.Financial_Account__c = fa.Id;
		link.Contact__c = acct.Person_Contact_Id__c;
		link.CIF_JHA_LINK__c = '30DayNoSigTEST1111';
		insert link;
		for(CampaignMember cm : [SELECT Campaign.Name, Status FROM CampaignMember WHERE ContactId = :acct.Person_Contact_Id__c]) {
			System.assertEquals('Attempting Contact', cm.Status);
			//ensure 30 Day CD Maturity Campaign
			if(cm.ContactId == acct.Person_Contact_Id__c) {
				System.assertEquals('30 Day No Signature', cm.Campaign.Name);
			}
		}
		
		Test.startTest();
		fa.Maturity_Date__c = Date.today().addDays(-46);
		update fa;
		Test.stopTest();
		CampaignMember[] cm = [SELECT Campaign.Name, Status FROM CampaignMember WHERE ContactId = :acct.Person_Contact_Id__c];
		System.assertEquals(0, cm.size());
    }
    
    @isTest
    static void testCampaignWorkflowTrigger() {
    	TriggerValidator.setIsTest();
        Id acctRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer Person Account SFDC2').getRecordTypeId();
        Id finRTId = Schema.SObjectType.Financial_Account_SFDC2__c.getRecordTypeInfosByName().get('CD').getRecordTypeId();
		
		Account acct = new Account();
		acct.LastName = 'Test';
		acct.RecordTypeId = acctRTId;
		acct.Occupation_SFDC2__pc = 'Tester';
		insert acct;
		acct = [SELECT Person_Contact_Id__c FROM Account WHERE Id = :acct.Id];
		
		Financial_Account_SFDC2__c fa = new Financial_Account_SFDC2__c();
		fa.Name = 'TEST 0000';
		fa.Status__c = 'Active';
		fa.Product_Class__c = 'CD';
		fa.RecordTypeId = finRTId;
		fa.Maturity_Date__c = Date.today().addDays(-1);
		fa.Funding_Date__c = Date.today();
		insert fa;
		
		Financial_Account_Contact_Link_SFDC2__c link = new Financial_Account_Contact_Link_SFDC2__c();
		link.Financial_Account__c = fa.Id;
		link.Contact__c = acct.Person_Contact_Id__c;
		link.CIF_JHA_LINK__c = '30DayCDTEST1111';
		insert link;
		
		Campaign c = new Campaign();
		c.Name = '30 Day CD Maturity';
		c.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Service Campaign').getRecordTypeId();
		insert c;
		CampaignMemberStatus s1 = new CampaignMemberStatus();
		s1.Label = 'Attempting Contact';
		s1.IsDefault = true;
		s1.CampaignId = c.Id;
		CampaignMemberStatus s2 = new CampaignMemberStatus();
		s2.Label = 'Contacted';
		s2.CampaignId = c.Id;
		CampaignMemberStatus s3 = new CampaignMemberStatus();
		s3.Label = 'Expired';
		s3.CampaignId = c.Id;
		List<CampaignMemberStatus> cms = new List<CampaignMemberStatus>{s1,s2,s3};
		insert cms;
		
		CampaignMember cm = new CampaignMember();
		cm.CampaignId = c.Id;
		cm.ContactId = acct.Person_Contact_Id__c;
		cm.Status = 'Attempting Contact';
		insert cm;
				
		Test.startTest();
		fa.CampaignAutomationTriggerSFDC2__c = true;
		update fa;
		Test.stopTest();
		CampaignMember[] cmList = [SELECT Campaign.Name, Status FROM CampaignMember WHERE ContactId = :acct.Person_Contact_Id__c];
		System.assertEquals(0, cmList.size());
    }
}