public with sharing class CICertificationDisplayController {
    /** Opportunity record id */
    public String oppId {get; set;}
    
    /** CI Certification record type id */
    public String certRTId {get; set;}
    
    /** CI Certification record type name */
    public String certRecordTypeName {
        get {
            if(certRecordTypeName == null) {
                if(certRTId != null) {
                    RecordType rt = [SELECT Name from RecordType WHERE Id = :certRTId];
                    certRecordTypeName = rt.Name;
                } else {
                    certRecordTypeName = '';
                }
            }
            return certRecordTypeName;
        }
        set;
    }
    
    /** Constructor */
    public CICertificationDisplayController() {
        
    }
    
    /** 
    * Returns formatted block title based on CI Certification record type name
    * @return formatted section block title 
    */
    public String getBlockTitle() {
        return (certRecordTypeName == '') ? '[Undefined Certification Record Type]' : certRecordTypeName + 's';
    }
    
    /**
    * Retrieves CI Certification records for the opportunity based on they're record type
    */
    public List<CI_Certification__c> CertificationList {
        get {
            if(CertificationList == null) {
                CertificationList = [
                                        SELECT Id, Name, Status__c
                                        FROM CI_Certification__c
                                        WHERE Opportunity__c = : oppid AND
                                                RecordTypeId = :certRTId
                                        ORDER BY Name
                                    ];
            }
            return CertificationList;
        }
        set;
    }
}