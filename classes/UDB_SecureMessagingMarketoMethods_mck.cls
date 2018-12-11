/***

    Author: René Ayala Medina
    Description: Mock class for testing callouts from SFDC (It was created to send alerts using Marketo through UDB)
    
    Version Developer             Date          Description
    0.1     René Ayala Medina RAM 05/02/2018    Class created
    0.2     René Ayala Medina RAM 05/02/2018    Building the class
    1.0     René Ayala Medina RAM 05/03/2018    Documentation and testing

***/

@isTest
global class UDB_SecureMessagingMarketoMethods_mck implements HttpCalloutMock{    
   
    public Integer intCode;
    public String strStatus;
    public String strBody;
    public Map<String, String> mapResponseHeaders;

    /*
        Default constructor
    */

    global UDB_SecureMessagingMarketoMethods_mck(){
        intCode = 404;
        strStatus = 'NOT FOUND';
        strBody = 'NOT FOUND';
        mapResponseHeaders = new Map<String,String>();
    }

    /*
      Constructor.
    */

    global UDB_SecureMessagingMarketoMethods_mck(Integer intCode, String strStatus, String strBody, Map<String, String> mapResponseHeaders) {
        this.intCode = intCode;
        this.strStatus = strStatus; 
        this.strBody = strBody;
        this.mapResponseHeaders = mapResponseHeaders;
    }

    /*
      Method that responses where the callout is perform in test methods
    */

    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        for (String key : this.mapResponseHeaders.keySet()) {
            res.setHeader(key, this.mapResponseHeaders.get(key));
        }
        res.setBody(this.strBody);
        res.setStatusCode(this.intCode);
        res.setStatus(this.strStatus);
        return res;
    }

}