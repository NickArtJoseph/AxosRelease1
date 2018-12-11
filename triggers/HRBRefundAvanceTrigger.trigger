trigger HRBRefundAvanceTrigger on HRB_Refund_Advance__c (before update, after insert, after update) {
	new HRBRefundAdvanceTriggerHandler().run();
}