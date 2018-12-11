public with sharing class ExternalReferralOppApexController {
    
    //This will be replaced with a custom metadata types on Phase two 
    private static Set<String> recTypesAllowed = new Set<String>{'C_I_SFDC2', 'Commercial_Banking_SFDC2', 'HBD_SFDC2', 'IPL_SFDC2'};//Record Types allowed to be used in External Referral Opportunity
    private static Set<String> subBranchesAllowed = new Set<String>{'C_I_SFDC2', 'IPL_SFDC2'};//Record Types available to use subBranch field   
    @AuraEnabled
    public static Map<String,String> getAvailableRecordTypes(){
        Map<String,String> recTypes = new Map<String,String>();
        
        for(RecordTypeInfo info : Lead.SObjectType.getDescribe().getRecordTypeInfos()) {
           if(info.isAvailable() && recTypesAllowed.contains(info.getDeveloperName())) {   recTypes.put(info.getRecordTypeId(), info.getName());  }
        }
        return recTypes;
    }
    @AuraEnabled
    public static Map<String, Object> getFieldsToPopulate(Id objId, String objName, Id subBranch){
        Account acc = new Account();
      	Contact con = new Contact();
        
        Map<String, Object> fieldMapping = new Map<String,Object>();

        RecordType subBranchDevName = [SELECT DeveloperName FROM RecordType WHERE Id = :subBranch Limit 1];
        System.debug('----------------------subBranch' + subBranch);
        System.debug('----------------------subBranchDevName' + subBranchDevName);
        
        if(objName == 'Contact'){
            con = [SELECT Id,  AccountId, Email, MobilePhone, Phone FROM Contact WHERE Id = :objId];
            Id accId = con.AccountId;
            acc = [SELECT Id, BillingCity, BillingCountry, BillingState, BillingPostalCode, Sub_Branch_SFDC2__c, Name, Phone FROM Account WHERE Id = :accId];
        }
        // This Opp Name population will be updated on phase two
        String bkrOppLabel = 'Broker';
        String oppName = bkrOppLabel +' - '+ acc.Name +' - '+ system.today().format(); // This format define the opportunity name for boker lead conversion 
        
        if(subBranchesAllowed.contains(subBranchDevName.DeveloperName)){
            System.debug('-----------------INSIDE SubBranch');
            fieldMapping.put('Sub_Branch_SFDC2__c', acc.Sub_Branch_SFDC2__c);
        }
        fieldMapping.put('Broker_Email__c', con.Email);
        fieldMapping.put('Broker_Phone__c', con.Phone);
        fieldMapping.put('City', acc.BillingCity);
        fieldMapping.put('Country', acc.BillingCountry);
        fieldMapping.put('LeadSource', 'Broker Dealer'); 
        fieldMapping.put('MobilePhone', con.MobilePhone);
        fieldMapping.put('Opportunity_NameSFDC2__c', oppName);
        fieldMapping.put('Phone', acc.Phone);
        fieldMapping.put('PostalCode', acc.BillingPostalCode);
        fieldMapping.put('State', acc.BillingState);
        
        fieldMapping.put('Broker_Company_SFDC2__c', acc.Id);
        fieldMapping.put('Broker_Name_SFDC2__c', con.Id);
        fieldMapping.put('BrokerLead__c', true);

        System.debug(fieldMapping);
        return fieldMapping;
    }
}