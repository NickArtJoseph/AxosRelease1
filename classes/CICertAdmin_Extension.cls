public with sharing class CICertAdmin_Extension {
    /** Current opportunity record */
    public Opportunity opp {get; set;}
    
    /** User's ability to edit */
    public Boolean isEditor {get; set;}
    
    /** Required checklist items for each certification type */
    private Map<String,List<String>> RequiredChecklistItemMap;
    
    /** Enumeration of page mode values: READ, EDIT */
    public enum PageMode {READ, EDIT}
    
    /** The mode of the cert admin section:  expected values of 'read' or 'edit' */
    public PageMode mode {get; set;}

    /** 
    * Returns the current mode value
    * @returns mode name
    */
    public String getModeName() {
        if(mode == null) {
            mode = PageMode.READ;
        }
        return mode.name();
    }

    /**
    * Determines if current user can edit the settings
    * @returns true if user can edit; false if not
    */
    public Boolean getCanEdit(Id profileId) {
        Set<String> editorProfileSet = new Set<String>{'System Administrator',
                                                        'C&I - Credit'};
        Profile p = [SELECT Name FROM Profile WHERE Id = :profileId];
        return editorProfileSet.contains(p.Name);
    }

    /** Constructor */
    public CICertAdmin_Extension(ApexPages.StandardController stdController) {
        this.mode = PageMode.READ;
        this.isEditor = false;
        this.opp = getOpportunityDetails(stdController.getRecord().Id);
        this.isEditor = getCanEdit(UserInfo.getProfileId());
        this.RequiredChecklistItemMap = createChecklistItemMap();
    }
    
    //place holder--will need to define manage functions for checklist items
    public String certTypeName {get; set;}
    public PageReference manage() {
        if(certTypeName == null)
            return null;
        PageReference ref = Page.CICertChecklistAdmin;
        ref.getParameters().put('id',opp.Id);
        ref.getParameters().put('ctype', certTypeName);
        ref.setRedirect(false);
        return ref;
    }
    
    private Opportunity getOpportunityDetails(Id oppId) {
        return [
                SELECT
                    Id,
                    CI_Annual_Certification_Required__c,
                    CI_Quarterly_Certification_Required__c,
                    CI_Monthly_Certification_Required__c
                FROM Opportunity
                WHERE Id = :oppId];
    }
    
    public Opportunity editOpp {get; set;}
    
    public PageReference editCertMgmt() {
        editOpp = opp.clone(true, true);
        this.mode = PageMode.EDIT;
        return null;
    }
    
    public PageReference cancelCertMgmt() {
        editOpp = null;
        this.mode = PageMode.READ;
        return null;
    }
    
    public PageReference saveCertMgmt() {
        this.mode = PageMode.READ;
        update editOpp;
        opp = getOpportunityDetails(editOpp.Id);
        editOpp = null;
        return null;
    }
    
    /**
    * Retrieves list of required checklist items
    */
    private Map<String,List<String>> createChecklistItemMap() {
        Map<String,List<String>> returnMap = new Map<String,List<String>>();
        for(C_I_Checklist_Item_Admin__c citem : [
                SELECT Checklist_Item_Name__c, Certification_Type__c
                FROM C_I_Checklist_Item_Admin__c
                WHERE Opportunity__c = :opp.Id
                ORDER BY Checklist_Item_Name__c]) {
            if(!returnMap.containsKey(citem.Certification_Type__c)) {
                returnMap.put(citem.Certification_Type__c, new List<String>());
            }
            returnMap.get(citem.Certification_Type__c).add(citem.Checklist_Item_Name__c);
        }
        return returnMap;
    }
    
    public List<String> getAnnualChecklistItems() {
        return RequiredChecklistItemMap.get('Annual Certification');
    }
    
    public List<String> getQuarterlyChecklistItems() {
        return RequiredChecklistItemMap.get('Quarterly Certification');
    }
    
    public List<String> getMonthlyChecklistItems() {
        return RequiredChecklistItemMap.get('Monthly Certification');
    }
}