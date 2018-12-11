/**
* Controller class for LeadConverProgress Visualforce page
*/
public with sharing class LeadConvertProgressController {
	/** Lead that is being converted */
    public Lead convertedLead {get; set;}
    /** Indicator of valid conversion status */
    public Boolean validStatus {get; set;}
    
    /** Constructor */
    public LeadConvertProgressController() {
    	String leadId = Id.valueOf(ApexPages.currentPage().getParameters().get('id'));
    	convertedLead = new Lead(Id=leadId, IsConverted=false);
    	validStatus = true;
    	pollResults();
    }
    
    /**
    * Queries Lead to (1) validate that it is the correct Status and (2) to see if conversion has 
    * occurred; Visualforce page uses actionPoller to call this method
    */
    public PageReference pollResults() {
        convertedLead = [SELECT
        					Name,
        					Company,
        					Status,
        					ConvertedAccountId,
        					ConvertedAccount.Name,
        					ConvertedContactId,
        					ConvertedContact.Name,
        					ConvertedOpportunityId,
        					ConvertedOpportunity.Name,
        					IsConverted 
        				  FROM Lead 
        				  WHERE Id = :convertedLead.Id];
        String convertStatus = 'Contacted/Converted';
        if(convertedLead.Status != convertStatus) {
        	//if user managed to find this page with a Lead that has an invalid Status,
        	//inform user through error message
    		validStatus = false;
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The Lead must have a Status value of \'' + convertStatus + '\' in order to be converted.'));
    	} else {
    		validStatus = true;
    	}
        return null;
    }
}