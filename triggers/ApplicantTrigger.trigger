trigger ApplicantTrigger on Applicant_SFDC2__c (after insert, after update) {
    if(!TriggerLoopExecutionControl_cls.hasAlreadyBeenExecuted('ApplicantTrigger')) {
		new ApplicantTriggerHandler().run();
	}
}