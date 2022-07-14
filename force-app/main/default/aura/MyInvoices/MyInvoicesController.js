/* LABEL PRELOAD, DO NOT REMOVE
$Label.c.My_Invoices
*/
({
	doInit: function(component, event, helper){
        helper.doInit(component, event, helper);
    },    
    
    doPrevious: function(component, event, helper) {
        component.find("MyinvoicesDataService").doPrevious();
        component.find("grid").focusAction();
    },
    
    doNext: function(component, event, helper) {
        component.find("MyinvoicesDataService").doNext();
        component.find("grid").focusAction();
    },
    
    setTitle: function(component, event, helper) {
        if (component.get("v.initDone") && !component.get("v.recordId")) {
            document.title = BASE.baseUtils.getLabel(component, 'My_Invoices');
        }
    },
    
    onGenericComponentEvent: function(component, event, helper) {}    
})