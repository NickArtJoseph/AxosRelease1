({
	doInit: function (component, event, helper) {
	
		var recId = component.get("v.recordId");
		var endURL = '';    
		console.log('recId',recId);
		var action = component.get("c.generateDocument");
		action.setParams({
			"boardingFormId" : recId
		});
		action.setCallback(this, function(response){
			var state = response.getState();
			if(state === "SUCCESS"){
				endURL = response.getReturnValue();
                if(endURL.includes('Warning'))
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({"title": "Warning!", "message": "BF Status should be approved"});
                    toastEvent.fire();
                    // Close the action panel
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
                }else
                {
                console.log('endURL',endURL);
                var urlEvent = $A.get("e.force:navigateToURL");
				urlEvent.setParams({
				  "url": endURL
				});
				urlEvent.fire();
                    
                }
			}
		});
		 
		$A.enqueueAction(action);
	}
})