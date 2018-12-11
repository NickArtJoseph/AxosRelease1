@isTest
private class ApplicationTriggerHandler_Test {

   @TestSetUp static void initData(){
        Database.insert(new campaign(Name = 'Incomplete Application'));
        Map<String,RecordType> mapApplcntRTsByDevName = UtilsSFDC2.getRecordTypesMap('Applicant_SFDC2__c','DeveloperName');
        Map<String,RecordType> mapAppsRTsByDevName = UtilsSFDC2.getRecordTypesMap('Application_SFDC2__c','DeveloperName');
        Application_SFDC2__c app = new Application_SFDC2__c(
                Name = 'Test TCI Application',
                Application_Status__c = 'Pending',
                RecordTypeId = mapAppsRTsByDevName.get('TCI').Id
            );
        insert app;
        Applicant_SFDC2__c applnt = new Applicant_SFDC2__c(
                Application_Id__c = app.Id,
                First_Name__c = 'Test',
                Last_Name__c = 'TCI',
                Email__c = 'test.contacttci@test.com',
                RecordTypeId =  mapApplcntRTsByDevName.get('TCI').Id
            ); 
        insert applnt;
    }

    @isTest
    static void updateTCIRecord() {
        List<Application_SFDC2__c> updApp = new List<Application_SFDC2__c>();
        Test.startTest();
            for(Application_SFDC2__c a : [select Id, Application_Status__c from Application_SFDC2__c where Name = 'Test TCI Application' limit 1]) {
                a.Application_Status__c = 'Approved';
                updApp.add(a);
            }
            if(!updApp.isEmpty()) {
                update updApp;
            }
        Test.stopTest();
        System.assertEquals('Approved', updApp[0].Application_Status__c);
    }

}