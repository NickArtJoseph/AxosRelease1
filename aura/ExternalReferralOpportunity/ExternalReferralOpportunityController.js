({
    doInit : function(component, event, helper) {
        var action = component.get("c.getAvailableRecordTypes");
    	action.setCallback(this, function(response){
    		var state = response.getState();
            if(component.isValid() && (state === 'SUCCESS' || state === 'DRAFT')){
                console.log(response);
    			var recTypes = response.getReturnValue();
                var optionsList  = [];
                optionsList .push({value: '', label: 'choose one...'});
                for(var key in recTypes){
                    optionsList .push({value: key, label: recTypes[key]});
                }
			component.set('v.availableRecordTypes', optionsList );
                
            }else if(state==='INCOMPLETE'){
                console.log('User is Offline System does not support drafts '
                           + JSON.stringify(response.getError()));
            }else if(state ==='ERROR'){
                
            }else{
                
            }
		});
        action.setStorable();
        $A.enqueueAction(action);
    },
    validateEntry : function(component, event, helper){
        var recordType = component.find('recordTypes').get('v.value');
        if(recordType == ''){
        	//helper.validateRecordType(component);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error Message',
                message:'Please select a lead record type option and try again',
                messageTemplate: 'Mode is pester, duration is 4sec and Message is overrriden',
                duration:' 4000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
        }
        else {
            /*helper.prePopulateLead(component);
            $A.enqueueAction(action); */
            
            var leadPopulation = component.get("c.populateLead");
            $A.enqueueAction(leadPopulation);
           
        }
    },
    populateLead : function(component) {
        var recordType = component.find('recordTypes').get('v.value');
        var action = component.get("c.getFieldsToPopulate");
		action.setParams({
            objId : component.get('v.recordId'),
            objName :  component.get('v.sObjectName'),
            subBranch : recordType
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                	var leadMapping = response.getReturnValue();
                    
                    var createRecordEvent = $A.get('e.force:createRecord');
                
                    createRecordEvent.setParams({
                        'entityApiName':'Lead',
                        'recordTypeId': recordType,
                        'defaultFieldValues': leadMapping 
                    });
                    createRecordEvent.fire();
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})