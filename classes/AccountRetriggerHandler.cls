/**
* @description <p>Handler class for AccountTrigger functionality designed specifically for
* functionality that needs to triggered based on workflow retriggers</p>
* @author Mike Crosby, BofI Federal 
*/
public class AccountRetriggerHandler extends TriggerHandler{
  	/** Map of Accounts before changes */
  	private Map<Id, Account> oldMap;
  	/** Map of Accounts with changes */
  	private Map<Id, Account> newMap;
    
	/** Constructor */
  	public AccountRetriggerHandler() {
    	this.oldMap = (Map<Id, Account>) Trigger.oldMap;
    	this.newMap = (Map<Id, Account>) Trigger.newMap;
  	}
    
	/**
  	* Process beforeUpdate logic
  	*/
  	public override void beforeUpdate() {
    	capturePriorOwner();
    }
    
  	/**
  	* When the Account owner changes, capture the prior owner value
  	* @param oldAcctMap map of initial state Accounts
  	* @param newAcctMap map of changed Accounts 
  	*/
  	private void capturePriorOwner() {
    	for(Account newAcct : newMap.values()) {
      		Account oldAcct = oldMap.get(newAcct.Id);
      		if(oldAcct.OwnerId != newAcct.OwnerId) {
	        	newAcct.Prior_Owner__c = oldAcct.OwnerId;
    	    	newAcct.Current_Rep_Dials__c = 0;
      		}
    	}
  	}
}