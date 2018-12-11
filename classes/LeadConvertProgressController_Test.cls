@isTest
private class LeadConvertProgressController_Test {
	@isTest
    static void testController() {
    	Id rtId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Consumer Deposits SFDC2').getRecordTypeId();
    	
        Lead lead1 = new Lead(FirstName='Test',
  								LastName='Contact',
  								Email='testcontact@test.com',
  								Company='TestNew',
  								RecordTypeId = rtId,
  								SFDC2__c = true,
  								Status = '1 - New',
  								Opportunity_NameSFDC2__c='Test');
		insert lead1;
		
		Test.setCurrentPage(Page.LeadConvertProgress);
        ApexPages.currentPage().getParameters().put('id',lead1.Id);
        LeadConvertProgressController ctr = new LeadConvertProgressController();
        System.assertEquals(false, ctr.convertedLead.IsConverted);
        System.assertEquals(false, ctr.validStatus);
        
        lead1.Status = 'Contacted/Converted';
        Test.startTest();
        update lead1;
        Test.stopTest();
        
        ctr.pollResults();
        System.assertEquals(true, ctr.convertedLead.IsConverted);
        System.assertEquals(true, ctr.validStatus);
    }
}