/***

    Author: René Ayala Medina
    Description: APEX class for the consumption of the web service which sends -through Marketo- alerts when a secure message is created by an agent.
    
    Version Developer             Date          Description
    0.1     René Ayala Medina RAM 04/24/2018    Class created
    0.2     René Ayala Medina RAM 04/24/2018    Building the class
    1.0     René Ayala Medina RAM 06/07/2018    Documentation and testing
    1.1     René Ayala Medina RAM 06/11/2018    Update lead brand

    NOTES: Debug statements are left in this code since this APEX class performs callouts and it is needed to know the responses whenever is needed

***/

global class UDB_SecureMessagingMarketoMethods_cls {

    /*
        Static variables to control the mock WS responses from the test methods
    */

    global static Integer testModeWS0;
    global static Integer testModeWS1;
    global static Integer testModeWS2;
    global static Integer testModeWS3;
    global static Integer testModeWS4;

    global static Boolean blnIsProductiveOrg;
    global static Boolean blnIsProductiveOrgSetTest;
    
    /*
        Invocable method that is called from process builder when a record of UDB_Secure_Messaging__c is created for an agent
    */

    @invocableMethod  (label='Send to UDB Customer an email message from Marketo' description='Sends -to UDB Customers- an email message from Marketo.')
    global static void sendMarketoEmail(List<Id> sMessagesIds){
        if(sMessagesIds != null){
            if(!sMessagesIds.isEmpty()){
                validateIfProductiveEnvironment();
                sendFromMarketoEmail(sMessagesIds,blnIsProductiveOrg);
            }
        }
    }

    /*
        Main method. Perfoms all the invocations to the rest of the methods and does what's necessary to format the request message and perform the callout.
    */

    @future(callout=true)
    global static void sendFromMarketoEmail(List<Id> sMessagesIds, Boolean blnIsProductiveOrg){
        UDB_SecureMessagingMarketoMethods_cls.blnIsProductiveOrg = blnIsProductiveOrg;
        List<UDB_Secure_Messaging__c> lstSecureMessages = new List<UDB_Secure_Messaging__c>();
        List<UDB_Secure_Messaging__c> lstValidSecMsgs = new List<UDB_Secure_Messaging__c>();
        //Query the refered secure messages
        String strQueryOverSecureMessagesSttnbt = 'SELECT '+String.join(new List<String>(SObjectType.UDB_Secure_Messaging__c.Fields.getMap().keySet()),', ')+', Related_To__r.Brand__c FROM UDB_Secure_Messaging__c WHERE Id IN (\''+String.join(new List<Id>(sMessagesIds),'\',\'')+'\')';
        try{lstSecureMessages = Database.query(strQueryOverSecureMessagesSttnbt);}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
        for(UDB_Secure_Messaging__c iterator:lstSecureMessages){
            if(iterator.Name__c != null){
                lstValidSecMsgs.add(iterator);
            }
        }
        for(UDB_Secure_Messaging__c iterator:lstValidSecMsgs){
            //Access token is requested
            AccessTokenResultWrapper accTokenResWrappInstance = getProcessedAccessToken();
            LeadIdQueryResProcWrapper leadQueryProcessedWprInst = new LeadIdQueryResProcWrapper();
            CampaignQueryRespProcWrapper campQueryProcessedWprInst = new CampaignQueryRespProcWrapper();
            TriggerCmpgnRespProcWrapper triggerCampProcessedWprInst = new TriggerCmpgnRespProcWrapper();
            LeadBrandUpdProcWrapper  updateLeadBrandWprInstance = new LeadBrandUpdProcWrapper();
            if(accTokenResWrappInstance.blnIsSuccessful){
                //Lead ID is requested
                leadQueryProcessedWprInst = getLeadId(accTokenResWrappInstance.strAccessToken,iterator);
            }
            if(leadQueryProcessedWprInst.blnIsSuccessful){
                if(leadQueryProcessedWprInst.lngLeadId != null){
                    //Access token is requested
                    accTokenResWrappInstance = getProcessedAccessToken();
                    if(accTokenResWrappInstance.blnIsSuccessful){
                        //Campaign ID is requested
                        campQueryProcessedWprInst = getCampaignId(accTokenResWrappInstance.strAccessToken,leadQueryProcessedWprInst.lngLeadId);
                        if(campQueryProcessedWprInst.blnIsSuccessful){
                            if(campQueryProcessedWprInst.lngCampaignId != null){
                                //Access token is requested
                                accTokenResWrappInstance = getProcessedAccessToken();
                                if(accTokenResWrappInstance.blnIsSuccessful){
                                    //To trigger the Marketo campaign request
                                    if(iterator.Related_To__r.Brand__c != null){
                                        if(String.isNotBlank(iterator.Related_To__r.Brand__c)){
                                            if(!iterator.Related_To__r.Brand__c.equalsIgnoreCase(leadQueryProcessedWprInst.strBrandName) || leadQueryProcessedWprInst.strBrandName == null || String.isBlank(leadQueryProcessedWprInst.strBrandName)){
                                                accTokenResWrappInstance = getProcessedAccessToken();
                                                if(accTokenResWrappInstance.blnIsSuccessful){
                                                    updateLeadBrandWprInstance = updateLeadBrand(accTokenResWrappInstance.strAccessToken,leadQueryProcessedWprInst.lngLeadId,iterator.Related_To__r.Brand__c);
                                                }
                                            }
                                        }
                                    }
                                    triggerCampProcessedWprInst = triggerCampaign(accTokenResWrappInstance.strAccessToken,leadQueryProcessedWprInst.lngLeadId,campQueryProcessedWprInst.lngCampaignId);
                                }                                
                            }                                
                        }
                    }                        
                }
            }
        }
    }

    /*
        Method that validates whether the current environment is sandbox or production
    */

    public static void validateIfProductiveEnvironment(){
        blnIsProductiveOrg = false;
        Organization orgInstance = new Organization();
        try{orgInstance = [SELECT Id, IsSandbox FROM Organization LIMIT 1];}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
        if(orgInstance.Id != null){
            blnIsProductiveOrg = (!Test.isRunningTest())?!orgInstance.IsSandbox:(blnIsProductiveOrgSetTest != null)?blnIsProductiveOrgSetTest:!orgInstance.IsSandbox;
        }
    }

    /*
        Method to get the Lead ID
    */

    public static LeadIdQueryResProcWrapper getLeadId(String strAccessToken, UDB_Secure_Messaging__c uDBSecMsgRecord){
        LeadIdQueryResProcWrapper leadQueryProcessedWprInst = new LeadIdQueryResProcWrapper();
        RequestWrapper reqWrapperInstance = new RequestWrapper();
        String lngLeadIdReqBodyMsg = getLeadIdReqBodyMessage(uDBSecMsgRecord);
        if(String.isNotBlank(lngLeadIdReqBodyMsg)){
            reqWrapperInstance = getRequestWrapper(lngLeadIdReqBodyMsg, Label.UDB_MarketoWSLeadQueryDevName_cl, strAccessToken, new Map<String,String>());
            if(reqWrapperInstance.blnReadyToBeSent){
                //Mock Response is set
                if(Test.isRunningTest()){
                    UDB_SecureMessagingMarketoMethods_mck leadIDMockInstance = new UDB_SecureMessagingMarketoMethods_mck();
                    leadIDMockInstance.intCode = (testModeWS1 == 5)?200:(testModeWS1 == 4)?200:(testModeWS1 == 3)?200:(testModeWS1 == 2)?200:(testModeWS1 == 1)?200:400;
                    leadIDMockInstance.strStatus = (testModeWS1 == 5)?'SUCCESS':(testModeWS1 == 4)?'SUCCESS':(testModeWS1 == 3)?'SUCCESS':(testModeWS1 == 2)?'SUCCESS':(testModeWS1 == 1)?'SUCCESS':'NOT FOUND';
                    leadIDMockInstance.strBody = (testModeWS1 == 5)?'{"requestId": "17f5c#163d686eeb0","result": [{"id": 1284051,"sfdcContactId":"0030H00004mZtYYQA0",'+((blnIsProductiveOrg)?'"'+Label.UDB_MarketoWSUDBBrandAPIFieldProd_cl+'"':'"'+Label.UDB_MarketoWSUDBBrandAPIFieldSndbx_cl+'"')+':"Bank X"}],"success": true}':(testModeWS1 == 4)?'{"requestId": "17f5c#163d686eeb0","errors": [{"code": "601","message":"Access token invalid"}],"success": false}':(testModeWS1 == 3)?'{"requestId": "17f5c#163d686eeb0","errors": [],"success": false}':(testModeWS1 == 2)?'{"requestId": "17f5c#163d686eeb0","result": [],"success": true}':(testModeWS1 == 1)?'{"requestId": "17f5c#163d686eeb0","result": [{"id": 1284051,"sfdcContactId":"0030H00004mZtYYQA0","'+Label.UDB_MarketoWSUDBBrandAPIFieldSndbx_cl+'":null}],"success": true}':'NOT FOUND';
                    leadIDMockInstance.mapResponseHeaders = new Map<String,String>();
                    Test.setMock(HttpCalloutMock.class, leadIDMockInstance);
                }
                HttpResponse leadIdQueryResponse = performCallout(reqWrapperInstance,null);
                if(leadIdQueryResponse.getStatusCode() == 200 || leadIdQueryResponse.getStatusCode() == 201 || leadIdQueryResponse.getStatusCode() == 202){
                    RawResponseLeadIdQueryWpr rawRespWrappInstance = new RawResponseLeadIdQueryWpr();
                    try{rawRespWrappInstance = (RawResponseLeadIdQueryWpr) JSON.deserialize(leadIdQueryResponse.getBody(), RawResponseLeadIdQueryWpr.class);}catch(CalloutException cOExc){}catch(UnexpectedException uE){}catch(Exception gE){}
                    Boolean blnErrorWasSpecified = false; 
                    if(rawRespWrappInstance.success){
                        Boolean blnResultsWereProvided = false;
                        if(rawRespWrappInstance.result != null){
                            if(!rawRespWrappInstance.result.isEmpty()){ // Successful response
                                if(rawRespWrappInstance.result[0].id != null){
                                    blnResultsWereProvided = true; 
                                    leadQueryProcessedWprInst.blnIsSuccessful = true;
                                    leadQueryProcessedWprInst.lngLeadId = rawRespWrappInstance.result[0].id;
                                    String strUDBBrand = '';
                                    if(rawRespWrappInstance.result[0].UDB_Brand != null){
                                        if(String.isNotBlank(rawRespWrappInstance.result[0].UDB_Brand)){
                                            strUDBBrand = rawRespWrappInstance.result[0].UDB_Brand;
                                        }
                                    }
                                    if(rawRespWrappInstance.result[0].UDBBrand != null){
                                        if(String.isNotBlank(rawRespWrappInstance.result[0].UDBBrand)){
                                            strUDBBrand = rawRespWrappInstance.result[0].UDBBrand;
                                        }
                                    }
                                    if(String.isNotBlank(strUDBBrand)){
                                        leadQueryProcessedWprInst.strBrandName = strUDBBrand;
                                    }
                                }
                            }
                        }
                        if(!blnResultsWereProvided){
                            leadQueryProcessedWprInst.strErrorMsg = 'There was an error when requesting the lead ID : Response returned no result records.';
                        }
                    }else if(rawRespWrappInstance.errors != null){  //Errors are specified
                        if(!rawRespWrappInstance.errors.isEmpty()){
                            if(String.isNotBlank(rawRespWrappInstance.errors[0].code)){ 
                                if(rawRespWrappInstance.errors[0].code != null){
                                    if(String.isNotBlank(rawRespWrappInstance.errors[0].message)){
                                        if(rawRespWrappInstance.errors[0].message  != null){
                                            blnErrorWasSpecified = true;
                                            leadQueryProcessedWprInst.strErrorMsg = 'Error code : '+rawRespWrappInstance.errors[0].code+' Error Message : '+rawRespWrappInstance.errors[0].message+'.';
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if(!blnErrorWasSpecified){ //Errors are not specified
                        if(!rawRespWrappInstance.success){
                            leadQueryProcessedWprInst.strErrorMsg = 'There was an unknown error when requesting the lead ID : error not specified by the external endpoint.';
                        }
                    }
                }else{ //Errors are not specified
                    leadQueryProcessedWprInst.strErrorMsg = 'There was an error when requesting the lead ID. Http response status code : '+leadIdQueryResponse.getStatusCode()+'. Http response status : '+leadIdQueryResponse.getStatus()+'.';
                }
            }
        }
        System.debug('leadQueryProcessedWprInst : '+leadQueryProcessedWprInst);
        return leadQueryProcessedWprInst;
    }

    /*
        Method to get the campaign ID
    */

    public static CampaignQueryRespProcWrapper getCampaignId(String strAccessToken, Long lngLeadId){
        CampaignQueryRespProcWrapper campQueryProcessedWprInst = new CampaignQueryRespProcWrapper();
        RequestWrapper reqWrapperInstance = new RequestWrapper();
        String strcampReqBodyMsg = getCampaignIdReqBodyMsg();
        if(String.isNotBlank(strcampReqBodyMsg)){
            reqWrapperInstance = getRequestWrapper(strcampReqBodyMsg, Label.UDB_MarketoWSCampaignQueryDevName_cl, strAccessToken, new Map<String,String>());
            if(reqWrapperInstance.blnReadyToBeSent){
                //Mock Response is set
                if(Test.isRunningTest()){
                        UDB_SecureMessagingMarketoMethods_mck campaignIDMockInstance = new UDB_SecureMessagingMarketoMethods_mck();
                        campaignIDMockInstance.intCode = (testModeWS2 == 4)?200:(testModeWS2 == 3)?200:(testModeWS2 == 2)?200:(testModeWS2 == 1)?200:400;
                        campaignIDMockInstance.strStatus = (testModeWS2 == 4)?'SUCCESS':(testModeWS2 == 3)?'SUCCESS':(testModeWS2 == 2)?'SUCCESS':(testModeWS2 == 1)?'SUCCESS':'NOT FOUND';
                        campaignIDMockInstance.strBody = (testModeWS2 == 4)?'{"requestId":"afcc#163d269f510","errors":[{"code": "601","message":"Access token invalid"}],"success":false}':(testModeWS2 == 3)?'{"requestId": "afcc#163d269f510","errors": [],"success": false}':(testModeWS2 == 2)?'{"requestId": "afcc#163d269f510","result": [],"success": true}':(testModeWS2 == 1)?'{"requestId": "afcc#163d269f510","result": [{"id": 1544,"name": "New Secure Message","type": "trigger","programName": "SFDC Triggers","programId": 1143,"workspaceName": "Default","createdAt": "2018-06-05T22:28:16Z","updatedAt": "2018-06-05T22:29:07Z","active": true}],"success": true}':'NOT FOUND';
                        campaignIDMockInstance.mapResponseHeaders = new Map<String,String>();
                        Test.setMock(HttpCalloutMock.class, campaignIDMockInstance);
                }
                HttpResponse campaignIdQueryResponse = performCallout(reqWrapperInstance,null);
                if(campaignIdQueryResponse.getStatusCode() == 200 || campaignIdQueryResponse.getStatusCode() == 201 || campaignIdQueryResponse.getStatusCode() == 202){
                    RawResposeCampaignQueryWpr rawRespWrappInstance = new RawResposeCampaignQueryWpr();
                    try{rawRespWrappInstance = (RawResposeCampaignQueryWpr) JSON.deserialize(campaignIdQueryResponse.getBody(), RawResposeCampaignQueryWpr.class);}catch(CalloutException cOExc){}catch(UnexpectedException uE){}catch(Exception gE){}
                    Boolean blnErrorWasSpecified = false; 
                    if(rawRespWrappInstance.success){
                        Boolean blnResultsWereProvided = false;
                        if(rawRespWrappInstance.result != null){
                            if(!rawRespWrappInstance.result.isEmpty()){ // Successful response
                                if(rawRespWrappInstance.result[0].id != null){
                                    blnResultsWereProvided = true;
                                    campQueryProcessedWprInst.blnIsSuccessful = true;
                                    campQueryProcessedWprInst.lngCampaignId = rawRespWrappInstance.result[0].id;
                                }
                            }
                        }
                        if(!blnResultsWereProvided){
                            campQueryProcessedWprInst.strErrorMsg = 'There was an unknown error when requesting the campaign ID : Response returned no result records.';
                        }
                    }else if(rawRespWrappInstance.errors != null){ //Errors are specified
                        if(!rawRespWrappInstance.errors.isEmpty()){
                            if(String.isNotBlank(rawRespWrappInstance.errors[0].code)){ 
                                if(rawRespWrappInstance.errors[0].code != null){
                                    if(String.isNotBlank(rawRespWrappInstance.errors[0].message)){
                                        if(rawRespWrappInstance.errors[0].message  != null){
                                            blnErrorWasSpecified = true;
                                            campQueryProcessedWprInst.strErrorMsg = 'Error code : '+rawRespWrappInstance.errors[0].code+' Error Message : '+rawRespWrappInstance.errors[0].message+'.';
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if(!blnErrorWasSpecified){ //Errors are not specified
                        if(!rawRespWrappInstance.success){
                            campQueryProcessedWprInst.strErrorMsg = 'There was an unknown error when requesting the campaign ID : error not specified by the external endpoint.';
                        }
                    }
                }else{ //Response was unsuccessful
                    campQueryProcessedWprInst.strErrorMsg = 'There was an error when requesting the campaign ID. Http response status code : '+campaignIdQueryResponse.getStatusCode()+'. Http response status : '+campaignIdQueryResponse.getStatus()+'.';
                }
            }
        }
        System.debug('campQueryProcessedWprInst : '+campQueryProcessedWprInst);
        return campQueryProcessedWprInst;
    }

    /*
        Method to trigger the campaign (send the email message through Marketo)
    */

    public static TriggerCmpgnRespProcWrapper triggerCampaign(String strAccessToken, Long lngLeadId, Long lngCampaignId){
        TriggerCmpgnRespProcWrapper triggerCampProcessedWprInst = new TriggerCmpgnRespProcWrapper();
        RequestWrapper reqWrapperInstance = new RequestWrapper();
        String strTrigCampReqBodyMsg = getTriggerCampgnReqBodyMsg(lngLeadId);
        if(String.isNotBlank(strTrigCampReqBodyMsg)){
            reqWrapperInstance = getRequestWrapper(strTrigCampReqBodyMsg, Label.UDB_MarketoAlertWSDevName_cl, null, new Map<String,String>{'Content-Type' => 'application/json'});
            if(reqWrapperInstance.blnReadyToBeSent){
                //Mock Response is set
                if(Test.isRunningTest()){
                        UDB_SecureMessagingMarketoMethods_mck triggerCampaignIDMockInstance = new UDB_SecureMessagingMarketoMethods_mck();
                        triggerCampaignIDMockInstance.intCode = (testModeWS3 == 1)?200:(testModeWS3 == 0)?400:(testModeWS3 == 2)?200:(testModeWS3 == 3)?200:(testModeWS3 == 4)?200:400;
                        triggerCampaignIDMockInstance.strStatus = (testModeWS3 == 1)?'SUCCESS':(testModeWS3 == 0)?'NOT FOUND':(testModeWS3 == 2)?'SUCCESS':(testModeWS3 == 3)?'SUCCESS':(testModeWS3 == 4)?'SUCCESS':'NOT FOUND';
                        triggerCampaignIDMockInstance.strBody = (testModeWS3 == 1)?'{"requestId": "12a11#163d6fef910","result": [{"id": 1544}],"success": true}':(testModeWS3 == 0)?'NOT FOUND':(testModeWS3 == 2)?'{"requestId":"c210#163dc1f72a6","success":false,"errors":[{"code":"601","message":"Access token invalid"}]}':(testModeWS3 == 3)?'{"requestId": "12a11#163d6fef910","result": [],"success": true}':(testModeWS3 == 4)?'{"requestId": "afcc#163d269f510","errors": [],"success": false}':'NOT FOUND';
                        triggerCampaignIDMockInstance.mapResponseHeaders = new Map<String,String>();
                        Test.setMock(HttpCalloutMock.class, triggerCampaignIDMockInstance);
                }
                HttpResponse triggerCmpgnQueryResponse = performCallout(reqWrapperInstance,'/'+lngCampaignId+'/trigger.json?access_token='+strAccessToken);
                if(triggerCmpgnQueryResponse.getStatusCode() == 200 || triggerCmpgnQueryResponse.getStatusCode() == 201 || triggerCmpgnQueryResponse.getStatusCode() == 202){
                    RawTriggerCampainResponse rawRespWrappInstance = new RawTriggerCampainResponse();
                    try{rawRespWrappInstance = (RawTriggerCampainResponse) JSON.deserialize(triggerCmpgnQueryResponse.getBody(), RawTriggerCampainResponse.class);}catch(CalloutException cOExc){}catch(UnexpectedException uE){}catch(Exception gE){}
                    Boolean blnErrorWasSpecified = false; 
                    if(rawRespWrappInstance.success){
                        Boolean blnResultsWereProvided = false;
                        if(rawRespWrappInstance.result != null){
                            if(!rawRespWrappInstance.result.isEmpty()){ // Successful response
                                if(rawRespWrappInstance.result[0].id != null){
                                    blnResultsWereProvided = true;
                                    triggerCampProcessedWprInst.blnIsSuccessful = true;
                                    triggerCampProcessedWprInst.strResultId = rawRespWrappInstance.result[0].id;
                                }
                            }
                        }
                        if(!blnResultsWereProvided){
                            triggerCampProcessedWprInst.strErrorMsg = 'There was an unknown error when requesting the triggering of the specified campaign : Response returned no result records.';
                        }
                    }else if(rawRespWrappInstance.errors != null){  //Errors are specified
                        if(!rawRespWrappInstance.errors.isEmpty()){    
                            if(String.isNotBlank(rawRespWrappInstance.errors[0].code)){ 
                                if(rawRespWrappInstance.errors[0].code != null){
                                    if(String.isNotBlank(rawRespWrappInstance.errors[0].message)){
                                        if(rawRespWrappInstance.errors[0].message  != null){
                                            blnErrorWasSpecified = true;
                                            triggerCampProcessedWprInst.strErrorMsg = 'Error code : '+rawRespWrappInstance.errors[0].code+' Error Message : '+rawRespWrappInstance.errors[0].message+'.';
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if(!blnErrorWasSpecified){ //Errors are not specified
                        if(!rawRespWrappInstance.success){
                            triggerCampProcessedWprInst.strErrorMsg = 'There was an unknown error when requesting the triggering of the specified campaign : error not specified by the external endpoint.';
                        }
                    }
                }else{ //Response was unsuccessful
                    triggerCampProcessedWprInst.strErrorMsg = 'There was an error when requesting the triggering of the specified campaign. Http response status code : '+triggerCmpgnQueryResponse.getStatusCode()+'. Http response status : '+triggerCmpgnQueryResponse.getStatus()+'.';
                }
            }
        }
        System.debug('triggerCampProcessedWprInst : '+triggerCampProcessedWprInst);
        return triggerCampProcessedWprInst;
    }

    /*
        Method that updates the Lead brand stored in Marketo if it is not up to date with the brand stored in Salesforce
    */

    public static LeadBrandUpdProcWrapper updateLeadBrand(String strAccessToken, Long lngLeadId, String strBrandName){
        LeadBrandUpdProcWrapper leadBrandUpdProcessedWprInst = new LeadBrandUpdProcWrapper();
        RequestWrapper reqWrapperInstance = new RequestWrapper();
        String strUpdateLeadReqBodyMsg = getUpdateLeadBrandBodyMsg(lngLeadId,strBrandName);
        if(String.isNotBlank(strUpdateLeadReqBodyMsg)){
            reqWrapperInstance = getRequestWrapper(strUpdateLeadReqBodyMsg, Label.UDB_MarketoLeadUpdWSDevName_cl, strAccessToken, new Map<String,String>{'Content-Type' => 'application/json'});
            if(reqWrapperInstance.blnReadyToBeSent){
                //Mock Response is set
                if(Test.isRunningTest()){
                        UDB_SecureMessagingMarketoMethods_mck updateLeadBrandMockInstance = new UDB_SecureMessagingMarketoMethods_mck();
                        updateLeadBrandMockInstance.intCode = (testModeWS4 == 1)?200:(testModeWS4 == 0)?400:(testModeWS4 == 2)?200:(testModeWS4 == 3)?200:(testModeWS4 == 4)?200:400;
                        updateLeadBrandMockInstance.strStatus = (testModeWS4 == 1)?'SUCCESS':(testModeWS4 == 0)?'NOT FOUND':(testModeWS4 == 2)?'SUCCESS':(testModeWS4 == 3)?'SUCCESS':(testModeWS4 == 4)?'SUCCESS':'NOT FOUND';
                        updateLeadBrandMockInstance.strBody = (testModeWS4 == 1)?'{"requestId": "12a11#163d6fef910","result": [{"id": 1544,"status": "updated"}],"success": true}':(testModeWS4 == 0)?'NOT FOUND':(testModeWS4 == 2)?'{"requestId":"c210#163dc1f72a6","success":false,"errors":[{"code":"601","message":"Access token invalid"}]}':(testModeWS4 == 3)?'{"requestId": "12a11#163d6fef910","result": [],"success": true}':(testModeWS4 == 4)?'{"requestId": "afcc#163d269f510","errors": [],"success": false}':'NOT FOUND';
                        updateLeadBrandMockInstance.mapResponseHeaders = new Map<String,String>();
                        Test.setMock(HttpCalloutMock.class, updateLeadBrandMockInstance);
                }
                HttpResponse updateLeadBrandResponse = performCallout(reqWrapperInstance,null);
                if(updateLeadBrandResponse.getStatusCode() == 200 || updateLeadBrandResponse.getStatusCode() == 201 || updateLeadBrandResponse.getStatusCode() == 202){
                    UpdateLeadBrandRawResponse rawRespWrappInstance = new UpdateLeadBrandRawResponse();
                    try{rawRespWrappInstance = (UpdateLeadBrandRawResponse) JSON.deserialize(updateLeadBrandResponse.getBody(), UpdateLeadBrandRawResponse.class);}catch(CalloutException cOExc){}catch(UnexpectedException uE){}catch(Exception gE){}
                    Boolean blnErrorWasSpecified = false; 
                    if(rawRespWrappInstance.success){
                        Boolean blnResultsWereProvided = false;
                        if(rawRespWrappInstance.result != null){
                            if(!rawRespWrappInstance.result.isEmpty()){ // Successful response
                                if(rawRespWrappInstance.result[0].status != null){
                                    if(String.isNotBlank(rawRespWrappInstance.result[0].status)){
                                        if(rawRespWrappInstance.result[0].status.equalsIgnoreCase('updated')){
                                            blnResultsWereProvided = true;
                                            leadBrandUpdProcessedWprInst.blnIsSuccessful = true;
                                            leadBrandUpdProcessedWprInst.strStatus = rawRespWrappInstance.result[0].status;
                                        }
                                    }
                                }
                            }
                        }
                        if(!blnResultsWereProvided){
                            leadBrandUpdProcessedWprInst.strErrorMsg = 'There was an unknown error when requesting the lead brand update : Record in Marketo seems not have being updated.';
                        }
                    }else if(rawRespWrappInstance.errors != null){  //Errors are specified
                        if(!rawRespWrappInstance.errors.isEmpty()){    
                            if(String.isNotBlank(rawRespWrappInstance.errors[0].code)){ 
                                if(rawRespWrappInstance.errors[0].code != null){
                                    if(String.isNotBlank(rawRespWrappInstance.errors[0].message)){
                                        if(rawRespWrappInstance.errors[0].message  != null){
                                            blnErrorWasSpecified = true;
                                            leadBrandUpdProcessedWprInst.strErrorMsg = 'Error code : '+rawRespWrappInstance.errors[0].code+' Error Message : '+rawRespWrappInstance.errors[0].message+'.';
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if(!blnErrorWasSpecified){ //Errors are not specified
                        if(!rawRespWrappInstance.success){
                            leadBrandUpdProcessedWprInst.strErrorMsg = 'There was an unknown error when requesting the lead brand update : error not specified by the external endpoint.';
                        }
                    }
                }else{ //Response was unsuccessful
                    leadBrandUpdProcessedWprInst.strErrorMsg = 'There was an error when requesting the lead brand update. Http response status code : '+updateLeadBrandResponse.getStatusCode()+'. Http response status : '+updateLeadBrandResponse.getStatus()+'.';
                }
            }
        }
        System.debug('leadBrandUpdProcessedWprInst : '+leadBrandUpdProcessedWprInst);
        return leadBrandUpdProcessedWprInst;
    }

    /*      
        Method to request the access token to consume Marketo's web services
    */

    public static AccessTokenResultWrapper getProcessedAccessToken(){
        //Mock Response is set
        if(Test.isRunningTest()){
            UDB_SecureMessagingMarketoMethods_mck tokenRequestMockInstance = new UDB_SecureMessagingMarketoMethods_mck();
            tokenRequestMockInstance.intCode = (testModeWS0 == 0)?400:(testModeWS0 == 1)?200:400;
            tokenRequestMockInstance.strStatus = (testModeWS0 == 0)?'NOT FOUND':(testModeWS0 == 1)?'SUCCESS':'NOT FOUND';
            tokenRequestMockInstance.strBody = (testModeWS0 == 0)?'NOT FOUND':(testModeWS0 == 1)?'{"access_token": "defd853e-912c-43fa-a1bf-c319174031d5:sj","token_type": "bearer","expires_in": 1473,"scope": "salesforcesupport@bofifederalbank.com"}':'NOT FOUND';
            tokenRequestMockInstance.mapResponseHeaders = new Map<String,String>();
            Test.setMock(HttpCalloutMock.class, tokenRequestMockInstance);
        }
        //Access token processed wrapper instance is filled out
        AccessTokenResultWrapper accTokenResWrappInstance = new AccessTokenResultWrapper();
        MKTO_AccessTokenRequest_cls.AccessTokenRequestProcessedResponse cOutWrappedResponseInstance = MKTO_AccessTokenRequest_cls.getAccessToken();
        if(cOutWrappedResponseInstance.blnSuccessfulResponse){
            if(cOutWrappedResponseInstance.strAccessToken != null){
                if(String.isNotBlank(cOutWrappedResponseInstance.strAccessToken)){
                    accTokenResWrappInstance.blnIsSuccessful = true;
                    accTokenResWrappInstance.strAccessToken = cOutWrappedResponseInstance.strAccessToken;
                }
            }
        }
        System.debug('accTokenResWrappInstance : '+accTokenResWrappInstance);
        return accTokenResWrappInstance;
    }


    /*
        Method that fills the wrapper that contains the resources needed to perfom the callout. It takes data from an specific custom metadata type.
    */

    global static RequestWrapper getRequestWrapper(String strBodyMsg, String strWSSettingsDevName, String strAccessToken, Map<String,String> mapExtraHdrs){
        RequestWrapper reqWrapperInstance = new RequestWrapper();
        //A query to the proper custom metadata type is performed
        String strQueryOverWSSettings = 'SELECT '+String.join(new List<String>(SObjectType.SimpleWSSetttings__mdt.Fields.getMap().keySet()),', ')+' FROM SimpleWSSetttings__mdt WHERE DeveloperName = \''+strWSSettingsDevName+'\' LIMIT 1';
        SimpleWSSetttings__mdt settingsInstance = new SimpleWSSetttings__mdt();
        try{settingsInstance = Database.query(strQueryOverWSSettings);}catch(QueryException qE){}catch(UnexpectedException uE){}catch(Exception gE){}
        if(settingsInstance.Id != null){
            //Wrapper is filled out
            reqWrapperInstance.strEndpointURL = settingsInstance.EndpointURI__c;
            reqWrapperInstance.strBodyMessage = strBodyMsg;
            reqWrapperInstance.mapHeaders = new Map<String,String>();
            if(strAccessToken != null){
                if(String.isNotBlank(strAccessToken)){
                    reqWrapperInstance.mapHeaders.put('Authorization','Bearer '+strAccessToken);
                }
            }
            for(String iterator:mapExtraHdrs.keySet()){
                reqWrapperInstance.mapHeaders.put(iterator,mapExtraHdrs.get(iterator));
            }
            if(settingsInstance.TimeoutInMiliseconds__c != null){
                reqWrapperInstance.intTimeout = (Integer)settingsInstance.TimeoutInMiliseconds__c;
            }
            reqWrapperInstance.strHTTPMethod = settingsInstance.HttpMethod__c;
            reqWrapperInstance.blnReadyToBeSent = true;
        }
        return reqWrapperInstance;
    }

    /*
        Method that creates the body message from the secure messages to request the lead ID.
    */

    global static String getLeadIdReqBodyMessage(UDB_Secure_Messaging__c secureMessageInstance){
        String strBodyMsg = '';
        strBodyMsg = '?filterType=sfdcContactId&filterValues='+secureMessageInstance.Name__c+'&fields=id,'+((blnIsProductiveOrg)?Label.UDB_MarketoWSUDBBrandAPIFieldProd_cl:Label.UDB_MarketoWSUDBBrandAPIFieldSndbx_cl)+',sfdcContactId';
        System.debug('strBodyMsg : '+strBodyMsg);
        return strBodyMsg;
    }

    /*
        Method that creates the body message from the secure messages to request the campaign ID.
    */

    global static String getCampaignIdReqBodyMsg(){
        String strBodyMsg = '?name='+Label.UDB_SecureMessageAlertMktoCampaignName_cl;
        System.debug('strBodyMsg : '+strBodyMsg);  
        return strBodyMsg;
    }

    /*
        Method that creates the body message from the secure messages to request the campaign to be triggered.
    */

    global static String getTriggerCampgnReqBodyMsg(Long lngLeadId){
        String strBodyMsg = '';
        Map<String,Object> mapRequestStructure = new Map<String,Object>{
            'input' => new Map<String,Object>{
                'leads' => new List<Object>{
                    new Map<String,Object>{
                        'id' => lngLeadId
                    }
                }
            }
        };
        try{strBodyMsg = JSON.serialize(mapRequestStructure);}catch(SerializationException serE){}catch(UnexpectedException uE){}catch(Exception gE){}
        System.debug('strBodyMsg : '+strBodyMsg);
        return strBodyMsg;
    }

    /*
        Method that creates the body message from the secure messages to request the campaign to be triggered.
    */

    global static String getUpdateLeadBrandBodyMsg(Long lngLeadId, String strBrandName){
        String strBodyMsg = '';
        Map<String,Object> mapRequestStructure = new Map<String,Object>{
            'action' => 'updateOnly',
            'lookupField' => 'id',
            'input' => new List<Object>{
                new Map<String,Object>{
                    'id' => lngLeadId,
                    (blnIsProductiveOrg)?Label.UDB_MarketoWSUDBBrandAPIFieldProd_cl: Label.UDB_MarketoWSUDBBrandAPIFieldSndbx_cl => strBrandName
                }
            }
        };
        try{strBodyMsg = JSON.serialize(mapRequestStructure);}catch(SerializationException serE){}catch(UnexpectedException uE){}catch(Exception gE){}
        System.debug('strBodyMsg : '+strBodyMsg);
        return strBodyMsg;
    }



    /*
        Method that perform the callout based on the resulting wrapper instance (already filled with the needed values and resources)
    */

    global static HttpResponse performCallout(RequestWrapper reqWrapperInstance, String strURLComplement){
        Http httpInstance = new Http();
        HttpRequest requestInstance = new HttpRequest();
        requestInstance.setMethod(reqWrapperInstance.strHTTPMethod);
        if(requestInstance.getMethod() == 'POST'){    
            requestInstance.setEndpoint(reqWrapperInstance.strEndpointURL + (String)((strURLComplement != null && String.isNotBlank(strURLComplement))?strURLComplement:''));
            requestInstance.setBody(reqWrapperInstance.strBodyMessage);
        }else if(requestInstance.getMethod() == 'GET'){
            requestInstance.setEndpoint(reqWrapperInstance.strEndpointURL+reqWrapperInstance.strBodyMessage);
        }
        for(String iterator:reqWrapperInstance.mapHeaders.keySet()){
            requestInstance.setHeader(iterator,reqWrapperInstance.mapHeaders.get(iterator));
        }
        requestInstance.setTimeout(reqWrapperInstance.intTimeout);
        HttpResponse responseInstance = null;
        try{responseInstance = httpInstance.send(requestInstance);}catch(CalloutException cOExc){}catch(UnexpectedException uE){}catch(Exception gE){}
        if(responseInstance != null){
            System.debug('Response body message : '+responseInstance.getBody());
        }
        return responseInstance;
    }

    /*
        Wrapper class that stores the necessary data and resources to perform a callout
    */

    global class RequestWrapper{
        global String strEndpointURL;
        global String strBodyMessage;
        global Map<String,String> mapHeaders;
        global Integer intTimeout;
        global String strHTTPMethod;
        global Boolean blnReadyToBeSent;
        global RequestWrapper(){
            strEndpointURL = '';
            strBodyMessage = '';
            mapHeaders = new Map<String,String>();
            intTimeout = 120000;
            strHTTPMethod = 'GET';
            blnReadyToBeSent = false;
        }
    }

    /*
        Class to deserialize the "Campaign ID" WS response.
    */

    global class RawResposeCampaignQueryWpr{
        global String requestId;
        global Boolean success;
        global List<CampaignQueryResult> result;
        global List<WSError> errors;
        global RawResposeCampaignQueryWpr(){
            requestId = '';
            success = false;
            result = new List<CampaignQueryResult>();
            errors = new List<WSError>();
        }
    }

    /*
        Class to deserialize the "Campaign ID" WS response.
    */

    global class CampaignQueryResult{
        global Long id;
        global String name;
        global String description;
        global String type;
        global String programName;
        global String programId;
        global String workspaceName;
        global Datetime createdAt;
        global Datetime updatedAt;
        global Boolean active;
        global CampaignQueryResult(){
            id = null;
            name = '';
            description = '';
            type = '';
            programName = '';
            programId = '';
            workspaceName = '';
            createdAt = null;
            updatedAt = null;
            active = false;
        }
    }

    /*
        Class to wrapper the processed response from the "Campaign ID" web service.
    */

    global class CampaignQueryRespProcWrapper{
        global Boolean blnIsSuccessful;
        global Long lngCampaignId;
        global String strErrorMsg;
        global CampaignQueryRespProcWrapper(){
            blnIsSuccessful = false;
            lngCampaignId = null;
            strErrorMsg = '';
        }
    }

    /*
        Class to deserialize the "Lead ID" WS response.
    */

    global class RawResponseLeadIdQueryWpr{
        global Boolean success;
        global String requestId;
        global List<WSError> errors;
        global List<LeadIdResult> result;
        global RawResponseLeadIdQueryWpr(){
            success = false;
            requestId = '';
            errors = new List<WSError>();
            result = new List<LeadIdResult>();
        }
    }

    /*
        Class to deserialize the "Lead ID" WS response.
    */

    global class LeadIdResult{
        global Long id;
        global String UDBBrand;
        global String UDB_Brand;
        global String sfdcContactId;
        global LeadIdResult(){
            id = null;
            UDBBrand = '';
            UDB_Brand = '';
            sfdcContactId = '';
        }
    }

    /*
        Class to wrapper the processed response from the "Lead ID" web service.
    */

    global class LeadIdQueryResProcWrapper{
        global Boolean blnIsSuccessful;
        global Long lngLeadId;
        global String strBrandName;
        global String strErrorMsg;
        global LeadIdQueryResProcWrapper(){
            blnIsSuccessful = false;
            lngLeadId = null;
            strBrandName = '';
            strErrorMsg = '';
        }
    }

    /*
        Class to deserialize the "Trigger Campaign" WS response.
    */

    global class RawTriggerCampainResponse{
        global String requestId;
        global Boolean success;
        global List<TriggerCampaignResult> result;
        global List<WSError> errors;
        global RawTriggerCampainResponse(){
            requestId = '';
            result = new List<TriggerCampaignResult>();
            success = false;
            errors = new List<WSError>();
        } 
    }

    /*
        Class to deserialize the "Trigger Campaign" WS response.
    */

    global class TriggerCampaignResult{
        global Long id;
        global TriggerCampaignResult(){
            id = null;
        }
    }

    /*
        Class to wrapper the processed response of "Trigger Campaign" web service.
    */

    global class TriggerCmpgnRespProcWrapper{
        global Boolean blnIsSuccessful;
        global Long strResultId;
        global String strErrorMsg;
        global TriggerCmpgnRespProcWrapper(){
            blnIsSuccessful = false;
            strResultId = null;
            strErrorMsg = '';
        }
    }

    /*
        Wraps the raw response for the "Update lead brand" WS
    */

    global class UpdateLeadBrandRawResponse{
        global String requestId;
        global List<UpdtLeadReslt> result;
        global Boolean success;
        global List<WSError> errors;
        global UpdateLeadBrandRawResponse(){
            requestId = '';
            result = new List<UpdtLeadReslt>();
            success = false;
            errors = new List<WSError>();
        }
    }

    /*
        Wrapps the raw response result structure for the "Update lead brand" WS
    */

    global class UpdtLeadReslt{
        global Long id;
        global String status;
        global UpdtLeadReslt(){
            id = null;
            status = ''; 
        }
    }

    /*
        Wrapps the processed respons of the "Update lead brand" WS
    */

    global class LeadBrandUpdProcWrapper{
        global Boolean blnIsSuccessful;
        global String strStatus;
        global String strErrorMsg;
        global LeadBrandUpdProcWrapper(){
            blnIsSuccessful = false;
            strStatus = '';
            strErrorMsg = '';
        }
    }

    /*
        Class to wrapper the processed response of "Access Token" web service.
    */

    global class AccessTokenResultWrapper{
        global Boolean blnIsSuccessful;
        global String strAccessToken;
        global AccessTokenResultWrapper(){
            blnIsSuccessful = false;
            strAccessToken = '';
        }
    }

    /*
        Class to deserialize the error structure when web services indicates exceptions
    */

    global class WSError{
        global String code;
        global String message;
        global WSError(){
            code = '';
            message = '';
        }
    }

}