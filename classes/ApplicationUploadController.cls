public with sharing class ApplicationUploadController {
    public String sourceSystem {get; set;}
    public Document fileUpload {get; set;}
    public Id jobId {get; set;}
    public String jobStatus {get; set;}
    
    public ApplicationUploadController() {
        fileUpload = new Document();
    }
    
    public List<SelectOption> getSourceSystemList() {
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('', '-- Select One --'));
        options.add(new SelectOption('meridianlink', 'MeridianLink'));
        
        return options;
    }
        
    public PageReference upload() {
        PageReference ref = null;
        
        if(sourceSystem == null || sourceSystem == '') {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'A source system must be selected'));
           return ref;
        }
        
        String fileName = fileUpload.Name;
        if(fileUpload.Name == null || fileUpload.Body == null) {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'A file must be specified for upload'));
           return ref;
        }
        
        fileName = fileName.toLowerCase();
        if(!fileName.endsWith('.xml') && !fileName.endsWith('.zip')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'File must be either XML or ZIP'));
            return ref;
        }
        
        try {
            ApplicationServiceHandler hdl = new ApplicationServiceHandler(sourceSystem, fileUpload.Name, fileUpload.Body);
            jobId = System.enqueueJob(hdl);
            jobStatus = 'Queued';
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
            ApplicationServiceHandler hdl = new ApplicationServiceHandler();
            hdl.handleError(e, 'ApplicationUploadController', null);
        }
        return ref;
    }

    public PageReference pollResults() {
        AsyncApexJob[] job = [SELECT Id, Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :jobID];
        if(job.size() > 0) jobStatus = job[0].Status;
        return null;
    }
    
    public PageReference startNewUpload() {
        jobStatus = null;
        jobId = null;
        fileUpload = new Document();
        return null;
    }
}