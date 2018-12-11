/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class PersonFinancialAcctJuncTriggerHdlr_Test {

	/** tests the insert of Person Financial Account Junction records */
	@isTest
    static void testMapAccountFinancialJunction() {
        Account acct1 = TestDataFactory.createTestPersonAccount();
        acct1.CIF_Person__c = 'TESTAAA111';
        acct1.RecordTypeId = '012i0000001AblM';
        Account acct2 = TestDataFactory.createTestPersonAccount();
        acct2.CIF_Person__c = 'TESTBBB222';
        acct2.RecordTypeId = '012i0000001AblM';
        Account[] accts = new List<Account> {acct1,acct2};
        insert accts;
        
        Financial_Account__c fin = new Financial_Account__c();
        fin.Name = 'Test';
        fin.JHA_RECORD_ID__c = 'TEST0';
        fin.Status__c = 'Active';
        insert fin;
        
        String cifJhaLink1 = 'TESTAAA111|TEST0';
        String cifJhaLink2 = 'TESTBBB222|TEST0';
        
        Person_Financial_Account_Junction__c perFin1 = new Person_Financial_Account_Junction__c();
        Person_Financial_Account_Junction__c perFin2 = new Person_Financial_Account_Junction__c();
        perFin1.CIF_JHA_LINK__c = cifJhaLink1;
        perFin2.CIF_JHA_LINK__c = cifJhaLink2;
        Person_Financial_Account_Junction__c[] perFins = new Person_Financial_Account_Junction__c[]{perFin1,perFin2};
        Test.startTest();
        insert perFins;
        Test.stopTest();
        
        Id perfinToUpdate;
        
        Person_Financial_Account_Junction__c[] perFinResults = [SELECT CIF_JHA_LINK__c, Person_Account__c, Person_Account__r.CIF_Person__c, Financial_Account__c, Financial_Account__r.Person_Account_Count__c FROM Person_Financial_Account_Junction__c WHERE Id in :perFins];
        System.assertEquals(2, perFinResults.size());
        for(Person_Financial_Account_Junction__c perFin : perFinResults) {
        	System.assertNotEquals(null, perFin.Person_Account__c, 'Person Account was not populated');
        	System.assertNotEquals(null, perFin.Financial_Account__c, 'Financial Account was not populated');
        	if(perFin.Person_Account__c == accts[0].Id) {
        		System.assertEquals('TESTAAA111|TEST0', perFin.CIF_JHA_LINK__c);
        		System.assertEquals(2, perFin.Financial_Account__r.Person_Account_Count__c);
        		perfinToUpdate = perfin.Id;
        	} else if (perFin.Person_Account__c == accts[1].Id) {
        		System.assertEquals('TESTBBB222|TEST0', perFin.CIF_JHA_LINK__c);
        	}
        }
        
        Financial_Account__c fin2 = new Financial_Account__c();
        fin2.Name = 'Test2';
        fin2.JHA_RECORD_ID__c = 'TEST1';
        fin2.Status__c = 'Active';
        insert fin2;
        
        Person_Financial_Account_Junction__c pfUpdate = new Person_Financial_Account_Junction__c();
        pfUpdate.Id = perfinToUpdate;
        pfUpdate.Financial_Account__c = fin2.Id;
        update pfUpdate;
        
        perFinResults = [SELECT CIF_JHA_LINK__c, Person_Account__c, Person_Account__r.CIF_Person__c, Financial_Account__c, Financial_Account__r.Person_Account_Count__c FROM Person_Financial_Account_Junction__c WHERE Id in :perFins];
        System.assertEquals(2, perFinResults.size());
        for(Person_Financial_Account_Junction__c perFin : perFinResults) {
       		System.assertEquals(1, perFin.Financial_Account__r.Person_Account_Count__c);
        }
    }
    
    /** tests the insert of Person Financial Account Junction records */
	@isTest
    static void testUpdateFinancialAccountCountsOnUpdate() {
    
    }
}