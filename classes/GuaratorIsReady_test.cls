@IsTest
public class GuaratorIsReady_test {
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
    static void garatorReady() {
        Boarding_Form__c bf = [Select id from Boarding_Form__c limit 1];

        Guarantor__c g = new Guarantor__c( Boarding_Form__c = bf.Id,
            Name = 'New Guarantor 30/03',
            GTR_1_Contingent__c = 'Yes',
            GTR_1_Class_Code__c = 'A – Personal',
            GTR_1_Mailing_City__c = 'GDL',       
            GTR_1_Mailing_Country__c = 'test',
            GTR_1_Mailing_Postal_Code_Zip__c = '97420',
            GTR_1_Mailing_State__c = 'JA',
            GTR_1_Mailing_Street__c = '150 Jacarandas' , 
            GTR_1_Tax_ID_number__c = '99-7890630',
            GTR_1_Tax_ID_Number_Type__c = 'I - Individual' ,                           
                                          
            
            GTR_1_Class_Code_Source_Page__c = 'test',
            GTR_1_Contingent_Source_Page__c = 'test',
            GTR_1_Mailing_City_Source_Page__c = 'test',       
            GTR_1_Mailing_Country_Source_Page__c = 'test',
            GTR_1_Mailing_State_Source_Page__c = 'test',
            GTR_1_Mailing_Street_Source_Page__c = 'test',
            GTR_1_Name_Source_Page__c = 'test' ,  
            GTR_1_Postal_Code_Zip_Source_Page__c = 'test',
            GTR_1_Tax_ID_Number_Source_Page__c = 'test',
            GTR_1_Tax_ID_Number_Type_Source_Page__c = 'test'  
            
        );
        insert g;
        
        List<Guarantor__c> idG  = new List<Guarantor__c>();
        idG.add(g);
        
        GuaratorIsReady.getGuaratorIds(idG);
       
    }
    
}