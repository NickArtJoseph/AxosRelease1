public with sharing class CaseRecordTypeSerchController {


  private String soql {get;set;} 
  
  public  String parent {get;set;}
  public  String accId {get;set;}
  public  String url {get;set;}
  public  String contId {get;set;}
  public List<RecordType> RTCases {get;set;}

  public String sortDir {
    get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
    set;
  }


  public String sortField {
    get  { if (sortField == null) {sortField = 'Name'; } return sortField;  }
    set;
  }

  // init the controller and display some sample data when the page loads
  public CaseRecordTypeSerchController(ApexPages.StandardController controller) {
      accId = '';
      contId = '';
      soql    = 'Select Id, Name, DeveloperName, Description  from RecordType where SobjectType = \'Case\' and IsActive = true ';
      accId   = ApexPages.currentPage().getParameters().get('def_account_id');
      parent  = ApexPages.currentPage().getParameters().get('id');
      contId  = ApexPages.currentPage().getParameters().get('def_contact_id'); 
      system.debug('parent-->'+parent);
      if (!String.isEmpty(parent)){
          Case c = [select accountId, contactId from Case where id =: parent];
          system.debug('case-->'+c);
          system.debug('1accId-->'+accId);
          if(accId != '' || accId != null) 
            accId    = c.AccountId;
            contId = c.ContactId;
            system.debug('2accId-->'+accId);
            system.debug('contId-->'+contId);

      }
      
      runQuery();
  }

  // toggles the sorting of query from asc<-->desc
  public void toggleSort() {
    // simply toggle the direction
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
    // run the query again
    runQuery();
  }

  // runs the actual query
  public void runQuery() {




    try {
      RTCases = Database.query(soql + ' order by ' + sortField + ' ' + sortDir );


    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
    }

  }

  // runs the search with parameters passed via Javascript
  public PageReference runSearch() {

    String Name = Test.isRunningTest() ? 'd' :  Apexpages.currentPage().getParameters().get('Name');
    String[] Names = Name.split ('[ ]{1}[\\s]?'); 
    soql = 'Select Id, Name,DeveloperName, Description  from RecordType where SobjectType = \'Case\' and IsActive = true ';
    
    if (!Name.equals(''))
 
        For (string s: Names)  {
                             soql += ' and (Name LIKE \'%'+String.escapeSingleQuotes(s)+'%\' or Description LIKE \'%'+String.escapeSingleQuotes(s)+'%\' )';
        }
 
    runQuery();

    return null;
 }


}