/* LABEL PRELOAD, DO NOT REMOVE
$Label.c.My_Orders
*/
({
	doInit: function(component, event, helper){
        helper.doInit(component, event, helper);
    },    
    
    doPrevious: function(component, event, helper) {
        component.find("MyOrdersDataService").doPrevious();
        component.find("grid").focusAction();
    },
    
    doNext: function(component, event, helper) {
        component.find("MyOrdersDataService").doNext();
        component.find("grid").focusAction();
    },
    
    onFilterChange: function(component, event, helper) {
        helper.clearAllDataServiceFilters(component, event, helper);
        helper.onFilterChange(component, event, helper);
    },
    
    setTitle: function(component, event, helper) {
        if (component.get("v.initDone") && !component.get("v.recordId")) {
            document.title = BASE.baseUtils.getLabel(component, 'My_Orders');
        }
    },
    
    onGenericComponentEvent: function(component, event, helper) {}    
})