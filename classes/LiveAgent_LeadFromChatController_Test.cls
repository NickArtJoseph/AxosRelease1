@isTest
private class LiveAgent_LeadFromChatController_Test {

	@testSetup
	static void setup() {
		LiveChatVisitor chatVisitor = new LiveChatVisitor();
		insert chatVisitor;

		LiveChatTranscript chatTranscript = new LiveChatTranscript(
			ChatFirstName__c = 'John',
			ChatLastName__c = 'Doe',
			ChatEmail__c = 'john@doe.com',
			ChatPhone__c = '7896584568',
			Chat_Inquiry_Type__c = 'Checking, Savings, or other deposit accounts',
			LiveChatVisitorId = chatVisitor.Id
		);
		insert chatTranscript;
	}

	@isTest static void should_generate_lead_from_chat() {
		LiveChatTranscript chatTranscript = [SELECT Id FROM LiveChatTranscript LIMIT 1];
		ApexPages.StandardController stdController = new ApexPages.StandardController(chatTranscript);


		Test.startTest();
			LiveAgent_LeadFromChatController chatController = new LiveAgent_LeadFromChatController(stdController);
			chatController.saveLead();
		Test.stopTest();

		System.assert(chatController.newLead != null);
		System.assert(String.isNotBlank(chatController.newLead.Id));
	}

}