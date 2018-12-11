/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SessionSyncSchedulable implements Database.AllowsCallouts, Database.Batchable<SObject>, Database.Stateful, System.Schedulable {
    global G4S__Sync__c sync;
    global SessionSyncSchedulable() {

    }
    global SessionSyncSchedulable(G4S__Sync__c sync) {

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
    @Future(callout=true)
    global static void sync(Datetime since) {

    }
}
