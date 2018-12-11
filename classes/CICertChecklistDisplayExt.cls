public with sharing class CICertChecklistDisplayExt {
	/** Current Certification record */
	private CI_Certification__c cert;

	public Boolean isEditor {
		get
		{
			return Schema.Sobjecttype.C_I_Checklist_Item__c.isUpdateable();
		}
	}

	/** Constructor */
	public CICertChecklistDisplayExt(ApexPages.StandardController ctr) {
		cert = (CI_Certification__c)ctr.getRecord();
		cert = getCertificationDetails(cert.Id);
		resetEditVariables();
	}
	
	/**
	* Retrieves list of checklist items associated with the certification
	* @return list of CI Checklist Item records
	*/
	public List<C_I_Checklist_Item__c> getChecklistItems() {
		return cert.C_I_Checklist_Items__r;
	}
	
	/**
	* Retrieves image for whether or not the cert is ready for approval submission
	* @return html image string
	*/
	public String getReadyForApprovalImage() {
		return cert.Ready_for_Approval__c;
	}
	
	/**
	* Retrieves certification and checklist item data
	*/
	private CI_Certification__c getCertificationDetails(Id certId) {
		return [
				SELECT Name, Ready_for_Approval__c,
					(SELECT Name, Status__c, Grace_Period__c
						FROM C_I_Checklist_Items__r ORDER BY Name) 
				FROM CI_Certification__c 
				WHERE Id = :certId
				];
	}
	
	/** Checklist item id selected for editing */
	public String selectedItemId {get; set;}
	/** Existing status for checklist item selected */
	public String selectedItemStatus {get; set;}
	
	/** Checklist Item placeholder for modification */
	public C_I_Checklist_Item__c modifyItem {get; set;}
	
	/** Indicates whether a checklist item has been selected for editing */
	public Boolean isEdit {get; set;}
	
	/** Sets up interface for editing item status */
	public PageReference editItem() {
		if(selectedItemId == null) {
			return null;
		}
		modifyItem = new C_I_Checklist_Item__c();
		modifyItem.Id = selectedItemId;
		modifyItem.Status__c = selectedItemStatus;
		isEdit = true;
		return null;
	}
	
	/** Saves changes to item */
	public PageReference saveItem() {
		update modifyItem;
		resetEditVariables();
		cert = getCertificationDetails(cert.Id);
		return null;
	}
	
	/** Cancels editing of item */
	public PageReference cancelItem() {
		resetEditVariables();
		return null;
	}
	
	/** Clears out item edit variables */
	private void resetEditVariables() {
		isEdit = false;
		modifyItem = null;
		selectedItemId = null;
		selectedItemStatus = null;
	}
}