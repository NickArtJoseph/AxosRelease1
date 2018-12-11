/**
* @description <p>Handler class for ApplicantTrigger functionality</p>
* @author Mike Crosby, BofI Federal Bank 
* updated by: Jaime Terrats, Unosquare
*/
public class ApplicantTriggerHandler extends TriggerHandler {
    
    private Map<Id, Applicant_SFDC2__c> oldMap; 
    /** Map of Applicants with changes */
    private Map<Id, Applicant_SFDC2__c> newMap;
    /** List of Applicants with changes */
    private List<Applicant_SFDC2__c> newList;
    /** Get API Service Account Id*/
    public static final Id apiServ  = [select Id from User where Alias = 'aserv'].Id;


    /** Constructor */
    public ApplicantTriggerHandler() {
        this.oldMap = (Map<Id, Applicant_SFDC2__c>) Trigger.oldMap;
        this.newMap = (Map<Id, Applicant_SFDC2__c>) Trigger.newMap;
        this.newList = (List<Applicant_SFDC2__c>) Trigger.new;
    }
    
    /**
    * Process afterInsert logic
    */
    
    public override void afterInsert() {
        //handleIncompleteApplications();
        processApplication();
    }

    /**
    * When Applications are created that are Incomplete/Unsubmitted, creates Person Account record
    * for each applicant and adds to campaign
    */  
    
    
    /*
    private void handleIncompleteApplications() {
        Map<String,RecordType> mapAppcntsRTsByID = UtilsSFDC2.getRecordTypesMap('Applicant_SFDC2__c','Id');
        Set<String> statusTriggerValues = new Set<String>{'not submitted', 'incomplete'};
        List<String> appsToProcess = new List<String>();
        for(Applicant_SFDC2__c app : newMap.values()) { 
            if(String.isNotBlank(app.Application_Status__c)){
                if(statusTriggerValues.contains(app.Application_Status__c.toLowerCase())){
                    Boolean blnIsRTValid = false;
                    if(app.RecordTypeId != null){
                        if(mapAppcntsRTsByID.containsKey(app.RecordTypeId)){
                            if(!mapAppcntsRTsByID.get(app.RecordTypeId).DeveloperName.equalsIgnoreCase('Enrollment')){
                                blnIsRTValid = true;
                            }
                        }
                    }
                    if(blnIsRTValid){
                        appsToProcess.add(app.Id);
                    }
                }
            }
        }
        if(!appsToProcess.isEmpty()) {
            createBusinessAccountsForIncompleteApps(appsToProcess);
        }
    }


    @future
    public static void createBusinessAccountsForIncompleteApps(List<String> applicantIdList) {      
        Id cdRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer Person Account SFDC2').getRecordTypeId();
        List<Account> acctsToInsert = new List<Account>();
        for(Applicant_SFDC2__c applicant : [SELECT First_Name__c, Last_Name__c, Email__c, Cell_Phone__c FROM Applicant_SFDC2__c WHERE Id in :applicantIdList]) {
            Account a = new Account();
            a.RecordTypeId = cdRTId;
            a.FirstName = applicant.First_Name__c;
            a.LastName = applicant.Last_Name__c;
            a.PersonEmail = applicant.Email__c;
            a.PersonMobilePhone = applicant.Cell_Phone__c;
            a.Occupation_SFDC2__pc = 'Unknown';
            a.OwnerId = UserTriggerHandler.APIAccountId;
            a.Applicant_Id_SFDC2__pc = applicant.Id;
            acctsToInsert.add(a);
        }
        
        if(acctsToInsert.size() > 0) {
            List<Id> successIdList = new List<Id>();
            List<CampaignMember> cmToInsert = new List<CampaignMember>();
            for(Database.SaveResult sr : Database.insert(acctsToInsert, false)) {
                if(sr.isSuccess()) {
                    successIdList.add(sr.getId());
                } else {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
                    }
                }
            }
            
            String campaignName = 'Incomplete/Unsubmitted Application - Enrollment';
            Campaign c = [SELECT Id, Name FROM Campaign WHERE Name = :campaignName LIMIT 1];
            if(c == null) {
                System.debug('handleIncompleteApplications: unable to locate campaign - ' + campaignName);
                return;
            }
            List<Applicant_SFDC2__c> applicantsToUpdate = new List<Applicant_SFDC2__c>();
            for(Account newAcct : [SELECT Person_Contact_Id__c, Applicant_Id_SFDC2__pc FROM Account WHERE Id in :successIdList]) {
                CampaignMember cm = new CampaignMember();
                cm.Status = 'Attempting Contact';
                cm.CampaignId = c.Id;
                cm.ContactId = newAcct.Person_Contact_Id__c;
                cmToInsert.add(cm);
                Applicant_SFDC2__c applicant = new Applicant_SFDC2__c();
                applicant.Id = newAcct.Applicant_Id_SFDC2__pc;
                applicant.Contact__c = newAcct.Person_Contact_Id__c;
                applicantsToUpdate.add(applicant);
            }
            
            for(Database.SaveResult sr : Database.insert(cmToInsert, false)) {
                if(!sr.isSuccess()) {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Campaign Member fields that affected this error: ' + err.getFields());
                    }
                }
            }
            Database.update(applicantsToUpdate, false);
        }
    }*/


    /* 
        Here starts the code for TCI Applications
        The following methods will validate if the applicant already exists as contact | person account| lead.
        If non of the previous records exists, it will create a new Lead.
    */

    private void processApplication() {
        Set<String> tciStatusValues = new Set<String>{'approved', 'pending', 'counter offer'};
        List<String> appTciToProcess = new List<String>();
        Map<Id,Applicant_SFDC2__c> mapNewCustom = newMap.deepClone();
        for(List<Applicant_SFDC2__c> iterator0 : [SELECT Id FROM Applicant_SFDC2__c WHERE Id IN: newList AND RecordType.DeveloperName = 'TCI' AND Application_Id__r.Application_Status__c IN: tciStatusValues]) {
            for(Applicant_SFDC2__c iterator1:iterator0){
                appTciToProcess.add(iterator1.Id);
                if(mapNewCustom.containsKey(iterator1.Id)){
                    mapNewCustom.remove(iterator1.Id);
                }
            }    
        }
        if(!appTciToProcess.isEmpty()) {
            checkIfApplicationHasPersonAccount(appTciToProcess);
        }
        if(!mapNewCustom.isEmpty()){
            Enr_ProcessFromAppcntTrigger_bch bchInstance = new Enr_ProcessFromAppcntTrigger_bch(mapNewCustom.keySet());
            Database.executeBatch(bchInstance,10);
        }
    }

    @future 
    public static void checkIfApplicationHasPersonAccount(List<String> appToProcess) {
        Id tciRTId = Schema.SObjectType.Applicant_SFDC2__c.getRecordTypeInfosByName().get('TCI').getRecordTypeId();
        List<RecordType> rtIds = [select Id from RecordType where DeveloperName in ('Business_Consumer_Person_Account', 'Consumer_Person_Account_SFDC2' )];
        Boolean foundPA = false;
        Set<Id> appsWithoutPersonAccount = new Set<Id>();
        List<String> accIdsForOpps = new List<String>();
        List<String> appIdsForOpps = new List<String>();
        List<Applicant_SFDC2__c> getApplicantData = [select First_Name__c, Last_Name__c, Email__c, Cell_Phone__c, Home_Phone__c, Application_Status__c  
                                                        from Applicant_SFDC2__c where Id in: appToProcess and RecordTypeId =: tciRTId];
        Set<String> lstName = new Set<String>();
        for(Applicant_SFDC2__c app : getApplicantData) {
            String name = app.First_Name__c + ' ' + app.Last_Name__c;
            lstName.add(name);
        }

        List<Applicant_SFDC2__c> updApp =  new List<Applicant_SFDC2__c>();
        List<Account> checkExistingPersonAccount = [select Id, Name, PersonEmail, PersonHomePhone, PersonMobilePhone 
                                                from Account where RecordTypeId in: rtIds and Name in: lstName];
        for(Applicant_SFDC2__c applnt : getApplicantData) {
            foundPA = false;
            for(Account a : checkExistingPersonAccount) {
                if(a.Name == applnt.First_Name__c + ' ' + applnt.Last_Name__c && a.PersonEmail != null && a.PersonEmail == applnt.Email__c && foundPA == false) {
                    applnt.Linked_Account__c = a.Id;
                    foundPA = true;
                    accIdsForOpps.add(a.Id);
                    appIdsForOpps.add(applnt.Id);
                    updApp.add(applnt);
                    break;
                }
                else if((a.Name == applnt.First_Name__c + ' ' + applnt.Last_Name__c && a.PersonHomePhone != null && a.PersonHomePhone == applnt.Home_Phone__c &&  foundPA == false)
                        || (a.Name == applnt.First_Name__c + ' ' + applnt.Last_Name__c && a.PersonMobilePhone != null && a.PersonMobilePhone == applnt.Cell_Phone__c && foundPA == false)) {
                    applnt.Linked_Account__c = a.Id;
                    foundPA = true;
                    accIdsForOpps.add(a.Id);
                    appIdsForOpps.add(applnt.Id);
                    updApp.add(applnt);
                    break;
                }
            }
            if(foundPA == false) {
                appsWithoutPersonAccount.add(applnt.Id); 
            }
        }
        
        if(!updApp.isEmpty()) {
            try {
                update updApp;
            }
            catch(DmlException e) {
                System.debug('ERROR: ' + e);
            }
        }

        if(!accIdsForOpps.isEmpty() && !appIdsForOpps.isEmpty()) {
            createOpportunityOnAccount(accIdsForOpps, appIdsForOpps);
        }

        if(!appsWithoutPersonAccount.isEmpty()) {
            createNewLead(appsWithoutPersonAccount);
        }
    }


    public static void createOpportunityOnAccount(List<Id> accIdsForOpps, List<Id> appIdsForOpps) { 
        String drRTId = [select Id from RecordType where DeveloperName = 'Dealer_Services_Applicant_SFDC2' and SObjectType = 'Opportunity'].Id;
        List<Opportunity> oppsToInsert = new List<Opportunity>();
        List<Applicant_SFDC2__c> applicant = [select Id, First_Name__c, Last_Name__c, Application_Id__r.Name, 
                                                Application_Status__c from Applicant_SFDC2__c where Id in: appIdsForOpps];
        List<Account> accounts = [select Id, Name from Account where Id in: accIdsForOpps];
        List<Id> oppsToLink = new List<Id>();
        for(Applicant_SFDC2__c applnt : applicant) {
            for(Account acc : accounts ) {
                if(applnt.Application_Status__c == 'Pending' && acc.Name == applnt.First_Name__c + ' ' + applnt.Last_Name__c) {
                    Opportunity opp = new Opportunity();                
                    opp.Name = 'Opportunity ' + applnt.Application_Id__r.Name + ' ' + applnt.First_Name__c + ' ' + applnt.Last_Name__c;
                    opp.RecordTypeId =  drRTId;
                    opp.AccountId = acc.Id;
                    opp.CloseDate = Date.today().addDays(30);
                    opp.StageName = '5 - Pending Review';
                    opp.LeadSource = 'Application';
                    oppsToInsert.add(opp);
                }
                else if(applnt.Application_Status__c == 'Approved' && acc.Name == applnt.First_Name__c + ' ' + applnt.Last_Name__c 
                    || applnt.Application_Status__c == 'Counter Offer' && acc.Name == applnt.First_Name__c + ' ' + applnt.Last_Name__c) {
                    Opportunity opp = new Opportunity();                
                    opp.Name = 'Opportunity ' + applnt.Application_Id__r.Name + ' ' + applnt.First_Name__c + ' ' + applnt.Last_Name__c;
                    opp.RecordTypeId =  drRTId;
                    opp.AccountId = acc.Id;
                    opp.CloseDate = Date.today().addDays(30);
                    opp.StageName = '7 - Approved Unfunded';
                    opp.LeadSource = 'Application';
                    oppsToInsert.add(opp);
                }
            }
        }

        if(!oppsToInsert.isEmpty()) {
            for(Database.SaveResult sr : Database.insert(oppsToInsert, false)) {
                if(sr.isSuccess()) {
                    System.debug('Opportunity Created: ' + sr.Id);
                    oppsToLink.add(sr.Id);
                }
                else {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Opportunity fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }

        if(!oppsToLink.isEmpty()) {
            linkOpportunityToApplication(oppsToLink, appIdsForOpps);
        }
    }

    public static void linkOpportunityToApplication(List<Id> oppsToLink, List<Id> appsToLink) {
        List<String> appId = new List<String>();
        List<Applicant_SFDC2__c> getApplicationFromApplicant = [select Application_Id__c from Applicant_SFDC2__c where Id in: appsToLink];
        List<Application_SFDC2__c> getAppsToUpdate = new List<Application_SFDC2__c>();
        List<Opportunity> updOpp = new List<Opportunity>();
        List<Opportunity> oppsToLinkWithApplication = [select Id, Name, Related_Application__c from Opportunity where Id in: oppsToLink];
        for(Applicant_SFDC2__c applnt : getApplicationFromApplicant) {
            appId.add(applnt.Application_Id__c);
        }
        if(!appId.isEmpty()) {
            getAppsToUpdate = [select Id, Name from Application_SFDC2__c where Id in: appId];
            for(Opportunity opp : oppsToLinkWithApplication) {
                for(Application_SFDC2__c app : getAppsToUpdate) {
                    if(opp.Name.contains(app.Name)) {
                        opp.Related_Application__c = app.Id;
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
    }

    public static void createNewLead(Set<Id> appsWithoutPersonAccount) {
        Id dsaRTId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Dealer Services - Applicant SFDC2').getRecordTypeId();
        List<Applicant_SFDC2__c> getApplicantData = [select Application_Id__r.Name, First_Name__c, Last_Name__c, Home_Phone__c, Cell_Phone__c, Email__c,
                                                        Application_Status__c, Address_1__c, City__c, State__c, Zip__c 
                                                        from Applicant_SFDC2__c where Id in: appsWithoutPersonAccount];
        List<Lead> leadsToInsertP = new List<Lead>();
        List<Lead> leadsToInsertA = new List<Lead>();
        Set<String> leadIds = new Set<String>();
        for(Applicant_SFDC2__c applnt : getApplicantData) {
            if(applnt.Application_Status__c == 'Pending') {
                Lead lP = new Lead();
                lP.FirstName = applnt.First_Name__c;
                lP.LastName = applnt.Last_Name__c;
                lP.Email = applnt.Email__c;
                lP.Phone = applnt.Home_Phone__c;
                lP.MobilePhone = applnt.Cell_Phone__c;
                lP.Status = 'New';
                lP.LeadSource = 'Application';
                lP.Employer__c = 'Not Provided';
                lP.RecordTypeId = dsaRTId;
                lP.Opportunity_NameSFDC2__c = 'Opportunity ' + applnt.Application_Id__r.Name + ' ' + lP.FirstName + ' ' + lP.LastName;
                lP.OwnerId = ApplicantTriggerHandler.apiServ;
                lP.Applicant_Id__c = applnt.Id;
                lP.Street = applnt.Address_1__c;
                lP.City = applnt.City__c;
                lP.State = applnt.State__c;
                lP.PostalCode = applnt.Zip__c;
                lP.isFromApplication__c = true;
                leadsToInsertP.add(lP);
            }
            else if(applnt.Application_Status__c == 'Approved' || applnt.Application_Status__c == 'Counter Offer') {
                Lead lA = new Lead();
                lA.FirstName = applnt.First_Name__c;
                lA.LastName = applnt.Last_Name__c;
                lA.Email = applnt.Email__c;
                lA.Phone = applnt.Home_Phone__c;
                lA.MobilePhone = applnt.Cell_Phone__c;
                lA.Status = 'New';
                lA.LeadSource = 'Application';
                lA.Employer__c = 'Not Provided';
                lA.RecordTypeId = dsaRTId;
                lA.Opportunity_NameSFDC2__c = 'Opportunity ' + applnt.Application_Id__r.Name + ' ' + lA.FirstName + ' ' + lA.LastName;
                lA.OwnerId = ApplicantTriggerHandler.apiServ;
                lA.Applicant_Id__c = applnt.Id;
                lA.Street = applnt.Address_1__c;
                lA.City = applnt.City__c;
                lA.State = applnt.State__c;
                lA.PostalCode = applnt.Zip__c;
                lA.isFromApplication__c = true;
                leadsToInsertA.add(lA);
            }
        }

        if(!leadsToInsertP.isEmpty()) {
            for(Database.SaveResult sr : Database.insert(leadsToInsertP, false)) {
                if(sr.isSuccess()) {
                }
                else {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Lead fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }

        if(!leadsToInsertA.isEmpty()) {
            for(Database.SaveResult sr : Database.insert(leadsToInsertA, false)) {
                if(sr.isSuccess()) {
                    leadIds.add(sr.Id);
                    convertLead(leadIds);
                }
                else {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Lead fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
    }

    public static void convertLead(Set<String> leadsToConvert) {
        List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
        String autoConvertedStatus = 'Contacted/Converted';
        List<String> oppNames = new List<String>();
        List<Id> applntId = new List<Id>();
        Map<Id, Lead> leadConvertMap = new Map<Id, Lead>([
          SELECT Name, Applicant_Id__c, OwnerId, Owner.Name, Opportunity_NameSFDC2__c, RecordTypeId, IsConverted
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
            lc.setSendNotificationEmail(false);
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
            linkConvertedOpps(oppNames, applntId);
        }
    }

    public static void linkConvertedOpps(List<String> oppsToLink, List<Id> appsToLink) {
        List<String> appId = new List<String>();
        List<Applicant_SFDC2__c> getApplicationFromApplicant = [select Id, Application_Id__c from Applicant_SFDC2__c where Id in: appsToLink];
        List<Application_SFDC2__c> getAppsToUpdate = new List<Application_SFDC2__c>();
        List<Opportunity> updOpp = new List<Opportunity>();
        List<Opportunity> oppsToLinkWithApplication = [select Id, Name, StageName, LeadSource, AccountId, Related_Application__c 
                                                        from Opportunity where Name in: oppsToLink];
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
        List<Opportunity_Queue__c> lstOQToInsert = new List<Opportunity_Queue__c>();
        for(Opportunity o : opps) {
            Opportunity_Queue__c oq = new Opportunity_Queue__c();
            oq.Opportunity__c = o.Id;
            oq.OwnerId = queueId;
            lstOQToInsert.add(oq);
        }
        if(!lstOQToInsert.isEmpty()) {
            insert lstOQToInsert;
        }
    }

}