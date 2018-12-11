@IsTest
public class BorrowerIsReady_test {
    @testSetup
    static void setup() {
        Map<String, RecordType> mapOpportunityRecordTypes = UtilsSFDC2.getRecordTypesMap('Opportunity', 'DeveloperName');
        Map<String, RecordType> mapAccountRecordTypes = UtilsSFDC2.getRecordTypesMap('Account', 'DeveloperName');
        Map<String, RecordType> mapBFRecordTypes = UtilsSFDC2.getRecordTypesMap('Boarding_Form__c', 'DeveloperName');

        Account acc = new Account(
            RecordTypeId = mapAccountRecordTypes.get('Business_Account_SFDC2').Id,
            Is_Converted__c = true,
            Name = 'TEST ACCOUNT'
        );

        insert acc;

        Opportunity opp = new Opportunity(
            RecordTypeId = mapOpportunityRecordTypes.get('CRESL_SFDC2').Id,
            Name = 'TEST OPP',
            StageName = '1 - New',
            CloseDate = System.today().addDays(10),
            AccountId = acc.Id,
            Loan_Amount__c = 100.55,
            Estimated_Rate_at_Close__c = 5.0,
            C_I_Sub_Stage__c = 'Gathering Information',
            CI_Projected_Initial_Funding__c = 100.55
        );
        insert opp;
        
        
        Boarding_Form__c  bf = new Boarding_Form__c(
       			RecordTypeId = mapBFRecordTypes.get('Post_LOQ_Approval').Id, 
        		Opportunity__c = opp.Id);
        
        insert bf;
        
    }    
    
    @isTest
    static void borrowerReady() {
        Boarding_Form__c bf = [Select id from Boarding_Form__c limit 1];

        Borrower__c b = new Borrower__c( Boarding_Form__c = bf.Id,
            Name = 'NewBorrower 30-03',
            Class_Code__c = 'D – Employee/Direct Loan',
            Mailing_Address_City__c = 'Personal',
            Mailing_Address_Country__c = 'MEX',       
            Mailing_Address_Postal_Code__c = '07222',
            Mailing_Address_State__c = 'JA',
            Mailing_Address_Street__c	 = 'JAJAJA',
            Tax_ID_Number__c = '99-9801234' , 
            Tax_ID_Number_Types__c = 'T - TIN',                     
                                          
            
            Source_Page_TaxID__c = 'test',
            Source_Page_TaxID_Type__c = 'test',
            Source_Page_Street__c = 'test',       
            Source_Page_State__c = 'test',
            Source_Page_Postal_Code__c = 'test',
            Source_Page_Legal_Name__c = 'test',
            Source_Page_Country__c = 'test' ,  
            Source_Page_Class_Code__c = 'test',
            Source_Page_City__c = 'test'
            
        );
        insert b;
		
        List<Borrower__c> idB  = new List<Borrower__c>();
        idB.add(b);
        
        BorrowerIsReady.getBorrowerIds(idB);

    }
    
}