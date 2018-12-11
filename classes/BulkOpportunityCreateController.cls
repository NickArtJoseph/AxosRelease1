/**
* @description <p>Controller class for BulkOpportunityCreate visualforce page<p>
* @author Mike Crosby, BofI Federal
*/
public with sharing class BulkOpportunityCreateController {
    
    public SelectOption[] selectedReportFields { get; set; }
    public SelectOption[] allReportFields { get; set; }
    
    public SelectOption[] selectedOwners {get; set;}
    public SelectOption[] ownerOptions {get; set;}
    
    public Boolean isTest {get; set;}
    
    /** Consumer Deposits Opportunity record type id */
    private static String CD_OPPORTUNITY_RECORDTYPEID = '012i0000001AbiI';
    
    /** Bulk Report Id (custom report filtered on Consumer Deposits Opportunities with Creation Date set to '') */
    private static String CD_BULKREPORT_ID = '00Oi0000006G5rN';

    /** List of report ids that may be used for the bulk creation */
    private static List<String> reportIdList = new List<String> {
        '00Oi0000006G5rO',
        '00Oi0000006G5rP',
        '00Oi0000006GdP8',
        '00Oi0000006FLsV',
        '00Oi0000005pKu5'
    };
        
    /** Opportunity object to store data entered by user that will be replicated for insertion based on report results */
    public Opportunity oppModel { get; set; }
    
    /** Report id to be used for bulk opportunity creation */
    public String selectedReport { get; set; }
    
    /** Count of opportunities successfully created during process */
    public Integer newOpportunityCount {get; set;}
    
    /** Timestamp of bulk creation process, to be used in report URL to display results of bulk opportunity creation*/
    public Datetime bulkCreationDateTime {get; set;}
    
    /** Constructor */
    public BulkOpportunityCreateController() {
        oppModel = new Opportunity(RecordTypeId=BulkOpportunityCreateController.CD_OPPORTUNITY_RECORDTYPEID,OwnerId=Userinfo.getUserId());
        newOpportunityCount = -1;
        isTest = false;
        allReportFields = new List<SelectOption>();
        selectedReportFields = new List<SelectOption>();
        selectedOwners = new List<SelectOption>();
        ownerOptions = new List<SelectOption>();
        for(User u : [SELECT Name FROM User WHERE Profile.Name IN ('Consumer Deposits Team','Consumer Wholesale Team','Consumer Deposits Management') AND IsActive = true ORDER BY FirstName, LastName]) {
            ownerOptions.add(new SelectOption(u.Id, u.Name));
        }
    }
    
    /**
    * Creates a list of names of tabular reports that the user can select
    * @return list of SelectOption values where Label=Name of report and Value=Id of report
    */
    public List<SelectOption> getReportOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','-- Select One --'));
        System.debug('**** ' + reportIdList);
        //retrieve tabular reports
        for(Report r : [Select Id, Name From Report Where Id in :reportIdList And Format = 'Tabular' Order By Name]) {
            options.add(new SelectOption(r.Id, r.Name));
        }
        return options;
    }
    
    /**
    * Allows for rerendering of visualforce page (AJAX) when action is submitted
    * @return null since the user should not be redirected to a different page
    */
    public PageReference rerender() {
        populateReportFields(selectedReport);
        return null;
    }
    
    /**
     * Populates the allReportFields variable based on the selected report
     * @param reportId Id of the selected report
     */
    private void populateReportFields(String reportId) {
        allReportFields = new List<SelectOption>();
        selectedReportFields = new List<SelectOption>();
        if(reportId == null || reportId == '') {
            return;
        }
        
        //run the selected report to get the results
        Reports.reportResults results = Reports.ReportManager.runReport(selectedReport, false);
        for (String colName : results.getReportMetadata().getDetailColumns()) {
            //ignore the following columns
            //  Account.Id
            //  Person_Financial_Account_Junction__c.Financial_Account__c.Id
            if(colName != 'Account.Id' && colName != 'Person_Financial_Account_Junction__c.Financial_Account__c.Id') {
                try {
                    String label = getReportColumnLabel(colName);
                    allReportFields.add(new SelectOption(colName, label));
                } catch (Exception e) {
                    oppModel.addError('An error occurred while attempting to decode the report column \'' + colName + '\'. Please contact salesforcesupport@bofi.com and provide a screenshot of this page.');
                }
            }
        }
    } 
    
    /**
     * Retrieves the user friendly label associated with a report column [assumes report is based on Customers with Financial Accounts report type]
     * @param colName The column name in API form
     * @return formatted column label
     */
    private String getReportColumnLabel(String colName) {
        String label = '';
        //parse column API name
        String[] parsedColumn = colName.split('\\.');
        
        //determine label for supplied column name
        if(parsedColumn.size() == 1) {
            //base object is Person Account (Account)
            label = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get(colName).getDescribe().getLabel();
        } else {
            Schema.SobjectType objectType = Schema.getGlobalDescribe().get(parsedColumn[parsedColumn.size() - 2]);
            //last 2 elements determine (1) object and (2) field
            label = '[' + objectType.getDescribe().getLabel() + '] ';
            label += objectType.getDescribe().fields.getMap().get(parsedColumn[parsedColumn.size() - 1]).getDescribe().getLabel();
        }
        return label;
    }
    
    /**
    * Validates form input and creates opportunity records
    * @return null since the user should not be redirected to a different page
    */
    public PageReference createOpportunities() {
        //perform validation
        if(!isValidSubmit()) {
            return null;
        }
        
        //MCC 2015-03-20 : Add Person Account and Financial Account ID sets to ensure that only one opportunity is created
        //per person account and financial account
        Set<String> personAccountIdSet = new Set<String>();
        Set<String> financialAccountIdSet = new Set<String>();
        
        //run the selected report to get the results
        Reports.reportResults results = Reports.ReportManager.runReport(selectedReport, true);
        
        //ensure that report contains the minimum columns needed to create opportunities
        //Account.Id
        //Person_Financial_Account_Junction__c.Financial_Account__c.Id
        //Person_Financial_Account_Junction__c.Financial_Account__c.Brand__c
        Integer acctIdIndex = -1;
        Integer finAcctIdIndex = -1;
        Integer brandIndex = -1;
        //set up map of columns that should be populated into Description field of Opportunity
        Map<Integer,SelectOption> descFieldMap = new Map<Integer, SelectOption>();
        for (Integer i = 0; i < results.getReportMetadata().getDetailColumns().size(); i++) {
           String colName = results.getReportMetadata().getDetailColumns().get(i);
           if(colName == 'Account.Id') {
            acctIdIndex = i;
           } else if (colName == 'Person_Financial_Account_Junction__c.Financial_Account__c.Id') {
            finAcctIdIndex = i;
           } else if (colName == 'Person_Financial_Account_Junction__c.Financial_Account__c.Brand__c') {
            brandIndex = i;
           }
            for(SelectOption selectedField : selectedReportFields) {
                if(selectedField.getValue() == colName) {
                    //populates the column index as key, and column name (SelectOption) as value
                    descFieldMap.put(i, selectedField);
                }
            }
        }
        if(acctIdIndex < 0 || finAcctIdIndex < 0 || brandIndex < 0) {
            oppModel.addError('The report you selected must have Account ID, Financial Account ID, and Financial Account Brand columns available');
            return null;
        }

        //set date/time of batch creation
        bulkCreationDateTime = Datetime.now();
        oppModel.Consumer_Deposits_Bulk_Creation_Date__c = bulkCreationDateTime;

        //process the tabular report results
        Reports.ReportFactWithDetails factWithDetails = (Reports.ReportFactWithDetails) results.getFactMap().get('T!T');

        List<Opportunity> toInsert = new List<Opportunity>();
        for (Reports.ReportDetailRow row : factWithDetails.getRows()) {
            Opportunity opp = oppModel.clone();
            String acctId = row.getDataCells().get(acctIdIndex).getLabel();
            String finAcctId = row.getDataCells().get(finAcctIdIndex).getLabel();
            
            //MCC 2015-03-20 : Ensure that duplicate opportunities are not created for person account or financial account
            if(!personAccountIdSet.contains(acctId) && !financialAccountIdSet.contains(finAcctId))
            {
                String brand = row.getDataCells().get(brandIndex).getLabel();
                opp.AccountId = acctId;
                opp.Financial_Account__c = finAcctId;
                opp.Name = opp.Name + ' ' + brand;
                //populate Description field with field label/value pairs based on selectedReportFields
                opp.Description = '';
                for(Integer colIndex : descFieldMap.keySet()) {
                    String fieldLabel = descFieldMap.get(colIndex).getLabel();
                    String fieldValue = row.getDataCells().get(colIndex).getLabel();
                    if(opp.Description != '') {
                        opp.Description += '\n';
                    }
                    opp.Description += fieldLabel + ': ' + fieldValue;
                }
                toInsert.add(opp);
                //when testing, limit to 10 opportunity inserts
                if(isTest && toInsert.size() == 10) {
                    break;
                }
                
                //MCC 2015-03-20 : track person account/financial account ids
                personAccountIdSet.add(acctId);
                financialAccountIdSet.add(finAcctId);
            }
        }

        List<String> ownerList = new List<String>();
        for(SelectOption so : selectedOwners) {
            ownerList.add(so.getValue());
        }
        toInsert = evenlyDivideOwnership(toInsert, ownerList);

        try {
            insert toInsert;
            newOpportunityCount = toInsert.size();
        } catch (Exception e) {
            oppModel.addError('An unexpected error occurred during the opportunity creation process: ' + e);
        }

        return null;
    }
    
    /**
    * Performs necessary input validation prior to submitting opportunities for insert
    * @return false is input validation fails; otherwise returns true 
    */
    private Boolean isValidSubmit() {
        Boolean hasError = false;
        if(oppModel.Service_Call_Attempts__c == null && oppModel.Sales_Call_Attempts__c == null) {
            oppModel.addError('Please select either a Service Call Attempts or Sales Call Attempts value.');
            hasError = true;
        } else if (oppModel.Service_Call_Attempts__c != null && oppModel.Sales_Call_Attempts__c != null) {
            oppModel.addError('Please select either a Sales Call Attempts value or a Service Call Attempts value (not both).');
            hasError = true;
        }
        if(selectedOwners.size() == 0) {
            oppModel.addError('Please select at least one owner.');
            hasError = true;
        }
        if(selectedReport == null || selectedReport == '') {
            oppModel.addError('Please select a report.');
            hasError = true;
        }       
        //not valid if any page errors are reported
        return (!hasError);
    }
    
    /**
    * Uses the supplied owner list to evenly assign opportunities among members of the list via round-robin
    * @param oppList List of opportunities to assign ownership
    * @param ownerList List of users who will be owners
    * @return updated list of opportunities with ownership assignments
    */
    private List<Opportunity> evenlyDivideOwnership(List<Opportunity> oppList, List<String> ownerList) {
        Integer ownerIndex = 0;
        
        for(Opportunity o : oppList) {
            if(ownerIndex == ownerList.size()) {
                ownerIndex = 0;
            }
            o.OwnerId = ownerList.get(ownerIndex++);
        }
        return oppList;
    }
    
    /**
    * Returns the report id to be used in the URL presented to the user after a successful bulk creation
    * @return report id
    */
    public String getBulkReportId() {
        return BulkOpportunityCreateController.CD_BULKREPORT_ID;
    }
}