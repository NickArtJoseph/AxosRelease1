/**
* @description <p>Handler class for automated creation of CI Certification functionality</p>
* @author Mike Crosby, BofI Federal 
*/
global class CICertificationCreationHandler {
    private Map<String, Id> certRecordTypeIdMap = new Map<String, Id>();
    
    /** Constructor */
    global CICertificationCreationHandler() {
        certRecordTypeIdMap = getCertificationRecordTypes();
    }
    
    private Map<String, Id> getCertificationRecordTypes() {
        Map<String, Id> returnMap = new Map<String, Id>();
        for(RecordType rt : [SELECT Name FROM RecordType WHERE SObjectType = 'CI_Certification__c' AND IsActive=true]) {
            returnMap.put(rt.Name, rt.Id);
        }
        return returnMap;
    }
    
    /** Handles the logic for the C&I Certification creation */
    global void run(Date timePeriod) {
        //retrieve list of Certifications that exist for the current period to ensure duplications aren't created
        Date startDate = timePeriod.toStartOfMonth();
        Date dueDate = timePeriod.toStartOfMonth().addDays(75);
        String certYear = String.valueOf(startDate.year());
        String certMonth = ((startDate.month() < 10) ? '0' : '') + String.valueOf(startDate.month());
        List<CI_Certification__c> existingCerts = [SELECT
                                                        Opportunity__c,
                                                        Certification_Type__c
                                                    FROM CI_Certification__c
                                                    WHERE
                                                        Year_of_Certification__c = :certYear AND
                                                        Month_of_Certification__c = :certMonth
                                                    ];
        
        //retrieve all required checklist items for C&I opportunities
        Map<Id,Map<String,CertificationWrapper>> oppCertMap = new Map<Id,Map<String,CertificationWrapper>>();
        for(C_I_Checklist_Item_Admin__c citem : [SELECT
                                                    Opportunity__c,
                                                    Certification_Type__c,
                                                    Checklist_Item_Name__c,
                                                    Grace_Period__c,
                                                    Opportunity__r.OwnerId
                                                FROM C_I_Checklist_Item_Admin__c
                                                WHERE
                                                    Opportunity__r.StageName = 'Closed Won' AND
                                                    (
                                                        (Opportunity__r.CI_Annual_Certification_Required__c = true AND 
                                                            Certification_Type__c = 'Annual Certification') OR
                                                        (Opportunity__r.CI_Quarterly_Certification_Required__c = true AND
                                                            Certification_Type__c = 'Quarterly Certification') OR
                                                        (Opportunity__r.CI_Monthly_Certification_Required__c = true AND
                                                            Certification_Type__c = 'Monthly Certification')
                                                    )]) {
            //check to make sure certification doesn't already exist for the current period
            Boolean certExists = false;
            for(CI_Certification__c cert : existingCerts) {
                if(cert.Opportunity__c == citem.Opportunity__c &&
                    cert.Certification_Type__c == citem.Certification_Type__c) {
                    certExists = true;  
                }
            }
            //certification already exists for this period--do not duplicate
            if(certExists)
            {
                continue;
            }
            
            //handle opportunity not already defined
            if(!oppCertMap.containsKey(citem.Opportunity__c)) {
                oppCertMap.put(citem.Opportunity__c, new Map<String, CertificationWrapper>());
            }
            
            //handle certification type not already defined
            if(!oppCertMap.get(citem.Opportunity__c).containsKey(citem.Certification_Type__c)) {
                CertificationWrapper cwrap = new CertificationWrapper();
                cwrap.OpportunityId = citem.Opportunity__c;
                cwrap.CertificationType = citem.Certification_Type__c;
                cwrap.RecordTypeId = certRecordTypeIdMap.get(citem.Certification_Type__c);
                cwrap.StartDate = startDate;
                cwrap.DueDate = dueDate;
                cwrap.CertificationYear = certYear;
                cwrap.CertificationMonth = certMonth;
                cwrap.Owner = citem.Opportunity__r.OwnerId;
                cwrap.ItemList = new List<C_I_Checklist_Item__c>();
                oppCertMap.get(citem.Opportunity__c).put(citem.Certification_Type__c, cwrap);
            }
            
            //add checklist item to be created
            CertificationWrapper cwrap = oppCertMap.get(citem.Opportunity__c).get(citem.Certification_Type__c);
            String certKey = cwrap.getChecklistLinkId();
            CI_Certification__c cert = new CI_Certification__c(ChecklistLinkId__c=certKey);
            C_I_Checklist_Item__c item = new C_I_Checklist_Item__c();
            item.Name = citem.Checklist_Item_Name__c;
            item.Status__c = 'Requested';
            item.Grace_Period__c = citem.Grace_Period__c;
            item.Certification__r = cert;
            oppCertMap.get(citem.Opportunity__c).get(citem.Certification_Type__c).ItemList.add(item);
        }
        
        //once the certs/checklist items are set up, insert the records
        //included logic here to only insert based on time period matching certification type
        //List<Sobject> objList = new List<Sobject>();
        List<CI_Certification__c> insertCertList = new List<CI_Certification__c>();
        List<C_I_Checklist_Item__c> insertCItemList = new List<C_I_Checklist_Item__c>();
        for(Map<String,CertificationWrapper> wrapperMap : oppCertMap.values()) {
            for(CertificationWrapper certWrap : wrapperMap.values()) {
                if(certWrap.CertificationType == 'Monthly Certification' ||
                    (certWrap.CertificationType == 'Quarterly Certification' && 
                        (
                            certWrap.CertificationMonth == '03' ||
                            certWrap.CertificationMonth == '06' ||
                            certWrap.CertificationMonth == '09' ||
                            certWrap.CertificationMonth == '12' 
                        )) ||
                    (certWrap.CertificationType == 'Annual Certification' && certWrap.CertificationMonth == '12')) {
                    //objList.add(certWrap.getCertificationObject());
                    insertCertList.add(certWrap.getCertificationObject());
                    for(C_I_Checklist_Item__c citem : certWrap.ItemList) {
                        //objList.add(citem);
                        insertCItemList.add(citem);
                    }
                }
            }
        }
        
        //if(objList.size() > 0) {
        if(insertCertList.size() > 0) {
            //insert objList;
            insert insertCertList;
            insert insertCItemList;
        }
    }
    
    /** Private wrapper class for Certifications */
    private class CertificationWrapper {
        public Id OpportunityId {get; set;}
        public String CertificationType {get; set;}
        public String RecordTypeId {get; set;}
        public String CertificationYear {get; set;}
        public String CertificationMonth {get; set;}
        public Date DueDate {get; set;}
        public Id Owner {get; set;}
        public Date StartDate {get; set;}
        public List<C_I_Checklist_Item__c> ItemList {get; set;}
        
        /** Constructor */
        public CertificationWrapper() {}
        
        public String getChecklistLinkId() {
            return OpportunityId + '|' + CertificationType + '|' + CertificationYear + '|' + CertificationMonth;
        }
        
        public CI_Certification__c getCertificationObject() {
            CI_Certification__c cert = new CI_Certification__c();
            cert.Opportunity__c = OpportunityId;
            cert.RecordTypeId = RecordTypeId;
            cert.Status__c = 'In Progress';
            cert.Month_of_Certification__c = CertificationMonth;
            cert.Year_of_Certification__c = CertificationYear;
            cert.Start_Date__c = StartDate;
            cert.Due_Date__c = DueDate;
            cert.Certification_Owner__c = Owner;
            cert.ChecklistLinkId__c = getChecklistLinkId();
            return cert;
        }
    }
}