/***    

    Author: Jaime Terrats
    Description: Test class to validate the functionality of sending secure messages as well as the visualization of a chosen template.
    
    Version Developer             Date          Description
    1.0     Jaime Terrats JT      03/16/2018    Test class creation
    1.1     Gabe Arce GA          09/27/2018    Update Sample Email Folder and Template

***/

@isTest
private class Secure_Support_Controller_Test {
    
    static Case createTestRecords() {
      Contact c =  new Contact(
        FirstName = 'Test',
        LastName = 'Test lastname',
        Phone =' 1231231234'
        );
      insert c;

      Case caseTest = new Case(
        Origin = 'UDB',
        Priority = 'Standard',
        Status = 'New',
        UDB_CIF__c = 'xxx111',
        Description = 'Running Test',
        Contact = c,
        recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('UDB Inquiry').getRecordTypeId()
      );

        insert caseTest;
        return caseTest;
    }
    @isTest
    static void testConstructor() {
        Case caseTest = createTestRecords();
        Test.startTest();
            Secure_Support_Controller smc = new Secure_Support_Controller(new ApexPages.StandardController(caseTest));
            smc.strSelectedFolder = [select Id, Name from Folder where Name = 'Axos - Consumer Deposits'].Id;
            smc.selectedTemplateId = [select Id from EmailTemplate where Name = 'Axos Bank - Close Account'].Id;
            smc.strSelectedTemp = [select Name from EmailTemplate where Name = 'Axos Bank - Close Account'].Name;
            smc.strTName = smc.strSelectedTemp;
        Test.stopTest();
    }

    @isTest 
    static void testGetTemplates() {
        Case caseTest = createTestRecords();
        Test.startTest();
            Secure_Support_Controller smc = new Secure_Support_Controller(new ApexPages.StandardController(caseTest));
            smc.lstEmailTemplates = [select Id from EmailTemplate where Name = 'Axos Bank - Close Account'];
            List<EmailTemplate> templates = smc.getTemplates();
        Test.stopTest();
    }

    @isTest
    static void testGetItems() {
        Case caseTest = createTestRecords();
        Test.startTest();
            Secure_Support_Controller smc = new Secure_Support_Controller(new ApexPages.StandardController(caseTest));
            List<SelectOption> items = smc.getItems();
        Test.stopTest();
    }

    @isTest
    static void testUpdatePreview() {
        Case caseTest = createTestRecords();
        Test.startTest();
            Secure_Support_Controller smc = new Secure_Support_Controller(new ApexPages.StandardController(caseTest));
            PageReference pv = smc.updatePreview();
        Test.stopTest();
    }

    @isTest
    static void testHide() {
        Case caseTest = createTestRecords();
        Test.startTest();
            Secure_Support_Controller smc = new Secure_Support_Controller(new ApexPages.StandardController(caseTest));
            PageReference h = smc.hide();
        Test.stopTest();
    }

    @isTest
    static void testRenderTemplate() {
        Case caseTest = createTestRecords();
        Test.startTest();
            Secure_Support_Controller smc = new Secure_Support_Controller(new ApexPages.StandardController(caseTest));
            smc.strTName = 'Axos Bank - Close Account';
            PageReference render = smc.renderTemplate();
        Test.stopTest();
    }

    @isTest
    static void testChangeTemplate() {
        Case caseTest = createTestRecords();
        Test.startTest();
            Secure_Support_Controller smc = new Secure_Support_Controller(new ApexPages.StandardController(caseTest));
            PageReference ct = smc.changeTemplate();
        Test.stopTest();
    }

    @isTest
    static void testSendMessage() {
        Case caseTest = createTestRecords();
        Test.startTest();
            Secure_Support_Controller smc = new Secure_Support_Controller(new ApexPages.StandardController(caseTest));
            PageReference sm = smc.sendMessage();
        Test.stopTest();
    }

    @isTest
    static void testAttachFile() {
        Case caseTest = createTestRecords();
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

        Secure_Support_Controller upload = new Secure_Support_Controller(new ApexPages.StandardController(caseTest));
        Secure_Support_Controller.attachFile(a.Name, caseTest.Id, base64String);
        Test.stopTest();
    }
}