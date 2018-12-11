({
	getAccountRecord: function(component) {
		var self = this; 
		var recordId = component.get('v.recordId');

		var callback = function (result) {
			var state = result.getState();

			if (state === 'SUCCESS') {
                component.set('v.accountRecord', result.getReturnValue());
                console.log(component.get('v.accountRecord'));
            } else if (state === 'INCOMPLETE') {
            	self.handleError(component, "User is offline, device doesn't support drafts.");
            } else if (state === 'ERROR') {
                self.handleError(component, result.getError()[0].message);
            } else {
                self.handleError(component, result.getError()[0].message);
            }
		};

		var action = component.get('c.getAccount');
		action.setParams({ 'accountId': recordId });
		action.setCallback(this, callback);
		$A.enqueueAction(action);
	},

	requestResearch: function (component) {
		var self = this;
		var accountRecord = component.get('v.accountRecord');

		var callback = function (result) {
			var state = result.getState();

			if (state === 'SUCCESS') {
                self.handleSuccess();
            } else if (state === 'INCOMPLETE') {
            	self.handleError(component, "User is offline, device doesn't support drafts.");
            } else if (state === 'ERROR') {
                self.handleError(component, result.getError()[0].message);
            } else {
                self.handleError(component, result.getError()[0].message);
            }
		};

		var action = component.get('c.requestResearch');
		action.setParams({ 'accountRecord': accountRecord });
		action.setCallback(this, callback);
		$A.enqueueAction(action);
	},

	validateForm: function (component) {
		var inputNotes = component.find('inputNotes');
		var notesValue = inputNotes.get('v.value');

		if (!notesValue || notesValue.trim().length == 0) {
			inputNotes.set("v.errors", [{message:"This field is required."}]);
			return false;
		}

		return true;
	},

	clearFormErrors: function (component) {
		var inputNotes = component.find('inputNotes');
		inputNotes.set("v.errors", []);
	},

	// Handle successful Lead conversion
	handleSuccess : function () {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            'type': 'success',
            'duration': 2000,
            'mode': 'dismissible',
            'message': 'Account Research has been REQUESTED'
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