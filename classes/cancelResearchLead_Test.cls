@isTest

public class cancelResearchLead_Test {

   static testMethod void cancelRequestResearch() {

        User userBU, userRM;
        try {
            userBU = [select id from User where IsActive=True and Profile.Name='Enterprise User' and UserRole.Name!='Research Manager' LIMIT 1];
            userRM = [select id from User where IsActive=True and Profile.Name='Enterprise User' and UserRole.Name='Research Manager' LIMIT 1];
        } catch (QueryException qe) {
            System.debug(qe);
            return;
        }

        RecordType businessRT = [select Id from RecordType where SObjectType='Lead' and DeveloperName='Business_Banking'];
        RecordType businessProspectRT = [select Id from RecordType where SObjectType='Lead' and DeveloperName='Prospecting_Business_SFDC2'];

	Lead businessLead = new Lead(FirstName='Test_First', LastName='Test_Consumer', OwnerId=userBU.Id, RecordTypeId=businessRT.Id, Company='Test_Company');
        insert businessLead;
         System.debug('userRM.Id' +userRM.Id);
        System.debug('userBU.Id' +userBU.Id);
        businessLead.OwnerId=userRM.Id;
        businessLead.RecordTypeId=businessProspectRT.Id;
        businessLead.Return_Record_Type_SFDC2__c = businessRT.Id;
        businessLead.Return_Owner_SFDC2__c = userBU.Id;
        Update businessLead;
        CancelResearchLead.returnLead(businessLead.Id, userBU.Id);
   }      

    
    
}