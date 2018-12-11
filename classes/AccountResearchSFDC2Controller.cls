public class AccountResearchSFDC2Controller {

	@AuraEnabled
	public static Account getAccount(String accountId) {
		return [
			SELECT Id, OwnerId, Owner.UserRole.Name, RecordTypeId, RecordType.DeveloperName, Research_Requested_By_SFDC2__c,
				Research_Request_Type_SFDC2__c, Research_Request_Notes_SFDC2__c, CIF_SFDC2__c, ResearchAction_SFDC2__c
			FROM Account
			WHERE Id = :accountId
		];
	}

	// Execute Research Request
	@AuraEnabled
	public static void requestResearch(Account accountRecord) {
		// Requestor must be the account owner
		if (UserInfo.getUserId() != accountRecord.OwnerId) {
			throw new AuraHandledException(Label.AccountResearchSFDC2_RequestResearchOwnerError);
		}

		// Validate Phones and Emails with BAD status
		Phone_SFDC2__c[] phones = [SELECT Id FROM Phone_SFDC2__c WHERE Account__c = :accountRecord.Id AND Phone_Status__c != 'Bad'];
		Email_SFDC2__c[] emails = [SELECT Id FROM Email_SFDC2__c WHERE Account__c = :accountRecord.Id AND Email_Status__c != 'Bad'];
		if(!phones.isEmpty()) {
			throw new AuraHandledException(Label.AccountResearchSFDC2_RequestResearchPhonesError);
		}
		if(!emails.isEmpty()) {
			throw new AuraHandledException(Label.AccountResearchSFDC2_RequestResearchEmailsError);
		}

		// Make sure this is not a JH customer
		if (String.isNotBlank(accountRecord.CIF_SFDC2__c)) {
			throw new AuraHandledException(Label.AccountResearchSFDC2_RequestResearchJHError);
		}

		// Assign new record type to account
		Map<String, RecordType> mapAccountRecordTypes = AccountResearchSFDC2Controller.getNewAccountRecordTypes('Request/Cancel');
		RecordType newRecordType = mapAccountRecordTypes.get(accountRecord.RecordType.DeveloperName);
		if (newRecordType != null)  { accountRecord.RecordTypeId = newRecordType.Id; }

		// Assign account to Research Manager
		try {
			User researchManager = [SELECT Id FROM User WHERE UserRole.Name = 'Research Manager' LIMIT 1];
			accountRecord.OwnerId = researchManager.Id;
		} catch(Exception e) {
			throw new AuraHandledException(Label.AccountResearchSFDC2_RequestResearchManagerError);
		}

		// Assign current user as Requestor
		accountRecord.Research_Requested_By_SFDC2__c = UserInfo.getUserId();
		accountRecord.ResearchAction_SFDC2__c = 'Request';

		// Update record
		Database.SaveResult sr = Database.update(accountRecord, false);
		if(!sr.isSuccess()) { throw new AuraHandledException(sr.getErrors()[0].getMessage()); }
	}

	// Execute Research Cancellation
	@AuraEnabled
	public static void cancelResearch(Id accountId) {
		Account accountRecord = AccountResearchSFDC2Controller.getAccount(accountId);

		// Validate current user (Only user who requested Research can Cancel it)
		Id currentUserId = UserInfo.getUserId();
		if (currentUserId != accountRecord.Research_Requested_By_SFDC2__c) {
			throw new AuraHandledException(Label.AccountResearchSFDC2Controller_CancelRequestError);
		}

		// Assign new record type to account
		Map<String, RecordType> mapAccountRecordTypes = AccountResearchSFDC2Controller.getNewAccountRecordTypes('Request/Cancel');
		RecordType newRecordType = mapAccountRecordTypes.get(accountRecord.RecordType.DeveloperName);
		if (newRecordType != null)  {
			accountRecord.RecordTypeId = newRecordType.Id;
		}

		accountRecord.OwnerId = currentUserId;
		accountRecord.Research_Requested_By_SFDC2__c  = null;
		accountRecord.Research_Request_Type_SFDC2__c  = null;
		accountRecord.Research_Request_Notes_SFDC2__c = null;
		accountRecord.ResearchAction_SFDC2__c = 'Cancel';

		// Update record
		Database.SaveResult sr = Database.update(accountRecord, false);
		if(!sr.isSuccess()) {
			throw new AuraHandledException(sr.getErrors()[0].getMessage());
		}
	}

	@AuraEnabled
	public static Task getReturnResearchTask(String accountId) {
		Account accountRecord = AccountResearchSFDC2Controller.getAccount(accountId);

		RecordType taskRecordType = UtilsSFDC2.getRecordTypesMap('Task', 'DeveloperName').get('SFDC2_Return_Account_Research');
		Task researchTask = new Task(
			RecordTypeId = taskRecordType.Id,
			OwnerId  = UserInfo.getUserId(),
			WhatId   = accountId,
			Subject  = 'Research Returned',
			Status   = 'Completed',
			Priority = 'Normal'
		);

		return researchTask;
	}

	@AuraEnabled
	public static String returnResearch(Task newTask, String accountId) {
		Account accountRecord = AccountResearchSFDC2Controller.getAccount(accountId);

		// Update Account
		if (accountRecord.Owner.UserRole.Name != 'Research Manager') {
			throw new AuraHandledException(Label.AccountResearchSFDC2_ReturnResearchTeamError);
		}

		// Assign new record type to account
		Map<String, RecordType> mapAccountRecordTypes = AccountResearchSFDC2Controller.getNewAccountRecordTypes('Request/Cancel');
		RecordType newRecordType = mapAccountRecordTypes.get(accountRecord.RecordType.DeveloperName);
		if (newRecordType != null)  {
			accountRecord.RecordTypeId = newRecordType.Id;
		}

		// Revert to Previous Owner
		accountRecord.OwnerId = accountRecord.Research_Requested_By_SFDC2__c;

		accountRecord.Research_Requested_By_SFDC2__c  = null;
		accountRecord.Research_Request_Type_SFDC2__c  = null;
		accountRecord.Research_Request_Notes_SFDC2__c = null;
		accountRecord.ResearchAction_SFDC2__c = 'Return';

		try {
			update accountRecord;
			insert newTask;
		} catch(Exception ex) {
			throw new AuraHandledException(ex.getMessage());
		}

		return newTask.Id;
	}

	// Get record type mappings for account research
	@testVisible
	private static Map<String, RecordType> getNewAccountRecordTypes(String operation) {

		// Get Account Record Types
		Map<String, RecordType> mapRecordTypes = UtilsSFDC2.getRecordTypesMap('Account', 'DeveloperName');

		// Get Account Research Record Type Mappings
		SFDC2AccountResearchRecordType__mdt[] lstRecordTypeMappings = UtilsSFDC2.getResearchRecordTypeMappings('Account', operation);

		// Map new Record types based on mappings
		Map<String, RecordType> mapNewRecordTypes = new Map<String, RecordType>();
		for(SFDC2AccountResearchRecordType__mdt recordTypeMapping: lstRecordTypeMappings) {
			mapNewRecordTypes.put(recordTypeMapping.CurrentRecordType__c, mapRecordTypes.get(recordTypeMapping.NewRecordType__c));
		}

		return mapNewRecordTypes;
	}
}