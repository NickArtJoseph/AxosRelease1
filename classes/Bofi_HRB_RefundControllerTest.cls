@isTest
private class Bofi_HRB_RefundControllerTest {
	
	@isTest static void test_createHRB_Refund() {
        //Test.setMock(HttpCalloutMock.class, new MockHRBResponseGnr8r());
        Test.setMock(HttpCalloutMock.class, new MockHerokuResponseGnr8r());
        
        //createHRB_Refund(String Application_Status, String City, String Client_Preferred_Phone, Integer Current_Year_Tax_Refund_Amount, Datetime Date_And_Timestamp_Received, Date Date_Of_Birth, Date Date_Processed, String Filing_Status, String First_Name, String Last_Name, String Middle_Name, String Refund_Advance_Application_ID, String SSN_TIN, String State, String Street, String Zip_Code) 
        Integer YEARS_30 = 30 * 365;
        String Application_Status = 'New';
        String City = 'San Diego';
        String Client_Preferred_Phone = '(123) 456-7890';
        Integer Current_Year_Tax_Refund_Amount = 0;
        Datetime Date_And_Timestamp_Received = Datetime.now();
        Date Date_Of_Birth = Date.today() - YEARS_30;
        Date Date_Processed = Date.today();
        String Filing_Status = 'Single';
        String First_Name = 'TestFirstName';
        String Last_Name = 'TestLastName';
        String Middle_Name = 'TestMiddleName';
        String Refund_Advance_Application_ID = 'Refund_Advance_Application_ID';
        String SSN_TIN = '000000000';
        String State = 'CA';
        String Street = 'Towne Ctr Dr';
        String Zip_Code = '92110';
        Bofi_HRB_RefundController.createHRB_Refund( Application_Status, City, Client_Preferred_Phone, Current_Year_Tax_Refund_Amount,  Date_And_Timestamp_Received, Date_Of_Birth, Date_Processed, Filing_Status, First_Name, Last_Name, Middle_Name, Refund_Advance_Application_ID, SSN_TIN, State,  Street, Zip_Code);
        
	}
	
	
}