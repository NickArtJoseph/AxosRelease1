@RestResource(urlMapping='/Bofi_HRB_Decision/*')
global with sharing class Bofi_HRB_DecisionController {
          
   @HttpPost
    global static void createCase(String RequestID, String Decision, String Score, String Transcript, String Decision_By) {
    System.debug('RequestID Decision ' + RequestID + ', ' + Decision);
    HRB_Refund_Advance__c HRB_UPD_Rec = [SELECT Id, Refund_Advance_Application_ID__c, AutoDecision__c, Score__c,Transcript__c, DecisionBy__c FROM HRB_Refund_Advance__c where Refund_Advance_Application_ID__c =:RequestID limit 1];
    System.debug(Decision);
    System.debug(Score);
    System.debug(Transcript);
    System.debug(Decision_By);
    HRB_UPD_Rec.AutoDecision__c = Decision;      
    HRB_UPD_Rec.Score__c       = Score;
    HRB_UPD_Rec.Transcript__c  = Transcript;
    HRB_UPD_Rec.DecisionBy__c  = Decision_By;
    
   Update HRB_UPD_Rec; 

   }  
   //string token = '/d';
   // string a='asdf';
}