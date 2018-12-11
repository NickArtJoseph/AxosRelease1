/***

    Author: René Ayala Medina
    Description: Queueable class to asynchronously and orderly execute the "enrollment process" functionality
    
    Version Developer             Date          Description
    0.1     René Ayala Medina RAM 09/02/2018    Class created
    0.2     René Ayala Medina RAM 09/02/2018    Building the class
    1.0     René Ayala Medina RAM 09/06/2018    Documentation and testing

***/

global class Enr_ProcessFromAppcntTrigger_que implements Queueable {

    private List<Applicant_SFDC2__c> lstAppcnts;
    
    global  Enr_ProcessFromAppcntTrigger_que(List<Applicant_SFDC2__c> lstAppcntsC){
        lstAppcnts = lstAppcntsC;
    }
    
    global void execute(QueueableContext context) {
        TCIENR_GeneralUtils_cls.processEnrollmentAppsOnApplicantInsert(lstAppcnts);
    }
}