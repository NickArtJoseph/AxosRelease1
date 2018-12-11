public without sharing class ProxyAccountCampaignCreationController {
  /** Set to 'true' during unit testing */
  public Boolean isTest {get; set;}
  
  /** Consumer Deposits Campaign record type id */
  private static String campaignRecordType;
  
  /** Default campaign owner id */
  private static String campaignOwner;
  
  /** List of report ids used for campaign creation */
  private static List<String> reportIdList;
  
  public CD_Proxy_Account_Campaign_Config__c config {get; set;}
  
  /** Set to true when campaign button clicked */
  public Boolean isSubmitted {get; set;}
  
  /** Map of reports used for Campaign creation where key is report id */
  public List<CampaignReportState> reportStateList {get; set;}
  
  /** Campaign model of default values that will be cloned for campaign creation */
  private Campaign campModel {get; set;}
  
  /** Constructor */
  public ProxyAccountCampaignCreationController() {
  	try {
  		config = CD_Proxy_Account_Campaign_Config__c.getAll().values()[0];
  		if(config.Campaign_Owner_Id__c != null) {
  			campaignOwner = config.Campaign_Owner_Id__c;
  		}
  		campaignRecordType = config.Campaign_Record_Type_Id__c;
  		String reportIdString = config.Report_Id_List__c;
  		reportIdList = reportIdString.split(',');
  	} catch(Exception e) { return; }
  	reportStateList = createReportStateList();
  	campModel = createCampaignModel();
  	isSubmitted = false;
  }
  
  /**
  * Sets up the campaign report state list
  */
  private List<CampaignReportState> createReportStateList() {
  	List<CampaignReportState> returnList = new List<CampaignReportState>();
  	for(Report r : [SELECT Name FROM Report WHERE Id in :reportIdList AND Format = 'Tabular' ORDER BY Name]) {
  		returnList.add(new CampaignReportState(r));
  	}
  	return returnList;
  }
  
  /**
  * Sets up model Campaign record with default values set that will be cloned
  */
  private Campaign createCampaignModel() {
  	Campaign camp = new Campaign();
  	camp.IsActive = true;
  	camp.OwnerId = campaignOwner;
  	camp.RecordTypeId = campaignRecordType;
  	camp.StartDate = Date.today();
  	return camp;
  }
  
  public PageReference createCampaigns() {
  	if(config == null) { return null; }
  	isSubmitted = true;
  	List<Campaign> campaignsToAdd = new List<Campaign>();
  	List<List<CampaignMember>> campaignMembersToAdd = new List<List<CampaignMember>>();
  	for(CampaignReportState crs : reportStateList) {
  		Report r = crs.CampaignReport;
  		
  		//run the report to get the results
        Reports.reportResults results = Reports.ReportManager.runReport(r.Id, true);
        
        //ensure that the first column contains the Contact Id
        String colName = results.getReportMetadata().getDetailColumns().get(0);
        if(colName != 'Account.Person_Contact_Id__c') {
        	//invalid first column
        	crs.IsValidReport = false;
        	crs.Message = 'The report \'' + r.Name + '\' does not have the Person Contact Id as the first column value and cannot be used for Campaign creation.';
            continue;
        }
        
        //process the tabular report results
        Reports.ReportFactWithDetails factWithDetails = (Reports.ReportFactWithDetails) results.getFactMap().get('T!T');
        if(factWithDetails.getRows().size() == 0) {
        	//no report results
        	crs.Message = 'The report \'' + r.Name + '\' did not return any records so a Campaign will not be created for this report.';
        	crs.IsValidReport = false;
        	continue;
        }
        
        //a valid report with results has been encountered so set up the Campaign
        Campaign c = campModel.clone();
  		c.Name = r.Name + ' [' + Datetime.now().format('yyyy-MM-dd') + ']';
  		crs.CampaignName = c.Name;
  		c.Type = 'Email';
        campaignsToAdd.add(c);
        
        //create the Campaign member records
        List<CampaignMember> cmList = new List<CampaignMember>();
        for (Reports.ReportDetailRow row : factWithDetails.getRows()) {
        	String acctContactId = row.getDataCells().get(0).getLabel();
        	CampaignMember cm = new CampaignMember();
        	cm.ContactId = acctContactId;
        	cmList.add(cm);
        }
        campaignMembersToAdd.add(cmList);
  	}
  	
  	//perform any necessary inserts
  	//*** Use state list to determine which are valid reports
  	if(campaignsToAdd.size() > 0)
  	{
  		insert campaignsToAdd;
  		Set<CampaignMember> cmToInsert = new Set<CampaignMember>();
  		//since not all reports will result in campaign creation, we need to properly increment
  		Integer stateCounter = 0;
  		for(Integer i = 0; i < campaignsToAdd.size(); i++) {
  			Id campaignId = campaignsToAdd.get(i).Id;
  			while(!reportStateList.get(stateCounter).IsValidReport) {
  				stateCounter++;
  			}
  			reportStateList.get(stateCounter).Message = 'Completed';
  			reportStateList.get(stateCounter).CampaignId = campaignId;
  			List<CampaignMember> cmList = campaignMembersToAdd.get(i);
  			reportStateList.get(stateCounter).MemberCount = cmList.size();
  			for(CampaignMember cm : cmList) {
  				cm.CampaignId = campaignId;
  				cmToInsert.add(cm);
  			}
  			stateCounter++;
  		}
  		insert new List<CampaignMember>(cmToInsert);
  	}

  	return null;
  }
  
  /** Wrapper class for Reports */
  public class CampaignReportState {
  	public Report CampaignReport {get; set;}
  	public String CampaignName {get; set;}
  	public Boolean IsValidReport {get; set;}
  	public String Message {get; set;}
  	public Id CampaignId {get; set;}
  	public Integer MemberCount {get; set;}
  	
  	public CampaignReportState(Report r) {
  		this.CampaignReport = r;
  		this.IsValidReport = true;
  		this.MemberCount = 0;
  	}
  	
  }
}