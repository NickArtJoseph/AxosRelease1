@isTest
private class OpportunityTriggerHandler_Test {
    
    /**
* Set up test records
*/
    static void createTestUsers() {
        //create test users for roles that will trigger lead reassignments
        List<User> testUserList = new List<User>();
        Set<String> testProfile = new Set<String>{'Enterprise User'};
            User tUser = TestDataFactory.createTestUsers(testProfile)[0];
        for(String r : UserTriggerHandler.roleLeadQueueMap.keySet()) {
            User testUser = tUser.clone();
            testUser.Username = 'test@testusertrigger.org.' + r;
            testUser.CommunityNickname = r;
            Id roleId;
            for(UserRole ur : UserTriggerHandler.roleMap.values()) {
                if(ur.DeveloperName == r) {
                    roleId = ur.Id;
                    break;
                }
            } 
            testUser.UserRoleId = roleId;
            testUserList.add(testUser);
        }
        System.debug('Adding test users: ' + testUserList.size());
        System.assert(testUserList.size() > 0);
        insert testUserList;
    }
    
    /**
* Tests the handleConsumerDepositsCallAttemptUpdate method that is triggered beforeInsert, beforeUpdate for Opportunities
*/
    @isTest
    static void testHandleConsumerDepositsCallAttemptUpdate() {
        TriggerValidator.setIsTest();
        
        //create a test account
        Account a = new Account(Name='Test');
        insert a;
        
        //create a test opportunity for Consumer Deposits
        List<String> salesCallStatusList = new List<String>();
        salesCallStatusList.addAll(OpportunityTriggerHandler.CD_MAP_SALESCALLSTAGES.keySet());
        List<String> serviceCallStatusList = new List<String>();
        serviceCallStatusList.addAll(OpportunityTriggerHandler.CD_MAP_SERVICECALLSTAGES.keySet());
        
        String sampleCallStatus = salesCallStatusList.get(0);
        Opportunity o = new Opportunity(AccountId=a.Id, Name='Test', StageName='Open', LeadSource='Other', CloseDate=Date.today(), Sales_Lost_Reason__c='Test',Sales_Call_Attempts__c=sampleCallStatus, RecordTypeId=OpportunityTriggerHandler.CD_OPP_RECORDTYPEID);
        insert o;
        
        o = [Select Id, StageName From Opportunity Where Id = :o.Id];
        System.assertEquals(OpportunityTriggerHandler.CD_MAP_SALESCALLSTAGES.get(sampleCallStatus), o.StageName);
        
        //test update of service call attempts
        sampleCallStatus = serviceCallStatusList.get(0);
        o.Service_Call_Attempts__c = sampleCallStatus;
        update o;
        
        o = [Select Id, StageName From Opportunity Where Id = :o.Id];
        System.assertEquals(OpportunityTriggerHandler.CD_MAP_SERVICECALLSTAGES.get(sampleCallStatus), o.StageName);
    }
    
    
    /**
* Tests the checkConsumerDepositsStageChange method that is triggered beforeUpdate for Opportunities
*/
    /*@isTest
static void testCheckConsumerDepositsStageChange() {
TriggerValidator.setIsTest();

List<User> user = TestDataFactory.createTestUsers(new Set<String>{'Consumer Deposits Team'});
RecordType rt = [SELECT Id 
FROM RecordType 
WHERE IsActive = true AND
DeveloperName = 'Consumer_Deposits_Person_Accounts' AND 
SobjectType = 'Account'][0];

System.runAs(user.get(0)) {
//create a test account
Account a = TestDataFactory.createTestPersonAccount();
a.RecordTypeId= rt.Id;
insert a;

//create a test opportunity for Consumer Deposits
List<String> salesCallStatusList = new List<String>();
salesCallStatusList.addAll(OpportunityTriggerHandler.CD_MAP_SALESCALLSTAGES.keySet());
List<String> serviceCallStatusList = new List<String>();
serviceCallStatusList.addAll(OpportunityTriggerHandler.CD_MAP_SERVICECALLSTAGES.keySet());

Opportunity o = new Opportunity(AccountId=a.Id, Name='Test', StageName='Open', LeadSource='Other', CloseDate=Date.today(), RecordTypeId=OpportunityTriggerHandler.CD_OPP_RECORDTYPEID);
insert o;

o.StageName = 'Sale Won';
try {
update o;
System.assert(false, 'Stage should not have been allowed to update');
} catch (Exception e) {}
}
}
*/
    
    @isTest
    static void testHandleSFRetailOriginatorAutoPop() {
        TriggerValidator.setIsTest();
        
        //create a test account
        Account a = TestDataFactory.createTestPersonAccount();
        insert a;
        
        Id origRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Specialty Finance - Originator').getRecordTypeId();
        Account origA = new Account();
        origA.Name = 'Annuitants Federal Bank';
        origA.RecordTypeId = origRTId;
        insert origA;
        
        Id oppRetailSSRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Specialty Finance - Retail SS').getRecordTypeId();
        Opportunity o = new Opportunity();
        o.Name = 'Test';
        o.RecordTypeId = oppRetailSSRTId;
        o.AccountId = a.Id;
        o.StageName = 'Pricing';
        o.CloseDate = Date.today();
        
        Test.startTest();
        insert o;
        Test.stopTest();
        
        o = [SELECT Originator__c FROM Opportunity WHERE Id = :o.Id];
        
        System.assertEquals(origA.id, o.Originator__c);
    }
    
    /**
* Tests the handleContactToPersonAccountConvert method that is triggered beforeInsert for Opportunities
*/
    /* @isTest
static void testHandleContactToPersonAccountConvert() {
TriggerValidator.setIsTest();

String personAccountRTName = 'Business_Consumer_Person_Account';
String oppCDRTName = 'Consumer_Deposits_SFDC2';
String oppVirtusRTName = 'Virtus_SFDC2';
String busAccountRTName = 'Business_Account';
String busAccountRTId;		//record type id for Business Account
String personAccountRTId;	//record type id for Consumer Deposits Person Account
String oppCDRTId;			//record type id for Consumer Deposits Opportunity
String oppVirtusRTId;		//record type id for Virtus Opportunity

List<String> recordTypesToCheck = new List<String>{oppCDRTName, oppVirtusRTName};

for(RecordType rt : [
SELECT DeveloperName 
FROM RecordType 
WHERE IsActive = true 
AND( 
(SObjectType='Opportunity' AND DeveloperName in :recordTypesToCheck)
OR
(SObjectType='Account' AND IsPersonType=true AND DeveloperName=:personAccountRTName)
OR
(SObjectType='Account' AND IsPersonType=false AND DeveloperName=:busAccountRTName)
)
]) {
if(rt.DeveloperName == oppCDRTName) {
oppCDRTId = rt.Id;
} else if (rt.DeveloperName == oppVirtusRTName) {
oppVirtusRTId = rt.Id;
} else if (rt.DeveloperName == personAccountRTName) {
personAccountRTId = rt.Id;
} else if (rt.DeveloperName == busAccountRTName) {
busAccountRTId = rt.Id;
}
}
System.assertNotEquals(null, personAccountRTId, 'Missing Person Account record type');
System.assertNotEquals(null, oppCDRTId, 'Missing Consumer Deposits Opportunity record type');
System.assertNotEquals(null, oppVirtusRTId, 'Missing Virtus Opportunity record type');
System.assertNotEquals(null, busAccountRTId, 'Missing Business Account record type');

//create a test account
Account a = new Account(Name='Test', RecordTypeId=busAccountRTId);
insert a;

//create test contacts
//200 for Consumer Deposits opps
//200 for Virtus opps
//1 to test non-conversion
List<Contact> contactList = new List<Contact>();
for(Integer i=0; i < 42; i++) {
Contact c = new Contact();
c.LastName = 'Test' + i;
c.AccountId = a.Id;
c.Email = 'test' + i + '@example.com';
contactList.add(c);
}
insert contactList;

//create test opportunities
List<Opportunity> oppList = new List<Opportunity>();
for(Integer i=0; i < 42; i++) {
Contact c = contactList.get(i);
Opportunity o = new Opportunity();
o.Contact__c = c.Id;
o.AccountId = a.Id;
o.StageName = 'Open';
o.LeadSource = 'Other';
o.Branch__c = 'Virtus - 10';
o.Interest_Rate__c = 0;
o.CloseDate = Date.today();
if(i < 21) {
o.RecordTypeId = oppCDRTId;
o.Name = oppCDRTName + i;
} else if (i < 41) {
o.RecordTypeId = oppVirtusRTId;
o.Name = oppVirtusRTName + i;
} else {
o.Name = 'Test' + i;
}
oppList.add(o);
}

Test.startTest();
insert oppList;
Test.stopTest();

for(Opportunity o : [SELECT Name, AccountId, Account.RecordTypeId, Account.Employer_SFDC2__pc, Account.RecordType.DeveloperName, Contact__c FROM Opportunity WHERE Id in :oppList]) {
if(o.Name.startsWith('Test')) {
System.assertNotEquals(null, o.Contact__c);
} else {
System.assertEquals(null, o.Contact__c, 'Name=' + o.Name + '; Account Record Type=' + o.Account.RecordType.DeveloperName + '  ');
System.assertEquals(personAccountRTId, o.Account.RecordTypeId);
System.assertNotEquals(null, o.Account.Employer_SFDC2__pc); 
}
}

} */
    
    /**
* Tests the handleOpportunityQueueAssignment method that is triggered after insert
*/
    @isTest
    static void testHandleOpportunityQueueAssignment() {
        TriggerValidator.setIsTest();
        
        Account a = TestDataFactory.createAndInsertTestBusinessAccount();
        Opportunity o = new Opportunity(AccountId=a.Id, Name='Test', StageName='Open', LeadSource='RMI', CloseDate=Date.today());
        
        Test.startTest();
        insert o;
        Test.stopTest();
        
        Opportunity_Queue__c[] oq = [SELECT Id FROM Opportunity_Queue__c WHERE Opportunity__c = :o.Id];
        System.assertEquals(1, oq.size());
    }
    
    /**
* Handles test for handleOppReassignment functionality
*/
    @isTest
    static void testReassignOppToQueue() {
        TriggerValidator.setIsTest();
        createTestUsers();
        
        Id oppAutoRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Auto Loan Indirect SFDC2').getRecordTypeId();
        List<User> testUserList = [SELECT UserRoleId, UserRole.Name FROM User WHERE Username LIKE 'test@testusertrigger.org.%'];
        System.assert(testUserList.size() > 0);
        //for every test user, create a test Opportunity record and assign ownership to that user
        User apiUser = [select Id from user where profile.name = 'API Service Account' limit 1][0];
        List<Opportunity> testOppList = new List<Opportunity>();
        List<Opportunity> afterInsertList = new List<Opportunity>();
        System.runAs(apiUser) {
            Account a = new Account(Name='TestAccount');
            insert a;
            
            for(User u : testUserList) {
                Opportunity o = new Opportunity(
                    AccountId = a.id,
                    Name='Test' + u.id,
                    StageName='1 - New',
                    CloseDate = Date.today(),
                    RecordTypeId = oppAutoRT,
                    LeadSource = 'Advisor',
                    OwnerId = u.Id);
                testOppList.add(o);
            }
            
            insert testOppList;
            
            //ensure that inserted records belong to users
            afterInsertList = [SELECT OwnerId, Owner.UserRole.DeveloperName FROM Opportunity WHERE Id IN :testOppList]; 
            for(Opportunity o : afterInsertList) {
                Boolean isValidOwner = false;
                for(User u : testUserList) {
                    if(u.Id == o.OwnerId) {
                        isValidOwner = true;
                        break;
                    }
                }
                System.assert(isValidOwner);
            }
            Test.startTest();
            //flag opps for reassignment
            for(Opportunity o : afterInsertList) {
                o.Reassign_To_Queue_SFDC2__c = true;
            }
            update afterInsertList;
            Test.stopTest();
        }
        
        
        
        
        List<Opportunity> afterUpdateList = [SELECT OwnerId, (SELECT OwnerId FROM Opportunity_Queues__r) FROM Opportunity WHERE Id IN :testOppList];
        for(Opportunity o : afterUpdateList) {
            System.assertEquals(apiUser.Id, o.OwnerId);
            System.assert(o.Opportunity_Queues__r.size() > 0);
            Opportunity priorOpp;
            for(Opportunity po : afterInsertList) {
                if(po.Id == o.Id) {
                    priorOpp = po;
                    break;
                }
            }
            Opportunity_Queue__c oppQueue = o.Opportunity_Queues__r[0];
            System.assertNotEquals(null, priorOpp);
            String ownerRoleName = priorOpp.Owner.UserRole.DeveloperName;
            String queueName = UserTriggerHandler.queueMap.get(oppQueue.OwnerId).DeveloperName;
            System.assertEquals(UserTriggerHandler.roleOppQueueMap.get(ownerRoleName), queueName);
        }
    }
    
    //*SFDC2 Restrict Opporutunity Owner Change*// 
    
    @isTest
    public static void oppOwnerUpdateTest(){
        Profile adminProfile = [Select Id, Name From Profile Where Name= 'System Administrator'];
        User adminU = new User(
            FirstName='Test',
            LastName='UserAdmin',
            Alias='tuseradm',
            Email='tuseradm@test.org',
            Username='tuseradm@test.org',
            CommunityNickname='tuseradm',
            ProfileId=adminProfile.Id,
            TimeZoneSidKey='America/Los_Angeles',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            EmailEncodingKey='ISO-8859-1',
            Department='Test',
            Division='Test',
            Trained_SFDC2__c=true);
        
        insert adminU;
        Profile apip = [Select Id, Name From Profile Where Name = 'Api Service Account'];
        User apiu = new User(
            FirstName='Test',
            LastName='Enterprise User',
            Alias='tuserent',
            Email='tuserentrp@test.org.com',
            Username='tusereapiuserntrp@test.org.com',
            CommunityNickname='tuserEntrprise',
            ProfileId=apip.Id,
            TimeZoneSidKey='America/Los_Angeles',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            EmailEncodingKey='ISO-8859-1',
            Department='Test',
            Division='Test',
            Trained_SFDC2__c=true);
        
        insert apiu;
        Profile p = [Select Id, Name From Profile Where Name = 'Enterprise User'];
        Id oppAutoRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Business Banking SFDC2').getRecordTypeId();
        UserRole bnkmgrrole = [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName = 'Business_Banking_Manager'];
        User u = new User(
            FirstName='Test',
            LastName='Enterprise User',
            Alias='tuserent',
            Email='tuserentrp@test.org.com',
            Username='tuserentrp@test.org.com',
            CommunityNickname='tuserEntrprise1',
            ProfileId=p.Id,
            TimeZoneSidKey='America/Los_Angeles',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            EmailEncodingKey='ISO-8859-1',
            Department='Test',
            Division='Test',
            UserRoleId = bnkmgrrole.Id,
            ManagerId = adminU.Id,
            Trained_SFDC2__c=true);
        
        insert u;
        Group bsbkqu = new Group();
        bsbkqu.name = 'Business Banking Opportunity Queue';
        bsbkqu.Type = 'Queue';
        Insert bsbkqu;
        QueueSobject queobj = new QueueSobject();
        queobj.SobjectType = 'Opportunity_Queue__c';
        queobj.QueueId = bsbkqu.Id; 
        Insert queobj;
        //  Group bsbkqu = [SELECT Id FROM Group WHERE DeveloperName = 'Businesss_Banking_Opportunity_Queue'];
        Opportunity o;
        System.runAs(u){
            Account a = new Account(Name='TestAccount', SFDC2__c = true);
            insert a;
            System.debug(apiu.Id+'User'+u.Id);
            o = new Opportunity(
                AccountId = a.id,
                Name='Test' + u.id,
                StageName='1 - New',
                CloseDate = Date.today(),
                RecordTypeId = oppAutoRT,
                LeadSource = 'Advisor'
             //   OwnerId = u.Id
             );
            insert o;
         System.debug('o'+o);
            Opportunity_Queue__c opq = new Opportunity_Queue__c(OwnerId = bsbkqu.Id, Opportunity__c = o.Id);
            insert opq;
            o.OwnerId = apiu.Id;  
            update o;
            System.debug('o1'+o);
        }
        
        UserRole bnkreprole = [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName = 'Business_Banking'];
        System.debug(o+'bnkreprole'+bnkreprole);
        User repu = new User(
            FirstName='Test',
            LastName='Enterprise User rep',
            Alias='tuserent',
            Email='tuserentrp@test.org.com',
            Username='businessbkingrep@test.org.com',
            CommunityNickname='tuserEntrprise2',
            ProfileId=p.Id,
            TimeZoneSidKey='America/Los_Angeles',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            EmailEncodingKey='ISO-8859-1',
            Department='Test',
            Division='Test',
            UserRoleId = bnkreprole.Id,
            ManagerId = u.Id,
            Trained_SFDC2__c=true);
        
        insert repu;
        //System.runAs(u){
        //o.OwnerId = bsbkqu.Id;
        //update o;
        //}
    }
    
    
    
    /**
* Handles test for auto30DayCrossSell functionality
*/
    @isTest(seeAllData=true)
    static void testAuto30DayCrossSell() {
        TriggerValidator.setIsTest();
        
        Pricebook2 virtusPB = new Pricebook2(Name='Virtus', isActive=true);
        Pricebook2 businessPB = new Pricebook2(Name='Business Banking', isActive=true);
        Pricebook2[] customPBs = new List<Pricebook2>{virtusPB, businessPB};
            insert customPBs;
        virtusPB = customPBs[0];
        businessPB = customPBs[1];
        
        Product2 prod = new Product2(Name = 'Checking Account', 
                                     Family = 'Consumer Deposits');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        PricebookEntry virtusPBE = new PricebookEntry(
            Pricebook2Id = virtusPB.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true);
        PricebookEntry businessPBE = new PricebookEntry(
            Pricebook2Id = businessPB.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true);
        PricebookEntry[] customPrices = new List<PricebookEntry>{virtusPBE, businessPBE};
            insert customPrices;
        virtusPBE = customPrices[0];
        businessPBE = customPrices[1];
        
        Id virtusRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Virtus SFDC2').getRecordTypeId();
        Id bbRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Business Banking SFDC2').getRecordTypeId();
        Id cdRTId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Consumer Deposits SFDC2').getRecordTypeId();
        Id cdaRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer Person Account SFDC2').getRecordTypeId();
        Account a1 = new Account(LastName='TestAccountVirtus',Occupation_SFDC2__pc='Test',SFDC2__c=true, RecordTypeId=cdaRTId);
        Account a2 = new Account(LastName='TestAccountBB_CD',Occupation_SFDC2__pc='Test',SFDC2__c=true, RecordTypeId=cdaRTId);
        Account a3 = new Account(LastName='TestAccountBB_Virtus',Occupation_SFDC2__pc='Test',SFDC2__c=true, RecordTypeId=cdaRTId);
        Account[] accts = new List<Account>{a1,a2,a3};
            insert accts;
        Map<Id, Account> acctMap = new Map<Id, Account>([SELECT Name, Person_Contact_Id__c FROM Account WHERE Id in :accts]);
        //to test creation of Virtus cross sell we need a financial account > 50000
        Financial_Account_SFDC2__c fa = new Financial_Account_SFDC2__c();
        fa.Name = 'TEST Account';
        fa.Department__c = 'Mortgage Lending';
        fa.Balance__c = 51000;
        insert fa;
        Financial_Account_Contact_Link_SFDC2__c facl = new Financial_Account_Contact_Link_SFDC2__c();
        facl.Contact__c = acctMap.get(accts[2].Id).Person_Contact_Id__c; //associate with 3rd test account
        facl.Financial_Account__c = fa.Id;
        facl.CIF_JHA_LINK__c = '0000^TEST';
        insert facl;
        
        Opportunity o1 = new Opportunity();
        o1.AccountId = accts[0].id;
        o1.Name='TestVirtusOpp';
        o1.StageName='1 - New';
        o1.CloseDate = Date.today();
        o1.RecordTypeId = virtusRTId;
        o1.LeadSource = 'Advisor';
        o1.Pricebook2Id = virtusPB.Id;
        Opportunity o2 = new Opportunity();
        o2.AccountId = accts[1].id;
        o2.Name='TestBBOpp_CD';
        o2.StageName='1 - New';
        o2.CloseDate = Date.today();
        o2.RecordTypeId = bbRTId;
        o2.LeadSource = 'Advisor';
        o2.Pricebook2Id = businessPB.Id;
        Opportunity o3 = new Opportunity();
        o3.AccountId = accts[2].id;
        o3.Name='TestBBOpp_Virtus';
        o3.StageName='1 - New';
        o3.CloseDate = Date.today();
        o3.RecordTypeId = bbRTId;
        o3.LeadSource = 'Advisor';
        o3.Pricebook2Id = businessPB.Id;
        Opportunity[] opps = new List<Opportunity>{o1,o2,o3};
            insert opps;
        OpportunityLineItem oli1 = new OpportunityLineItem();
        oli1.PricebookEntryId = virtusPBE.Id;
        oli1.OpportunityId=opps[0].Id;
        oli1.UnitPrice=1;
        oli1.Quantity=1;
        OpportunityLineItem oli2 = new OpportunityLineItem();
        oli2.PricebookEntryId = businessPBE.Id;
        oli2.OpportunityId=opps[1].Id;
        oli2.UnitPrice=1;
        oli2.Quantity=1;
        OpportunityLineItem oli3 = new OpportunityLineItem();
        oli3.PricebookEntryId = businessPBE.Id;
        oli3.OpportunityId=opps[2].Id;
        oli3.UnitPrice=1;
        oli3.Quantity=1;
        OpportunityLineItem[] oliList = new List<OpportunityLineItem>{oli1,oli2,oli3};
            insert oliList;
        
        Test.startTest();
        for(Integer i = 0; i < opps.size(); i++) {
            opps[i].Cross_Sell_SFDC2__c = true;
            opps[i].StageName = '0 - Closed - Lost';
            opps[i].Sales_Lost_Reason__c = 'Lost';
        }
        update opps;
        Test.stopTest();
        
        accts = [SELECT Id, Name, (SELECT Id, Name, StageName, RecordTypeId, Cross_Sell_SFDC2__c FROM Opportunities) FROM Account WHERE Id in :accts];
        for(Account a : accts) {
            System.assertEquals(2, a.Opportunities.size());
            for(Opportunity opp : a.Opportunities) {
                System.assertEquals(false, opp.Cross_Sell_SFDC2__c);
                if(a.Name == 'TestAccountVirtus' && opp.StageName == '1 - New') {
                    System.assertEquals(bbRTId, opp.RecordTypeId);
                } else if (a.Name == 'TestAccountBB_CD' && opp.StageName == '1 - New') {
                    System.assertEquals(cdRTId, opp.RecordTypeId);
                } else if (a.Name == 'TestAccountBB_Virtus' && opp.StageName == '1 - New') {
                    System.assertEquals(virtusRTId, opp.RecordTypeId);
                }
            }
        }
    }
    
    
    //** SFDC2 C&I  Any user outside the C&I BU cannot create an Opportunity on an account 
    //if on that same account an Opportunity with C&I record type already exists in Stage 2-7**//
    
    @isTest
    public static void restrictAssignOppC_ItoAccC_I(){
               Test.startTest();
     //create a test account
        Account a = new Account(Name='Test');
        insert a;
        Id idCRESL = [Select id from RecordType where DeveloperName = 'CRESL_SFDC2' and SobjectType ='Opportunity'].Id;
        Opportunity o = new Opportunity(AccountId=a.Id, Name='Test', StageName='3 - Committed to Complete Application', C_I_Sub_Stage__c = 'Terms Negotiation', LeadSource='Other', CloseDate=Date.today() ,  RecordTypeId=idCRESL, Document_Tracking_checklist__c = 'Construction Loan');
        insert o;
        Opportunity o2 = new Opportunity(AccountId=a.Id, Name='Test2', StageName='3 - Committed to Complete Application', C_I_Sub_Stage__c = 'Terms Negotiation', LeadSource='Other', CloseDate=Date.today() ,  RecordTypeId=idCRESL, Document_Tracking_checklist__c = 'Construction Loan');
        insert o2;
        List<Opportunity> newOppList = new List<Opportunity>();
        newOppList.add(o);
        newOppList.add(o2);
        update newOppList;
        Test.stopTest();
        
    }
    
    
}