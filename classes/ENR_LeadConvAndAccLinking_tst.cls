/***

    Author: René Ayala Medina
    Description: Test class to validate the "enrollment process" functionality
    
    Version Developer             Date          Description
    0.1     René Ayala Medina RAM 08/30/2018    Class created
    0.2     René Ayala Medina RAM 08/30/2018    Building the class
    1.0     René Ayala Medina RAM 09/06/2018    Documentation and testing

***/

@isTest
private class ENR_LeadConvAndAccLinking_tst {

	/*
		Method that inserts previos data for testing 
	*/
	
	@testSetUp static void initData(){
		Map<String,RecordType> mapAppsRTsByDevName = UtilsSFDC2.getRecordTypesMap('Application_SFDC2__c','DeveloperName'); 
		Map<String,RecordType> mapAppcntsRTsByDevName = UtilsSFDC2.getRecordTypesMap('Applicant_SFDC2__c','DeveloperName');
		Map<String,RecordType> mapAccsRTsByDevName = UtilsSFDC2.getRecordTypesMap('Account','DeveloperName');
		Database.insert(new campaign(Name = 'Incomplete Application'));
		Database.insert(new campaign(Name = 'Abandoned Enrollment Opps'));
		Test.startTest();
			List<Application_SFDC2__c> lstApps = new List<Application_SFDC2__c>{
				new Application_SFDC2__c(
					Name = 'Aplication test 1',
					RecordTypeId = mapAppsRTsByDevName.get('Enrollment').Id
				),
				new Application_SFDC2__c(
					Name = 'Aplication test 2',
					RecordTypeId = mapAppsRTsByDevName.get('Enrollment').Id,
					Application_State__c = 'Documents Requested',
					Decision_Status__c = 'Cancelled'
				),
				new Application_SFDC2__c(
					Name = 'Aplication test 3',
					RecordTypeId = mapAppsRTsByDevName.get('Enrollment').Id,
					Application_State__c = 'Personal Information (Incomplete)',
					Decision_Status__c = 'No Decision'
				),
				new Application_SFDC2__c(
					Name = 'Aplication test 4',
					RecordTypeId = mapAppsRTsByDevName.get('Enrollment').Id,
					Application_State__c = 'Referred From Another Brand',
					Decision_Status__c = 'Approved'
				)
			};
			Database.insert(lstApps);
			List<Applicant_SFDC2__c> lstApplicants = new List<Applicant_SFDC2__c>{
				new Applicant_SFDC2__c(
					Application_Id__c = lstApps.get(0).Id,
					RecordTypeId = mapAppcntsRTsByDevName.get('Enrollment').Id,
					First_Name__c = 'Fernando',
					Last_Name__c = 'Zavala',
					Cell_Phone__c = '3322445533',
					Home_Phone__c = '4433221144',
					Email__c = 'testApplicant1@email.com'
				),
				new Applicant_SFDC2__c(
					Application_Id__c = lstApps.get(0).Id,
					RecordTypeId = mapAppcntsRTsByDevName.get('Enrollment').Id,
					First_Name__c = 'Jesús',
					Last_Name__c = 'Hernández',
					Cell_Phone__c = '1166554433',
					Home_Phone__c = '0099888776',
					Email__c = 'testApplicant2@email.com'
				),
				new Applicant_SFDC2__c(
					Application_Id__c = lstApps.get(1).Id,
					RecordTypeId = mapAppcntsRTsByDevName.get('Enrollment').Id,
					First_Name__c = 'Jamie',
					Last_Name__c = 'Denton',
					Cell_Phone__c = '99887766222',
					Home_Phone__c = '4455112223',
					Email__c = 'testApplicant3@email.com'
				),
				new Applicant_SFDC2__c(
					Application_Id__c = lstApps.get(1).Id,
					RecordTypeId = mapAppcntsRTsByDevName.get('Enrollment').Id,
					First_Name__c = 'Clyo',
					Last_Name__c = 'Avilés',
					Cell_Phone__c = '2132143246',
					Home_Phone__c = '9327432721',
					Email__c = 'testApplicant4@email.com'
				),
				new Applicant_SFDC2__c(
					Application_Id__c = lstApps.get(0).Id,
					RecordTypeId = mapAppcntsRTsByDevName.get('Enrollment').Id,
					First_Name__c = 'Fernando',
					Last_Name__c = 'Zavala'
				),
				new Applicant_SFDC2__c(
					Application_Id__c = lstApps.get(2).Id,
					RecordTypeId = mapAppcntsRTsByDevName.get('Enrollment').Id,
					First_Name__c = 'Roberto',
					Last_Name__c = 'García',
					Cell_Phone__c = '2342354523',
					Home_Phone__c = '2133545324',
					Email__c = 'testApplicant5@email.com'
				)
			}; 
			Database.insert(lstApplicants);
			List<Account> lstPreviousExistingAccounts = new List<Account>{
				new Account(
					FirstName = 'Existing',
					LastName = 'TestAccount1',
					RecordTypeId = mapAccsRTsByDevName.get('Consumer_Person_Account_SFDC2').Id
				),
				new Account(
					FirstName = 'Existing',
					LastName = 'TestAccount2',
					CIF_SFDC2__c = '341234',
					RecordTypeId = mapAccsRTsByDevName.get('Consumer_Person_Account_SFDC2').Id
				),
				new Account(
					FirstName = 'Existing',
					LastName = 'TestAccount3',
					PersonEmail = 'TestAccount3@testemail.com',
					PersonHomePhone = '1122334455',
					PersonMobilePhone = '2211445566',
					RecordTypeId = mapAccsRTsByDevName.get('Consumer_Person_Account_SFDC2').Id
				),
				new Account(
					FirstName = 'Existing',
					LastName = 'TestAccount3',
					PersonEmail = 'TestAccount3@testemail.com',
					PersonHomePhone = '2321342433',
					PersonMobilePhone = '1212134322',
					RecordTypeId = mapAccsRTsByDevName.get('Consumer_Person_Account_SFDC2').Id
				)
			};
			Database.insert(lstPreviousExistingAccounts);
			Application_SFDC2__c appToUpdate = new Application_SFDC2__c(
				Id = lstApps.get(0).Id,
				Application_State__c = 'Product Selection (Incomplete)',
				Decision_Status__c = 'No Decision'
			);
			Database.update(appToUpdate);
		Test.stopTest();
	}

	/*
		Validates that leads are created as expected
	*/

	@isTest static void mustCreateLeads(){
		Map<String,RecordType> mapAppsRTsByDevName = UtilsSFDC2.getRecordTypesMap('Application_SFDC2__c','DeveloperName');
		Map<String,RecordType> mapAppcntsRTsByDevName = UtilsSFDC2.getRecordTypesMap('Applicant_SFDC2__c','DeveloperName'); 
		List<Application_SFDC2__c> lstApps = new List<Application_SFDC2__c>{
			new Application_SFDC2__c(
				Name = 'Aplication test 4',
				RecordTypeId = mapAppsRTsByDevName.get('Enrollment').Id,
				Application_State__c = null
			),
			new Application_SFDC2__c(
				Name = 'Aplication test 5',
				RecordTypeId = mapAppsRTsByDevName.get('Enrollment').Id,
				Application_State__c = null
			)
		};
		Database.insert(lstApps);
		List<Applicant_SFDC2__c> lstApplicants = new List<Applicant_SFDC2__c>{
			new Applicant_SFDC2__c(
				Application_Id__c = lstApps.get(0).Id,
				RecordTypeId = mapAppcntsRTsByDevName.get('Enrollment').Id,
				First_Name__c = 'Guillermo',
				Last_Name__c = 'Miranda',
				Cell_Phone__c = '2133421344',
				Home_Phone__c = '8756621211',
				Email__c = 'testApplicant6@email.com'
			),
			new Applicant_SFDC2__c(
				Application_Id__c = lstApps.get(1).Id,
				RecordTypeId = mapAppcntsRTsByDevName.get('Enrollment').Id,
				First_Name__c = 'Ramiro',
				Last_Name__c = 'Kurz',
				Cell_Phone__c = '6643532572',
				Home_Phone__c = '9864249911',
				Email__c = 'testApplicant7@email.com'
			)
		};
		Test.startTest();
			Database.insert(lstApplicants);
			for(Application_SFDC2__c iterator:lstApps){
				iterator.Application_State__c = 'Product Selection (Incomplete)';
			}
			Database.update(lstApps);
		Test.stopTest();
		Integer intCreatedLeadsCountOf = Database.countQuery('SELECT COUNT() FROM Lead WHERE Applicant_Id__r.Application_Id__r.Name = \'Aplication test 4\' OR Applicant_Id__r.Application_Id__r.Name = \'Aplication test 5\'');
		System.assertEquals(2,intCreatedLeadsCountOf);
	}

	/*
		Validates the lead conversion takes place properly
	*/

	
	@isTest static void mustConvertExistingLeads(){
		Test.startTest();
			Application_SFDC2__c appToUpdate = new Application_SFDC2__c(
				Id = [SELECT Id FROM Application_SFDC2__c WHERE Name =: 'Aplication test 1'].Id,
				Application_State__c = 'Personal Information (Incomplete)',
				Decision_Status__c = 'No Decision'
			);
			Database.update(appToUpdate);
		Test.stopTest();
		Integer intExistingLeads = Database.countQuery('SELECT COUNT() FROM Lead WHERE Applicant_Id__r.Application_Id__r.Name = \'Aplication test 1\'');
		System.debug([SELECT Id, Name FROM Lead WHERE Applicant_Id__r.Application_Id__r.Name =: 'Aplication test 1']);
		System.assertEquals(intExistingLeads,3);
		Integer intCreatedOppsWithProperStage = Database.countQuery('SELECT COUNT() FROM Opportunity WHERE Related_Application__r.Name = \'Aplication test 1\' AND StageName = \'4 - Application in Progress\'');
		System.assertEquals(3,intCreatedOppsWithProperStage);
	}

	/*
		Validates that the applicants are linked properly to their related account.
	*/

	@isTest static void mustLinkAccounts(){
		System.assertEquals([SELECT COUNT() FROM Opportunity WHERE Account.Name =: 'Clyo Avilés'],1);
		System.assertEquals([SELECT COUNT() FROM Opportunity WHERE Account.Name =: 'Jamie Denton'],1);
		Map<String,RecordType> mapAppcntsRTsByDevName = UtilsSFDC2.getRecordTypesMap('Applicant_SFDC2__c','DeveloperName'); 
		Map<String,RecordType> mapAccsRTsByDevName = UtilsSFDC2.getRecordTypesMap('Account','DeveloperName');
		Application_SFDC2__c appToUpdate = new Application_SFDC2__c(
			Id = [SELECT Id FROM Application_SFDC2__c WHERE Name =: 'Aplication test 2'].Id,
			Application_State__c = 'Personal Information (Incomplete)',
			Decision_Status__c = 'No Decision'
		);
		List<Account> lstAccounts = new List<Account>{
			new Account(
				FirstName = 'Jamie',
				LastName = 'Denton',
				Email__c = 'testApplicant3@email.com',
				RecordTypeId = mapAccsRTsByDevName.get('Consumer_Person_Account_SFDC2').Id
			)
		};
		Database.insert(lstAccounts);
		Database.insert(
			new Applicant_SFDC2__c(
				First_Name__c = 'Masiosare',
				Last_Name__c = 'UnExtrañoEnemigo',
				Email__c = 'testApplicant4@email.com',
				RecordTypeId = mapAppcntsRTsByDevName.get('Enrollment').Id,
				Application_Id__c = appToUpdate.Id
			)
		);
		Test.startTest();
			Database.update(appToUpdate);
		Test.stopTest();
		System.assertNotEquals([SELECT Linked_Account__c FROM Applicant_SFDC2__c WHERE Name__c =: 'Jamie Denton'].Linked_Account__c,null);
		System.assertNotEquals([SELECT Linked_Account__c FROM Applicant_SFDC2__c WHERE Name__c =: 'Clyo Avilés'].Linked_Account__c,null);
		System.assertNotEquals([SELECT Linked_Account__r.Name FROM Applicant_SFDC2__c WHERE Name__c =: 'Masiosare UnExtrañoEnemigo' LIMIT 1].Linked_Account__r.Name,'Clyo Avilés');
		System.assertEquals([SELECT COUNT() FROM Opportunity WHERE Account.Name =: 'Clyo Avilés'],1);
		System.assertEquals([SELECT COUNT() FROM Opportunity WHERE Account.Name =: 'Jamie Denton'],1);
	}

	/*
		Validates that when an application changes its state, the related opportunities change their stage as well in a proper way
	*/

	@isTest static void mustChangeOppStage(){
		Integer intCreatedOpportunitiesByStage1 = [SELECT COUNT() FROM Opportunity WHERE StageName =: '0 - Closed - Lost' AND Related_Application__r.Name =: 'Aplication test 2'] ;
		Integer intCreatedOpportunitiesByStage2 = [SELECT COUNT() FROM Opportunity WHERE StageName =: '4 - Application in Progress' AND Related_Application__r.Name =: 'Aplication test 3'] ;
		System.assertEquals(2,intCreatedOpportunitiesByStage1);
		System.assertEquals(1,intCreatedOpportunitiesByStage2);
		List<Application_SFDC2__c> lstAppsToUpdate = [SELECT Id, Application_State__c FROM Application_SFDC2__c WHERE Name IN: new Set<String>{'Aplication test 2','Aplication test 3'}];
		Test.startTest();
			for(Application_SFDC2__c iterator:lstAppsToUpdate){
				iterator.Application_State__c = 'Disclosures (Incomplete)';
				iterator.Decision_Status__c = 'No Decision';
			}
			Database.update(lstAppsToUpdate);
			for(Application_SFDC2__c iterator:lstAppsToUpdate){
				iterator.Application_State__c = 'KBA Still to Be Answered';
				iterator.Decision_Status__c = 'No Decision';
			}
			TriggerLoopExecutionControl_cls.resetStatusExecutionTrigger('ApplicationTrigger');
			Database.update(lstAppsToUpdate);
			for(Application_SFDC2__c iterator:lstAppsToUpdate){
				iterator.Application_State__c = 'Complete';
				iterator.Decision_Status__c = 'Approved';
			}
			TriggerLoopExecutionControl_cls.resetStatusExecutionTrigger('ApplicationTrigger');
			Database.update(lstAppsToUpdate);
		Test.stopTest();
		Integer intOppsWithProperStage = [SELECT COUNT() FROM Opportunity WHERE Related_Application__r.Name IN:new Set<String>{'Aplication test 2','Aplication test 3'} AND StageName =: '7 - Approved Unfunded'];
		System.assertEquals(3,intOppsWithProperStage);
	}
	
	/*
		Validates the matching criteria logic #1
	*/

	@isTest static void mustMatchApplicantsProperlyN1(){
		Map<String,RecordType> mapAppsRTsByDevName = UtilsSFDC2.getRecordTypesMap('Application_SFDC2__c','DeveloperName'); 
		Map<String,RecordType> mapAppcntsRTsByDevName = UtilsSFDC2.getRecordTypesMap('Applicant_SFDC2__c','DeveloperName');
		Application_SFDC2__c appInstance = new Application_SFDC2__c(
			Name = 'Aplication test 6',
			RecordTypeId = mapAppsRTsByDevName.get('Enrollment').Id, 
			Application_id__c = 'Application6',
			Application_State__c = 'Product Selection (Incomplete)',
			Decision_Status__c = 'No Decision'
		);
		Test.startTest();
			Database.upsert(appInstance,Application_SFDC2__c.Application_id__c);
			List<Applicant_SFDC2__c> lstApplcnts = new List<Applicant_SFDC2__c>{
				new Applicant_SFDC2__c(
					First_Name__c = 'Existing',
					Last_Name__c = 'TestAccount1',
				 	Email__c = 'testemail6@email.com',
				 	External_Id__c = 'Appcnt01',
				 	RecordTypeId = mapAppcntsRTsByDevName.get('Enrollment').Id,
				 	Application_Id__r = new Application_SFDC2__c(Application_Id__c = 'Application6')
				),
				new Applicant_SFDC2__c(
					First_Name__c = 'Existing',
					Last_Name__c = 'TestAccount2',
				 	CIF__c = '341234',
				 	External_Id__c = 'Appcnt02',
				 	RecordTypeId = mapAppcntsRTsByDevName.get('Enrollment').Id,
				 	Application_Id__r = new Application_SFDC2__c(Application_Id__c = 'Application6')
				),
				new Applicant_SFDC2__c(
					First_Name__c = 'Existing',
					Last_Name__c = 'TestAccount3',
					Cell_Phone__c = '2133421344',
					Home_Phone__c = '1122334455',
					Email__c = 'TestAccount3@testemail.com',
				 	External_Id__c = 'Appcnt03',
				 	RecordTypeId = mapAppcntsRTsByDevName.get('Enrollment').Id,
				 	Application_Id__r = new Application_SFDC2__c(Application_Id__c = 'Application6')
				),
				new Applicant_SFDC2__c(
					First_Name__c = 'Existing',
					Last_Name__c = 'TestAccount4',
				 	CIF__c = '341234',
				 	External_Id__c = 'Appcnt04',
				 	RecordTypeId = mapAppcntsRTsByDevName.get('Enrollment').Id,
				 	Application_Id__r = new Application_SFDC2__c(Application_Id__c = 'Application6')
				),
				new Applicant_SFDC2__c(
					First_Name__c = 'NoExisting',
					Last_Name__c = 'TestAccount',
				 	External_Id__c = 'Appcnt05',
				 	RecordTypeId = mapAppcntsRTsByDevName.get('Enrollment').Id,
				 	Application_Id__r = new Application_SFDC2__c(Application_Id__c = 'Application6')
				)
			};
			Database.upsert(lstApplcnts,Applicant_SFDC2__c.External_Id__c);
		Test.stopTest();
		Integer intOppsGenerated = [SELECT COUNT() FROM Opportunity WHERE Related_Application__r.Name =: 'Aplication test 6' AND  StageName =: '4 - Application in Progress'];
		Integer intLeadsCreated = [SELECT COUNT() FROM Lead WHERE Name =: 'NoExisting TestAccount' AND Isconverted =: false];
	    System.assertEquals(3,intOppsGenerated);
	    System.assertEquals(1,intLeadsCreated);
	}

	/*
		Validates the matching criteria logic #2
	*/

	@isTest static void mustMatchApplicantsProperlyN2(){
		Map<String,RecordType> mapAppsRTsByDevName = UtilsSFDC2.getRecordTypesMap('Application_SFDC2__c','DeveloperName'); 
		Map<String,RecordType> mapAppcntsRTsByDevName = UtilsSFDC2.getRecordTypesMap('Applicant_SFDC2__c','DeveloperName');
		Application_SFDC2__c appInstance = new Application_SFDC2__c(
			Name = 'Aplication test 7',
			RecordTypeId = mapAppsRTsByDevName.get('Enrollment').Id, 
			Application_id__c = 'Application6',
			Application_State__c = 'Complete',
			Decision_Status__c = 'Declined'
		);
		Test.startTest();
			Database.upsert(appInstance,Application_SFDC2__c.Application_id__c);
			List<Applicant_SFDC2__c> lstApplcnts = new List<Applicant_SFDC2__c>{
				new Applicant_SFDC2__c(
					First_Name__c = 'Existing',
					Last_Name__c = 'TestAccount1',
				 	Email__c = 'testemail6@email.com',
				 	External_Id__c = 'Appcnt01',
				 	RecordTypeId = mapAppcntsRTsByDevName.get('Enrollment').Id,
				 	Application_Id__r = new Application_SFDC2__c(Application_Id__c = 'Application6')
				),
				new Applicant_SFDC2__c(
					First_Name__c = 'Existing',
					Last_Name__c = 'TestAccount2',
				 	CIF__c = '341234',
				 	External_Id__c = 'Appcnt02',
				 	RecordTypeId = mapAppcntsRTsByDevName.get('Enrollment').Id,
				 	Application_Id__r = new Application_SFDC2__c(Application_Id__c = 'Application6')
				),
				new Applicant_SFDC2__c(
					First_Name__c = 'Existing',
					Last_Name__c = 'TestAccount3',
					Cell_Phone__c = '2133421344',
					Home_Phone__c = '1122334455',
					Email__c = 'TestAccount3@testemail.com',
				 	External_Id__c = 'Appcnt03',
				 	RecordTypeId = mapAppcntsRTsByDevName.get('Enrollment').Id,
				 	Application_Id__r = new Application_SFDC2__c(Application_Id__c = 'Application6')
				),
				new Applicant_SFDC2__c(
					First_Name__c = 'Existing',
					Last_Name__c = 'TestAccount4',
				 	External_Id__c = 'Appcnt04',
				 	RecordTypeId = mapAppcntsRTsByDevName.get('Enrollment').Id,
				 	Application_Id__r = new Application_SFDC2__c(Application_Id__c = 'Application6')
				)
			};
			Database.upsert(lstApplcnts,Applicant_SFDC2__c.External_Id__c);
		Test.stopTest();
		Integer intOppsGenerated = [SELECT COUNT() FROM Opportunity WHERE Related_Application__r.Name =: 'Aplication test 7' AND  StageName =: '0 - Closed - Lost'];
		System.assertEquals(4,intOppsGenerated);
	}

	/*
		Helps to conver the contact trigger coverage
	*/

	@isTest static void mustCreateRecords(){
		Database.insert(new Contact(FirstName = 'Test', LastName = 'Contact'));
	}
}