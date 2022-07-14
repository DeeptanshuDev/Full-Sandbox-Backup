({
    doInit: function(component, event, helper) {
        /* remove this when we are sure this doesn't breaks anything */
        //  show spinner should not be forced as true, its value should be computed by the callee component
        //  component.set('v.showSpinner', true);
        /* ends */

        var cmpStack = component.get('v.componentStack');
        //Checks for a design attribute to change the style of component in standalone mode to mimic embedded mode when inside a tab
        var recordDetailStyle = component.get("v.recordDetailStyle");
        if (recordDetailStyle == true) {
            component.set("v.isEmbedded", recordDetailStyle);
        };

        cmpStack.push(component);
        component.set('v.componentStack',cmpStack);

        component.set('v.embeddedHelper', helper);

       setTimeout($A.getCallback(function() {
            if(component.get("v.fieldsetName")  && !( component.get("v.fieldList") && component.get("v.fieldList").length > 0)) {
                helper.getFieldset(component,helper);
            }
        }), 100);

        helper.enableButtons(component, helper, helper.checkAndSaveForm, !!component.get('v.buttonsVisible'), helper.changeToRead);

        if(!component.get("v.sectionHeader") && !component.get("v.sectionOpen")) {
            component.set("v.sectionOpen",true);
        }
    },

    refresh: function(component, event, helper) {
        var isStandalone = !component.get('v.isEmbedded');
        if(isStandalone === true) {
            helper.getFieldset(component,helper);
        }
    },
    save: function(component, event, helper) {
        helper.checkAndSaveForm(component, event, helper);
    },

    cancel: function(component, event, helper) {
        helper.cancel(component, event, helper);
    },

    recalculateFormula: function(component, event, helper) {
        helper.recalculateFormula(component, helper);
    },

    onGenericComponentEvent: function(component, event, helper) {
        var cmpEvent = BASE.componentEventUtils.getGenericComponentEvent(event);
        var fieldList = component.get("v.fieldList");

        if (cmpEvent.isSource("DropFile")) {
            // Set the value of the attachment field to the id of the attachment
            var attachmentFieldName = cmpEvent.getData().attachmentFieldName;

            for(var fieldIndex in fieldList){
                var fieldName = fieldList[fieldIndex].name;

                if (fieldName == attachmentFieldName) {
                    // If the file has been deleted, set the value to null
                    // If a file has been uploaded, set the value to the id of the attachment.
                    var attachmentFieldValue = null;
                    if (cmpEvent.getState() == BASE.componentEventUtils.GENERIC_EVENT_FILE_UPLOAD_SUCCESS) {
                        attachmentFieldValue = cmpEvent.getData().parentId;
                    }

                    // Determine whether the DropFile component needs to be shown
                    var showDropFile = (!fieldList[fieldIndex].options || fieldList[fieldIndex].options.length == 0);
                    if (!showDropFile && ((attachmentFieldValue != null && attachmentFieldValue != '') || (attachmentFieldValue == null || attachmentFieldValue == ''))) {
                        showDropFile = true;
                    }

                    fieldList[fieldIndex].value = attachmentFieldValue;
                    fieldList[fieldIndex].error = null;
                    fieldList[fieldIndex].showDropFile = showDropFile;
                    break;
                }
            }
            //Some magic is happening and the uploaded attachment is somewhere saved in the fieldList...but we can't find where :(
            //when commenting in line below, the value of the FILEUPLOAD field is cleared
            //component.set("v.fieldList", fieldList);
        }

        // Change in the value for the picklist option
        // Determine whether the DropFile component needs to be shown
        if (cmpEvent.isSource("Field") && cmpEvent.getState() == BASE.componentEventUtils.GENERIC_EVENT_FILE_UPLOAD_SUCCESS) {
            var fieldName = cmpEvent.getData().name;
            var fieldValue = cmpEvent.getData().value;

            for (var fieldIndex in fieldList) {
                var currentFieldName = fieldList[fieldIndex].name;
                if (fieldName == currentFieldName) {
                    fieldList[fieldIndex].showDropFile = (fieldValue == null || fieldValue == '');
                    break;
                }
            }
            component.set("v.fieldList", fieldList);
        }

        //Catch the field change event and check if there are formula fields, recalculate them and update them
        //also recalculate dependent picklist options if controlling field value was changed
        if(cmpEvent.isSource("Field") && cmpEvent.getState() == BASE.componentEventUtils.GENERIC_EVENT_FIELD_CHANGE){
            helper.recalculateFormulas(component, event, helper);
            let field = cmpEvent.getData();
            if (field && field.isController) {
                let warnings = [];
                let errors = [];
                helper.changeDependentPicklistOptions(component, helper, field, warnings, errors);
                if (!$A.util.isEmpty(warnings)) {
                    event.getSource().showScopedNotification(helper.getDependentPicklistWarningNotificationParams(warnings));
                }
            }
        }
    },

    showFieldsError: function(component, event, helper) {
        var params = event.getParam('arguments');
        if (params) {
           var fieldList = params.fieldList;
           if(fieldList){
              helper.onSaveError(component, helper,fieldList);
           }
        }

    },

    /* Will reload the picklist option override when changes haven been made, like selecting another candidate with different picklist options */
    changePicklistOptionOverrides : function(component, event, helper){
        helper.changePicklistOptionOverrides(component, event, helper);
    },

    recalculateFormulaFields : function(component, event, helper){
        helper.recalculateFormulas(component, event, helper);
    },
    
    callFieldComponentMethod: function(component, event, helper) {
        var params = event.getParam('arguments');
        if(params) {
            let data = params.data;
            if(data) {
                let isReturnData = data.isReturnData;
                var returnedData = helper.callFieldComponentMethod(component, event, helper, data);
                if(isReturnData) {
                    return returnedData;
                }
            }
        }
    }
})