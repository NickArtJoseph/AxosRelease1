({
	cancelResearch: function (component) {
		var self = this;
		var recordId = component.get('v.recordId');

		var callback = function (updateResult) {
			var state = updateResult.getState();

			if (state === 'SUCCESS') {
                self.handleSuccess();
            } else if (state === 'INCOMPLETE') {
            	self.handleError(component, "User is offline, device doesn't support drafts.");
            } else if (state === 'ERROR') {
                self.handleError(component, updateResult.getError()[0].message);
            } else {
                self.handleError(component, updateResult.getError()[0].message);
            }
		};

		var action = component.get('c.cancelResearch');
		action.setParams({ 'accountId': recordId });
		action.setCallback(this, callback);
		$A.enqueueAction(action);
	},

	// Handle successful Lead conversion
	handleSuccess : function () {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            'type': 'success',
            'duration': 2000,
            'mode': 'dismissible',
            'message': 'Account Research has been CANCELLED'
        });
        
        // Display message
        toastEvent.fire();
        $A.get('e.force:refreshView').fire();
        $A.get('e.force:closeQuickAction').fire();
	},
    
    // Handle unsuccessful Lead conversion
    handleError : function (component, message) {
        var toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
            'type': 'error',
            'mode': 'sticky',
            'message': message
        });
        
        // Display message and close dialog
        toastEvent.fire();
        $A.get('e.force:closeQuickAction').fire();
    },
})