({
    // Execute Lead conversion
    executeConversion : function (component, callback) {
        // Set start time for conversion
        component.set('v.conversionTimeStart', (new Date()).getTime());
        
        // Execute conversion
        var leadId = component.get('v.recordId');
        var action = component.get('c.convertLead');
        action.setParams({ 'leadId': leadId });
        action.setCallback(this, callback);
        $A.enqueueAction(action);
    },
    
    // Get converted Lead information
    getConvertedLeadRecord : function (component, leadId) {
        var self = this;
        var callback = function (result) {
            var state = result.getState();
	
            if (state === 'SUCCESS') {
                var lead = result.getReturnValue();
                
                if (lead.IsConverted === false) {
                    var conversionTimeSecs = self.getConversionTime(component);
                    
                    // If current conversion time in less than 60 seconds, execute query again
                    if (conversionTimeSecs <= 60) {
                        setTimeout($A.getCallback(() => self.getConvertedLeadRecord(component, leadId)), 3000);
                    } else {
                		self.handleError(component, 'Lead Conversion has timed out. Please try again. If the problem persists, please contact your administrator');
                    }
                } else {
                    self.handleSuccess(component, lead);
                }
            } else if (state === 'INCOMPLETE') {
                console.log("User is offline, device doesn't support drafts.");
            } else if (state === 'ERROR') {
                self.handleError(component, result.getError()[0].message);
            } else {
                console.log('Unknown problem, state: ' + state + ', error: ' + result.getError()[0].message);
            }
        };
        var action = component.get('c.getConvertedLead');
        
        if (action) {
            action.setParams({ 'leadId': leadId });
            action.setCallback(this, callback);
            
            // Enqueue Action
            $A.enqueueAction(action);
        }
    },
    
    // Handle successful Lead conversion
	handleSuccess : function(component, lead) {
        component.set('v.lead', lead);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            'type': 'success',
            'duration': 2000,
            'mode': 'dismissible',
            'message': 'Lead has been successfully converted.'
        });
        
        // Display message
        toastEvent.fire();
        $A.get("e.force:refreshView").fire();
	},
    
    // Handle unsuccessful Lead conversion
    handleError : function(component, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            'type': 'error',
            'mode': 'sticky',
            'title': 'ERROR UPDATING LEAD STATUS',
            'message': message
        });
        
        // Display message and close dialog
        toastEvent.fire();
        $A.get("e.force:closeQuickAction").fire();
    },
    
    // Get current conversion time in seconds
    getConversionTime: function (component) {
        var conversionTimeStart = component.get('v.conversionTimeStart');
        var currentTime = (new Date()).getTime();
        var conversionTimeSecs = Math.floor((currentTime - conversionTimeStart) / 1000);
        console.log('conversionTime (s): ' + conversionTimeSecs);
        
        return conversionTimeSecs;
    },
    
})