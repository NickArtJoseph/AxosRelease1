public class LiveAgent_PreChatDefaultController {

	public ChatInquiryType__mdt[] chatInquiryTypes { get; private set; }
	public Map<String, LiveChatButton> mapChatButtons { get; private set; }

	public LiveAgent_PreChatDefaultController() {
		chatInquiryTypes = [
			SELECT 
				Id, DeveloperName, AuthenticatedUser__c, BrandName__c, 
				BuisinessUnit__c, ButtonToRoute__c, InquiryTypeLabel__c, DisplayOrder__c
			FROM ChatInquiryType__mdt
			WHERE IsActive__c = true
			ORDER BY DisplayOrder__c ASC
		];

		// Get Chat Button Developer Names
		Set<String> setButtonDevNames = new Set<String>();
		for (ChatInquiryType__mdt inquiryType : chatInquiryTypes) {
			setButtonDevNames.add(inquiryType.ButtonToRoute__c);
		}

		// Get Chat Buttons IDs and map by Developer Name
		LiveChatButton[] chatButtons = [
			SELECT Id, DeveloperName, Queue.Name 
			FROM LiveChatButton 
			WHERE DeveloperName IN :setButtonDevNames 
				AND IsActive = true
		];

		mapChatButtons = new Map<String, LiveChatButton>();
		for (LiveChatButton button : chatButtons) {
			mapChatButtons.put(button.DeveloperName, button);
		}
	}
}