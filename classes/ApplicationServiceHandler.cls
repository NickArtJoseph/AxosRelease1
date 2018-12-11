/**
* @description <p>Handler class for ApplicationService functionality which parses files and
* automatically generates Applications and related records for SFDC 2.0</p>
* @author Mike Crosby, BofI Federal 
*/
global class ApplicationServiceHandler implements Queueable {
	/** Set in unit tests to indicate tests are running */
    public Boolean isTest {get; set;}
    /** Source system name */
    private String source {get; set;}
    /** Name of file that is being parsed */
    private String filename {get; set;}
    /** File being parsed */
    private Blob fileattach {get; set;}
    /** Map of record types (developer name/id) for Application object */
    private Map<String,ID> appRecordTypeMap {get; set;}
    /** Map of URI namespaces (source/URL) for XML parsing */
    private Map<String,String> namespaceMap = new Map<String,String> {
        'meridianlink' => 'http://www.meridianlink.com/CLF'
    };
    /** Map of root nodes (source/root) for XML parsing */
    private Map<String,String> rootnodeMap = new Map<String,String> {
    	'meridianlink' => 'xpress_loan'      
    };

	/**
	* Default constructor
	*/
    public ApplicationServiceHandler() {}    
    
    /**
    * Constructor with parameters
    * @param source system that supplied the file
    * @param filename name of file submitted
    * @param fileattach file object (expected file types: ZIP, XML)
    */
    public ApplicationServiceHandler(String source, String filename, Blob fileattach)
    {
        this.source = source;
        this.filename = filename;
        this.fileattach = fileattach;
        this.isTest = false;
        
        appRecordTypeMap = new Map<String, ID>();
        for(RecordType rt : [SELECT Name, DeveloperName, SObjectType FROM RecordType WHERE SObjectType in ('Application_SFDC2__c','Application_Account_SFDC2__c', 'Applicant_SFDC2__c') AND IsActive=true]) {
          appRecordTypeMap.put(rt.SObjectType.toLowerCase() + '|' + rt.DeveloperName.toLowerCase(), rt.Id);
        }
    }

	/**
	* Implementation class for executing the main logic of parsing the submitted file
	* @param ctx queueable context for enqueued job
	*/
    public void execute(QueueableContext ctx) {
        String errorFile = filename;
        
        if(filename.endsWith('.zip')) {
        	//for ZIP files, extract XML files and process individually
            List<String> fileNameList = new List<String>();
            Zippex xmlZip = new Zippex(fileattach);
            for(String xmlFileName : xmlZip.getFileNames()) {
                Blob content = xmlZip.getFile(xmlFileName);
                String xFileName = xmlFileName.substring(xmlFileName.lastIndexOf('/')+1);
                fileNameList.add(xFileName.substring(0, xFileName.indexOf('.')));
                try{
                	processFile(source, xFileName, content);
                } catch (Exception e) {
                    handleError(e, 'ApplicationServiceHandler', xFileName + ' (' + fileName + ')');
                }
            }
        } else  {
        	//for XML files
            try{
        		processFile(source, filename, fileattach);
            } catch (Exception e) {
                handleError(e, 'ApplicationServiceHandler', fileName);
            }
        }
    }
    
    /**
    * Parses the XML file and creates or updates Application record and related records
    * based on the XML content; updates are based on XML file name (minus extension)
    * @param src source system
    * @param fileName name of file submitted
    * @param fileAttach file object
    */
    public void processFile(String src, String fileName, Blob fileAttach) {
        System.debug('**** processFile: Received ' + fileName + ' from ' + src);
        
        //convert the Blob file to String
        String fileString = fileAttach.toString();

        //Set up DOM for file
        Dom.Document xmlDoc = new Dom.Document();
        xmlDoc.load(fileString);
        
        //Retrieve field mappings
        src = src.toLowerCase(); 
        String xmlNamespace = namespaceMap.get(src);
        String rootNodeName = rootnodeMap.get(src);
        Map<String,Blob> fieldMaps = retrieveFieldMappingFiles(src);
        if(fieldMaps.size() == 0) {
            throw new ApplicationServiceHandlerException('The source \'' + src + '\' is not currently configured as an Application source.');        
        }
        
        Map<Integer,Map<String,Object>> applicationFieldValues = new Map<Integer,Map<String,Object>>();
        Map<Integer,Map<String,Object>> applicantFieldValues = new Map<Integer,Map<String,Object>>();        
        Map<Integer,Map<String,Object>> approvedAccountsFieldValues = new Map<Integer,Map<String,Object>>();
        Map<Integer,Map<String,Object>> interestedAccountsFieldValues = new Map<Integer,Map<String,Object>>();
        Map<Integer,Map<String,Object>> customAnswerFieldValues = new Map<Integer,Map<String,Object>>();
        
        //based on the mappings retrieved from static resources, extract the values from the XML
        for(String fName : fieldMaps.keySet())
        {
            Blob fieldMapFile = fieldMaps.get(fName);
            Map<String,String> sfdcFieldMap = parseFieldMapFile(fieldMapFile);
            fName = fName.toLowerCase();
            if(fName.contains('_application_')) {
                //process APPLICATION field mappings
                applicationFieldValues = extractValues(xmlDoc, sfdcFieldMap, xmlNamespace, rootNodeName);
            } else if (fName.contains('_applicant_')) {
                //process APPLICANT field mappings
                applicantFieldValues = extractValues(xmlDoc, sfdcFieldMap, xmlNamespace, rootNodeName);
            } else if (fName.contains('_approvedaccount_')) {
                //process APPROVEDACCOUNTS field mappings
                approvedAccountsFieldValues = extractValues(xmlDoc, sfdcFieldMap, xmlNamespace, rootNodeName);
            } else if (fName.contains('_interestedaccount_')) {
                //process INTERESTEDACCOUNTS field mappings
                interestedAccountsFieldValues = extractValues(xmlDoc, sfdcFieldMap, xmlNamespace, rootNodeName);
            } else if (fName.contains('_answer_')) {
                //process ANSWER field mappings
                customAnswerFieldValues = extractValues(xmlDoc, sfdcFieldMap, xmlNamespace, rootNodeName);
            }
        }
        
        System.debug('**** RecordTypes: ' + appRecordTypeMap);
        
        //set up the Application record
        Application_SFDC2__c app = new Application_SFDC2__c();
        app.RecordTypeId = appRecordTypeMap.get('application_sfdc2__c|' + src);
        String appName = fileName.substring(0, fileName.indexOf('.'));
        app.Name = appName;
        app.Application_Id__c = appName;
        if(applicationFieldValues.size() > 0) {
            for(String fieldName : applicationFieldValues.get(0).keySet()) {
                app.put(fieldName, applicationFieldValues.get(0).get(fieldName));
                System.debug('Application: ' + fieldName + '=' + applicationFieldValues.get(0).get(fieldName));
            }
        }
        upsert app Application_Id__c;
        
        //retrieve Question records to link with Answers
        Map<String, Application_Question_SFDC2__c> questionMap = queryApplicationQuestion();
        
        //set up the Applicant record(s)
        List<Applicant_SFDC2__c> applicantList = new List<Applicant_SFDC2__c>();
        List<Applicant_Answer_SFDC2__c> applicantAnswerList = new List<Applicant_Answer_SFDC2__c>();
        if(applicantFieldValues.size() > 0) {
            for(Integer i : applicantFieldValues.keySet()) {
                Map<String,Object> keyValueMap = applicantFieldValues.get(i);
                Applicant_SFDC2__c applicant = new Applicant_SFDC2__c();
            	applicant.Application_Id__c = app.Id;
            	applicant.RecordTypeId = appRecordTypeMap.get('applicant_sfdc2__c|' + src);
            	String externalId;
                for(String fieldName : keyValueMap.keySet()) {
                    applicant.put(fieldName, keyValueMap.get(fieldName));
                    if(fieldName.toLowerCase() == 'external_id__c') {
                    	externalId = (String)keyValueMap.get(fieldName);
                    }
                    System.debug('Applicant: ' + fieldName + '=' + keyValueMap.get(fieldName));
                }
                applicantList.add(applicant);
                //for each applicant, get any answers to questions
                String appAnswerFilename;
                for(String fName : fieldMaps.keySet()) {
                	if(fname.toLowerCase().contains('_applicantanswer_')) {
                		appAnswerFilename = fname;
                		break;
                	}
                }
                if(appAnswerFilename != null && externalId != null) {
                	Blob fieldMapFile = fieldMaps.get(appAnswerFilename);
        			Map<String,String> sfdcFieldMap = parseFieldMapFile(fieldMapFile);
            		Map<Integer,Map<String,Object>> applicantAnswerFieldValues = extractValues(xmlDoc, sfdcFieldMap, xmlNamespace, rootNodeName);
            		if(applicantAnswerFieldValues.size() > 0) {
            			for(Integer k : applicantAnswerFieldValues.keySet()) {
	            			Map<String,Object> appkeyValueMap = applicantAnswerFieldValues.get(k);
	            			if(appkeyValueMap.get('Internal_Id__c') != externalId) {
	            				continue;
	            			}
			                Applicant_Answer_SFDC2__c appAnswer = new Applicant_Answer_SFDC2__c();
			          		appAnswer.External_Id__c = externalId + '|';
			                for(String fieldName : appkeyValueMap.keySet()) {
			                    appAnswer.put(fieldName, appkeyValueMap.get(fieldName));
			                    if(fieldName.toLowerCase() == 'question_code__c') {
			                    	String questionCode = String.valueOf(appkeyValueMap.get(fieldName));
			                    	appAnswer.External_Id__c = externalId + '|' + questionCode;
			                    	if(questionMap.containsKey(questionCode)) {
			                    		appAnswer.put('Question__c', questionMap.get(questionCode).Id);
			                    	}
			                    }
			                    System.debug('Applicant Answer: ' + fieldName + '=' + appkeyValueMap.get(fieldName));
			                }
			                applicantAnswerList.add(appAnswer);
            			}
            		}
                }
            }
        }
        upsert applicantList External_Id__c;
        if(applicantAnswerList.size() > 0) {
        	applicantList = [SELECT External_Id__c FROM Applicant_SFDC2__c WHERE Id in :applicantList];
        	for(Applicant_SFDC2__c applicant : applicantList) {
        		for(Applicant_Answer_SFDC2__c ans : applicantAnswerList) {
        			if(ans.External_Id__c.startsWith(applicant.External_Id__c)) {
        				ans.Applicant_Id__c = applicant.Id;
        			}
        		}
        	}
        	upsert applicantAnswerList External_Id__c;
        }
        
        //set up the Account record(s)
        List<Application_Account_SFDC2__c> accountList = new List<Application_Account_SFDC2__c>();
        if(approvedAccountsFieldValues.size() > 0) {
            for(Integer i : approvedAccountsFieldValues.keySet()) {
                Map<String,Object> keyValueMap = approvedAccountsFieldValues.get(i);
                Application_Account_SFDC2__c account = new Application_Account_SFDC2__c();
            	account.Application_Id__c = app.Id;
                account.RecordTypeId = appRecordTypeMap.get('application_account_sfdc2__c|approved_account');
                for(String fieldName : keyValueMap.keySet()) {
                    account.put(fieldName, keyValueMap.get(fieldName));
                    System.debug('Approved Account: ' + fieldName + '=' + keyValueMap.get(fieldName));
                }
                accountList.add(account);
            }
        }
        if(interestedAccountsFieldValues.size() > 0) {
            for(Integer i : interestedAccountsFieldValues.keySet()) {
                Map<String,Object> keyValueMap = interestedAccountsFieldValues.get(i);
                Application_Account_SFDC2__c account = new Application_Account_SFDC2__c();
            	account.Application_Id__c = app.Id;
                account.RecordTypeId = appRecordTypeMap.get('application_account_sfdc2__c|interested_account');
                for(String fieldName : keyValueMap.keySet()) {
                    account.put(fieldName, keyValueMap.get(fieldName));
                    System.debug('Interested Account: ' + fieldName + '=' + keyValueMap.get(fieldName));
                }
                accountList.add(account);
            }
        }
        upsert accountList Type_Id__c;
        
        //Set up the Answer record(s)
        List<Application_Answer_SFDC2__c> answerList = new List<Application_Answer_SFDC2__c>();
        if(customAnswerFieldValues.size() > 0) {
            for(Integer i : customAnswerFieldValues.keySet()) {
                Map<String,Object> keyValueMap = customAnswerFieldValues.get(i);
                Application_Answer_SFDC2__c answer = new Application_Answer_SFDC2__c();
            	answer.Application_Id__c = app.Id;
                for(String fieldName : keyValueMap.keySet()) {
                    if(fieldName.toLowerCase() == 'question_code__c') {
                    	String questionCode = String.valueOf(keyValueMap.get(fieldName));
                        answer.put('External_Id__c', fileName + '|' + questionCode);
                        if(questionMap.containsKey(questionCode)) {
                        	answer.put('Question__c', questionMap.get(questionCode).Id);
                        }
                    }
                    answer.put(fieldName, keyValueMap.get(fieldName));
                    System.debug('Answer: ' + fieldName + '=' + keyValueMap.get(fieldName));
                }
                answerList.add(answer);
            }
        }
        upsert answerList External_Id__c;
        
        //Create an Attachment record to associate with the Application record
        Attachment attach = new Attachment();
        attach.ParentId = app.Id;
        attach.Name = fileName;
        attach.Body = fileAttach;
        insert attach;        
    }

    private Map<Integer,Map<String,Object>> extractValues(DOM.Document xmlDoc, Map<String,String> fieldMap, String xmlNamespace, String rootNodeName) {
        //Map of elements with field/value pairs to return
        Map<Integer,Map<String,Object>> returnMap = new Map<Integer,Map<String,Object>>();
        
        //Retrieve the root element for this document.
        Dom.XMLNode rootNode = xmlDoc.getRootElement();
        
        //verify we have the correct top node
        if(rootNode.getName().toLowerCase() != rootNodeName) {
            throw new ApplicationServiceHandlerException('An invalid XML format was encounted');
        }
        
		//Cycle through XML and create necessary field mapping
        for(String xmlTag : fieldMap.keySet()) {
            String sfdcFieldType = fieldMap.get(xmlTag);
            System.debug('**** Parsing tag: ' + xmlTag);
            String[] nodeAttrArray = xmlTag.split('>');
            List<Dom.XMLNode> nodeListToProcess = parseTags(xmlTag, rootNode, xmlNamespace);
            //Dom.XMLNode xNode = rootNode;
            
            for(Integer i = 0; i < nodeListToProcess.size(); i++) {
                if(returnMap.get(i) == null) {
                    returnMap.put(i, new Map<String,Object>());
                }
                DOM.XMLNode node = nodeListToProcess.get(i);
                //process value parsed from XML
                String attrName = nodeAttrArray[nodeAttrArray.size()-1];
                String xVal = node.getAttribute(attrName, null);
                //System.debug('**** Attribute ' + attrName + ' = ' + xVal);
                if(attrName.startsWith('d3p1') ||
                  	attrName.startsWith('d2p1')) {
                    attrName = attrName.substring(attrName.indexOf(':') +1);
                    xVal = node.getAttribute(attrName, 'http://www.meridianlink.com/InternalUse');
                }
                System.debug('**** Attribute ' + attrName + ' = ' + xVal);
                if(xVal != null) {
	                String[] sfdcFieldTypeArray = sfdcFieldType.split('\\|');
    	            String dataType = sfdcFieldTypeArray[1].toLowerCase();
        	        if(dataType == 'string') {
            	        returnMap.get(i).put(sfdcFieldTypeArray[0], xVal);
                	} else if (dataType == 'date') {
	                    returnMap.get(i).put(sfdcFieldTypeArray[0], Date.valueOf(xVal));
	                } else if (dataType == 'datetime') {
	                	//additional processing may be necessary depending on the source system
	                	if(xVal.length() == 25) {
	                		//MeridianLink uses format: yyyy-MM-ddTHH:mm:ss(+ or -)hh:mm from GMT
	                		Datetime dt = Datetime.valueOf(xVal.replace('T', ' '));
	                		returnMap.get(i).put(sfdcFieldTypeArray[0], dt);
	                	} else {
	                		//attempt just a straight conversion of the value
	                    	returnMap.get(i).put(sfdcFieldTypeArray[0], Datetime.valueOf(xVal));
	                	}
    	            } else if (dataType == 'decimal') {
        	            returnMap.get(i).put(sfdcFieldTypeArray[0], (Decimal)JSON.deserialize(xVal, Decimal.class));
            	    } else if (dataType == 'boolean') {
                	    returnMap.get(i).put(sfdcFieldTypeArray[0], (Boolean)JSON.deserialize(xVal, Boolean.class));
                	}
                }
            }
        }
        
        //remove any empty nodes
        for(Integer key : returnMap.keySet()) {
            if(returnMap.get(key).size() == 0)
            	returnMap.remove(key);
        }
        
        return returnMap;
    }
    
    private List<Dom.XMLNode> parseTags(String xmlTag, DOM.XmlNode root, String xmlNamespace) {
    	List<Dom.XMLNode> nodeListToProcess = new List<Dom.XMLNode>();
    	DOM.XmlNode xNode = root;
    	String[] nodeAttrArray = xmlTag.split('>');
        System.debug('**** Node Attribute Array: ' + nodeAttrArray);
                
        
        List<DOM.XMLNode> currentNodes = new List<DOM.XMLNode>{root};
        for(Integer i = 0; i < nodeAttrArray.size()-1; i++) {
            if(xNode == null) {
                break;
            }
            
            String nodeName = nodeAttrArray[i];
            System.debug('>> Node Name=' + nodeName);
            List<DOM.XMLNode> xNodeList = new List<DOM.XMLNode>();
            
            Boolean hasMultiples = nodeName.startsWith('*');
            Boolean hasConditionals = nodeName.contains('{');
            Map<String, String> conditionalNodeParameters = new Map<String,String>();
            if(hasConditionals) {
	    		System.debug('>> Has Conditionals');
	    		String conditionalText = nodeName.substring(nodeName.indexOf('{') + 1, nodeName.length() - 1);
	        	nodeName = nodeName.substring(0,nodeName.indexOf('{'));
	        	for(String cText : conditionalText.split(',')) {
	        		String[] condition = cText.split('@');
	        		conditionalNodeParameters.put(condition[0],condition[1]);
	        	}
            }
            
            System.debug('>> Has Multiples=' + hasMultiples);
            System.debug('>> Has Conditionals=' + hasConditionals);
            
            if(!hasMultiples && !hasConditionals) {
            	//no special processing, move to child
            	System.debug('>> Not a special node');
            	for(DOM.XMLNode node : currentNodes) {
            		DOM.XMLNode tNode = node.getChildElement(nodeName, xmlNamespace);
            		tNode = checkNodeConditional(tNode, conditionalNodeParameters);
            		if(tNode != null) { 
            			xNodeList.add(tNode);
            		}
            	}
            } else {
        		System.debug('>> Has Multiples');
        		nodeName = nodeName.substring(1);
        		System.debug('>> Node name=' + nodeName);
        		for(DOM.XMLNode node : currentNodes) {
        			for(DOM.XMLNode childNode : node.getChildElements()) {
        				System.debug('>> compare to=' + childNode.getName());
        				if(nodeName.toLowerCase() == childNode.getName().toLowerCase()) {
        					DOM.XMLNode verifyNode = checkNodeConditional(childNode, conditionalNodeParameters);
        					if(verifyNode != null) {
	        					System.debug('>> Found matching node');
	        					xNodeList.add(childNode);
        					}
        				}
        			}
        		}
            }
            currentNodes = xNodeList;
        }
        return currentNodes;
    }
    
    private DOM.XMLNode checkNodeConditional(DOM.XMLNode node, Map<String,String> conditionalParams) {
    	for(String attrName : conditionalParams.keySet()) {
			String xVal = node.getAttribute(attrName, null);
			System.debug('>> Conditionals Param Name=' + attrName);
			System.debug('>> Conditional Param Value=' + xVal);
			if(conditionalParams.get(attrName) != null &&
				xVal.toLowerCase() == conditionalParams.get(attrName).toLowerCase()) {
				continue;
			} else {
				return null;
			}
		}
		return node;
    }


    private Map<String,String> parseFieldMapFile(Blob file) {
        Map<String,String> returnMap = new Map<String,String>();
        String fieldMapString = file.toString();
        for(String line : fieldMapString.split('\r\n')) {
            if(line.startsWith('//')) {
                //skip comments
            } else {
                if(line.contains('=')) {
                    //mapping format is XMLTags>param=sfdc_field__c|datatype
                    String xmlTag = line.split('=')[0];
                    String sfdcField = line.split('=')[1];
                    returnMap.put(xmlTag, sfdcField);
                }
            }
        }
        return returnMap;
    }
    
    /**
    * Retrieves custom question records to link to application/applicant answers
    * @returns map of Custom Question records (key=Question Code; value=Custom Question record)
    */
    private Map<String, Application_Question_SFDC2__c> queryApplicationQuestion() {
    	Map<String, Application_Question_SFDC2__c> returnMap = new Map<String, Application_Question_SFDC2__c>();
    	for(Application_Question_SFDC2__c q : [SELECT Question_Code__c FROM Application_Question_SFDC2__c]) {
    		returnMap.put(q.Question_Code__c, q);
    	}
    	return returnMap;
    }
    
    /**
    * Queries the static resources for field mappings of the source specified
    * @param source system whose mappings are needed
    * @returns map of static resource name with the corresponding mapping file
    */
    public Map<String,Blob> retrieveFieldMappingFiles(String source) {
        Map<String,Blob> fileMap = new Map<String,Blob>();
        source = source + '_%';
        for(StaticResource sr : [SELECT Name, Body FROM StaticResource WHERE Name like :source]) {
          fileMap.put(sr.Name, sr.Body);
        }
        System.debug('**** retrieveFieldMappingFiles: ' + fileMap);
        return fileMap;
    }
    
    /**
    * Provides error handling by sending an email to notify interested parties of issues
    * with processing the Application file
    * @param e Exception originally thrown
    * @param className name of the class where exception was thrown
    * @param fileName name of the file that caused the exception
    */
    public void handleError(Exception e, String className, String fileName) {
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        msg.setToAddresses(new List<String>{'salesforcesupport@bofifederalbank.com','hhaner@bofifederalbank.com'});
        msg.setSubject('Salesforce: Application Service Handler Exception for ' + className);
        String bodyString = '';
        bodyString += 'The following error occurred' + ((fileName != null) ? ' for file ' + fileName : '') + ':\n\n';
        bodyString += 'Line ' + e.getLineNumber() + ' - ' + e.getMessage();
        bodyString += '\n\nStack Trace: ' + e.getStackTraceString();
        msg.setPlainTextBody(bodyString);
        msg.setEmailPriority('Highest');
        msg.setReplyTo('salesforcesupport@bofi.com');
        msg.setSenderDisplayName('Error from ' + UserInfo.getName());
        if(!isTest) {
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{msg});
        }
    }
    
    /** Custom exception */
    public class ApplicationServiceHandlerException extends Exception { }

}