({
	// Create Return research Task
	getNewTask : function(component) {
		var self = this;

		var accountId = component.get('v.recordId');
		var action = component.get('c.getReturnResearchTask');
		action.setParams({ 'accountId': accountId });
		action.setCallback(this, (result) => {
			var state = result.getState();
			console.log(result.getReturnValue());
			if (state === 'SUCCESS') {
				component.set('v.newTask', result.getReturnValue());
			} else if (state === 'ERROR') {
				self.handleError(component, result.getError()[0].message);
			}
		});

		$A.enqueueAction(action);
	},

	// Save return research Task
	saveNewTask: function (component) {
		var self = this;

		var accountId = component.get('v.recordId');
		var newTask = component.get('v.newTask');

		var action = component.get('c.returnResearch');
		action.setParams({
			'newTask': newTask,
			'accountId': accountId
		});
		action.setCallback(this, (result) => {
			var state = result.getState();
			console.log('INSERTED TASK ID: ' + result.getReturnValue());
			if (state === 'SUCCESS') {
				self.handleSuccess();
			} else if (state === 'ERROR') {
				self.handleError(component, result.getError()[0].message);
			}
		});

		$A.enqueueAction(action);
	},

	// Validate form fields
	validateFields: function (component) {
		// Validate Task
		var inputTaskDescription = component.find('inputTaskDescription');
		var inputTaskDescriptionValue = inputTaskDescription.get('v.value');

		if ( !inputTaskDescriptionValue || $A.util.isEmpty(inputTaskDescriptionValue.trim()) ) {
			inputTaskDescription.set('v.errors', [{message:'This field is required.'}]);
			return false;
		}

		return true;
	},

	// Handle successful Research Return
	handleSuccess : function () {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            'type': 'success',
            'duration': 2000,
            'mode': 'dismissible',
            'message': 'Account Research has been RETURNED'
        });

        // Display message
        toastEvent.fire();
        $A.get('e.force:refreshView').fire();
        $A.get('e.force:closeQuickAction').fire();
	},

    // Handle unsuccessful Research Return
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