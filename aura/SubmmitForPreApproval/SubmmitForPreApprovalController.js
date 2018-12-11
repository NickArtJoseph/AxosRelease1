({
    /**
     * Control the component behavior here when record is changed (via any component)
     */
    handleRecordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "CHANGED") {
            // get the fields that changed for this record
            var changedFields = eventParams.changedFields;
            //console.log('Fields that are changed: ' + JSON.stringify(changedFields));
            // record is changed, so refresh the component (or other component logic)
            var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                "type" : "success",
                "title": "Submit for Pre-Approval",
                "message": "Your record has successfully been submitted"
            });
            resultsToast.fire();
            $A.get("e.force:closeQuickAction").fire();

        } else if(eventParams.changeType === "LOADED") { 
            
            var ChangeRec = component.get("v.simpleRecord");
            console.log('ChangeRec.BF_Status__c'+ChangeRec.BF_Status__c);
                    console.log('ChangeRec.BorrowerReadyForSubmmit_SFDC2_del__c'+ChangeRec.BorrowerReadyForSubmmit_SFDC2_del__c);
                    console.log('ChangeRec.GuarantorReadyForSubmmit_SFDC2_del__c'+ChangeRec.GuarantorReadyForSubmmit_SFDC2_del__c);
                    console.log('ChangeRec.Loan_Account_Information_Ready__c'+ChangeRec.Loan_Account_Information_Ready__c);
                    console.log('ChangeRec.Payment_Ready__c'+ChangeRec.Payment_Ready__c);
                    console.log('ChangeRec.Rate_Ready__c'+ChangeRec.Rate_Ready__c);
            
            if(ChangeRec.BF_Status__c === "BF In Progress"){
                
                if(ChangeRec.BorrowerReadyForSubmmit_SFDC2_del__c === true  && ChangeRec.GuarantorReadyForSubmmit_SFDC2_del__c === true && 
                   ChangeRec.Loan_Account_Information_Ready__c === true     && ChangeRec.Payment_Ready__c === true  && ChangeRec.Rate_Ready__c === true){
                    ChangeRec.BF_Status__c = "BF Submitted for Pre-Approval";
                    component.find("recordHandler").saveRecord($A.getCallback(function(saveResult) {
                        
                        if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                            // handle component related logic in event handler
                        } else if (saveResult.state === "INCOMPLETE") {
                            console.log("User is offline, device doesn't support drafts.");
                        } else if (saveResult.state === "ERROR") {
                            console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
                        } else {
                            console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                        }
                    }));
                }else{
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "type" : "warning",
                        "title": "Warning",
                        "message": "Plese complete all the required field to Submitted for Pre-Approval"
                    });
                    resultsToast.fire();
                    $A.get("e.force:closeQuickAction").fire();
                    
                } 
                

            }else if (ChangeRec.BF_Status__c === "BF Submitted for Pre-Approval"){
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "type" : "warning",
                    "title": "Warning",
                    "message": "This record as already been submitted for pre-approval"
                });
                resultsToast.fire();
                $A.get("e.force:closeQuickAction").fire();
            }else if (ChangeRec.BF_Status__c === "BF Submitted for Approval"){
                
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "type" : "warning",
                    "title": "Warning",
                    "message": "This record as already been Submitted for Approval"
                });
                resultsToast.fire();
                $A.get("e.force:closeQuickAction").fire();
            }else if(ChangeRec.BF_Status__c === "BF Approved"){
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "type" : "warning",
                    "title": "Warning",
                    "message": "This record as already been Approved"
                });
                resultsToast.fire();
                $A.get("e.force:closeQuickAction").fire();
            }
            

           console.log(ChangeRec.BF_Status__c);
           
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted and removed from the cache
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving or deleting the record
        }
    }
})