({
    doInit: function (component, event, helper) {
        var cmpStack = component.get('v.componentStack');
        if(cmpStack) {
        	cmpStack.push(component);
        	component.set('v.componentStack',cmpStack);
        }
        if(component.get("v.sectionHeader")) {
            BASE.baseUtils.resolveDynamicLabel(component, 'v.sectionHeader');
        }
    },

    toggleSection: function(component, event, helper) {
        component.set("v.sectionOpen", !component.get("v.sectionOpen"));
    },

    handleSectionHeaderChange: function(component, event, helper) {
        if(component.get("v.sectionHeader")) {
            BASE.baseUtils.handleDynamicLabelChange(component, "v.sectionHeader", "v.sectionHeaderLoading");
        }
    }
})