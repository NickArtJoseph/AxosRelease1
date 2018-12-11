@isTest
public class MockHRBResponseGnr8r implements HttpCalloutMock {


    public HTTPResponse respond(HTTPRequest req) {

        //System.assertEquals('PUT', req.getMethod());
        if('PUT'==req.getMethod()){
            String endpt = req.getEndpoint();
            //System.assert(endpt == 'https://bsltst.hrblock.net/ra/confirmapplication' || endpt == 'https://bsl.hrblock.net/ra/confirmapplication');
            //System.assertEquals('https://bsltst.hrblock.net/ra/confirmapplication', req.getEndpoint());
            String appId = req.getHeader('appId');
            System.assertEquals(appId, '1140');
            String auth = req.getHeader('Authorization');
            String exp  = req.getHeader('Expires');
            String jsonBody = req.getBody();
            System.assert(jsonBody.contains('applicationId'));
            System.assert(jsonBody.contains('MOCKTEST_ADVANCE_APPLICATION_ID'));
            System.assert(jsonBody.contains('applicationStatus'));
            System.assert(jsonBody.contains('DCL') || jsonBody.contains('APD'));
            System.assert(jsonBody.contains('requestDate'));
            System.assert(jsonBody.contains('responseDate'));
        }
        
        String contentType = req.getHeader('Content-Type');
        System.assertEquals(contentType,'application/json');
        //

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"applicationId":"MOCKTEST_ADVANCE_APPLICATION_ID"}');
        res.setStatusCode(200);
        return res;
    }

}