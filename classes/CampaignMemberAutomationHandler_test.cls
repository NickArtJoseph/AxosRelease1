@isTest
private class CampaignMemberAutomationHandler_test {
	@isTest
    static void test30DayCDMaturityAutomation() {
        Id acctRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer Person Account SFDC2').getRecordTypeId();
        Id finRTId = Schema.SObjectType.Financial_Account_SFDC2__c.getRecordTypeInfosByName().get('CD').getRecordTypeId();
		
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
		
		Account acct1 = new Account();
		acct1.LastName = 'Test1';
		acct1.RecordTypeId = acctRTId;
		acct1.Occupation_SFDC2__pc = 'Tester';
		acct1.PersonDoNotCall = false;
		Account acct2 = new Account();
		acct2.LastName = 'Test2';
		acct2.RecordTypeId = acctRTId;
		acct2.Occupation_SFDC2__pc = 'Tester';
		acct2.PersonDoNotCall = false;
		List<Account> accts = new List<Account>{acct1,acct2}; 
		insert accts;
		accts = [SELECT Person_Contact_Id__c FROM Account WHERE Id in :accts];
		Set<Id> contactIds = new Set<Id>{accts[0].Person_Contact_Id__c,accts[1].Person_Contact_Id__c};
		
		CampaignMember cm = new CampaignMember();
		cm.CampaignId = c.Id;
		cm.ContactId = accts[1].Person_Contact_Id__c;
		cm.Status = 'Attempting Contact';
		insert cm;
		
		Financial_Account_SFDC2__c fa1 = new Financial_Account_SFDC2__c();
		fa1.Name = 'TEST0000';
		fa1.Status__c = 'Active';
		fa1.Product_Class__c = 'CD';
		fa1.RecordTypeId = finRTId;
		fa1.Maturity_Date__c = Date.today().addDays(30);
		Financial_Account_SFDC2__c fa2 = new Financial_Account_SFDC2__c();
		fa2.Name = 'TEST0001';
		fa2.Status__c = 'Active';
		fa2.Product_Class__c = 'CD';
		fa2.RecordTypeId = finRTId;
		fa2.Maturity_Date__c = Date.today().addDays(-1);
		List<Financial_Account_SFDC2__c> fas = new List<Financial_Account_SFDC2__c>{fa1,fa2};
		insert fas;
		
		Financial_Account_Contact_Link_SFDC2__c link1 = new Financial_Account_Contact_Link_SFDC2__c();
		link1.Financial_Account__c = fas[0].Id;
		link1.Contact__c = accts[0].Person_Contact_Id__c;
		link1.CIF_JHA_LINK__c = '30DayCDTEST1111';
		Financial_Account_Contact_Link_SFDC2__c link2 = new Financial_Account_Contact_Link_SFDC2__c();
		link2.Financial_Account__c = fas[1].Id;
		link2.Contact__c = accts[1].Person_Contact_Id__c;
		link2.CIF_JHA_LINK__c = '30DayCDTEST1112';
		List<Financial_Account_Contact_Link_SFDC2__c> links = new List<Financial_Account_Contact_Link_SFDC2__c>{link1,link2};
		insert links;
		
		Test.startTest();
		CampaignMemberAutomationHandler.handleCampaignMemberAutomation(new List<String>{links[0].Id, links[1].Id});
		Test.stopTest();
		
		CampaignMember[] members = [SELECT Id, ContactId FROM CampaignMember WHERE ContactId in :contactIds];
		Financial_Account_Campaign_Link_SFDC2__c[] faLinks = [SELECT Financial_Account__c FROM Financial_Account_Campaign_Link_SFDC2__c WHERE Campaign__c =:c.Id];
		
		System.assertEquals(1, members.size());
		System.assertEquals(1, faLinks.size());
		System.assertEquals(accts[0].Person_Contact_Id__c, members[0].ContactId);
		System.assertEquals(fas[0].Id, faLinks[0].Financial_Account__c);
    }
    
    @isTest
    static void test30DayNoSigAutomation() {
        Id acctRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer Person Account SFDC2').getRecordTypeId();
        Id finRTId = Schema.SObjectType.Financial_Account_SFDC2__c.getRecordTypeInfosByName().get('CD').getRecordTypeId();
		
		Campaign c = new Campaign();
		c.Name = '30 Day No Signature Card';
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
		
		Account acct1 = new Account();
		acct1.LastName = 'Test1';
		acct1.RecordTypeId = acctRTId;
		acct1.Occupation_SFDC2__pc = 'Tester';
		acct1.PersonDoNotCall = false;
		Account acct2 = new Account();
		acct2.LastName = 'Test2';
		acct2.RecordTypeId = acctRTId;
		acct2.Occupation_SFDC2__pc = 'Tester';
		acct2.PersonDoNotCall = false;
		List<Account> accts = new List<Account>{acct1,acct2}; 
		insert accts;
		accts = [SELECT Person_Contact_Id__c FROM Account WHERE Id in :accts];
		Set<Id> contactIds = new Set<Id>{accts[0].Person_Contact_Id__c,accts[1].Person_Contact_Id__c};
		
		CampaignMember cm = new CampaignMember();
		cm.CampaignId = c.Id;
		cm.ContactId = accts[1].Person_Contact_Id__c;
		cm.Status = 'Attempting Contact';
		insert cm;
		
		Financial_Account_SFDC2__c fa1 = new Financial_Account_SFDC2__c();
		fa1.Name = 'TEST 0000';
		fa1.Status__c = 'Open';
		fa1.Department__c = 'Consumer Deposits';
		fa1.Signature_Card_Received__c = false;
		fa1.RecordTypeId = finRTId;
		fa1.Open_Date__c = Date.today().addDays(-35);
		fa1.Signature_Card_Received__c = false;
		Financial_Account_SFDC2__c fa2 = new Financial_Account_SFDC2__c();
		fa2.Name = 'TEST 0001';
		fa2.Status__c = 'Open';
		fa1.Department__c = 'Consumer Deposits';
		fa2.RecordTypeId = finRTId;
		fa2.Open_Date__c = Date.today().addDays(-46);
		fa2.Signature_Card_Received__c = false;
		List<Financial_Account_SFDC2__c> fas = new List<Financial_Account_SFDC2__c>{fa1,fa2};
		insert fas;
		
		Financial_Account_Contact_Link_SFDC2__c link1 = new Financial_Account_Contact_Link_SFDC2__c();
		link1.Financial_Account__c = fas[0].Id;
		link1.Contact__c = accts[0].Person_Contact_Id__c;
		link1.CIF_JHA_LINK__c = '30DayNoSigTEST1111';
		Financial_Account_Contact_Link_SFDC2__c link2 = new Financial_Account_Contact_Link_SFDC2__c();
		link2.Financial_Account__c = fas[1].Id;
		link2.Contact__c = accts[1].Person_Contact_Id__c;
		link2.CIF_JHA_LINK__c = '30DayNoSigTEST1112';
		List<Financial_Account_Contact_Link_SFDC2__c> links = new List<Financial_Account_Contact_Link_SFDC2__c>{link1,link2};
		insert links;
		
		Test.startTest();
		CampaignMemberAutomationHandler.handleCampaignMemberAutomation(new List<String>{links[0].Id, links[1].Id});
		Test.stopTest();
		
		CampaignMember[] members = [SELECT Id, ContactId FROM CampaignMember WHERE ContactId in :contactIds];
		
		System.assertEquals(1, members.size());
		System.assertEquals(accts[0].Person_Contact_Id__c, members[0].ContactId);
    }
    
    @isTest
    static void test45DayNoSigAutomation() {
        Id acctRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer Person Account SFDC2').getRecordTypeId();
        Id finRTId = Schema.SObjectType.Financial_Account_SFDC2__c.getRecordTypeInfosByName().get('CD').getRecordTypeId();
		
		Campaign c = new Campaign();
		c.Name = '45 Day No Signature Card';
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
		
		Account acct1 = new Account();
		acct1.LastName = 'Test';
		acct1.RecordTypeId = acctRTId;
		acct1.Occupation_SFDC2__pc = 'Tester';
		acct1.PersonDoNotCall = false;
		Account acct2 = new Account();
		acct2.LastName = 'Test2';
		acct2.RecordTypeId = acctRTId;
		acct2.Occupation_SFDC2__pc = 'Tester';
		acct2.PersonDoNotCall = false;
		List<Account> accts = new List<Account>{acct1,acct2}; 
		insert accts;
		accts = [SELECT Person_Contact_Id__c FROM Account WHERE Id in :accts];
		Set<Id> contactIds = new Set<Id>{accts[0].Person_Contact_Id__c,accts[1].Person_Contact_Id__c};
		
		CampaignMember cm = new CampaignMember();
		cm.CampaignId = c.Id;
		cm.ContactId = accts[1].Person_Contact_Id__c;
		cm.Status = 'Attempting Contact';
		insert cm;
		
		Financial_Account_SFDC2__c fa1 = new Financial_Account_SFDC2__c();
		fa1.Name = 'TEST 0000';
		fa1.Status__c = 'Open';
		fa1.Department__c = 'Consumer Deposits';
		fa1.Signature_Card_Received__c = false;
		fa1.RecordTypeId = finRTId;
		fa1.Open_Date__c = Date.today().addDays(-50);
		fa1.Signature_Card_Received__c = false;
		Financial_Account_SFDC2__c fa2 = new Financial_Account_SFDC2__c();
		fa2.Name = 'TEST 0001';
		fa2.Status__c = 'Open';
		fa1.Department__c = 'Consumer Deposits';
		fa2.RecordTypeId = finRTId;
		fa2.Open_Date__c = Date.today().addDays(-61);
		fa2.Signature_Card_Received__c = false;
		List<Financial_Account_SFDC2__c> fas = new List<Financial_Account_SFDC2__c>{fa1,fa2};
		insert fas;
		
		Financial_Account_Contact_Link_SFDC2__c link1 = new Financial_Account_Contact_Link_SFDC2__c();
		link1.Financial_Account__c = fas[0].Id;
		link1.Contact__c = accts[0].Person_Contact_Id__c;
		link1.CIF_JHA_LINK__c = '45DayNoSigTEST1111';
		Financial_Account_Contact_Link_SFDC2__c link2 = new Financial_Account_Contact_Link_SFDC2__c();
		link2.Financial_Account__c = fas[1].Id;
		link2.Contact__c = accts[1].Person_Contact_Id__c;
		link2.CIF_JHA_LINK__c = '45DayNoSigTEST1112';
		List<Financial_Account_Contact_Link_SFDC2__c> links = new List<Financial_Account_Contact_Link_SFDC2__c>{link1,link2};
		insert links;
		
		Test.startTest();
		CampaignMemberAutomationHandler.handleCampaignMemberAutomation(new List<String>{links[0].Id, links[1].Id});
		Test.stopTest();
		
		CampaignMember[] members = [SELECT Id, ContactId FROM CampaignMember WHERE ContactId in :contactIds];
		
		System.assertEquals(1, members.size());
		System.assertEquals(accts[0].Person_Contact_Id__c, members[0].ContactId);
    }
    
    @isTest
    static void test10DayUnfundedAutomation() {
        Id acctRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer Person Account SFDC2').getRecordTypeId();
        Id finRTId = Schema.SObjectType.Financial_Account_SFDC2__c.getRecordTypeInfosByName().get('CD').getRecordTypeId();
		
		Campaign c = new Campaign();
		c.Name = '10 Day Unfunded Accounts';
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
		
		Account acct1 = new Account();
		acct1.LastName = 'Test';
		acct1.RecordTypeId = acctRTId;
		acct1.Occupation_SFDC2__pc = 'Tester';
		acct1.PersonDoNotCall = false;
		Account acct2 = new Account();
		acct2.LastName = 'Test2';
		acct2.RecordTypeId = acctRTId;
		acct2.Occupation_SFDC2__pc = 'Tester';
		acct2.PersonDoNotCall = false;
		List<Account> accts = new List<Account>{acct1,acct2}; 
		insert accts;
		accts = [SELECT Person_Contact_Id__c FROM Account WHERE Id in :accts];
		Set<Id> contactIds = new Set<Id>{accts[0].Person_Contact_Id__c,accts[1].Person_Contact_Id__c};
		
		CampaignMember cm = new CampaignMember();
		cm.CampaignId = c.Id;
		cm.ContactId = accts[1].Person_Contact_Id__c;
		cm.Status = 'Attempting Contact';
		insert cm;
		
		Financial_Account_SFDC2__c fa1 = new Financial_Account_SFDC2__c();
		fa1.Name = 'TEST 0000';
		fa1.Status__c = 'Open';
		fa1.Department__c = 'Consumer Deposits';
		fa1.Signature_Card_Received__c = false;
		fa1.RecordTypeId = finRTId;
		fa1.Open_Date__c = Date.today().addDays(-11);
		Financial_Account_SFDC2__c fa2 = new Financial_Account_SFDC2__c();
		fa2.Name = 'TEST 0001';
		fa2.Status__c = 'Open';
		fa1.Department__c = 'Consumer Deposits';
		fa2.RecordTypeId = finRTId;
		fa2.Open_Date__c = Date.today().addDays(-40);
		List<Financial_Account_SFDC2__c> fas = new List<Financial_Account_SFDC2__c>{fa1,fa2};
		insert fas;
		
		Financial_Account_Contact_Link_SFDC2__c link1 = new Financial_Account_Contact_Link_SFDC2__c();
		link1.Financial_Account__c = fas[0].Id;
		link1.Contact__c = accts[0].Person_Contact_Id__c;
		link1.CIF_JHA_LINK__c = '10DayUnfundedTEST1111';
		Financial_Account_Contact_Link_SFDC2__c link2 = new Financial_Account_Contact_Link_SFDC2__c();
		link2.Financial_Account__c = fas[1].Id;
		link2.Contact__c = accts[1].Person_Contact_Id__c;
		link2.CIF_JHA_LINK__c = '10DayUnfundedTEST1112';
		List<Financial_Account_Contact_Link_SFDC2__c> links = new List<Financial_Account_Contact_Link_SFDC2__c>{link1,link2};
		insert links;
		
		Test.startTest();
		CampaignMemberAutomationHandler.handleCampaignMemberAutomation(new List<String>{links[0].Id, links[1].Id});
		Test.stopTest();
		
		CampaignMember[] members = [SELECT Id, ContactId FROM CampaignMember WHERE ContactId in :contactIds];
		
		System.assertEquals(1, members.size());
		System.assertEquals(accts[0].Person_Contact_Id__c, members[0].ContactId);
    }
    
    @isTest
    static void test30DayUnfundedAutomation() {
        Id acctRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer Person Account SFDC2').getRecordTypeId();
        Id finRTId = Schema.SObjectType.Financial_Account_SFDC2__c.getRecordTypeInfosByName().get('CD').getRecordTypeId();
		
		Campaign c = new Campaign();
		c.Name = '30 Day Unfunded Accounts';
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
		
		Account acct1 = new Account();
		acct1.LastName = 'Test';
		acct1.RecordTypeId = acctRTId;
		acct1.Occupation_SFDC2__pc = 'Tester';
		acct1.PersonDoNotCall = false;
		Account acct2 = new Account();
		acct2.LastName = 'Test2';
		acct2.RecordTypeId = acctRTId;
		acct2.Occupation_SFDC2__pc = 'Tester';
		acct2.PersonDoNotCall = false;
		List<Account> accts = new List<Account>{acct1,acct2}; 
		insert accts;
		accts = [SELECT Person_Contact_Id__c FROM Account WHERE Id in :accts];
		Set<Id> contactIds = new Set<Id>{accts[0].Person_Contact_Id__c,accts[1].Person_Contact_Id__c};
		
		CampaignMember cm = new CampaignMember();
		cm.CampaignId = c.Id;
		cm.ContactId = accts[1].Person_Contact_Id__c;
		cm.Status = 'Attempting Contact';
		insert cm;
		
		Financial_Account_SFDC2__c fa1 = new Financial_Account_SFDC2__c();
		fa1.Name = 'TEST 0000';
		fa1.Status__c = 'Open';
		fa1.Department__c = 'Consumer Deposits';
		fa1.Signature_Card_Received__c = false;
		fa1.RecordTypeId = finRTId;
		fa1.Open_Date__c = Date.today().addDays(-35);
		Financial_Account_SFDC2__c fa2 = new Financial_Account_SFDC2__c();
		fa2.Name = 'TEST 0001';
		fa2.Status__c = 'Open';
		fa1.Department__c = 'Consumer Deposits';
		fa2.RecordTypeId = finRTId;
		fa2.Open_Date__c = Date.today().addDays(-47);
		List<Financial_Account_SFDC2__c> fas = new List<Financial_Account_SFDC2__c>{fa1,fa2};
		insert fas;
		
		Financial_Account_Contact_Link_SFDC2__c link1 = new Financial_Account_Contact_Link_SFDC2__c();
		link1.Financial_Account__c = fas[0].Id;
		link1.Contact__c = accts[0].Person_Contact_Id__c;
		link1.CIF_JHA_LINK__c = '30DayUnfundedTEST1111';
		Financial_Account_Contact_Link_SFDC2__c link2 = new Financial_Account_Contact_Link_SFDC2__c();
		link2.Financial_Account__c = fas[1].Id;
		link2.Contact__c = accts[1].Person_Contact_Id__c;
		link2.CIF_JHA_LINK__c = '30DayUnfundedTEST1112';
		List<Financial_Account_Contact_Link_SFDC2__c> links = new List<Financial_Account_Contact_Link_SFDC2__c>{link1,link2};
		insert links;
		
		Test.startTest();
		CampaignMemberAutomationHandler.handleCampaignMemberAutomation(new List<String>{links[0].Id, links[1].Id});
		Test.stopTest();
		
		CampaignMember[] members = [SELECT Id, ContactId FROM CampaignMember WHERE ContactId in :contactIds];
		
		System.assertEquals(1, members.size());
		System.assertEquals(accts[0].Person_Contact_Id__c, members[0].ContactId);
    }
    
    @isTest
    static void test45DayUnfundedAutomation() {
        Id acctRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer Person Account SFDC2').getRecordTypeId();
        Id finRTId = Schema.SObjectType.Financial_Account_SFDC2__c.getRecordTypeInfosByName().get('CD').getRecordTypeId();
		
		Campaign c = new Campaign();
		c.Name = '45 Day Unfunded Accounts';
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
		
		Account acct1 = new Account();
		acct1.LastName = 'Test';
		acct1.RecordTypeId = acctRTId;
		acct1.Occupation_SFDC2__pc = 'Tester';
		acct1.PersonDoNotCall = false;
		Account acct2 = new Account();
		acct2.LastName = 'Test2';
		acct2.RecordTypeId = acctRTId;
		acct2.Occupation_SFDC2__pc = 'Tester';
		acct2.PersonDoNotCall = false;
		List<Account> accts = new List<Account>{acct1,acct2}; 
		insert accts;
		accts = [SELECT Person_Contact_Id__c FROM Account WHERE Id in :accts];
		Set<Id> contactIds = new Set<Id>{accts[0].Person_Contact_Id__c,accts[1].Person_Contact_Id__c};
		
		CampaignMember cm = new CampaignMember();
		cm.CampaignId = c.Id;
		cm.ContactId = accts[1].Person_Contact_Id__c;
		cm.Status = 'Attempting Contact';
		insert cm;
		
		Financial_Account_SFDC2__c fa1 = new Financial_Account_SFDC2__c();
		fa1.Name = 'TEST 0000';
		fa1.Status__c = 'Open';
		fa1.Department__c = 'Consumer Deposits';
		fa1.Signature_Card_Received__c = false;
		fa1.RecordTypeId = finRTId;
		fa1.Open_Date__c = Date.today().addDays(-50);
		Financial_Account_SFDC2__c fa2 = new Financial_Account_SFDC2__c();
		fa2.Name = 'TEST 0001';
		fa2.Status__c = 'Open';
		fa1.Department__c = 'Consumer Deposits';
		fa2.RecordTypeId = finRTId;
		fa2.Open_Date__c = Date.today().addDays(-62);
		List<Financial_Account_SFDC2__c> fas = new List<Financial_Account_SFDC2__c>{fa1,fa2};
		insert fas;
		
		Financial_Account_Contact_Link_SFDC2__c link1 = new Financial_Account_Contact_Link_SFDC2__c();
		link1.Financial_Account__c = fas[0].Id;
		link1.Contact__c = accts[0].Person_Contact_Id__c;
		link1.CIF_JHA_LINK__c = '45DayUnfundedTEST1111';
		Financial_Account_Contact_Link_SFDC2__c link2 = new Financial_Account_Contact_Link_SFDC2__c();
		link2.Financial_Account__c = fas[1].Id;
		link2.Contact__c = accts[1].Person_Contact_Id__c;
		link2.CIF_JHA_LINK__c = '45DayUnfundedTEST1112';
		List<Financial_Account_Contact_Link_SFDC2__c> links = new List<Financial_Account_Contact_Link_SFDC2__c>{link1,link2};
		insert links;
		
		Test.startTest();
		CampaignMemberAutomationHandler.handleCampaignMemberAutomation(new List<String>{links[0].Id, links[1].Id});
		Test.stopTest();
		
		CampaignMember[] members = [SELECT Id, ContactId FROM CampaignMember WHERE ContactId in :contactIds];
		
		System.assertEquals(1, members.size());
		System.assertEquals(accts[0].Person_Contact_Id__c, members[0].ContactId);
    }
    
    @isTest
    static void test10DayZeroAutomation() {
        Id acctRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer Person Account SFDC2').getRecordTypeId();
        Id finRTId = Schema.SObjectType.Financial_Account_SFDC2__c.getRecordTypeInfosByName().get('CD').getRecordTypeId();
		
		Campaign c = new Campaign();
		c.Name = '10 Day Zero Balance';
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
		
		Account acct1 = new Account();
		acct1.LastName = 'Test';
		acct1.RecordTypeId = acctRTId;
		acct1.Occupation_SFDC2__pc = 'Tester';
		acct1.PersonDoNotCall = false;
		Account acct2 = new Account();
		acct2.LastName = 'Test2';
		acct2.RecordTypeId = acctRTId;
		acct2.Occupation_SFDC2__pc = 'Tester';
		acct2.PersonDoNotCall = false;
		List<Account> accts = new List<Account>{acct1,acct2}; 
		insert accts;
		accts = [SELECT Person_Contact_Id__c FROM Account WHERE Id in :accts];
		Set<Id> contactIds = new Set<Id>{accts[0].Person_Contact_Id__c,accts[1].Person_Contact_Id__c};
		
		CampaignMember cm = new CampaignMember();
		cm.CampaignId = c.Id;
		cm.ContactId = accts[1].Person_Contact_Id__c;
		cm.Status = 'Attempting Contact';
		insert cm;
		
		Financial_Account_SFDC2__c fa1 = new Financial_Account_SFDC2__c();
		fa1.Name = 'TEST 0000';
		fa1.Status__c = 'Open';
		fa1.Department__c = 'Consumer Deposits';
		fa1.Signature_Card_Received__c = false;
		fa1.RecordTypeId = finRTId;
		fa1.Zero_Balance_Date__c = Date.today().addDays(-11);
		fa1.Zero_Balance_Flag__c = true;
		Financial_Account_SFDC2__c fa2 = new Financial_Account_SFDC2__c();
		fa2.Name = 'TEST 0001';
		fa2.Status__c = 'Open';
		fa1.Department__c = 'Consumer Deposits';
		fa2.RecordTypeId = finRTId;
		fa2.Zero_Balance_Date__c = Date.today().addDays(-32);
		fa2.Zero_Balance_Flag__c = true;
		List<Financial_Account_SFDC2__c> fas = new List<Financial_Account_SFDC2__c>{fa1,fa2};
		insert fas;
		
		Financial_Account_Contact_Link_SFDC2__c link1 = new Financial_Account_Contact_Link_SFDC2__c();
		link1.Financial_Account__c = fas[0].Id;
		link1.Contact__c = accts[0].Person_Contact_Id__c;
		link1.CIF_JHA_LINK__c = '10DayZeroTEST1111';
		Financial_Account_Contact_Link_SFDC2__c link2 = new Financial_Account_Contact_Link_SFDC2__c();
		link2.Financial_Account__c = fas[1].Id;
		link2.Contact__c = accts[1].Person_Contact_Id__c;
		link2.CIF_JHA_LINK__c = '10DayZeroTEST1112';
		List<Financial_Account_Contact_Link_SFDC2__c> links = new List<Financial_Account_Contact_Link_SFDC2__c>{link1,link2};
		insert links;
		
		Test.startTest();
		CampaignMemberAutomationHandler.handleCampaignMemberAutomation(new List<String>{links[0].Id, links[1].Id});
		Test.stopTest();
		
		CampaignMember[] members = [SELECT Id, ContactId FROM CampaignMember WHERE ContactId in :contactIds];
		
		System.assertEquals(1, members.size());
		System.assertEquals(accts[0].Person_Contact_Id__c, members[0].ContactId);
    }
    
    @isTest
    static void test30DayZeroAutomation() {
        Id acctRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer Person Account SFDC2').getRecordTypeId();
        Id finRTId = Schema.SObjectType.Financial_Account_SFDC2__c.getRecordTypeInfosByName().get('CD').getRecordTypeId();
		
		Campaign c = new Campaign();
		c.Name = '30 Day Zero Balance';
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
		
		Account acct1 = new Account();
		acct1.LastName = 'Test';
		acct1.RecordTypeId = acctRTId;
		acct1.Occupation_SFDC2__pc = 'Tester';
		acct1.PersonDoNotCall = false;
		Account acct2 = new Account();
		acct2.LastName = 'Test2';
		acct2.RecordTypeId = acctRTId;
		acct2.Occupation_SFDC2__pc = 'Tester';
		acct2.PersonDoNotCall = false;
		List<Account> accts = new List<Account>{acct1,acct2}; 
		insert accts;
		accts = [SELECT Person_Contact_Id__c FROM Account WHERE Id in :accts];
		Set<Id> contactIds = new Set<Id>{accts[0].Person_Contact_Id__c,accts[1].Person_Contact_Id__c};
		
		CampaignMember cm = new CampaignMember();
		cm.CampaignId = c.Id;
		cm.ContactId = accts[1].Person_Contact_Id__c;
		cm.Status = 'Attempting Contact';
		insert cm;
		
		Financial_Account_SFDC2__c fa1 = new Financial_Account_SFDC2__c();
		fa1.Name = 'TEST 0000';
		fa1.Status__c = 'Open';
		fa1.Department__c = 'Consumer Deposits';
		fa1.Signature_Card_Received__c = false;
		fa1.RecordTypeId = finRTId;
		fa1.Zero_Balance_Date__c = Date.today().addDays(-31);
		fa1.Zero_Balance_Flag__c = true;
		Financial_Account_SFDC2__c fa2 = new Financial_Account_SFDC2__c();
		fa2.Name = 'TEST 0001';
		fa2.Status__c = 'Open';
		fa1.Department__c = 'Consumer Deposits';
		fa2.RecordTypeId = finRTId;
		fa2.Zero_Balance_Date__c = Date.today().addDays(-47);
		fa2.Zero_Balance_Flag__c = true;
		List<Financial_Account_SFDC2__c> fas = new List<Financial_Account_SFDC2__c>{fa1,fa2};
		insert fas;
		
		Financial_Account_Contact_Link_SFDC2__c link1 = new Financial_Account_Contact_Link_SFDC2__c();
		link1.Financial_Account__c = fas[0].Id;
		link1.Contact__c = accts[0].Person_Contact_Id__c;
		link1.CIF_JHA_LINK__c = '30DayZeroTEST1111';
		Financial_Account_Contact_Link_SFDC2__c link2 = new Financial_Account_Contact_Link_SFDC2__c();
		link2.Financial_Account__c = fas[1].Id;
		link2.Contact__c = accts[1].Person_Contact_Id__c;
		link2.CIF_JHA_LINK__c = '30DayZeroTEST1112';
		List<Financial_Account_Contact_Link_SFDC2__c> links = new List<Financial_Account_Contact_Link_SFDC2__c>{link1,link2};
		insert links;
		
		Test.startTest();
		CampaignMemberAutomationHandler.handleCampaignMemberAutomation(new List<String>{links[0].Id, links[1].Id});
		Test.stopTest();
		
		CampaignMember[] members = [SELECT Id, ContactId FROM CampaignMember WHERE ContactId in :contactIds];
		
		System.assertEquals(1, members.size());
		System.assertEquals(accts[0].Person_Contact_Id__c, members[0].ContactId);
    }
    
    @isTest
    static void test45DayZeroAutomation() {
        Id acctRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer Person Account SFDC2').getRecordTypeId();
        Id finRTId = Schema.SObjectType.Financial_Account_SFDC2__c.getRecordTypeInfosByName().get('CD').getRecordTypeId();
		
		Campaign c = new Campaign();
		c.Name = '45 Day Zero Balance';
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
		
		Account acct1 = new Account();
		acct1.LastName = 'Test';
		acct1.RecordTypeId = acctRTId;
		acct1.Occupation_SFDC2__pc = 'Tester';
		acct1.PersonDoNotCall = false;
		Account acct2 = new Account();
		acct2.LastName = 'Test2';
		acct2.RecordTypeId = acctRTId;
		acct2.Occupation_SFDC2__pc = 'Tester';
		acct2.PersonDoNotCall = false;
		List<Account> accts = new List<Account>{acct1,acct2}; 
		insert accts;
		accts = [SELECT Person_Contact_Id__c FROM Account WHERE Id in :accts];
		Set<Id> contactIds = new Set<Id>{accts[0].Person_Contact_Id__c,accts[1].Person_Contact_Id__c};
		
		CampaignMember cm = new CampaignMember();
		cm.CampaignId = c.Id;
		cm.ContactId = accts[1].Person_Contact_Id__c;
		cm.Status = 'Attempting Contact';
		insert cm;
		
		Financial_Account_SFDC2__c fa1 = new Financial_Account_SFDC2__c();
		fa1.Name = 'TEST 0000';
		fa1.Status__c = 'Open';
		fa1.Department__c = 'Consumer Deposits';
		fa1.Signature_Card_Received__c = false;
		fa1.RecordTypeId = finRTId;
		fa1.Zero_Balance_Date__c = Date.today().addDays(-46);
		fa1.Zero_Balance_Flag__c = true;
		Financial_Account_SFDC2__c fa2 = new Financial_Account_SFDC2__c();
		fa2.Name = 'TEST 0001';
		fa2.Status__c = 'Open';
		fa1.Department__c = 'Consumer Deposits';
		fa2.RecordTypeId = finRTId;
		fa2.Zero_Balance_Date__c = Date.today().addDays(-62);
		fa2.Zero_Balance_Flag__c = true;
		List<Financial_Account_SFDC2__c> fas = new List<Financial_Account_SFDC2__c>{fa1,fa2};
		insert fas;
		
		Financial_Account_Contact_Link_SFDC2__c link1 = new Financial_Account_Contact_Link_SFDC2__c();
		link1.Financial_Account__c = fas[0].Id;
		link1.Contact__c = accts[0].Person_Contact_Id__c;
		link1.CIF_JHA_LINK__c = '45DayZeroTEST1111';
		Financial_Account_Contact_Link_SFDC2__c link2 = new Financial_Account_Contact_Link_SFDC2__c();
		link2.Financial_Account__c = fas[1].Id;
		link2.Contact__c = accts[1].Person_Contact_Id__c;
		link2.CIF_JHA_LINK__c = '45DayZeroTEST1112';
		List<Financial_Account_Contact_Link_SFDC2__c> links = new List<Financial_Account_Contact_Link_SFDC2__c>{link1,link2};
		insert links;
		
		Test.startTest();
		CampaignMemberAutomationHandler.handleCampaignMemberAutomation(new List<String>{links[0].Id, links[1].Id});
		Test.stopTest();
		
		CampaignMember[] members = [SELECT Id, ContactId FROM CampaignMember WHERE ContactId in :contactIds];
		
		System.assertEquals(1, members.size());
		System.assertEquals(accts[0].Person_Contact_Id__c, members[0].ContactId);
    }
    
    @isTest
    static void testWelcomeListAutomation() {
        Id acctRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer Person Account SFDC2').getRecordTypeId();
        Id finRTId = Schema.SObjectType.Financial_Account_SFDC2__c.getRecordTypeInfosByName().get('CD').getRecordTypeId();
		
		Campaign c = new Campaign();
		c.Name = 'Consumer Deposits Welcome List';
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
		
		Account acct1 = new Account();
		acct1.LastName = 'Test';
		acct1.RecordTypeId = acctRTId;
		acct1.Occupation_SFDC2__pc = 'Tester';
		acct1.PersonDoNotCall = false;
		Account acct2 = new Account();
		acct2.LastName = 'Test2';
		acct2.RecordTypeId = acctRTId;
		acct2.Occupation_SFDC2__pc = 'Tester';
		acct2.PersonDoNotCall = false;
		List<Account> accts = new List<Account>{acct1,acct2}; 
		insert accts;
		accts = [SELECT Person_Contact_Id__c FROM Account WHERE Id in :accts];
		Set<Id> contactIds = new Set<Id>{accts[0].Person_Contact_Id__c,accts[1].Person_Contact_Id__c};
		
		CampaignMember cm = new CampaignMember();
		cm.CampaignId = c.Id;
		cm.ContactId = accts[1].Person_Contact_Id__c;
		cm.Status = 'Attempting Contact';
		insert cm;
		
		Financial_Account_SFDC2__c fa1 = new Financial_Account_SFDC2__c();
		fa1.Name = 'TEST 0000';
		fa1.Status__c = 'Open';
		fa1.Department__c = 'Consumer Deposits';
		fa1.Signature_Card_Received__c = false;
		fa1.RecordTypeId = finRTId;
		fa1.Open_Date__c = Date.today().addDays(-5);
		fa1.Signature_Card_Received__c = false;
		Financial_Account_SFDC2__c fa2 = new Financial_Account_SFDC2__c();
		fa2.Name = 'TEST 0001';
		fa2.Status__c = 'Open';
		fa1.Department__c = 'Consumer Deposits';
		fa2.RecordTypeId = finRTId;
		fa2.Open_Date__c = Date.today().addDays(-12);
		fa2.Signature_Card_Received__c = false;
		List<Financial_Account_SFDC2__c> fas = new List<Financial_Account_SFDC2__c>{fa1,fa2};
		insert fas;
		
		Financial_Account_Contact_Link_SFDC2__c link1 = new Financial_Account_Contact_Link_SFDC2__c();
		link1.Financial_Account__c = fas[0].Id;
		link1.Contact__c = accts[0].Person_Contact_Id__c;
		link1.CIF_JHA_LINK__c = 'WelcomeListTEST1111';
		Financial_Account_Contact_Link_SFDC2__c link2 = new Financial_Account_Contact_Link_SFDC2__c();
		link2.Financial_Account__c = fas[1].Id;
		link2.Contact__c = accts[1].Person_Contact_Id__c;
		link2.CIF_JHA_LINK__c = 'WelcomeListTEST1112';
		List<Financial_Account_Contact_Link_SFDC2__c> links = new List<Financial_Account_Contact_Link_SFDC2__c>{link1,link2};
		insert links;
		
		Test.startTest();
		CampaignMemberAutomationHandler.handleCampaignMemberAutomation(new List<String>{links[0].Id, links[1].Id});
		Test.stopTest();
		
		CampaignMember[] members = [SELECT Id, ContactId FROM CampaignMember WHERE ContactId in :contactIds];
		
		System.assertEquals(1, members.size());
		System.assertEquals(accts[0].Person_Contact_Id__c, members[0].ContactId);
    }
}