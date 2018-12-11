/***

    Author: René Ayala Medina
    Description: APEX test class to validate the scenario about summarizing the brands of the related financial accounts and set that summary to the numeric fields in "Account" object. 
    
    Version Developer             Date          Description
    0.1     René Ayala Medina RAM 07/03/2018    Class created
    0.2     René Ayala Medina RAM 07/03/2018    Building the class
    1.0     René Ayala Medina RAM 07/05/2018    Documentation and testing

***/

@isTest
private class UDB_UpdateBrandsCounter_tst {

	/*
		Method to create bulk test accounts
	*/

	public static List<Account> getBulkAccs(){
		List<Account> lstAccsToInsert = new List<Account>();
		for(Integer i=0; i<10;i++){
			lstAccsToInsert.add(new Account(Name = 'Test account '+i));
		}
		return lstAccsToInsert;
	}

	/*
		Method to create bulk junctionRecords
	*/

	public static List<Financial_Account_Link_SFDC2__c> getBulkJunctionRecords(List<Account> lstAccsToInsert, List<Financial_Account_SFDC2__c> fAccsToInsert, Integer intMode){
		List<Financial_Account_Link_SFDC2__c> lstJunctionRecordsToInsert = new List<Financial_Account_Link_SFDC2__c>();
		Integer intIterationCounter = 0;
		for(Account iterator:lstAccsToInsert){
			lstJunctionRecordsToInsert.addAll(
				new List<Financial_Account_Link_SFDC2__c>{
					new Financial_Account_Link_SFDC2__c(
						Account__c = iterator.Id,
						Financial_Account__c = fAccsToInsert.get(0).Id,
						CIF_JHA_LINK__c = 'TestExt'+(intIterationCounter++)
					),
					new Financial_Account_Link_SFDC2__c(
						Account__c = iterator.Id,
						Financial_Account__c = fAccsToInsert.get(1).Id,
						CIF_JHA_LINK__c = 'TestExt'+(intIterationCounter++)
					),
					new Financial_Account_Link_SFDC2__c(
						Account__c = iterator.Id,
						Financial_Account__c = fAccsToInsert.get(2).Id,
						CIF_JHA_LINK__c = 'TestExt'+(intIterationCounter++)
					),
					new Financial_Account_Link_SFDC2__c(
						Account__c = iterator.Id,
						Financial_Account__c = fAccsToInsert.get(3).Id,
						CIF_JHA_LINK__c = 'TestExt'+(intIterationCounter++)
					),
					new Financial_Account_Link_SFDC2__c(
						Account__c = iterator.Id,
						Financial_Account__c = fAccsToInsert.get(4).Id,
						CIF_JHA_LINK__c = 'TestExt'+(intIterationCounter++)
					),
					new Financial_Account_Link_SFDC2__c(
						Account__c = iterator.Id,
						Financial_Account__c = fAccsToInsert.get(5).Id,
						CIF_JHA_LINK__c = 'TestExt'+(intIterationCounter++)
					),
					new Financial_Account_Link_SFDC2__c(
						Account__c = iterator.Id,
						Financial_Account__c = fAccsToInsert.get(6).Id,
						CIF_JHA_LINK__c = 'TestExt'+(intIterationCounter++)
					)
				}
			);
		}
		//The records are inserted if it is specified
		if(intMode == 1){
			Database.insert(lstJunctionRecordsToInsert);
		}
		return lstJunctionRecordsToInsert;
	}


	/*
		Method to create test accounts
	*/

	public static List<Account> getAccs(){
		List<Account> lstAccsToInsert = new List<Account>{
			new Account(
				Name = 'Test account 1'
			),
			new Account(
				Name = 'Test account 2'
			),
			new Account(
				Name = 'Test account 3'
			)
		};
		return lstAccsToInsert;
	}

	/*
		Method to create test financial accounts
	*/

	public static List<Financial_Account_SFDC2__c> getFinancialAccs(){
		List<Financial_Account_SFDC2__c> fAccsToInsert = new List<Financial_Account_SFDC2__c>{
			new Financial_Account_SFDC2__c(
				Name = 'Test Financial Account 1',
				Brand__c = 'Bank X'
			),
			new Financial_Account_SFDC2__c(
				Name = 'Test Financial Account 2',
				Brand__c = 'BofI Federal Bank'
			),
			new Financial_Account_SFDC2__c(
				Name = 'Test Financial Account 3',
				Brand__c = 'BofI Advisor'
			),
			new Financial_Account_SFDC2__c(
				Name = 'Test Financial Account 4',
				Brand__c = 'Bank of Internet'
			),
			new Financial_Account_SFDC2__c(
				Name = 'Test Financial Account 5',
				Brand__c = 'UFB Direct'
			),
			new Financial_Account_SFDC2__c(
				Name = 'Test Financial Account 6',
				Brand__c = 'Virtus Bank'
			),
			new Financial_Account_SFDC2__c(
				Name = 'Test Financial Account 7',
				Brand__c = 'NetBank'
			)
		};
		return fAccsToInsert;
	}

	/*
		Method to create the junction object records
	*/

	public static List<Financial_Account_Link_SFDC2__c> getJunctionRecords(List<Account> lstAccsToInsert, List<Financial_Account_SFDC2__c> fAccsToInsert, Integer intMode){
		List<Financial_Account_Link_SFDC2__c> lstJunctionRecordsToInsert = new List<Financial_Account_Link_SFDC2__c>{
			new Financial_Account_Link_SFDC2__c(
				Account__c = lstAccsToInsert.get(0).Id,
				Financial_Account__c = fAccsToInsert.get(0).Id,
				CIF_JHA_LINK__c = 'TestExt1'
			),
			new Financial_Account_Link_SFDC2__c(
				Account__c = lstAccsToInsert.get(0).Id,
				Financial_Account__c = fAccsToInsert.get(1).Id,
				CIF_JHA_LINK__c = 'TestExt2'
			),
			new Financial_Account_Link_SFDC2__c(
				Account__c = lstAccsToInsert.get(1).Id,
				Financial_Account__c = fAccsToInsert.get(2).Id,
				CIF_JHA_LINK__c = 'TestExt3'
			),
			new Financial_Account_Link_SFDC2__c(
				Account__c = lstAccsToInsert.get(1).Id,
				Financial_Account__c = fAccsToInsert.get(3).Id,
				CIF_JHA_LINK__c = 'TestExt4'
			),
			new Financial_Account_Link_SFDC2__c(
				Account__c = lstAccsToInsert.get(2).Id,
				Financial_Account__c = fAccsToInsert.get(4).Id,
				CIF_JHA_LINK__c = 'TestExt5'
			),
			new Financial_Account_Link_SFDC2__c(
				Account__c = lstAccsToInsert.get(2).Id,
				Financial_Account__c = fAccsToInsert.get(5).Id,
				CIF_JHA_LINK__c = 'TestExt6'
			),
			new Financial_Account_Link_SFDC2__c(
				Account__c = lstAccsToInsert.get(2).Id,
				Financial_Account__c = fAccsToInsert.get(6).Id,
				CIF_JHA_LINK__c = 'TestExt7'
			)
		};
		//The records are inserted if it is specified
		if(intMode == 1){
			Database.insert(lstJunctionRecordsToInsert);
		}
		return lstJunctionRecordsToInsert;
	} 

	/*
		Method that validates the scenario where new junction records are inserted and the summarization is performed properly.
	*/

	@isTest static void shouldAddToCounter() {
		List<Account> lstAccsToInsert = getAccs();
		Database.insert(lstAccsToInsert);
		List<Financial_Account_SFDC2__c> fAccsToInsert = getFinancialAccs();
		Database.insert(fAccsToInsert);
		List<Financial_Account_Link_SFDC2__c> lstJunctionRecordsToInsert = getJunctionRecords(lstAccsToInsert,fAccsToInsert,0);
		Test.startTest();
			Database.insert(lstJunctionRecordsToInsert);
			//Based on all the created junction records, the summarized fields must have the following values
			System.assertEquals([SELECT Id, BankXFinancialAccounts__c FROM Account WHERE Id =: lstAccsToInsert[0].Id].BankXFinancialAccounts__c,1);
			System.assertEquals([SELECT Id, BofIFederalBankFinancialAccounts__c FROM Account WHERE Id =: lstAccsToInsert[0].Id].BofIFederalBankFinancialAccounts__c,1);
			System.assertEquals([SELECT Id, BofIAdvisorFinancialAccounts__c FROM Account WHERE Id =: lstAccsToInsert[0].Id].BofIAdvisorFinancialAccounts__c,0);
			System.assertEquals([SELECT Id, BofIAdvisorFinancialAccounts__c FROM Account WHERE Id =: lstAccsToInsert[1].Id].BofIAdvisorFinancialAccounts__c,1);
			System.assertEquals([SELECT Id, BankOfInternetFinancialAccounts__c FROM Account WHERE Id =: lstAccsToInsert[1].Id].BankOfInternetFinancialAccounts__c,1);
			System.assertEquals([SELECT Id, UFBDirectFinancialAccounts__c FROM Account WHERE Id =: lstAccsToInsert[1].Id].UFBDirectFinancialAccounts__c,0);
			System.assertEquals([SELECT Id, UFBDirectFinancialAccounts__c FROM Account WHERE Id =: lstAccsToInsert[2].Id].UFBDirectFinancialAccounts__c,1);
			System.assertEquals([SELECT Id, VirtusBankFinancialAccounts__c FROM Account WHERE Id =: lstAccsToInsert[2].Id].VirtusBankFinancialAccounts__c,1);
			System.assertEquals([SELECT Id, NetBankFinancialAccounts__c FROM Account WHERE Id =: lstAccsToInsert[2].Id].NetBankFinancialAccounts__c,1);
			System.assertEquals([SELECT Id, BankXFinancialAccounts__c FROM Account WHERE Id =: lstAccsToInsert[2].Id].BankXFinancialAccounts__c,0);
		Test.stopTest();
	}

	/*
		Method that validates the scenario where new juntion records are added and summarized properly.
	*/
	
	@isTest static void shouldAddMoreToCounter() {
		List<Account> lstAccsToInsert = getAccs();
		Database.insert(lstAccsToInsert);
		List<Financial_Account_SFDC2__c> fAccsToInsert = getFinancialAccs();
		Database.insert(fAccsToInsert);
		List<Financial_Account_Link_SFDC2__c> lstJunctionRecordsToInsert = getJunctionRecords(lstAccsToInsert,fAccsToInsert,1);
		Test.startTest();
			//New junction record is created
			Database.insert(
				new Financial_Account_Link_SFDC2__c(
					Account__c = lstAccsToInsert.get(0).Id,
					Financial_Account__c = fAccsToInsert.get(0).Id,
					CIF_JHA_LINK__c = 'TestExt8'
				)
			);
			//Sumarized field in account must be updated properly
			System.assertEquals([SELECT Id, BankXFinancialAccounts__c FROM Account WHERE Id =: lstAccsToInsert[0].Id].BankXFinancialAccounts__c,2);
			System.assertEquals([SELECT Id, BofIFederalBankFinancialAccounts__c FROM Account WHERE Id =: lstAccsToInsert[0].Id].BofIFederalBankFinancialAccounts__c,1);
		Test.stopTest();
	}

	/*
		Method that validates the escenario where summarization was previously executed but some of the junction records were erased.
	*/
	
	@isTest static void shouldReducetheCounter() {
		List<Account> lstAccsToInsert = getAccs();
		Database.insert(lstAccsToInsert);
		List<Financial_Account_SFDC2__c> fAccsToInsert = getFinancialAccs();
		Database.insert(fAccsToInsert);
		List<Financial_Account_Link_SFDC2__c> lstJunctionRecordsToInsert = getJunctionRecords(lstAccsToInsert,fAccsToInsert,1);
		Test.startTest();
			Database.insert(
				new Financial_Account_Link_SFDC2__c(
					Account__c = lstAccsToInsert.get(0).Id,
					Financial_Account__c = fAccsToInsert.get(0).Id,
					CIF_JHA_LINK__c = 'TestExt8'
				)
			);
			//Junction record is deleted
			Database.delete([SELECT Id FROM Financial_Account_Link_SFDC2__c WHERE Brand__c = 'Bank X' AND Account__c =: lstAccsToInsert.get(0).Id LIMIT 1]);
			//Sumarized field must be reduced in 1
			System.assertEquals([SELECT Id, BankXFinancialAccounts__c FROM Account WHERE Id =: lstAccsToInsert[0].Id].BankXFinancialAccounts__c,1);
			Database.delete([SELECT Id FROM Financial_Account_Link_SFDC2__c WHERE Brand__c = 'BofI Federal Bank' AND Account__c =: lstAccsToInsert.get(0).Id]);
			System.assertEquals([SELECT Id, BofIFederalBankFinancialAccounts__c FROM Account WHERE Id =: lstAccsToInsert[0].Id].BofIFederalBankFinancialAccounts__c,0);
		Test.stopTest();
	}

	/*
		Method that validates the scenario where one junction record is deleted but, after, undeleted.
	*/

	@isTest static void shouldRecoverCounter(){
		List<Account> lstAccsToInsert = getAccs();
		Database.insert(lstAccsToInsert);
		List<Financial_Account_SFDC2__c> fAccsToInsert = getFinancialAccs();
		Database.insert(fAccsToInsert);
		List<Financial_Account_Link_SFDC2__c> lstJunctionRecordsToInsert = getJunctionRecords(lstAccsToInsert,fAccsToInsert,1);
		Test.startTest();
			Database.insert(
				new Financial_Account_Link_SFDC2__c(
					Account__c = lstAccsToInsert.get(0).Id,
					Financial_Account__c = fAccsToInsert.get(0).Id,
					CIF_JHA_LINK__c = 'TestExt8'
				)
			);
			List<Financial_Account_Link_SFDC2__c> lstFinancialAccountToDelete = [SELECT Id FROM Financial_Account_Link_SFDC2__c WHERE Brand__c = 'Bank X' AND Account__c =: lstAccsToInsert.get(0).Id];
			//Record is deleted and the summarized field is reduced in 2.
			Database.delete(lstFinancialAccountToDelete);
			System.assertEquals([SELECT Id, BankXFinancialAccounts__c FROM Account WHERE Id =: lstAccsToInsert[0].Id].BankXFinancialAccounts__c,0);
			//Records are undeleted and the summarized field is updated into 2.
			Database.undelete(lstFinancialAccountToDelete);
			System.assertEquals([SELECT Id, BankXFinancialAccounts__c FROM Account WHERE Id =: lstAccsToInsert[0].Id].BankXFinancialAccounts__c,2);
		Test.stopTest();
	}

	/*
		Validates the scenario where the batch process is executed for those accounts which have never been processed for summary.
	*/

	@isTest static void shouldExecuteBatchProperly(){
		List<Account> lstAccsToInsert = getAccs();
		Database.insert(lstAccsToInsert);
		List<Financial_Account_SFDC2__c> fAccsToInsert = getFinancialAccs();
		Database.insert(fAccsToInsert);
		TriggerLoopExecutionControl_cls.setAlreadyBeenExecuted('AccountLinkToFinancialsTrigger');
		List<Financial_Account_Link_SFDC2__c> lstJunctionRecordsToInsert = getJunctionRecords(lstAccsToInsert,fAccsToInsert,1);
		//Summary must has never been performed.
		System.assertEquals([SELECT Id, BankXFinancialAccounts__c FROM Account WHERE Id =: lstAccsToInsert[0].Id].BankXFinancialAccounts__c,0);
		String strQueryOverAccountsToProcess = 'SELECT Id FROM Account WHERE FinAccsSummProcessed__c = false';
		UDB_UpdateBrandsCounter_bch batchInstance = new UDB_UpdateBrandsCounter_bch(strQueryOverAccountsToProcess);
		Test.startTest();
			Database.executeBatch(batchInstance,100);
		Test.stopTest();
		//After batch process execution, the summary fields must be updated
		System.assertEquals([SELECT Id, BankXFinancialAccounts__c FROM Account WHERE Id =: lstAccsToInsert[0].Id].BankXFinancialAccounts__c,1);
		TriggerLoopExecutionControl_cls.resetStatusExecutionTrigger('AccountLinkToFinancialsTrigger');
	}

	/*
		Method that validated the ability to schedule the batch process. 
	*/

	@isTest static void shouldSchedule(){
		List<Account> lstAccsToInsert = getAccs();
		Database.insert(lstAccsToInsert);
		List<Financial_Account_SFDC2__c> fAccsToInsert = getFinancialAccs();
		Database.insert(fAccsToInsert);
		TriggerLoopExecutionControl_cls.setAlreadyBeenExecuted('AccountLinkToFinancialsTrigger');
		List<Financial_Account_Link_SFDC2__c> lstJunctionRecordsToInsert = getJunctionRecords(lstAccsToInsert,fAccsToInsert,1);
		System.assertEquals([SELECT Id, BankXFinancialAccounts__c FROM Account WHERE Id =: lstAccsToInsert[0].Id].BankXFinancialAccounts__c,0);
		Test.startTest();
			UDB_UpdateBrandsCounter_sch scheduleInstance = new UDB_UpdateBrandsCounter_sch();
			Datetime dTNext5Mins = Datetime.now().addMinutes(5);
			String strChronStmt = '00 '+dTNext5Mins.minute()+' '+dTNext5Mins.hour()+' '+dTNext5Mins.day()+' '+dTNext5Mins.month()+' ? '+dTNext5Mins.year();
			System.schedule(strChronStmt+' Summarize branding', strChronStmt, scheduleInstance);
		Test.stopTest();
	}

	/*
		Method that validates the bulk records insert scenario
	*/

	@isTest static void shouldProcessWhenBulkInsert(){
		List<Account> lstAccsToInsert = getBulkAccs();
		Database.insert(lstAccsToInsert);
		List<Financial_Account_SFDC2__c> fAccsToInsert = getFinancialAccs();
		Database.insert(fAccsToInsert);
		Test.startTest();
			List<Financial_Account_Link_SFDC2__c> lstJunctionRecordsToInsert = getBulkJunctionRecords(lstAccsToInsert,fAccsToInsert,1);
		Test.stopTest();
		System.assertEquals([SELECT Id, BankXFinancialAccounts__c FROM Account WHERE Id =: lstAccsToInsert[0].Id].BankXFinancialAccounts__c,1);
		//Database.undelete(lstJunctionRecordsToInsert);
	}

	/*
		Method that validates the bulk records insert scenario
	*/

	@isTest static void shouldProcessWhenBulkDelete(){
		List<Account> lstAccsToInsert = getBulkAccs();
		Database.insert(lstAccsToInsert);
		List<Financial_Account_SFDC2__c> fAccsToInsert = getFinancialAccs();
		Database.insert(fAccsToInsert);
		List<Financial_Account_Link_SFDC2__c> lstJunctionRecordsToInsert = getBulkJunctionRecords(lstAccsToInsert,fAccsToInsert,1);
		lstAccsToInsert[0].BankXFinancialAccounts__c = 1;
		Database.update(lstAccsToInsert[0]);
		Test.startTest();
			Database.delete(lstJunctionRecordsToInsert);
		Test.stopTest();
		System.assertEquals([SELECT Id, BankXFinancialAccounts__c FROM Account WHERE Id =: lstAccsToInsert[0].Id].BankXFinancialAccounts__c,0);
	}

	/*
		Method that validates the bulk records undelete scenario
	*/

	@isTest static void shouldProcessWhenBulkUndelete(){
		List<Account> lstAccsToInsert = getBulkAccs();
		Database.insert(lstAccsToInsert);
		List<Financial_Account_SFDC2__c> fAccsToInsert = getFinancialAccs();
		Database.insert(fAccsToInsert);
		List<Financial_Account_Link_SFDC2__c> lstJunctionRecordsToInsert = getBulkJunctionRecords(lstAccsToInsert,fAccsToInsert,1);
		Database.delete(lstJunctionRecordsToInsert);
		lstAccsToInsert[0].BankXFinancialAccounts__c = 0;
		Database.update(lstAccsToInsert[0]);
		Test.startTest();
			Database.undelete(lstJunctionRecordsToInsert);
		Test.stopTest();
		System.assertEquals([SELECT Id, BankXFinancialAccounts__c FROM Account WHERE Id =: lstAccsToInsert[0].Id].BankXFinancialAccounts__c,1);
	}

}