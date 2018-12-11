/*
	This is the controller for the leadConvertSFCoreComponent
*/
public with sharing class leadConvertSFCoreComponentController extends ComponentControllerBase {
	
	private final List<String> CONVERTED_STATUSES = new List<String>{'Qualified'};
	
	// prefix for the label of existing accounts
    private final string EXISTING = 'Attach to existing: ';
    
    // checkbox on the component indicating if there will be an email sent to the owner 
    public boolean sendOwnerEmail {get; set;}
    
    // This will hold the Opportunity for the Opportunity name on the component 
    public Opportunity opportunityID {get; set;}
    
    // Checkbox on the component indicating if an Opportunity should be created
    public Boolean doNotCreateOppty {get; set;}
    
    // This will hold the owner of Lead
    public Opportunity ownerID {
        get {
            if (ownerId == null) {
                ownerID = new Opportunity(OwnerId = leadConvert.ownerId);
            }
            return ownerId;
        }
        set;
    }
    
    //THis is set by the <apex:attribute> and is the lead to convert
    public Lead leadConvert {
    	get; 
        set {
        	//the first time this is set, the select list of Accounts will be populated 
            if (accounts == null) {
                system.debug('leadConvert set to ' + value);
                
                leadConvert = value;
                
                //populate the Account dropdown based on the lead
                populateAccounts(); 
                
            }
        }
    }
    
    // the list of accounts in the select list
    public List<SelectOption> accounts {get; set;}
    
    // the selected account in the select list of accounts
    public string selectedAccount {get; set;}
    
    // the selected account in the select list of accounts
    public string selectedAccountRecordType {get; set;}
    
    // the account record type option list
    public List<SelectOption> accountRecordTypes {get; set;}
    
    //Constructor
    public leadConvertSFCoreComponentController() {
        // create a new Opportunity which will hold the Opportuniy name set by the user
        opportunityId = new Opportunity();
        //For initial SF deployment, we are not concerned with creating opps
        doNotCreateOppty = true;
        
        // set the selected Account to NONE by default
        selectedAccount = 'NONE';
        
        // set list of possible account record types
        accountRecordTypes = populateAccountRecordTypes();
    }
    
    // Populate picklist with available account record type options
    private List<SelectOption> populateAccountRecordTypes() {
    	List<SelectOption> returnList = new List<SelectOption>();
    	for(RecordType rt : [SELECT Name FROM RecordType WHERE SobjectType='Account' AND Name LIKE 'Specialty Finance%' AND IsActive=true AND IsPersonType=true ORDER BY Name]) {
    		returnList.add(new SelectOption(rt.Id, rt.Name));
    	}
    	return returnList;
    }
    
    // Find an Account using SOSL based on the given lead name (person accounts)
    private Account [] findCompany (string companyName) {
        
        //perform the SOSL query
        List<List<SObject>> searchList = [
            FIND :companyName 
            IN NAME FIELDS 
            RETURNING 
            Account(
                Id, 
                Name
            )
        ];
        
        List <Account> accountsFound = new List<Account>();
        
        for (List <sobject> sObjs : searchList) {
            
            for (sObject s : sObjs) {
            	
            	//add the account that was found to the list of found accounts
                accountsFound.add((Account) s);
            }   
        }
        
        // return the list of found accounts
        return accountsFound;
    }
    
    //populate the list of Accounts in the dropdown
    private void populateAccounts() {
    	
        if (leadConvert != null) {
                
            string company = leadConvert.Name;
          	
          	// find any accounts that match the SOSL query in the findCompany() method  
            Account [] accountsFound = findCompany(company + '*');
            
            accounts = new List<selectOption>();
            
            if (accountsFound != null && accountsFound.size() > 0) {
            	
            	// if there is at least 1 account found add a NONE option and a Create New Account option
                accounts.add(new SelectOption('NONE', '-None-'));
                
                accounts.add(new SelectOption('NEW', 'Create New Account: ' + company ));
                
                // for each account found, add an option to attach to the existing account
                for (Account a : accountsFound) {
                    
                    accounts.add(new SelectOption(a.Id, EXISTING + a.Name));
                }
                
            }
            
            else {
            	
            	// if no accounts matched then simply add a Create New Account option
                accounts.add(new SelectOption('NEW', 'Create New Account: ' + company ));
                
                system.debug('no account matches on company ' + company);
                
                selectedAccount = 'NEW';
            }
            
            //the default opportunity name will be the lead's company
            opportunityId.Name = company + '-';
        }
        
        else system.debug('leadConvert = null');
            
    }
    
    // when the selected account in the select list of accounts changes this method is called 
    public PageReference accountChanged() {
       
		// if either the NONE option or the Create New Account option is selected, the Opportuniy Name is set to the lead's company
        if (selectedAccount == 'NEW' || selectedAccount == 'NONE') {
            opportunityId.Name = leadConvert.Company  + '-';
            
        }

        else {
			// otherwise find the account's Id and Name that was selected and set the Opportuity name to that Account
            Account [] a = [
                SELECT Id, Name 
                FROM Account WHERE Id = :selectedAccount];
            
            if (a.size() > 0) {
                opportunityId.Name = a[0].Name + '-';
            }
            
        }
        return null;
    }
    
    //this gets called when an existing accout gets looked up via the lookup magnifying glass
    public PageReference accountLookedUp() {
        system.debug('!!! Account looked up --> ' + ownerId.AccountId );
		
		//find the Id and Nmae of the Account that was looked up        
        Account [] a = [
            SELECT Id, Name 
            FROM Account WHERE Id = :ownerId.AccountId];
        
        if (a.size() > 0) {
            
            // add the locked up account to the slect list
            accounts.add(new SelectOption(a[0].Id, EXISTING + a[0].Name));
            
            // set the selected account to the one that was just looked up by default
            selectedAccount = a[0].Id;
            
            // set the Opportunity name to the account's name that was looked up
            opportunityId.Name = a[0].Name + '-';
            
            system.debug('accounts --> ' + accounts);
        }
        
        return null;
    }
    
	// set up the Lead Status pick list
    public List<SelectOption> LeadStatusOption {
        
        get {
        	
        	
            if(LeadStatusOption == null) {
                
                LeadStatusOption = new List<SelectOption>();
                
                //get the lead statuses
                LeadStatus [] ls = [select MasterLabel from LeadStatus where IsConverted=true and MasterLabel in :CONVERTED_STATUSES order by SortOrder];
                
                // if there is more than 1 lead status option, add a NONE option  
                if (ls.size() > 1) {
                    LeadStatusOption.add(new SelectOption('NONE', '-None'));
                }
                
                // add the rest of the lead status options
                for (LeadStatus convertStatus : ls){
                    LeadStatusOption.add(new SelectOption(convertStatus.MasterLabel, convertStatus.MasterLabel));
                } 
                
            }
            
            return LeadStatusOption;
        }
        set;
    }
    
}