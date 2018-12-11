trigger AttachmentTrigger on Attachment (after insert) {
	new AttachmentTriggerHandler().run();
}