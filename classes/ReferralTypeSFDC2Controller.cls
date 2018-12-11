/**
 * Controller for VF page used to set Record Type for
 * new referral opportunities
 */
public with sharing class ReferralTypeSFDC2Controller {
   
	public String ReferTo {get; set;}	
	public String Notes {get; set;}
	
	/**
	 * Check that the user creating the referral is the owner of the referred from Opportunity
	 * @return Null page reference to allow error message to be shown
	 */
	public Boolean checkUser {
		get {
			List<Opportunity> opps = [select Id, OwnerId from Opportunity where AccountId=:ApexPages.currentPage().getParameters().get('accountId') and IsClosed=false];
			if (opps == null) {
				return false;
			} else {
				for (Opportunity opp : opps) {
					if (opp.OwnerId == UserInfo.getUserId()) return true;
				}
				return false;
			}
		}
	}
	
    /**
     * Verify that the user would not normally have access to one or more SFDC2 Opportunity record types.
     * (If they have access to all SFDC2 record types, as in the case of an admin, they don't need to use
     *  the referral process. They can create the Opportunity directly.)
     */
    public Boolean checkAccess {
        get {
	        If(ReferToList.size()>0) {
	            return true;
	        } 
	        return false;
        }
    }
    
	public String userId {
		get {
			return UserInfo.getUserId();
		}
	}
	
	/**
	 * Generate the Record Type PickList for SFDC2 Opportunities
	 * excluding the one associated with the User creating the referral
	 * @return List of Record Type Ids and Names
	 */
	public List<SelectOption> ReferToList {
		get {
			List<SelectOption> referToList = new List<SelectOption>();
			for(RecordTypeInfo info: Opportunity.SObjectType.getDescribe().getRecordTypeInfos()) {
    			if((info.getName() == 'Advisor Recruiting SFDC2'
                    || info.getName() == 'Advisory SFDC2'
                    || info.getName() == 'Auto Loan Indirect SFDC2'
                    || info.getName() == 'Business Banking SFDC2'
                    || info.getName() == 'Consumer Deposits SFDC2'
                    || info.getName() == 'Dealership Recruiting SFDC2'
                    || info.getName() == 'Virtus SFDC2'
                    || info.getName() == 'IPL SFDC2'
                    || info.getName() == 'Epiq SFDC2'
                    || info.getName() == 'Dealer Services - Applicant SFDC2'
                    || info.getName() == 'ULP SFDC2'                         
    			    || info.getName() == 'HBD SFDC2')
    			    && info.isAvailable() == false) {
        			referToList.add(new SelectOption(info.getRecordTypeId(), info.getName()));
    			}
			}
			return referToList;		
		}
		set;
	}
	
	public ReferralTypeSFDC2Controller () {

	}
	
	/**
	 * Create a new Opportunity record for this referral with the appropriate Record Type
	 * @return Page reference for the new Opportunity record
	 */
	public PageReference create() {
		User user = [select Id, Name, UserRole.Name from User where id=:UserInfo.getUserId()];
		String accountId = ApexPages.currentPage().getParameters().get('accountId');
		Opportunity opp = new Opportunity(Name='Referral from ' + user.UserRole.Name, AccountId=accountId, CloseDate=Date.Today().addMonths(1),
										  Referred_By_SFDC2__c=user.Id, Referrer_Notes_SFDC2__c=Notes, RecordTypeId=ReferTo,
										  LeadSource='Cross-Sell', StageName='1 - New');
		insert opp;
        
		System.debug('ReferTo'+ReferTo);
		PageReference pr = new PageReference(ApexPages.currentPage().getParameters().get('retURL'));
		return pr;
	}
	
	/**
	 * Cancel the record insert
	 * @return Page reference to the original Account or Opportunity page
	 */
	public PageReference cancel() {
		PageReference pr = new PageReference(ApexPages.currentPage().getParameters().get('retURL'));
		return pr;		
	}
	
}