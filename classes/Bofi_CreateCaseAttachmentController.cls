@RestResource(urlMapping='/Bofi_CreateCaseAttachment/*')
global with sharing class Bofi_CreateCaseAttachmentController {

    private class CaseDetail {
        Id CaseIdForAttach;
    }
    private class Attach {
        String Body;
        String ContentType;
        String Name;
    }
    private class casedetails {
        CaseDetail casedetails;
        list<Attach> attachments;
    } 

    @HttpPost
    global static String doPost() {
        //json will be taken directly from RestContext
        system.debug('RestContext.request---->'+RestContext.request);
        system.debug('RestContext.requestrequestBody---->'+RestContext.request.requestBody);
        
        CaseDetails container = (CaseDetails)System.JSON.deserialize(
            RestContext.request.requestBody.tostring(), 
            CaseDetails.class);
    system.debug('container  --->'+container );
        Id CaseIds = container.casedetails.CaseIdForAttach;
          system.debug('case Id --->'+CaseIds);
     
        list<attachment> attachmentToInsert = new list<attachment>();
    
        for (Attach att :container.attachments) {
            attachmentToInsert.add(
                new Attachment(parentId = CaseIds, name = att.name, 
                               ContentType = att.ContentType, 
                               Body = EncodingUtil.base64Decode(att.body)));
        }
        insert attachmentToInsert;
    
        if (attachmentToInsert != null){
                        return 'An Attachment Records Created in SF For the Requested Case Id :--'+CaseIds;
            }
            else{
            return 'No Attachment Records Created in SF For the Requested Case Id :--'+CaseIds;
            }   
    }
}