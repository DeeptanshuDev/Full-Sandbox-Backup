({
    doInit : function(component, event, helper) {
        helper.doInit(component, event);
    },
    handleUploadFinished : function(component, event, helper) {
        helper.handleUploadFinished(component, event);
    },
    handleSave : function(component, event, helper) {
        helper.handleSave(component, event);
    },
    handleDelete : function(component, event, helper){
        helper.handleDelete(component, event);
    },
    optionNumberChange : function(component, event, helper){
        helper.changeDetailsOfDesign(component, event);
    },
    needsPricingChange : function(component, event, helper){
        helper.changeDetailsOfDesign(component, event);
    },
    notesChange : function(component, event, helper){
        helper.changeDetailsOfDesign(component, event);
    }
})