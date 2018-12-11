@isTest
public class Call_Count_IS_TriggerHandler_Test {
    static testmethod void callTriggerMethod() {
        List<User> users = TestDataFactory.createTestUsers(new Set<String>{'System Administrator'});
        
        System.runAs(users[0]){
            Account acc = TestDataFactory.createAndInsertTestBusinessAccount();
            Contact con = TestDataFactory.createTestContact(acc);
            Insert con;
            Campaign camp = new Campaign(Name='Test Campaign 01', IsActive=true);
            camp.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Call Campaign').getRecordTypeId();
            camp.CampaignMemberRecordTypeId = Schema.SObjectType.CampaignMember.getRecordTypeInfosByName().get('Call Campaign').getRecordTypeId();
            camp.StartDate = Date.today();
            insert camp;
            CampaignMember memb = new CampaignMember();
            memb.ContactId = con.Id; 
            system.debug('ContactId'+con.Id);
            memb.CampaignId = camp.Id;
            memb.Status = 'Sent';
            insert memb;
            
            Task tsk = new Task();
            tsk.whoId = con.Id; 
            tsk.WhatId = camp.Id;
            tsk.Subject = 'call';
            tsk.Status = 'Completed';
            tsk.Priority = 'Normal';
            tsk.isdc_dialer_list_name__c = camp.Name;
            tsk.CallDisposition = 'Busy';
            insert tsk; 
        }
        
    }
}