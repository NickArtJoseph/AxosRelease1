/***    

    Author: Jaime Terrats
    Description: Class to view a selected template based on a selected folder. It allows the sending of a message.
    
    Version Developer             Date          Description
    1.0     Jaime Terrats JT      03/05/2018    Class creation
    1.1     René Ayala Medina RAM 04/23/2018    Standards and best practices were applied.
    1.2     Gabe Arce GA          09/27/2018    Updated Folder Names (Line 64 & 68)

***/

global class Secure_Support_Controller { 
 
    private final Case caseInstance;
    public String strSelectedFolder {get;set;}
    public Map<String, String> mapSelOpt = new Map<String, String>();
    public Boolean blnFlag {get;set;}
    public UDB_Secure_Messaging__c secMessageInstance {get;set;}
    public List<EmailTemplate> lstEmailTemplates {get;set;}
    public String strSelectedTemp {get;set;}
    public String strTName {get; set{strTName = value;}}
    
    public String selectedTemplateId { get; set; }

    /*
        Constructor.
    */

    public Secure_Support_Controller(ApexPages.StandardController stdController) {
        caseInstance = [SELECT Id, CaseNumber, Contact.FirstName, ContactId FROM Case WHERE Id = :stdController.getId()];
        blnFlag = false;
        secMessageInstance = new UDB_Secure_Messaging__c();
        selectedTemplateId = ApexPages.currentPage().getParameters().get('selectedTemplateId');
        if(selectedTemplateId != null){
            if (String.isNotBlank(selectedTemplateId)){
                strSelectedTemp = '';
                EmailTemplate auxEmailTemplate = new EmailTemplate();
                try{auxEmailTemplate = [SELECT Id, HtmlValue FROM EmailTemplate WHERE Id = :selectedTemplateId LIMIT 1];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
                if(auxEmailTemplate.Id != null){
                    if(auxEmailTemplate.HtmlValue != null){
                        if(String.isNotBlank(auxEmailTemplate.HtmlValue)){
                            strSelectedTemp = auxEmailTemplate.HtmlValue
                            .replace('<![CDATA[', '')
                            .replace(']]>', '')
                            .replace('{!User.FirstName}', UserInfo.getFirstName());
                            if(caseInstance.Contact.FirstName != null){
                                strSelectedTemp = strSelectedTemp.replace('{!Case.Contact}', caseInstance.Contact.FirstName);
                            }
                        }
                    }
                }
            }
        }
    }

    /*
        Method that returns a list of SelectOption for a picklist field to select a folder.
    */

    public List<SelectOption> getItems() {
        List<SelectOption> lstOptions = new List<SelectOption>();
        List<Folder> lstFolders = new List<Folder>();
        try{lstFolders = [SELECT Id, Name FROM Folder WHERE type =: 'Email' AND (Name LIKE: 'Axos%' OR Name LIKE: '%UFB%') ORDER BY Name];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
        for(Folder f : lstFolders) {
            lstOptions.add(new SelectOption(f.Id, f.Name));
            mapSelOpt.put(f.Id, f.Name);
        }
        blnFlag = false;
        return lstOptions;
    }

    /*
        Based on folder selection, related folders are shown.
    */

    public List<EmailTemplate> getTemplates() {
        lstEmailTemplates = new List<EmailTemplate>();
        String strOption = null;
        if(strSelectedFolder != null){
            if(String.isNotBlank(strSelectedFolder)){
                if(mapSelOpt.containsKey(strSelectedFolder)){
                    strOption = mapSelOpt.get(strSelectedFolder);
                }
            }
        }
        if(strOption == null || String.isBlank(strOption)) {
            strOption = 'Axos - Business Banking';
            try{lstEmailTemplates = [SELECT Name, Id, Body, htmlValue FROM EmailTemplate WHERE EmailTemplate.Folder.Name =: strOption];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
        }
        else {
            try{lstEmailTemplates = [SELECT Name, Id, Body, htmlValue FROM EmailTemplate WHERE EmailTemplate.Folder.Name =: strOption AND (NOT Name  LIKE 'After Hours New VIP%') AND (NOT Name LIKE 'Approval Cloning Request%') AND (NOT Name LIKE 'Case Reassignment%') AND (NOT Name LIKE 'Task Reminder') ORDER BY Name];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
        }
        return lstEmailTemplates;
    }

    public PageReference changeTemplate() {        
        return null;
    }

    /*
        Based on the chosen template, this is shown.
    */
    
    public PageReference renderTemplate() {
        PageReference pr = null;
        EmailTemplate auxEmailTemplate = new EmailTemplate();
        /*try{auxEmailTemplate = [SELECT Id,Body, HtmlValue FROM EmailTemplate WHERE Name LIKE :'%'+strTName+'%' LIMIT 1];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){} */
        auxEmailTemplate = [SELECT Id,Body, HtmlValue FROM EmailTemplate WHERE Name LIKE :'%'+strTName+'%' LIMIT 1];
        if(auxEmailTemplate.Id != null){
            pr = new PageReference('/apex/Secure_Support_Email_Template?id=' + caseInstance.Id + '&selectedTemplateId=' + auxEmailTemplate.Id);
            pr.setRedirect(true);
        }
        return pr;
    }

    /*
        Reset the template
    */

    public PageReference hide() {
        strSelectedTemp = null;
        return null;
    }

    /*
        Updates the view of the chosen template
    */
    
    public PageReference updatePreview() {
        return null;
    }

    @RemoteAction
    global static void attachFile(String fileName, String parId, String base64File) {
        base64File = base64File.substringAfterLast(';base64,');
        Attachment a = new Attachment (ParentId = parId,
                                       Body = EncodingUtil.base64Decode(base64File), 
                                       Name = fileName,
                                       IsPrivate = false);
        Database.SaveResult sr = Database.insert(a,false);
    }

    /*
        Method that sends a message (creates a record of secure messaging) when user clicks on "Send Secure Message" button.
    */

    public PageReference sendMessage() {
        String baseURL =  URL.getSalesforceBaseURL().toExternalForm() + '/';
        secMessageInstance.Related_To__c = caseInstance.Id;
        secMessageInstance.Description__c = strSelectedTemp;
        secMessageInstance.Assigned_To__c = UserInfo.getUserId();
        secMessageInstance.ActivityDate__c = System.today();
        if(caseInstance.Contact.FirstName != null) {
            secMessageInstance.Name__c = caseInstance.ContactId;
        }
        Database.SaveResult sr = Database.insert(secMessageInstance,false);
        if(sr.isSuccess()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, ' A UDB response has been successfully logged'));
            hide();
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ' Cannot send message.'));
        }
        return null;
    }
}