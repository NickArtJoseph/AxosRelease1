/**
 * Abstract class for custom SFDC2 object controllers
 * (Email_SFDC2__c, Phone_SFDC2__c and Address_SFDC2__c)
 * Used to override save button functionality
 */
public abstract class CustomSFDC2ControllerBase {
    
    protected ApexPages.StandardController stdController;
    protected String urlParameters;
    
    /**
     * Return a reference to the Edit page
     * @param objInstance The SObject to be edited
     * @param saveView Name of the VF Save Page
     * @param returnView Name of the VF page to go to if user selects 'Cancel'
     * @param parentId Id for parent record to navigate to if record is automatically deleted
     * @return Page reference to the Edit page
     */
    public PageReference getEditPage(SObject objInstance, String saveView, String returnView, String parentId) {
    	
    	Schema.DescribeSObjectResult describeResult = objInstance.getSObjectType().getDescribe();
    	PageReference page = new PageReference('/' + describeResult.getKeyPrefix() + '/e?');
    	
    	page.getParameters().put('id', objInstance.id);
    	if (parentId != null) {
	    	page.getParameters().put('saveURL','/' + parentId);
    	} else {
	    	page.getParameters().put('saveURL','/apex/' + saveView + '?id=' + objInstance.id + '&nooverride=1');
    	}
    	page.getParameters().put('retURL','/apex/' + returnView + '?id=' + objInstance.id + '&nooverride=1');
    	page.getParameters().put('nooverride','1');
    	page.setRedirect(false);
    	
    	return page;
    }
    
    /**
     * Return a reference to the View Page
     * @param objInstance The SObject to be viewed
     * @param view Name of the VF View Page
     * @return Page reference to the View Page
     */
    public PageReference getViewPage(SObject objInstance, String view) {
    	
    	PageReference page = new PageReference('/apex/' + view);
    	
    	page.getParameters().put('id', objInstance.id);
    	page.getParameters().put('nooverride', '1');
    	page.getParameters().put('override','0');
    	page.setRedirect(false);
    	
    	return page;
    }

}