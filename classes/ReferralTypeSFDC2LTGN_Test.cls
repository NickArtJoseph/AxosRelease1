@isTest
private class ReferralTypeSFDC2LTGN_Test {

    static testMethod void referralTest() {
    
          
		// Set up test data for calling record
		Account account = TestDataFactory.createAndInsertTestPersonAccount();
		RecordType referToType = [select id from RecordType where SObjectType='Opportunity' and Name='CRESL SFDC2'];

		Profile userProfile = new Profile();
		Profile adminProfile = new Profile();
		for(Profile prof : [select id, Name from Profile where Name in ('Enterprise User', 'System Administrator')]) {
			if(prof.Name == 'System Administrator') {
				adminProfile = prof;
			} else if (prof.Name == 'Enterprise User') {
				userProfile = prof;
			}
		}		
		User mgr = new User(alias='test6453', profileId=adminProfile.Id, lastName='testLast6453', firstName='testFirst', userName='test6453Ref@test.com',
							 email='test6453@test.com', CommunityNickname='test6453', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
							 EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
		insert mgr;
		User user = new User(alias='test645', profileId=userProfile.Id, lastName='testLast645', firstName='testFirst', userName='test645Ref@test.com',
							 email='test645@test.com', CommunityNickname='test645', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
							 EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', ManagerId=mgr.Id, Department='Test', Division='Test', Trained_SFDC2__c=true);
		insert user;
		Opportunity opp = new Opportunity(Name = 'test opp', AccountId = account.Id, StageName = '1 - New', CloseDate = Date.today());
                       
					insert opp;
                System.runAs(mgr) {
                         
			ReferralTypeSFDC2LTGN.getInitData(opp.Id);
                        ReferralTypeSFDC2LTGN.create(String.valueOf(opp.Id), 'EQF SFDC2', 'Notestest');
                }
    }
}