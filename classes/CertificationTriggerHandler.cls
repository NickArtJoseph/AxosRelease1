/**
* @description <p>Handler class for CertificationTrigger functionality</p>
* @author Mike Crosby, BofI Federal 
*/
public class CertificationTriggerHandler extends TriggerHandler {

  /** Map of Certifications before changes */
  private Map<Id, WLD_Certification__c> oldCertMap;
  /** Map of Certifications with changes */
  private Map<Id, WLD_Certification__c> newCertMap;
  /** List of records before insert */
  private List<WLD_Certification__c> newList;
  /** Set of recipient emails for escalation notification */
  private Set<String> escalationRecipientSet;
  /** Current user email address */
  private static String currentUserEmail;
  /** Instance URL */
  private static final String instanceURL = URL.getSalesforceBaseUrl().toExternalForm();

  /** Constructor */
  public CertificationTriggerHandler() {
    this.oldCertMap = (Map<Id, WLD_Certification__c>) Trigger.oldMap;
    this.newCertMap = (Map<Id, WLD_Certification__c>) Trigger.newMap;
    this.newList = (List<WLD_Certification__c>) Trigger.new;
  	User currentUser = [SELECT Email FROM User WHERE Id = :Userinfo.getUserId()];
  	currentUserEmail = currentUser.Email;
  }

  /**
  * Process beforeInsert logic
  */
  public override void beforeInsert() {
  	populateContactEmailFields(newList);
  }

  /**
  * Process afterUpdate logic
  */
  public override void afterUpdate() {
  	processAnalystCallUpdate();
    handleStatusHistoryCreation(this.oldCertMap, this.newCertMap);
  }
  
  /**
  * Process afterInsert logic
  */
  public override void afterInsert() {
  	processAnalystCallUpdate();
  	handleStatusHistoryCreation(null, this.newCertMap);
  }

  /**
  * Cycles through picklist fields (checklist items) and if the field has been set to 'Analyst Call' it sends an email
  * to appropriate recipients
  */
  private void processAnalystCallUpdate() {
  	if(escalationRecipientSet == null) {
  		Group grp = [SELECT Id FROM Group WHERE DeveloperName = 'WLD_Status_Escalation_Recipients'];
  		if(grp == null) {
  			System.debug('**** ERROR: Unable to locate public group: WLD_Status_Escalation_Recipients');
  			return;
  		}
	  	//retrieve recipients from the WLD_Status_Escalation_Recipients
	  	escalationRecipientSet = new Set<String>();
	  	Set<Id> recipientIdSet = UtilityMethods.GetUserIdsFromGroup(grp.Id);
	  	for(User u : [SELECT Email FROM User WHERE Id in :recipientIdSet]) {
	  		escalationRecipientSet.add(u.Email);
	  	}
  	}
  	Set<String> checklistFieldSet = new Set<String>(); 
  	
  	//cycle through all fields on the WLD Certification object to determine which ones to process
  	Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.WLD_Certification__c.fields.getMap();
    for (String fieldName: schemaFieldMap.keySet()) {
        Schema.DescribeFieldResult f = schemaFieldMap.get(fieldName).getDescribe();
        if(f.getType() == Schema.DisplayType.Picklist) {
        	for(Schema.PicklistEntry entry : f.getPicklistValues()) {
        		if(entry.getLabel() == 'Analyst Call') {
        			checklistFieldSet.add(fieldName);
        			break;
        		}
        	}
        }
    }
    
    //determine if the checklist fields were updated to Analyst Call
    List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
    for(WLD_Certification__c cert : newList) {
    	WLD_Certification__c oldCert = new WLD_Certification__c();
    	if(oldCertMap != null) {
    		oldCert = oldCertMap.get(cert.Id);
    	}
    	for(String fieldName : checklistFieldSet) {
    		System.debug('****' + (String)cert.get(fieldName));
    		if(
    			(String)cert.get(fieldName) == 'Analyst Call' &&
    			(String)cert.get(fieldName) != (String)oldCert.get(fieldName)) {
    			Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
			  	List<String> emailList = new List<String>();
			  	emailList.addAll(escalationRecipientSet);
			  	msg.setToAddresses(emailList);
			  	msg.setCcAddresses(new List<String>{currentUserEmail});
			  	msg.setSubject('WLD Status Escalation');
			  	Schema.DescribeFieldResult f = schemaFieldMap.get(fieldName).getDescribe();
			  	String fieldLabel = f.getLabel();
			  	msg.setHtmlBody('<p>Please be notified that the ' + fieldLabel + ' was updated to Analyst Call.</p>' +
			  		'<p><a href="' + instanceURL + '/' + cert.Id + '">Link to the Salesforce page</a></p>');
			  	msg.setPlainTextBody('Please be notified that the ' + fieldLabel + ' was updated to Analyst Call.\n\n' +
			  		'Link to the Salesforce page: ' + instanceURL + '/' + cert.Id);
			  	messages.add(msg);
    		}
    	}
    }
    
    if(messages.size() > 0) {
    	Messaging.SendEmailResult[] results = new List<Messaging.SendEmailResult>();
    	if(!Test.IsRunningTest()) {
    		results = Messaging.sendEmail(messages);
    	}
    	for(Messaging.SendEmailResult result : results) {
			if(!result.success) {
    			System.debug('**** WLD Escalation Notification email failed to send: ' + result.errors[0].message);
			}
    	}
    }
  }

  /**
  * Given a list of certifications, sets the Contact Email/Contact Email 2 fields with values from parent Account
  * @param newRecs records to be inserted
  */
  private void populateContactEmailFields(List<WLD_Certification__c> newRecs) {
  	Set<Id> acctIds = new Set<Id>();
  	for(WLD_Certification__c cert : newRecs) {
  		acctIds.add(cert.Account__c);
  	}
  	
  	Map<Id,Account> accountMap = new Map<Id,Account>([SELECT Id, Contact_Email__c, Contact_Email_2__c FROM Account WHERE Id in :acctIds]);
  	
  	for(WLD_Certification__c cert : newRecs) {
  		cert.Contact_Email__c = accountMap.get(cert.Account__c).Contact_Email__c;
  		cert.Contact_Email_2__c = accountMap.get(cert.Account__c).Contact_Email_2__c;
  	}
  }

  /**
  * If the Status field of the Certification changes, create a Status History record
  * @param oldCertMap map of the initial state Certification
  * @param newCertMap map of changed Certifications
  */
  private void handleStatusHistoryCreation(Map<Id,WLD_Certification__c> oldMap, Map<Id,WLD_Certification__c> newMap) {
  	//determine which reviews have a status update
  	Set<Id> idSet = new Set<Id>();
    for(WLD_Certification__c newCert : newMap.values()) {
    	if(oldMap == null) {
    		//after insert
    		idSet.add(newCert.Id);
    	} else {
    		//after update
	        WLD_Certification__c oldCert = oldMap.get(newCert.Id);
	        if(newCert.Status__c != oldCert.Status__c) {
	          idSet.add(newCert.Id);
	        }
    	}
    }
    
    if(idSet.size() > 0) {
    	List<WLD_Status_History__c> historyToAdd = new List<WLD_Status_History__c>();
    	for(Id i : idSet) {
    	  //create status history record
          WLD_Status_History__c sh = new WLD_Status_History__c();
          sh.Certification__c = i;
          sh.Name = newMap.get(i).Status__c;
          if(sh.Name == null || sh.Name == '') {
          	sh.Name = '--None--';
          }
          sh.Status_Date_Time__c = Datetime.now();
          historyToAdd.add(sh);
    	}
    	insert historyToAdd;
    	
    	//perform any necessary linking between histories
    	for(WLD_Certification__c cert : [
    									SELECT Id,
    										(
    										  SELECT Id, Name, Status_Date_Time__c
    										  FROM Status_History__r
    										  ORDER BY Status_Date_Time__c DESC, Id DESC
    										  LIMIT 2
    										 )
    									FROM WLD_Certification__c
    									WHERE Id in :idSet]) {
    		
    		if(cert.Status_History__r.size() > 1) {
    			WLD_Status_History__c histToUpdate = cert.Status_History__r[1];
    			histToUpdate.Next_Status__c = cert.Status_History__r[0].Id;
    			toUpdate.add(histToUpdate);
    		}								
    	}
    }
  }
}