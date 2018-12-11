@isTest
public class EmailPublisherLoader_test {
    
    
    
    static testmethod void DefaultCaseFeedEmailImplementor_SimpleTest()    {
        //Create test data here
        Exception failureDuringExecution = null;
        
        String defaultsAsJSON = '[{"targetSObject":{"attributes":{"type":"EmailMessage"},"TextBody":"",'
            + '"FromName":"Test","FromAddress":"test@example.com","HtmlBody":"<html><body></body></html>","BccAddress":"test@example.com",'
            + '"CcAddress":"","ToAddress":"test@example.com","Subject":"Testing"},"contextId":"50011000005ZtcRAAS","actionType":"Email",'
            + '"actionName":"Case.Email","fromAddressList":["salesforce@test.com"]}]';
        List<QuickAction.SendEmailQuickActionDefaults> defaultsSettings = 
            (List<QuickAction.SendEmailQuickActionDefaults>)JSON.deserialize(defaultsAsJSON, List<QuickAction.SendEmailQuickActionDefaults>.class);
        
        Test.startTest();
        try { (new EmailPublisherLoader()).onInitDefaults(defaultsSettings); 
            
            }
        catch(Exception failure) { failureDuringExecution = failure; }
         EmailPublisherLoader e = new EmailPublisherLoader(); 
             e.getfromAddress('123451234512345');
        Test.stopTest();
        
      
        //Make other assertions here
    }
}