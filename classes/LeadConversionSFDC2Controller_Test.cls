/**
 * Apex Test class for LeadConversionController class
 */
@isTest
public class LeadConversionSFDC2Controller_Test {

    @testSetup
    static void setup() {
        Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('C&I SFDC2').getRecordTypeId();

        Lead leadRecord = new Lead(
        	RecordTypeId = recordTypeId,
            LastName = 'My Test Lead',
            Company = 'Test Company',
            Status = 'New',
            LeadSource = 'Advisor'
        );
        insert leadRecord;
    }

    @isTest
    static void should_convert_lead() {
        Lead leadRecord = [
            SELECT Id, Opportunity_NameSFDC2__c, Sub_Branch_SFDC2__c, Loan_Amount__c
            FROM Lead
            LIMIT 1
        ];
        leadRecord.Opportunity_NameSFDC2__c = 'Opportunity Name';
        leadRecord.Sub_Branch_SFDC2__c = 'EQF';
        leadRecord.Loan_Amount__c = 1.0;
        update leadRecord;

        // Execute Test
        Test.startTest();
        	Id resultId = LeadConversionSFDC2Controller.convertLead(leadRecord.Id);
        Test.stopTest();

        // Verify test results
        System.assert(resultId != null);
        Lead convertedLead = LeadConversionSFDC2Controller.getConvertedLead(leadRecord.Id);
        System.assert(convertedLead != null);
    }

    @isTest
    static void should_not_convert_lead() {
        Lead leadRecord = [
            SELECT Id, Opportunity_NameSFDC2__c, Sub_Branch_SFDC2__c, Loan_Amount__c
            FROM Lead
            LIMIT 1
        ];

        // Execute Test
        Id resultId = null;
        Test.startTest();
            try {
                 resultId = LeadConversionSFDC2Controller.convertLead(leadRecord.Id);
            } catch (Exception ex) {}
        Test.stopTest();

        // Verify test results
        System.assert(resultId == null);
    }
}