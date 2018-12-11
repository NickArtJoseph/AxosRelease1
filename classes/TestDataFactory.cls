/**
 * @description Utility class for creating records to use in unit test classes 
 * @author Mike Crosby, BofI Federal
 */
@isTest
public class TestDataFactory {

  /**
  * Creates basic test Business Account
  * @return test business account record
  */
  public static Account createTestBusinessAccount() {
  	return new Account(Name='Test Account');
  }

  public static Task createTestTaskUDB() {
    Case caseTest = new Case(
      Origin = 'UDB',
      Priority = 'Standard',
      Status = 'New',
      Description = 'Running Test',
      IsVisibleSelfService__c = false,
      recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('UDB Inquiry').getRecordTypeId());

    insert caseTest;
    Task taskTest = new Task(
      WhatId = caseTest.Id,
      Subject = 'This is a test',
      ActivityDate = System.Today(),
      recordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('UDB Comment').getRecordTypeId());

    return taskTest;
  }

  /**
  * Create and insert basic test Business Account record
  * @return test business acount record (Id only)
  */
  public static Account createAndInsertTestBusinessAccount() {
  	Account a = createTestBusinessAccount();
  	insert a;
  	return a;
  }

  /**
  * Creates basic C&I Certification
  * @param opp Opportunity record that Certification is associated with
  * @return test C&I Certification record
  */
  public static CI_Certification__c createTestCICertification(Opportunity opp) {
  	//identify a C&I user to be assigned as Certification Owner
  	User u = [SELECT Id FROM User WHERE Profile.Name LIKE 'C&I%' AND IsActive = true LIMIT 1];
  	CI_Certification__c cert = new CI_Certification__c(Name='Test',
        													Certification_Owner__c=u.Id,
        													Opportunity__c=opp.Id,
        													Status__c='In Credit Review');
    return cert;
  }
  
  /**
  * Create and insert basic C&I Certification
  * @param opp Opportunity record that Certification is associated with
  * @return test C&I Certification record (Id only)
  */
  public static CI_Certification__c createAndInsertTestCICertification(Opportunity opp) {
    CI_Certification__c c = createTestCICertification(opp);
    insert c;
    return c;
  }

  /**
  * Create basic test Contact for the Account specified
  * @param acct Account object containing at least the Account Id
  * @return test Contact record
  */
  public static Contact createTestContact(Account acct) {
  	Contact c = new Contact(AccountId=acct.Id,
  							FirstName='Test',
  							LastName='Contact',
  							Email='testcontact@test.com');
  	return c;
  }
  
  /**
  * Create basic test Lead using record type specified
  * @param recordTypeId record type id for the Lead
  * @param companyName sample company name; supply null value if creating 
  * a Lead to be converted to a Person Account
  * @return test Lead record
  */
  public static Lead createTestLead(String recordTypeId, String companyName) {
  	Lead l = new Lead(RecordTypeId=recordTypeId,
  							FirstName='Test',
  							LastName='Contact',
  							Email='testcontact@test.com');
  	if(companyName != null) {
  		l.Company = companyName;
  	}
  	return l;
  }
  
  /**
  * Create and insert basic test Lead using record type specified
  * @param recordTypeId record type id for the Lead
  * @param companyName sample company name; supply null value if creating 
  * a Lead to be converted to a Person Account
  * @return test Lead record (id only)
  */
  public static Lead createAndInsertTestLead(String recordTypeId, String companyName) {
  	Lead l = TestDataFactory.createTestLead(recordTypeId, companyName);
  	
  	insert l;
  	return l;
  }
  
  /**
  * Creates basic test Person Account record
  * @return test person account record
  */
  public static Account createTestPersonAccount() {
  	return new Account(FirstName='Test', LastName='Person');
  }
  
  /**
  * Create and insert basic test Person Account record
  * @return test person acount record (Id only)
  */
  public static Account createAndInsertTestPersonAccount() {
  	Account a = createTestPersonAccount();
  	insert a;
  	return a;
  }

  /**
  * Creates test Phone Number for specified Account
  * @param acct master account record for phone number
  * @return test phone number record
  */
  public static Phone_Number__c createTestPhoneNumber(Account acct) {
  	Phone_Number__c pn = new Phone_Number__c(Account_Name__c = acct.Id, Phone_Number__c = '(858) 649-2000');
  	return pn;
  }

  /**
  * Creates and insert test Phone Number for specified Account
  * @param acct master account record for phone number
  * @return test phone number record (Id only)
  */
  public static Phone_Number__c createAndInsertTestPhoneNumber(Account acct) {
  	Phone_Number__c pn = createTestPhoneNumber(acct);
  	insert pn;
  	return pn;
  }

  /**
  * Creates test Task for specified record
  * @param what master record for task
  * @return new task
  */
  public static Task createTestTask(sObject what) {
  	return createTestTask(what, 1, false).get(0);
  }
  
  /**
  * Creates test Task for specified record
  * @param what master record for task
  * @param cnt number of tasks to create
  * @return new task
  */
  public static Task createTestTask(sObject what, Integer cnt) {
  	return createTestTask(what, cnt, false).get(0);
  }

  /**
  * Creates test Tasks for specified record
  * @param what master record for tasks
  * @param cnt number of tasks to create
  * @param isWho if true, uses what param to populate as Who; otherwise, populates as What
  * @return list of new tasks
  */
  public static List<Task> createTestTask(sObject what, Integer cnt, Boolean isWho) {
  	List<Task> returnList = new List<Task>();
  	for(Integer i=0; i <= cnt; i++) {
  	  Task t = new Task(Subject='Test Task ' + i, Priority='Low', Status='New', Type='Call', CallType='Outbound', ActivityDate=Date.today());
  	  if(isWho) {
  	  	t.WhoId = what.Id;
  	  } else {
  	  	t.WhatId = what.Id;
  	  }
  	  returnList.add(t);
  	}
  	return returnList;
  }
  
  /**
  * Creates and inserts test users for each profile name provided
  * @param profileNameSet set of profile names to use for the test users
  * @return list of new User ids that were created based on the supplied profile names
  */
  public static List<User> createTestUsers(Set<String> profileNameSet) {
  	List<User> toInsert = new List<User>();
  	
  	//retrieve profiles for the list of profile names provided
  	Map<String,Profile> profileNameMap = new Map<String,Profile>();
  	for(Profile p : [Select Id, Name From Profile Where Name IN :profileNameSet OR Name = 'System Administrator']) {
  		profileNameMap.put(p.Name, p);
  	}
  	Profile adminProfile = profileNameMap.get('System Administrator');
  	User adminU = new User(
                        FirstName='Test',
                        LastName='UserAdmin',
                        Alias='tuseradm',
                        Email='tuseradm@test.org',
                        Username='tuseradm@test.org',
                        CommunityNickname='tuseradm',
                        ProfileId=adminProfile.Id,
                        TimeZoneSidKey='America/Los_Angeles',
                        LanguageLocaleKey='en_US',
                        LocaleSidKey='en_US',
                        EmailEncodingKey='ISO-8859-1',
                        Department='Test',
                        Division='Test',
                        Trained_SFDC2__c=true);
    insert adminU;
  	Integer index = 0;
  	
    for(String profileName : profileNameSet) {
      index++;
      Profile p = profileNameMap.get(profileName);
      
      if(p == null) {
      	throw new TestDataFactoryException('Unknown profile name: ' + profileName);
      }
      
      User u = new User(
                        FirstName='Test',
                        LastName='User' + profileName,
                        Alias='tuser' + index,
                        Email='tuser' + index+ '@test.org',
                        Username='tuser' + index + '@test.org.' + index,
                        CommunityNickname='tuser' + index,
                        ProfileId=p.Id,
                        TimeZoneSidKey='America/Los_Angeles',
                        LanguageLocaleKey='en_US',
                        LocaleSidKey='en_US',
                        EmailEncodingKey='ISO-8859-1',
                        Department='Test',
                        Division='Test',
                        Trained_SFDC2__c=true);
      if(profileName == 'Enterprise User') {
      	u.ManagerId = adminU.Id;
      }
      toInsert.add(u);
    }
    
    try {
    	insert toInsert;
    	return toInsert;
    }
    catch(Exception e) {
    	throw new TestDataFactoryException('Error inserting test users: ' + e.getMessage());
    }
  }
  
  public enum CertificationType {ACCOUNT, RECERTIFICATION, QUARTERLY}
  
  /**
  * Creates Certification record for specified Account and type
  * @param acct Account to associate certification with
  * @param cType CertificationType
  * @return test Certification record
  */
  public static WLD_Certification__c createTestCertification(Account acct, CertificationType cType) {
    Map<CertificationType, RecordType> certRTMap = new Map<CertificationType, RecordType>();
    for(RecordType rt : [
                SELECT DeveloperName
                FROM RecordType
                WHERE SobjectType = 'WLD_Certification__c'
                ]) {
      if(rt.DeveloperName == 'Account_Certification') {
        certRTMap.put(CertificationType.ACCOUNT, rt);
      } else if (rt.DeveloperName == 'Account_Recertification') {
        certRTMap.put(CertificationType.RECERTIFICATION, rt);
      } else if (rt.DeveloperName == 'Quarterly_Certification') {
        certRTMap.put(CertificationType.QUARTERLY, rt);
      }
    }
    
    WLD_Certification__c cert = new WLD_Certification__c(Name='Test',Account__c=acct.Id,RecordTypeId=certRTMap.get(cType).Id, QLR_Year__c=String.valueOf(Date.today().year()));
    
    if(cType == CertificationType.QUARTERLY) {
      cert.QLR_Quarter__c = 'QTR 1';
    }
    
    return cert;
  }

  /**
  * Creates and inserts Certification record for specified Account and type
  * @param acct Account to associate certification with
  * @param cType CertificationType
  * @return test Certification record (id only)
  */
  public static WLD_Certification__c createAndInsertTestCertification(Account acct, CertificationType cType) {
    WLD_Certification__c c = createTestCertification(acct, cType);
    insert c;
    return c;
  }
  
  /**
  * Create basic test Credit Review for the Certification specified
  * @param cert Certification object containing at least the Certification Id
  * @return test Credit Review record
  */
  public static WLD_Credit_Review__c createTestCreditReview(WLD_Certification__c cert) {
    WLD_Credit_Review__c c = new WLD_Credit_Review__c(Certification__c=cert.Id,
                Name='Test',
                Credit_Status__c='Pending Approval');
    return c;
  }
  
  public class SingleRequestMock implements HttpCalloutMock {
		protected Integer code;
		protected String status;
		protected String bodyAsString;
		protected Blob bodyAsBlob;
		protected Map<String, String> responseHeaders;

		public SingleRequestMock(Integer code, String status, String body,
                                         Map<String, String> responseHeaders) {
			this.code = code;
			this.status = status;
			this.bodyAsString = body;
			this.bodyAsBlob = null;
			this.responseHeaders = responseHeaders;
		}

		public SingleRequestMock(Integer code, String status, Blob body,
                                         Map<String, String> responseHeaders) {
			this.code = code;
			this.status = status;
			this.bodyAsBlob = body;
			this.bodyAsString = null;
			this.responseHeaders = responseHeaders;
		}

	    public HTTPResponse respond(HTTPRequest req) {
	        HttpResponse resp = new HttpResponse();
			resp.setStatusCode(code);
			resp.setStatus(status);
			if (bodyAsBlob != null) {
				resp.setBodyAsBlob(bodyAsBlob);
			} else {
				resp.setBody(bodyAsString);
			}

			if (responseHeaders != null) {
			     for (String key : responseHeaders.keySet()) {
				resp.setHeader(key, responseHeaders.get(key));
			     }
			}
			return resp;
	    }
	}
  
  public class TestDataFactoryException extends Exception {}
}