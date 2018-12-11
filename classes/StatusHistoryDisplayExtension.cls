public with sharing class StatusHistoryDisplayExtension {
	/** Current record */
	private Sobject obj;
	
	/** Constructor */
	public StatusHistoryDisplayExtension(ApexPages.StandardController ctr) {
		obj = ctr.getRecord();
	}
	
	/**
	* Retrieves the Status History records for the current record
	*/
	public List<WLD_Status_History__c> getStatusHistory() {
		//dynamically determine record type
		String objectAPIName = (obj.id).getSObjectType().getDescribe().getName();
		return Database.query('SELECT Name, Status_Date_Time__c, Time_in_Status_days__c ' +
								'FROM WLD_Status_History__c ' +
								'WHERE ' + 
								((objectAPIName == 'WLD_Certification__c') ? 'Certification__c' : 'Credit_Review__c') +
								' = \'' + obj.Id + '\' ' +
								'ORDER BY Status_Date_Time__c DESC, ID DESC');
								
	}
}