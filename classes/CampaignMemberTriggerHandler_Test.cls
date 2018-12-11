@isTest
private class CampaignMemberTriggerHandler_Test {

	/**
	* Tests the TrackSpecialtyFinanceEmailStatus method that is triggered in the afterUpdate
	*/
  	@isTest
  	static void testTrackSpecialtyFinanceEmailStatus() {
        Id specFinRTId;  //Specialty Finance Person Account record type id
        
        specFinRTId = [SELECT Id FROM RecordType WHERE IsActive = true AND IsPersonType = true AND DeveloperName like 'Specialty_Finance%' LIMIT 1][0].Id;
        List<Account> newPerAcct = new List<Account>();
        for(Integer i=0; i < 2; i++) {
            Account a = TestDataFactory.createTestPersonAccount();
            a.RecordTypeId = specFinRTId;
            newPerAcct.add(a);
        }
        insert newPerAcct;
        newPerAcct = [SELECT Person_Contact_ID__c FROM Account WHERE Id in :newPerAcct];
        System.assertEquals(2,newPerAcct.size());
        
        Account acc = TestDataFactory.createAndInsertTestBusinessAccount();
        Contact con = TestDataFactory.createTestContact(acc);
        insert con;
        
        List<Id> conIds = new List<Id>{con.Id};
        for(Integer i=0; i < newPerAcct.size(); i++) {
        	conIds.add(newPerAcct[i].Person_Contact_ID__c);        
        }
        
        Campaign cam = new Campaign();
        cam.Name = 'Test';
        insert cam;
        
        CampaignMember cmNoUpdate = new CampaignMember(ContactId=con.Id, Status='Sent', CampaignId=cam.Id);
        CampaignMember cmOpened = new CampaignMember(ContactId=newPerAcct[0].Person_Contact_ID__c, Status='Sent', CampaignId=cam.Id);
        CampaignMember cmBounced = new CampaignMember(ContactId=newPerAcct[1].Person_Contact_ID__c, Status='Sent', CampaignId=cam.Id);
        CampaignMember[] cms = new CampaignMember[]{cmNoUpdate,cmOpened,cmBounced};
        insert cms;
            
        Test.startTest();
        cms[0].et4ae5__Activity__c = 'Clicked';
        cms[1].et4ae5__Activity__c = 'Opened';
        cms[2].et4ae5__Activity__c = 'Bounced';
        update cms;
        Test.stopTest();
        
        for(Contact c : [SELECT Id, Account.Recent_Email_Status_Specialty_Finance__c, Account.Email_Bounced_Specialty_Finance__c FROM Contact WHERE Id in :conIds]) {
            if (c.Id == conIds[0]) {
                //non Specialty Finance Contact
                System.assertNotEquals('Clicked', c.Account.Recent_Email_Status_Specialty_Finance__c, 'Non-Specialty Finance Person Account was improperly updated');
            } else if(c.Id == conIds[1]) {
                //Specialty Finance Person Account
                System.assertEquals('Opened',c.Account.Recent_Email_Status_Specialty_Finance__c, 'Specialty Finance Person Account was not updated to Opened');
            } else if(c.Id == conIds[2]) {
                //Specialty Finance Person Account
                System.assertEquals('Bounced',c.Account.Recent_Email_Status_Specialty_Finance__c, 'Specialty Finance Person Account was not updated to Bounced');
                System.assertEquals(true,c.Account.Email_Bounced_Specialty_Finance__c, 'Specialty Finance Person Account was not updated for Email Bounced');
            } 
        }
    }
    
    /**
    * Tests the handlePrimaryCampaignLeadPopulation
    */
    @isTest
    static void testHandlePrimaryCampaignLeadPopulation() {
    	Id leadRTId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Consumer Deposits SFDC2').getRecordTypeId();
    	
    	Lead l = new Lead();
    	l.LastName = 'TestHandlePrimaryCampaign';
    	l.Status = 'New';
    	l.LeadSource = 'Email';
    	l.RecordTypeId = leadRTId;
    	l.Primary_Campaign_SFDC2__c = null;
    	insert l;
    	
    	Campaign c = new Campaign();
		c.Name = 'TestPrimaryCampaign';
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
		
		CampaignMember cm1 = new CampaignMember();
		cm1.CampaignId = c.Id;
		cm1.LeadId = l.Id;
		
		Test.startTest();
		insert cm1;
		Test.stopTest();
		
		l = [SELECT Primary_Campaign_SFDC2__c FROM Lead WHERE Id = :l.Id];
		System.assertEquals(c.Id, l.Primary_Campaign_SFDC2__c);
    }
    
    /**
    * Tests the handleExpiredContactedMembers method
    */
    @isTest
    static void testHandleExpiredContactedMembers() {
        Id acctRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer Person Account SFDC2').getRecordTypeId();
		Id finRTId = Schema.SObjectType.Financial_Account_SFDC2__c.getRecordTypeInfosByName().get('CD').getRecordTypeId();
		
		Account acct1 = new Account();
		acct1.LastName = 'Test01';
		acct1.RecordTypeId = acctRTId;
		acct1.Occupation_SFDC2__pc = 'Tester';
		acct1.PersonDoNotCall = false;
		Account acct2 = new Account();
		acct2.LastName = 'Test02';
		acct2.RecordTypeId = acctRTId;
		acct2.Occupation_SFDC2__pc = 'Tester';
		acct2.PersonDoNotCall = false;
		List<Account> accts = new List<Account>{acct1, acct2};
		insert accts;
		accts = [SELECT Person_Contact_Id__c FROM Account WHERE Id in :accts];
		
		Campaign c = new Campaign();
		c.Name = '30 Day CD Maturity';
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
		
		CampaignMember cm1 = new CampaignMember();
		cm1.CampaignId = c.Id;
		cm1.ContactId = accts[0].Person_Contact_Id__c;
		CampaignMember cm2 = new CampaignMember();
		cm2.CampaignId = c.Id;
		cm2.ContactId = accts[1].Person_Contact_Id__c;
		List<CampaignMember> cmList = new List<CampaignMember>{cm1,cm2};
		insert cmList;
		
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
		List<Id> faIdList = new List<Id>();
		for(Financial_Account_SFDC2__c fa : fas) {
			faIDList.add(fa.Id);
		}
		
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
		
		Financial_Account_Campaign_Link_SFDC2__c fasc1 = new Financial_Account_Campaign_Link_SFDC2__c();
		fasc1.Campaign__c = c.Id;
		fasc1.Financial_Account__c = fas[0].Id;
		Financial_Account_Campaign_Link_SFDC2__c fasc2 = new Financial_Account_Campaign_Link_SFDC2__c();
		fasc2.Campaign__c = c.Id;
		fasc2.Financial_Account__c = fas[1].Id;
		Financial_Account_Campaign_Link_SFDC2__c[] fascLinks = new List<Financial_Account_Campaign_Link_SFDC2__c>{fasc1,fasc2};
		insert fascLinks;
		
		cmList = [SELECT Status,ContactId FROM CampaignMember WHERE CampaignId = :c.Id];
		System.assertEquals(2, cmList.size());
		
		cmList[0].Status = 'Expired';
		cmList[1].Status = 'Contacted';
		
		Test.startTest();
		update cmList;
		Test.stopTest();
		
		cmList = [SELECT Status,ContactId FROM CampaignMember WHERE CampaignId = :c.Id];
		System.assertEquals(0, cmList.size());
		
		Task[] tasks = [SELECT Id FROM Task WHERE WhatId in :faIDList];
		System.assertEquals(2, tasks.size());
    }
}