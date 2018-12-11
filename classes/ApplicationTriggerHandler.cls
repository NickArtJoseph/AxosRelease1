public class ApplicationTriggerHandler extends TriggerHandler {
    /** Map of Applications before changes */
    private Map<Id, Application_SFDC2__c> oldMap;
    /** Map of Applications with changes */
    private Map<Id, Application_SFDC2__c> newMap;

    public static final Id apiServ  = [select Id from User where Alias = 'aserv'].Id;
    public static final Id consumerDepositsLeadQueueId = [SELECT Id, DeveloperName,Type FROM Group WHERE Type = 'Queue' AND DeveloperName =: Label.TCIENR_ConsumerDepositosLeadQueueDevName_cl LIMIT 1].Id; 

    public ApplicationTriggerHandler() {
        this.oldMap = (Map<Id, Application_SFDC2__c>) Trigger.oldMap;
        this.newMap = (Map<Id, Application_SFDC2__c>) Trigger.newMap;
    }

    public override void afterUpdate() {
        handleTCIApplicationStatus();
        Map<Id,Application_SFDC2__c> mapCloneOldApps = oldMap.deepClone();
        Map<Id,Application_SFDC2__c> mapCloneNewApps = newMap.deepClone();
        Map<String,RecordType> mapAppsRTsByID = UtilsSFDC2.getRecordTypesMap('Application_SFDC2__c','Id'); 
        Set<Id> setAppsNotToProcess = new Set<Id>();
        for(Id iterator:newMap.keySet()){
            if(oldMap.get(iterator).Application_State__c == newMap.get(iterator).Application_State__c){
                if(oldMap.get(iterator).Decision_Status__c == newMap.get(iterator).Decision_Status__c){
                    setAppsNotToProcess.add(iterator);
                }    
            }
            if(newMap.get(iterator).RecordTypeId != null){
                if(mapAppsRTsByID.containsKey(newMap.get(iterator).RecordTypeId)){
                    if(mapAppsRTsByID.get(newMap.get(iterator).RecordTypeId).DeveloperName != 'Enrollment'){
                        if(!setAppsNotToProcess.contains(iterator)){
                            setAppsNotToProcess.add(iterator);
                        }
                    }
                }
            }else{
                setAppsNotToProcess.add(iterator);
            }
        }
        for(Id iterator:setAppsNotToProcess){
            mapCloneOldApps.remove(iterator);
            mapCloneNewApps.remove(iterator);
        }
        if(!oldMap.isEmpty()){
            if(!newMap.isEmpty()){
               TCIENR_GeneralUtils_cls.processEnrollmentApplication(mapCloneOldApps, mapCloneNewApps); 
            }
        }
    }

    /*
        When the Application Status gets updated from Pending to Counter Offer or Approved, it converts the Lead
    */

    private void handleTCIApplicationStatus() {
        Map<String,RecordType> mapAppsRTsByID = UtilsSFDC2.getRecordTypesMap('Application_SFDC2__c','Id');
        List<String> appToProcess = new List<String>();
        Set<String> tciStatusValues = new Set<String>{'approved','counter offer'};
        for(Id app : newMap.keySet()) {
            Application_SFDC2__c oldApp = oldMap.get(app);
            Application_SFDC2__c newApp = newMap.get(app);
            if(oldApp.Application_Status__c == 'Pending' && newApp.Application_Status__c != 'Pending') {
                if(tciStatusValues.contains(newApp.Application_Status__c.toLowerCase())){
                    Boolean blnIsRTValid = false;
                    if(newApp.RecordTypeId != null){
                        if(mapAppsRTsByID.containsKey(newApp.RecordTypeId)){
                            if(mapAppsRTsByID.get(newApp.RecordTypeId).DeveloperName.equalsIgnoreCase('TCI')){
                                blnIsRTValid = true;
                            }
                        }
                    }
                    if(blnIsRTValid){
                        appToProcess.add(app);
                    }
                }
            }
        }
        if(!appToProcess.isEmpty()) {
            updateApplicationStatus(appToProcess);
        }
    }


    /* Here Starts TCI Update status logic*/
    @future
    public static void updateApplicationStatus(List<String> appToProcess) {
        Id dsaRTId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Dealer Services - Applicant SFDC2').getRecordTypeId();
        List<Application_SFDC2__c> getApplicationToUpdate = [select Id, Application_Status__c from Application_SFDC2__c where Id in: appToProcess];
        List<Applicant_SFDC2__c> getApplicantToUpdate = [select Application_Id__c, First_Name__c, Last_Name__c, Email__c, Home_Phone__c, 
                                                                Cell_Phone__c, Address_1__c, State__c, City__c, Zip__c, Application_Id__r.Name
                                                                from Applicant_SFDC2__c where Application_Id__c in: appToProcess];
        List<Lead> newLeadFromUpdate = new List<Lead>();
        List<Id> leadIdToConvert = new List<Id>();
        for(Application_SFDC2__c app : getApplicationToUpdate) {
            for(Applicant_SFDC2__c applnt : getApplicantToUpdate) {
                if(app.Id != null && applnt.Application_Id__c != null && app.Id == applnt.Application_Id__c) {
                    Lead l = new Lead();
                    l.FirstName = applnt.First_Name__c;
                    l.LastName = applnt.Last_Name__c;
                    l.Email = applnt.Email__c;
                    l.Phone = applnt.Home_Phone__c;
                    l.MobilePhone = applnt.Cell_Phone__c;
                    l.Status = 'New';
                    l.LeadSource = 'Application';
                    l.Employer__c = 'Not Provided';
                    l.RecordTypeId = dsaRTId;
                    l.Opportunity_NameSFDC2__c = 'Opportunity ' + applnt.Application_Id__r.Name + ' ' + l.FirstName + ' ' + l.LastName;
                    l.OwnerId = ApplicationTriggerHandler.apiServ;
                    l.Applicant_Id__c = applnt.Id;
                    l.Street = applnt.Address_1__c;
                    l.City = applnt.City__c;
                    l.State = applnt.State__c;
                    l.PostalCode = applnt.Zip__c;
                    l.isFromApplication__c = true;
                    newLeadFromUpdate.add(l);
                }
            }
        }
        if(!newLeadFromUpdate.isEmpty()) {
            for(Database.SaveResult sr : Database.insert(newLeadFromUpdate)) {
                if(sr.isSuccess()) {
                    leadIdToConvert.add(sr.Id);
                    convertLead(leadIdToConvert);
                }
                else {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('No Application updated: ' + err.getFields());
                    }
                }
            }
        }
    }

    public static void convertLead(List<Id> leadsToConvert) {
        List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
        String autoConvertedStatus = 'Contacted/Converted';
        List<String> oppNames = new List<String>();
        List<Id> applntId = new List<Id>();
        Map<Id, Lead> leadConvertMap = new Map<Id, Lead>([
          SELECT Name, OwnerId, Owner.Name, Applicant_Id__c, Opportunity_NameSFDC2__c, RecordTypeId, IsConverted
          FROM Lead 
          WHERE Id IN: leadsToConvert 
        ]);

        for(Lead l : leadConvertMap.values()) {
            Database.LeadConvert lc = new Database.LeadConvert();       
            if(l.IsConverted == true) {
                continue;
            }
            String oppName = l.Opportunity_NameSFDC2__c;
            if(oppName == null || oppName == '') {
                oppName = l.Name;
            }
            oppNames.add(oppName);
            applntId.add(l.Applicant_Id__c);
            lc.setLeadId(l.Id);
            lc.setConvertedStatus(autoConvertedStatus);
            lc.setOpportunityName(oppName);
            lc.setOwnerId(l.OwnerId);
            lc.setSendNotificationEmail(true);
            leadConverts.add(lc);
        }
        if (!leadConverts.isEmpty()) {
            List<Database.LeadConvertResult> lcrList = Database.convertLead(leadConverts);
            for(Database.LeadConvertResult lcr : lcrList) {
                if(lcr.isSuccess()) {
                    System.debug('Processing leads to convert: ' + lcr);
                }
                else {
                    System.debug('Error while converting leads: ' + lcr);
                    continue;
                }
            }
        }

        if(!applntId.isEmpty() && !oppNames.isEmpty()) {
            linkOpportunityToApplication(oppNames, applntId);
        }
    }

    public static void linkOpportunityToApplication(List<String> oppsToLink, List<Id> appsToLink) {
        List<String> appId = new List<String>();
        List<Applicant_SFDC2__c> getApplicationFromApplicant = [select Application_Id__c from Applicant_SFDC2__c where Id in: appsToLink];
        List<Application_SFDC2__c> getAppsToUpdate = new List<Application_SFDC2__c>();
        List<Opportunity> updOpp = new List<Opportunity>();
        List<Opportunity> oppsToLinkWithApplication = [select Id, Name, StageName, LeadSource, AccountId, Related_Application__c from Opportunity where Name in: oppsToLink];
        Set<Id> accIds = new Set<Id>();
        Set<Id> appIds = new Set<Id>();
        for(Applicant_SFDC2__c applnt : getApplicationFromApplicant) {
            appId.add(applnt.Application_Id__c);
        }
        if(!appId.isEmpty()) {
            getAppsToUpdate = [select Id, Name from Application_SFDC2__c where Id in: appId];
            for(Opportunity opp : oppsToLinkWithApplication) {
                for(Applicant_SFDC2__c applnt : getApplicationFromApplicant) {
                    accIds.add(opp.AccountId);
                    appIds.add(applnt.Id);
                }
            }
            for(Opportunity opp : oppsToLinkWithApplication) {
                for(Application_SFDC2__c app : getAppsToUpdate) {
                    if(opp.Name.contains(app.Name)) {
                        opp.Related_Application__c = app.Id;
                        opp.StageName = '7 - Approved Unfunded';
                        opp.LeadSource = 'Application';
                        updOpp.add(opp);
                    }
                }
            }
        }

        if(!updOpp.isEmpty()) {
            for(Database.SaveResult sr : Database.update(updOpp)) {
                if(sr.isSuccess()) {
                    System.debug('Opportunity linked: ' + sr.Id);
                } 
                else {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Opportunity not linked by this error: ' + err.getFields());
                    }
                }
            }
        }

        if(!updOpp.isEmpty()) {
            sendOppsToQueue(updOpp);    
        }
        if(!accIds.isEmpty() && !appIds.isEmpty()) {
            linkConvertedAccounts(accIds, appIds);
        }
    }
    public static void linkConvertedAccounts(Set<Id> accIds, Set<Id> appsToLink) {
        List<Account> getConvertedAccount = [select Id, Name from Account where Id in: accIds];
        List<Applicant_SFDC2__c> getApplicantData = [select Linked_Account__c, First_Name__c, Last_Name__c from Applicant_SFDC2__c where Id in: appsToLink];
        List<Applicant_SFDC2__c> updApp = new List<Applicant_SFDC2__c>();
        for(Account acc : getConvertedAccount) {
            for(Applicant_SFDC2__c applnt : getApplicantData) {
                if(acc.Name == applnt.First_Name__c + ' ' + applnt.Last_Name__c) {
                    applnt.Linked_Account__c = acc.Id;
                    updApp.add(applnt);
                }
            }
        }
        if(!updApp.isEmpty()) {
            for(Database.SaveResult sr : Database.update(updApp)) {
                if(sr.isSuccess()) {
                    System.debug('Applicant linked: ' + sr.Id);
                } 
                else {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Applicant not linked by this error: ' + err.getFields());
                    }
                }
            }
        }
    }
    public static void sendOppsToQueue(List<Opportunity> opps) {
        Id queueId = [select Id from Group where type = 'Queue' and DeveloperName = 'TCI_Opportunity_Queue'].Id;
        List<Opportunity_Queue__c> oqInsert = new List<Opportunity_Queue__c>();
        for(Opportunity o : opps) {
            Opportunity_Queue__c oq = new Opportunity_Queue__c();
            oq.Opportunity__c = o.Id;
            oq.OwnerId = queueId;
            oqInsert.add(oq);
        }
        if(!oqInsert.isEmpty()) {
            insert oqInsert;
        }
    }

}