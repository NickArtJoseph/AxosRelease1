// Mapping for MeridianLink: Application_Account_SFDC2__c
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
INTERESTED_ACCOUNTS>*ACCOUNT_TYPE>amount_deposit=Amount_Deposit__c|Decimal
INTERESTED_ACCOUNTS>*ACCOUNT_TYPE>apy=APY__c|Decimal
INTERESTED_ACCOUNTS>*ACCOUNT_TYPE>source_of_funds=Funding_Status__c|String
INTERESTED_ACCOUNTS>*ACCOUNT_TYPE>interest_rate_type=Interest_Rate_Type__c|String
INTERESTED_ACCOUNTS>*ACCOUNT_TYPE>is_rate_override=Is_Rate_Override__c|String
INTERESTED_ACCOUNTS>*ACCOUNT_TYPE>issue_date=Issue_Date__c|Date
INTERESTED_ACCOUNTS>*ACCOUNT_TYPE>account_name=Account_Name__c|String
INTERESTED_ACCOUNTS>*ACCOUNT_TYPE>account_number=Account_Number__c|String
INTERESTED_ACCOUNTS>*ACCOUNT_TYPE>product_code=Product_Code__c|String
INTERESTED_ACCOUNTS>*ACCOUNT_TYPE>rate=Rate__c|String
INTERESTED_ACCOUNTS>*ACCOUNT_TYPE>term=Term__c|Decimal
INTERESTED_ACCOUNTS>*ACCOUNT_TYPE>term_type=Term_Type__c|String
INTERESTED_ACCOUNTS>*ACCOUNT_TYPE>account_type=Type__c|String
INTERESTED_ACCOUNTS>*ACCOUNT_TYPE>d3p1:internal_account_type_id=Type_Id__c|String