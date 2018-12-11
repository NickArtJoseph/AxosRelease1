@isTest
private class LiveAgent_PreChatDefaultController_Test {

	@isTest static void should_instantiate_controller() {
		LiveAgent_PreChatDefaultController controller = new LiveAgent_PreChatDefaultController();
		System.assert(controller.chatInquiryTypes != null && !controller.chatInquiryTypes.isEmpty());
		System.assert(controller.mapChatButtons != null && !controller.mapChatButtons.isEmpty());
	}
}