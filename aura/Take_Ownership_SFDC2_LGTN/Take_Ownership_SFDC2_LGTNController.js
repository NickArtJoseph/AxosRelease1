({
	doInit : function(component, event, helper) {
		console.log("record Id ",component.get("v.recordId"));
        var oppQueId = component.get("v.recordId");
        helper.changeOwnerHelper(component, oppQueId);
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
	}
})