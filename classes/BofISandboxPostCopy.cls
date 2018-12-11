global class BofISandboxPostCopy implements SandboxPostCopy {
    
    public static Boolean isTest = false;
    
	global void runApexClass(SandboxContext context) {
        if(isTest) { BofISandboxPostCopyHandler.isTest = true; }
        BofISandboxPostCopyHandler hdl = new BofISandboxPostCopyHandler();
        hdl.unmaskAdminEmailAddress();
        hdl.deleteScheduledJobs();
    }
}