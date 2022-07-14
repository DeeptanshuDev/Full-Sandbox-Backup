/*
$Label.c.Error_Message_ContactUs
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
    
    doInitSuccess : function(component, helper, result, event) {
        if(result) {
            component.set('v.fields', result.Fields);
            console.log('@@@ : ' + JSON.stringify(result.Fields));
        }
        component.set("v.initDone", true);
        var delayInMilliseconds = 2000;
        window.setTimeout(
            $A.getCallback(function() {
                component.set("v.showSpinner", false);
            }), delayInMilliseconds
        );    
    },
   
    handleSubmit : function(component, event, helper) {
        event.preventDefault(); // stop form submission
        var contactRecord = event.getParams().fields;     
        var fields = JSON.stringify(contactRecord);
        if(contactRecord["Description__c"]) {
            component.set("v.showSpinner", true);
            let contactForm = component.find('contactUsForm');
            if(contactForm) {
                component.set('v.errorMessage', null);
                let con = [].concat(contactForm);
                con[0].submit(contactRecord); 
            }
        } else {
            component.set('v.errorMessage', BASE.baseUtils.getLabel(component,'Error_Message_ContactUs'));
            // BASE.baseUtils.showToast("Please write comment.", "");
        }
    },
    
    addExtraFields : function(component, event, helper, recId){
        $A.get('e.force:refreshView').fire();
        var extraOptions = {
            toastError: true,
        };
        var parameters = {
            'contactUsId': recId
        };
        BASE.baseUtils.executeAction(component, helper, "c.saveContact", parameters, helper.updateSuccess, extraOptions);
    },
    
    updateSuccess : function(component, event, helper, result) {
        component.set("v.initDone", true);
        component.set("v.showSpinner", false);
        
    }
})