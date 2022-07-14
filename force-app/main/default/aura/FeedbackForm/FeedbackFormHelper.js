/* LABEL PRELOAD, DO NOT REMOVE
$Label.c.Error_Message_Feedback
*/
({
    doInit : function(component, event, helper) {
        var fieldSetName = component.get('v.fieldSetName');
        var sobjectName = component.get('v.objectName');
        
        var extraOptions = {
            toastError: true,
        };
        var parameters = {
            'sObjectName': sobjectName, 
            'fieldSetname': fieldSetName
        };
        
        BASE.baseUtils.executeAction(component, helper, "c.getForm", parameters, helper.doInitSuccess, extraOptions);
    },
    
    doInitSuccess : function(component, helper, result) {
        if(result) {
            component.set('v.fields', result.Fields);
        } 
        var delayInMilliseconds = 1500;
        window.setTimeout(
            $A.getCallback(function() {
                component.set("v.initDone", true);
                component.set("v.showSpinner", false);
            }), delayInMilliseconds
        ); 
        
    },
    
    closeModal : function(component,event, helper) {
        var eve = component.getEvent("genericComponentEvent");
        eve.fire();
    },
    
    handleSubmit : function(component, event, helper) {
        
        event.preventDefault(); // stop form submission
        var eventFields = event.getParam("fields");
        if(eventFields["Description__c"]) {
            component.set("v.showSpinner", true);   
            let feedBackForm = component.find('feedbackForm');
            if(feedBackForm) {
                component.set('v.errorMessage', null);
                let fbf = [].concat(feedBackForm);
                fbf[0].submit(eventFields); 
            }
        } else {
            component.set('v.errorMessage', BASE.baseUtils.getLabel(component,'Error_Message_Feedback'));
            // BASE.baseUtils.showToast("Please write comment.", "");
        }
    },
    
    addExtraFields : function(component, event, helper, recId){
        var extraOptions = {
            toastError: true,
        };
        var parameters = {
            'feedbackRecordId': recId
        };
        BASE.baseUtils.executeAction(component, helper, "c.saveFeedback", parameters, helper.updateSuccess, extraOptions);
    },
    
    updateSuccess : function(component, event, helper, result) {
        component.set("v.initDone", true);
        component.set("v.showSpinner", false);
    }
})