({
	doInit : function(component, event, helper) {
		helper.getNewTask(component);
	},

	saveNewTask : function (component, event, helper) {
		if (helper.validateFields(component)) {
			helper.saveNewTask(component);
		}
	},

	clearErrors: function(component, event, helper) {
		var inputNotes = component.find('inputTaskDescription');
		inputNotes.set('v.errors', []);
	},

	cancelAction: function(component, event, helper) {
		$A.get('e.force:closeQuickAction').fire();
	},
})