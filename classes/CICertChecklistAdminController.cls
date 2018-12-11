public with sharing class CICertChecklistAdminController {
	/** Opportunity for checklist items */
	private Opportunity opp;
	
	/** Certification type */
	private String certType;
	
	/** Selected Checklist Item */
	public String selectedItem {get; set;}
	
	/** List of existing checklist items that are required for the opportunity */
	public List<C_I_Checklist_Item_Admin__c> RequiredChecklistItemList {get; set;}
	
	/** Checklist item to be added as a required item */
	public C_I_Checklist_Item_Admin__c modifyChecklistItem {get; set;}
	
	/** Constructor */
	public CICertChecklistAdminController() {
		opp = [
				SELECT Name, StageName
				FROM Opportunity
				WHERE Id = :Apexpages.currentPage().getParameters().get('id')
			   ];
		certType = Apexpages.currentPage().getParameters().get('ctype');
		RequiredChecklistItemList = getRequiredChecklistItems();
	}
	
	public PageReference returnToOpp() {
		PageReference ref = new PageReference('/' + opp.Id);
		ref.setRedirect(true);
		return ref;
	}
	
	/**
	* Returns Certification Type Name
	* @return name of Certification type
	*/
	public String getCertificationTypeName() {
		return certType;
	}
	
	/**
	* Returns the Opportunity record
	* @return Opportunity
	*/
	public Opportunity getOpportunity() {
		return opp;
	}
	
	/**
	* Retrieves list of checklist item names for the certification type
	* @return list of checklist items available for certification type
	*/
	public List<String> getChecklistItemNames() {
		Map<String,List<String>> depFieldOptionMap = UtilityMethods.GetDependentOptions('C_I_Checklist_Item_Admin__c', 'Certification_Type__c', 'Checklist_Item_Name__c');
		return depFieldOptionMap.get(certType);
	}
	
	/**
	* Returns possible checklist item names that will be required for certification
	* @return select option list of checklist items that may be required for certification
	*/
	public List<SelectOption> getChecklistItemOptions() {
		Set<String> checkListItemNames = new Set<String>(getChecklistItemNames());
		Set<String> existingChecklistItemNames = new Set<String>();
		for(C_I_Checklist_Item_Admin__c existCI : RequiredChecklistItemList) {
			existingChecklistItemNames.add(existCI.Checklist_Item_Name__c);
		}
		List<SelectOption> selectList = new List<SelectOption>();
		for(String name : checkListItemNames) {
			//only allow for the addition of checklist items that aren't already required
			if(!existingChecklistItemNames.contains(name)) {
				selectList.add(new SelectOption(name, name));
			}
		}
		return selectList;
	}
	
	public Boolean isAdd {get; set;}
	
	/**
	* Adds selected checklist item as required
	*/
	public PageReference addItem() {
		if(selectedItem == null || 
			selectedItem == '') {
			return null;
		}
		isAdd = true;
		modifyChecklistItem = new C_I_Checklist_Item_Admin__c();
		modifyChecklistItem.Opportunity__c = opp.Id;
		modifyChecklistItem.Certification_Type__c = certType;
		modifyChecklistItem.Checklist_Item_Name__c = selectedItem;
		modifyChecklistItem.Name = selectedItem;
		return null;
	}
	
	/**
	* Retrieves list of required checklist items
	*/
	private List<C_I_Checklist_Item_Admin__c> getRequiredChecklistItems() {
		return [
				SELECT Checklist_Item_Name__c, Grace_Period__c
				FROM C_I_Checklist_Item_Admin__c
				WHERE Opportunity__c = :opp.Id AND
				Certification_Type__c = :certType
				ORDER BY Checklist_Item_Name__c];
	}
	
	public String checklistId {get; set;}
	
	public PageReference editChecklistItem() {
		for(C_I_Checklist_Item_Admin__c citem : RequiredChecklistItemList) {
			if(checklistId == citem.Id) {
				modifyChecklistItem = citem;
				break;
			}
		}
		return null;
	}
	
	public PageReference deleteChecklistItem() {
		modifyChecklistItem = new C_I_Checklist_Item_Admin__c(Id=checklistId);
		delete modifyChecklistItem;
		RequiredChecklistItemList = getRequiredChecklistItems();
		modifyChecklistItem = null;
		checklistId = null;
		return null;
	}
	
	public PageReference saveChecklistItem() {
		if(modifyChecklistItem.Grace_Period__c == null) {
			opp.addError('A Grace Period value is expected.');
			return null;
		}
		if(modifyChecklistItem.Id == null) {
			//inserting new checklist item
			insert modifyChecklistItem;
		} else {
			//updating existing item
			update modifyChecklistItem;
		}
		modifyChecklistItem = null;
		isAdd = false;
		RequiredChecklistItemList = getRequiredChecklistItems();
		checklistId = null;
		return null;
	}
	
	public PageReference cancelChecklistItem() {
		modifyChecklistItem = null;
		isAdd = false;
		checklistId = null;
		return null;
	}
}