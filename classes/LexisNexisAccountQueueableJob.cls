public class LexisNexisAccountQueueableJob implements Queueable, Database.AllowsCallouts {
    private static final String greerOwnerId = '005i0000003A0Gn';
    private static final String outboundOwnerId = '005i0000006ne2Z';
    private Boolean isTest = false;
    private TestDataFactory.SingleRequestMock TestHttpCallout;
    
    /** Number of person record results to return in one job call */
    public static final Integer MAXRETURNCOUNT = 100; //future enhancement may be to move to custom setting and allow for multiple callouts
    
    /** Starting record number for API search */
    private Integer startResultCount = 1;
    
    /** Account passed in from Trigger */
    private Account acct{get; set;}
    
    /** Constructor */
    public LexisNexisAccountQueueableJob(Account acct){
        this(acct, false, null);
    }
    
    /** Constructor */
    public LexisNexisAccountQueueableJob(Account acct, Boolean isTest, TestDataFactory.SingleRequestMock testCall){
        this.acct = acct;
        this.isTest = isTest;
        this.TestHttpCallout = testCall;
    }
    
    /**
     * Interface method. 
     */
    public void execute(QueueableContext context) {
        //Retrieve LexisNexist Account Callout record for this specific job
        Webservice_Callout__c currentCallout = new Webservice_Callout__c();
        if(!isTest) {
            currentCallout = [Select Id, Status__c, Date_Time_Submitted__c, Response__c, Account__c,
                                     Job_ID__c From Webservice_Callout__c Where Job_ID__c = :context.getJobId()];
        }
        //retrieve necessary Account data to perform comparisons
        acct = [SELECT
                        Id,
                        Gender_Person__c,
                        Deceased_Person__c,
                        Date_of_Death__c,
                        Social_Security_Number_Person__c,
                        (SELECT
                            Id,
                            Phone_Number__c
                         FROM Phone_Numbers__r),
                        (SELECT
                            Id, 
                            Address_Line__c
                         FROM Address__r)
                    FROM Account
                    WHERE Id = :acct.Id
                    ];
        
        //Start time - used to determine Duration of callout
        Long start = System.now().getTime();
        
        //Make the REST call
        try{
            HttpRequest req = new HttpRequest();
            HttpResponse res;
            req.setMethod('GET');
            if(!Test.isRunningTest()) {
                String searchVal = acct.Social_Security_Number_Person__c.replace('-','').trim();
                req.setEndpoint('callout:LexisNexisAccurint/WsAccurint/BpsSearch?ver_=1.87&User.GLBPurpose=1&User.DLPurpose=3&Options.ReturnCount=' + LexisNexisAccountQueueableJob.MAXRETURNCOUNT + '&Options.StartingRecord=' + this.startResultCount + '&SearchBy.SSN=' + searchVal);
                req.setTimeout(60000);
                Http h = new Http();
                res = h.send(req);
            } else {
                TestDataFactory.SingleRequestMock fakeResponse = TestHttpCallout;
                res = fakeResponse.respond(req);
            }
            
            //4a - Response OK
            if(res.getStatusCode() == 200){
                currentCallout.status__c = 'OK';
            //4b - Reponse KO
            }else{
                currentCallout.status__c = 'KO';
            }
            //Save the response body
            currentCallout.Response__c = res.getBody();
            processResponseBody(res.getBodyDocument());
        }catch(LexisNexisException lne) {
            currentCallout.status__c = 'KO';
        }catch(Exception e){
            //Callout failed (e.g. timeout)
            currentCallout.status__c = 'Failed';
            currentCallout.Response__c = e.getStackTraceString().replace('\n',' / ')+' - '+e.getMessage();
        }
        //Sets info about the job
        DateTime submittedDateTime = System.now();
        currentCallout.Date_Time_Submitted__c = submittedDateTime;
        acct.SF_LexisNexis_Callout_Status__c = currentCallout.Status__c;
        acct.SF_LexisNexis_Callout_Date_Time__c = submittedDateTime;
        currentCallout.Duration__c = submittedDateTime.getTime()-start;
        TriggerValidator.reset();
        update acct;
        if(!isTest) {
            update currentCallout;
        }
    }
   
    private void processResponseBody(DOM.Document doc) {
        Boolean isPersonFound = false;
        Boolean hasNewPhoneNumber = false;
        Boolean hasFoundAddress = false;
        Boolean hasGender = false;
        Boolean isDeceased = false;
        List<LexisNexisRecord> records = new List<LexisNexisRecord>();  
        Boolean hasUnexpectedResponse = false;
        LexisNexisException lne = new LexisNexisException('An unexpected response was returned ' +
                                        'from LexisNexis: ');
        DOM.XMLNode root = doc.getRootElement();
        DOM.XMLNode responseNode = root.getChildElements()[0];
        for(DOM.XMLNode rootChildNode : responseNode.getChildElements()) {
            if(rootChildNode.getNodeType() == DOM.XMLNodeType.ELEMENT) {
                String childNodeName = rootChildNode.getName().toLowerCase();
                String childNodeValue = rootChildNode.getText();
                if(childNodeName == 'header') {
                    for(DOM.XMLNode headerNode : rootChildNode.getChildElements()) {
                        if(headerNode.getNodeType() == DOM.XMLNodeType.ELEMENT) {
                            String headerNodeName = headerNode.getName().toLowerCase();
                            String headerNodeValue = headerNode.getText();
                            if(headerNodeName == 'status') {
                                if(headerNodeValue != '0') {
                                    hasUnexpectedResponse = true;
                                    lne.setMessage(lne.getMessage() + ' Status=' + headerNodeValue);
                                }
                            } else if (headerNodeName == 'message') {
                                hasUnexpectedResponse = true;
                                lne.setMessage(lne.getMessage() + ' Message=' + headerNodeValue);
                            }
                        }
                    }       
                } else if (childNodeName == 'subjecttotalcount') {
                    System.debug('*** Number of records returned from LexisNexis=' + childNodeValue);
                    If(childNodeValue != null && Integer.valueOf(childNodeValue) > 0) {
                        isPersonFound = true;
                    }
                } else if (childNodeName == 'records') {
                    for(DOM.XMLNode recordNode : rootChildNode.getChildElements()) {
                        //process all records
                        if(recordNode.getNodeType() == DOM.XMLNodeType.ELEMENT) {
                            String recordNodeName = recordNode.getName().toLowerCase();
                            if(recordNodeName == 'record') {
                                LexisNexisRecord lnr = new LexisNexisRecord(recordNode);
                                records.add(lnr);
                            }   
                        }
                    }
                }
            }
        }
        if(hasUnexpectedResponse) {
            throw lne;
        }
        System.debug('*** Processed ' + records.size() + ' results from LexisNexis');
        if(records.size() > 0) {
            //if results were returned, process records
            List<SObject> toInsert = new List<SObject>();
        
            Set<String> phoneSet = new Set<String>();
            Address__c newAddress;
            Boolean hasAddress = false;
            for(LexisNexisRecord rec : records) {
                if(!hasGender && rec.Gender != null) {
                    hasGender = true;
                    acct.Gender_Person__c = rec.Gender;
                }
                if(rec.Deceased && !acct.Deceased_Person__c) {
                    isDeceased = true;
                    acct.Deceased_Person__c = true;
                }
                if(rec.DOD != null && acct.Date_of_Death__c == null) {
                    isDeceased = true;
                    acct.Deceased_Person__c = true;
                    acct.Date_of_Death__c = rec.DOD;
                }
                if(rec.Phone10 != null) {
                    Boolean hasPhone = false;
                    String lnPhone = rec.Phone10.replaceAll('[^0-9]', '');
                    for(Phone_Number__c pn : acct.Phone_Numbers__r) {
                        String acctPhone = pn.Phone_Number__c.replaceAll('[^0-9]', '');
                        if(acctPhone == lnPhone) {
                            hasPhone = true;
                            break;
                        }
                    }
                    if(!hasPhone) {
                        hasNewPhoneNumber = true;
                        phoneSet.add(lnPhone);
                    }
                }
                if(rec.AddressStreetNumber != null && !hasFoundAddress) {
                    hasFoundAddress = true;
                    for(Address__c add : acct.Address__r) {
                        if(add.Address_Line__c != null) {
                            String[] addressComponents = add.Address_Line__c.split(' '); //requirement is that only numeric portion needs to match
                            if(rec.AddressStreetNumber == addressComponents[0]) {
                                hasAddress = true;
                                break;
                            }
                        }
                    }
                    if(newAddress == null && !hasAddress) {
                        newAddress = new Address__c();
                        newAddress.Account_Name__c = acct.Id;
                        newAddress.Address_Line__c = rec.AddressStreetNumber + ((rec.AddressStreetDirection != '') ? ' ' + rec.AddressStreetDirection : '') + ' ' + rec.AddressStreetName + ' ' + rec.AddressStreetSuffix;
                        newAddress.City__c = rec.AddressCity;
                        newAddress.State__c = rec.AddressState;
                        newAddress.Zip__c = rec.AddressZip5 + ((rec.AddressZip4 != '') ? '-' + rec.AddressZip4 : '');
                        //newAddress.Status__c = 'Accurint - XML';
                        toInsert.add(newAddress);
                    }
                }
            }
            for(String pn : phoneSet) {
                Phone_Number__c phone = new Phone_Number__c();
                phone.Source__c = 'Accurint - XML';
                phone.Account_Name__c = acct.Id;
                phone.Phone_Number__c =  '(' + pn.substring(0, 3) + ') ' + pn.substring(3, 6) + '-' + pn.substring(6);
                toInsert.add(phone);
            }
            if(toInsert.size() > 0) {
                insert toInsert;
            }
        }
        //handle Research Status updates
        if(!isPersonFound) {
            acct.Research_Status_Person__c = 'Hard to Find';
            acct.OwnerId = greerOwnerId;
        } else {
            if(isDeceased) {
                acct.Research_Status_Person__c = 'Hard to Find - Deceased';
                acct.OwnerId = greerOwnerId;
            } else {
                if(hasNewPhoneNumber) {
                    acct.Research_Status_Person__c = 'New Researched';
                    acct.OwnerId = outboundOwnerId;
                } else {
                    acct.Research_Status_Person__c = 'Needs Research';
                    acct.OwnerId = greerOwnerId;
                }
            }
        }
    }
    
    /** Class used to represent a single record response from LexisNexis */
    public class LexisNexisRecord {
        public String Type {get; set;}
        public String Gender {get; set;}
        public String AddressStreetNumber {get; set;}
        public String AddressStreetDirection {get; set;}
        public String AddressStreetName {get; set;}
        public String AddressStreetSuffix {get; set;}
        public String AddressCity {get; set;}
        public String AddressState {get; set;}
        public String AddressZip5 {get; set;}
        public String AddressZip4 {get; set;}
        public Boolean Deceased {get; set;}
        public Date DOD {get; set;}
        public String Phone10 {get; set;}
        
        public LexisNexisRecord(DOM.XMLNode recordNode) {
            this.Type = '';
            this.Gender = '';
            this.AddressStreetNumber = '';
            this.AddressStreetDirection = '';
            this.AddressStreetName = '';
            this.AddressStreetSuffix = '';
            this.AddressCity = '';
            this.AddressState = '';
            this.AddressZip5 = '';
            this.AddressZip4 = '';
 
            for (DOM.XMLNode detailNode : recordNode.getChildElements()) {
                if(detailNode.getNodeType() == DOM.XMLNodeType.ELEMENT) {
                    String nodeName = detailNode.getName().toLowerCase();
                    String nodeValue = detailNode.getText();
                    System.debug('**** Node "' + nodeName + '" = "' + nodeValue + '"');
                    if(nodeName == 'type') {
                        this.Type = nodeValue;
                    } else if(nodeName == 'gender') {
                        this.Gender = nodeValue;
                    } else if(nodeName == 'address') {
                        for(DOM.XMLNode addressNode : detailNode.getChildElements()) {
                            if(addressNode.getNodeType() == DOM.XMLNodeType.ELEMENT) {
                                String addressNodeName = addressNode.getName().toLowerCase();
                                String addressNodeValue = addressNode.getText();
                                if(addressNodeValue == null) {
                                    addressNodeValue = '';
                                }
                                if(addressNodeName == 'streetnumber') {
                                    this.AddressStreetNumber = addressNodeValue;
                                } else if(addressNodeName == 'streetpredirection') {
                                    this.AddressStreetDirection = addressNodeValue; 
                                } else if (addressNodeName == 'streetname') {
                                    this.AddressStreetName = addressNodeValue;
                                } else if (addressNodeName == 'streetsuffix') {
                                    this.AddressStreetSuffix = addressNodeValue;
                                } else if (addressNodeName == 'city') {
                                    this.AddressCity = addressNodeValue;
                                } else if (addressNodeName == 'state') {
                                    this.AddressState = addressNodeValue;
                                } else if (addressNodeName == 'zip5') {
                                    this.AddressZip5 = addressNodeValue;
                                } else if (addressNodeName == 'zip4') {
                                    this.AddressZip4 = addressNodeValue;
                                }
                            }
                        }
                    } else if(nodeName == 'deceased') {
                        this.Deceased = (nodeValue == 'Y') ? true : false;
                    } else if (nodeName == 'dod') {
                        String yearVal;
                        String monthVal;
                        String dayVal;
                        for(DOM.XMLNode dodNode : detailNode.getChildElements()) {
                            if(dodNode.getNodeType() == DOM.XMLNodeType.ELEMENT) {
                                String dodNodeName = dodNode.getName().toLowerCase();
                                String dodNodeValue = dodNode.getText();
                                if(dodNodeName == 'year') {
                                    yearVal = dodNodeValue;
                                } else if (dodNodeName == 'month') {
                                    monthVal = dodNodeValue;
                                } else if (dodNodeName == 'day') {
                                    dayVal = dodNodeValue;
                                }
                            }
                        }
                        if(yearVal != null && monthVal != null && dayVal != null) {
                            this.DOD = Date.newInstance(Integer.valueOf(yearVal), Integer.valueOf(monthVal), Integer.valueOf(dayVal));
                        }
                    } else if (nodeName == 'phoneinfo') {
                        for(DOM.XMLNode phoneNode : detailNode.getChildElements()) {
                            if(phoneNode.getNodeType() == DOM.XMLNodeType.ELEMENT) {
                                String phoneNodeName = phoneNode.getName().toLowerCase();
                                String phoneNodeValue = phoneNode.getText();
                                if(phoneNodeName == 'phone10') {
                                    this.Phone10 = phoneNodeValue;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
   

    private void updateAccount(Account acct) {
        update acct;
    }   
    public class LexisNexisException extends Exception { }
}