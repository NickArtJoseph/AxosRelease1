/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private without sharing class RequestLeadResearchSFDC2Controller_Test {

    /**
     * Test logic sending requests for Lead research
     */
    static testMethod void researchLeadRequestTest() {

        // set up test data
        User userBU, userRM;
        try {
            userBU = [select id from User where IsActive=True and Profile.Name='Enterprise User' and UserRole.Name!='Research Manager' LIMIT 1];
            userRM = [select id from User where IsActive=True and Profile.Name='Enterprise User' and UserRole.Name='Research Manager' LIMIT 1];
        } catch (QueryException qe) {
            System.debug(qe);
            return;
        }

        RecordType consumerRT = [select Id from RecordType where SObjectType='Lead' and DeveloperName='Consumer_Deposits'];
        RecordType businessRT = [select Id from RecordType where SObjectType='Lead' and DeveloperName='Business_Banking'];
        RecordType consumerProspectRT = [select Id from RecordType where SObjectType='Lead' and DeveloperName='Prospecting_Consumer_SFDC2'];
        RecordType businessProspectRT = [select Id from RecordType where SObjectType='Lead' and DeveloperName='Prospecting_Business_SFDC2'];
       
        Lead consumerLead = new Lead(FirstName='Test_First', LastName='Test_Consumer', OwnerId=userBU.Id, RecordTypeId=consumerRT.Id);
        Lead businessLead = new Lead(FirstName='Test_First', LastName='Test_Consumer', OwnerId=userBU.Id, RecordTypeId=businessRT.Id, Company='Test_Company');
        insert consumerLead;
        insert businessLead;

        // start test
        Test.startTest();
                
        RequestLeadResearchSFDC2Controller controller;

        
        // Request research as business unit user
        System.runAs(userBU) {
             
            // --- test consumer request research page
            Test.setCurrentPage(Page.RequestLeadResearchSFDC2);
            controller = new RequestLeadResearchSFDC2Controller(new ApexPages.StandardController(consumerLead));
            controller.requestType = 'PHONE';
            
            // Request consumer Lead research
            controller.sendLead();
            
            // Confirm updated record type
            System.assertEquals(consumerProspectRT.Id, consumerLead.RecordTypeId, 'Unexpected record type for researching consumer Lead.');
            
            // --- test business request research page
            Test.setCurrentPage(Page.RequestLeadResearchSFDC2);
            controller = new RequestLeadResearchSFDC2Controller(new ApexPages.StandardController(businessLead));
            controller.requestType = 'PHONE';
            
            // Request business Lead research
            controller.sendLead();
            
            // Confirm updated record type
            System.assertEquals(businessProspectRT.Id, businessLead.RecordTypeId, 'Unexpected record type for researching business Lead.');
            
            // --- test cancel button
            PageReference cancelPage = new PageReference('/' + businessLead.Id);
            System.assertEquals(cancelPage.getURL(), controller.cancel().getURL(), 'Unexpected return URL for cancel button.');
    
        }   
        
        Test.stopTest();        
    }
    
    /**
     * Test failure conditions on Lead requests
     */
    static testMethod void researchLeadRequestFailureTest() {

        // set up test data
        User userBU, userRM;
        try {
            userBU = [select id from User where IsActive=True and Profile.Name='Enterprise User' and UserRole.Name!='Research Manager' LIMIT 1];
            userRM = [select id from User where IsActive=True and Profile.Name='Enterprise User' and UserRole.Name='Research Manager' LIMIT 1];
        } catch (QueryException qe) {
            System.debug(qe);
            return;
        }

        RecordType consumerRT = [select Id from RecordType where SObjectType='Lead' and DeveloperName='Consumer_Deposits'];
        RecordType businessRT = [select Id from RecordType where SObjectType='Lead' and DeveloperName='Business_Banking'];
        RecordType consumerProspectRT = [select Id from RecordType where SObjectType='Lead' and DeveloperName='Prospecting_Consumer_SFDC2'];
        RecordType businessProspectRT = [select Id from RecordType where SObjectType='Lead' and DeveloperName='Prospecting_Business_SFDC2'];

        Lead businessLead = new Lead(FirstName='Test_First', LastName='Test_Consumer', OwnerId=userBU.Id, RecordTypeId=businessRT.Id, Company='Test_Company');
        insert businessLead;
        Phone_SFDC2__c phone = new Phone_SFDC2__c(Lead__c=businessLead.Id, Phone__c='(987) 654-1234', Phone_Status__c='Unverified', Phone_Type__c='Other Business');
        insert phone;
		Email_SFDC2__c email = new Email_SFDC2__c(Lead__c=businessLead.Id, Email__c='test@test.com', Email_Status__c='Unverified', Email_Type__c='Other Business');
		insert email;
        
        // start test
        Test.startTest();
        
        RequestLeadResearchSFDC2Controller controller;

        System.runAs(userBU) {
            
            Test.setCurrentPage(Page.ReturnLeadResearchSFDC2);
            controller = new RequestLeadResearchSFDC2Controller(new ApexPages.StandardController(businessLead));

            // --- test unused phone numbers
            controller.requestType = 'PHONE';
            
            // Try to request research
            controller.sendLead();
            
            // Confirm updated record type
            System.assertEquals(businessRT.Id, businessLead.RecordTypeId, 'Unexpected record type for business Lead with untested phone numbers.');
        
            // --- test unused email addresses
            controller.requestType = 'EMAIL';
            
            // Try to request research
            controller.sendLead();
            
            // Confirm updated record type
            System.assertEquals(businessRT.Id, businessLead.RecordTypeId, 'Unexpected record type for business Lead with untested email addresses.');

        }

        delete phone;
        
        businessLead = new Lead(FirstName='Test_First', LastName='Test_Consumer', OwnerId=userRM.Id, RecordTypeId=businessRT.Id, Company='Test_Company');
        insert businessLead;

        System.runAs(userBU) {
                    
            // --- test non-owner research request
            Test.setCurrentPage(Page.ReturnLeadResearchSFDC2);
            controller = new RequestLeadResearchSFDC2Controller(new ApexPages.StandardController(businessLead));
            
            // Try to request research
            controller.sendLead();
            
            // Confirm updated record type
            System.assertEquals(businessRT.Id, businessLead.RecordTypeId, 'Unexpected record type for business Lead research request by non-owner.');
            
        }
        
        Test.stopTest();
            
    }
    
    /**
     * Test logic for returning researched Leads to the requesting business unit
     */
    static testMethod void returnLeadTest() {

        // set up test data
        User userBU, userRM;
        try {
            userBU = [select id from User where IsActive=True and Profile.Name='Enterprise User' and UserRole.Name!='Research Manager' LIMIT 1];
            userRM = [select id from User where IsActive=True and Profile.Name='Enterprise User' and UserRole.Name='Research Manager' LIMIT 1];
        } catch (QueryException qe) {
            System.debug(qe);
            return;
        }

        RecordType consumerRT = [select Id from RecordType where SObjectType='Lead' and DeveloperName='Consumer_Deposits'];
        RecordType businessRT = [select Id from RecordType where SObjectType='Lead' and DeveloperName='Business_Banking'];
        RecordType consumerProspectRT = [select Id from RecordType where SObjectType='Lead' and DeveloperName='Prospecting_Consumer_SFDC2'];
        RecordType businessProspectRT = [select Id from RecordType where SObjectType='Lead' and DeveloperName='Prospecting_Business_SFDC2'];
            
        Lead consumerLead = new Lead(FirstName='Test_First', LastName='Test_Consumer', OwnerId=userRM.Id, RecordTypeId=consumerProspectRT.Id, 
                                Return_Owner_SFDC2__c=userBU.Id, Return_Record_Type_SFDC2__c=consumerRT.Id);
        Lead businessLead = new Lead(FirstName='Test_First', LastName='Test_Consumer', OwnerId=userBU.Id, RecordTypeId=businessProspectRT.Id, 
                                Return_Owner_SFDC2__c=userBU.Id, Return_Record_Type_SFDC2__c=businessRT.Id, Company='Test_Company');
        insert consumerLead;
        insert businessLead;

        // start test
        Test.startTest();
        
        RequestLeadResearchSFDC2Controller controller;

        // Return research as Research Manager
        System.runAs(userRM) {
            
            // --- test consumer return research page
            Test.setCurrentPage(Page.ReturnLeadResearchSFDC2);
            controller = new RequestLeadResearchSFDC2Controller(new ApexPages.StandardController(consumerLead));
            
            // Return consumer Lead research
            controller.returnLead();
            
            // Confirm updated record type
            System.assertEquals(consumerRT.Id, consumerLead.RecordTypeId, 'Unexpected record type for returning consumer Lead.');
            System.assertEquals(userBU.Id, consumerLead.OwnerId, 'Unexpected user for returning consumer Lead.');

            // --- test non-owner research request
            Test.setCurrentPage(Page.ReturnLeadResearchSFDC2);
            controller = new RequestLeadResearchSFDC2Controller(new ApexPages.StandardController(businessLead));
            
            // Try to request research
            controller.returnLead();
            
            // Confirm updated record type
            System.assertEquals(businessProspectRT.Id, businessLead.RecordTypeId, 'Unexpected record type for return of researched Lead by non-owner.');
            
        }
        
        Test.stopTest();
        
    }
}