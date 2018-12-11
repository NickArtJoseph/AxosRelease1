// Mapping for MeridianLink: Applicant_Answer_SFDC2__c
// Strict Format:
//  TAG_LEVEL1>TAG_LEVEL2{>etc...}>paramter_name=Salesforce_API_Field_Name|Datatype
//
// A * next to a tag name indicates multiple elements (multiple records) are possible
//
// Valid Datatypes:
//  String = Text values
//  Decimal = Numeric values
//  Date = Date values
//  Boolean = Boolean (True/False) values
//
APPLICANTS>*APPLICANT>d3p1:internal_borrower_id=Internal_Id__c|String
APPLICANTS>*APPLICANT>APPLICANT_QUESTIONS>*APPLICANT_QUESTION>APPLICANT_QUESTION_ANSWER>answer_text=Answer_Text__c|String
APPLICANTS>*APPLICANT>APPLICANT_QUESTIONS>*APPLICANT_QUESTION>question_name=Question_Code__c|String