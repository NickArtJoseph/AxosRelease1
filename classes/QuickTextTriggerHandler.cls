/**
* @description <p>Handler class for QuickTextTrigger functionality</p>
* @author 
*/
public class QuickTextTriggerHandler extends TriggerHandler {
    /** Map of Contacts before changes */
    private Map<Id, QuickText> oldQuickTextMap;
    /** List of Contact with changes */
    private List<QuickText> newQuickTextList;
    
	private final String[] strGroups = new String[]{'Advisor Live Agent','Business Banking Live Agent','Consumer Deposits Live Agent'};
    private final Group[] lstGroups = [SELECT Id FROM Group WHERE Name IN :strGroups];
    
    /** Constructor */
    public QuickTextTriggerHandler() {
        this.oldQuickTextMap = (Map<Id, QuickText>) Trigger.oldMap;
        this.newQuickTextList = Trigger.new;
    }
    
    /**
    * Process afterUpdate logic
    */
    public override void afterUpdate() {
        // convertFlaggedContactsSFDC2(this.newContList);
        shareQuickTextUpdate();	
    }
    
    /**
    * Process afterInsert logic
    */
    public override void afterInsert() {
        shareQuickTextInsert();
    }
    
    /*
     * When a QuickText record in created, check the Business_Units__c multi-picklist and create one QuickTextShare record for each picklist value
     */
    public void shareQuickTextInsert(){
        for(QuickText qtTemp : newQuickTextList){
            String[] strBU = qtTemp.Business_Units__c.split(';');
            for(String strTemp : strBU){
                QuickTextShare qtShr = new QuickTextShare();
                qtShr.ParentId = qtTemp.id;
                qtShr.AccessLevel = 'Read';
                qtShr.UserOrGroupId = strTemp=='Advisor'?lstGroups[0].id:strTemp=='Business Banking'?lstGroups[1].id:lstGroups[2].id;
                toInsert.add((sObject)qtShr);
            }
        }
    }
    /*
     * When Business_Banking__c multi-picklist is updated on QuickText record, delete existing QuickTextShare records and create new ones for each picklist value
     */
    public void shareQuickTextUpdate(){
        List<Id> lstIdsToDelete = new List<Id>();
        for(QuickText qtTemp : newQuickTextList){
            // Verify if the Business_Banking__c multi-picklist was updated
            if(oldQuickTextMap.get(qtTemp.id).Business_Units__c != qtTemp.Business_Units__c){
                // Make a list of the existing QuickTextShare to be deleted
                lstIdsToDelete.add(qtTemp.id);
                String[] strBU = qtTemp.Business_Units__c.split(';');
                for(String strTemp : strBU){
                    QuickTextShare qtShr = new QuickTextShare();
                    qtShr.ParentId = qtTemp.id;
                    qtShr.AccessLevel = 'Read';
                	qtShr.UserOrGroupId = strTemp=='Advisor'?lstGroups[0].id:strTemp=='Business Banking'?lstGroups[1].id:lstGroups[2].id;
                    // Make a list of the new QuickTextShare to be inserted
                    toInsert.add((sObject)qtShr);
                }
            }
        }
        // Delete all the QuickTextShare records related to the QuickText record updated
        if(!lstIdsToDelete.isEmpty()){
            delete [SELECT Id, ParentId FROM QuickTextShare WHERE ParentId IN :lstIdsToDelete AND RowCause = 'Manual'];
        }
    }
}