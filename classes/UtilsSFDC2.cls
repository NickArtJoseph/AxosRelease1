public class UtilsSFDC2 {

	/**
	 * @param sObjectName Name of the object to get Record type mappings
	 * @return            List of record type mappings
	 */
	public static SFDC2AccountResearchRecordType__mdt[] getResearchRecordTypeMappings(String objectName, String operation) {
		SFDC2AccountResearchRecordType__mdt[] lstRecordTypeMappings = [
			SELECT Id, CurrentRecordType__c, NewRecordType__c
			FROM SFDC2AccountResearchRecordType__mdt
			WHERE Operation__c = :operation
				AND RelatedObject__c = :objectName
				AND IsActive__c = true
		];

		return lstRecordTypeMappings;
	}

	/**
	 * @param sObjectName SObject to get record types
	 * @param keyField    Field to use as key for map
	 * @return            Map of Record types by Key field
	 */
	public static Map<String, RecordType> getRecordTypesMap(String sObjectName, String keyField) {
		Map<String, RecordType> mapRecordTypes = new Map<String, RecordType>();

		RecordType[] lstRecordTypes = [
			SELECT Id, DeveloperName, Name, IsPersonType
			FROM RecordType
			WHERE SObjectType = :sObjectName
		];

		for(RecordType recType: lstRecordTypes) {
			String key = String.valueOf(recType.get(keyField));
			mapRecordTypes.put(key, recType);
		}

		return mapRecordTypes;
	}

	/**
	 * Get SLA Reminder Times for Email notifications
	 */
	public static SFDC2SLAReminderSettings__mdt getSLAReminderTimes() {
		SFDC2SLAReminderSettings__mdt defaultReminderTimes = [
			SELECT Id, BF_Approval_Reminder_Time__c, LOQ_Approval_Reminder_Time__c, Opp_Proj_Close_Date_Reminder_Time__c
			FROM SFDC2SLAReminderSettings__mdt
			WHERE IsActive__c = true
			LIMIT 1
		];

		return defaultReminderTimes;
	}
}