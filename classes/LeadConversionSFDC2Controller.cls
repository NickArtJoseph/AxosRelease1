/*
Apex Controller for Lightning Lead Conversion functionality
*/
public class LeadConversionSFDC2Controller {
    public static String ownershipErrorMessage = 'Leads cannot be converted when they are owned by a queue. Please either take ownership of this lead before converting, or assign ownership to another user.';
    
    // Execute Lead Conversion
    @AuraEnabled
    public static Id convertLead(String leadId) {
        Lead leadToConvert = [
            SELECT Id, Name, Status, OwnerId, ConvertLeadSFDC2__c, Opportunity_NameSFDC2__c, IsConverted
            FROM Lead
            WHERE Id = :leadId
		];
        
        // Check if lead is already converted
        if (leadToConvert.IsConverted == true) {
            return leadToConvert.Id;
        }
        
        // Validate Lead Ownership
        if (!String.valueOf(leadToConvert.OwnerId).startsWith('005')) {
            throw new AuraHandledException(ownershipErrorMessage);
        }
        
        // Update fields and execute conversion
        leadToConvert.ConvertLeadSFDC2__c = true;
    	leadToConvert.Status = 'Contacted/Converted';
        //leadToConvert.Sub_Branch_SFDC2__c = 'RELF';
        
        Database.SaveResult convertResult = Database.update(leadToConvert, false);
        
        if (!convertResult.isSuccess()) {
            String errorMessage = 'An error occurred while attempting to update the Lead status to Contacted/Converted: ';
            for (Database.Error err : convertResult.getErrors()) {
                errorMessage += '- ' + err.getMessage() + ' ';
            }
            throw new AuraHandledException(errorMessage);
        }
        
        return leadToConvert.Id;
    }
    
    // Get information about records related to a converted Lead
    @AuraEnabled
    public static Lead getConvertedLead(String leadId) {
        Lead convertedLead = [
            SELECT
            Name,
            Company,
            Status,
            ConvertedAccountId,
            ConvertedAccount.Name,
            ConvertedAccount.IsPersonAccount,
            ConvertedContactId,
            ConvertedContact.Name,
            ConvertedOpportunityId,
            ConvertedOpportunity.Name,
            IsConverted 
            FROM Lead 
            WHERE Id = :leadId
        ];
        
        return convertedLead;
    }
}