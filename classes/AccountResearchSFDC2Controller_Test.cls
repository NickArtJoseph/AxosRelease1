@isTest
private class AccountResearchSFDC2Controller_Test {

    @isTest static void should_request_account_research() {
        Map<String, RecordType> mapAccountRecordTypes = UtilsSFDC2.getRecordTypesMap('Account', 'DeveloperName');

        String uniqueUserName = 'user@bofi.com.apextest';

        UserRole r = new UserRole(DeveloperName = 'Research_Manager', Name = 'Research Manager');
        insert r;

        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];

        User u = new User(
            Alias             = 'standt',
            Email             = 'user@bofi.com.apextest',
            EmailEncodingKey  = 'UTF-8',
            LastName          = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey      = 'en_US',
            ProfileId         = p.Id,
            UserRoleId        = r.Id,
            TimeZoneSidKey    = 'America/Los_Angeles',
            UserName          = uniqueUserName,
            Department        = 'Department',
            Division          = 'Division ',
            Trained_SFDC2__c  = true,
            ManagerId         = UserInfo.getUserId()
        );

        Account acc = new Account();
        System.runAs(u) {
            acc = new Account(
                Name         = 'Test Business Account',
                OwnerId      = UserInfo.getUserId(),
                RecordTypeId = mapAccountRecordTypes.get('Business_Account_SFDC2').Id
            );
            insert acc;
        }

        Account accountRecord = AccountResearchSFDC2Controller.getAccount(acc.Id);

        Test.startTest();
            System.runAs(u) {
                accountRecord.Research_Request_Type_SFDC2__c = 'Bad phone numbers';
                accountRecord.Research_Request_Notes_SFDC2__c = 'TEST NOTES';
                AccountResearchSFDC2Controller.requestResearch(accountRecord);
            }
        Test.stopTest();

        // Verify results
        accountRecord = AccountResearchSFDC2Controller.getAccount(acc.Id);

        System.assertEquals('Prospecting_Business_SFDC2', accountRecord.RecordType.DeveloperName);
        System.assert(String.isNotBlank(accountRecord.Research_Requested_By_SFDC2__c));
        System.assertEquals('Bad phone numbers', accountRecord.Research_Request_Type_SFDC2__c);
        System.assertEquals('TEST NOTES', accountRecord.Research_Request_Notes_SFDC2__c);
        System.assertEquals('Request', accountRecord.ResearchAction_SFDC2__c);
    }

    @isTest static void should_return_account_research() {
        Map<String, RecordType> mapAccountRecordTypes = UtilsSFDC2.getRecordTypesMap('Account', 'DeveloperName');

        String uniqueUserName = 'user@bofi.com.apextest';

        UserRole r = new UserRole(DeveloperName = 'Research_Manager', Name = 'Research Manager');
        insert r;

        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];

        User u = new User(
            Alias             = 'standt',
            Email             = 'user@bofi.com.apextest',
            EmailEncodingKey  = 'UTF-8',
            LastName          = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey      = 'en_US',
            ProfileId         = p.Id,
            UserRoleId        = r.Id,
            TimeZoneSidKey    = 'America/Los_Angeles',
            UserName          = uniqueUserName,
            Department        = 'Department',
            Division          = 'Division ',
            Trained_SFDC2__c  = true,
            ManagerId         = UserInfo.getUserId()
        );

        Account acc = new Account();
        System.runAs(u) {
            acc = new Account(
                Name         = 'Test Business Account',
                OwnerId      = UserInfo.getUserId(),
                RecordTypeId = mapAccountRecordTypes.get('Prospecting_Business_SFDC2').Id,
                Research_Requested_By_SFDC2__c = UserInfo.getUserId()
            );
            insert acc;
        }

        Test.startTest();
            System.runAs(u) {
                Task newTask = AccountResearchSFDC2Controller.getReturnResearchTask(acc.Id);
                AccountResearchSFDC2Controller.returnResearch(newTask, acc.Id);
            }
        Test.stopTest();

        // Verify results
        Account accountRecord = AccountResearchSFDC2Controller.getAccount(acc.Id);

        System.assertEquals('Business_Account_SFDC2', accountRecord.RecordType.DeveloperName);
        System.assertEquals(null, accountRecord.Research_Requested_By_SFDC2__c);
        System.assertEquals('Return', accountRecord.ResearchAction_SFDC2__c);

        Task[] insertedTasks = [SELECT Id, Subject FROM Task WHERE Subject = 'Research Returned'];
        System.assertEquals(1, insertedTasks.size());
    }

	@isTest static void should_cancel_account_research() {
		Map<String, RecordType> mapAccountRecordTypes = UtilsSFDC2.getRecordTypesMap('Account', 'DeveloperName');

		String uniqueUserName = 'user@bofi.com.apextest';

		UserRole r = new UserRole(DeveloperName = 'Research_Manager', Name = 'Research Manager');
		insert r;

		Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];

        User u = new User(
        	Alias             = 'standt',
        	Email             = 'user@bofi.com.apextest',
        	EmailEncodingKey  = 'UTF-8',
        	LastName          = 'Testing',
        	LanguageLocaleKey = 'en_US',
        	LocaleSidKey      = 'en_US',
        	ProfileId         = p.Id,
        	UserRoleId        = r.Id,
        	TimeZoneSidKey    = 'America/Los_Angeles',
        	UserName          = uniqueUserName,
        	Department        = 'Department',
        	Division          = 'Division ',
        	Trained_SFDC2__c  = true,
        	ManagerId         = UserInfo.getUserId()
        );

        Account acc = new Account();
        System.runAs(u) {
	        acc = new Account(
				Name         = 'Test Business Account',
				OwnerId      = UserInfo.getUserId(),
				RecordTypeId = mapAccountRecordTypes.get('Prospecting_Business_SFDC2').Id,
				Research_Requested_By_SFDC2__c = UserInfo.getUserId()
			);
			insert acc;
        }

        Test.startTest();
        	System.runAs(u) {
        		AccountResearchSFDC2Controller.cancelResearch(acc.Id);
	        }
        Test.stopTest();

        // Verify results
       	Account accountRecord = AccountResearchSFDC2Controller.getAccount(acc.Id);

		System.assertEquals('Business_Account_SFDC2', accountRecord.RecordType.DeveloperName);
		System.assertEquals(null, accountRecord.Research_Requested_By_SFDC2__c);
        System.assertEquals('Cancel', accountRecord.ResearchAction_SFDC2__c);
	}

	// Test should fail when Canceling user is different from Requestor user
	@isTest static void should_not_cancel_account_research() {
		Map<String, RecordType> mapAccountRecordTypes = UtilsSFDC2.getRecordTypesMap('Account', 'DeveloperName');

		String uniqueUserName = 'user@bofi.com.apextest';

		UserRole r = new UserRole(DeveloperName = 'Research_Manager', Name = 'Research Manager');
		insert r;

		Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];

        User u = new User(
        	Alias             = 'standt',
        	Email             = 'user@bofi.com.apextest',
        	EmailEncodingKey  = 'UTF-8',
        	LastName          = 'Testing',
        	LanguageLocaleKey = 'en_US',
        	LocaleSidKey      = 'en_US',
        	ProfileId         = p.Id,
        	UserRoleId        = r.Id,
        	TimeZoneSidKey    = 'America/Los_Angeles',
        	UserName          = uniqueUserName,
        	Department        = 'Department',
        	Division          = 'Division ',
        	Trained_SFDC2__c  = true,
        	ManagerId         = UserInfo.getUserId()
        );

        Account acc = new Account();
        System.runAs(u) {
	        acc = new Account(
				Name         = 'Test Business Account',
				OwnerId      = UserInfo.getUserId(),
				RecordTypeId = mapAccountRecordTypes.get('Prospecting_Business_SFDC2').Id
			);
			insert acc;
        }

        Test.startTest();
        	System.runAs(u) {
        		try {
        			AccountResearchSFDC2Controller.cancelResearch(acc.Id);
        		} catch(Exception e) {
        			// Ignore exception
        		}
	        }
        Test.stopTest();

        // Verify results
       	Account accountRecord = AccountResearchSFDC2Controller.getAccount(acc.Id);

		System.assertEquals('Prospecting_Business_SFDC2', accountRecord.RecordType.DeveloperName);
		System.assertEquals(null, accountRecord.Research_Requested_By_SFDC2__c);
	}
}