/***

    Author: René Ayala Medina
    Description: Auxiliar class to perform Enrollment / TCI operations
    
    Version Developer             Date          Description
    0.1     René Ayala Medina RAM 08/15/2018    Class created
    0.2     René Ayala Medina RAM 08/15/2018    Building the class
    1.0     René Ayala Medina RAM 09/06/2018    Documentation and testing

***/

public  class TCIENR_GeneralUtils_cls {

    public static final String strIncAppCampID = [SELECT Id FROM Campaign WHERE Name =: 'Incomplete Application' LIMIT 1].Id;
    public static final String strAbandonedCamp = [SELECT Id FROM Campaign WHERE Name =: 'Abandoned Enrollment Opps' LIMIT 1].Id;
    
    /*
        Contains the "fit for processing" states
    */

    public static final Set<String> setEnrollmentStatesValues = new Set<String>{
        'Product Selection (Incomplete)'.toLowerCase(),
        'Disclosures (Incomplete)'.toLowerCase(),
        'Personal Information (Incomplete)'.toLowerCase(),
        'Review and Submit (Incomplete)'.toLowerCase(),
        'Waiting for Customer to Remove Freeze'.toLowerCase(),
        'Account Number Error'.toLowerCase(),
        'Boarding Error'.toLowerCase(),
        'NetBank Accepted / Disclosures'.toLowerCase(),
        'NetBank Accepted / Product Selection'.toLowerCase(),
        'Referred From Another Brand'.toLowerCase(),
        'Task List - Post Boarding'.toLowerCase(),
        'Documents Requested'.toLowerCase(),
        'Mitek Upload Page'.toLowerCase(),
        'Pending Application Review'.toLowerCase(),
        'Pending Completion of KBA'.toLowerCase(),
        'KBA Still to Be Answered'.toLowerCase(),
        'Pending Document Review'.toLowerCase(),
        'Response Needed From Customer'.toLowerCase(),
        'Waiting for Mitek Upload'.toLowerCase(),
        'Complete'.toLowerCase(),
        'Referred to NetBank'.toLowerCase()
    };

    /*
        Method to handle after insert event over valid applicants
    */

    public static void processEnrollmentAppsOnApplicantInsert(List<Applicant_SFDC2__c> lstApplicants) {
        ApplicantsInfoWrapper applicantsInfoWprInstance = new ApplicantsInfoWrapper();
        Map<String,Lead> mapLeadByGenID = new Map<String,Lead>();
        for(Applicant_SFDC2__c iterator:lstApplicants){
            if(String.isNotBlank(iterator.Application_State__c)){
                if(verifyIfAppliesProcessing(iterator)){
                    applicantsInfoWprInstance.lstApplicantWithValidStates.add(iterator);
                    applicantsInfoWprInstance.setNames.add(iterator.Name__c);
                    if(String.isNotBlank(iterator.CIF__c)){ 
                        applicantsInfoWprInstance.setCIFs.add(iterator.CIF__c);
                    }
                    if(iterator.ApplicantLeads__r != null){
                        if(!iterator.ApplicantLeads__r.isEmpty()){
                            mapLeadByGenID.put(iterator.GenericExternalID__c,iterator.ApplicantLeads__r[0]);
                        }
                    }
                }                     
            }
        }
        LookUpResultWrapper lookUpResultInstance = lookUpRelItems(applicantsInfoWprInstance);
        if(!mapLeadByGenID.isEmpty()){
            lookUpResultInstance.mapExistingLeadsByGenID = mapLeadByGenID;
        }
        processApplicants(lookUpResultInstance);
    }

    /*
        Method to handle after update event on valid applications
    */

    public static void processEnrollmentApplication(Map<Id,Application_SFDC2__c> mapOldApps, Map<Id,Application_SFDC2__c> mapNewApps){
        Map<String,RecordType> mapAppsRTsByDevName = UtilsSFDC2.getRecordTypesMap('Application_SFDC2__c','DeveloperName'); 
        Set<Id> setApplicationsToProcess = new Set<Id>();
        for(Id iterator:mapNewApps.keySet()){
            if(String.isNotBlank(mapNewApps.get(iterator).Application_State__c)){
                if(String.isNotBlank(mapOldApps.get(iterator).Application_State__c)){
                    if(mapNewApps.get(iterator).Application_State__c.equalsIgnoreCase('Product Selection (Incomplete)')){
                        if(!setEnrollmentStatesValues.contains(mapOldApps.get(iterator).Application_State__c.toLowerCase())){
                            setApplicationsToProcess.add(iterator);
                        }else if(!mapNewApps.get(iterator).Decision_Status__c.equalsIgnoreCase(mapOldApps.get(iterator).Decision_Status__c)){
                            setApplicationsToProcess.add(iterator);
                        }
                    }else if(setEnrollmentStatesValues.contains(mapNewApps.get(iterator).Application_State__c.toLowerCase())){
                        setApplicationsToProcess.add(iterator);
                    }
                }else if(setEnrollmentStatesValues.contains(mapNewApps.get(iterator).Application_State__c.toLowerCase())){
                    setApplicationsToProcess.add(iterator);
                }   
            }
        }
        if(!setApplicationsToProcess.isEmpty()){
            Set<Id> setApplicantsToProcess = new Set<Id>();
            for(List<Applicant_SFDC2__c> iterator0:[SELECT Id FROM Applicant_SFDC2__c WHERE Application_Id__c IN: setApplicationsToProcess]){
                for(Applicant_SFDC2__c iterator1:iterator0){
                    setApplicantsToProcess.add(iterator1.Id);
                }
            }
            if(!setApplicantsToProcess.isEmpty()){
                Enr_ProcessFromAppcntTrigger_bch bchInstance = new Enr_ProcessFromAppcntTrigger_bch(setApplicantsToProcess);
                Database.executeBatch(bchInstance,10);
            }
        }
    }

    /*
        Method to get all those accounts that match with the refered applicants
    */

    public static LookUpResultWrapper lookUpRelItems(ApplicantsInfoWrapper applicantsInfoWprInstance){
        LookUpResultWrapper searchResultsInstance = new LookUpResultWrapper();
        Map<String,RecordType> mapAccsRTsByDevName = UtilsSFDC2.getRecordTypesMap('Account','DeveloperName');
        List<String> lstOrConditions = new List<String>();
        if(!applicantsInfoWprInstance.setNames.isEmpty()){
            lstOrConditions.add('Name IN (\''+String.join(new List<String>(applicantsInfoWprInstance.setNames),'\',\'')+'\')');
        }
        if(!applicantsInfoWprInstance.setCIFs.isEmpty()){
            lstOrConditions.add('CIF_SFDC2__c IN (\''+String.join(new List<String>(applicantsInfoWprInstance.setCIFs),'\',\'')+'\')');
        }
        if(!lstOrConditions.isEmpty()){
            List<String> lstAndConditions = new List<String>();
            lstAndConditions.add('('+String.join(lstOrConditions,' OR ')+')');
            lstAndConditions.add('RecordTypeId = \''+mapAccsRTsByDevName.get('Consumer_Person_Account_SFDC2').Id+'\'');
            String strQueryOverPersonAccs = 'SELECT Id, PersonEmail, CIF_SFDC2__c, PersonHomePhone, PersonMobilePhone, Name FROM Account WHERE ('+String.join(lstAndConditions,' AND ')+')';
            List<Account> lstExistingPersonAccount = new List<Account>();
            try{lstExistingPersonAccount = Database.query(strQueryOverPersonAccs);}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
            Map<String,List<Account>> mapAccsByName = new Map<String,List<Account>>();
            Map<String,Account> mapAccsByCIF = new Map<String,Account>();
            if(!lstExistingPersonAccount.isEmpty()){
                for(Account iterator:lstExistingPersonAccount){
                    if(!mapAccsByName.containsKey(iterator.Name)){
                        mapAccsByName.put(iterator.Name, new List<Account>());
                    }
                    mapAccsByName.get(iterator.Name).add(iterator);
                    if(String.isNotBlank(iterator.CIF_SFDC2__c)){
                        mapAccsByCIF.put(iterator.CIF_SFDC2__c,iterator);
                    }
                }
            }
            for(Applicant_SFDC2__c iterator:applicantsInfoWprInstance.lstApplicantWithValidStates){
                searchResultsInstance.mapApplicantsByGenID.put(iterator.GenericExternalID__c,iterator);
                if(iterator.Linked_Account__c != null){
                    searchResultsInstance.mapsAccsByGenID.put(iterator.GenericExternalID__c,iterator.Linked_Account__c);
                }else{
                    Boolean blnAppHasAPAcc = false;
                    if(String.isNotBlank(iterator.GenericExternalID__c)){
                        if(String.isNotBlank(iterator.CIF__c)){
                            if(mapAccsByCIF.containsKey(iterator.CIF__c)){
                                if(!searchResultsInstance.mapsAccsByGenID.containsKey(iterator.GenericExternalID__c)){
                                    searchResultsInstance.mapsAccsByGenID.put(iterator.GenericExternalID__c,mapAccsByCIF.get(iterator.CIF__c).Id);
                                }
                                blnAppHasAPAcc = true;
                            }
                        }
                        if(!blnAppHasAPAcc){
                            if(mapAccsByName.containsKey(iterator.Name__c)){
                                if(mapAccsByName.get(iterator.Name__c).size() == 1){
                                    if(!searchResultsInstance.mapsAccsByGenID.containsKey(iterator.GenericExternalID__c)){
                                        if(validateIfSecondaryMatch(iterator,mapAccsByName.get(iterator.Name__c).get(0))){
                                            searchResultsInstance.mapsAccsByGenID.put(iterator.GenericExternalID__c,mapAccsByName.get(iterator.Name__c).get(0).Id);
                                            blnAppHasAPAcc = true;
                                        }
                                    }
                                }else{
                                    for(Account iterator1:mapAccsByName.get(iterator.Name__c)){
                                        if(validateIfSecondaryMatch(iterator,iterator1)){
                                            if(!searchResultsInstance.mapsAccsByGenID.containsKey(iterator.GenericExternalID__c)){
                                                searchResultsInstance.mapsAccsByGenID.put(iterator.GenericExternalID__c,iterator1.Id);
                                            }
                                            blnAppHasAPAcc = true;
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                        if(!blnAppHasAPAcc){
                            if(iterator.Application_State__c.equalsIgnoreCase('Product Selection (Incomplete)')){
                                if(String.isNotBlank(iterator.ApplicationDecisionStatus__c)){
                                    if(!iterator.ApplicationDecisionStatus__c.equalsIgnoreCase('Cancelled')){
                                        searchResultsInstance.mapAppcntsWOutAccsByGenToCreateLead.put(iterator.GenericExternalID__c,iterator);
                                    }
                                }else{
                                    searchResultsInstance.mapAppcntsWOutAccsByGenToCreateLead.put(iterator.GenericExternalID__c,iterator);
                                }   
                            }else{
                                searchResultsInstance.mapAppcntsWOutAccsByGenID.put(iterator.GenericExternalID__c,iterator); 
                            }
                        }
                    }
                }
            }
        }
        return searchResultsInstance;
    }

    /*
        Method to determinate whether the refered account and applicants match when the first criteria has matched. 
    */

    public static Boolean validateIfSecondaryMatch(Applicant_SFDC2__c applicantInstance, Account accountInstance){
        Boolean blnSecondaryMatchWasFound = false;
        if(String.isNotBlank(applicantInstance.Email__c)){
            if(String.isNotBlank(accountInstance.PersonEmail)){
                if(applicantInstance.Email__c.equalsIgnoreCase(accountInstance.PersonEmail)){
                    blnSecondaryMatchWasFound = true;
                }
            }
        }
        if(String.isNotBlank(applicantInstance.Home_Phone__c)){
            if(String.isNotBlank(accountInstance.PersonHomePhone)){
                if(applicantInstance.Home_Phone__c.equalsIgnoreCase(accountInstance.PersonHomePhone)){
                    blnSecondaryMatchWasFound = true;
                }
            }
        }
        if(String.isNotBlank(applicantInstance.Cell_Phone__c)){
            if(String.isNotBlank(accountInstance.PersonMobilePhone)){
                if(applicantInstance.Cell_Phone__c.equalsIgnoreCase(accountInstance.PersonMobilePhone)){
                    blnSecondaryMatchWasFound = true;
                }
            }
        }
        if(!blnSecondaryMatchWasFound){
            if(String.isBlank(applicantInstance.Email__c)){
                if(String.isBlank(applicantInstance.Home_Phone__c)){
                    if(String.isBlank(applicantInstance.Cell_Phone__c)){
                        blnSecondaryMatchWasFound = true;
                    }
                }
            }
        }
        return blnSecondaryMatchWasFound;
    }

    /*
        Method that decides what to do depending on the accounts found  or not found as well as leads found or not found and the application state.
    */

    public static void processApplicants(LookUpResultWrapper lookUpResultInstance){
        Set<String> setCIFs = new Set<String>();
        Set<String> setGenIDs = new Set<String>();
        Set<String> setNames = new Set<String>();
        if(!lookUpResultInstance.mapsAccsByGenID.isEmpty()){
            if(!lookUpResultInstance.mapApplicantsByGenID.isEmpty()){
                updateApplicantLinkedAcount(lookUpResultInstance.mapsAccsByGenID,lookUpResultInstance.mapApplicantsByGenID);
                updateEnrollmentOpportunityOnAccount(lookUpResultInstance.mapsAccsByGenID,new Map<Id,Id>(),lookUpResultInstance.mapApplicantsByGenID,new Set<String>()); 
            }
        }
        if(!lookUpResultInstance.mapAppcntsWOutAccsByGenID.isEmpty()){
            Set<Id> setleadsToDeleteIDs = new Set<Id>();
            for(String iterator:lookUpResultInstance.mapAppcntsWOutAccsByGenID.keySet()){
                if(String.isNotBlank(lookUpResultInstance.mapAppcntsWOutAccsByGenID.get(iterator).CIF__c)){
                    setCIFs.add((lookUpResultInstance.mapAppcntsWOutAccsByGenID.get(iterator).CIF__c));
                }
                setGenIDs.add(iterator);
                setNames.add(lookUpResultInstance.mapAppcntsWOutAccsByGenID.get(iterator).Name__c);
            }
            LeadSearchValidationResultWrapper leadSearchResultInstance = searchRelatedLeads(setGenIDs,setCIFs,setNames);
            Map<String,Applicant_SFDC2__c> mapAppcntsToCreateNewLeads = new Map<String,Applicant_SFDC2__c>();
            Map<Id,Lead> mapLeadsToConvert = new Map<Id,Lead>();
            Map<String,Applicant_SFDC2__c> mapApplcntsToConvertLead = new Map<String,Applicant_SFDC2__c>();
            for(String iterator:lookUpResultInstance.mapAppcntsWOutAccsByGenID.keySet()){
                if(lookUpResultInstance.mapExistingLeadsByGenID.containsKey(iterator)){
                    mapLeadsToConvert.put(lookUpResultInstance.mapExistingLeadsByGenID.get(iterator).Id,lookUpResultInstance.mapExistingLeadsByGenID.get(iterator));
                }else{
                    if(String.isNotBlank(lookUpResultInstance.mapAppcntsWOutAccsByGenID.get(iterator).CIF__c)){
                        if(leadSearchResultInstance.mapFoundLeadsByCIF.containsKey(lookUpResultInstance.mapAppcntsWOutAccsByGenID.get(iterator).CIF__c)){
                            mapLeadsToConvert.put(leadSearchResultInstance.mapFoundLeadsByCIF.get(lookUpResultInstance.mapAppcntsWOutAccsByGenID.get(iterator).CIF__c).Id,leadSearchResultInstance.mapFoundLeadsByCIF.get(lookUpResultInstance.mapAppcntsWOutAccsByGenID.get(iterator).CIF__c));
                            mapApplcntsToConvertLead.put(iterator,lookUpResultInstance.mapAppcntsWOutAccsByGenID.get(iterator));
                            if(lookUpResultInstance.mapAppcntsWOutAccsByGenID.containsKey(iterator)){    
                                lookUpResultInstance.mapAppcntsWOutAccsByGenID.remove(iterator);
                            }
                            continue;
                        }
                    }
                    if(leadSearchResultInstance.mapFoundLeadsByName.containsKey(lookUpResultInstance.mapAppcntsWOutAccsByGenID.get(iterator).Name__c)){
                        mapLeadsToConvert.put(leadSearchResultInstance.mapFoundLeadsByName.get(lookUpResultInstance.mapAppcntsWOutAccsByGenID.get(iterator).Name__c).Id,leadSearchResultInstance.mapFoundLeadsByName.get(lookUpResultInstance.mapAppcntsWOutAccsByGenID.get(iterator).Name__c));
                        mapApplcntsToConvertLead.put(iterator,lookUpResultInstance.mapAppcntsWOutAccsByGenID.get(iterator));
                        if(lookUpResultInstance.mapAppcntsWOutAccsByGenID.containsKey(iterator)){
                            lookUpResultInstance.mapAppcntsWOutAccsByGenID.remove(iterator);
                        }
                        continue; 
                    }
                    if(leadSearchResultInstance.mapFoundLeadsByGenID.containsKey(iterator)){
                        mapLeadsToConvert.put(leadSearchResultInstance.mapFoundLeadsByGenID.get(iterator).Id,leadSearchResultInstance.mapFoundLeadsByGenID.get(iterator));
                        mapApplcntsToConvertLead.put(iterator,lookUpResultInstance.mapAppcntsWOutAccsByGenID.get(iterator));
                        if(lookUpResultInstance.mapAppcntsWOutAccsByGenID.containsKey(iterator)){ 
                            lookUpResultInstance.mapAppcntsWOutAccsByGenID.remove(iterator);
                        }
                        continue;
                    }
                }
            }
            if(!mapLeadsToConvert.isEmpty()){
                if(!mapApplcntsToConvertLead.isEmpty()){
                    convertEnrollmentLead(mapLeadsToConvert, mapApplcntsToConvertLead, new Map<Id,String>(), new Map<String,Set<String>>(), false, 2);   
                }
            }
            if(!lookUpResultInstance.mapAppcntsWOutAccsByGenID.isEmpty()){
                createNewEnrollmentLead(lookUpResultInstance.mapAppcntsWOutAccsByGenID,2);
            }
        }
        if(!lookUpResultInstance.mapAppcntsWOutAccsByGenToCreateLead.isEmpty()){
            for(String iterator:lookUpResultInstance.mapAppcntsWOutAccsByGenToCreateLead.keySet()){
                if(String.isNotBlank(lookUpResultInstance.mapAppcntsWOutAccsByGenToCreateLead.get(iterator).CIF__c)){
                    setCIFs.add(lookUpResultInstance.mapAppcntsWOutAccsByGenToCreateLead.get(iterator).CIF__c);
                }
                setGenIDs.add(iterator);
                setNames.add(lookUpResultInstance.mapAppcntsWOutAccsByGenToCreateLead.get(iterator).Name__c);
            }
            LeadSearchValidationResultWrapper leadSearchResultInstance = searchRelatedLeads(setGenIDs,setCIFs,setNames);
            Map<String,Applicant_SFDC2__c> mapAppcntsToCreateNewLeads = new Map<String,Applicant_SFDC2__c>();
            for(String iterator:lookUpResultInstance.mapAppcntsWOutAccsByGenToCreateLead.keySet()){
                if(String.isNotBlank(lookUpResultInstance.mapAppcntsWOutAccsByGenToCreateLead.get(iterator).CIF__c)){
                    if(leadSearchResultInstance.mapFoundLeadsByCIF.containsKey(lookUpResultInstance.mapAppcntsWOutAccsByGenToCreateLead.get(iterator).CIF__c)){
                        lookUpResultInstance.mapAppcntsWOutAccsByGenToCreateLead.remove(iterator);
                        continue;
                    }
                }
                if(leadSearchResultInstance.mapFoundLeadsByGenID.containsKey(iterator)){
                    lookUpResultInstance.mapAppcntsWOutAccsByGenToCreateLead.remove(iterator);
                }
            }
            if(!lookUpResultInstance.mapAppcntsWOutAccsByGenToCreateLead.isEmpty()){
                createNewEnrollmentLead(lookUpResultInstance.mapAppcntsWOutAccsByGenToCreateLead,1);
            }
        }
    }

    /*
        Method to look up all the leads that match the provided applicants
    */

    public static LeadSearchValidationResultWrapper searchRelatedLeads(Set<String> setGenericIDs, Set<String> setCIFs, Set<String> setNames){ 
        Set<String> setProcessedGenID = new Set<String>();
        Set<String> setProcessedNames = new Set<String>();
        LeadSearchValidationResultWrapper leadSearchResultInstance = new LeadSearchValidationResultWrapper();
        Map<String,Lead> mapLeadsByGenID = new Map<String,Lead>();
        Map<String,Lead> mapLeadsByCIF = new Map<String,Lead>();
        Map<String,Lead> mapLeadsByName = new Map<String,Lead>();
        String strCIFNotNullFilter = 'CIF__c != null';
        String strGenIDNotNullFilter = 'AppNameExtID__c != null';
        String strRTFilter = 'RecordType.DeveloperName  = \'Consumer_Deposits_SFDC2\'';
        String strConvStatFilter = 'isConverted = false';
        String strOppNameNotNull = 'Opportunity_NameSFDC2__c != null';
        if(!setGenericIDs.isEmpty()){
            for(String iterator:setGenericIDs){
                setProcessedGenID.add(String.escapeSingleQuotes(iterator));
            }
            String strGenIDFilter = 'AppNameExtID__c IN (\''+String.join(new List<String>(setProcessedGenID),'\',\'')+'\')';
            String strQueryGenID = 'SELECT Id, AppNameExtID__c, CIF__c, isConverted, Opportunity_NameSFDC2__c, OwnerId, Status, Name FROM Lead WHERE '+String.join(new List<String>{strGenIDFilter,strGenIDNotNullFilter,strRTFilter,strConvStatFilter,strOppNameNotNull},' AND ');
            List<Lead> lstLeadQueryResult = new List<Lead>();
            lstLeadQueryResult = Database.query(strQueryGenID);
            for(Lead iterator:lstLeadQueryResult){
                if(String.isNotBlank(iterator.AppNameExtID__c)){
                    if(setGenericIDs.contains(iterator.AppNameExtID__c)){
                        mapLeadsByGenID.put(iterator.AppNameExtID__c,iterator);
                    }
                }
            }
        }
        if(!setCIFs.isEmpty()){
            String strCIFCodeFilter = 'CIF__c IN (\''+String.join(new List<String>(setCIFs),'\',\'')+'\')';
            String strQueryLeadsCIFs = 'SELECT Id, CIF__c, AppNameExtID__c, isConverted, Opportunity_NameSFDC2__c, OwnerId, Status, Name FROM Lead WHERE '+String.join(new List<String>{strCIFCodeFilter,strCIFNotNullFilter,strRTFilter,strConvStatFilter,strOppNameNotNull},' AND ');
            for(List<Lead> iterator0:Database.query(strQueryLeadsCIFs)){
                for(Lead iterator1:iterator0){
                    if(String.isNotBlank(iterator1.CIF__c)){ 
                        if(setCIFs.contains(iterator1.CIF__c)){
                            mapLeadsByCIF.put(iterator1.CIF__c,iterator1);
                        }
                    }
                }
            }
        }
        if(!setNames.isEmpty()){
            for(String iterator:setNames){
                setProcessedNames.add(String.escapeSingleQuotes(iterator));
            }
            String strNameFilter = 'Name IN (\''+String.join(new List<String>(setProcessedNames),'\',\'')+'\')';
            String strQueryLeadsNames = 'SELECT Id, CIF__c, AppNameExtID__c, isConverted, Opportunity_NameSFDC2__c, OwnerId, Status, Name FROM Lead WHERE '+String.join(new List<String>{strNameFilter,strRTFilter,strConvStatFilter,strOppNameNotNull},' AND ');
            for(List<Lead> iterator0:Database.query(strQueryLeadsNames)){
                for(Lead iterator1:iterator0){
                    if(String.isNotBlank(iterator1.Name)){ 
                        if(setNames.contains(iterator1.Name)){
                            mapLeadsByName.put(iterator1.Name,iterator1);
                        }
                    }
                }
            }
        }
        leadSearchResultInstance.mapFoundLeadsByCIF = mapLeadsByCIF;
        leadSearchResultInstance.mapFoundLeadsByGenID = mapLeadsByGenID;
        leadSearchResultInstance.mapFoundLeadsByName = mapLeadsByName;
        return leadSearchResultInstance;
    }

    /*
        Method that links the refered accounts with their matching applicants
    */

    public static void updateApplicantLinkedAcount(Map<String,Id> mapsAccsByGenID, Map<String,Applicant_SFDC2__c> mapApplicantsByGenID){
        List<Applicant_SFDC2__c> lstAppcntsToUpdate = new List<Applicant_SFDC2__c>();
        for(String iterator:mapApplicantsByGenID.keySet()){
            if(mapsAccsByGenID.containsKey(iterator)){
                if(mapApplicantsByGenID.get(iterator).Linked_Account__c != mapsAccsByGenID.get(iterator)){
                    lstAppcntsToUpdate.add(
                        new Applicant_SFDC2__c(
                            Id = mapApplicantsByGenID.get(iterator).Id,
                            Linked_Account__c = mapsAccsByGenID.get(iterator)
                        )
                    );
                }
            }
        }
        if(!lstAppcntsToUpdate.isEmpty()){
            TriggerLoopExecutionControl_cls.setAlreadyBeenExecuted('ApplicantTrigger');
            TriggerLoopExecutionControl_cls.setAlreadyBeenExecuted('ApplicationTrigger');    
            Database.update(lstAppcntsToUpdate,false);
        }
    }

    /*
        Method to create / update (upsert) the opportunities related to the refered applicants when applies
    */

    public static void updateEnrollmentOpportunityOnAccount(Map<String,Id> mapsAccsByGenID, Map<Id,Id> mapOppsIdByAccID, Map<String,Applicant_SFDC2__c> mapAppcntsByGenID, Set<String> setOppNoToCreateOppQueue){
        Map<String,RecordType> mapOppsRTsByDevName = UtilsSFDC2.getRecordTypesMap('Opportunity','DeveloperName');
        Map<String,Opportunity> mapOppsByExtIDToUpdate = new Map<String,Opportunity>();
        Map<String,Opportunity> mapOppsByExtIDToUpsert = new Map<String,Opportunity>();
        Map<String,Opportunity> mapOppByAccountID = new Map<String,Opportunity>();
        Map<String,Opportunity> mapOppByEnrExtID = new Map<String,Opportunity>();
        Set<String> setOppExtIDs = new Set<String>();
        for(Applicant_SFDC2__c iterator:mapAppcntsByGenID.values()){
            setOppExtIDs.add(iterator.OpportunityExtID__c);
        }
        for(List<Opportunity> iterator0:[SELECT Id, EnrollmentTCIExtID__c, Name, AccountId FROM Opportunity WHERE EnrollmentTCIExtID__c IN: setOppExtIDs AND EnrollmentTCIExtID__c !=: null]){
            for(Opportunity iterator1:iterator0){
                if(String.isNotBlank(iterator1.EnrollmentTCIExtID__c)){
                    mapOppByEnrExtID.put(iterator1.EnrollmentTCIExtID__c,iterator1);
                }
            }
        }
        for(List<Opportunity> iterator0:[SELECT Id, EnrollmentTCIExtID__c, Name, AccountId FROM Opportunity WHERE AccountId IN: mapsAccsByGenID.values() AND AccountId !=: null]){
            for(Opportunity iterator1:iterator0){
                if(iterator1.AccountId != null){
                    mapOppByAccountID.put(iterator1.AccountId,iterator1);
                }
            }
        }
        for(String iterator:mapAppcntsByGenID.keySet()){
            Opportunity oppInstance = new Opportunity();
            Boolean blnNewOpp = true;
            if(mapsAccsByGenID.containsKey(iterator)){
                if(mapOppsIdByAccID.containsKey(mapsAccsByGenID.get(iterator))){
                    oppInstance.Id = mapOppsIdByAccID.get(mapsAccsByGenID.get(iterator));
                    blnNewOpp = false;
                }else if(mapOppByEnrExtID.containsKey(mapAppcntsByGenID.get(iterator).OpportunityExtID__c)){
                    oppInstance = mapOppByEnrExtID.get(mapAppcntsByGenID.get(iterator).OpportunityExtID__c);
                    blnNewOpp = false;
                }else if(mapOppByAccountID.containsKey(mapsAccsByGenID.get(iterator))){
                    if(String.isBlank(mapOppByAccountID.get(mapsAccsByGenID.get(iterator)).EnrollmentTCIExtID__c)){
                        if(mapOppByAccountID.get(mapsAccsByGenID.get(iterator)).Name.contains(iterator)){
                            oppInstance = mapOppByAccountID.get(mapsAccsByGenID.get(iterator));
                            blnNewOpp = false;
                        }
                    }
                }
                if(blnNewOpp){
                    oppInstance.Name = 'Opportunity '+mapAppcntsByGenID.get(iterator).OpportunityExtID__c;
                    oppInstance.AccountId = mapsAccsByGenID.get(iterator);
                }
                oppInstance.Related_Application__c = mapAppcntsByGenID.get(iterator).Application_Id__c;
                oppInstance.EnrollmentTCIExtID__c = mapAppcntsByGenID.get(iterator).OpportunityExtID__c;
                oppInstance.CloseDate = Date.today().addMonths(1);
                oppInstance.RecordTypeId =  mapOppsRTsByDevName.get('Consumer_Deposits_SFDC2').Id;
                oppInstance.StageName = getStageName(mapAppcntsByGenID.get(iterator));
                oppInstance.LeadSource = 'Application';
                oppInstance.CampaignId = null;
                if(oppInstance.StageName.equalsIgnoreCase('4 - Application in Progress')){
                    oppInstance.CampaignId = strAbandonedCamp;
                }
                if(blnNewOpp){
                    if(String.isNotBlank(oppInstance.EnrollmentTCIExtID__c)){
                        oppInstance.Id = null;
                        mapOppsByExtIDToUpsert.put(oppInstance.EnrollmentTCIExtID__c,oppInstance);
                    }
                }else if(oppInstance.Id != null){
                    if(String.isNotBlank(oppInstance.EnrollmentTCIExtID__c)){
                        mapOppsByExtIDToUpdate.put(oppInstance.EnrollmentTCIExtID__c,oppInstance);
                    }
                }
            }
        }
        for(String iterator:mapOppsByExtIDToUpsert.keySet()){
            if(mapOppsByExtIDToUpdate.containsKey(iterator)){
                mapOppsByExtIDToUpdate.remove(iterator);
            }
        }
        if(!mapOppsByExtIDToUpsert.isEmpty()){
            List<Database.UpsertResult> lstUpstR = new List<Database.UpsertResult>();
            Set<Id> setCreatedOppsByID = new Set<Id>();
            Map<Id,Opportunity> mapCreatedOppsById = new Map<Id,Opportunity>();
            SObjectField f = Opportunity.EnrollmentTCIExtID__c;
            TriggerLoopExecutionControl_cls.setAlreadyBeenExecuted('OpportunityTrigger');
            TriggerLoopExecutionControl_cls.setAlreadyBeenExecuted('AccountTrigger');
            lstUpstR = Database.upsert(mapOppsByExtIDToUpsert.values(),f,false);
            for(Database.UpsertResult iterator:lstUpstR){
                if(iterator.isSuccess()){
                    if(iterator.isCreated()){
                        setCreatedOppsByID.add(iterator.getId());
                    }
                }
            }
            for(Opportunity iterator:mapOppsByExtIDToUpsert.values()){
                if(iterator.Id != null){
                    if(setCreatedOppsByID.contains(iterator.Id)){
                        if(!setOppNoToCreateOppQueue.contains(iterator.Name)){
                            mapCreatedOppsById.put(iterator.Id, iterator);
                        }
                    }
                }
            }
            if(!mapCreatedOppsById.isEmpty()){
                sendEnrollmentOppsToQueue(mapCreatedOppsById.keySet());
            }
        }
        if(!mapOppsByExtIDToUpdate.isEmpty()){
            TriggerLoopExecutionControl_cls.setAlreadyBeenExecuted('OpportunityTrigger');
            TriggerLoopExecutionControl_cls.setAlreadyBeenExecuted('AccountTrigger');
            Database.update(mapOppsByExtIDToUpdate.values(),false);
        }
    }

    public static String getStageName(Applicant_SFDC2__c applicantInstance){
        String strStageName  = '1 - New (Open, 0%, Pipeline)';
        Boolean blnStageWasAssigned = false;
        if(applicantInstance.Application_State__c.equalsIgnoreCase('Product Selection (Incomplete)')){
            strStageName = (applicantInstance.ApplicationDecisionStatus__c != null)?(applicantInstance.ApplicationDecisionStatus__c.equalsIgnoreCase('Cancelled'))?'0 - Closed - Lost':'4 - Application in Progress':'4 - Application in Progress';
            blnStageWasAssigned = true;
        }
        if(!blnStageWasAssigned){
            if(applicantInstance.Application_State__c.equalsIgnoreCase('Disclosures (Incomplete)')){
                strStageName = (applicantInstance.ApplicationDecisionStatus__c.equalsIgnoreCase('Cancelled'))?'0 - Closed - Lost':'4 - Application in Progress';
                blnStageWasAssigned = true;
            }
        }
        if(!blnStageWasAssigned){
            if(applicantInstance.Application_State__c.equalsIgnoreCase('Personal Information (Incomplete)') || applicantInstance.Application_State__c.equalsIgnoreCase('Review and Submit (Incomplete)')){
                strStageName = (applicantInstance.ApplicationDecisionStatus__c.equalsIgnoreCase('No Decision'))?'4 - Application in Progress':(applicantInstance.ApplicationDecisionStatus__c.equalsIgnoreCase('Cancelled'))?'0 - Closed - Lost':strStageName;
                blnStageWasAssigned = (applicantInstance.ApplicationDecisionStatus__c.equalsIgnoreCase('No Decision') || applicantInstance.ApplicationDecisionStatus__c.equalsIgnoreCase('Cancelled'))?true:false;
            }
        }
        if(!blnStageWasAssigned){
            if(applicantInstance.Application_State__c.equalsIgnoreCase('KBA Still to Be Answered') || applicantInstance.Application_State__c.equalsIgnoreCase('Pending Application Review') || applicantInstance.Application_State__c.equalsIgnoreCase('Pending Completion of KBA') || applicantInstance.Application_State__c.equalsIgnoreCase('Referred From Another Brand') || applicantInstance.Application_State__c.equalsIgnoreCase('Waiting for Customer to Remove Freeze')){
                strStageName = (applicantInstance.ApplicationDecisionStatus__c.equalsIgnoreCase('No Decision'))?'5 - Pending Review':strStageName;
                blnStageWasAssigned = (applicantInstance.ApplicationDecisionStatus__c.equalsIgnoreCase('No Decision'))?true:false;
            }
        }
        if(!blnStageWasAssigned){
            if(applicantInstance.Application_State__c.equalsIgnoreCase('Documents Requested') || applicantInstance.Application_State__c.equalsIgnoreCase('Pending Document Review') || applicantInstance.Application_State__c.equalsIgnoreCase('Response Needed From Customer') || applicantInstance.Application_State__c.equalsIgnoreCase('Waiting for Mitek Upload')){
                strStageName = (applicantInstance.ApplicationDecisionStatus__c.equalsIgnoreCase('No Decision'))?'6 - Pending Documentation':strStageName;
                blnStageWasAssigned = (applicantInstance.ApplicationDecisionStatus__c.equalsIgnoreCase('No Decision'))?true:false;
            }
        }
        if(!blnStageWasAssigned){
            if(applicantInstance.Application_State__c.equalsIgnoreCase('Account Number Error') || applicantInstance.Application_State__c.equalsIgnoreCase('Boarding Error') || applicantInstance.Application_State__c.equalsIgnoreCase('Complete') || applicantInstance.Application_State__c.equalsIgnoreCase('Documents Requested') || applicantInstance.Application_State__c.equalsIgnoreCase('NetBank Accepted / Disclosures') || applicantInstance.Application_State__c.equalsIgnoreCase('NetBank Accepted / Product Selection') || applicantInstance.Application_State__c.equalsIgnoreCase('Referred From Another Brand') || applicantInstance.Application_State__c.equalsIgnoreCase('Task List - Post Boarding')){
                strStageName = (applicantInstance.ApplicationDecisionStatus__c.equalsIgnoreCase('Approved'))?'7 - Approved Unfunded':strStageName;
                blnStageWasAssigned = (applicantInstance.ApplicationDecisionStatus__c.equalsIgnoreCase('Approved'))?true:false;
            }
        }
        if(!blnStageWasAssigned){
            if(applicantInstance.Application_State__c.equalsIgnoreCase('KBA Still to Be Answered') || applicantInstance.Application_State__c.equalsIgnoreCase('Documents Requested') || applicantInstance.Application_State__c.equalsIgnoreCase('Mitek Upload Page') || applicantInstance.Application_State__c.equalsIgnoreCase('Pending Application Review') || applicantInstance.Application_State__c.equalsIgnoreCase('Pending Completion of KBA') || applicantInstance.Application_State__c.equalsIgnoreCase('Pending Document Review') || applicantInstance.Application_State__c.equalsIgnoreCase('Referred to NetBank') || applicantInstance.Application_State__c.equalsIgnoreCase('Response Needed From Customer') || applicantInstance.Application_State__c.equalsIgnoreCase('Waiting for Mitek Upload') || applicantInstance.Application_State__c.equalsIgnoreCase('Complete')){
                strStageName = (applicantInstance.ApplicationDecisionStatus__c.equalsIgnoreCase('Cancelled'))?'0 - Closed - Lost':strStageName;
                blnStageWasAssigned = (applicantInstance.ApplicationDecisionStatus__c.equalsIgnoreCase('Cancelled'))?true:false;
            }
        }
        if(!blnStageWasAssigned){
            if(applicantInstance.Application_State__c.equalsIgnoreCase('Complete') || applicantInstance.Application_State__c.equalsIgnoreCase('Referred to NetBank')){
                strStageName = (applicantInstance.ApplicationDecisionStatus__c.equalsIgnoreCase('Declined'))?'0 - Closed - Lost':strStageName;
                blnStageWasAssigned = (applicantInstance.ApplicationDecisionStatus__c.equalsIgnoreCase('Declined'))?true:false;
            }
        }
        if(!blnStageWasAssigned){
            strStageName  = '1 - New (Open, 0%, Pipeline)';
        }
        return strStageName;
    }

    /*
        Verifies whether the refered applicants fit for processing based on state's and decision's values
    */

    public static Boolean verifyIfAppliesProcessing(Applicant_SFDC2__c applicantToValidate){
        Boolean blnApplies = false;
        if(applicantToValidate.Application_State__c.equalsIgnoreCase('Product Selection (Incomplete)')){
            blnApplies = true;
        }else if(String.isNotBlank(applicantToValidate.ApplicationDecisionStatus__c)){
            if(String.isNotBlank(applicantToValidate.Application_State__c)){
                if(applicantToValidate.Application_State__c.equalsIgnoreCase('Disclosures (Incomplete)')){
                    blnApplies = true;
                }
                if(applicantToValidate.Application_State__c.equalsIgnoreCase('Personal Information (Incomplete)') || applicantToValidate.Application_State__c.equalsIgnoreCase('Review and Submit (Incomplete)')){
                    blnApplies = (applicantToValidate.ApplicationDecisionStatus__c.equalsIgnoreCase('No Decision') || applicantToValidate.ApplicationDecisionStatus__c.equalsIgnoreCase('Cancelled'))?true:false;
                }
                if(!blnApplies){
                    if(applicantToValidate.Application_State__c.equalsIgnoreCase('KBA Still to Be Answered') || applicantToValidate.Application_State__c.equalsIgnoreCase('Pending Application Review') || applicantToValidate.Application_State__c.equalsIgnoreCase('Pending Completion of KBA') || applicantToValidate.Application_State__c.equalsIgnoreCase('Referred From Another Brand') || applicantToValidate.Application_State__c.equalsIgnoreCase('Waiting for Customer to Remove Freeze')){
                        blnApplies = (applicantToValidate.ApplicationDecisionStatus__c.equalsIgnoreCase('No Decision'))?true:false;
                    }
                }
                if(!blnApplies){
                    if(applicantToValidate.Application_State__c.equalsIgnoreCase('Documents Requested') || applicantToValidate.Application_State__c.equalsIgnoreCase('Pending Document Review') || applicantToValidate.Application_State__c.equalsIgnoreCase('Response Needed From Customer') || applicantToValidate.Application_State__c.equalsIgnoreCase('Waiting for Mitek Upload')){
                        blnApplies = (applicantToValidate.ApplicationDecisionStatus__c.equalsIgnoreCase('No Decision'))?true:false;
                    }
                }
                if(!blnApplies){
                    if(applicantToValidate.Application_State__c.equalsIgnoreCase('Account Number Error') || applicantToValidate.Application_State__c.equalsIgnoreCase('Boarding Error') || applicantToValidate.Application_State__c.equalsIgnoreCase('Complete') || applicantToValidate.Application_State__c.equalsIgnoreCase('Documents Requested') || applicantToValidate.Application_State__c.equalsIgnoreCase('NetBank Accepted / Disclosures') || applicantToValidate.Application_State__c.equalsIgnoreCase('NetBank Accepted / Product Selection') || applicantToValidate.Application_State__c.equalsIgnoreCase('Referred From Another Brand') || applicantToValidate.Application_State__c.equalsIgnoreCase('Task List - Post Boarding')){
                        blnApplies = (applicantToValidate.ApplicationDecisionStatus__c.equalsIgnoreCase('Approved'))?true:false;
                    }
                }
                if(!blnApplies){
                    if(applicantToValidate.Application_State__c.equalsIgnoreCase('KBA Still to Be Answered') || applicantToValidate.Application_State__c.equalsIgnoreCase('Documents Requested') || applicantToValidate.Application_State__c.equalsIgnoreCase('Mitek Upload Page') || applicantToValidate.Application_State__c.equalsIgnoreCase('Pending Application Review') || applicantToValidate.Application_State__c.equalsIgnoreCase('Pending Completion of KBA') || applicantToValidate.Application_State__c.equalsIgnoreCase('Pending Document Review') || applicantToValidate.Application_State__c.equalsIgnoreCase('Referred to NetBank') || applicantToValidate.Application_State__c.equalsIgnoreCase('Response Needed From Customer') || applicantToValidate.Application_State__c.equalsIgnoreCase('Waiting for Mitek Upload') || applicantToValidate.Application_State__c.equalsIgnoreCase('Complete')){
                        blnApplies = (applicantToValidate.ApplicationDecisionStatus__c.equalsIgnoreCase('Cancelled'))?true:false;
                    }
                }
                if(!blnApplies){
                    if(applicantToValidate.Application_State__c.equalsIgnoreCase('Complete') || applicantToValidate.Application_State__c.equalsIgnoreCase('Referred to NetBank')){
                        blnApplies = (applicantToValidate.ApplicationDecisionStatus__c.equalsIgnoreCase('Declined'))?true:false;
                    }
                }
            }
        }
        return blnApplies;
    }

    /*
        Method to create new leads when applies
    */


    public static void createNewEnrollmentLead(Map<String, Applicant_SFDC2__c> mapApplicantsByGenID, Integer intCreationMode) {
        Map<String,RecordType> mapLeadRTsByDevName = UtilsSFDC2.getRecordTypesMap('Lead','DeveloperName');
        Map<String,Lead> mapLeadByGenID = new Map<String,Lead>();
        Map<Id,Lead> mapLeadsToConvert = new Map<Id,Lead>();
        Map<String,Lead> mapLeadsByCIF = new Map<String,Lead>();
        Map<String,Lead> mapLeadsByName = new Map<String,Lead>();
        Map<String,String> mapGenIDByCIF = new Map<String,String>();
        Map<String,String> mapGenIDByName = new Map<String,String>();
        Map<String,Set<String>> mapApplicantsSharingAccountByCIF = new Map<String,Set<String>>();
        Map<String,Set<String>> mapApplicantsSharingAccountByName = new Map<String,Set<String>>();
        Map<String,Set<String>> mapProcessedToShareLeadApplcntsRefs = new Map<String,Set<String>>();
        Map<Id,String> mapGenIDByLeadID = new Map<Id,String>();
        for(String iterator:mapApplicantsByGenID.keySet()){
            Lead leadToProcess = new Lead(
                FirstName = mapApplicantsByGenID.get(iterator).First_Name__c,
                LastName = mapApplicantsByGenID.get(iterator).Last_Name__c,
                Email = mapApplicantsByGenID.get(iterator).Email__c,
                Phone = mapApplicantsByGenID.get(iterator).Home_Phone__c,
                MobilePhone = mapApplicantsByGenID.get(iterator).Cell_Phone__c,
                Status = 'New',
                LeadSource = 'Application',
                Employer__c = 'Not Provided',
                RecordTypeId = mapLeadRTsByDevName.get('Consumer_Deposits_SFDC2').Id,
                Opportunity_NameSFDC2__c = 'Opportunity '+mapApplicantsByGenID.get(iterator).OpportunityExtID__c, 
                Applicant_Id__c = mapApplicantsByGenID.get(iterator).Id,
                Street = mapApplicantsByGenID.get(iterator).Address_1__c,
                City = mapApplicantsByGenID.get(iterator).City__c,
                State = mapApplicantsByGenID.get(iterator).State__c,
                CIF__c = mapApplicantsByGenID.get(iterator).CIF__c,
                PostalCode = mapApplicantsByGenID.get(iterator).Zip__c,
                AppNameExtID__c = mapApplicantsByGenID.get(iterator).GenericExternalID__c,
                Primary_Campaign_SFDC2__c = (intCreationMode == 1)?strIncAppCampID:null,
                isFromApplication__c = true
            );
            if(String.isNotBlank(leadToProcess.CIF__c)){
                if(!mapLeadsByCIF.containsKey(leadToProcess.CIF__c)){
                    mapLeadsByCIF.put(leadToProcess.CIF__c,leadToProcess);
                    mapGenIDByCIF.put(leadToProcess.CIF__c,leadToProcess.AppNameExtID__c);
                    mapApplicantsSharingAccountByCIF.put(leadToProcess.AppNameExtID__c,new Set<String>());
                }else if(mapGenIDByCIF.containsKey(leadToProcess.CIF__c)){
                    String strExtID = mapGenIDByCIF.get(leadToProcess.CIF__c);
                    if(mapApplicantsSharingAccountByCIF.containsKey(strExtID)){
                        mapApplicantsSharingAccountByCIF.get(strExtID).add(leadToProcess.AppNameExtID__c);
                    }
                }
            }
            String strLeadName = leadToProcess.FirstName +' '+ leadToProcess.LastName;
            if(!mapLeadsByName.containsKey(strLeadName)){
                mapLeadsByName.put(strLeadName,leadToProcess);
                mapGenIDByName.put(strLeadName,leadToProcess.AppNameExtID__c);
                mapApplicantsSharingAccountByName.put(leadToProcess.AppNameExtID__c,new Set<String>());
            }else{
                String strExtID = mapGenIDByName.get(strLeadName);
                if(mapApplicantsSharingAccountByName.containsKey(strExtID)){
                    mapApplicantsSharingAccountByName.get(strExtID).add(leadToProcess.AppNameExtID__c);
                }
            }
            if(!mapLeadByGenID.containsKey(leadToProcess.AppNameExtID__c)){
                mapLeadByGenID.put(leadToProcess.AppNameExtID__c,leadToProcess);
            }
        }
        for(String iterator:mapApplicantsSharingAccountByCIF.keySet()){
            if(!mapProcessedToShareLeadApplcntsRefs.containsKey(iterator)){
                mapProcessedToShareLeadApplcntsRefs.put(iterator,new Set<String>());
            }
            mapProcessedToShareLeadApplcntsRefs.get(iterator).addAll(mapApplicantsSharingAccountByCIF.get(iterator));
            if(mapApplicantsSharingAccountByName.containsKey(iterator)){
                mapProcessedToShareLeadApplcntsRefs.get(iterator).addAll(mapApplicantsSharingAccountByName.get(iterator));
                mapApplicantsSharingAccountByName.remove(iterator);
            }
        }
        for(String iterator:mapApplicantsSharingAccountByName.keySet()){
            if(!mapProcessedToShareLeadApplcntsRefs.containsKey(iterator)){
                mapProcessedToShareLeadApplcntsRefs.put(iterator,mapApplicantsSharingAccountByName.get(iterator));
            }
        }
        if(!mapLeadByGenID.isEmpty()){
            Set<Id> setUpsertedLeads = new Set<Id>();
            SObjectField f = Lead.AppNameExtID__c;
            TriggerLoopExecutionControl_cls.setAlreadyBeenExecuted('LeadTrigger');
            List<Database.UpsertResult> lstURs = Database.upsert(mapLeadByGenID.values(),f,false);
            for(String iterator:mapLeadByGenID.keySet()){
                Id recordId = mapLeadByGenID.get(iterator).Id;
                if(recordId != null){
                    mapLeadsToConvert.put(recordId,mapLeadByGenID.get(iterator));
                    mapGenIDByLeadID.put(recordId,mapLeadByGenID.get(iterator).AppNameExtID__c);
                }
            }
        }
        if(intCreationMode == 2){
            if(!mapLeadsToConvert.isEmpty()){
                convertEnrollmentLead(mapLeadsToConvert, mapApplicantsByGenID, mapGenIDByLeadID, mapProcessedToShareLeadApplcntsRefs, false, 1);
            }
        }
    }

    /*
        Method to convert the specified leads
    */

    public static void convertEnrollmentLead(Map<Id,Lead> mapLeadsToConvert, Map<String, Applicant_SFDC2__c> mapApplicantsByGenID, Map<Id,String> mapGenIDByLeadID, Map<String,Set<String>> mapProcessedToShareLeadApplcntsRefs, Boolean blnSendAlert, Integer mode) {
        Map<String,RecordType> mapLeadRTsByDevName = UtilsSFDC2.getRecordTypesMap('Lead','DeveloperName');
        List<Group> lstQueues = new List<Group>();
        String strAPIQueueId =  ApplicationTriggerHandler.consumerDepositsLeadQueueId;
        String strAPIUserId = ApplicationTriggerHandler.apiServ;
        Set<Id> setQueuesNotAllowed = new Set<Id>();
        for(List<QueueSobject> iterator0:[SELECT QueueId FROM QueueSobject WHERE SObjectType = 'Lead' AND QueueId !=: strAPIQueueId]){
            for(QueueSobject iterator1:iterator0){
                setQueuesNotAllowed.add(iterator1.QueueId);
            }
        }
        Set<String> setControlOwners = new Set<String>{
            strAPIQueueId,
            strAPIUserId
        };
        List<Database.LeadConvert> lstConvItems = new List<Database.LeadConvert>();
        Map<Id,Lead> mapConvertedLeads = new Map<Id,Lead>();
        Map<Id,Id> mapOppsIdByAccID = new Map<Id,Id>();
        Map<String,Id> mapLeadApplicantCorrespondency = new Map<String,Id>();
        Map<Id,Id> mapCorrespondencyLeadIDAccountID = new Map<Id,Id>();
        Map<Id,String> mapCorrespondencyGenIDByAccID = new Map<Id,String>();
        Map<Id,String> mapCorrespondencyGenIDByOppID = new Map<Id,String>();
        Set<String> setAccsToSetOwnerServiceAccount = new Set<String>();
        Set<String> setOppNoToCreateOppQueue = new Set<String>();
        for(Lead iterator:mapLeadsToConvert.values()){
            Database.LeadConvert convertLeadInstance = new Database.LeadConvert();
            String strOppName = iterator.Opportunity_NameSFDC2__c;
            convertLeadInstance.setLeadId(iterator.Id);
            convertLeadInstance.setConvertedStatus('Contacted/Converted');
            convertLeadInstance.setOpportunityName(strOppName);
            if(strAPIQueueId.equalsIgnoreCase(iterator.OwnerId) || setQueuesNotAllowed.contains(iterator.OwnerId)){
                convertLeadInstance.setOwnerId(strAPIUserId);
            }else{
                convertLeadInstance.setOwnerId(iterator.OwnerId);
            }
            if(mode != 1){
                if(!setControlOwners.contains(iterator.OwnerId)){   
                    setOppNoToCreateOppQueue.add(strOppName);
                    setAccsToSetOwnerServiceAccount.add(iterator.Name);
                }
            }
            convertLeadInstance.setSendNotificationEmail(blnSendAlert);
            lstConvItems.add(convertLeadInstance);
        }
        if(!lstConvItems.isEmpty()){
            TriggerLoopExecutionControl_cls.setAlreadyBeenExecuted('LeadTrigger');
            TriggerLoopExecutionControl_cls.setAlreadyBeenExecuted('AccountTrigger');
            TriggerLoopExecutionControl_cls.setAlreadyBeenExecuted('OpportunityTrigger');
            TriggerLoopExecutionControl_cls.setAlreadyBeenExecuted('ContactTrigger');
            List<Database.LeadConvertResult> lstLeadConvertStatus = Database.convertLead(lstConvItems,false);
            for(Database.LeadConvertResult iterator:lstLeadConvertStatus){
                if(iterator.isSuccess()){
                    if(mapLeadsToConvert.containsKey(iterator.getLeadId())){
                        mapConvertedLeads.put(iterator.getLeadId(),mapLeadsToConvert.get(iterator.getLeadId()));
                    }
                    mapCorrespondencyLeadIDAccountID.put(iterator.getLeadId(),iterator.getAccountId());
                    if(mapGenIDByLeadID.containskey(iterator.getLeadId())){
                        mapCorrespondencyGenIDByAccID.put(iterator.getAccountId(),mapGenIDByLeadID.get(iterator.getLeadId()));
                        mapOppsIdByAccID.put(iterator.getAccountId(),iterator.getOpportunityId());
                    }
                }
            }
        }
        Map<String,Id> mapAccsByGenID = new Map<String,Id>();
        Map<String,Applicant_SFDC2__c> mapApplicantsToLinkByGenID = new Map<String,Applicant_SFDC2__c>();
        for(Id iterator0:mapCorrespondencyLeadIDAccountID.keySet()){
            if(mapGenIDByLeadID.containsKey(iterator0)){
                if(mapProcessedToShareLeadApplcntsRefs.containsKey(mapGenIDByLeadID.get(iterator0))){
                    if(mapApplicantsByGenID.containsKey(mapGenIDByLeadID.get(iterator0))){
                        mapAccsByGenID.put(mapGenIDByLeadID.get(iterator0),mapCorrespondencyLeadIDAccountID.get(iterator0));
                        mapApplicantsToLinkByGenID.put(mapGenIDByLeadID.get(iterator0),mapApplicantsByGenID.get(mapGenIDByLeadID.get(iterator0)));
                    }
                }
            }
        }
        if(!mapAccsByGenID.isEmpty()){
            if(!mapApplicantsToLinkByGenID.isEmpty()){
                updateApplicantLinkedAcount(mapAccsByGenID,mapApplicantsToLinkByGenID);
                updateEnrollmentOpportunityOnAccount(mapAccsByGenID,mapOppsIdByAccID,mapApplicantsToLinkByGenID,setOppNoToCreateOppQueue); 
            }
        }
        if(!mapApplicantsByGenID.isEmpty()){
            if(!mapCorrespondencyGenIDByAccID.isEmpty()){
                if(!mapProcessedToShareLeadApplcntsRefs.isEmpty()){
                    linkConvertedEnrollmentAccounts(mapApplicantsByGenID,mapCorrespondencyGenIDByAccID,mapProcessedToShareLeadApplcntsRefs,setOppNoToCreateOppQueue);
                }
            }
        }
        if(!setAccsToSetOwnerServiceAccount.isEmpty()){
            updateAccountOwner(setAccsToSetOwnerServiceAccount);
        }
    }

    /*
        Method to link the applicants to the accounts created as a result of a lead conversion
    */

    public static void linkConvertedEnrollmentAccounts(Map<String, Applicant_SFDC2__c> mapApplicantsByGenID, Map<Id,String> mapCorrespondencyGenIDByAccID, Map<String,Set<String>> mapProcessedToShareLeadApplcntsRefs, Set<String> setOppNoToCreateOppQueue){ 
        Map<String,Applicant_SFDC2__c> mapAppcntsToUpdate = new Map<String,Applicant_SFDC2__c>();
        Map<String,Opportunity> mapOppsToUpsert = new Map<String,Opportunity>();
        Map<String,RecordType> mapOppsRTsByDevName = UtilsSFDC2.getRecordTypesMap('Opportunity','DeveloperName');
        for(Id iterator0:mapCorrespondencyGenIDByAccID.keySet()){
            if(mapApplicantsByGenID.containsKey(mapCorrespondencyGenIDByAccID.get(iterator0))){
                if(mapProcessedToShareLeadApplcntsRefs.containsKey(mapCorrespondencyGenIDByAccID.get(iterator0))){
                    for(String iterator1:mapProcessedToShareLeadApplcntsRefs.get(mapCorrespondencyGenIDByAccID.get(iterator0))){
                        if(mapApplicantsByGenID.containsKey(iterator1)){
                            mapAppcntsToUpdate.put(
                                mapApplicantsByGenID.get(iterator1).OpportunityExtID__c,
                                new Applicant_SFDC2__c(
                                    Id = mapApplicantsByGenID.get(iterator1).Id,
                                    Linked_Account__c = iterator0
                                )
                            );
                            mapOppsToUpsert.put(
                                mapApplicantsByGenID.get(iterator1).OpportunityExtID__c,
                                new Opportunity(
                                    AccountId = iterator0,
                                    LeadSource = 'Application',
                                    RecordTypeId =  mapOppsRTsByDevName.get('Consumer_Deposits_SFDC2').Id,
                                    StageName = getStageName(mapApplicantsByGenID.get(iterator1)),
                                    CampaignId = (getStageName(mapApplicantsByGenID.get(iterator1)).equalsIgnoreCase('4 - Application in Progress'))?strAbandonedCamp:null,
                                    Related_Application__c = mapApplicantsByGenID.get(iterator1).Application_Id__c,
                                    EnrollmentTCIExtID__c = mapApplicantsByGenID.get(iterator1).OpportunityExtID__c,
                                    CloseDate = Date.today().addMonths(1),
                                    Name = 'Opportunity '+mapApplicantsByGenID.get(iterator1).OpportunityExtID__c
                                )
                            );
                        }
                    }             
                }
            }
        }
        if(!mapAppcntsToUpdate.isEmpty()){
            TriggerLoopExecutionControl_cls.setAlreadyBeenExecuted('ApplicantTrigger');
            TriggerLoopExecutionControl_cls.setAlreadyBeenExecuted('ApplicationTrigger');       
            Database.update(mapAppcntsToUpdate.values(),false);
        }
        if(!mapOppsToUpsert.isEmpty()){
            Set<Id> setCreatedOppsByID = new Set<Id>();
            Map<Id,Opportunity> mapCreatedOppsById = new Map<Id,Opportunity>();
            SObjectField f = Opportunity.EnrollmentTCIExtID__c;
            TriggerLoopExecutionControl_cls.setAlreadyBeenExecuted('OpportunityTrigger');
            TriggerLoopExecutionControl_cls.setAlreadyBeenExecuted('AccountTrigger');
            List<Database.UpsertResult> lstUpstR = Database.upsert(mapOppsToUpsert.values(),f,false);
            for(Database.UpsertResult iterator:lstUpstR){
                if(iterator.isSuccess()){
                    if(iterator.isCreated()){
                        setCreatedOppsByID.add(iterator.getId());
                    }
                }
            }
            for(Opportunity iterator:mapOppsToUpsert.values()){
                if(iterator.Id != null){
                    if(setCreatedOppsByID.contains(iterator.Id)){
                        if(!setOppNoToCreateOppQueue.contains(iterator.Name)){
                            mapCreatedOppsById.put(iterator.Id, iterator);
                        }
                    }
                }
            }
            if(!mapCreatedOppsById.isEmpty()){
                sendEnrollmentOppsToQueue(mapCreatedOppsById.keySet());
            }
        }
    }

    public static void assignToProperQueue(List<Lead> leadsToAssignOwners){
        Id consumerDepositsLeadQueueId = ApplicationTriggerHandler.consumerDepositsLeadQueueId; 
        if(consumerDepositsLeadQueueId != null){
            for(Lead iterator:leadsToAssignOwners){
                iterator.OwnerId = consumerDepositsLeadQueueId;
            }
        }
    }

    /*
        Method to create opportunity queue records if applies
    */

    public static void sendEnrollmentOppsToQueue(Set<Id> setOppsToCreateQueue) {
        Group oppQueueId = new Group();
        try{oppQueueId = [SELECT Id FROM Group WHERE type = 'Queue' AND DeveloperName = 'Consumer_Deposits_Opportunity_Queue' LIMIT 1];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
        if(oppQueueId.Id != null){
            List<Opportunity_Queue__c> lstOQToInsert = new List<Opportunity_Queue__c>();
            for(Id iterator : setOppsToCreateQueue) {
                lstOQToInsert.add(
                    new Opportunity_Queue__c(
                        Opportunity__c = iterator,
                        OwnerId = oppQueueId.Id
                    )
                );
            }
            if(!lstOQToInsert.isEmpty()) {
                Database.insert(lstOQToInsert,false);
            }
        }
    }

    /*
        Method to update the owner of the accounts when applies
    */

    public static void updateAccountOwner(Set<String> setAccsToSetOwnerServiceAccount){
        List<Account> lstAccsToUpd = new List<Account>();
        for(List<Account> iterator0:[SELECT Id FROM Account WHERE Name IN:setAccsToSetOwnerServiceAccount]){
            for(Account iterator1:iterator0){
                lstAccsToUpd.add(new Account(
                    Id = iterator1.Id,
                    OwnerId = ApplicationTriggerHandler.apiServ
                ));
            }
        }
        if(!lstAccsToUpd.isEmpty()){
            TriggerLoopExecutionControl_cls.setAlreadyBeenExecuted('AccountTrigger');
            Database.update(lstAccsToUpd,false);
        }
    }

    /*
        Wrapper to specify the applicant's info to look for the related accounts
    */

    public class ApplicantsInfoWrapper{
        public Set<String> setNames;
        public Set<Id> setApplicationIds;
        public Set<String> setCIFs;
        public List<Applicant_SFDC2__c> lstApplicantWithValidStates;
        public ApplicantsInfoWrapper(){
            setNames = new Set<String>();
            setCIFs = new Set<String>();
            lstApplicantWithValidStates = new List<Applicant_SFDC2__c>();
        }
    }

    /*
        Wrapper that stores the accounts look up result
    */

    public class LookUpResultWrapper{
        public Map<String,Applicant_SFDC2__c> mapAppcntsWOutAccsByGenID;
        public Map<String,Id> mapsAccsByGenID;
        public Map<String,Applicant_SFDC2__c> mapApplicantsByGenID;
        public Map<String,Applicant_SFDC2__c> mapAppcntsWOutAccsByGenToCreateLead;
        public Map<String,Lead> mapExistingLeadsByGenID;
        public LookUpResultWrapper(){
            mapAppcntsWOutAccsByGenID = new Map<String,Applicant_SFDC2__c>();
            mapsAccsByGenID = new Map<String,Id>();
            mapApplicantsByGenID = new Map<String,Applicant_SFDC2__c>();
            mapAppcntsWOutAccsByGenToCreateLead = new Map<String,Applicant_SFDC2__c>();
            mapExistingLeadsByGenID = new Map<String,Lead>();
        }
    }

    /*
        Wrapper to store the leads look up result
    */

    public class LeadSearchValidationResultWrapper{
        public Map<String,Lead> mapFoundLeadsByCIF;
        public Map<String,Lead> mapFoundLeadsByGenID;
        public Map<String,Lead> mapFoundLeadsByName;
        public LeadSearchValidationResultWrapper(){
            mapFoundLeadsByCIF = new Map<String,Lead>();
            mapFoundLeadsByGenID = new Map<String,Lead>();
            mapFoundLeadsByName = new Map<String,Lead>();
        }
    }

}