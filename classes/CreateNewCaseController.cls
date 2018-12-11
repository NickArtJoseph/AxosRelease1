public class CreateNewCaseController {
    private final Case newC;
    public boolean notBottom  {get; set;}
    public boolean notTop  {get; set;}
    public string BaseURL ; 
    
    
    public CreateNewCaseController(ApexPages.StandardController stdController){
        
        this.newC = (Case)stdController.getRecord();
        String accId = ''; 
        String contId = ''; 
        String parent = '';  
        
        
        BaseURL = ApexPages.currentPage().getHeaders().get('Host');
        Set<String> setNoBottom = new Set<String> {'IRA_Levy_Garnishment', 'CD_Renewal'};
        Set<String> setNoTop = new Set<String> {'Customer_Documents_Pending' , 'Email_Case'}; 
        notBottom = true; notTop    = true;        
        accId =  ApexPages.currentPage().getParameters().get('def_account_id');
        contId=   ApexPages.currentPage().getParameters().get('def_contact_id'); 
        parent=   ApexPages.currentPage().getParameters().get('def_parent_id'); 
        System.debug('accId '+accId);
        
        String setRT = ApexPages.currentPage().getParameters().get('rtdevName');
        Id rtID = [Select id from RecordType where DeveloperName =:setRT ].Id;
        newC.RecordTypeId = rtID; 
        if(!String.isBlank(accId)) { newC.AccountId = accId;
            Boolean isPA = [Select IsPersonAccount from Account where id =:accId].IsPersonAccount;            
            if(isPA) { id idCo = [SELECT Id FROM Contact where Account.Id =:accId limit 1].id;            
                    newC.ContactId = idCo;  }
        }
        if(!String.isBlank(contId)) newC.ContactId = contId;
        if(!String.isBlank(parent)) newC.ParentId = parent;
        
        if(setNoBottom.contains(setRT)) notBottom = false;
        if(setNoTop.contains(setRT))    notTop    = false; 
        
        
    }
    
    public PageReference doCancel(){
        
        BaseURL =   'https://' + BaseURL +'/lightning/o/Case/new';
        PageReference pg = new PageReference(BaseURL);
        
        return pg;
        
    }
    
}