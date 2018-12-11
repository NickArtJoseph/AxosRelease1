public class SpecialtyFinanceSurveyExtension {
  private final Survey__c survey;
  private final String accountName;
  private final ApexPages.StandardController ctr;
  public Boolean isSuccess { get; set;}
  
  public SpecialtyFinanceSurveyExtension(ApexPages.StandardController controller) {
  	isSuccess = false;
  	ctr = controller;
  	survey = (Survey__c)ctr.getRecord();
  	String acctId = (String)ApexPages.currentPage().getParameters().get('Account__c');
  	survey.Account__c = acctId;
  	accountName = [SELECT Name FROM Account WHERE Id = :acctId].Name;
  }
  
  public String getAccountName() {
  	return accountName;
  }
  
  public PageReference save() {
  	isSuccess = false;
  	try {
  		ctr.save();
  	} catch(Exception e) {
  		ApexPages.addMessages(e);
  	}
  	
  	if(ApexPages.hasMessages()) {
  		return null;
  	}
  	
  	isSuccess = true;
  	return null;
  }
}