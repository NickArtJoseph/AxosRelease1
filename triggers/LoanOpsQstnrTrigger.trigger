trigger LoanOpsQstnrTrigger on Loan_Ops_Questionnaire__c (before update) {
  new LoanOpsQstnrTriggerHandler().run();
}