({
    doInit : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        
        var action = component.get('c.getCase');
        action.setParams({
            'recordId': recordId
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            
            if (state === 'SUCCESS') {
                var ca = result.getReturnValue();
                component.set('v.simpleRecord', ca);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    handleSaveRecord: function(component, event, helper) {
		var ca = component.get('v.simpleRecord');
        var action = component.get('c.saveCase');
        action.setParams({
            'Ca': ca
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            
            if (state === 'SUCCESS') {
                $A.get("e.force:refreshView").fire();
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        
        $A.enqueueAction(action);
    }
})