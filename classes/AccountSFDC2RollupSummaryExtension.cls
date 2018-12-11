/**
 * Controller Extension for SFDC2 Financial Account Rollup Summary
 * for Business and Person Accounts. Includes all JH financial accounts
 */
public with sharing class AccountSFDC2RollupSummaryExtension {

    // Current Account
    private Account account;
    
    // Total open deposit accounts
    public Integer numDepositAccounts{get; set;}

    // Total open CD accounts
    public Integer numCDAccounts{get; set;}
    
	// Total open loan accounts
    public Integer numLoanAccounts{get; set;}
    
    // Balance of deposit accounts
    public Decimal balanceDepositAccounts{get; set;}
    
    // Balance of CD accounts
    public Decimal balanceCDAccounts{get; set;}

    // Balance of loan accounts
    public Decimal balanceLoanAccounts{get; set;}
    
    // Number of all-time Opportunities
    public Integer numLTDOpportunities{get; set;}
    
    // Number of Opportunities created during this quarter
    public Integer numQTDOpportunities{get; set;}
    
    // Number of completed tasks of type 'call' all-time
    public Integer numLTDCalls{get; set;}
    
    // Number of completed tasks of type 'call' this quarter
    public Integer numQTDCalls{get; set;}
    
    // Constructor
    public AccountSFDC2RollupSummaryExtension(ApexPages.StandardController ctr) {
        account = [SELECT Id, IsPersonAccount, PersonContactId FROM Account WHERE Id = :((Account)ctr.getRecord()).Id];
     
     	List<Financial_Account_Link_SFDC2__c> links = null;
     	List<Financial_Account_Contact_Link_SFDC2__c> contact_links = null;
     	
    	if (!account.IsPersonAccount) {
	         links = [SELECT Account__r.Id, 
							 Id, 
							 Financial_Account__r.Balance__c,
							 Financial_Account__r.JH_Master_Table__c,
                             Financial_Account__r.RecordTypeId
   					  FROM Financial_Account_Link_SFDC2__c
   					  WHERE Account__r.Id = :account.Id];
    	} else {
	         contact_links = [SELECT Contact__r.Id, 
									 Id, 
									 Financial_Account__r.Balance__c,
									 Financial_Account__r.JH_Master_Table__c,
                                     Financial_Account__r.RecordTypeId
                   			  FROM Financial_Account_Contact_Link_SFDC2__c
                   			  WHERE Contact__r.Id = :account.PersonContactId
                   			  AND (Relationship__c = 'Primary' OR Relationship__c = 'Joint' OR Relationship__c = 'Dealer')];
    	}
    	
        List<Opportunity> opportunities = [SELECT Id,
                                           		  CreatedDate
                                           FROM Opportunity
                                           WHERE AccountId = :account.Id];

        List<Task> tasks = [SELECT ID,
                            	   ActivityDate 
                            FROM Task 
                            WHERE Type = 'Call' 
                            	AND Status = 'Completed' 
                            	AND (WhatId in :opportunities OR WhatId = :account.Id 
                            		OR (WhoId = :account.PersonContactId AND WhoId != null))];

        numDepositAccounts = 0;
        numCDAccounts = 0;
        numLoanAccounts = 0;
		balanceDepositAccounts = 0.0;
		balanceCDAccounts = 0.0;
		balanceLoanAccounts = 0.0;
        numLTDOpportunities = opportunities.size();
        numQTDOpportunities = calculateQuarterlyCount(opportunities, 'CreatedDate');
        numLTDCalls = tasks.size();
        numQTDCalls = calculateQuarterlyCount(tasks, 'ActivityDate');
         
        String query = 'Select id from RecordType where SobjectType = \'Financial_Account_SFDC2__c\'  and Name like \'%Employee%\'';
        List<SObject> results = Database.query(query);
        Set<Id> resultIds = (new Map<Id,SObject>(results)).keySet();
        if (!account.IsPersonAccount) {
	        for (Financial_Account_Link_SFDC2__c link : links) {
	            if (link.Financial_Account__r.JH_Master_Table__c == 'DD' &&  !resultIds.contains(link.Financial_Account__r.RecordTypeId) ) {
					numDepositAccounts++;
	                balanceDepositAccounts += link.Financial_Account__r.Balance__c;
	            }
	            if (link.Financial_Account__r.JH_Master_Table__c == 'CD' &&  !resultIds.contains(link.Financial_Account__r.RecordTypeId)) {
					numCDAccounts++;
	                balanceCDAccounts += link.Financial_Account__r.Balance__c;
	            }
	            if (link.Financial_Account__r.JH_Master_Table__c == 'LN' &&  !resultIds.contains(link.Financial_Account__r.RecordTypeId)) {
					numLoanAccounts++;
	                balanceLoanAccounts += link.Financial_Account__r.Balance__c;
	            }
	        }
        } else {
	        for (Financial_Account_Contact_Link_SFDC2__c link : contact_links) {
	            if (link.Financial_Account__r.JH_Master_Table__c == 'DD' &&  !resultIds.contains(link.Financial_Account__r.RecordTypeId)) {
					numDepositAccounts++;
	                balanceDepositAccounts += link.Financial_Account__r.Balance__c;
	            }
	            if (link.Financial_Account__r.JH_Master_Table__c == 'CD' &&  !resultIds.contains(link.Financial_Account__r.RecordTypeId)) {
					numCDAccounts++;
	                balanceCDAccounts += link.Financial_Account__r.Balance__c;
	            }
	            if (link.Financial_Account__r.JH_Master_Table__c == 'LN' &&  !resultIds.contains(link.Financial_Account__r.RecordTypeId)) {
					numLoanAccounts++;
	                balanceLoanAccounts += link.Financial_Account__r.Balance__c;
	            }
	        }
		}
    }
    
    /**
    * Computes the number of records created during the current quarter
    * @param objArray array of records to analyze
    * @param dateFieldName name of Date field to be used in comparison
    * @return count of records during current quarter
    */
    private Integer calculateQuarterlyCount(Sobject[] objArray, String dateFieldName) {
        Integer counter = 0;
        //determine the start/end dates for the current fiscal quarter
        Period qtr = [SELECT StartDate, EndDate 
                        FROM Period 
                        WHERE Type = 'Quarter' AND 
                        StartDate = THIS_FISCAL_QUARTER];
                        
        //loop through the record array and increment the counter if the date field falls within the quarter date range
        for(Sobject o : objArray) {
            Object value = o.get(dateFieldName);
            Date compareDate;
            if (value instanceof Date){
                compareDate = (Date)value;
            } else if(value instanceof DateTime) {
                compareDate = ((DateTime)value).date();
            } else {
                //if the data type if not a Date, break out
                break;
            }
            
            if(compareDate >= qtr.StartDate && compareDate <= qtr.EndDate) {
                counter++;
            }
        }
        return counter;
    }
    
}