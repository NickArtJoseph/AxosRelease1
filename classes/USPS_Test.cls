/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class USPS_Test {
	static testMethod void TestUSPS() {
	
		Test.StartTest();
		
		USPS.USPSAddress MyAddress = new USPS.USPSAddress();
		
		// will return the default address		
		USPS.CheckAddress(MyAddress,'Test');
		
		// This should return an error message
		MyAddress.City = 'ERROR';
		USPS.CheckAddress(MyAddress,'Test');

		// and this shoudl return a blank address 
		// so we can test the generic error message
		MyAddress.City = 'NULL';
		USPS.CheckAddress(MyAddress,'Test');
		
		Test.StopTest();
	} // TestUSPS

    static testMethod void TestUSPSAddress() {
			
			Test.StartTest();
			
			USPS.USPSAddress MyAddress = new USPS.USPSAddress();
			
			// test the has data method
				MyAddress.HasData();
				
				MyAddress.Address1 = '6406 IVY LN';
				MyAddress.HasData();
	
				MyAddress.Address1 = '';
				MyAddress.Address2 = '6406 IVY LN';
				MyAddress.HasData();
	
				MyAddress.Address2 = '';
				MyAddress.City = 'Greenbelt';
				MyAddress.HasData();			
				
				MyAddress.City = '';
				MyAddress.State = 'MD';
				MyAddress.HasData();			
	
				MyAddress.State = '';
				MyAddress.Zip5 = '20770';
				MyAddress.HasData();			
	
				MyAddress.Zip5 = '';
				MyAddress.Zip4 = '1441';
				MyAddress.HasData();			
				
				MyAddress.Zip4 = '';
				MyAddress.USPS_Returned_Error = true;
				MyAddress.HasData();
				
				MyAddress.USPS_Returned_Error = false;
				MyAddress.USPS_ERROR_CODE = 'Test';
				MyAddress.HasData();
	
				MyAddress.USPS_ERROR_CODE = '';
				MyAddress.USPS_ERROR_DESC = 'Test';
				MyAddress.HasData();
				
				MyAddress.USPS_ERROR_DESC = '';
				MyAddress.USPS_ERROR_SOURCE = 'Test';
				MyAddress.HasData();
			
				// the object should now be empty for other testing ...
				MyAddress.USPS_ERROR_SOURCE = '';
			// end testing of has data method

			// test CanCheckAddress method			
				MyAddress.Address2 = '6406 IVY LN';
				MyAddress.Zip5 = '20770';
				MyAddress.CanCheckAddress();
	
				MyAddress.Zip5 = '';
				MyAddress.City = 'Greenbelt';
				MyAddress.State = 'MD';
				MyAddress.CanCheckAddress();
			// end testing of CanCheckAddress method
			
			// Test GetZip Method
				MyAddress.Zip5 = '20770';			
				MyAddress.Zip4 = '1441';
				MyAddress.getZip();
			// end testing of GetZip Method
			
			Test.StopTest();
		} // TestUSPSAddress
		
	static testMethod void testAddress_Extension() {
		
		Account account = new Account(Name='Test');
		insert account;
		
		Address__c address = new Address__c(Account_Name__c=account.Id, Address_Line__c='4250 La Jolla Village Drive', City__c='San Diego', State__c='CA', Zip__c='92121');
		insert address;

		Test.StartTest();
		
		Address_Extension ext = new Address_Extension(new Apexpages.StandardController(address));
		
		ext.USPSUserIDCode = 'TEST';
		
		ext.validate();
	} // TestAddress_Extension
	
	static testMethod void testUSPSAddressComp_Controller() {
		
		Address__c address = new Address__c(Address_Line__c='4250 La Jolla Village Drive', City__c='San Diego', State__c='CA', Zip__c='92121');
		
		USPSAddressComp_Controller ctr = new USPSAddressComp_Controller();
		ctr.CurrentAddress = address;
		
		Test.StartTest();
		// setting the id makes the call out to validate the address
		// the USPS class has a mock HTML Call out class for use with testing
		// so you can set your USPS ID to any non blank value and get a result		
		ctr.USPS_ID = 'TEST';
		ctr.AddressFromUSPS.getZip();
		
		ctr.UseCorrectedAddress();
		
		ctr.CurrentAddress.Zip__c = '';
		// setting the id makes the call out to validate the address
		ctr.USPS_ID = 'TEST';
		ctr.Dismiss();
		
		// testing for AddressesAreDifferent
		ctr.AddressFromUSPS.Address1 = 'test';
		ctr.AddressesAreDifferent(false);
		
		ctr.AddressFromUSPS.Address1 = ctr.Address2Check.Address1;
		ctr.AddressFromUSPS.Address2 = 'test';
		ctr.AddressesAreDifferent(false);

		ctr.AddressFromUSPS.Address2 = ctr.Address2Check.Address2;
		ctr.AddressFromUSPS.City = 'test';
		ctr.AddressesAreDifferent(false);

		ctr.AddressFromUSPS.City = ctr.Address2Check.City;
		ctr.AddressFromUSPS.State = 'AL';
		ctr.AddressesAreDifferent(false);		

		ctr.AddressFromUSPS.State = ctr.Address2Check.State;
		ctr.AddressFromUSPS.Zip5 = '90210';
		ctr.AddressesAreDifferent(false);		

		ctr.AddressFromUSPS.Zip5 = ctr.Address2Check.Zip5;
		ctr.AddressFromUSPS.Zip4 = '1234';
		ctr.AddressesAreDifferent(false);		
		ctr.AddressesAreDifferent(true);
		// end testing for AddressesAreDifferent
		
		// testing for DidTheAddressChange
		ctr.PreviousAddress.Address2 = 'Test';
		ctr.DidTheAddressChange();

		ctr.PreviousAddress.Address2 = ctr.Address2Check.Address2;
		ctr.PreviousAddress.City = 'Test';
		ctr.DidTheAddressChange();

		ctr.PreviousAddress.City = ctr.Address2Check.City;
		ctr.PreviousAddress.State = 'AL';
		ctr.DidTheAddressChange();
		// end testing for DidTheAddressChange
		
		Test.StopTest();
		
	}
}