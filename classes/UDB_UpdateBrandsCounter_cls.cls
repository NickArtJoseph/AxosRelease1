/***

    Author: René Ayala Medina
    Description: APEX class to summarize the brands of the related financial accounts and set that summary to the numeric fields in "Account" object. 
    
    Version Developer             Date          Description
    0.1     René Ayala Medina RAM 07/02/2018    Class created
    0.2     René Ayala Medina RAM 07/02/2018    Building the class
    1.0     René Ayala Medina RAM 07/05/2018    Documentation and testing

***/

global class UDB_UpdateBrandsCounter_cls {

    /*
        Method to summarize the brands of financial accounts in numeric fields of the "Account" record
    */

    global static void updateBrandCounterFields(Set<Id> accountsIDs){
        Map<Id,Map<String,List<Financial_Account_Link_SFDC2__c>>> mapBrandsPerAccount = new Map<Id,Map<String,List<Financial_Account_Link_SFDC2__c>>>();
        Map<Id,Map<String,Integer>> mapCounterBrandsPerAccount = new Map<Id,Map<String,Integer>>();
        List<Account> lstAccountsToBeQueried = new List<Account>();
        //The refered accounts are queried as well as their related financial accounts.
        String strQueryOverAccAndFinancialRelsSttmnt = 'SELECT Id, Name, (SELECT Id, Brand__c FROM Financial_Account_Links__r) FROM Account WHERE Id IN (\''+String.join(new List<Id>(accountsIDs),'\',\'')+'\')';
        lstAccountsToBeQueried = Database.query(strQueryOverAccAndFinancialRelsSttmnt);
        // A map of Account Id -> Brand -> Financial Accounts with that brand is created and filled out.
        // A map of Account Id -> Brand -> Number of Financial Accounts with that brand is created and filled out.
        for(Account iterator0:lstAccountsToBeQueried){
            if(!mapBrandsPerAccount.containsKey(iterator0.Id)){
                mapBrandsPerAccount.put(iterator0.Id, new Map<String,List<Financial_Account_Link_SFDC2__c>>());
            }
            if(!mapCounterBrandsPerAccount.containsKey(iterator0.Id)){
                mapCounterBrandsPerAccount.put(iterator0.Id, new Map<String,Integer>());
            }
            for(Financial_Account_Link_SFDC2__c iterator1:iterator0.Financial_Account_Links__r){
                if(iterator1.Brand__c != null){
                    if(String.isNotBlank(iterator1.Brand__c)){
                        if(!mapBrandsPerAccount.get(iterator0.Id).containsKey(iterator1.Brand__c.toLowerCase())){
                            mapBrandsPerAccount.get(iterator0.Id).put(iterator1.Brand__c.toLowerCase(),new List<Financial_Account_Link_SFDC2__c>());
                        }
                        mapBrandsPerAccount.get(iterator0.Id).get(iterator1.Brand__c.toLowerCase()).add(iterator1);
                    }
                }
            }
            for(String iterator2:mapBrandsPerAccount.get(iterator0.Id).keySet()){
                mapCounterBrandsPerAccount.get(iterator0.Id).put(iterator2,mapBrandsPerAccount.get(iterator0.Id).get(iterator2).size());
            }
        }
        //Every account summary fields are set based on the previous maps.
        List<Account> lstAccsToUpdate = new List<Account>();
        for(Id iterator0:mapCounterBrandsPerAccount.keySet()){
            Boolean blnAtLeastOneFieldWillBeUpdtd = false;
            Account accountInstance = new Account();
            accountInstance.Id = iterator0;
            accountInstance.FinAccsSummProcessed__c = true;
            if(mapCounterBrandsPerAccount.get(iterator0).containsKey('bank x')){
                accountInstance.BankXFinancialAccounts__c = mapCounterBrandsPerAccount.get(iterator0).get('bank x');
            }else{
                accountInstance.BankXFinancialAccounts__c = 0;
            }
            if(mapCounterBrandsPerAccount.get(iterator0).containsKey('bofi federal bank')){
                blnAtLeastOneFieldWillBeUpdtd = true;
                accountInstance.BofIFederalBankFinancialAccounts__c = mapCounterBrandsPerAccount.get(iterator0).get('bofi federal bank');
            }else{
                accountInstance.BofIFederalBankFinancialAccounts__c = 0;
            }
            if(mapCounterBrandsPerAccount.get(iterator0).containsKey('bofi advisor')){
                blnAtLeastOneFieldWillBeUpdtd = true;
                accountInstance.BofIAdvisorFinancialAccounts__c = mapCounterBrandsPerAccount.get(iterator0).get('bofi advisor');
            }else{
                accountInstance.BofIAdvisorFinancialAccounts__c = 0;
            }
            if(mapCounterBrandsPerAccount.get(iterator0).containsKey('bank of internet')){
                blnAtLeastOneFieldWillBeUpdtd = true;
                accountInstance.BankOfInternetFinancialAccounts__c = mapCounterBrandsPerAccount.get(iterator0).get('bank of internet');
            }else{
                accountInstance.BankOfInternetFinancialAccounts__c = 0;
            }
            if(mapCounterBrandsPerAccount.get(iterator0).containsKey('ufb direct')){
                blnAtLeastOneFieldWillBeUpdtd = true;
                accountInstance.UFBDirectFinancialAccounts__c = mapCounterBrandsPerAccount.get(iterator0).get('ufb direct');
            }else{
                accountInstance.UFBDirectFinancialAccounts__c = 0;
            }
            if(mapCounterBrandsPerAccount.get(iterator0).containsKey('virtus bank')){
                blnAtLeastOneFieldWillBeUpdtd = true;
                accountInstance.VirtusBankFinancialAccounts__c = mapCounterBrandsPerAccount.get(iterator0).get('virtus bank');
            }else{
                accountInstance.VirtusBankFinancialAccounts__c = 0;
            }
            if(mapCounterBrandsPerAccount.get(iterator0).containsKey('netbank')){
                accountInstance.NetBankFinancialAccounts__c = mapCounterBrandsPerAccount.get(iterator0).get('netbank');
                blnAtLeastOneFieldWillBeUpdtd = true;
            }else{
                accountInstance.NetBankFinancialAccounts__c = 0;
            }
            lstAccsToUpdate.add(accountInstance); 
        }
        //All processed accounts are updated
        if(!lstAccsToUpdate.isEmpty()){
            Database.update(lstAccsToUpdate,false);
        }
    }
    
}