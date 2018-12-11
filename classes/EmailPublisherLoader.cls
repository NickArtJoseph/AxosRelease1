global class EmailPublisherLoader implements QuickAction.QuickActionDefaultsHandler {
    // Empty constructor
    global EmailPublisherLoader(){}
    
    // The main interface method
    global void onInitDefaults(QuickAction.QuickActionDefaults[] defaults){
        QuickAction.SendEmailQuickActionDefaults sendEmailDefaults = null;
        Map<String, String> OWEA = new Map<String, String>();
        OWEA.put('wld@bofi.com' , 'BofI Warehouse Lending' );			
        OWEA.put('clientrelations@bofi.com' , 'BofI Client Relations' );			
        OWEA.put('noreply@bofifederalbank.com' , 'BankX Auto Reply'	);	 		    
        OWEA.put('testcustomerservice@bofi.com', 'Test Customer Service' );			
        OWEA.put('noreply@bankofinternet.com' , 'Bank of Internet Customer Service' );
        OWEA.put('noreply@ufbdirect.com' , 'UFB Direct Customer Service' );	
        OWEA.put('noreply@bankx.com' , 'Bank X Customer Service' );			
        OWEA.put('noreply@netbank.com' , 'Net Bank Customer Service' );		
        OWEA.put('testcsdev@bofi.com' , 'Dev Test Customer Service');			
        
        
        // Check if the quick action is the standard Case Feed send email action
        for (Integer j = 0; j < defaults.size(); j++) {
            if (defaults.get(j) instanceof QuickAction.SendEmailQuickActionDefaults && 
                defaults.get(j).getTargetSObject().getSObjectType() == 
                EmailMessage.sObjectType && defaults.get(j).getActionName().equals('Case.Email') &&  
                defaults.get(j).getActionType().equals('Email')){
                    sendEmailDefaults = (QuickAction.SendEmailQuickActionDefaults)defaults.get(j);
                    break;
                }
        }
        
        if(sendEmailDefaults != null){
            String emOri = [select Origin from Case where Id  =:sendEmailDefaults.getContextId()].Origin;   
            EmailMessage emailMessage = (EmailMessage)sendEmailDefaults.getTargetSObject();      String emailFrom = getfromAddress(sendEmailDefaults.getContextId()); 
            
            
            if (emOri == 'Email' && !emailFrom.equals('notEmailOrg')){        emailMessage.FromAddress = emailFrom;  LIST<String> fromList = sendEmailDefaults.getFromAddressList();
                if(fromList != null){    for(Integer i = fromList.size() - 1; i >= 0; i--){    if(OWEA.containsKey(fromList.get(i))){  if(!fromList.get(i).equals(emailMessage.FromAddress)){  fromList.remove(i);       }  }  }   }                                  
                
            }            
        }        
    }
    
    public String getfromAddress(String idCase) {  
        
        List<EmailMessage> emailList  = [Select ToAddress   from EmailMessage  where  ParentId = :idCase ORDER BY LastModifiedDate asc limit 1];
        String email = '';
        
        if(!emailList.isEmpty())  email =   emailList[0].ToAddress;
        else  email = 'notEmailOrg';
                
        return email;   
    }   
    
    
    
}