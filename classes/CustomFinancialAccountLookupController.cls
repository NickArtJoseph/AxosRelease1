public class CustomFinancialAccountLookupController {
    public List<Financial_Account_Link_SFDC2__c> results{get;set;} // search results
    public string searchString{get;set;} // search keyword
    public string relatedAcc{get;set;} // search keyword
    public string sign {get;set;} // search keyword
    public Boolean dateSelect { get; set; }    
    public Integer rec { get; set; }    
    public Integer tot { get; set; }     
    integer totalRecs = 0;
    integer count= 0;
    integer LimitSize= 50;
    public List<Lead> leads=new List<Lead>();
    public String selectedColumn  {
            get  { if(selectedColumn==null)  {  selectedColumn='Account_Number__c'; } return selectedColumn;}     
            set;
    	}
    
    public CustomFinancialAccountLookupController() {
        
        // get the current search string 
        relatedAcc =  getTextBox();
        dateSelect = false;
        searchString = System.currentPageReference().getParameters().get('lksrch'); 
        runSearch();  
 
        
    }
    
    
    
    // performs the keyword search
    public PageReference search() {
        System.debug('selectedColumn '+selectedColumn);
        runSearch();
        return null;
    }
    
    // prepare the query and issue the search command
    private void runSearch() {
        // TODO prepare query string for complex serarches & prevent injections
        results = performSearch(searchString, relatedAcc);               
    } 
    
    // run the search and return the records found. 
    private List<Financial_Account_Link_SFDC2__c> performSearch(string searchString, string relatedAcc) {
        
        String soql = 'select id, Name, Product_Type__c, Current_Balance__c, Account_Number__c, Status__c, CIF__c, Ownership__c, Open_Date__c, Maturity_Date__c from Financial_Account_Link_SFDC2__c';
        String relAcc = ' where ';
        String soqlCount = '';
        if(relatedAcc != '000000000000000' && relatedAcc != null){
            soql = soql +  ' where Account__c =\'' + relatedAcc +'\'';   
            relAcc = ' and ';   
        }
         
  
        if(searchString != '' && searchString != null && !dateSelect)   {
            soql = soql + relAcc + selectedColumn+ ' LIKE \'%'+searchString+'%\' ';
        }   else if(searchString != '' && searchString != null ){
            soql = soql + relAcc + selectedColumn+ ' '+sign +' '+searchString;
        }            
            
            soqlCount = soql;
        soql = soql + ' limit 50 OFFSET '+count;
        System.debug('sign ' + sign); 
        System.debug('soql ' + soql);
        System.debug(soqlCount);
         List<Financial_Account_Link_SFDC2__c> reuslt  = database.query(soqlCount);
        tot=totalRecs = reuslt.size(); 
        System.debug('tot' + tot);
        return  database.query(soql);
        
    }

    public PageReference Firstbtn() {
        count=0;
        runSearch();
        return null;
    }
    public PageReference prvbtn() {
        count=count-limitsize;
        runSearch();
        return null;
    }
    
    public PageReference Nxtbtn() {
        count=count+limitsize;
        runSearch();
        return null;
    }
    public PageReference lstbtn() {
        count= totalrecs - math.mod(totalRecs,LimitSize);
        runSearch();
        return null;
    }
    
    
    public Boolean getNxt() {
        if((count+ LimitSize) > totalRecs)
            return true;
        else
            return false;
        
    }
    public Boolean getPrv() {
        if(count== 0)
            return true;
        else
            return false;
        
        
    }    
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Account_Number__c','Account Number')); 
        options.add(new SelectOption('Product_Type__c','Product Type'));  
        options.add(new SelectOption('String_Balance__c','Current Balance'));
        options.add(new SelectOption('Status__c','Status'));
        options.add(new SelectOption('CIF__c','CIF'));  
        options.add(new SelectOption('Ownership__c','Ownership'));
        options.add(new SelectOption('Open_Date__c','Open Date'));
        options.add(new SelectOption('Maturity_Date__c','Maturity Date'));   
        
        return options;
    }
    public List<SelectOption> getFilters() {
        List<SelectOption> filter = new List<SelectOption>();
        filter.add(new SelectOption('=','=')); 
        filter.add(new SelectOption('>','<')); 
        filter.add(new SelectOption('<','>'));  
        
        return filter;
    }
    public PageReference dateSelected() { 
        if(selectedColumn.equals('Maturity_Date__c') || selectedColumn.equals('Open_Date__c')) {  dateSelect = true;   }else{dateSelect = false;}
        return null;
    }
    // used by the visualforce page to send the link to the right dom element
    public string getFormTag() {
        return System.currentPageReference().getParameters().get('frm');
    }
    
    // used by the visualforce page to send the link to the right dom element for the text box
    public string getTextBox() { 
        return System.currentPageReference().getParameters().get('relatedACc');
    }
    
    public string getLkUpId() { 
        return System.currentPageReference().getParameters().get('lkfield');
    }    
    
    public string getLknm() { 
        return System.currentPageReference().getParameters().get('lknm');
    }     
}