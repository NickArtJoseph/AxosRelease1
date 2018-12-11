/**
 * Interface for custom controllers for SFDC2 objects
 * (Email_SFDC2__c, Phone_SFDC2__c and Address_SFDC2__c)
 * Used to override Save button functionality
 */
public interface IntCustomSFDC2Controller {
    PageReference onEdit();
    PageReference onSave();    
}