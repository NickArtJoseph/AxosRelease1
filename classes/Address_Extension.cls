public with sharing class Address_Extension {
	// When this is set, it will trigger the lookup on the address to the USPS
	public string USPSUserIDCode {get; set;}

	public final Address__c CurrentAddress {get; set;}
	
	public Address_Extension(ApexPages.StandardController stdController) {
		
		USPSUserIDCode = '';
		this.CurrentAddress = (Address__c)stdController.getRecord();
	} // constructor
	
	public pagereference validate() {
        
        // if the address validation hasn't been triggered, trigger it here
        if (USPSUserIDCode == '') {

			// Confirm you have an address before setting the code
			// without an address, the component won't actually do anything
			if (CurrentAddress.Address_Line__c != '' && CurrentAddress.Address_Line__c != null) {				
				if ((CurrentAddress.Zip__c != '') || ((CurrentAddress.City__c != '') && (CurrentAddress.State__c != '')))  {
			        
			        USPSUserIDCode  = '017BOFIF0706';
			        
				} // have city and state OR Zip
			} // Address1 != ''
        	
        } // USPSUserIDCode == ''

		// Add any other form validation or save code here
		return null;
		         		
	} // validate
}