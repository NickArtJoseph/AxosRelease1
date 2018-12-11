({
    changeOwnerHelper : function(component, recordId) {
        console.log('helper');
        // invoke server-side controller method 
        var action = component.get("c.changeOwner");
        
        // set parameters
        action.setParams({
            "oppQueueId" : recordId
        });
        console.log('helper2');
        
        // handle response 
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if(state == "SUCCESS"){
                console.log('owner change successfull.');
                var oppId = response.getReturnValue();
                if (oppId.includes("Error"))
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Error : Dont have permission to take ownership",
                        "type": "error"
                    });
                    toastEvent.fire();
                    // Close the action panel
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
                }
                
                else{
                console.log(oppId);
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": oppId
                });
                    navEvt.fire();}
            }else{
                console.log('Error');
            }
            
        });
        console.log('helper3');
        $A.enqueueAction(action);
    }
})