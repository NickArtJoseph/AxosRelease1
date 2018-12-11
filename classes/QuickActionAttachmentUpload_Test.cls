@isTest
private class QuickActionAttachmentUpload_Test {
	
	@isTest
	static Case createTestRecord() {
		Case caseTest = new Case(
            Origin = 'UDB',
            Priority = 'Standard',
            Status = 'New',
            UDB_CIF__c = 'xxx111',
            Description = 'Running Test',
            recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('UDB Inquiry').getRecordTypeId());

        insert caseTest;

        return caseTest;
	}

	@isTest
	static void testController() {
		Case caseTest = createTestRecord();
        Test.startTest();
        QuickActionAttachmentUpload attUpload = new QuickActionAttachmentUpload(new ApexPages.StandardController(caseTest));
        Test.stopTest();
	}

	@isTest
	static void testRemoteAction() {
		Case caseTest = createTestRecord();
		String base64String  = '';
		Blob bodyBlob = Blob.valueOf('Test_Att');

        Attachment a = new Attachment(
            ParentId = caseTest.Id,
            Body = bodyBlob,
            Name = 'Test_Att'
        );

        Test.startTest();
        insert a;
        base64String = EncodingUtil.base64Encode(a.Body);

        QuickActionAttachmentUpload upload = new QuickActionAttachmentUpload(new ApexPages.StandardController(caseTest));
        QuickActionAttachmentUpload.attachFile(a.Name, caseTest.Id, base64String);
        Test.stopTest();
	}
}