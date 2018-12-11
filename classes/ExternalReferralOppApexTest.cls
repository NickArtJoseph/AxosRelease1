@isTest
public class ExternalReferralOppApexTest {
    static testmethod void testRecordTypesAvailables(){
        
        Id brokerPS = [Select id,name from PermissionSet where Name = 'External_Referral_Opportunity'].id;
    
        
        String uniqueUserName = 'enterpriseuser' + DateTime.now().getTime() + '@testorg.com';
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Enterprise User'];
        Profile pSA = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User u2 = new User(Alias = 'standt', Email='SAenterpriseuser@testorg.com',
                           EmailEncodingKey='UTF-8', LastName='SATesting', LanguageLocaleKey='en_US',
                           Trained_SFDC2__c = true, Department = 'Testing', Division = 'Testing',                        
                           LocaleSidKey='en_US', ProfileId = pSA.Id,
                           TimeZoneSidKey='America/Los_Angeles',
                           UserName='SA'+uniqueUserName);
        insert u2;
        User u = new User(Alias = 'standt', Email='enterpriseuser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          Trained_SFDC2__c = true, Department = 'Testing', Division = 'Testing',
                          ManagerId = u2.Id, 
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName=uniqueUserName);   
        insert u;
        PermissionSetAssignment psas = new PermissionSetAssignment (PermissionSetId = brokerPS, AssigneeId = u.Id);
        insert psas;      
        
        System.runAs(u) {
        Test.startTest();
            ExternalReferralOppApexController.getAvailableRecordTypes();
            Test.stopTest();
        }
        
    }
    static testmethod void testPrepopulateLead(){
        Account acc = new Account(BillingCity='Fake', BillingCountry='Fake', BillingState='Fake', BillingPostalCode='Fake', Sub_Branch_SFDC2__c='IPL', Name='Fake Inc', Phone='1234567890');
        insert acc;
        Contact con = new Contact(LastName='Tester' , MobilePhone = '1234567890', AccountId = acc.Id);
        insert con;
        
        Id subBranch = [SELECT Id FROM RecordType WHERE DeveloperName = 'C_I_SFDC2'].Id;
        System.assert(!String.isBlank(subBranch));
        
        ExternalReferralOppApexController.getFieldsToPopulate(con.Id,'Contact',subBranch);
    }
}