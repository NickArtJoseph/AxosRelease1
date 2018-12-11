@isTest
private class UtilsSFDC2_Test {

	@isTest static void testGetAccountRecordTypeMappings() {
		SFDC2AccountResearchRecordType__mdt[] mappingList = UtilsSFDC2.getResearchRecordTypeMappings('Account', 'Request/Cancel');
		System.assert(!mappingList.isEmpty());
	}

	@isTest static void testGetRecordTypesMap() {
		Map<String, RecordType> mapRecordTypes = UtilsSFDC2.getRecordTypesMap('Account', 'DeveloperName');
		System.assert(!mapRecordTypes.isEmpty());
	}

	@isTest static void testGetSLAReminderTimes() {
		SFDC2SLAReminderSettings__mdt defaultReminderTimes = UtilsSFDC2.getSLAReminderTimes();
		System.assert(defaultReminderTimes != null);
	}

}