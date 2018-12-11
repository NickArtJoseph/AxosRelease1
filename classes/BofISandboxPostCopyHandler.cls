public class BofISandboxPostCopyHandler {
    public static Boolean isTest = false;
    public static final Organization ORG = [SELECT isSandbox FROM Organization];
    
	private SandboxPostCopy__mdt spc;
    
    public BofISandboxPostCopyHandler() {
        spc = [SELECT Unmask_Admin_Email_Address__c, Delete_Scheduled_Jobs__c FROM SandboxPostCopy__mdt WHERE QualifiedApiName = 'SandboxPostCopy'];
    }
    
    public void unmaskAdminEmailAddress() {
        BofISandboxPostCopyHandler.unmaskAdminEmailAddress(spc.Unmask_Admin_Email_Address__c);
    }
    
    public void deleteScheduledJobs() {
        BofISandboxPostCopyHandler.deleteScheduledJobs(spc.Delete_Scheduled_Jobs__c);
    }
    
    public static void deleteScheduledJobs(Boolean isActionable) {
        if(!isTest && !BofISandboxPostCopyHandler.ORG.isSandbox) { throw new BofISandboxPostCopyHandlerException('This process may not run in the production environment'); }
        if(isActionable) {
            for(CronTrigger[] cronstodelete : [Select Id, CronJobDetail.Name, CronJobDetail.JobType from CronTrigger]) {
                for(CronTrigger ct : cronstodelete) {
                    System.debug('**** Deleting scheduled job: id=' + ct.Id + '; name=' + ct.CronJobDetail.Name + '; type=' + ct.CronJobDetail.JobType);
                    System.abortJob(ct.Id);
                }
            }
        }
    }
    
    public static void unmaskAdminEmailAddress(Boolean isActionable) {
        if(!isTest && !BofISandboxPostCopyHandler.ORG.isSandbox) { throw new BofISandboxPostCopyHandlerException('This process may not run in the production environment'); }
        if(isActionable) {
            List<User> toUpdate = new List<User>();
            User[] uList = [SELECT Email FROM User WHERE IsActive = true AND Profile.Name = 'System Administrator'];
            System.debug('**** Located ' + uList.size() + ' System Admin Emails to update');
            for(User u : uList) {
                if(u.Email.endsWith('@example.com')) {
                    u.Email = u.Email.replace('@example.com','');
                    u.Email = u.Email.replace('=', '@');
                    System.debug('**** Unmasked email=' + u.Email);
                    toUpdate.add(u);
                }
            }
            if(toUpdate.size() > 0) {
                update toUpdate;
            }
        }
    }
    
    public class BofISandboxPostCopyHandlerException extends Exception {}
}