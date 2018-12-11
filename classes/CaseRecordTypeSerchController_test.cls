@isTest
private class CaseRecordTypeSerchController_test {
    
    @isTest static void searchCasesRecordTypesTest() {
        // Implement test code

        System.debug('Star test');
        Test.startTest();
            Datetime dtF  = System.now();
            Case caseTest = new Case();
            caseTest.Subject = 'Test Case';
            caseTest.Priority = 'VIP';
            caseTest.Status = 'New';
            caseTest.Origin = 'Web';
            caseTest.Future_Action_Date__c = dtF+5;
            insert caseTest;
            CaseRecordTypeSerchController cRT = new CaseRecordTypeSerchController (new ApexPages.StandardController(caseTest));

            cRT.toggleSort();
            cRT.runSearch();
        Test.stopTest();

    }
    

    
}