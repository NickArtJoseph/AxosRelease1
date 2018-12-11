/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SessionSyncBatchable implements Database.AllowsCallouts, Database.Batchable<Integer>, Database.Stateful {
    global Set<String> addedSyncComments;
    global G4S__User_Settings__c adminUserSettings;
    global Map<String,G4S__User_Settings__c> eligibleUserSettingsMap;
    global Integer nextId;
    global Integer pageSize;
    global Map<String,String> partnerMap;
    global Datetime since;
    global G4S__Sync__c sync;
    global Boolean syncFailed;
    global Datetime syncToTime;
    global SessionSyncBatchable(G4S__Sync__c sync) {

    }
    global SessionSyncBatchable(G4S__Sync__c sync, Datetime syncToTime) {

    }
    global void execute(Database.BatchableContext context, List<Integer> pages) {

    }
    global void finish(Database.BatchableContext context) {

    }
    global System.Iterable start(Database.BatchableContext context) {
        return null;
    }
global class PageIterable implements System.Iterable<Integer>, System.Iterator<Integer> {
    global Boolean hasNext() {
        return null;
    }
    global System.Iterator iterator() {
        return null;
    }
    global Integer next() {
        return null;
    }
}
}
