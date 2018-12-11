/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class BatchableProcessStep extends relax.SimpleProcessStep implements Database.Batchable<SObject> {
    global BatchableProcessStep() {

    }
    global abstract void execute(Database.BatchableContext param0, List<SObject> param1);
    global abstract void finish(Database.BatchableContext param0);
    global virtual Integer getScope() {
        return null;
    }
    global abstract Database.QueryLocator start(Database.BatchableContext param0);
}
