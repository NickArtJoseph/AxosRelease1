({
    doInit: function(component, event, helper) {
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": "Success!",
            "message": component.get('v.successMessage'),
            "type": "success"
        });
        
        resultsToast.fire();
    }
})