/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class DB_Api {
    global DB_Api() {

    }
    global static void allowBlocking() {

    }
    global static void allowMatching() {

    }
    global static void autoConvert(Id leadId, Id accountId, Id contactId, Id scenarioId) {

    }
    global static void autoMerge(Id masterId, Id mergeId, Id scenarioId) {

    }
    global static void cancelAllBatchKeyBuilderProceses() {

    }
    global static void cancelBatchKeyBuilder(Long batchRebuildNumber) {

    }
    global static void disableDupeBlocker() {

    }
    global static void enableDupeBlocker() {

    }
    global static List<CRMfusionDBR101.DB_Api.Matches> findMatches(SObject searchObject) {
        return null;
    }
    global static void populateDefaultTestSettings() {

    }
    global static void preventBlocking() {

    }
    global static void preventMatching() {

    }
    global static void rebuildKeys(List<String> recordIds) {

    }
    global static Long startBatchKeyBuilder(List<String> scenarioIds) {
        return null;
    }
global class Matches {
    global String blockingMessage;
    global Set<Id> matchedIds;
    global String matchOnInsertAction;
    global String matchOnUpdateAction;
    global Id scenarioId;
}
}
