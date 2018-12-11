/**
* @description <p>Handler class for automated creation of WLD Quarterly Certification functionality</p>
* @author Mike Crosby, BofI Federal 
*/
global class WLDQtrCertCreationHandler {
    private static final String instanceURL = URL.getSalesforceBaseUrl().toExternalForm();
    private static final String recipientGroupName = 'WLD_QC_Email_Summary_Recipients';
    private Map<String, Id> certRecordTypeIdMap = new Map<String, Id>();
    
    /** Constructor */
    global WLDQtrCertCreationHandler() {
        certRecordTypeIdMap = getCertificationRecordTypes();
    }
    
    private Map<String, Id> getCertificationRecordTypes() {
        Map<String, Id> returnMap = new Map<String, Id>();
        for(RecordType rt : [SELECT DeveloperName FROM RecordType WHERE SObjectType = 'WLD_Certification__c' AND IsActive=true]) {
            returnMap.put(rt.DeveloperName, rt.Id);
        }
        System.debug('**** ' + returnMap);
        return returnMap;
    }
    
    /** Handles the logic for the WLD Quarterly Certification creation */
    global void run(Date timePeriod) {
        String qtrVal = getQuarter(timePeriod);
        if(qtrVal == null) {
            //not run during a month that precedes a new quarter
            System.debug('**** Run date does not warrant QC creation: ' + String.valueOf(timePeriod));
            return;
        }
        
        //start date is the 15th day of the month that the process runs
        Date startDate = Date.newInstance(timePeriod.year(), timePeriod.month(), 15);
        //Due date is 30 days from the start date
        Date dueDate = startDate.addDays(30);
        String certYear = String.valueOf((timePeriod.month() == 1) ? timePeriod.year() - 1 : timePeriod.year());
        System.debug('**** Processing QC creation for ' + qtrVal + ' ' + certYear);
        //get existing QC certs to ensure we don't duplicate
        Set<Id> existingAcctIdSet = new Set<Id>();
        for(AggregateResult ar : [
                                    SELECT
                                        Account__c, Account__r.Name
                                    FROM WLD_Certification__c
                                    WHERE
                                        QLR_Year__c = :certYear AND
                                        QLR_Quarter__c = :qtrVal AND
                                        RecordTypeId = :certRecordTypeIdMap.get('Quarterly_Certification')
                                    GROUP BY Account__c, Account__r.Name
                                  ]) {
            existingAcctIdSet.add((Id)ar.get('Account__c'));
        }
        System.debug('**** Located ' + existingAcctIdSet.size() + ' Account(s) that already have QCs created for the quarter');
        
        //determine which accounts are eligible for quarterly certification creation
        Set<Id> eligibleAcctIdSet = new Set<Id>();
        List<WLD_Certification__c> certsToInsert = new List<WLD_Certification__c>();
        for(WLD_Certification__c acCert : [
                                         SELECT
                                            Account__c, 
                                            Account__r.Name, 
                                            Account__r.Contact_Email__c, 
                                            Account__r.Contact_Email_2__c
                                         FROM WLD_Certification__c
                                         WHERE
                                             RecordTypeId = :certRecordTypeIdMap.get('Account_Certification') AND
                                             Status__c = '6 - Signature Submitted (Approved)' AND
                                             Account__r.Account_Status__c = 'Active'
                                 ]) {
            Id acctId = acCert.Account__c;
            if(existingAcctIdSet.contains(acctId)) {
                //if the account already has a quarterly certification for this period, continue to the next
                System.debug('**** ' + acctId + ' already has a QC for this period; skipping');
                continue;
            }
            existingAcctIdSet.add(acctId); //in case we encounter this account in the result set
            String accountName = acCert.Account__r.Name;
            String qcFormatName = accountName.left(70) + ' ' + certYear + ' ' + qtrVal;
            System.debug('**** Creating QC for ' + qcFormatName);
            WLD_Certification__c cert = new WLD_Certification__c();
            cert.RecordTypeId = certRecordTypeIdMap.get('Quarterly_Certification');
            cert.Name = qcFormatName;
            cert.Account__c = acctId;
            cert.QLR_Quarter__c = qtrVal;
            cert.QLR_Year__c = certYear;
            cert.Start_Date__c = startDate;
            cert.Due_Date__c = dueDate;
            cert.OwnerId = '005i0000007COy9'; //Jennifer Huckleberry
            cert.Contact_Email__c = acCert.Account__r.Contact_Email__c;
            cert.Contact_Email_2__c = acCert.Account__r.Contact_Email_2__c;
            cert.Status__c = '1 - (AC/ARC/QLR) Creation';
            //all checklist items default to requested
            //currently unable to get default values for picklist fields programmatically so set directly
            //see: https://success.salesforce.com/issues_view?id=a1p300000008XL8AAM 
            cert.Notice_of_Action__c = 'N/A';
            cert.MRA_Exhibit_B_and_All_Schedules__c = 'Requested';
            cert.MRA_Schedule_1_Financial_Covenants__c = 'Requested';
            cert.Unaudited_P_L_for_the_Quarter__c = 'Requested';
            cert.Unaudited_P_L_YTD__c = 'Requested';
            cert.Unaudited_Balance_Sheet_YTD__c = 'Requested';
            cert.Investor_Scorecards__c = 'Requested';
            cert.Hedging_Reports__c = 'Requested';
            cert.Quality_Control_Reports__c = 'Requested';
            certsToInsert.add(cert);
        }
        System.debug('**** ' + certsToInsert.size() + ' QC(s) to insert');
        List<WLD_Certification__c> certsAdded = new List<WLD_Certification__c>();
        List<WLDQtrCertErrorWrapper> certErrors = new List<WLDQtrCertErrorWrapper>();
        if(certsToInsert.size() > 0) {
            //insert new QC records; allow for partial inserts
            Database.SaveResult[] sr = Database.insert(certsToInsert, false);
            
            for(Integer i = 0; i < sr.size(); i++) {
                if(sr.get(i).isSuccess()) {
                    certsToInsert.get(i).id = sr.get(i).getId();
                    certsAdded.add(certsToInsert.get(i));
                } else {
                    WLD_Certification__c errorRec = certsToInsert.get(i);
                    Database.Error[] errors = sr.get(i).getErrors();
                    certErrors.add(new WLDQtrCertErrorWrapper(errorRec, errors.get(0).getMessage()));
                }
            }
        }
        SendQCEmailSummary(qtrVal, certYear, certsAdded, certErrors);
    }
    
    private void SendQCEmailSummary(String qtr, String year, List<WLD_Certification__c> successList, List<WLDQtrCertErrorWrapper> errorList) {
        Boolean recipientError = false;
        Group recipientGroup = [SELECT Id FROM Group WHERE DeveloperName = :recipientGroupName LIMIT 1];
        Set<Id> recipientSet = new Set<Id>();
        try {
            recipientSet = UtilityMethods.GetUserIdsFromGroup(recipientGroup.Id);
        } catch (Exception e) {
            //an error occurred getting the recipients from the group--send to API Service Account [Salesforce Support]
            recipientSet.add('005i0000001wnZb');
            recipientError = true;
        }
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        for(Id userId : recipientSet) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            string body = '';
            mail.setSubject('List of QCs Created ' + year + ' ' + qtr);
            if(successList.size() == 0) {
                body = 'No QCs were created';
            } else {
                body = 'The following QCs have been created for the current quarter:';
                body += '<ul>';
                for(WLD_Certification__c cert : successList) {
                    body += '<li><a href="' + instanceURL + '/' + cert.Id + '">' + cert.Name + '</a></li>';
                }
                body += '</ul>';
            }
            if(errorList.size() > 0) {
                body += '<br/><br/>';
                body += 'QCs for the following Accounts were not created due to the noted error(s):';
                body += '<ul>';
                for(WLDQtrCertErrorWrapper errorWrap : errorList) {
                    body += '<li>' + errorWrap.getAccountLinkHTML() + ': ERROR - ' + errorWrap.ErrorMsg + '</li>';
                }
                body += '</ul>';
            }
            mail.setReplyTo('salesforcesupport@bofi.com');
            mail.setSenderDisplayName('BofI Salesforce Support');
            mail.setTargetObjectId(userId); 
            mail.setSaveAsActivity(false);
            mail.setHtmlBody(body); 
            mailList.add(mail);
        }
        Messaging.sendEmail(mailList);
    }
    
    private class WLDQtrCertErrorWrapper {
        public WLD_Certification__c CertRecord {get; set;}
        public String ErrorMsg {get; set;}
        
        public WLDQtrCertErrorWrapper(WLD_Certification__c cert, String error) {
            CertRecord = cert;
            ErrorMsg = error;
        }
        
        public String getAccountLinkHTML() {
            return '<a href="' + instanceURL + '/' + CertRecord.Account__c + '">' + CertRecord.Name.left(CertRecord.Name.length() - 10) + '</a>';
        }
    }
    
    /** 
    * Determines which quarter the process is running in. The process is running on the 15th of the month past the quarter
    * @param runDate date the process runs
    * @return null if not running for a valid quarter; appropriate quarter value otherwise:
    * <UL><LI>January = QTR4</LI><LI>April = QTR1</LI><LI>July = QTR2</LI><LI>October = QTR3</LI></UL>
    */
    private String getQuarter(Date runDate) {
        if(runDate == null) { return null; }
        String val = null;
        //valid months: 4,7,10,1
        List<Integer> qtrOrder = new List<Integer>{1,2,3,0};
        Integer quarterDateMonth = runDate.month()-1;
        if(Math.mod(quarterDateMonth,3) != 0) {
            return val;
        }
     
        Integer quarter = quarterDateMonth/3;
        List<Schema.PicklistEntry> picklistVals = Schema.SObjectType.WLD_Certification__c.fields.getMap().get('QLR_Quarter__c').getDescribe().getPicklistValues();
        for(Integer i = 0; i < qtrOrder.size(); i++) {
          if(quarter == qtrOrder.get(i)) {
            return picklistVals.get(i).getValue();
          }
        }
        //val = picklistVals.get(quarter).getValue();
        return val;
    }
    
}