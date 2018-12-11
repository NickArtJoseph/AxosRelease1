({
	getInitDataHelper : function(component) {
		var accId = component.get("v.recordId");
        
        var action = component.get("c.getInitData");
        action.setParams({
            "accountId" : accId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var initData = response.getReturnValue();
                
                component.set("v.checkUser", initData.checkUser);
                component.set("v.checkAccess", initData.checkAccess);
                component.set("v.ReferToList", initData.referToList);
            }
        });
        
        $A.enqueueAction(action);
	},
    
    createRecordHelper : function(component){
        
        var self = this;
        var accId = component.get("v.recordId");
        var refTo = component.get("v.selectedItem");
        var Notes = component.get("v.Notes");
        var action = component.get("c.create");
        action.setParams({
            "accountId" : accId,
            "refTo" : refTo,
            "Notes" : Notes
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if(state === "SUCCESS"){
               this.showToast(component, 'Success', 'success', 'Opportunity has been referred.');
            }else{
                this.showToast(component, 'Error', 'error', 'Failed to refer Opportunity.')
            }
            self.cancelActionHelper(component);
        });
        $A.enqueueAction(action);
        
    },
    
    showToast : function(component, title, type, msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type" : type,
            "message": msg
        });
        toastEvent.fire();
    },

    cancelActionHelper : function(component, event, helper) {
        var closeModal = $A.get("e.force:closeQuickAction");
        closeModal.fire();
    }
})