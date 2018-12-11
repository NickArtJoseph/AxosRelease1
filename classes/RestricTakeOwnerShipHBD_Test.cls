@isTest
public class RestricTakeOwnerShipHBD_Test {

    
      static testMethod void referralTest() {
		
          Test.startTest();
          UserRole ur  = [select id, Name from UserRole where Name = 'HBD'];
          
          Profile userProfile = new Profile();
          Profile adminProfile = new Profile();
          for(Profile prof : [select id, Name from Profile where Name in ('Enterprise User', 'System Administrator')]) {
              if(prof.Name == 'System Administrator') {
                  adminProfile = prof;
              } else if (prof.Name == 'Enterprise User') {
                  userProfile = prof;
              }
          }    
          User mgr = new User(alias='test6453', profileId=adminProfile.Id, lastName='testLast6453', firstName='testFirst', userName='test6453@test.com',
                              email='test6453@test.com', CommunityNickname='test6453', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',
                              EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
          insert mgr;
          User user = new User(alias='test645', profileId=userProfile.Id, lastName='testLast645', firstName='testFirst', userName='test645@test.com',
                               email='test645@test.com', CommunityNickname='test645', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US',UserRoleId = ur.Id,
                               EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', ManagerId=mgr.Id, Department='Test', Division='Test', Trained_SFDC2__c=true);
          insert user;

          
          System.runAs(user) {
              
              RecordType accBB = [select Id from RecordType where SObjectType='Account' and DeveloperName='Business_Account_SFDC2'];
              Account acc = new Account (Name = 'Acc Test', RecordTypeId = accBB.Id );
              RecordType oppHBD = [select Id from RecordType where SObjectType='Opportunity' and DeveloperName='HBD_SFDC2'];
              Date myDate = Date.newInstance(2017,10,12);
              Opportunity opp =  new Opportunity (Name  = 'Test HBD', AccountId = acc.Id, StageName = '1 - New', CloseDate = myDate , Loan_HBD__c = '685165', RecordTypeId = oppHBD.Id);
              insert opp;
              Opportunity_Queue__c oq = new Opportunity_Queue__c(Opportunity__c = opp.id);              
              insert oq; 
              // roleId,  queueId
              RestricTakeOwnerShipHBD.returnFlag(user.UserRoleId,oq.Id);
              
          }
		  Test.stopTest();
                   
      
      }    
}