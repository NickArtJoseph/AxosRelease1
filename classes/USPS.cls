/**
* Code developed externally by Anthony Coleman: https://github.com/colemab/SFDC_USPS-Component
*/
public with sharing class USPS {	
	public static final String CALLOUT_ERROR_CODE = '-2';
	
	private static string BuildAddressQueryURLString(USPS.USPSAddress AddressToQuery, string USPS_UID) { 
				
		// this function is coded to send only one address at a time
		// but it could be updated to support more (10 is the max ATM) by
		// iterating over addresses and incremending the address ID XML for each address 
		// until you have one large URL as your query.
		
		// However, if you do modify this for mutiple addresses then you will need to
		// re-write the XML parse to handle that as well.  
		
		String BaseURL = 'http://production.shippingapis.com/ShippingAPI.dll?API=Verify&XML=';
		String ReturnValue = '<AddressValidateRequest USERID="' + USPS_UID + '"><Address ID="0">';
		
		ReturnValue += '<Address1>' + AddressToQuery.Address1 + '</Address1>';
		ReturnValue += '<Address2>' + AddressToQuery.Address2 + '</Address2>';
		ReturnValue += '<City>' + AddressToQuery.City + '</City>';
		ReturnValue += '<State>' + AddressToQuery.State + '</State>';
		ReturnValue += '<Zip5>' + AddressToQuery.Zip5 + '</Zip5>';
		ReturnValue += '<Zip4>' + AddressToQuery.Zip4 + '</Zip4>';		
		ReturnValue += '</Address></AddressValidateRequest>';
		
		ReturnValue = EncodingUtil.urlEncode(ReturnValue, 'UTF-8');
		
		ReturnValue = BaseURL + ReturnValue; 
		
		return ReturnValue;
		
	} // BuildAddressQueryURLString

	private static string GetStandardizedAddressFromUSPS(string USPSURLtoQuery) {

			 string ReturnValue = '';

			// winter 13 added support for testing http callouts via a mock class
			// if you are not running this on winter 13 or later you will need
			// to modify your code to get test coverage
			 if (Test.IsRunningTest()) {
				 Test.setMock(HttpCalloutMock.class, new USPSHttpCalloutMock());
			 }			 
			 
	         HttpRequest USPSRequest = new HttpRequest();
	         Http USPSHttp = new Http();
	         
	         USPSRequest.setMethod('GET');
	         
	         USPSRequest.setEndpoint(USPSURLtoQuery);

			 try {
             	HttpResponse USPSResponse = USPSHttp.send(USPSRequest);
             	ReturnValue = USPSResponse.getBody();
			 } catch(Exception ex) {
			 	//MCC 11/17/2015
			 	//handle callout issues in a friendly manner
			 	ReturnValue = '<CALLOUTERROR>';
			 }  
		
			 system.debug('XML Response was: ' + ReturnValue);
			 system.debug('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-');
			 
			 return ReturnValue;
		
	} // GetStandardizedAddressFromUSPS
	
	private static USPS.USPSAddress ParseUSPSResponseXML(String XMLToParse) {
		USPS.USPSAddress ReturnAddress = new USPS.USPSAddress();

		// parse the response
		XMLStreamReader USPSXMLReader = new XMLStreamReader(XMLToParse);
		
		while (USPSXMLReader.hasNext()) {

	         if (USPSXMLReader.getEventType() == XmlTag.START_ELEMENT) {

	            if ('AddressValidateResponse' == USPSXMLReader.getLocalName()) {
	            		            	
	            	USPSXMLReader.next();
	            	
		            if ('Address' == USPSXMLReader.getLocalName()) {
		            	ReturnAddress = ParseUSPSAddressXML(USPSXMLReader);
		            } // <Address ID="0"> tag
		            
	            } // <AddressValidateResponse> confirmation
	         } // Starting tag        
			
			USPSXMLReader.next();
	         		
		} // loop thru UPS XML Reader

		if (ReturnAddress.HasData() == false) {
			// if parsing comes back totally blank then indicate an unknown / parsing error to the caller / requestor
			system.Debug('ReturnAddress.HasData() == false');
			ReturnAddress.USPS_Returned_Error = true;
			ReturnAddress.USPS_ERROR_DESC = 'Unknown Error parsing XML Response';
			ReturnAddress.USPS_ERROR_SOURCE = 'Salesforce XML Parsing';
			ReturnAddress.USPS_ERROR_CODE = '-1';
		} // ReturnAddress.HasData() == false

		return ReturnAddress;
	} // ParseAddressXML
	
	private static USPS.USPSAddress ParseUSPSAddressXML(XMLStreamReader USPSAddressXMLReader) {
		USPS.USPSAddress ReturnAddress = new USPS.USPSAddress();
		
		while(USPSAddressXMLReader.hasNext()) {
	        if (USPSAddressXMLReader.getEventType() == XmlTag.END_ELEMENT) {
	        	if ('Address' == USPSAddressXMLReader.getLocalName()) {
	        		// quit parsing when we hit the end of this record	        	
		           break;
	        	} // check for address ending tag
	        } else if ('Error' == USPSAddressXMLReader.getLocalName()) {
	        	system.Debug('API Returned an error!');
	        	
	        	ReturnAddress = ParseUSPSErrorXML(USPSAddressXMLReader);
	        	ReturnAddress.USPS_Returned_Error = true;
	        } else if ('Address1' == USPSAddressXMLReader.getLocalName()) {
	        	
	        	USPSAddressXMLReader.next();
	        	
	        	if (USPSAddressXMLReader.getEventType() == XmlTag.CHARACTERS) {
	        		system.Debug('Address1: ' +  USPSAddressXMLReader.getText());	        	
        			ReturnAddress.Address1 = USPSAddressXMLReader.getText();
	        	} // check for data
	        } else if ('Address2' == USPSAddressXMLReader.getLocalName()) {
	        	
	        	USPSAddressXMLReader.next();
	        	
	        	if (USPSAddressXMLReader.getEventType() == XmlTag.CHARACTERS) {
	        		system.Debug('Address2: ' +  USPSAddressXMLReader.getText());	        	
	        		ReturnAddress.Address2 = USPSAddressXMLReader.getText();
	        	} // check for data
	        } else if ('City' == USPSAddressXMLReader.getLocalName()) {
	        	
	        	USPSAddressXMLReader.next();
	        	
	        	if (USPSAddressXMLReader.getEventType() == XmlTag.CHARACTERS) {
	        		system.Debug('City: ' +  USPSAddressXMLReader.getText());	        	
	        		ReturnAddress.City = USPSAddressXMLReader.getText();
	        	} // check for data
	        } else if ('State' == USPSAddressXMLReader.getLocalName()) {
	        	
	        	USPSAddressXMLReader.next();
	        	
	        	if (USPSAddressXMLReader.getEventType() == XmlTag.CHARACTERS) {
	        		system.Debug('State: ' +  USPSAddressXMLReader.getText());	        	
	        		ReturnAddress.State = USPSAddressXMLReader.getText();
	        	} // check for data
	        } else if ('Zip5' == USPSAddressXMLReader.getLocalName()) {
	        	
	        	USPSAddressXMLReader.next();
	        	
	        	if (USPSAddressXMLReader.getEventType() == XmlTag.CHARACTERS) {
	        		system.Debug('Zip5: ' +  USPSAddressXMLReader.getText());	        	
	        		ReturnAddress.Zip5 = USPSAddressXMLReader.getText();
	        	} // check for data
	        } else if ('Zip4' == USPSAddressXMLReader.getLocalName()) {
	        	
	        	USPSAddressXMLReader.next();
	        	
	        	if (USPSAddressXMLReader.getEventType() == XmlTag.CHARACTERS) {
	        		system.Debug('Zip4: ' +  USPSAddressXMLReader.getText());	        	
	        		ReturnAddress.Zip4 = USPSAddressXMLReader.getText();
	        	} // check for data
	        	        		        	
	        } // check for end tags
	        
	        USPSAddressXMLReader.next();
	        
	     } // loop thru XML reader
		
		return ReturnAddress;		
	} // ParseUSPSAddressXML
	
	private static USPS.USPSAddress ParseUSPSErrorXML(XMLStreamReader USPSErrorXMLReader) {

		USPS.USPSAddress ReturnAddress = new USPS.USPSAddress();
		
		while(USPSErrorXMLReader.hasNext()) {
	        if (USPSErrorXMLReader.getEventType() == XmlTag.END_ELEMENT) {
	        	if ('Error' == USPSErrorXMLReader.getLocalName()) {
		        	// quit parsing when we hit the end of this record
		           	break;
	        	}
	        } else if ('Number' == USPSErrorXMLReader.getLocalName()) {
	        	
	        	USPSErrorXMLReader.next();
	        	
	        	if (USPSErrorXMLReader.getEventType() == XmlTag.CHARACTERS) {
	        		system.Debug('Error Number / Code: ' +  USPSErrorXMLReader.getText());	        	
	        		ReturnAddress.USPS_ERROR_CODE = USPSErrorXMLReader.getText();
	        	} // check for data
	        } else if ('Source' == USPSErrorXMLReader.getLocalName()) {
	        	
	        	USPSErrorXMLReader.next();
	        	
	        	if (USPSErrorXMLReader.getEventType() == XmlTag.CHARACTERS) {
	        		system.Debug('Error Source: ' + USPSErrorXMLReader.getText());	        	
	        		ReturnAddress.USPS_ERROR_SOURCE = USPSErrorXMLReader.getText();
	        	} // check for data
	        } else if ('Description' == USPSErrorXMLReader.getLocalName()) {
	        	
	        	USPSErrorXMLReader.next();
	        	
	        	if (USPSErrorXMLReader.getEventType() == XmlTag.CHARACTERS) {
	        		system.Debug('Error Description: ' + USPSErrorXMLReader.getText());	        	
	        		ReturnAddress.USPS_ERROR_DESC = USPSErrorXMLReader.getText();
	        	} // check for data
	        	
	        } // check for ending element
	        
	        USPSErrorXMLReader.next();
	        
	     } // loop thru XML reader
		
		return ReturnAddress;		

		
	} // ParseUSPSErrorXML
	
	public static USPS.USPSAddress CheckAddress(USPS.USPSAddress Address2Check, string USERID) {

		USPS.USPSAddress ResponseAddress = new USPS.USPSAddress();
		
		// build the URL for the API call		
		string USPSURL = BuildAddressQueryURLString(Address2Check, USERID);

		// call the API and pullback the XML as a string
		string XMLResponse = GetStandardizedAddressFromUSPS(USPSURL);
		
		if(XMLResponse == '<CALLOUTERROR>') {
			//MCC 11/17/2015
			//Handle callout issues in a friendly manner
			ResponseAddress = new USPSAddress();
			system.Debug('<CALLOUTERROR> == true');
			ResponseAddress.USPS_Returned_Error = true;
			ResponseAddress.USPS_ERROR_DESC = 'An error occurred while communicating with the USPS address verification service. Please try again later.';
			ResponseAddress.USPS_ERROR_SOURCE = 'Salesforce Communication with USPS';
			ResponseAddress.USPS_ERROR_CODE = USPS.CALLOUT_ERROR_CODE;
		} else {
			// send the XML reponse to the parser
			ResponseAddress = ParseUSPSResponseXML(XMLResponse);
		}
		
		/*
		system.debug('-=-=-=-=-=-=- Results -=-=-=-=-=-=-');
		system.debug('Address1: ' + ResponseAddress.Address1);
		system.debug('Address2: ' + ResponseAddress.Address2);
		system.debug('City: ' + ResponseAddress.City);
		system.debug('State: ' + ResponseAddress.State);
		system.debug('Zip5: ' + ResponseAddress.Zip5);
		system.debug('Zip4: ' + ResponseAddress.Zip4);
		
		if (ResponseAddress.USPS_Returned_Error == true) {
			system.debug('USPS_ERROR_CODE: ' + ResponseAddress.USPS_ERROR_CODE);
			system.debug('USPS_ERROR_DESC: ' + ResponseAddress.USPS_ERROR_DESC);
			system.debug('USPS_ERROR_SOURCE: ' + ResponseAddress.USPS_ERROR_SOURCE);
		} // check for error code
		
		system.debug('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-');		
		
		system.debug('-=-=-=-=-=-=- Searched -=-=-=-=-=-=-');
		system.debug('Address1: ' + Address2Check.Address1);
		system.debug('Address2: ' + Address2Check.Address2);
		system.debug('City: ' + Address2Check.City);
		system.debug('State: ' + Address2Check.State);
		system.debug('Zip5: ' + Address2Check.Zip5);
		system.debug('Zip4: ' + Address2Check.Zip4);
		system.debug('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-');		
		*/
		
		return ResponseAddress;
		
	} // CheckAddress
		
	public class USPSAddress {
		
		// in the USPS world, address 1 contains address 2 data (i.e. UNIT 101 or APT A)
		// So you will need to put the actual street address in address2 for proper parsing
		public string Address1 {get; set;}
		public string Address2 {get; set;}
		public string City {get; set;}
		public string State {get; set;}
		public string Zip5 {get; set;}
		public string Zip4 {get; set;}
		
		public boolean USPS_Returned_Error {get; set;}
		public string USPS_ERROR_CODE {get; set;}
		public string USPS_ERROR_DESC {get; set;}
		public string USPS_ERROR_SOURCE {get; set;}
		
		public USPSAddress() {
			Address1='';
			Address2='';
			City='';
			State='';
			Zip5='';
			Zip4='';
			
			USPS_Returned_Error = false;
			USPS_ERROR_CODE = '';
			USPS_ERROR_DESC = '';
			USPS_ERROR_SOURCE = '';			
		} // constructor
		
		public string getZip() {
			string ReturnValue = Zip5;
			
			if (Zip4 != null && Zip4 != '') {
				ReturnValue += '-' + Zip4;
			}
			
			return ReturnValue;
		}// getZip
		
		public boolean CanCheckAddress() {
			// this method is used to determine when the component can
			// make a valid call to the USPS validation service.
			
			// since some data is required, there is no need to send
			// the request until we have the min data required
						
			boolean ReturnValue = false;
						
			if (Address2 != '' && Address2 != null) {
				
				if (Zip5 != '') {
					ReturnValue = true;
				} else if ((City != '') && (State != '')) {
					ReturnValue = true;
				} // have city and state OR Zip
				
			} // Address2 != ''
			
			system.debug('>>>>>> CanCheckAddress: Returning: ' + ReturnValue);
			return ReturnValue;
		} // Can Check Address
		
		public boolean HasData() {
			// this will return false if everything was defaulted.
			boolean ReturnValue = false;
			
			if (Address1 !='') {
				ReturnValue = true;
			} else if (Address2 !='') {
				ReturnValue = true;
			} else if (City !='') {
				ReturnValue = true;
			} else if (State !='') {
				ReturnValue = true;
			} else if (Zip5 !='') {
				ReturnValue = true;
			} else if (Zip4 !='') {
				ReturnValue = true;
			} else if (USPS_Returned_Error !=false) {
				ReturnValue = true;
			} else if (USPS_ERROR_CODE !='') {
				ReturnValue = true;
			} else if (USPS_ERROR_DESC !='') {
				ReturnValue = true;
			} else if (USPS_ERROR_SOURCE !='') {
				ReturnValue = true;
			}

			return ReturnValue;
		} // HasData

	} // class USPSAddress
} // end USPS Class