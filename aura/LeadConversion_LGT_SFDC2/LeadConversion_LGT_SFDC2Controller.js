({
    // Initialize component (execute lead conversion automatically)
	cInit : function(component, event, helper) {
        // Conversion callback
        var callback = function (conversionResult) {
            var state = conversionResult.getState();
	
            if (state === 'SUCCESS') {
                var leadId = conversionResult.getReturnValue();
                helper.getConvertedLeadRecord(component, leadId);
            } else if (state === 'INCOMPLETE') {
                console.log("User is offline, device doesn't support drafts.");
            } else if (state === 'ERROR') {
                helper.handleError(component, conversionResult.getError()[0].message);
            } else {
                console.log('Unknown problem, state: ' + state + ', error: ' + conversionResult.getError()[0].message);
            }
        };
        
        helper.executeConversion(component, callback);
	},
    
    
})