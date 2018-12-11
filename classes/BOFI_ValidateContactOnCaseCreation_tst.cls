/*

Description: Test class that validates the scenarios when a case is created to verify whether the APEX code validation is working properly.
Cases will be able to be created or updated if selected Account and Contact are related between them.

Author: René Ayala Medina

Version   Author  Description         Date
1.0       RAM     Test class created  april/06/2018
1.1       RAM     Class documentation april/06/2018
*/

@isTest
private class BOFI_ValidateContactOnCaseCreation_tst {

	/*
		Inserts test data
	*/

	@testSetup static void initData(){
		Database.insert(new List<Account>{
			new Account(
				Name = 'Test Account Name 1'
			),
			new Account(
				Name = 'Test Account Name 2'
			)
		});
	}

	/*
		Validate escenarios where DMLs over Case object are successful
	*/
	
	@isTest static void shouldAllowCaseCreationOrUpdate() {
		List<Account> lstAccs = [SELECT Id, Name FROM Account];
		List<Contact> lstCntcs = new List<Contact>{
			new Contact(
				FirstName = 'Contact',
				LastName = '1',
				AccountId = lstAccs.get(0).Id
			),
			new Contact(
				FirstName = 'Contact',
				LastName = '2',
				AccountId = lstAccs.get(1).Id
			)
		};
		Database.insert(lstCntcs);
		AccountContactRelation aCRInstance = new AccountContactRelation(
			AccountId = lstAccs.get(0).Id,
			ContactId = lstCntcs.get(1).Id
		);
		Database.insert(aCRInstance);
		Case caseInstance = new Case(
			Subject = 'Test Case',
			AccountId = lstAccs.get(0).Id,
			ContactId = lstCntcs.get(1).Id
		);
		Database.SaveResult sr = Database.insert(caseInstance,false);
		//Since the contact is related by account contact relation, DML operation must be allowed
		System.assert(sr.isSuccess());
		Database.delete(aCRInstance);
		lstCntcs.get(1).AccountId = lstAccs.get(0).Id;
		Database.update(lstCntcs.get(1));
		caseInstance.ContactId = lstCntcs.get(1).Id;
		sr = Database.update(caseInstance,false);
		//Since the contact is related to the same account that the one refered on the case, DML operation must be allowed
		System.assert(sr.isSuccess());
	}

	/*
		Validates the escenario where DML's over Case object are not successful
	*/
	
	@isTest static void shouldNotAllowCaseCreation() {
		List<Account> lstAccs = [SELECT Id, Name FROM Account];
		List<Contact> lstCntcs = new List<Contact>{
			new Contact(
				FirstName = 'Contact',
				LastName = '1',
				AccountId = lstAccs.get(0).Id
			),
			new Contact(
				FirstName = 'Contact',
				LastName = '2',
				AccountId = lstAccs.get(1).Id
			)
		};
		Database.insert(lstCntcs);
		Case caseInstance = new Case(
			Subject = 'Test Case',
			AccountId = lstAccs.get(0).Id,
			ContactId = lstCntcs.get(1).Id
		);
		Database.SaveResult sr = Database.insert(caseInstance,false);
		//Since is not there relation between the chosen account and contact, DML operation must not be allowed.
		System.assert(!sr.isSuccess());
		caseInstance.ContactId = lstCntcs.get(0).Id;
		Database.insert(caseInstance);
		caseInstance.ContactId = lstCntcs.get(1).Id;
		sr = Database.update(caseInstance,false);
		//Since is not there relation between the chosen account and contact, DML operation must not be allowed.
		System.assert(!sr.isSuccess());
	}
	
}