public  class CasenextSLAdate{
    @future
    public static void copyTargetDate(Set<Id> caseIds) {
        List<Case> casesToUpdate = new List<Case>();
     
        for (CaseMilestone milestone : [ select CaseId, TargetDate
                                         from CaseMilestone
                                         where CaseId in :caseIds and IsCompleted = false
                                         ORDER BY TargetDate DESC LIMIT 1]){
        casesToUpdate.add(new Case( Id = milestone.CaseId, next_sla_due__c  = milestone.TargetDate));

        }

        if (!casesToUpdate.isEmpty()) {
            update casesToUpdate;
        }
    }
    
  
}