/* LABEL PRELOAD, DO NOT REMOVE
$Label.c.Important_News
*/
({
	doInit : function(component, event, helper) {
		helper.doInit(component, event, helper);
	},
    
    doPrevious: function(component, event, helper) {
        component.find("MyNewsDataService").doPrevious();
        component.find("grid").focusAction();
    },
    
    doNext: function(component, event, helper) {
        component.find("MyNewsDataService").doNext();
        component.find("grid").focusAction();
    },
    
    setTitle: function(component, event, helper) {
        if (component.get("v.initDone") && !component.get("v.recordId")) {
            document.title = BASE.baseUtils.getLabel(component, 'Important_News');
        }
    },
    
    onGenericComponentEvent: function(component, event, helper) {}
})