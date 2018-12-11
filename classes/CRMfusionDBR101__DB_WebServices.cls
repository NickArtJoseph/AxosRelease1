/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class DB_WebServices {
    global DB_WebServices() {

    }
    webService static void CancelKeyBuilding() {

    }
    webService static Integer DeleteAllOldScenarioLinksBatch() {
        return null;
    }
    webService static String DeleteAllScenarioKeysBatchApex(Integer batchSize) {
        return null;
    }
    webService static Integer DeleteAllScenarioLinksBatch() {
        return null;
    }
    webService static Integer DeleteOldScenarioLinksBatch(List<String> scenarios) {
        return null;
    }
    webService static String DeleteScenarioKeysBatchApex(List<String> scenarios, Integer batchSize) {
        return null;
    }
    webService static Integer DeleteScenarioLinksBatch(List<String> scenarios) {
        return null;
    }
    webService static void MarkScenariosRebuildNeeded(List<String> scenarioIds) {

    }
    webService static void SetScenarioKeySizes(List<String> scenarioIds, List<Integer> keySizes) {

    }
    webService static void bypassBlock() {

    }
    webService static String getDupeBlockerStatus(String requestingFeature) {
        return null;
    }
    @ReadOnly
    webService static Integer getKeysCount(String scenarioIds) {
        return null;
    }
    webService static List<Id> getPotentialDupeObjectIdsByWarningId(String dupeWarningId) {
        return null;
    }
    @ReadOnly
    webService static Integer getRecordCount(String objectName) {
        return null;
    }
    webService static List<String> getSettings() {
        return null;
    }
    webService static String getVersion() {
        return null;
    }
    webService static void incrementScenarioBlockCount(String scenarioId, Integer blockCount) {

    }
    webService static void incrementScenarioMergeCount(String scenarioId, Integer mergeCount) {

    }
    webService static Boolean isValidLicense() {
        return null;
    }
    webService static void leadConvert_CreateTask(String contactId, String opportunityId, String subject, String description) {

    }
    webService static void markScenariosRebuilt(List<String> scenarioIds) {

    }
    webService static List<String> rebuildKeysBatchApex(List<String> scenarioIds, String objectType, Integer batchSize) {
        return null;
    }
    webService static Integer rebuildKeys_Account(Id scenarioId, List<String> idArray) {
        return null;
    }
    webService static Integer rebuildKeys_Contact(Id scenarioId, List<String> idArray) {
        return null;
    }
    webService static Integer rebuildKeys_Lead(Id scenarioId, List<String> idArray) {
        return null;
    }
    webService static Integer rebuildKeys(Id scenarioId, List<String> idArray, String objectType) {
        return null;
    }
    webService static void saveSettings(List<String> settings) {

    }
    webService static String updateLicense(String requestingFeature, Integer userCount) {
        return null;
    }
    webService static String validateLicense(String requestingFeature, Integer userCount) {
        return null;
    }
    webService static String validateLicenseWithoutCount(String requestingFeature) {
        return null;
    }
}
