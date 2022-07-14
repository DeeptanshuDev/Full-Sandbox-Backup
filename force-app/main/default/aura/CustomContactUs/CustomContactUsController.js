/*
$Label.c.Success_Message_ContactUs
*/
({
    doInit : function(component, event, helper) {
        helper.doInit(component, event, helper);
    },
    
    handleError : function(component, event, helper) {
        console.log('error');
    },
    
    handleSubmit : function(component, event, helper) {
        helper.handleSubmit(component, event, helper);
    },
    
    handleSuccess : function(component, event, helper) { 
        component.set('v.successMessage', BASE.baseUtils.getLabel(component,'Success_Message_ContactUs')); 
        helper.addExtraFields(component, event, helper, event.getParams().response.id);
        component.set("v.showSpinner", false);
    }  
})