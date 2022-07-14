({
    doInit: function(component, event, helper) {
        var cmpStack = component.get('v.componentStack');
        cmpStack.push(component);
        component.set('v.componentStack',cmpStack);
    },
    
    saveButtonClick: function(component, event, helper) {
        var callerComponent = component.get("v.callerComponent");
        callerComponent.saveAction();
    },
    
    cancelButtonClick: function(component, event, helper) {
        var callerComponent = component.get("v.callerComponent");
        callerComponent.cancelAction();
        BASE.componentEventUtils.fireGenericComponentEvent(component, BASE.componentEventUtils.GENERIC_EVENT_CANCELLED, null);
    },
    
    // returns the list of modified field's data within field-set
    getSaveDataAction: function(component, event, helper) {
        return helper.getSaveDataAction(component, event, helper);
    },
    
    // override the properties in fieldset's input based on provided ones
    setOverrideDataAction: function(component, event, helper) {
        var args = event.getParams().arguments;
        helper.setOverrideDataAction(component, helper, args.data);
    },
    
    // show undo link with previous value
    setPreviousDataAction: function(component, event, helper) {
        var args = event.getParams().arguments;
        helper.setPreviousDataAction(component, helper, args.data);
    },
    
    // set the current value with passed value and show undo link with database value
    setDatabaseValueAction: function(component, event, helper) {
        var args = event.getParams().arguments;
        helper.setDatabaseValueAction(component, helper, args.data);
    },
    
    // set the current value with passed value and show undo link with database value
    setDatabaseValueWithPreviousAction: function(component, event, helper) {
        var args = event.getParams().arguments;
        helper.setDatabaseValueWithPreviousAction(component, helper, args.data);
    },
    
    // returns the list of all field's data within field-set
    getAllDataAction: function(component, event, helper) {
        var args = event.getParams().arguments;
        return helper.getAllDataAction(component, helper, args.includeEmptyFields);
    },
    
    // clears the form fields. does not return any values
    clearAllDataAction: function(component, event, helper) {
        return helper.clearFieldValues(component, event, helper);
    },
    
    setServerErrors: function(component, event, helper) {
        var errorList = component.get("v.serverFieldErrors");
        if (errorList && errorList.length > 0) {
            helper.onSaveError(component, helper, errorList);
        }
    },
    
    initFieldList: function(component, event, helper) {
        //var	fieldList = component.get("v.fieldList");
        var fieldList = event.getParams().arguments.newFieldList;
        if (!fieldList) {
            fieldList = component.get('v.fieldList');
        }
        var fieldOverrides = component.get("v.fieldOverrides");
        helper.createFieldArray(component, helper, fieldList, fieldOverrides);
        helper.setFormula(component, helper);
        helper.recalculateFormula(component, helper);
    },
    
    checkFieldErrors: function(component, event, helper) {
        return helper.checkFieldErrors(component, helper);
    },
    
    onGenericComponentEvent: function(component, event, helper) {
        var cmpEvent = BASE.componentEventUtils.getGenericComponentEvent(event);
        
        if(cmpEvent.isSource("InputLocation") && cmpEvent.getState() == BASE.componentEventUtils.GENERIC_EVENT_CHANGED) {
            var data = cmpEvent.getData();
            if(data) {
                
                if(component.get("v.isEmbedded") == true) {
                    BASE.componentEventUtils.fireGenericComponentEvent(component, BASE.componentEventUtils.GENERIC_EVENT_CHANGED, data);
                } else {
                    event.stopPropagation();
                    helper.setOverrideDataAction(component, helper, data);
                }
                helper.setHiddenFieldData(component, data);
            }
        }
        
    }
})