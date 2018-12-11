@isTest
private class ApplicationUploadController_Test {

    @isTest
    static void testApplicationUploadController() {
        ApplicationUploadController ctr = new ApplicationUploadController();
        
        System.assert(ctr.getSourceSystemList().size() > 0);
        
        Boolean pass = false;
        ctr.upload();
        for(ApexPages.Message msg : ApexPages.getMessages()) {
            if(msg.getSummary().contains('source system')) {
                pass = true;
            }
        }
        System.assert(pass);
        pass = false;
        
        ctr.sourceSystem = 'meridianlink';
        ctr.upload();
        for(ApexPages.Message msg : ApexPages.getMessages()) {
            if(msg.getSummary().contains('file')) {
                pass = true;
            }
        }
        System.assert(pass);
        pass = false;
        
        String uniqueId = 'test_' + Datetime.now().format('yyyyMMddHHmmss');
        ctr.fileUpload.name = uniqueId + '.test';
        ctr.fileUpload.body = Blob.valueOf(meridianlink_basic_xml);
        ctr.upload();
        for(ApexPages.Message msg : ApexPages.getMessages()) {
            if(msg.getSummary().contains('XML')) {
                pass = true;
            }
        }
        System.assert(pass);
        pass = false;
        
        ctr.fileUpload.name = uniqueId + '.xml';
        Test.startTest();
        ctr.upload();
        System.assertEquals('Queued', ctr.jobStatus);
        Test.stopTest();

        ctr.pollResults();
        
        ctr.startNewUpload();
        System.assertEquals(null, ctr.jobStatus);
        System.assertEquals(null, ctr.JobId);
        System.assertEquals(null, ctr.fileUpload.name);
    }
    
    private static String meridianlink_basic_xml = '<XPRESS_LOAN xmlns="http://www.meridianlink.com/CLF" version="5.150"><APPLICANTS><APPLICANT first_name="TEST" last_name="APPLICANT" d3p1:internal_borrower_id="TestMeridian_' + Datetime.now().format('yyyyMMddHHmmss') + '" xmlns:d3p1="http://www.meridianlink.com/InternalUse"></APPLICANT></APPLICANTS></XPRESS_LOAN>';
}