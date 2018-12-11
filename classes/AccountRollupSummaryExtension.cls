public with sharing class AccountRollupSummaryExtension {
    /** Current Account record */
    private Account acct;
    
    /** Count of opportunities for Account during current quarter */
    public Integer opportunityQTD {get; set;}
    
    /** Total count of opportunities for Account */
    public Integer opportunityLTD {get; set;}
    
    /** Count of completed Tasks of Type "Call" for Account during current quarter */
    public Integer callsQTD {get; set;}
    
    /** Total count of completed Tasks of Type "Call" for Account */
    public Integer callsLTD {get; set;}
    
    /** Total count of open financial accounts */
	public Integer finAcctCount {get; set;}
	
	/** Total sum of open financial account balances */
	public Decimal finAcctBalance {get; set;}
    
    /** Constructor */
    public AccountRollupSummaryExtension(ApexPages.StandardController ctr) {
        acct = (Account)ctr.getRecord();
        acct = [SELECT Id, PersonContactId,
                (SELECT ID,CreatedDate FROM Opportunities),
                (
				    SELECT ID, 
				           Financial_Account_Balance_Formula__c 
				    FROM Person_Financial_Account_Junctions__r 
				    WHERE Financial_Account_Status_Formula__c in ('Active','Restricted','Dormant')
				)
                FROM Account
                WHERE Id = :acct.Id];
        opportunityLTD = acct.Opportunities.size();
        List<Task> tasks = [SELECT ID,ActivityDate FROM Task WHERE Type = 'Call' AND IsClosed = true AND (WhatId in :acct.Opportunities OR WhoId = :acct.PersonContactId OR WhatId = :acct.Id)];
        callsLTD = tasks.size();
        opportunityQTD = calculateQuarterlyCount(acct.Opportunities, 'CreatedDate');
        callsQTD = calculateQuarterlyCount(tasks, 'ActivityDate');
        finAcctCount = acct.Person_Financial_Account_Junctions__r.size();
		finAcctBalance = calculateFinAcctBalance(acct.Person_Financial_Account_Junctions__r);
    }

	/**
	* Sums the balances of financial accounts
	* @param perFin array of Person Financial Account Junction records
	* @return sum of balances for associated financial accounts
	*/
	private Decimal calculateFinAcctBalance(Person_Financial_Account_Junction__c[] perFinArray) {
		Decimal sum = 0;
		for(Person_Financial_Account_Junction__c perFin : perFinArray) {
			sum += perFin.Financial_Account_Balance_Formula__c;
		}
		return sum;
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