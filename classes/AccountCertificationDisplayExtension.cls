public with sharing class AccountCertificationDisplayExtension {
    /** Current account record */
    private Account acct;
    public List<WLD_Certification__c> AccountCertifications {public get; private set;}
    public List<WLD_Certification__c> QuarterlyCertifications {public get; private set;}
    public String redirectURL {public get; private set;}
    public Boolean shouldRedirect {public get; private set;}
    
    /** Constructor */
    public AccountCertificationDisplayExtension(ApexPages.StandardController ctr) {
        shouldRedirect = false;
        acct = (Account)ctr.getRecord();
        if(acct.Id != null) {
            acct = [SELECT Name FROM Account WHERE Id = :acct.Id];
            getCertifications();
        }
    }
    
    /**
    * Retrieves Account Certifications, Recertifications, Quarterly Certifications
    * for the given account and stores in the appropriate lists
    */
    private void getCertifications() {
        AccountCertifications = new List<WLD_Certification__c>();
        QuarterlyCertifications = new List<WLD_Certification__c>();
        
        for(WLD_Certification__c cert : [
                        SELECT 
                            Name, Status__c, Due_Date__c, RecordType.DeveloperName
                        FROM
                            WLD_Certification__c
                        WHERE
                            Account__c = :acct.Id AND
                            RecordType.DeveloperName in (
                                                            'Account_Certification',
                                                            'Account_Recertification',
                                                            'Quarterly_Certification')
                        ORDER BY
                            QLR_Year__c DESC, QLR_Quarter__c DESC
                        ]) {
            if(
                cert.RecordType.DeveloperName == 'Account_Certification' ||
                cert.RecordType.DeveloperName == 'Account_Recertification') {
                AccountCertifications.add(cert);    
            } else if(cert.RecordType.DeveloperName == 'Quarterly_Certification') {
                QuarterlyCertifications.add(cert);
            }
        }
    }
    
    public PageReference newAccountCertification() {
        return newCertification('ac');
    }
    
    public PageReference newQuarterlyCertification() {
        return newCertification('qc');
    }
    
    /**
    * Redirects user to appropriate Certification form: for Account Certifications,
    * if no Certifications exist, 
    * it will return the url for the Account Certification record type, otherwise,
    * it will return the url for the Account Recertification record type; for 
    * Quarterly Certications, it will just launch the QC record type
    * @return null if no account defined; otherwise a formatted url for certification creation
    */
    public PageReference newCertification(String certType) {
        shouldRedirect = true;
        PageReference ref;
        
        if(acct.Id != null) {
            //dynamically determine prefix for Certification object
            Schema.DescribeSObjectResult r = WLD_Certification__c.sObjectType.getDescribe();
            String keyPrefix = r.getKeyPrefix();
            List<RecordType> rtList = [
                                        SELECT
                                            DeveloperName
                                        FROM
                                            RecordType
                                        WHERE
                                            SobjectType = 'WLD_Certification__c'
                                        ];
            
            RecordType certRecordType;
            for(RecordType rt : rtList) {
                if(
                    (certType == 'ac' &&
                        (
                            (AccountCertifications.size() == 0 && rt.DeveloperName == 'Account_Certification') ||
                            (AccountCertifications.size() > 0 && rt.DeveloperName == 'Account_Recertification')
                        )
                    ) ||
                    (certType == 'qc' && 
                        rt.DeveloperName == 'Quarterly_Certification'
                    )
                    
                ) {
                    certRecordType = rt;
                    break;
                }
            }
            if(certRecordType != null) {
                ref = new PageReference('/' + keyPrefix + '/e');
                ref.getParameters().put('retURL', '/' + acct.Id);
                ref.getParameters().put('RecordType',certRecordType.Id);
                ref.getParameters().put('ent','WLD_Certification__c');
                String nameSuffix = '';
                if(certRecordType.DeveloperName == 'Account_Certification') {
                    nameSuffix = ' AC';
                } else if (certRecordType.DeveloperName == 'Account_Recertification') {
                    nameSuffix = ' ARC';
                }
                ref.getParameters().put('Name',acct.Name + nameSuffix);
                ref.getParameters().put('CF00Ni000000FvDjU_lkid', acct.Id);
                ref.getParameters().put('CF00Ni000000FvDjU', acct.Name);
            }
        }
        redirectUrl = ref.getUrl();
        return null;
    }
}