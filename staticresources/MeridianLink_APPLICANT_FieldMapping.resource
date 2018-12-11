// Mapping for MeridianLink: Applicant_SFDC2__c
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
//APPLICANTS>*APPLICANT>borrower_id=External_Id__c|String
APPLICANTS>*APPLICANT>d3p1:internal_borrower_id=External_Id__c|String
APPLICANTS>*APPLICANT>allow_direct_mail=Allow_Direct_Mail__c|String
APPLICANTS>*APPLICANT>allow_email_solicit=Allow_Email_Solicit__c|String
APPLICANTS>*APPLICANT>allow_telemarket=Allow_Telemarket__c|String
APPLICANTS>*APPLICANT>bankruptcy_score=Bankruptcy_Score__c|Decimal
APPLICANTS>*APPLICANT>cell_phone=Cell_Phone__c|String
APPLICANTS>*APPLICANT>citizenship=Citizenship__c|String
APPLICANTS>*APPLICANT>credit_score=Credit_Score__c|Decimal
APPLICANTS>*APPLICANT>custom_score=Custom_Score__c|Decimal
APPLICANTS>*APPLICANT>dob=Date_of_Birth__c|Date
APPLICANTS>*APPLICANT>email=Email__c|String
APPLICANTS>*APPLICANT>first_name=First_Name__c|String
APPLICANTS>*APPLICANT>home_phone=Home_Phone__c|String
APPLICANTS>*APPLICANT>is_declined=Is_Declined__c|String
APPLICANTS>*APPLICANT>last_name=Last_Name__c|String
APPLICANTS>*APPLICANT>marital_status=Marital_Status__c|String
APPLICANTS>*APPLICANT>member_number=Member_Number__c|String
APPLICANTS>*APPLICANT>middle_name=Middle_Name__c|String
APPLICANTS>*APPLICANT>mother_maiden_name=Mother_Maiden_Name__c|String
APPLICANTS>*APPLICANT>number_in_household=Number_in_Household__c|Decimal
APPLICANTS>*APPLICANT>preferred_contact_method=Preferred_Contact_Method__c|String
APPLICANTS>*APPLICANT>role_type=Role_Type__c|String
APPLICANTS>*APPLICANT>ssn=SSN__c|String
APPLICANTS>*APPLICANT>work_phone=Work_Phone__c|String
APPLICANTS>*APPLICANT>work_phone_extension=Work_Phone_Extension__c|String
APPLICANTS>*APPLICANT>CURRENT_ADDRESS>LOOSE_ADDRESS>street_address_1=Address_1__c|String
APPLICANTS>*APPLICANT>CURRENT_ADDRESS>LOOSE_ADDRESS>street_address_2=Address_2__c|String
APPLICANTS>*APPLICANT>CURRENT_ADDRESS>LOOSE_ADDRESS>city=City__c|String
APPLICANTS>*APPLICANT>CURRENT_ADDRESS>LOOSE_ADDRESS>county=County__c|String
APPLICANTS>*APPLICANT>CURRENT_ADDRESS>LOOSE_ADDRESS>state=State__c|String
APPLICANTS>*APPLICANT>CURRENT_ADDRESS>LOOSE_ADDRESS>zip=Zip_Plus_4__c|String
APPLICANTS>*APPLICANT>MAILING_ADDRESS>street_address_1=Mailing_Address_1__c|String
APPLICANTS>*APPLICANT>MAILING_ADDRESS>street_address_2=Mailing_Address_2__c|String
APPLICANTS>*APPLICANT>MAILING_ADDRESS>city=Mailing_City__c|String
APPLICANTS>*APPLICANT>MAILING_ADDRESS>state=Mailing_State__c|String
APPLICANTS>*APPLICANT>MAILING_ADDRESS>zip=Mailing_Zip_Plus_4__c|String
APPLICANTS>*APPLICANT>PREVIOUS_ADDRESS>street_address_1=Previous_Address_1__c|String
APPLICANTS>*APPLICANT>PREVIOUS_ADDRESS>street_address_2=Previous_Address_2__c|String
APPLICANTS>*APPLICANT>PREVIOUS_ADDRESS>city=Previous_City__c|String
APPLICANTS>*APPLICANT>PREVIOUS_ADDRESS>county=Previous_County__c|String
APPLICANTS>*APPLICANT>PREVIOUS_ADDRESS>state=Previous_State__c|String
APPLICANTS>*APPLICANT>PREVIOUS_ADDRESS>zip=Previous_Zip__c|String
APPLICANTS>*APPLICANT>ID_CARD>exp_date=Identification_Expiration_Date__c|Date
APPLICANTS>*APPLICANT>ID_CARD>date_issued=Identification_Issue_Date__c|Date
APPLICANTS>*APPLICANT>ID_CARD>state=Identification_Issuing_State__c|String
APPLICANTS>*APPLICANT>ID_CARD>card_number=Identification_Number__c|String
APPLICANTS>*APPLICANT>ID_CARD>card_type=Identification_Type__c|String
APPLICANTS>*APPLICANT>ID_CARD2>exp_date=Identification_2_Expiration_Date__c|Date
APPLICANTS>*APPLICANT>ID_CARD2>date_issued=Identification_2_Issue_Date__c|Date
APPLICANTS>*APPLICANT>ID_CARD2>state=Identification_2_Issuing_State__c|String
APPLICANTS>*APPLICANT>ID_CARD2>card_number=Identification_2_Number__c|String
APPLICANTS>*APPLICANT>ID_CARD2>card_type=Identification_2_Type__c|String
APPLICANTS>*APPLICANT>APPLICANT_QUESTIONS>*APPLICANT_QUESTION{question_name@Relationship Types}>APPLICANT_QUESTION_ANSWER>answer_text=Relationship_Type__c|String
