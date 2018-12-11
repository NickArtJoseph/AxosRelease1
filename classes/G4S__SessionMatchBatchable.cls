/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SessionMatchBatchable implements Database.Batchable<SObject>, Database.Stateful, System.Schedulable {
    global G4S__Company_Settings__c companySettings;
    global Map<Id,CampaignMember> guestIdToCampaignMemberMap;
    global Map<Id,Id> guestIdToContactIdMap;
    global Map<Id,Lead> guestIdToLeadMap;
    global Map<G4S__Guest__c,CampaignMember> guestToCampaignMemberMap;
    global Map<G4S__Guest__c,Contact> guestToContactMap;
    global Map<G4S__Guest__c,Lead> guestToLeadMap;
    global Map<Id,Event> sessionIdToEventMap;
    global Map<Id,Lead> sessionIdToLeadMap;
    global Map<G4S__Session__c,Event> sessionToEventMap;
    global Map<G4S__Session__c,Lead> sessionToLeadMap;
    global G4S__Sync__c sync;
    global Datetime syncToTime;
    global SessionMatchBatchable(G4S__Sync__c sync) {

    }
    global SessionMatchBatchable(G4S__Sync__c sync, Datetime syncToTime) {

    }
    global void execute(System.SchedulableContext context) {

    }
    global void execute(Database.BatchableContext context, List<SObject> sObjects) {

    }
    global void finish(Database.BatchableContext context) {

    }
    global Database.QueryLocator start(Database.BatchableContext context) {
        return null;
    }
}
