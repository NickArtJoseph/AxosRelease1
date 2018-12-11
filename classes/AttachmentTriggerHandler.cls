public class AttachmentTriggerHandler extends TriggerHandler {
  private Map<Id, Attachment> oldMap;
  private Map<Id, Attachment> newMap;
  private List<Attachment> newList;
  
  public AttachmentTriggerHandler() {
    this.oldMap   = (Map<Id, Attachment>) Trigger.oldMap;
    this.newMap = (Map<Id, Attachment>) Trigger.newMap;
    this.newList = (List<Attachment>) Trigger.new;
  }

  public override void afterInsert() {
    setAttVisibility();
  }

  private void setAttVisibility() {
    Id udbId =  [select Id from User where  Name = 'UDB Integration'].Id;
    List<String> lstCaseIds = new List<String>();
    List<Attachment> updateAccess = new List<Attachment>();

    for(Case c : [select Id from Case where RecordType.DeveloperName = 'UDB_Inquiry']) {
      lstCaseIds.add(c.Id);
    }
    
    for(Attachment att : [select Id, Name, IsPrivate, OwnerId from Attachment where Id in: newList and ParentId in: lstCaseIds]) {
      if(att.OwnerId != udbId && att.IsPrivate != false) {
        att.IsPrivate = true;
        updateAccess.add(att);
        System.debug('Att Id: '  + att.Id + ' Att Name: ' + att.Name + ' IsPrivate? ' + att.IsPrivate);
      }
    }
    if(!updateAccess.isEmpty()) {
      try {
        update updateAccess;
      }
      catch(Exception e) {
        System.debug('Error: ' + e.getMessage());
      }
    }
  }
}