({
	doInit : function(component, event, helper) {
		helper.doInit(component, event, helper);
        helper.prepareFilters(component, event, helper);
    },
    
    doDataClone: function(component, event, helper){
        helper.doDataClone(component, event, helper);
    },
    
    /* pagination for custom item */
    doPreviousCustomItem: function(component, event, helper) {
        component.find("customItemDataService").doPrevious();
        component.find("customItemTable").focusAction();
    },
    
    doNextCustomItem: function(component, event, helper) {
        component.find("customItemDataService").doNext();
        component.find("customItemTable").focusAction();
    }
    
})