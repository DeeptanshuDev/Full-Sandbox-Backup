({
    doInit : function(component, event, helper) {
        helper.doInit(component, event, helper);
    },
    
    handleError : function(component, event, helper) {
        helper.showToast(component,event, helper);
    },
    
    handleCancel : function(component, event, helper) {
        //closes the modal or popover from the component  
        helper.closeModal(component,event, helper);
    },
    
    handleSubmit : function(component, event, helper) {
        helper.handleSubmit(component, event, helper);
    },
    
    handleSuccess : function(component, event, helper) { 
        helper.addExtraFields(component, event, helper, event.getParams().response.id);
        component.set("v.showSpinner", false);
        helper.closeModal(component,event, helper);
    }  
})