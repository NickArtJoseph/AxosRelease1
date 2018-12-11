/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestTaskTouchParentObject {

	static Id makeAccount() {
		Account a = new Account(Name='TestAccount');
		insert a;
		return a.Id;
	}

    static testMethod void testTaskOnAccount() {
        Id account = makeAccount();
        Task t = new Task(WhatId = account,Subject='Test',CallType='Inbound');
        insert t;

        Account l = [select Last_Activity_Datetime__c from Account where Id=:account];
        System.assert(l.Last_Activity_Datetime__c!=null,'Last_Activity_Datetime__c on Account should be filled');
    }

	static Id makeLead() {
		Lead l = new Lead(FirstName='Test',LastName='Lead',Company='Test');
		insert l;
		return l.Id;
	}

    static testMethod void testTaskOnLead() {
        Id lead = makeLead();
        Task t = new Task(WhoId = lead,Subject='Test',CallType='Inbound');
        insert t;

        Lead l = [select Last_Activity_Datetime__c from Lead where Id=:lead];
        System.assert(l.Last_Activity_Datetime__c!=null,'Last_Activity_Datetime__c on Lead should be filled');
    }
	
	static Id makeContact() {
		Id account = makeAccount();
		Contact l = new Contact(FirstName='Test',LastName='Lead',AccountId=account);
		insert l;
		return l.Id;
	}

    static testMethod void testTaskOnContact() {
        Id newObj = makeContact();
        Task t = new Task(WhoId = newObj,Subject='Test',CallType='Inbound');
        insert t;

        Contact l = [select Last_Activity_Datetime__c from Contact where Id=:newObj];
        System.assert(l.Last_Activity_Datetime__c!=null,'Last_Activity_Datetime__c on Contact should be filled');
    }
	
	static Id makeOpportunity() {
		Id account = makeAccount();
		Schema.DescribeFieldResult stageDesc = Opportunity.StageName.getDescribe();
		List<Schema.PicklistEntry> stages = stageDesc.getPicklistValues();
		Schema.PicklistEntry firstStage = stages.get(0);
		Opportunity l = new Opportunity(Name='Test',AccountId=account,CloseDate=System.Today(),StageName=firstStage.getValue());
		insert l;
		return l.Id;
	}

    static testMethod void testTaskOnOpportunity() {
        Id newObj = makeOpportunity();
        Task t = new Task(WhatId = newObj,Subject='Test',CallType='Inbound');
        insert t;

        Opportunity l = [select Last_Activity_Datetime__c from Opportunity where Id=:newObj];
        System.assert(l.Last_Activity_Datetime__c!=null,'Last_Activity_Datetime__c on Opportunity should be filled');
    }
	
	static Id makeCampaign() {
		Campaign l = new Campaign(Name='Test');
		insert l;
		return l.Id;
	}

    static testMethod void testTaskOnCampaign() {
        Id newObj = makeCampaign();
        Task t = new Task(WhatId = newObj,Subject='Test',CallType='Inbound');
        insert t;

        Campaign l = [select Last_Activity_Datetime__c from Campaign where Id=:newObj];
        System.assert(l.Last_Activity_Datetime__c!=null,'Last_Activity_Datetime__c on Campaign should be filled');
    }
	
	static Id makeContract() {
		Id account = makeAccount();
		Contract l = new Contract(AccountId=account,StartDate=System.Today(),ContractTerm=12);
		insert l;
		return l.Id;
	}

    static testMethod void testTaskOnContract() {
        Id newObj = makeContract();
        Task t = new Task(WhatId = newObj,Subject='Test',CallType='Inbound');
        insert t;

        Contract l = [select Last_Activity_Datetime__c from Contract where Id=:newObj];
        System.assert(l.Last_Activity_Datetime__c!=null,'Last_Activity_Datetime__c on Contract should be filled');
    }

    static testMethod void testTaskNotByCTI() {
        Id lead = makeLead();
        //No calltype
        Task t = new Task(WhoId = lead,Subject='Test');
        insert t;

        Lead l = [select Last_Activity_Datetime__c from Lead where Id=:lead];
        System.assert(l.Last_Activity_Datetime__c==null,'Last_Activity_Datetime__c on Lead should be null');
    }

    static testMethod void testMultipleTasksOnOneObject() {
        Id lead = makeLead();
        List<Task> tasks = new List<Task>();

        tasks.add(new Task(WhoId = lead,Subject='Test'));
        tasks.add(new Task(WhoId = lead,Subject='Test2'));
        insert tasks;
    }
}