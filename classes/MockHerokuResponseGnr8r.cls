@isTest
public class MockHerokuResponseGnr8r implements HttpCalloutMock {
    // Implement this interface method
    public HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('POST', req.getMethod());
        //System.assertEquals('https://bofi-topdialer-dev.herokuapp.com/applicant', req.getEndpoint());
        String contentType = req.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String jsonBody = req.getBody();            
        //System.assert(jsonBody.contains('Refund_Advance_Application_ID__c'));
        //System.assert(jsonBody.contains('MOCKTEST_ADVANCE_APPLICATION_ID'));
        //System.assert(jsonBody.contains('SSN_TIN__c'));
        //System.assert(jsonBody.contains('000000000'));
            
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/x-www-form-encoded');
        res.setBody('Accepted');
        res.setStatusCode(200);
        return res;
    }

}