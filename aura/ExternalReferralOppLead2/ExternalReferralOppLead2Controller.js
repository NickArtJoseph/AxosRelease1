({
    openModel: function(component, event, helper) {
        component.set("v.isOpen", true);
    },
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
    },
    createRecord : function (component, event, helper) {
        var sObject = component.get("v.simpleRecord");
        console.log(sObject);
        console.log(sObject.Broker_Name_SFDC2__c);
        var navEvt = $A.get("e.force:navigateToSObject");
        var contactId = component.get("v.recordId");
        
        navEvt.setParams({
            "recordId": sObject.Broker_Name_SFDC2__c,
        });
        navEvt.fire();
    }
})