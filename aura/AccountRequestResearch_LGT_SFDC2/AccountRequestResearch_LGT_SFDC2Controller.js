({
	doInit : function(component, event, helper) {
		helper.getAccountRecord(component);
	},

	doRequestResearch: function(component, event, helper) {
		if (helper.validateForm(component)) {
			helper.requestResearch(component);
		}
	},

	closeAction: function(component, event, helper) {
		$A.get('e.force:closeQuickAction').fire();
	},

	clearErrors: function(component, event, helper) {
		helper.clearFormErrors(component);
	},

	showSpinner: function(component, event, helper) {
		component.set('v.isWaiting', true);
	},

	hideSpinner: function(component, event, helper) {
		component.set('v.isWaiting', false);
	},
})