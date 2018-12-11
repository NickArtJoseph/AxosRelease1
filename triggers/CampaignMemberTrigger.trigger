trigger CampaignMemberTrigger on CampaignMember (after insert, after update) {
	new CampaignMemberTriggerHandler().run();
}