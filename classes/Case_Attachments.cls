@RestResource(urlMapping='/UDB_Case_Attachments/*')
global with sharing class Case_Attachments {

	@HttpGet
	global static String getAttachment() {
		RestRequest req = RestContext.request;
		String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
		String caseId = req.params.get('id');
		String fileName = req.params.get('file');
		String att;

		Attachment attachment;

		if(caseId != null || caseId != '' && fileName != null || fileName != '') {
			attachment = [select id, Body, Name, CreatedDate from Attachment where ParentId =: caseId and Name =: fileName];
		
			if(attachment != null){
				att = EncodingUtil.base64Encode(attachment.Body);
			}
			else {
				att = 'No Attachment found';
			}
		}
		return att;
	}
}