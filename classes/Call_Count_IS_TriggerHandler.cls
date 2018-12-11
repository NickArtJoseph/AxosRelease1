public class Call_Count_IS_TriggerHandler {

    
	public static void rollupDials(List<Task> listOfTasks){
		List<String> campaignList = new List<String>();
		List<CampaignMember> campmemberlist = new List<CampaignMember>();
		Map<String, String> campaignIdMap = new Map<String, String>();
		
		for(Task t : listOfTasks){
					
			if(t.isdc_dialer_list_name__c != null && t.CallDisposition != null)
				campaignIdMap.put(t.isdc_dialer_list_name__c,t.WhoId);
		}
		System.debug('campaignIdMap: '+campaignIdMap);
            
		for(Campaign cmp : [SELECT Id, Name, (SELECT CampaignId,LeadOrContactId,Call_Attempts__c,Status,Type FROM CampaignMembers) FROM Campaign WHERE Name IN :campaignIdMap.keySet()]){
			for(CampaignMember cm : cmp.CampaignMembers){
				if(cm.LeadOrContactId == campaignIdMap.get(cmp.Name)){
					cm.Call_Attempts__c = (cm.Call_Attempts__c != null? cm.Call_Attempts__c : 0) + 1;
					campmemberlist.add(cm);
				}
			}
		}
        
		update campmemberlist;
	}

	
    
}