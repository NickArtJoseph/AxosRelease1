/***

    Author: René Ayala Medina
    Description: Batch class to process the applicants (those with "enrollment" record type)
    
    Version Developer             Date          Description
    0.1     René Ayala Medina RAM 08/26/2018    Class created
    0.2     René Ayala Medina RAM 08/26/2018    Building the class
    1.0     René Ayala Medina RAM 09/06/2018    Documentation and testing

***/

global class Enr_ProcessFromAppcntTrigger_bch implements Database.Batchable<sObject> {
    
    String query;

    /*
        Constructor. Receives the applicants to process and filter them. With the filtered ones, proceeds to create / update the corresponding related records.
    */
    
    global Enr_ProcessFromAppcntTrigger_bch(Set<Id> setApplicantsToProcessIds) {
        List<Applicant_SFDC2__c> lstValidAppcnts = new List<Applicant_SFDC2__c>();
        List<String> lstEnrollmentStatusStatements = new List<String>();
        for(String iterator:TCIENR_GeneralUtils_cls.setEnrollmentStatesValues){
            lstEnrollmentStatusStatements.add('Application_State__c like \'%'+iterator+'%\'');
        }
        List<String> lstAndConditions = new List<String>{
            'Id IN (\''+String.join(new List<Id>(setApplicantsToProcessIds),'\',\'')+'\')',
            'RecordType.DeveloperName = \'Enrollment\'',
            '('+String.join(lstEnrollmentStatusStatements,' OR ')+')'
        };
        String strGenIDNotNullFilter = 'AppNameExtID__c != null';
        String strRTFilter = 'RecordType.DeveloperName  = \'Consumer_Deposits_SFDC2\'';
        String strConvStatFilter = 'isConverted = false';
        String strOppNameNotNull = 'Opportunity_NameSFDC2__c != null';
        List<String> lstFieldsAPINames = new List<String>(SObjectType.Applicant_SFDC2__c.Fields.getMap().keySet());
        lstFieldsAPINames.add('(SELECT Id, AppNameExtID__c, CIF__c, isConverted, Opportunity_NameSFDC2__c, OwnerId, Status, Name FROM ApplicantLeads__r WHERE '+String.join(new List<String>{strGenIDNotNullFilter,strRTFilter,strConvStatFilter,strOppNameNotNull},' AND ')+')');
        query = 'SELECT '+String.join(lstFieldsAPINames,', ')+' FROM Applicant_SFDC2__c WHERE '+String.join(lstAndConditions,' AND ');
    }

    /*
        Performs the querying
    */
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    /*
        Executes the processing for every resulting record from querying
    */

    global void execute(Database.BatchableContext BC, List<Applicant_SFDC2__c> scope) {
        TriggerLoopExecutionControl_cls.setAlreadyBeenExecuted('ApplicantTrigger');
        TriggerLoopExecutionControl_cls.setAlreadyBeenExecuted('ApplicationTrigger');
        System.enqueueJob(new Enr_ProcessFromAppcntTrigger_que(scope));
    }

    /*
        Does nothing
    */
    
    global void finish(Database.BatchableContext BC) {}
    
}