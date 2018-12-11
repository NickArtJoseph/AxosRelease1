public class HRBRefundAdvanceTriggerHandler extends TriggerHandler {
    private map<Id, HRB_Refund_Advance__c> oldMap;
    private map<Id, HRB_Refund_Advance__c> newMap;
    private list<HRB_Refund_Advance__c> newList;
    public  boolean flag = false;
    
    static final String APPROVE='APD';
    static final String DECLINE='DCL';

    static final String DEV  = 'CS13';
    static final String QA   = 'CS65';
    static final String UAT  = 'CS8';
    static final String PROD = 'NA46';

    static final String BLOCK_PROD_PW = 'Ym9maSMxMjA1I1Byb2Q=';
    static final String BLOCK_LNP_PW = 'Ym9maSNMblA=';
    static final String BLOCK_DEV_PW = 'Ym9maSNRQQ==';


    static final String HRB_TEST_URL = 'https://bsltst.hrblock.net/ra/confirmapplication';
    static final String HRB_LNP_URL = 'https://lnpbesl2.hrblock.com/ra/confirmapplication';
    static final String HRB_PROD_URL = 'https://besl.hrblock.com/ra/confirmapplication';

    static final String HEROKU_DEV_URL = 'https://dev.topdialer.loan/applicant';
    static final String HEROKU_QA_URL = 'https://test.topdialer.loan/applicant';
    static final String HEROKU_UAT_URL = 'https://staging.topdialer.loan/applicant';
    static final String HEROKU_PROD_URL = 'https://api.topdialer.loan/applicant';


    static final String HRB_PW;
    static final String HEROKU_URL;
    static final String HRB_URL;

    static {
        HEROKU_URL = getHerokuURL();
    }
    static {
        HRB_URL = getBlockURL();
    }    
    static {
        HRB_PW = getBlockPW();
    }
    
    public static String getBlockPW(){
        String pw;
        Organization org = [SELECT id, name, instanceName, isSandbox from Organization];
        pw = blockPW(org.instanceName, org.isSandbox);
        return pw;
    }

    public static String blockPW(String instanceName, Boolean isSandbox){
        if (PROD == instanceName || !isSandbox){
            // production
            return BLOCK_PROD_PW;    
        }
        if (DEV == instanceName) {
            //to validate the config in dev before pushing
           //return BLOCK_LNP_PW;
           return BLOCK_DEV_PW;
        }
        if ('CS17' == instanceName) {
            return BLOCK_DEV_PW;
        }
        if (QA == instanceName) {
            return BLOCK_DEV_PW;
        }
        if (UAT == instanceName) {
            return 'DONOTSEND';
            //return BLOCK_DEV_PW;
            //return BLOCK_LNP_PW;
        }
        return BLOCK_PROD_PW;
    }



    public static String blockURL(String instanceName, Boolean isSandbox){
        if (PROD == instanceName || !isSandbox){
            // production
            return HRB_PROD_URL;  
        }
        if (DEV == instanceName) {
           return HRB_TEST_URL;
           //return HRB_LNP_URL;
        }
        if ('CS17' == instanceName) {
            return HRB_TEST_URL;
        }
        if (QA == instanceName) {
            return HRB_TEST_URL;
        }
        if (UAT == instanceName) {
            return HRB_TEST_URL;
            //return HRB_LNP_URL;
        }
        // default will be production
        return HRB_PROD_URL;
    }

    public static String getBlockURL(){
        String url;
        Organization org = [SELECT id, name, instanceName, isSandbox from Organization];
        url = blockURL(org.instanceName, org.isSandbox);
        return url;
    }

    public static String herokuURL(String instanceName, Boolean isSandbox){
        if (PROD == instanceName || !isSandbox){
            // production
            return HEROKU_PROD_URL;    
        }
        if (DEV == instanceName) {
           return HEROKU_DEV_URL;
        }
        if ('CS17' == instanceName) {
            return HEROKU_DEV_URL;
        }
        if (QA == instanceName) {
            return HEROKU_QA_URL;
        }
        if (UAT == instanceName) {
            return HEROKU_UAT_URL;
        }
        // default to prod
        return HEROKU_PROD_URL;
    }

    public static String getHerokuURL(){
        String url;
        Organization org = [SELECT id, name, instanceName, isSandbox from Organization];
        url = herokuURL(org.instanceName, org.isSandbox);
        return url;

    }
///////////////////////////////////
    public HRBRefundAdvanceTriggerHandler() {
        this.oldMap = (map<Id, HRB_Refund_Advance__c>) Trigger.oldMap;
        this.newMap = (map<Id, HRB_Refund_Advance__c>) Trigger.newMap;
        this.newList = (list<HRB_Refund_Advance__c>) Trigger.new;        
    }

    public override void beforeUpdate() {
        retrieveDecisionStatus();
    }
    public override void afterInsert() {
        insertHRBStatus();
    }

    public override void afterUpdate() {
        updateHRBStatus();
    }
    private void setAutoDecisionAt(id HRBRecId, Datetime dt){
        System.debug('Setting AutoDecisionAt');
        System.debug(dt);
        HRBRefundStatus__c status = [select  AutoDecisionAt__c from HRBRefundStatus__c where HRB_Refund_Advance__c =:HRBRecid limit 1];      
        //HRBRefundStatus__c status = [SELECT AutoDecisionAt__c FROM HRBRefundStatus__c WHERE HRB_Refund_Advance__c = :HRBRec];
        if(Null == status.AutoDecisionAt__c){
            status.AutoDecisionAt__c = dt;
            update status;
        }
    }
    private void setManualDecisionAt(id HRBRecId, Datetime dt){

        System.debug('Setting ManualDecisionAt');
        System.debug(dt);        
        HRBRefundStatus__c status = [select  ManualDecisionAt__c from HRBRefundStatus__c where HRB_Refund_Advance__c =:HRBRecId limit 1];      
        //HRBRefundStatus__c status = [SELECT ManualDecisionAt__c FROM HRBRefundStatus__c WHERE HRB_Refund_Advance__c = :HRBRec];
        status.ManualDecisionAt__c = dt;
        update status;
    }
   
    private Boolean appUnsent(id HRBRecId){
        HRBRefundStatus__c HRB_Status = [select HRB_Refund_Advance__r.Refund_Advance_Application_ID__c, HRB_Refund_Advance__r.HRBDecision__c,HRB_Refund_Advance__r.isCompleted__c, HTTPResponseCode__c, CompletedAt__c from HRBRefundStatus__c where HRB_Refund_Advance__c =:HRBRecid ]; 
        Boolean unsent = HRB_Status.HTTPResponseCode__c != 200;
        System.debug('Checking if record ' + HRBRecID +  ' has been sent ' + unsent);
        return unsent;
    }
    
    
    private void retrieveDecisionStatus() {
        list<String> processDecision = new list<String>();
        list<HRB_Refund_Advance__c> setStatus = new list<HRB_Refund_Advance__c>();

        for(HRB_Refund_Advance__c decision : newMap.values()) {        
            if(decision.isCompleted__c == false && decision.Refund_Advance_Application_ID__c != null && decision.SSN_TIN__c != null) {  // this prevents infinite loop and also skips if unusable (no SSN, no ReqID)
                if(decision.HRBDecision__c == null) { // internal & heroku processing
                    if(decision.DecisionBy__c == null || decision.DecisionBy__c.substring(0,3) == 'RDL') {  // Send to Heroku
                        // TBD
                        SendToHeroku(decision.id);
                        System.debug('Send To Heroku');
                    } else {
                        setAutoDecisionAt(decision.id, Datetime.now());                                                       
                        if(decision.DecisionBy__c == 'AUTO') {
                            // AUTO
                            if (isValidDecision(decision.AutoDecision__c)) {
                                decision.HRBDecision__c = decision.AutoDecision__c.toUpperCase();
                                decision.isCompleted__c = true;
                                System.debug('HRB Decision is: ' + decision.HRBDecision__c);                     
                                setStatus.add(decision);
                                System.debug('AUTO');
                            } else {
                                System.debug('Invalid auto decision ' + decision.AutoDecision__c);
                                decision.AutoDecision__c = null;
                            }
                        }
                        else if(decision.DecisionBy__c == 'MANUAL') {
                             // MANUAL
                            if (isValidDecision(decision.ManualDecision__c)) {
                                decision.HRBDecision__c = decision.ManualDecision__c.toUpperCase();
                                decision.ManualDecision__c = decision.ManualDecision__c.toUpperCase();
                                decision.isCompleted__c = true;
                                setManualDecisionAt(decision.id, Datetime.now());
                                setStatus.add(decision);    
                                System.debug('MANUAL');
                            } else {
                                System.debug('Invalid manual decision ' + decision.ManualDecision__c);
                                decision.ManualDecision__c = null;
                            }
                        }
                    }
                } else {
                   //HRBDecision__c != null && decision.isCompleted == false
                   // sendToHRB(); // sets isCompleted = true and CompletedAt = now()                  
                   System.debug('Send To HRB');
                } 
            }
        }
    }

    private void insertHRBStatus() {
        HRBRefundStatus__c s = new HRBRefundStatus__c();
        for(HRB_Refund_Advance__c h : newMap.values()) {
            s.CreatedAt__c = System.now();
            s.Name = 'status-' + h.Name;
            s.HRB_Refund_Advance__c = h.Id;
            s.isCompleted__c = false;
            insert s;
            System.debug('Send to Heroku');
            SendToHeroku(s.HRB_Refund_Advance__c);
        }
    }
    private void updateHRBStatus() {
        list<HRBRefundStatus__c> query = [select Id, HRB_Refund_Advance__c, isCompleted__c, CompletedAt__c from HRBRefundStatus__c where HRB_Refund_Advance__c in: newList];
        list<HRBRefundStatus__c> setCompleted = new list<HRBRefundStatus__c>();
        for(HRB_Refund_Advance__c h : newMap.values()) {
            for(HRBRefundStatus__c s : query) {
                if(isValidDecision(h.HRBDecision__c) && h.Id == s.HRB_Refund_Advance__c) {
                    System.debug('Send To HRB');
                    //s.CompletedAt__c = System.now();
                    //s.isCompleted__c = true;
                    if (appUnsent(h.id)) {
                        System.debug('Unsent sending to HRB');
                        SendToHRB(s.HRB_Refund_Advance__c);
                    }     
                    }
                else {
                    // MANUAL Flow
                    System.debug(s.HRB_Refund_Advance__c);
                    System.debug(h.DecisionBy__c);
                    System.debug('Should be MANUAL');
                }
            }
        }
    }


    @future (callout=true)
    public static void SendToHeroku(id HRBRecid) {
        //Construct HTTP request and response
        //Http request method,Endpoint and setBody
        // Http Request and response refactored by Jaime Terrats
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setHeader('Content-Type','application/json');

        req.setMethod('POST');
        req.setEndpoint(HEROKU_URL); 
       
        // Added by Jaime Terrats to handle status codes and errors.
        try {
            system.debug('HRB Record Id' +HRBRecid);
            //SOQL to construct JSON string in set body
            HRB_Refund_Advance__c HRB_Record=[select Refund_Advance_Application_ID__c,SSN_TIN__c, DecisionBy__C FROM HRB_Refund_Advance__c where id=:HRBRecid];
              system.debug('serialized JSON'+JSON.serialize(HRB_Record));
              String JsonString=JSON.serialize(HRB_Record);
              system.debug(JsonString);
              req.setBody(JsonString); // new line required to fix the Content-Length: 0 problem
              
              res = http.send(req);
        } 
        catch(CalloutException e){
              System.debug('Callout Error: ' + e);
              System.debug(res.toString());
        }      
    }


    //////////////////////////////////////////////////////////////////////////////////////
    // Helper Methods
    //////////////////////////////////////////////////////////////////////////////////////
    private static String utcDateTime(DateTime dtNow ){
        String gmtDateTime = dtNow.format('MM/d/yy h:mm:ss a z','GMT'); 
        system.debug('gmtDateTime--->'+gmtDateTime);
        
        String utcDateTime = gmtDateTime.replace('GMT', 'UTC');
        system.debug('utcDateTime--->'+ utcDateTime);
        return utcDateTime;
    }

    private static String makeAuthStr(DateTime dtNow ){
        String requestType = 'PUT';
        String contentType = 'application/json';
        String endpoint = '/ra/confirmapplication';
        String partnerId = 'bofi';
        //String password = HRB_PW;       
        
        String utcDT = utcDateTime(dtNow);
        
        String canonicalStr = requestType + '\n\n' + contentType + '\n' + utcDT + '\n' + endpoint + '/' + partnerId;
        system.debug('canonicalStr---->'+canonicalStr);
        
        Blob passBase64 = EncodingUtil.base64Decode(HRB_PW);
        system.debug('passBase64--->'+passBase64);
        
        Blob mac = Crypto.generateMac('HMacSHA1', Blob.valueOf(canonicalStr), passBase64);
        system.debug('mac---->'+mac);
        
        String hmacStringBase64 = EncodingUtil.base64Encode(mac);
        system.debug('hmacStringBase64----->'+hmacStringBase64);
        
        String authStr = 'HRB ' + partnerId + ':' + hmacStringBase64;
        system.debug('authStr--->'+authStr);
                
        return authStr;
    }

    public static boolean isValidDecision(String decision){
        return (APPROVE == decision || DECLINE == decision);
    }
    
    private static String mkJsonBody(id HRBRecid, String respDate){
        //HRB_Refund_Advance__c HRB_Record = [select Refund_Advance_Application_ID__c,HRBDecision__c, Date_And_Timestamp_Received__c, (select  CreatedAt__c, CompletedAt__c from HRBRefundStatuses__r limit 1) from HRB_Refund_Advance__c where id =:HRBRecid ];      
        HRBRefundStatus__c HRB_Record = [select HRB_Refund_Advance__r.Refund_Advance_Application_ID__c, HRB_Refund_Advance__r.HRBDecision__c, HRB_Refund_Advance__r.AutoDecision__c, HRB_Refund_Advance__r.ManualDecision__c, AutoDecisionAt__c, CreatedAt__c, CompletedAt__c from HRBRefundStatus__c where HRB_Refund_Advance__c =:HRBRecid ]; 
        if (isValidDecision(HRB_Record.HRB_Refund_Advance__r.HRBDecision__c)){
            String jsonBody;       
            jsonBody = '{\n "applicationId": ' + '"' + HRB_Record.HRB_Refund_Advance__r.Refund_Advance_Application_ID__c +                     
                            '",\n "applicationStatus":' + '"' + HRB_Record.HRB_Refund_Advance__r.HRBDecision__c + 
                            '",\n "requestDate":'+ '"' + HRB_Record.CreatedAt__c.format('yyyy-MM-dd\'T\'hh:mm:ssZ') + 
                            '",\n "responseDate":' + '"' + respDate + 
                            '" \n }';                     
             System.debug('jsonBody---->'+jsonBody);
             return jsonBody;
        } else{
            System.debug('Invalid HRB Decision: ' + HRB_Record.HRB_Refund_Advance__r.HRBDecision__c);
            return '';
        }
    }


    private static void recordResults(id HRBRecId, String req, String respBody, String respStatus, Integer respStatusCode){
        System.debug('updating results for : ' +  + HRBRecId);
        HRBRefundStatus__c status = [select id, Name, HTTPRequest__c, isCompleted__c, CompletedAt__c, HTTPResponseBody__c, HTTPResponseCode__c, HTTPResponseStatus__c from HRBRefundStatus__c where HRB_Refund_Advance__c =:HRBRecid limit 1];      
        status.HTTPRequest__c           = req;
        status.HTTPResponseCode__c      = respStatusCode;
        if (200 == respStatusCode){
          status.HTTPResponseBody__c    = respBody;  
          status.isCompleted__c         = True;
          status.CompletedAt__c         = DateTime.now();
        }        
        status.HTTPResponseStatus__c    = respStatus;
        update status;
    }

//////////////////////////////////////////////////////////////////////////////////////
// Send to HRB
//////////////////////////////////////////////////////////////////////////////////////

    @future (callout=true)  
    public static void SendToHRB(id HRBRecId) {   
        String requestType = 'PUT';
         
        DateTime dtNow = DateTime.now();
        String utcDT = utcDateTime(dtNow);
        String respDT = dtNow.format('yyyy-MM-dd\'T\'hh:mm:ssZ'); 
        String jsonBody = mkJsonBody(HRBRecId, respDT);
        if(1 > jsonBody.length()) {
            System.debug('Invalid JSON:' + jsonBody);
            return;
        }
        String authStr = makeAuthStr(dtNow);

        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type','application/json');
        req.setHeader('appId','1140');
        req.setHeader('Expires', utcDT);
        system.debug('Expires------->'+ req.getHeader('Expires'));
        req.setHeader('Authorization', authStr);
        system.debug('authStr------->'+ req.getHeader('Authorization'));
        req.setMethod(requestType);
        req.setEndpoint(HRB_URL);
        req.setBody(jsonBody);
         
        try {
            Http http = new Http();
            HTTPResponse res = http.send(req);
            String reqInfo = jsonBody;
            String respStatus = res.getStatus();
            Integer respCode = res.getStatusCode();
            String respBody = res.getBody();
             
            System.debug(respStatus);
            System.debug(respCode);
             
            System.debug('updating results for : ' +  + HRBRecId);
            recordResults(HRBRecId, reqInfo, respBody, respStatus, respCode);
        }
        catch(CalloutException e){
              recordResults(HRBRecId, HRB_URL, 'Callout Error: ' + e,'Timeout', 504);
              System.debug('Callout Error: ' + e);
              //System.debug(res.toString());
        }      

   }
}