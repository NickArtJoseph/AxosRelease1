public class UpdateUserLastLoginBowser {
    @InvocableMethod 
    public static void getLastLoginFromBrowser( ){
        
        List<User> ltsUser = new List<User>();
        Integer dayBack = integer.valueof(Label.DaysBack);        
        DateTime dtM = System.now()-dayBack;
        List<AggregateResult> l = [Select UserId from LoginHistory where  LoginType='Application' and LoginTime >= :dtM group by UserId  ];
        set<id> logUserId = new set<id>();
        for(AggregateResult a : l) {
            logUserId.add((id)a.get('UserId')); 
            
        }
        List<LoginHistory> ltsLH = [Select LoginTime, Application,Status,UserId  
                                    from LoginHistory where UserId in :logUserId and LoginType='Application' and  LoginTime >= :dtM
                                    order by Application,Status, LoginTime desc];
        
        integer TotalLicenses  = [SELECT   TotalLicenses FROM UserLicense where name ='Salesforce' ].TotalLicenses;
        set<Id> ltsUrsLogH = new set<Id>();
        List<Weekly_User_Reporting__c> ltsUW = new List<Weekly_User_Reporting__c>();
        Map<Id,Profile> profileIds = new Map<id,profile>([SELECT Id,UserLicenseId FROM Profile where UserLicenseId  in (SELECT Id FROM UserLicense where name ='Salesforce')]);    
        
        for (LoginHistory lh : ltsLH) {
            if(lh.Application == 'Browser' && lh.Status == 'Success' && !ltsUrsLogH.contains(lh.UserId) ){
                
                Date getFirstDate = date.newinstance(lh.LoginTime.year(), lh.LoginTime.month(), lh.LoginTime.day());  
                User u = new user(id = lh.UserId, Last_Browser_Login_Date__c = getFirstDate);                                          
                ltsUser.add(u); 
                Weekly_User_Reporting__c wu = new Weekly_User_Reporting__c();
                wu.User__c =  lh.UserId;
                wu.Last_Browser_Login_Date__c = getFirstDate;
                wu.Number_of_Total_Licenses__c = TotalLicenses;
                wu.Logged_in_within_past_week__c = true;
                ltsUW.add(wu); 
                ltsUrsLogH.add(lh.UserId);
                
            }  
            
        }   
        
        update ltsUser;
        insert ltsUW;
        List<Weekly_User_Reporting__c> noltsUW = new List<Weekly_User_Reporting__c>();
        
        List<user> noStandardProfileUsers = [select id from user where profileId in:profileIds.Keyset() and id not in:ltsUrsLogH and isActive = true];     
        List<User> noltsUser = new List<User>();
        for(User noUsr : noStandardProfileUsers){
            Date defDate = date.newinstance(1900, 01, 01); 
            User u = new user(id = noUsr.Id, Last_Browser_Login_Date__c = defDate);
            noltsUser.add(u);
            Weekly_User_Reporting__c wu2 = new Weekly_User_Reporting__c();
            wu2.Number_of_Total_Licenses__c = TotalLicenses;
            wu2.User__c =  noUsr.Id;
            wu2.Last_Browser_Login_Date__c = defDate;
            wu2.Logged_in_within_past_week__c = false;
            noltsUW.add(wu2);
        }
        update noltsUser;
        insert noltsUW;
        
    }
    
    
}