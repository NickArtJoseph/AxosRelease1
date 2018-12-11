@isTest
private class UserTriggerHandler_Test {
	
	/**
	* Set up test records
	*/
	@testSetup
	static void init() {
		//create test users for roles that will trigger lead reassignments
        List<User> testUserList = new List<User>();
        Set<String> testProfile = new Set<String>{'Enterprise User'};
        User tUser = TestDataFactory.createTestUsers(testProfile)[0];
        for(String r : UserTriggerHandler.roleLeadQueueMap.keySet()) {
        	User testUser = tUser.clone();
        	testUser.Username = 'test@testusertrigger.org.' + r;
        	testUser.CommunityNickname = r;
        	Id roleId;
        	for(UserRole ur : UserTriggerHandler.roleMap.values()) {
        		if(ur.DeveloperName == r) {
        			roleId = ur.Id;
        			break;
        		}
        	} 
        	testUser.UserRoleId = roleId;
        	testUserList.add(testUser);
        }
        System.debug('Adding test users: ' + testUserList.size());
        System.assert(testUserList.size() > 0);
        insert testUserList;
	}
	
	/**
	* Handles test for handleLeadReassignment functionality
	*/
	@isTest
    static void testHandleLeadReassignment() {
    	TriggerValidator.setIsTest();
    	
    	List<User> testUserList = [SELECT UserRoleId, UserRole.Name FROM User WHERE Username LIKE 'test@testusertrigger.org.%'];
    	System.assert(testUserList.size() > 0);
        //for every test user, create a test Lead record and assign ownership to that user
        User apiUser = [select Id from user where profile.name = 'API Service Account' limit 1][0];
        List<Lead> testLeadList = new List<Lead>();
        Id leadRT = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Business Banking SFDC2').getRecordTypeId();
        for(User u : testUserList) {
        	Lead l = new Lead(FirstName='Test',
  								LastName='Contact',
  								Email='testcontact@test.com',
  								Company='Test' + u.id,
  								OwnerId = u.Id,
  								RecordTypeId = leadRT,
  								SFDC2__c = true);
        	testLeadList.add(l);
        }
        System.runAs(apiUser) {
        	insert testLeadList;
        }
        //ensure that inserted records belong to users
        List<Lead> afterInsertList = [SELECT OwnerId, Owner.Type, Owner.UserRole.DeveloperName FROM Lead WHERE Id IN :testLeadList]; 
        for(Lead l : afterInsertList) {
        	System.assertEquals('User', l.Owner.Type);
        }
        
        Test.startTest();
        //deactivate test users
        for(User u : testUserList) {
        	u.IsActive = false;
        }
        update testUserList;
        Test.stopTest();
        
        List<Lead> afterUpdateList = [SELECT OwnerId, Owner.Type FROM Lead WHERE Id IN :testLeadList];
        for(Lead l : afterUpdateList) {
        	System.assertNotEquals('User', l.Owner.Type);
        	Lead priorLead;
        	for(Lead pl : afterInsertList) {
        		if(pl.Id == l.Id) {
        			priorLead = pl;
        			break;
        		}
        	}
        	System.assertNotEquals(null, priorLead);
        	String ownerRoleName = priorLead.Owner.UserRole.DeveloperName;
        	String queueName = UserTriggerHandler.queueMap.get(l.OwnerId).DeveloperName;
        	System.assertEquals(UserTriggerHandler.roleLeadQueueMap.get(ownerRoleName), queueName);
        }
    }
    
    /**
	* Handles test for handleOppReassignment functionality
	*/
	@isTest
    static void testHandleOppReassignment() {
    	TriggerValidator.setIsTest();
    	
    	
    	Id oppAutoRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Auto Loan Indirect SFDC2').getRecordTypeId();
    	Id acctRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account SFDC2').getRecordTypeId();
    	List<User> testUserList = [SELECT UserRoleId, UserRole.Name FROM User WHERE Username LIKE 'test@testusertrigger.org.%'];
    	System.assert(testUserList.size() > 0);
        //for every test user, create a test Opportunity record and assign ownership to that user
        User apiUser = [select Id from user where profile.name = 'API Service Account' limit 1][0];
        List<Opportunity> testOppList = new List<Opportunity>();
        System.runAs(apiUser) {
	        Account a = new Account(Name='TestAccount', RecordTypeId=acctRT, SFDC2__c = true);
	        insert a;
	        
	        for(User u : testUserList) {
	        	Opportunity o = new Opportunity(
	        						AccountId = a.id,
	        						Name='Test' + u.id,
	  								StageName='1 - New',
	  								CloseDate = Date.today(),
	  								RecordTypeId = oppAutoRT,
	  								LeadSource = 'Advisor',
	  								OwnerId = u.Id);
	        	testOppList.add(o);
	        }

        	insert testOppList;
        }
        //ensure that inserted records belong to users
        List<Opportunity> afterInsertList = [SELECT OwnerId, Owner.UserRole.DeveloperName FROM Opportunity WHERE Id IN :testOppList]; 
        for(Opportunity o : afterInsertList) {
        	Boolean isValidOwner = false;
        	for(User u : testUserList) {
        		if(u.Id == o.OwnerId) {
        			isValidOwner = true;
        			break;
        		}
        	}
        	System.assert(isValidOwner);
        }
        
        Test.startTest();
        //deactivate test users
        for(User u : testUserList) {
        	u.IsActive = false;
        }
        update testUserList;
        Test.stopTest();
        
        List<Opportunity> afterUpdateList = [SELECT OwnerId, (SELECT OwnerId FROM Opportunity_Queues__r) FROM Opportunity WHERE Id IN :testOppList];
        for(Opportunity o : afterUpdateList) {
        	//System.assertEquals(apiUser.Id, o.OwnerId);
        	System.assert(o.Opportunity_Queues__r.size() > 0);
        	Opportunity priorOpp;
        	for(Opportunity po : afterInsertList) {
        		if(po.Id == o.Id) {
        			priorOpp = po;
        			break;
        		}
        	}
        	Opportunity_Queue__c oppQueue = o.Opportunity_Queues__r[0];
        	System.assertNotEquals(null, priorOpp);
        	String ownerRoleName = priorOpp.Owner.UserRole.DeveloperName;
        	String queueName = UserTriggerHandler.queueMap.get(oppQueue.OwnerId).DeveloperName;
        	System.assertEquals(UserTriggerHandler.roleOppQueueMap.get(ownerRoleName), queueName);
        }
    }
}