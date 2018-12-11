({
	validateBoardingForm: function(component) {
		var validBoardingForm = true;

		var allValid = component.find("formField").reduce(function (validFields, inputCmp) {
			return validFields.valid && inputCmp.get("v.validity").valid;
		}, true);
	}
})