({
    doInit : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        
        var action = component.get('c.getOpportunity');
        action.setParams({
            'recordId': recordId
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            
            if (state === 'SUCCESS') {
                var opp = result.getReturnValue();
                component.set('v.simpleRecord', opp);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    handleSaveRecord: function(component, event, helper) {
		var opp = component.get('v.simpleRecord');
        var action = component.get('c.saveOpportunity');
        action.setParams({
            'opp': opp
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