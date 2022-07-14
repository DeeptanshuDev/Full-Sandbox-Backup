({
    doInit: function (component, event, helper) {
        helper.isOverrideField(component,event,helper);
        var prefix = BASE.baseUtils.getObjectPrefix(component);
    },

    changeStateToEdit :function(component, event, helper) {
        component.set("v.state","Edit");
    },

    change :function(component, event, helper) {
        var field =component.get('v.fieldData');
        var fieldValue =component.get('v.fieldData.value');

        if (field.isInFormula && (fieldValue != field.oldValue)) {
            field.value = fieldValue;
            component.set('v.fieldData',field);
            var compEvent = component.getEvent("formulaFieldChange");
            compEvent.fire();
        }
        else{
            //call the keyup on changing a date or date time. there is no keyup event.
            if((field.type == "DATE" || field.type == "DATETIME")){
                if(field.value != field.oldValue){
                    helper.keyup(component, event, helper);
                }
            }

            //Fire a field change event other then formula
            if(field.fireFieldChangeEvent){
                BASE.componentEventUtils.fireGenericComponentEvent(component, BASE.componentEventUtils.GENERIC_EVENT_FIELD_CHANGE, field);
            }
        }
        if (field.type == 'FILEUPLOAD') {
            BASE.componentEventUtils.fireGenericComponentEvent(component, BASE.componentEventUtils.GENERIC_EVENT_FILE_UPLOAD_SUCCESS, field);
        }
    },

    keyup :function(component, event, helper) {
        helper.keyup(component, event, helper);
    },

    getData : function(component){
        return component.get("v.fieldData");
    },

    changeUpdate :function(component, event, helper) {
        var field =component.get('v.fieldData');
        field.value = field.updated;
        //undo for requirements
        if(field.type == 'REQUIREMENTS') {
            component.find('requirementsCmp').clearPreviousAddedReqData();
        }
        else {
            field.updated = '';
            component.set('v.fieldData',field);
        }
        if(field.fireFieldChangeEvent){
            BASE.componentEventUtils.fireGenericComponentEvent(component, BASE.componentEventUtils.GENERIC_EVENT_FIELD_CHANGE, field);
        }
    },

    isChanged :function(component, event, helper) {
        var result = false;
        var field =component.get('v.fieldData');
        if (field.type == 'REQUIREMENTS') {
            var delegateCmp = component.find('requirementsCmp');
            if (delegateCmp) {
                result = delegateCmp.isChangedAction();
            }
        } else if (field.type == 'REQUIREMENT_ASSESSMENT') {
            var delegateCmp = component.find('requirement_assessment');
            if (delegateCmp) {
                result = delegateCmp.isChangedAction();
            }
        } else {
            result = (field.oldValue != field.value);
        }
        return result;
    },

    getValue :function(component, event, helper) {
        var field =component.get('v.fieldData');
        var result = field.value;
        var label = field.label;
        var required = field.required;
        var type = field.type;
        if (field.type == 'DATE' && result == '') {
            result = null;
        } else if (field.type == 'REQUIREMENTS') {
            var delegateCmp = component.find('requirementsCmp');
            if (delegateCmp) {
                result = delegateCmp.getValueAction();
            }
        } else if (field.type == 'REQUIREMENT_ASSESSMENT') {
            var delegateCmp = component.find('requirement_assessment');
            if (delegateCmp) {
                result = delegateCmp.getAllData();
            }
        }
        return { "name" : field.name, "value" : result, "label" : label, "required" : required, "type" : type};
    },
    
    callComponentMethod: function(component, event, helper) {
        var params = event.getParam('arguments');
        if(params) {
            let data = params.data;
            if(data) {
                let isReturnData = data.isReturnData
                let returnedData = helper.callComponentMethod(component, event, helper, data);
                if(isReturnData) {
                    return returnedData;
                }
            }
        }
    },
    navigateToReference: function(component, event, helper) {
        var fieldData = component.get("v.fieldData");
        if(fieldData && fieldData.value) {
            BASE.baseUtils.navigateToSObject(fieldData.value);
        }
    },

    showScopedNotification: function (component, event, helper) {
        let params = event.getParam('arguments').params;
        component.set('v.scopedNotification', params);
        setTimeout($A.getCallback(() => {
            component.set('v.scopedNotification', {});
        }), params.timeout || 6000);
    },

    stateChange : function (component, event, helper) {
        if (component.get('v.state') === 'Read' && !$A.util.isEmpty(component.get('v.scopedNotification')) ) {
            component.set('v.scopedNotification', {});
        }
    },

    optionsChange : function (component, event, helper) {
        //stub for handling changes of dependent picklists' options
        //this workaround is needed for immediate reflection of actual options and values on UI
    }
})