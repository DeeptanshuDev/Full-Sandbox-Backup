({
    doInit: function(component, event, helper) {
        // defaulting old component value
        component.set("v.oldValue", component.get("v.value"));
        helper.setObjectLabel(component, event, helper);
        component.set('v.labelPrefix',BASE.baseUtils.getPackagePrefix(component));
    },

    onChangeNamePoint: function(component, event, helper) {
        helper.setObjectLabel(component, event, helper);
        component.set("v.searchResultMap", {});
        component.set("v.searchResultList", []);
        component.set("v.value", "");
        component.set("v.displayValue", "");
        component.set("v.error", "");
        component.set("v.showResults", false);
        component.set("v.results", []);
    },

    onKeyUp: function(component, event, helper) {
        helper.onKey(component, event, helper, 'keyup');
    },

    onKeyDown: function(component, event, helper) {
        helper.onKey(component, event, helper, 'keydown');
    },

    clickResult: function(component, event, helper) {
        event.preventDefault();
        helper.selectResult(component, event, helper, event.currentTarget.dataset.index);
    },

    clearField: function(component, event, helper) {
        event.preventDefault();
        helper.clearField(component, event, helper);
    },

    onFocus: function(component, event, helper) {
        var searchString = component.get("v.displayValue");
        var showAllResultsLink = component.get("v.showAllResultsLink");
        var isOptional = component.get("v.isOptional");
        helper.openResultBox(component, helper, searchString, !showAllResultsLink && isOptional); 
    },
    
    showAllResults: function(component, event, helper) {
        component.set("v.showAllResultsLink",false);
        var searchString = component.get("v.displayValue");
        helper.openResultBox(component, helper, searchString, true);
    }

})