public class NeustarQueueableJob implements Queueable, Database.AllowsCallouts {
	private Boolean isTest = false;
    private List<String> testResponseList;

    /** Account passed in from Trigger */
    private Account acct{get; set;}
    
    /** Phone Number passed in from Trigger */
    private Phone_Number__c ph {get; set;}
    
    /** Phone Number passed in from Trigger */

	/** Constructor */
    public NeustarQueueableJob(Account acct){
        this(acct, false, null);
    }
    
    /** Constructor */
    public NeustarQueueableJob(Phone_Number__c ph) {
    	this(ph, false, null);
    }
    
    /** Constructor */
    public NeustarQueueableJob(Account acct, Boolean isTest, List<String> sampleResponseList) {
        this.acct = acct;
        this.isTest = isTest;
        this.testResponseList = sampleResponseList;
    }
    
    /** Constructor */
    public NeustarQueueableJob(Phone_Number__c ph, Boolean isTest, List<String> sampleResponseList) {
        this.ph = ph;
        this.isTest = isTest;
        this.testResponseList = sampleResponseList;
    }
    
    /** Interface method */
    public void execute(QueueableContext context) {
    	if(acct != null) {
    		executeMPIC(context);
    	} else if (ph != null) {
    		executePhoneAttr(context);
    	}
    }
    
    private void executePhoneAttr(QueueableContext context) {
    	System.debug('**** Executing Phone Attr');
        //Retrieve Neustar Callout record for this specific job
        Webservice_Callout__c currentCallout = new Webservice_Callout__c();
        Id paRTId = Schema.SObjectType.Phone_Number__c.getRecordTypeInfosByName().get('Person Account SFDC2').getRecordTypeId();
        if(!isTest) {
            currentCallout = [Select Id, Status__c, Date_Time_Submitted__c, Response__c, Account__c,
                                     Job_ID__c, Job_Name__c From Webservice_Callout__c Where Job_ID__c = :context.getJobId()];
        }
        
        //attempt the callout
    	NeustarConfig__c config = NeustarConfig__c.getValues('SF');
    	if(isTest) {
    		config = new NeustarConfig__c();
    	}
    	System.debug('**** Setting up client object');
		NeustarWsGetdata.ClientSoap client = new NeustarWsGetdata.ClientSoap();
		NeustarWsGetdata.OriginationType orig = new NeustarWsGetdata.OriginationType();
		System.debug('**** Setting up username/password');
		orig.username = config.Username__c;
		orig.password = config.Password__c;
		
		NeustarWsGetdata.ArrayOfInt elements = new NeustarWsGetdata.ArrayOfInt();
		System.debug('**** Setting elements for Phone Attr query');
		elements.id = new List<Integer>{1320};
		
		//set up service key/values for Phone Attr callout
		NeustarWsGetdata.ArrayOfServiceKeyType serviceKeys = new NeustarWsGetdata.ArrayOfServiceKeyType();
		NeustarWsGetdata.ServiceKeyType serviceKey1 = new NeustarWsGetdata.ServiceKeyType();
		NeustarWsGetdata.ServiceKeyType serviceKey2 = new NeustarWsGetdata.ServiceKeyType();
		System.debug('**** Setting up service keys');
		serviceKey1.id = 1;
        if (paRTId == ph.RecordTypeId){
            serviceKey1.value = ph.Consumer_Mobile_2_0__c.replaceAll('[^0-9]', '');  
            System.debug('serviceKey1.value'+serviceKey1.value);
        }
        else{
          serviceKey1.value = ph.Phone_Number__c.replaceAll('[^0-9]', ''); 
        }
		serviceKey2.id = 599;
		serviceKey2.value = '1,2,3,4,5';
		serviceKeys.serviceKey = new List<NeustarWsGetdata.ServiceKeyType>{serviceKey1, serviceKey2};
		
		Integer transactionID = 0;
		
		//Start time - used to determine Duration of callout
    	Long start = System.now().getTime();
    	
    	List<SObject> toUpdate = new List<SObject>();
    	System.debug('**** Initiating query: ' + client);
		try {
			if(!isTest) {
				NeustarWsGetdata.ResponseMsgType resp = client.query(orig, config.Service_Id__c, transactionID, elements, serviceKeys ) ;
				System.debug('**** Neustar Phone Attr response: ' + resp);
				string outputVal = resp.errorCode + ' ' ;
				if( ( resp.errorCode == 0 ) && ( resp.result.element.size() > 0 ) ) {
					NeustarWsGetdata.ElementResultType result = resp.result.element[ 0 ] ;
					outputVal += result.errorCode + ' ' + result.id + ' ' ;
					if( result.errorCode == 0 ) {
						outputVal += result.value ;
						currentCallout.Status__c = 'OK';
						currentCallout.Response__c = serviceKey1.value + ': ' + result.value;
						List<SObject> processedRecords = processPhoneAttrResponse(result.value);
						toUpdate.addAll(processedRecords);
					} else {
						currentCallout.Status__c = 'KO';
					}
				} else {
					currentCallout.Response__c = 'Error Code: ' + outputVal;
					currentCallout.Status__c = 'KO';
				}
				System.debug('**** Output: ' + outputVal);
			} else {
				Dom.Document responseDom = new Dom.Document();
				String testResponse = this.testResponseList.get(0);
				List<SObject> processedRecords = processPhoneAttrResponse(testResponse);
				toUpdate.addAll(processedRecords);
				currentCallout.Status__c = 'OK';
				currentCallout.Response__c = testResponse;
			}
		} catch (Exception e) {
			//unexpected error
			currentCallout.Status__c = 'Failed';
			currentCallout.Response__c = e.getStackTraceString().replace('\n',' / ')+' - '+e.getMessage();
			System.debug('**** QUERY FAILED: ' + currentCallout.Response__c);
		}
		if(!isTest)
		{
			//Sets info about the job
	        DateTime submittedDateTime = System.now();
	        currentCallout.Date_Time_Submitted__c = submittedDateTime;
	        currentCallout.Duration__c = submittedDateTime.getTime()-start;
	        toUpdate.add(currentCallout);
		}
        
        update toUpdate;
    }
    
    private void executeMPIC(QueueableContext context) {
    	System.debug('**** Executing MPIC');
        //Retrieve Neustar Callout record for this specific job
        Webservice_Callout__c currentCallout = new Webservice_Callout__c();
        if(!isTest) {
            currentCallout = [Select Id, Status__c, Date_Time_Submitted__c, Response__c, Account__c,
                                     Job_ID__c, Job_Name__c From Webservice_Callout__c Where Job_ID__c = :context.getJobId()];
        }
        
        //retrieve necessary Account data to perform comparisons
    	acct = [
    			SELECT
                    Id,
                    FirstName,
                    LastName,
                    Phone,
                    (SELECT
                        Id,
                        Phone_Number__c,
                        Neustar_MPIC_Phone_Score__c
                     FROM Phone_Numbers__r),
                    (SELECT
                        Id, 
                        Address_Line__c,
                        City__c,
                        State__c,
                        Zip__c,
                        Neustar_Address_Score__c
                     FROM Address__r)
                FROM Account
                WHERE Id = :acct.Id
                ];
        
        //attempt the callout
    	NeustarConfig__c config = NeustarConfig__c.getValues('SF');
    	if(isTest) {
    		config = new NeustarConfig__c();
    	}
    	System.debug('**** Setting up client object');
		NeustarWsGetdata.ClientSoap client = new NeustarWsGetdata.ClientSoap();
		NeustarWsGetdata.OriginationType orig = new NeustarWsGetdata.OriginationType();
		System.debug('**** Setting up username/password');
		orig.username = config.Username__c;
		orig.password = config.Password__c;
		
		NeustarWsGetdata.ArrayOfInt elements = new NeustarWsGetdata.ArrayOfInt();
		System.debug('**** Setting elements for MPIC query');
		elements.id = new List<Integer>{3226};
		
		//create queries for the Account: MPIC queries are limited to the number of attributes that can be submitted
		NeustarMPICServiceKeyValue serviceQuery = new NeustarMPICServiceKeyValue(acct);
		List<String> queries = serviceQuery.values;
		System.debug('**** Queries to be submitted: ' + queries);
		
		List<QueryStat> stats = new List<QueryStat>();
		Integer queryIndex = 0;
		List<SObject> toUpdate = new List<SObject>();
		for(String query : queries) {
			queryIndex++;
			QueryStat queryInfo = new QueryStat();
			queryInfo.index = queryIndex;
			//Start time - used to determine Duration of callout
    		Long start = System.now().getTime();
    		
			NeustarWsGetdata.ArrayOfServiceKeyType serviceKeys = new NeustarWsGetdata.ArrayOfServiceKeyType();
			NeustarWsGetdata.ServiceKeyType serviceKey = new NeustarWsGetdata.ServiceKeyType();
			System.debug('**** Setting up service key');
			serviceKey.id = 875;
			serviceKey.value = query;
			serviceKeys.serviceKey = new List<NeustarWsGetdata.ServiceKeyType>{serviceKey};
			
			Integer transactionID = 0;
			System.debug('**** Initiating query: ' + client);
			try {
				if(!isTest) {
					NeustarWsGetdata.ResponseMsgType resp = client.query(orig, config.Service_Id__c, transactionID, elements, serviceKeys ) ;
					string outputVal = resp.errorCode + ' ' ;
					if( ( resp.errorCode == 0 ) && ( resp.result.element.size() > 0 ) ) {
						NeustarWsGetdata.ElementResultType result = resp.result.element[ 0 ] ;
						outputVal += result.errorCode + ' ' + result.id + ' ' ;
						if( result.errorCode == 0 ) {
							outputVal += result.value ;
							queryInfo.status = 'OK';
							queryInfo.response = result.value;
							Dom.Document responseDom = new Dom.Document();
							responseDom.load(result.value);
							List<SObject> processedRecords = processResponseBody(responseDom);
                            System.debug('processedRecords'+processedRecords);
							//prevent duplicate record ids from being updated
							for(SObject rec : processedRecords) {
								Boolean hasId = false;
								for(SObject uRec : toUpdate) {
									if(rec.Id == uRec.Id) {
										hasId = true;
										break;
									}
								}
								if(!hasId) {
									toUpdate.add(rec);
								}
							}
							//toUpdate.addAll(processResponseBody(responseDom));
						} else {
							queryInfo.status = 'KO';
						}
					} else {
						queryInfo.response = 'Error Code: ' + outputVal;
						queryInfo.status = 'KO';
					}
					System.debug('**** Output: ' + outputVal);
				} else {
					Dom.Document responseDom = new Dom.Document();
					String testResponse = this.testResponseList.get(queryIndex - 1);
					responseDom.load(testResponse);
					toUpdate.addAll(processResponseBody(responseDom));
					queryInfo.status = 'OK';
					queryInfo.response = testResponse;
				}
			} catch (Exception e) {
				//unexpected error
				queryInfo.status = 'Failed';
				queryInfo.response = e.getStackTraceString().replace('\n',' / ')+' - '+e.getMessage();
				System.debug('**** QUERY FAILED: ' + queryInfo.response);
			}
			//Sets info about the job
	        DateTime submittedDateTime = System.now();
	        queryInfo.submitted = submittedDateTime;
	        queryInfo.duration = submittedDateTime.getTime()-start;
	        stats.add(queryInfo);
		}
        System.debug('**** Stats: ' + stats);
        if(!isTest) {
        	QueryStat statInfo = stats.remove(0);
        	List<Webservice_Callout__c> calloutsToInsert = new List<Webservice_Callout__c>();
        	for(QueryStat s : stats) {
        		Webservice_Callout__c c = currentCallout.clone(false, true, false, false);
        		c.Job_Name__c = currentCallout.Job_Name__c;
        		c.Date_Time_Submitted__c = s.submitted;
        		c.Duration__c = s.duration;
        		c.Response__c = s.response;
        		c.Status__c = s.status;
        		c.Query_Index__c = s.index;
        		calloutsToInsert.add(c);
        	}
        	
        	currentCallout.Date_Time_Submitted__c = statInfo.submitted;
        	currentCallout.Duration__c = statInfo.duration;
        	currentCallout.Response__c = statInfo.response;
        	currentCallout.Status__c = statInfo.status;
        	currentCallout.Query_Index__c = statInfo.index;
            toUpdate.add(currentCallout);
            
            if(calloutsToInsert.size() > 0) {
            	insert calloutsToInsert;
            }
        }
        
        //determine if address/phone fields on Account should be updated
        populateHighScoreAccountDetails(toUpdate);
        toUpdate.add(acct);
        update toUpdate;
    }
    
    private void populateHighScoreAccountDetails(List<SObject> recsToUpdate) {
    	Boolean updateAccount = false;
    	Integer addressHighScoreIndex = -1;
    	Double addressHighScore = -1;
    	Integer phoneHighScoreIndex = -1;
    	Double phoneHighScore = -1;
    	Integer index = 0;
    	for(SObject obj : recsToUpdate) {
    		if(obj.getSObjectType() == Address__c.SObjectType) {
    			Address__c addr = (Address__c)obj;
    			if(addr.Neustar_Address_Score__c > addressHighScore) {
    				addressHighScoreIndex = index;
    				addressHighScore = addr.Neustar_Address_Score__c;
    			}
    		} else if (obj.getSObjectType() == Phone_Number__c.SObjectType) {
    			Phone_Number__c phone = (Phone_Number__c)obj;
    			if(phone.Neustar_MPIC_Phone_Score__c > phoneHighScore) {
    				phoneHighScoreIndex = index;
    				phoneHighScore = phone.Neustar_MPIC_Phone_Score__c;
    			}
    		}
    		index++;
    	}
    	System.debug('**** Address - Neustar high score: ' + addressHighScore);
    	System.debug('**** Phone - Neustar high score: ' + phoneHighScore);
    	if(addressHighScoreIndex > -1) {
    		//trigger update of address info using pre-existing trigger on Address object
    		Address__c addr = (Address__c)recsToUpdate.get(addressHighScoreIndex);
    		addr.Status__c = 'Current Mailing';
    	}
    	if(phoneHighScoreIndex > -1) {
    		Phone_Number__c phone = (Phone_Number__c)recsToUpdate.get(phoneHighScoreIndex);
    		System.debug('**** PHONE - ' + phone);
    		acct.Phone = phone.Phone_Number__c;
    		System.debug('**** Updating Account Phone to ' + acct.Phone);
    	}
    }
    
    /**
    * Given the response sring from Neustar, parses the Phone Attribute values and populates the 
    * Phone Number record that triggered the callout
    * @param response data returned from Neustar
    * @returns single record list of Phone Number record to update
    */
    private List<SObject> processPhoneAttrResponse(String response) {
    	//ordering of Phone Attribute response is:
    	//	1. Prepaid Phone Indicator
    	//	2. Business Phone Indicator (BPI)
    	//	3. Phone In-Service Indicator
    	//	4. Phone Type Indicator
    	//	5. Service Discontinued Indicator
    	String[] parsedResponse = response.split(',');
    	Phone_Number__c phone = new Phone_Number__c();
    	phone.Id = ph.Id;
    	phone.Neustar_Prepaid_Phone_Attributes__c = parsedResponse[0];
    	phone.Neustar_Business_Phone_Indicator_Attr__c = parsedResponse[1];
    	phone.Neustar_In_Service_Indicator__c = parsedResponse[2];
    	phone.Neustar_Phone_Type_Indicator__c = parsedResponse[3];
    	phone.Neustar_Service_Discontinued_Indicator__c = (parsedResponse[4] == '') ? null : Integer.valueOf(parsedResponse[4]);
    	phone.Neustar_Verification_Date__c = Datetime.now();
    	
    	List<SObject> returnList = new List<SObject>{phone};
    	return returnList;
    }
    
    /**
    * Given the response sring from Neustar, parses the MPIC values and populates the 
    * Address and/or Phone Number records that triggered the callout
    * @param doc XML response from Neustar
    * @returns record list of Address/Phone Number records to update
    */
    private List<SObject> processResponseBody(DOM.Document doc) {
        System.debug('processResponseBody');
        //List<LexisNexisRecord> records = new List<LexisNexisRecord>();  
        List<SObject> toUpdate = new List<SObject>();
        Boolean hasUnexpectedResponse = false;
        NeustarException ne = new NeustarException('An unexpected response was returned ' +
                                        'from Neustar: ');
        DOM.XMLNode root = doc.getRootElement();
    	System.debug(root.getName());
        //DOM.XMLNode responseNode = root.getChildElements()[0];
        for(DOM.XMLNode rootChildNode : root.getChildElements()) {
            if(rootChildNode.getNodeType() == DOM.XMLNodeType.ELEMENT) {
                String childNodeName = rootChildNode.getName().toLowerCase();
                System.debug(childNodeName);
                if(childNodeName == 'names') {
                    //MPIC returns customer name--no need to process further
                } else if (childNodeName == 'addresses') {
                	//process address validation
                	System.debug('**** Processing Addresses');
                	for(DOM.XMLNode addressNode : rootChildNode.getChildElements()) {
                		 String addressNodeName = addressNode.getName().toLowerCase();
                         if(addressNodeName == 'address') {
                         	//retrieve the address and Neustar data
                         	String addressStreet;
                         	String addressCity;
                         	String addressState;
                         	String addressZip;
                         	for(DOM.XMLNode addressComponentNode : addressNode.getChildElements()) {
                         		//the address that is returned is exactly as it was submitted to Neustar
                         		String componentNodeName = addressComponentNode.getName().toLowerCase();
                         		String componentValue = addressComponentNode.getText().toLowerCase().trim();
                         		if(componentNodeName == 'street') {
                         			addressStreet = componentValue;
                         		} else if (componentNodeName == 'city') {
                         			addressCity = componentValue;
                         		} else if (componentNodeName == 'st') {
                         			addressState = componentValue;
                         		} else if (componentNodeName == 'postal') {
                         			addressZip = componentValue;
                         		}
                         	}
                         	String addressString = addressStreet + '|' + addressCity + '|' + addressState + '|' + addressZip;
                         	System.debug('**** return data for ' + addressString);
                         	String validation = addressNode.getAttributeValue('validation', '');
                         	String dpvconfirm = addressNode.getAttributeValue('DPVConfirm', '');
                         	String uspstype = addressNode.getAttributeValue('USPSType', '');
                         	String rbdi = addressNode.getAttributeValue('RBDI', '');
                         	String vacancy = addressNode.getAttributeValue('vacancy', '');
                         	String cmra = addressNode.getAttributeValue('CMRA', '');
                         	String prison = addressNode.getAttributeValue('prison', '');
                         	String score = addressNode.getAttributeValue('score', '');

                         	for(Address__c address : acct.Address__r) {
                         		//associate returned address with appropriate Address record
                         		String street = (address.Address_Line__c == null) ? '' : address.Address_Line__c.toLowerCase().trim();
                         		String city = (address.City__c == null) ? '' : address.City__c.toLowerCase().trim();
                         		String state = (address.State__c == null) ? '' : address.State__c.toLowerCase().trim();
                         		String zip = (address.Zip__c == null) ? '' : address.Zip__c.toLowerCase().trim();
                         		String addressToCompare = street + '|' + city + '|' + state + '|' + zip;
                         		System.debug('**** comparing return value ' + addressString + ' to address record ' + addressToCompare);
                         		if(addressToCompare == addressString) {
                         			System.debug('**** address match found');
                         			Address__c addressToUpdate = new Address__c();
                         			addressToUpdate.Id = address.Id;
                         			addressToUpdate.Neustar_Address_Validation__c = (validation == '') ? null : Integer.valueOf(validation);
                         			addressToUpdate.Neustar_DPV_Confirm__c = dpvconfirm;
                         			addressToUpdate.Neustar_Address_USPS_Type__c = uspstype;
                         			addressToUpdate.Neustar_Residential_Indicator__c = rbdi;
                         			addressToUpdate.Neustar_Address_Vacancy__c = vacancy;
                         			addressToUpdate.Neustar_CMRA_Indicator__c = cmra;
                         			addressToUpdate.Neustar_Address_Prison__c = prison;
                         			addressToUpdate.Neustar_Address_Score__c = (score == '') ? null : Integer.valueOf(score);
                         			addressToUpdate.Neustar_Address_Verification_Date__c = Datetime.now();
                         			toUpdate.add(addressToUpdate);
                         		}
                         	}
                         }
                	}
                } else if (childNodeName == 'phones') {
                	//process phone validation
                	System.debug('**** Processing Phones');
                	for(DOM.XMLNode phoneNode : rootChildNode.getChildElements()) {
                		 String phoneNodeName = phoneNode.getName().toLowerCase();
                         if(phoneNodeName == 'phone') {
                         	//retrieve the phone number and Neustar data
                         	String phoneNodeValue = phoneNode.getText();
                         	System.debug('**** return data for ' + phoneNodeValue);
                         	String validation = phoneNode.getAttributeValue('validation', '');
                         	String mobile = phoneNode.getAttributeValue('mobile', '');
                         	String tz = phoneNode.getAttributeValue('tz', '');
                         	String dst = phoneNode.getAttributeValue('dst', '');
                         	String st = phoneNode.getAttributeValue('st', '');
                         	String daconnected = phoneNode.getAttributeValue('DAConnected', '');
                         	String bpi = phoneNode.getAttributeValue('BPI', '');
                         	String active = phoneNode.getAttributeValue('active', '');
                         	String score = phoneNode.getAttributeValue('score', '');

                         	for(Phone_Number__c phone : acct.Phone_Numbers__r) {
                         		//associate returned phone with appropriate Phone record
                         		String numToCompare = phone.Phone_Number__c.replaceAll('[^0-9]', '');
                         		System.debug('**** comparing return value ' + phoneNodeValue + ' to address record ' + numToCompare);
                         		if(numToCompare == phoneNodeValue) {
                         			System.debug('**** phone match found');
                         			Phone_Number__c phoneToUpdate = new Phone_Number__c();
                         			phoneToUpdate.Id = phone.Id;
                         			phoneToUpdate.Phone_Number__c = phone.Phone_Number__c; //need to include phone value so we can use to update Account for high score
                         			phoneToUpdate.Neustar_Phone_Validation__c = (validation == '') ? null : Integer.valueOf(validation);
                         			phoneToUpdate.Neustar_Mobile__c = mobile;
                         			phoneToUpdate.Neustar_Time_Zone__c = (tz == '') ? null : Integer.valueOf(tz);
                         			phoneToUpdate.Neustar_Daylight_Savings__c = dst;
                         			phoneToUpdate.Neustar_Postal_State_Code__c = st;
                         			phoneToUpdate.Neustar_DA_Connection__c = daconnected;
                         			phoneToUpdate.Neustar_Business_Phone_Indicator__c = bpi;
                         			phoneToUpdate.Neustar_Phone_Activity__c = (active == '') ? null : Integer.valueOf(active);
                         			phoneToUpdate.Neustar_MPIC_Phone_Score__c = (score == '') ? null : Integer.valueOf(score);
                         			phoneToUpdate.Neustar_Verification_MPIC_Date__c = Datetime.now();
                         			toUpdate.add(phoneToUpdate);
                         		}
                         	}
                         }
                	}
                } else if (childNodeName == 'emailaddresses') {
                	//not currently validating email address
                } else if (childNodeName == 'ipaddresses') {
                	//not currently validating IP addresses
                }
            }
        }
        
        return toUpdate;
    }
    
    /**
    * Used to capture query data so that Webservice Callout records can be created when multiple queries issued
    */
    private class QueryStat {
    	public Integer index {get; set;}
    	public String response {get; set;}
    	public String status {get; set;}
    	public Datetime submitted {get; set;}
    	public Long duration {get; set;}
    	
    	public QueryStat() {} 
    }
    
    /**
    * <p>Used to formulate MPIC query(s)</p>
    * <p>Query format:<br/>
    * <pre>
    *	Contact
    *		Names
    *			Name type="C"
    *				First/
    *				Last/
    *			/Name
    *		/Names
    *		Addresses *multiple
    *			Address score="1" appends="validation,dpvconfirm,uspstype,rbdi,vacancy,cmra,prison,verifiedaddress"
    *				Street/
    *				City/
    *				ST/
    *				Postal/
    *			/Address
    *		/Addresses
    *		Phones *multiple
    *			Phone score="1" appends="validation,mobile,tz,dst,st,daconnected,BPI,active" /
    *		/Phones
    *	/Contact
    * </pre>
    * </p>
    */
    private class NeustarMPICServiceKeyValue {
    	/** Formatted query values for supplied account */
    	public List<String> values {get; set;}
    	
    	/** Max count of addresses that can be added to a single MPIC query */
    	public final Integer MAXQUERY_ADDRESS = 2;
    	/** Max count of addresses that can be added to a single MPIC query */
    	public final Integer MAXQUERY_PHONE = 4;
    	
    	public NeustarMPICServiceKeyValue(Account a) {
    		values = new List<String>();
    		List<String> addressXmlList = new List<String>();
    		List<String> phoneXmlList = new List<String>();
    		for(Address__c addy : a.Address__r) {
    			String addressXml = '<Address score="1" appends="validation,dpvconfirm,uspstype,rbdi,vacancy,cmra,prison,verifiedaddress">';
    			addressXml += '<Street>' + addy.Address_Line__c + '</Street>';
    			addressXml += '<City>' + addy.City__c + '</City>';
    			addressXml += '<ST>' + addy.State__c + '</ST>';
    			addressXml += '<Postal>' + addy.Zip__c + '</Postal>';
    			addressXml += '</Address>';
    			addressXmlList.add(addressXml);
    		}
    		for(Phone_Number__c phone : a.Phone_Numbers__r) {
    			String phoneXml = '<Phone score="1" appends="validation,mobile,tz,dst,st,daconnected,BPI,active">' + phone.Phone_Number__c.replaceAll('[^0-9]', '') + '</Phone>';
    			phoneXmlList.add(phoneXml);
    		}
    		
    		String queryNameXml = '<Names><Name type="C"><First>' + a.FirstName + '</First><Last>' + a.LastName + '</Last></Name></Names>';
			Boolean hasMorePhone = false;
			Boolean hasMoreAddress = false;
			do {
				String mpicQuery = '<Contact>' + queryNameXml;
				Integer addressIndex = 0;
				if(addressXmlList.size() > 0) {
					mpicQuery += '<Addresses>';
				
					if(addressXmlList.size() > MAXQUERY_ADDRESS) {
						while(addressIndex < MAXQUERY_ADDRESS) {
							mpicQuery += addressXmlList.remove(0);
							addressIndex++;
						}
						hasMoreAddress = true;
					} else {
						Integer addressListSize = addressXmlList.size();
						while(addressIndex < addressListSize) {
							mpicQuery += addressXmlList.remove(0);
							addressIndex++;
						}
						hasMoreAddress = false;
					}
					mpicQuery += '</Addresses>';
				}
				Integer phoneIndex = 0;
				if(phoneXmlList.size() > 0) {
					mpicQuery += '<Phones>';
				
					if(phoneXmlList.size() > MAXQUERY_PHONE) {
						while(phoneIndex < MAXQUERY_PHONE) {
							mpicQuery += phoneXmlList.remove(0);
							phoneIndex++;
						}
						hasMorePhone = true;
					} else {
						Integer phoneListSize = phoneXmlList.size();
						while(phoneIndex < phoneListSize) {
							mpicQuery += phoneXmlList.remove(0);
							phoneIndex++;
						}
						hasMorePhone = false;
					}
					
					mpicQuery += '</Phones>';
				}
				mpicQuery += '</Contact>';
				values.add(mpicQuery);
			} while (hasMoreAddress || hasMorePhone);		
    	}
    }
    
    public class NeustarException extends Exception { }
}