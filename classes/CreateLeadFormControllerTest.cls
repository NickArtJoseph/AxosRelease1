@isTest
public class CreateLeadFormControllerTest {

    static Lead createLead(String subName, String recordTypeId, String companyField ) {
/**
        SharepointFieldMapping__mdt[] lstRecordTypeFieldSettings = [
            SELECT RecordTypeName__c 
            FROM SharepointFieldMapping__mdt            
            ORDER BY RecordTypeName__c ASC
        ];
        Set<Id> setRecordTypeId = new Set<Id>();


        SharepointFieldMapping__mdt[] lstRecordTypeSetting = [
            SELECT SharepointSetting__c, Field__c, Field__r.QualifiedApiName, Value__c
            FROM SharepointFieldMapping__mdt 

        ];

        System.debug('****lstRecordTypeSetting' + lstRecordTypeSetting);

        for ( SharepointFieldMapping__mdt recordTypeName_mtd : lstRecordTypeFieldSettings ) {
            setRecordTypeId.add(Schema.SObjectType.Lead.getRecordTypeInfosByName().get(recordTypeName_mtd.RecordTypeName__c).getRecordTypeId());
        }
   
      
        System.debug('****recordTypeId ' + setRecordTypeId);
        System.debug('****lstRecordTypeSettings ' + lstRecordTypeFieldSettings);
      */

        Lead ld                         = new Lead();
        ld.FirstName                    = 'Test FN';
        ld.LastName                     = 'Test LN';
        ld.Email                        = 'test@example.com';
        ld.Phone                        = '(111)222-3333';
        ld.Description                  = 'This is a Test';
        ld.Broker_ID__c                 = '';
        ld.Sub_Branch_SFDC2__c          = subName;
        ld.Lead_Source_Detail_SFDC2__c  = 'Test FN';
        ld.Referring_Business_Unit__c   = '';
        ld.RecordTypeId                 = Schema.SObjectType.Lead.getRecordTypeInfosByName().get(recordTypeId).getRecordTypeId();
        ld.Company                      = companyField;
        return ld;
    }

    static User createTestUser(String fName, String lName, Id profId) {
        User newUser = new User();
        newUser.FirstName         = fName;
        newUser.LastName          = fName;
        newUser.Alias             = 'standt';
        newUser.Email             =  'test@test.com';
        newUser.Username          = 'axos_test_user@axosbank.com';
        newUser.ProfileId         = profId;
        newUser.IsActive          = true;
        newUser.LanguageLocaleKey ='en_US';
        newUser.LocaleSidKey      ='en_US';
        newUser.TimeZoneSidKey    ='America/Los_Angeles';
        newUser.EmailEncodingKey  ='UTF-8';
        
        
        return newUser;
    }

    static LeadShare createSharePermission(String accessLevel, Id leadId, Id userOrGroupId ) {
        LeadShare leadPermission = new LeadShare();

        leadPermission.LeadAccessLevel = accessLevel;
        leadPermission.LeadId          = leadId;
        leadPermission.UserOrGroupId   = userOrGroupId;

        return leadPermission;
    }

    static testmethod void create_lead_and_attach_files() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name ='Cross-Sell Referral Profile']; 
        User u = createTestUser('test', 'test', p.Id);
        insert u;

        Lead ld = createLead('IPL', 'IPL SFDC2', 'Unosquare'); 
        ApexPages.StandardController sc     = new ApexPages.StandardController(ld);
        CreateLeadFormController controller = new CreateLeadFormController(sc);
       	LeadShare newLead;
        System.runAs(u) { 
        	controller.saveLead();
            newLead = createSharePermission('Edit', ld.Id, u.Id);
	   	}
        
        
        
        insert newLead;
         System.debug('createSharePermission*****'+[SELECT Id, LeadAccessLevel, UserOrGroupId FROM LeadShare WHERE leadId =:ld.Id]);   
        for(Integer index  = 0 ; index < controller.numAtt ; index++) {
            Attachment att = new Attachment();
            att.Name       = 'Test Attachment ' + index;
            att.Body       = Blob.valueOf('Test Data ' + index );
            att.ParentId   = ld.Id;
            controller.mapAttachments.put(index, att);
        }
        
        controller.insertAttachments();
        
        // Validate test results
        System.assert(String.isNotBlank(ld.Id));
        Attachment[] lstAttachments = [SELECT Id, ParentId FROM Attachment WHERE ParentId = :ld.Id];
        System.assertEquals(controller.numAtt, lstAttachments.size());
       
    }

    static testmethod void create_lead_without_attachments() {
        Profile p = [SELECT Id FROM Profile WHERE Name ='Cross-Sell Referral Profile']; 
        User u = createTestUser('test', 'test', p.Id);
        insert u;
        
        Lead ld = createLead('Advisor Consumer', 'Advisor Firm SFDC2', 'Unosquare');
        ApexPages.StandardController sc     = new ApexPages.StandardController(ld);
        CreateLeadFormController controller = new CreateLeadFormController(sc);
        
        System.runAs(u){
            controller.saveLead();
        }

        for(Integer index = 0 ; index < controller.numAtt ; index++) {
            Attachment att = new Attachment();
            att.Name = 'Test Attachment ' + index;
            att.ParentId = ld.Id;
            controller.mapAttachments.put(index, att);
        }
        
        controller.insertAttachments();

        System.assert(String.isNotBlank(ld.Id));
        Attachment[] lstAttachments = [SELECT Id, ParentId FROM Attachment WHERE ParentId = :ld.Id];
        System.assertEquals(0, lstAttachments.size());
    }

    static testmethod void validate_phone_number() {
        Lead ld  = createLead('Advisor Consumer', 'Advisor Firm SFDC2', 'Unosquare');
        ld.Phone = 'notanumber';
        
        ApexPages.StandardController sc  = new ApexPages.StandardController(ld);
        CreateLeadFormController newLead = new CreateLeadFormController(sc);
        
        newLead.saveLead();

        System.assert(newLead.hasError == true);
        Lead[] lstLeads = [SELECT Id FROM Lead];
        System.assert(lstLeads.isEmpty());
    }
	
    static testmethod void validate_dynamicFields() {
        Lead ld  = createLead('Advisor Consumer', 'Advisor Firm SFDC2', 'Unosquare');
        ld.Company = '';
        
        ApexPages.StandardController sc  = new ApexPages.StandardController(ld);
        CreateLeadFormController newLead = new CreateLeadFormController(sc);
        
        newLead.saveLead();

        System.assert(newLead.hasError == true);
        Lead[] lstLeads = [SELECT Id FROM Lead];
        System.assert(lstLeads.isEmpty());
    }
	@isTest
    static void validate_duplicate() {
		Profile p = [SELECT Id FROM Profile WHERE Name ='Cross-Sell Referral Profile']; 
        User u = createTestUser('test', 'test', p.Id);
        insert u;
        
		Lead ld = createLead('IPL', 'IPL SFDC2', 'Unosquare');
        ApexPages.StandardController sc     = new ApexPages.StandardController(ld);
        CreateLeadFormController controller = new CreateLeadFormController(sc);
        
       System.runAs(u){
        	controller.saveLead();
       }
        
        LeadShare newLead = new LeadShare();
            newLead.LeadAccessLevel= 'Read';
            newLead.LeadId = ld.Id;
            newLead.UserOrGroupId= u.Id;
            insert newLead;
        
        Lead ldDuplicate = createLead('IPL', 'IPL SFDC2', 'Unosquare');
        ApexPages.StandardController scDuplicate     = new ApexPages.StandardController(ldDuplicate);
        CreateLeadFormController controllerDuplicate = new CreateLeadFormController(scDuplicate);
    	
        System.runAs(u){
        	controllerDuplicate.saveLead();
        }
        
        System.debug('DUPLICATED ID ' + [SELECT FirstName, LastName, Email FROM Lead LIMIT 2]);
        System.assert(String.isNotBlank(ld.Id));
        System.assert(String.isBlank(ldDuplicate.Id));
    }     
}