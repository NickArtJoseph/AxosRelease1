public with sharing class LiveAgent_LeadFromChatController {

	public Lead newLead                      { get; set; }
	public LiveChatTranscript chatTranscript { get; set; }
	public String leadRecordTypeId           { get; set; }
	public Boolean leadWasCreated            { get; set; }
	public Boolean itHasErrors               { get; set; }

	/**
	 * Constructor
	 * @param  stdController Live Chat Transcript Standard Controller
	 */
	public LiveAgent_LeadFromChatController(ApexPages.StandardController stdController) {

		chatTranscript = [
			SELECT ChatFirstName__c, ChatLastName__c, ChatEmail__c, ChatPhone__c, Chat_Inquiry_Type__c, LiveChatButton.Queue.DeveloperName
			FROM LiveChatTranscript
			WHERE Id = :stdController.getId()
		];

		setNewLeadRecordType();

		newLead = new Lead(
			FirstName             = chatTranscript.ChatFirstName__c,
			LastName              = chatTranscript.ChatLastName__c,
			Email                 = chatTranscript.ChatEmail__c,
			Phone                 = chatTranscript.ChatPhone__c,
			PrimaryInquiryType__c = chatTranscript.Chat_Inquiry_Type__c,
			LeadSource            = 'Web Chat',
			Status                = 'New',
			Company               = 'Not provided',
			RecordTypeId          = leadRecordTypeId
		);

		// Set additional fields
		String advisorRecordType = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Advisor Firm SFDC2').getRecordTypeId();
		if(advisorRecordType == leadRecordTypeId) {
			newLead.Financial_Advisor_Type__c = 'Other';
			newLead.Financial_Advisor_Type_Other__c = 'Other';
		}

		leadWasCreated = false;
		itHasErrors = false;
	}

	/**
	 * Create Lead and associate it to Chat Transcript
	 */
	public PageReference saveLead() {
		try {
			insert newLead;
			chatTranscript.LeadId = newLead.Id;
			chatTranscript.ChatEmail__c = newLead.Email;
			update chatTranscript;
			leadWasCreated = true;
		} catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ex.getMessage()));
			leadWasCreated = false;
			itHasErrors = true;
		}

		return null;
	}

	/**
	 * Set record type for new lead based on chat routing
	 */
	private void setNewLeadRecordType() {
		String queueName = Test.isRunningTest() ? 'Consumer_Deposits_Chat_Queue' : chatTranscript.LiveChatButton.Queue.DeveloperName;
        Map<String, Schema.RecordTypeInfo> mapLeadRecordTypes = Schema.SObjectType.Lead.getRecordTypeInfosByName();
        String liveChatQueue = [SELECT RecordType_Name__c FROM Manager_SFDC2__mdt WHERE Live_Agent_Queue__c LIKE :('%'+queueName+'%')].RecordType_Name__c;
        this.leadRecordTypeId = mapLeadRecordTypes.get(liveChatQueue).getRecordTypeId();
	}

}