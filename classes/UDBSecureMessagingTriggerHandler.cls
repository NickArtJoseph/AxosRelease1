public class UDBSecureMessagingTriggerHandler extends TriggerHandler {
	private List<UDB_Secure_Messaging__c> newList;

	public UDBSecureMessagingTriggerHandler() {
		this.newList =(List<UDB_Secure_Messaging__c>) Trigger.new;
	}

	public override void afterInsert() {
		handleIsVisibleSelfService();
	}

	private void handleIsVisibleSelfService() {
    List<UDB_Secure_Messaging__c> messageList =  new List<UDB_Secure_Messaging__c>();
    String caseId;
    Case c;
    for(UDB_Secure_Messaging__c setIsVisble : [select Customer_Read__c, Related_To__c from UDB_Secure_Messaging__c where Id =:newList and Customer_Read__c = null]) {
     	caseId = setIsVisble.Related_To__c;
     	System.debug('Case Id is: ' + caseId);
    	 	messageList.add(setIsVisble);
    }
    if(messageList.size() > 0 ) {
     		c = [select Id, IsVisibleSelfService__c from case where Id =: caseId];
     		c.IsVisibleSelfService__c = true;
     		update c;
    }
  }
}