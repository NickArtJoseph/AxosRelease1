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
private class NeustarQueueableJob_Test {

    @isTest
    static void testNeustarMPICQueueableJob() {
    	List<Id> sfRTidList = new List<Id>();
    	sfRTidList.addAll(AccountTriggerHandler.neustarSpecFinRTIdSet);
    	Id sfRTid = sfRTidList[0];
    	
    	Account acct = TestDataFactory.createTestPersonAccount();
    	acct.RecordTypeId = sfRTid;
        acct.Research_Status_Person__c = '';
        acct.OwnerId = AccountTriggerHandler.SF_OUTBOUNDOWNERID;
        
        insert acct;
        
        Address__c a1 = new Address__c(Account_Name__c = acct.Id, Address_Line__c = '1 N State St', City__c = 'Chicago', State__c = 'IL', Zip__c = '60602');
		Address__c a2 = new Address__c(Account_Name__c = acct.Id, Address_Line__c = '1 E Madison St', City__c = 'Chicago', State__c = 'IL', Zip__c = '60603');
		Address__c a3 = new Address__c(Account_Name__c = acct.Id, Address_Line__c = '1 Unknown Blvd', City__c = 'Chicago', State__c = 'IL', Zip__c = '60000');
		Address__c[] addrs = new List<Address__c>{a1,a2,a3};
		insert addrs;
		
		Phone_Number__c p1 = new Phone_Number__c(Account_Name__c = acct.Id, Phone_Number__c = '(312) 555-1211', Source__c = 'Other');
		Phone_Number__c p2 = new Phone_Number__c(Account_Name__c = acct.Id, Phone_Number__c = '(312) 555-1212', Source__c = 'Other');
		Phone_Number__c p3 = new Phone_Number__c(Account_Name__c = acct.Id, Phone_Number__c = '(312) 555-1213', Source__c = 'Other');
		Phone_Number__c p4 = new Phone_Number__c(Account_Name__c = acct.Id, Phone_Number__c = '(312) 555-1214', Source__c = 'Other');
		Phone_Number__c p5 = new Phone_Number__c(Account_Name__c = acct.Id, Phone_Number__c = '(773) 555-1211', Source__c = 'Other');
		Phone_Number__c p6 = new Phone_Number__c(Account_Name__c = acct.Id, Phone_Number__c = '(773) 555-1212', Source__c = 'Other');
		Phone_Number__c p7 = new Phone_Number__c(Account_Name__c = acct.Id, Phone_Number__c = '(773) 555-1213', Source__c = 'Other');
		Phone_Number__c p8 = new Phone_Number__c(Account_Name__c = acct.Id, Phone_Number__c = '(773) 555-1214', Source__c = 'Other');
		Phone_Number__c[] phones = new List<Phone_Number__c>{p1,p2,p3,p4,p5,p6,p7,p8};
		insert phones;
		
		//generate sample response so that callouts to Neustar aren't made during test runs
		String qr1 = '<Contact><Names><Name type="C"><First>Test</First><Last>Person</Last></Name></Names><Addresses><Address validation="1" DPVConfirm="D" USPSType="H" RBDI="R" vacancy="N" CMRA="N" prison="N" score="12"><Street>1 N State St</Street><City>Chicago</City><ST>IL</ST><Postal>60602</Postal></Address><Address validation="1" DPVConfirm="D" USPSType="H" RBDI="R" vacancy="N" CMRA="N" prison="N" score="90"><Street>1 E Madison St</Street><City>Chicago</City><ST>IL</ST><Postal>60603</Postal></Address></Addresses><Phones><Phone validation="1" mobile="" tz="0" dst="Y" st="IL" DAConnected="U" BPI="U" active="1" score="65">3125551211</Phone><Phone validation="1" mobile="" tz="0" dst="Y" st="IL" DAConnected="U" BPI="U" active="1" score="64">3125551212</Phone><Phone validation="1" mobile="" tz="0" dst="Y" st="IL" DAConnected="U" BPI="U" active="1" score="63">3125551213</Phone><Phone validation="1" mobile="" tz="0" dst="Y" st="IL" DAConnected="U" BPI="U" active="1" score="60">3125551214</Phone></Phones></Contact>';
		String qr2 = '<Contact><Names><Name type="C"><First>Test</First><Last>Person</Last></Name></Names><Addresses><Address validation="1" DPVConfirm="D" USPSType="H" RBDI="R" vacancy="N" CMRA="N" prison="N" score="0"><Street>1 Unknown Blvd</Street><City>Chicago</City><ST>IL</ST><Postal>60000</Postal></Address></Addresses><Phones><Phone validation="1" mobile="" tz="0" dst="Y" st="IL" DAConnected="U" BPI="U" active="1" score="65">7735551211</Phone><Phone validation="1" mobile="" tz="0" dst="Y" st="IL" DAConnected="U" BPI="U" active="1" score="64">7735551212</Phone><Phone validation="1" mobile="" tz="0" dst="Y" st="IL" DAConnected="U" BPI="U" active="1" score="63">7735551213</Phone><Phone validation="1" mobile="" tz="0" dst="Y" st="IL" DAConnected="U" BPI="U" active="1" score="60">7735551214</Phone></Phones></Contact>';
		List<String> qrList = new List<String>{qr1,qr2};
		
		NeustarQueueableJob job = new NeustarQueueableJob(acct, true, qrList);
		job.execute(null);
		
		acct = [
				SELECT
					Id,
					FirstName,
					LastName,
					Phone,
					PersonMailingStreet,
					PersonMailingCity,
					PersonMailingState,
					PersonMailingPostalCode,
					(
						SELECT
							Neustar_Address_Score__c,
							Address_Line__c
						FROM Address__r
						ORDER BY Neustar_Address_Score__c DESC
						LIMIT 1
					),
					(
						SELECT
							Neustar_MPIC_Phone_Score__c,
							Phone_Number__c
						FROM Phone_Numbers__r
						ORDER BY Neustar_MPIC_Phone_Score__c DESC
						LIMIT 1
					)
				FROM Account
				WHERE Id = :acct.Id
				];
		
		//verify that appropriate fields were updated on Account
		System.assertEquals(acct.Phone_Numbers__r[0].Phone_Number__c, acct.Phone);
		System.assertEquals(acct.Address__r[0].Address_Line__c, acct.PersonMailingStreet);
    }
    
    @isTest
    static void testNeustarPhoneAttrQueueableJob() {
    	List<Id> sfRTidList = new List<Id>();
    	sfRTidList.addAll(AccountTriggerHandler.neustarSpecFinRTIdSet);
    	Id sfRTid = sfRTidList[0];
    	
    	Account acct = TestDataFactory.createTestPersonAccount();
    	acct.RecordTypeId = sfRTid;
        acct.Research_Status_Person__c = '';
        
        insert acct;
        		
		Phone_Number__c phone = new Phone_Number__c(Account_Name__c = acct.Id, Phone_Number__c = '(312) 555-1211', Source__c = 'Other');
		insert phone;
		
		phone = [SELECT Account_Name__c, Phone_Number__c, RecordTypeId FROM Phone_Number__c WHERE Id = :phone.Id];
		
		//generate sample response so that callouts to Neustar aren't made during test runs
		String qr = 'N,C,A1,L,0';
		List<String> qrList = new List<String>{qr};
		
		NeustarQueueableJob job = new NeustarQueueableJob(phone, true, qrList);
		job.execute(null);
		
		phone = [
				SELECT
					Id,
					Neustar_Prepaid_Phone_Attributes__c,
					Neustar_Business_Phone_Indicator_Attr__c,
					Neustar_In_Service_Indicator__c,
					Neustar_Phone_Type_Indicator__c,
					Neustar_Service_Discontinued_Indicator__c,
					Neustar_Verification_Date__c,
            		RecordTypeId
				FROM Phone_Number__c
				WHERE Id = :phone.Id
				];
		
		//verify that appropriate fields were updated on Phone Number
		System.assertEquals('N', phone.Neustar_Prepaid_Phone_Attributes__c);
		System.assertEquals('C', phone.Neustar_Business_Phone_Indicator_Attr__c);
		System.assertEquals('A1', phone.Neustar_In_Service_Indicator__c);
		System.assertEquals('L', phone.Neustar_Phone_Type_Indicator__c);
		System.assertEquals('0', String.valueOf(phone.Neustar_Service_Discontinued_Indicator__c));
		System.assertNotEquals(null, phone.Neustar_Verification_Date__c);
    }
}