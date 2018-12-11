public class UserTriggerHandler extends TriggerHandler {
    /** Map of records before changes */
    private Map<Id, User> oldMap;
    /** Map of records with changes */
    private Map<Id, User> newMap;
    /** List of records with changes; typically used for beforeInsert */
    private List<User> newList;
    /** Map of role ids/names */
    public static Map<Id, UserRole> roleMap {
        get{
            if(roleMap == null) {
                roleMap = new Map<Id, UserRole>([SELECT DeveloperName FROM UserRole]);
            }
            return roleMap;
        }
        set;
    }
    /** Map of queue ids/names */
    public static Map<Id, Group> queueMap {
        get{
            if(queueMap == null) {
                queueMap = new Map<Id, Group>([SELECT DeveloperName FROM Group WHERE Type = 'Queue']);
            }
            return queueMap;
        }
        set;
    }
    /** Map of roles with corresponding Lead queue names for reassignment during deactivation of user */
    public static Map<String,String> roleLeadQueueMap = new Map<String,String> {
        'Financial_Advisor_Mgr' => 'Advisor_Firm_Lead_Queue',
        'Financial_Advisor_Rep' => 'Advisor_Firm_Lead_Queue',
        'Dealer_Services_Manager' => 'Auto_Dealer_Lead_Queue',
        'Dealer_Services_Rep' => 'Auto_Dealer_Lead_Queue',
        'Business_Banking_Manager' => 'Business_Banking_Lead_Queue',
        'Business_Banking' => 'Business_Banking_Lead_Queue',
        'Consumer_Deposits' => 'Consumer_Deposits_Lead_Queue',
        'Consumer_Deposits_Manager' => 'Consumer_Deposits_Lead_Queue',
        'Virtus_Rep' => 'Virtus_Lead_Queue',
        'Virtus_Manager' => 'Virtus_Lead_Queue'
    };
    /** Map of roles with corresponding Opp Queue queue names for reassignment during deactivation of user */
    public static Map<String,String> roleOppQueueMap = new Map<String,String> {
        'Financial_Advisor_Mgr' => 'Advisor_Opportunity_Queue',
        'Financial_Advisor_Rep' => 'Advisor_Opportunity_Queue',
        'Dealer_Services_Manager' => 'Auto_Lending_Opportunity_Queue',
        'Dealer_Services_Rep' => 'Auto_Lending_Opportunity_Queue',
        'Business_Banking_Manager' => 'Business_Banking_Opportunity_Queue',
        'Business_Banking' => 'Business_Banking_Opportunity_Queue',
        'Consumer_Deposits' => 'Consumer_Deposits_Opportunity_Queue',
        'Consumer_Deposits_Manager' => 'Consumer_Deposits_Opportunity_Queue',
        'Virtus_Rep' => 'Virtus_Opportunity_Queue',
        'Virtus_Manager' => 'Virtus_Opportunity_Queue'
    };
    /** API Service Account id*/
    public static final Id APIAccountId = '005i0000001wnZb';
    
    /** Constructor */
    public UserTriggerHandler() {
        this.oldMap = (Map<Id, User>) Trigger.oldMap;
        this.newMap = (Map<Id, User>) Trigger.newMap;
        this.newList = (List<User>) Trigger.new;
    }

    /**
    * Process beforeInsert logic
    */
    //public override void beforeInsert() {  }
    
    /**
    * Process beforeUpdate logic
    */
    //public override void beforeUpdate() {  }
    
    /**
    * Process afterInsert logic
    */
    //public override void afterInsert() {  }
    
    /**
    * Process afterUpdate logic
    */
    public override void afterUpdate() { 
        //SFDC2
        handleLeadReassignments();
        handleOppReassignments();
    }
    
    /**
    * SFDC2: For deactivated users, transfer Opportunities to API Service Account
    * and link to an Opportunity Queue record assigned to appropriate opp queue 
    */
    private void handleOppReassignments() {
        List<String> deactivatedUserQueueList = new List<String>();
        for(User u : newMap.values()) {
            if(!u.IsActive && 
                oldMap.get(u.Id).IsActive &&
                roleOppQueueMap.keySet().contains(roleMap.get(u.UserRoleId).DeveloperName)) {
                //a deactivation has occurred for an affected business unit
                System.debug('User ' + u.Name + ' [' + u.Id + '] has been deactivated. ' +
                    'Opps will need to be reassigned to queue');
                deactivatedUserQueueList.add(u.Id);
            }
        }
        if(deactivatedUserQueueList.size() > 0) {
            updateOppOwnership(deactivatedUserQueueList);
        }
    }
    
    /**
    * SFDC2: A future method is needed for mixed DML actions
    * Updates any Opp records affected by user deactivation and potentially
    * creates corresponding Opp Queue records
    * @param uqid List of string values comprised of UserId|QueueId
    */
    @future
    private static void updateOppOwnership(List<String> uqid) {
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        for(Opportunity o : [SELECT OwnerId FROM Opportunity WHERE OwnerId IN :uqid AND IsClosed = false AND SFDC2__c = true]) {
            o.Reassign_To_Queue_SFDC2__c = true;
            oppsToUpdate.add(o);
        }
        if(oppsToUpdate.size() > 0) {
            update oppsToUpdate;
        }
    }
    
    /**
    * SFDC2: For deactivated users, transfer Lead ownership to appropriate
    * business lead queue for reassignment
    */
    private void handleLeadReassignments() {
        List<String> deactivatedUserQueueList = new List<String>();
        for(User u : newMap.values()) {
            if(!String.isBlank(u.UserRoleId)) {
                if(!u.IsActive && 
                   oldMap.get(u.Id).IsActive &&
                   roleLeadQueueMap.keySet().contains(roleMap.get(u.UserRoleId).DeveloperName)) {
                       //a deactivation has occurred for an affected business unit
                       System.debug('User ' + u.Name + ' [' + u.Id + '] has been deactivated. ' +
                                    'Leads will need to be reassigned to queue');
                       deactivatedUserQueueList.add(u.Id);
                   }               
            }
                

        }
        if(deactivatedUserQueueList.size() > 0) {
            updateLeadOwnership(deactivatedUserQueueList);
        }
    }
    
    /**
    * SFDC2: A future method is needed for mixed DML actions
    * Updates any Lead records affected by user deactivation
    * @param uqid List of string values comprised of UserId|QueueId
    */
    @future
    private static void updateLeadOwnership(List<String> uqid) {
        List<Lead> leadsToUpdate = new List<Lead>();
        for(Lead l : [SELECT OwnerId FROM Lead WHERE OwnerId IN :uqid AND IsConverted = false AND SFDC2__c = true]) {
            l.Reassign_To_Queue_SFDC2__c = true;
            leadsToUpdate.add(l);
        }
        if(leadsToUpdate.size() > 0) {
            update leadsToUpdate;
        }
    }
}