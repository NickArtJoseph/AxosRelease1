global class QuickActionAttachmentUpload {

	public QuickActionAttachmentUpload(ApexPages.StandardController stdController) {
	}

   @RemoteAction
   global static void attachFile(String fileName, String parId, String base64File) {
	   base64File = base64File.substringAfterLast(';base64,');
	   Attachment a = new Attachment (ParentId = parId,
	                                   Body = EncodingUtil.base64Decode(base64File), 
	                                   Name = fileName,
	                                   IsPrivate = true);
	   Database.SaveResult sr = Database.insert(a,false);
      if(sr.isSuccess()) {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, ' File Uploaded'));
      }
      else {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ' Error while uploading the file.'));
      }
   }
}