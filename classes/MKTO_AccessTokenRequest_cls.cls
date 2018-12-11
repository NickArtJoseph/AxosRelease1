/***

    Author: René Ayala Medina
    Description: Class to request the Marketo access token
    
    Version Developer             Date          Description
    0.1     René Ayala Medina RAM 06/08/2018    Class created
    0.2     René Ayala Medina RAM 06/08/2018    Building the class
    1.0     René Ayala Medina RAM 06/08/2018    Documentation and testing

***/
public class MKTO_AccessTokenRequest_cls {
	
	/*
		Takes custom metadata type instance and custom setting one. After that, perform the callout through other methods.
	*/

	public static AccessTokenRequestProcessedResponse getAccessToken(){
		Boolean blnMetadataAndCSProvided = false;
		AccessTokenRequestProcessedResponse responseWrappInstance = new AccessTokenRequestProcessedResponse();
		SimpleWSSetttings__mdt autWSSettingsIntance = new SimpleWSSetttings__mdt();
		String strQueryOverWSSettingsCMetaSttmnt = 'SELECT '+String.join(new List<String>(SObjectType.SimpleWSSetttings__mdt.Fields.getMap().keySet()),', ')+' FROM SimpleWSSetttings__mdt WHERE DeveloperName = \'MarketoAuthAccessToken\' limit 1';
		autWSSettingsIntance = Database.query(strQueryOverWSSettingsCMetaSttmnt);
		if(autWSSettingsIntance.Id != null){
			MarketoAuthCreds__c mketoKeysCSInstance = MarketoAuthCreds__c.getInstance();
			if(mketoKeysCSInstance.Name != null && String.isNotBlank(mketoKeysCSInstance.Name)){
				blnMetadataAndCSProvided = true;
				HttpResponse httpResponseInstance = performAuthCallout(autWSSettingsIntance,mketoKeysCSInstance);
				if(httpResponseInstance.getStatusCode() == 200 || httpResponseInstance.getStatusCode() == 201 || httpResponseInstance.getStatusCode() == 202){
					AccessTokenResponse accessTokenWrapperInstance = new AccessTokenResponse();
					try{accessTokenWrapperInstance = (AccessTokenResponse) JSON.deserialize(httpResponseInstance.getBody(), AccessTokenResponse.class);}catch(SerializationException serE){}catch(UnexpectedException uE){}catch(Exception gE){}
					Boolean blnAccessTokenWasProvided = false;
					if(accessTokenWrapperInstance.access_token != null){
						if(String.isNotBlank(accessTokenWrapperInstance.access_token)){
							blnAccessTokenWasProvided = true;
							responseWrappInstance.blnSuccessfulResponse = true;
							responseWrappInstance.strAccessToken = accessTokenWrapperInstance.access_token;
						}
					}
				}else{
					responseWrappInstance.strErrorMsg = 'Status code : '+httpResponseInstance.getStatusCode()+' - '+httpResponseInstance.getBody();
				}
			}
		}
		if(!blnMetadataAndCSProvided){
			responseWrappInstance.strErrorMsg = 'Authentication custom metadata type not found';
		}
		return responseWrappInstance;
	}

	/*
		Perform the callout itself
	*/

	public static HttpResponse performAuthCallout(SimpleWSSetttings__mdt wsConsumptionSettingsInstance, MarketoAuthCreds__c mketoKeysCSInstance){
		HttpResponse httpResponseInstance = new HttpResponse();
		Http httpInstance = new Http();
		HttpRequest httpRequestInstance = new HttpRequest();
		String strEndpointProcessedURI = wsConsumptionSettingsInstance.EndpointURI__c+'?grant_type='+mketoKeysCSInstance.GrantType__c+'&client_id='+mketoKeysCSInstance.ClientId__c+'&client_secret='+mketoKeysCSInstance.ClientSecret__c;
		httpRequestInstance.setEndpoint(strEndpointProcessedURI);
		httpRequestInstance.setMethod(wsConsumptionSettingsInstance.HttpMethod__c);
		if(wsConsumptionSettingsInstance.TimeoutInMiliseconds__c != null){
			httpRequestInstance.setTimeout((Integer)wsConsumptionSettingsInstance.TimeoutInMiliseconds__c);
		}
		try{httpResponseInstance = httpInstance.send(httpRequestInstance);}catch(CalloutException cOExc){}catch(UnexpectedException uE){}catch(Exception gE){}
		return httpResponseInstance;
	}

	/*
		Class to wrapper the processed response
	*/	

	public class AccessTokenRequestProcessedResponse{
		public Boolean blnSuccessfulResponse;
		public String strAccessToken;
		public String strErrorMsg;
		public AccessTokenRequestProcessedResponse(){
			blnSuccessfulResponse = false;
			strAccessToken = '';
			strErrorMsg = '';
		}
	}

	/*
		Class to wrapper the raw response
	*/

	public class AccessTokenResponse{
		public String access_token;
		public String token_type;
		public Integer expires_in;
		public String scope;
		public AccessTokenResponse(){
			access_token = '';
			token_type = '';
			expires_in = null;
			scope = '';
		}
	}

}