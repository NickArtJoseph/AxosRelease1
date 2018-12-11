trigger CertificationTrigger on WLD_Certification__c (before insert, after insert, after update) {
    new CertificationTriggerHandler().run();
}