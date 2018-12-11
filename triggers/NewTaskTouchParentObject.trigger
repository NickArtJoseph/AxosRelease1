trigger NewTaskTouchParentObject on Task (after insert) {
	//Put these in maps to ensure that each object is only in there once
	Map<Id,Account> accountsToUpdate = new Map<Id,Account>();
	Map<Id,Lead> leadsToUpdate = new Map<Id,Lead>();
	Map<Id,Opportunity> oppsToUpdate = new Map<Id,Opportunity>();
	Map<Id,Campaign> campsToUpdate = new Map<Id,Campaign>();
	Map<Id,Contact> contsToUpdate = new Map<Id,Contact>();
	Map<Id,Contract> contrsToUpdate = new Map<Id,Contract>();

	for (Task tsk:System.Trigger.new) {
		//Only CTI would set the CallType field
		if (tsk.CallType!=null && tsk.CallType!='') {
			if (tsk.WhoId!=null) {
				String whoId = tsk.WhoId;
				String whoIdPrefix = whoId.substring(0,3);

				if (whoIdPrefix.equalsIgnoreCase('00Q')) {
					Lead lead = new Lead(Id=tsk.WhoId, Last_Activity_Datetime__c=System.now());

					leadsToUpdate.put(tsk.WhoId, lead);
				} else if (whoIdPrefix.equalsIgnoreCase('003')) {
					Contact lead = new Contact(Id=tsk.WhoId, Last_Activity_Datetime__c=System.now());

					contsToUpdate.put(tsk.WhoId, lead);
				}
			}
			if (tsk.WhatId!=null) {
				String whatId = tsk.WhatId;
				String whatIdPrefix = whatId.substring(0,3);

				//Only CTI would fill the CallType field
				if (whatIdPrefix.equalsIgnoreCase('001')) {
					Account acc = new Account(Id=tsk.WhatId, Last_Activity_Datetime__c=System.now());

					accountsToUpdate.put(tsk.WhatId, acc);
				} else if (whatIdPrefix.equalsIgnoreCase('006')) {
					Opportunity acc = new Opportunity(Id=tsk.WhatId, Last_Activity_Datetime__c=System.now());

					oppsToUpdate.put(tsk.WhatId, acc);
				} if (whatIdPrefix.equalsIgnoreCase('701')) {
					Campaign acc = new Campaign(Id=tsk.WhatId, Last_Activity_Datetime__c=System.now());

					campsToUpdate.put(tsk.WhatId, acc);
				} if (whatIdPrefix.equalsIgnoreCase('800')) {
					Contract acc = new Contract(Id=tsk.WhatId, Last_Activity_Datetime__c=System.now());

					contrsToUpdate.put(tsk.WhatId, acc);
				}
			}
		}
	}

	try {
		if (accountsToUpdate.size()>0) {
			List<Account> accounts = accountsToUpdate.values();
			update accounts;
		}

		if (leadsToUpdate.size()>0) {
			List<Lead> leads = leadsToUpdate.values();
			update leads;
		}

		if (oppsToUpdate.size()>0) {
			List<Opportunity> opps = oppsToUpdate.values();
			update opps;
		}

		if (contsToUpdate.size()>0) {
			List<Contact> conts = contsToUpdate.values();
			update conts;
		}

		if (contrsToUpdate.size()>0) {
			List<Contract> contrs = contrsToUpdate.values();
			update contrs;
		}

		if (campsToUpdate.size()>0) {
			List<Campaign> camps = campsToUpdate.values();
			update camps;
		}

	} catch (System.DmlException e) {
		System.debug(e.getMessage());
	}
}