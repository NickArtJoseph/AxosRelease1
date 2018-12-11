/**
 * Custom controller for overriding save button on Address Detail page
 * to redirect to parent Account or Lead when record is deleted
 */
public class AddressSFDC2Controller extends CustomSFDC2ControllerBase implements IntCustomSFDC2Controller {
    
    public Address_SFDC2__c objInstance {get; set;}
    
    public AddressSFDC2Controller(ApexPages.StandardController controller) {
    	stdController = controller;
	    objInstance = (Address_SFDC2__c) controller.getRecord();
    }
    
    /**
     * Return reference to custom edit detail page
     * @return Page reference for edit detail page
     */
    public PageReference onEdit() {
    	Address_SFDC2__c addr = [select id, Account__r.id, Lead__r.id from Address_SFDC2__c where id = :objInstance.id];
		String parentId = null;
		if (addr.Account__c != null) {
			parentId = addr.Account__c;
		} else if (addr.Lead__c != null) {
			parentId = addr.Lead__c;
		}
    	PageReference page = getEditPage(objInstance, 'AddressSFDC2Save', 'AddressSFDC2View', parentId);
    	return page;
    }
    
    /**
     * Return page reference after 'Save'
     * If the record has been automatically deleted, send the 
     * user to the parent Account or Lead page
     * @return Page reference to Account, Lead or Email_SFDC2__c detail page
     */
    public PageReference onSave() {
    	PageReference page = getViewPage(objInstance, 'AddressSFDC2View');
    	return page;
    }
    
    /**
     * Insert new records and redirect to parent Lead or Account page
     */
    public PageReference saveNew() {
		try {
			insert objInstance;
			PageReference parentPage = new PageReference(System.currentPageReference().getParameters().get('retURL'));
			parentPage.setRedirect(true);
			return parentPage;
		} catch (Exception ex) {
			ApexPages.addMessages(ex);
			system.debug(ex);
			return null;
		}
	} 
}