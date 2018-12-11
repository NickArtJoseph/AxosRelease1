@isTest
private class ApplicationService_Test {
    
    @testSetup
    static void setup() {
    	Application_Question_SFDC2__c t1 = new Application_Question_SFDC2__c();
    	t1.Question_Code__c = 'test1';
    	t1.Question_Text__c = 'This is the first test question';
    	Application_Question_SFDC2__c t2 = new Application_Question_SFDC2__c();
    	t2.Question_Code__c = 'test2';
    	t2.Question_Text__c = 'This is the second test question';
    	Application_Question_SFDC2__c[] questions = new Application_Question_SFDC2__c[]{t1,t2};
    	insert questions;
    }
    
    @isTest
    static void testMeridianLinkApplicationService() {
        RestRequest request = new RestRequest();
		request.requestURI = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/Application/v1/meridianlink/test';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'text/xml');
        String uniqueId = 'TestMeridian_' + Datetime.now().format('yyyyMMddHHmmss');
        request.addHeader('Content-Disposition', 'attachment; filename="'+ uniqueId + '.xml"');
        String testXML = meridianlink_basic_xml;
        request.requestBody = Blob.valueOf(testXML);
        RestContext.request = request;
        Test.startTest();
        ApplicationService.uploadXml();
        Test.stopTest();
        Application_SFDC2__c app = [SELECT Id FROM Application_SFDC2__c WHERE Name = :uniqueId];
        System.assert(app != null);
    }

    @isTest
    static void testInvalidXmlFormat() {
        String source = 'invalidsource';
        String filename = 'InvalidSourceAndXml.xml';
        Blob fileattach = Blob.valueOf(bad_xml);
        ApplicationServiceHandler hdl = new ApplicationServiceHandler(source, filename, fileattach);
        hdl.isTest = true;
        try{
        	hdl.processFile(source, filename, fileattach);
            System.assert(false);
        } catch (ApplicationServiceHandler.ApplicationServiceHandlerException ae) {
            System.assert(ae.getMessage().endsWith('source.'));
            hdl.handleError(ae, 'ApplicationService_Test', filename);
        }
        
        //use valid source but invalid file format
        try{
            hdl.processFile('meridianlink', filename, fileattach);
            System.assert(false);
        } catch (ApplicationServiceHandler.ApplicationServiceHandlerException ae) {
            System.assert(ae.getMessage().contains('invalid XML format'));
            hdl.handleError(ae, 'ApplicationService_Test', filename);
        }
    }
    
    @isTest
    static void testMeridianLinkApplicationServiceHandler() {
        ApplicationServiceHandler hdl = new ApplicationServiceHandler();
        
        String source = 'meridianlink';
        String filename = 'TestMeridianFull_' + Datetime.now().format('yyyyMMddHHmmss');
        Blob fileattach = Blob.valueOf(meridianlink_full_xml);
        hdl = new ApplicationServiceHandler(source, filename + '.xml', fileattach);
        hdl.isTest = true;
        hdl.processFile(source, fileName + '.xml', fileattach);
        Application_SFDC2__c app = [SELECT Id, (SELECT Id FROM Applicants__r), (SELECT Id FROM Application_Accounts__r), (SELECT Id FROM Application_Answers__r) FROM Application_SFDC2__c WHERE Name = :filename];
        System.assert(app != null);
        System.assertEquals(2, app.Applicants__r.size());
        System.assertEquals(4, app.Application_Accounts__r.size());
        System.assertEquals(2, app.Application_Answers__r.size());
    }
    
    private static String bad_xml = '<INVALID_ROOT><TEST></TEST></INVALID_ROOT>';
    private static String meridianlink_basic_xml = '<XPRESS_LOAN xmlns="http://www.meridianlink.com/CLF" version="5.150"><APPLICANTS><APPLICANT first_name="TEST" last_name="APPLICANT" d3p1:internal_borrower_id="TestMeridian_' + Datetime.now().format('yyyyMMddHHmmss') + '" xmlns:d3p1="http://www.meridianlink.com/InternalUse"></APPLICANT></APPLICANTS></XPRESS_LOAN>';
    private static String meridianlink_full_xml = '<XPRESS_LOAN xmlns="http://www.meridianlink.com/CLF" version="5.150">' + 
        '<SPECIAL_INFO special_account_type_code="t" special_account_type_id="t" allow_direct_mail="t" allow_email_solicit="t" allow_share_info="t" allow_telemarket="t" ' +
        'mailing_city="t" city="t" country="t" email="t@test.com" mailing_address1="t" mailing_country="t" mailing_state="t" mailing_zip="t" phone="t" name="t" ' +
		'state="t" zip="t" establish_date="2016-01-01" id_ver_result="t" is_mailing_current="t" member_number="t" />' +
		'<SYSTEM type="t" xmlns:d2p1="http://www.meridianlink.com/InternalUse" d2p1:loan_id="TestMeridianLoan_' + Datetime.now().format('yyyyMMddHHmmss') + '" loan_number="t" source="t" >' +
		    '<APPROVAL_OFFICER code="t" email="t@test.com" reference_id="t" name="t" phone="t" />' +
			'<DECIDING_OFFICER code="t" email="t@test.com" reference_id="t" name="t" phone="t" />' +
			'<LOAN_OFFICER code="t" email="t@test.com" reference_id="t" name="t" phone="t" />' +
			'<ORIGINATOR code="t" email="t@test.com" reference_id="t" name="t" phone="t" />' +
			'<BOOKING_OFFICER code="t" email="t@test.com" reference_id="t" name="t" phone="t" />' +
		'</SYSTEM>' +
        '<APPLICANTS>' +
        	'<APPLICANT xmlns:d3p1="http://www.meridianlink.com/InternalUse" d3p1:internal_borrower_id="TestMeridianApplicant1_' + Datetime.now().format('yyyyMMddHHmmss') + '" allow_direct_mail="t" allow_email_solicit="t" allow_telemarket="t" bankruptcy_score="1" cell_phone="t" credit_score="1" custom_score="1" ' +
        	'dob="2012-01-01" email="t@test.com" first_name="t" home_phone="t" is_declined="t" last_name="t" marital_status="t" member_number="t" middle_name="t" mother_maiden_name="t" number_in_household="1" preferred_contact_method="t" role_type="t" ssn="t" work_phone="t" ' +
        	'work_phone_extension="t">' +
        		'<CURRENT_ADDRESS>' +
        			'<LOOSE_ADDRESS street_address_1="t" street_address_2="t" city="t" county="t" state="t" zip="t" />' +
        		'</CURRENT_ADDRESS>' +
        		'<MAILING_ADDRESS street_address_1="t" street_address_2="t" city="t" state="t" zip="t" />' +
        		'<PREVIOUS_ADDRESS street_address_1="t" street_address_2="t" city="t" county="t" state="t" zip="t" />' +
        		'<APPLICANT_QUESTIONS>' +
        			'<APPLICANT_QUESTION question_name="test1" question_type="text">' +
          				'<APPLICANT_QUESTION_ANSWER answer_text="No" answer_value="No" />' +
			        '</APPLICANT_QUESTION>' +
        			'<APPLICANT_QUESTION question_name="test2" question_type="text">' +
						'<APPLICANT_QUESTION_ANSWER answer_text="TEST" answer_value="N" />' +
        			'</APPLICANT_QUESTION>' +
        		'</APPLICANT_QUESTIONS>' +
        	'</APPLICANT>' +
        	'<APPLICANT xmlns:d3p1="http://www.meridianlink.com/InternalUse" d3p1:internal_borrower_id="TestMeridianApplicant2_' + Datetime.now().format('yyyyMMddHHmmss') + '" allow_direct_mail="t" allow_email_solicit="t" allow_telemarket="t" bankruptcy_score="1" cell_phone="t" credit_score="1" custom_score="1" ' +
        	'dob="2012-01-01" email="t@test.com" first_name="t" home_phone="t" is_declined="t" last_name="t" marital_status="t" member_number="t" middle_name="t" mother_maiden_name="t" number_in_household="1" preferred_contact_method="t" role_type="t" ssn="t" work_phone="t" ' +
        	'work_phone_extension="t">' +
        		'<CURRENT_ADDRESS>' +
        			'<LOOSE_ADDRESS street_address_1="t" street_address_2="t" city="t" county="t" state="t" zip="t" />' +
        		'</CURRENT_ADDRESS>' +
        		'<MAILING_ADDRESS street_address_1="t" street_address_2="t" city="t" state="t" zip="t" />' +
        		'<PREVIOUS_ADDRESS street_address_1="t" street_address_2="t" city="t" county="t" state="t" zip="t" />' +
        	'</APPLICANT>' +
        '</APPLICANTS>' +
        '<APPROVED_ACCOUNTS>' +
	        '<ACCOUNT_TYPE xmlns:d3p1="http://www.meridianlink.com/InternalUse" amount_deposit="1" apy="1" source_of_funds="t" interest_rate_type="t" is_rate_override="t" issue_date="2016-01-01" account_name="t" account_Number="t1" product_code="t" ' +
    	    'rate="1" term="1" term_type="t" account_type="t" d3p1:approved_account_type_id="TestMeridianApprovedAccount1_' + Datetime.now().format('yyyyMMddHHmmss') + '" />' +
   	        '<ACCOUNT_TYPE xmlns:d3p1="http://www.meridianlink.com/InternalUse" amount_deposit="1" apy="1" source_of_funds="t" interest_rate_type="t" is_rate_override="t" issue_date="2016-01-01" account_name="t" account_Number="t2" product_code="t" ' +
    	    'rate="1" term="1" term_type="t" account_type="t" d3p1:approved_account_type_id="TestMeridianApprovedAccount2_' + Datetime.now().format('yyyyMMddHHmmss') + '" />' +
        '</APPROVED_ACCOUNTS>' +
        '<INTERESTED_ACCOUNTS>' +
	        '<ACCOUNT_TYPE xmlns:d3p1="http://www.meridianlink.com/InternalUse" apy="1" source_of_funds="t" interest_rate_type="t" is_rate_override="t" issue_date="2016-01-01" account_name="t" product_code="t" ' +
    	    'rate="1" term="1" term_type="t" account_type="t" d3p1:internal_account_type_id="TestMeridianInterestedAccount1_' + Datetime.now().format('yyyyMMddHHmmss') + '" />' +
   	        '<ACCOUNT_TYPE xmlns:d3p1="http://www.meridianlink.com/InternalUse" apy="1" source_of_funds="t" interest_rate_type="t" is_rate_override="t" issue_date="2016-01-01" account_name="t" product_code="t" ' +
    	    'rate="1" term="1" term_type="t" account_type="t" d3p1:internal_account_type_id="TestMeridianInterestedAccount2_' + Datetime.now().format('yyyyMMddHHmmss') + '" />' +
        '</INTERESTED_ACCOUNTS>' +
        '<LOAN_INFO submit_date="2000-12-10T12:48:44-08:00" is_new_customer="Y" status="APPROVED" ' +
        	'create_date="2000-12-10T12:27:15-08:00" account_position="1" entity_type="P" ' + 
        	'last_modified="2000-12-10T13:28:27-08:00" is_claimed="N" is_locked="Y" is_minor="N" ' +
        	'is_lender_disclosure_checked="N" is_possible_dupe="N" approval_date="2000-12-10T12:55:09-08:00" ' +
        	'booking_date="2000-12-10T13:15:32-08:00" />' +
        '<CUSTOM_QUESTIONS>' +
        	'<CUSTOM_QUESTION question_name="test1">' +
        		'<CUSTOM_QUESTION_ANSWER answer_text="t" />' +
        	'</CUSTOM_QUESTION>' +
        	'<CUSTOM_QUESTION question_name="test2">' +
        		'<CUSTOM_QUESTION_ANSWER answer_text="t" />' +
        	'</CUSTOM_QUESTION>' +
        '</CUSTOM_QUESTIONS>' +
    '</XPRESS_LOAN>';
}