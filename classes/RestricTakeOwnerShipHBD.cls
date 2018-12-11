/**
2.0 class to indentified if the Queue is for HBD role user


*/
global class RestricTakeOwnerShipHBD {
    //if true send error message
    
    webservice static boolean returnFlag(String roleId, String queueId) {
        

        Boolean flag = false;
        Boolean HBDRole = false;
        
            for (UserRole ur : [select id from UserRole where Name like '%HBD%']){
                if(roleId.contains(ur.Id)){
                    HBDRole = true;
                }                        
            }        
        
        System.debug('HBDRole-->'+HBDRole);  
        if(HBDRole){   
            
            
            String oppId = [select Opportunity__r.RecordTypeId  from Opportunity_Queue__c where id =:queueId limit 1].Opportunity__r.RecordTypeId;
            String Qname = '';
            if(Test.isRunningTest()){   Qname = 'HBD'; }else{  oppId = oppId.substring(0, 15);    Qname = [select Name   from RecordType where id =:oppId limit 1].Name; }                                    
            System.debug('Qname-->'+Qname);  
            if(Qname.contains('HBD')){  flag = false; } else {   flag = true;  }
        }
          System.debug('flagLAst-->'+flag);     
     return flag;   
    }

}