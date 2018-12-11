@isTest
private class UDBSecureMessagingTrigerHandler_Test {
	
	public static UDB_Secure_Messaging__c createTestData() {
    	Case caseTest = new Case(
        Origin = 'UDB',
        Priority = 'Standard',
        Status = 'New',
        UDB_CIF__c = 'xxx111',
        Description = 'Running Test',
        recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('UDB Inquiry').getRecordTypeId());

        insert caseTest;


		UDB_Secure_Messaging__c  sm = new UDB_Secure_Messaging__c(
			Related_To__c = caseTest.Id,
			Assigned_To__c = UserInfo.getUserId(),
			Description__c = 'This is a test',
			Customer_Read__c = null
			);

        return sm;
	}


	@isTest
	static void testHandleIsVisible() {
		UDB_Secure_Messaging__c sm = createTestData();
		System.Test.startTest();
		insert sm;
		System.Test.stopTest();
	}
}