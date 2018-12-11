public class BOFI_IFL_Controller {
    HRBRefundStatus__c RId;
    String currUser;
    public Id RecId {get; set;}
    public String usr{get;set;}
    public ApexPages.StandardSetController controller {
        get {
            if(controller == null) {
                controller = new ApexPages.StandardSetController(Database.getQueryLocator([Select HRB_Refund_Advance__c, SLAMinutes__c, HRB_Refund_Advance__r.IRS_Phone_Number__c, HRB_Refund_Advance__r.ManualDecision__c,HRB_Refund_Advance__r.SSN_TIN__c,HRB_Refund_Advance__r.First_Name__c, HRB_Refund_Advance__r.Current_Year_Tax_Refund_Amount__c, CreatedAt__c FROM HRBRefundStatus__c Where HRB_Refund_Advance__r.HRBDecision__c=Null AND HRB_Refund_Advance__r.DecisionBy__c='manual' AND HRB_Refund_Advance__r.ManualDecision__c = Null and (HRB_Refund_Advance__r.Owner.Name = 'HRB-API1' or HRB_Refund_Advance__r.Owner.Name = 'HRB Queue' or HRB_Refund_Advance__r.Owner.Name =: currUser) order by CreatedDate desc]));
            }
            return controller;
        }
        set;
    }

    public String usr() {
        String currUser = UserInfo.getName();
        return currUser;
    }

    public List<HRBRefundStatus__c> getRecords(){
        List<HRBRefundStatus__c> Records=(List<HRBRefundStatus__c>) controller.getRecords();
        return Records;
    }
    public BOFI_IFL_Controller (){
        List<HRBRefundStatus__c> Records=[select HRB_Refund_Advance__c, CreatedAt__c, SLAMinutes__c, HRB_Refund_Advance__r.IRS_Phone_Number__c, HRB_Refund_Advance__r.ManualDecision__c,HRB_Refund_Advance__r.SSN_TIN__c,HRB_Refund_Advance__r.First_Name__c, HRB_Refund_Advance__r.OwnerId, HRB_Refund_Advance__r.Owner.Name, HRB_Refund_Advance__r.Current_Year_Tax_Refund_Amount__c from  HRBRefundStatus__c Where HRB_Refund_Advance__r.HRBDecision__c=Null AND HRB_Refund_Advance__r.DecisionBy__c='manual' AND HRB_Refund_Advance__r.ManualDecision__c = Null and (HRB_Refund_Advance__r.Owner.Name = 'HRB-API1' or HRB_Refund_Advance__r.Owner.Name ='HRB Queue' or HRB_Refund_Advance__r.Owner.Name =: currUser) order by CreatedDate desc];
        controller=new Apexpages.StandardSetController(Records);
        controller.setPageSize(1);
        RId = (HRBRefundStatus__c)controller.getRecord();
    }
    public PageReference UpdStatusToAccept(){
        String master  = [Select HRB_Refund_Advance__c from  HRBRefundStatus__c where id  =:RecId].HRB_Refund_Advance__c;
        HRB_Refund_Advance__c  HRBUp = new HRB_Refund_Advance__c (id = master, ManualDecision__c = 'APD', HRBDecision__c = 'APD') ;
        Update HRBUp;  
        PageReference retURL = new PageReference('/apex/BOFI_IFL_Page');
        retURL.setRedirect(true);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info,'Manual APD'));
        return retURL;
    }
    public PageReference UpdStatusToReject(){
        String master  = [Select HRB_Refund_Advance__c from  HRBRefundStatus__c where id  =:RecId].HRB_Refund_Advance__c;
        HRB_Refund_Advance__c  HRBUp = new HRB_Refund_Advance__c (id = master, ManualDecision__c = 'DCL', HRBDecision__c = 'DCL') ;
        Update HRBUp;        
        PageReference retURL = new PageReference('/apex/BOFI_IFL_Page');
        retURL.setRedirect(true);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info,'Manual DCL'));
        return retURL;            
    } 
    public PageReference quit() {
        String hrbApi = [select Id from User where Name = 'HRB-API1'].Id;
        String master  = [Select HRB_Refund_Advance__c from  HRBRefundStatus__c where id  =:RecId].HRB_Refund_Advance__c;
        HRB_Refund_Advance__c  HRBUp = new HRB_Refund_Advance__c (id = master, OwnerId = hrbApi);
        Update HRBUp;
        PageReference retURL = new PageReference('/apex/BOFI_IFL');
        retURL.setRedirect(true);
        return retURL;
    } 
}