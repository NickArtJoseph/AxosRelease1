/**
* @description <p>Handler class for PersonFinancialAccountJunctionTrigger functionality</p>
* @author Mike Crosby, BofI Federal 
*/
public class PersonFinancialAcctJuncTriggerHandler extends TriggerHandler{

  /** Map of records before changes */
  private Map<Id, Person_Financial_Account_Junction__c> oldJuncMap;
  /** Map of records with changes */
  private Map<Id, Person_Financial_Account_Junction__c> newJuncMap;

  /** Constructor */
  public PersonFinancialAcctJuncTriggerHandler() {
    this.oldJuncMap = (Map<Id, Person_Financial_Account_Junction__c>) Trigger.oldMap;
    this.newJuncMap = (Map<Id, Person_Financial_Account_Junction__c>) Trigger.newMap;
  }

  /**
  * Process afterInsert logic
  */
  public override void afterInsert() {
    mapAccountFinancialJunction(this.newJuncMap);
  }

  /**
  * Process afterUpdate logic
  */
  public override void afterUpdate() {
    updateFinancialAccountCounts(this.oldJuncMap, this.newJuncMap);
  }
  
  /**
  * Process afterDelete logic
  */
  public override void afterDelete() {
    updateFinancialAccountCounts(this.oldJuncMap, null);
  }

  private void updateFinancialAccountCounts(Map<Id, Person_Financial_Account_Junction__c> oldMap, Map<Id, Person_Financial_Account_Junction__c> newMap) {
    Set<Id> finAcctLookupSet = new Set<Id>();
    for(Person_Financial_Account_Junction__c oldJunc : oldMap.values()) {
        System.debug('**** Junction: ' + oldJunc.CIF_JHA_LINK__c);
        System.debug('**** Existing Fin Acct: ' + oldJunc.Financial_Account__c);
        System.debug('**** Existing Per Acct: ' + oldJunc.Person_Account__c);
        Person_Financial_Account_Junction__c newJunc = null;
        if(newMap != null) {
            newJunc = newMap.get(oldJunc.Id);
            if(newJunc.Financial_Account__c != null) {
                System.debug('**** Adding new Financial Account to update: ' + newJunc.Financial_Account__c);
                finAcctLookupSet.add(newJunc.Financial_Account__c);
            }
        }
        if(oldJunc.Financial_Account__c != null) {
            System.debug('**** Adding old Financial Account to update: ' + oldJunc.Financial_Account__c);
            finAcctLookupSet.add(oldJunc.Financial_Account__c);
        }
    }
    for(Financial_Account__c fin : [SELECT Id, (SELECT Id FROM Person_Financial_Account_Junctions__r) FROM Financial_Account__c WHERE Id IN :finAcctLookupSet]) {
        
        fin.Person_Account_Count__c = fin.Person_Financial_Account_Junctions__r.size();
        toUpdate.add(fin);
    }
  }

  /**
  * When new records are inserted, the Person Account and Financial Account records need to be linked
  * @param newMap map of new Person Financial Account Junction records
  */
  private void mapAccountFinancialJunction(Map<Id, Person_Financial_Account_Junction__c> newMap) {
    Map<Id, Person_Financial_Account_Junction__c> recordsToMap = new Map<Id, Person_Financial_Account_Junction__c>();
    for(Person_Financial_Account_Junction__c pf : newMap.values())
    {
      if(pf.Person_Account__c == null || pf.Financial_Account__c == null) {
        recordsToMap.put(pf.Id, pf);
      }
    }
    if(recordsToMap.size() > 0) {
        Database.executeBatch(new AccountFinancialJunctionBatch(recordsToMap));
    }
  }
}