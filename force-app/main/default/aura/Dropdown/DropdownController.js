({
    doInit: function(component, event, helper) {},
    
    toggle: function(component, event, helper) {
        helper.toggle(component, event, helper);
    },
    
    open: function(component, event, helper) {
        if(!component.get("v.isOpened") && !component.get("v.disabled")) {
            helper.open(component, event, helper);
        }
    },
    
    close: function(component, event, helper) {
        if(component.get("v.isOpened")) {
            helper.close(component, event, helper);
        }
    },
    
    isOpen: function(component, event, helper) {
        return component.get("v.isOpened");
    },
    
    setDropdownPosition: function(component, event, helper) {
        helper.setDropdownPosition(component, event, helper);
    },
    
    onDisabledChange: function(component, event, helper) {
        if(component.get("v.disabled") && component.get("v.isOpened")) {
            helper.close(component, event, helper);
        }
    }
    
})