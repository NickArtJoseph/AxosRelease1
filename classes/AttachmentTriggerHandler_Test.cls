@isTest
private class AttachmentTriggerHandler_Test {

    static string instance = System.Url.getSalesforceBaseUrl().toExternalForm();

    @isTest static void testGetAttachment() {
        
        Case c = new Case(
            Origin = 'UDB',
            Priority = 'Standard',
            Status = 'New',
            UDB_CIF__c = 'Test_CIF_att',
            Description = 'Running Test',
            recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('UDB Inquiry').getRecordTypeId()
        );
        
        insert c;
    
        Blob bodyBlob = Blob.valueOf('Test_Att');
    
        Attachment a = new Attachment(
            ParentId = c.Id,
            Body = bodyBlob,
            Name = 'Test_Att'
        );
        
        insert a;
    }
}