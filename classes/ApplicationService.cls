/**
* @description <p>RESTful web service that allows external systems to send an Applicant XML file
* for processing</p>
* @author Mike Crosby, BofI Federal 
*/
@RestResource(urlMapping='/Application/v1/*')
global with sharing class ApplicationService {

	/**
	* POST method exposed as web service; assumption is that file will be attached in body of
	* request
	*/
    @HttpPost
    global static void uploadXml() {
        try{
            RestRequest req = RestContext.request;
            RestResponse resp = RestContext.response;
            String source = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            Boolean isTest = false;
            //for testing purposes, "/test" is expected in the request
            if(source == 'test') {
            	System.debug('**** Web service test has been initiated');
                isTest = true;
                String tmpVal = req.requestURI.substring(0, req.requestURI.lastIndexOf('/'));
                source = tmpVal.substring(tmpVal.lastIndexOf('/')+1);
            }
            System.debug('**** Web service called by ' + source);
            //extract file attachment
            Blob fileAttach = req.requestBody;
            String contentDisp = req.headers.get('Content-Disposition');
            System.debug('**** Content Disposition: ' + contentDisp);
            String fileName = contentDisp.substring(contentDisp.indexOf('"')+1, contentDisp.lastIndexOf('"'));
            ApplicationServiceHandler hdl = new ApplicationServiceHandler(source, fileName, fileAttach);
            if(isTest) {
                hdl.isTest = true;
            }
            //submit job
            Id jobId = System.enqueueJob(hdl);
            System.debug('**** Job Id enqueued: ' + jobId);
        } catch (Exception e) {
            ApplicationServiceHandler hdl = new ApplicationServiceHandler();
            hdl.handleError(e, 'ApplicationService', null);
        }
    }

}