@isTest
private class UDB_User_Update_Test {
	static String createTestRecords() {
    	Case caseTest = new Case(
     		Origin = 'UDB',
     		Priority = 'Standard',
     		Status = 'New',
     		Description = 'Running Test',
     		IsVisibleSelfService__c = false,
            recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('UDB Inquiry').getRecordTypeId());

    	insert caseTest;
    	UDB_Secure_Messaging__c taskTest = new UDB_Secure_Messaging__c(
    		Related_To__c = caseTest.Id,
    		Description__c = 'This is a test',
    		ActivityDate__c = System.Today(),
            Assigned_To__c = UserInfo.getUserId()
    		);

        return caseTest.Id;
    }

    @isTest 
    static void testUserUpdate() {
    	String caseId = createTestRecords();
    	
    	String testUpdate = UDB_User_Update.updateData(caseId);
    }
}