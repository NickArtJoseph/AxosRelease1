global class LeadsEditable implements Database.Batchable<sObject>, Database.Stateful{

   global final String UId;
   global final String Query;
   global Map<String, Map<String, Integer>> editLeadMap;

   global LeadsEditable(String userId){
      editLeadMap = new Map<String, Map<String, Integer>>();
      UId=userId;
      Query = 'select Id, Owner.UserRole.Name, Owner.FirstName, Owner.LastName from Lead';
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
     Map<Id, Lead> leadMap = new Map<Id, Lead>();
     for(sobject s : scope){
       Lead l = (Lead)s;
       leadMap.put(l.Id, l);
     }
     
     for(UserRecordAccess ura : [SELECT RecordId FROM UserRecordAccess WHERE UserId =: UId AND RecordId IN :leadMap.keySet() AND HasEditAccess = true]) {
       Lead l = leadMap.get(ura.RecordId);
       String roleName = l.Owner.UserRole.Name;
       if(!editLeadMap.containsKey(roleName)) {
         editLeadMap.put(roleName, new Map<String, Integer>());
       }
       String ownerName = ((l.Owner.FirstName == null) ? '' : l.Owner.FirstName + ' ') + l.Owner.LastName;
       ownerName = ownerName.trim();
       if(!editLeadMap.get(roleName).containsKey(ownerName)) {
         editLeadMap.get(roleName).put(ownerName, 0);
       }
       Integer incrVal = editLeadMap.get(roleName).get(ownerName);
       editLeadMap.get(roleName).put(ownerName, ++incrVal);
     }
     System.debug(editLeadMap);
    }

   global void finish(Database.BatchableContext BC){
       System.debug(editLeadMap);
       List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
       Id recipientId = '005i00000055SSO';
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            string body = '';
            mail.setSubject('Leads editable by ' + UId);
            if(editLeadMap.size() == 0) {
                body = 'No leads editable';
            } else {
                body = 'The following Leads are editable:';
                body += '<ul>';
                Set<String> keySet = editLeadMap.keySet();
                List<String> sortedKeys = new List<String>();
                sortedKeys.addAll(keySet);
                sortedKeys.sort();
                for(String key : sortedKeys) {
                  body += '<li>' + key;
                  Set<String> ownerSet = editLeadMap.get(key).keySet();
                  List<String> sortedOwners = new List<String>();
                  sortedOwners.addAll(ownerSet);
                  sortedOwners.sort();
                  for(String ownerName : sortedOwners) {
                    body += '<br>&nbsp;&nbsp;-&nbsp;' + ownerName + ': ' + editLeadMap.get(key).get(ownerName);   
                  }
                  body += '</li>';
                }
                body += '</ul>';
            }
            mail.setReplyTo('salesforcesupport@bofi.com');
            mail.setSenderDisplayName('BofI Salesforce Support');
            mail.setTargetObjectId(recipientId); 
            mail.setSaveAsActivity(false);
            mail.setHtmlBody(body); 
            mailList.add(mail);
        Messaging.sendEmail(mailList);
   }

}