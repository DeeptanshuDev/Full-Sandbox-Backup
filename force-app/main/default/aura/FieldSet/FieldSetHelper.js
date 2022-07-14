({
    getFieldset : function(component, helper) {
        var picklistOptionOverrides = component.get("v.picklistOptionOverrides");

        var params = {
            sObjectName : component.get("v.sObjectName"),
            sObjectId : component.get("v.recordId"),
            fieldsetName : helper.getFieldsetName(component,'v.fieldsetName'),
            recordTypeId : component.get('v.recordTypeId'),
            fieldsToBlock : component.get("v.fieldsToBlock"),
            picklistOptionOverrides : JSON.stringify(component.get("v.picklistOptionOverrides")),
        };
        var extraOptions = {
            toastError: component.get("v.showToast"),
            afterFunction: helper.hideSpinner,
            forceUpload: component.get("v.forceUpload")
        }
        BASE.baseUtils.executeAction(component, helper, "c.getFieldset", params, helper.getFieldsetSuccess, extraOptions);
    },
    getFieldsetName:function(component,attribute) {
        var value = component.get(attribute);
        if (value && (value != '') && (value.indexOf('.') !== -1)) {
            value = value.split('.')[1];
        }
        return value;
    },
    getFieldsetSuccess : function(component, helper, responseValues) {
        var readOnly = responseValues.readOnly;
        var error = responseValues.error;
        var fieldList = responseValues.fields;
        component.set("v.messages",[]);

        if(error && error != '') {
            if(component.get("v.showToast")) {
                BASE.baseUtils.showToast(error,"error");
            }
            var invalidFieldSet = '';
            invalidFieldSet = "Invalid FieldSet Name";

            if(error == invalidFieldSet) {
                component.set("v.messages",invalidFieldSet);
            }
        }
        else {
            var fieldOverrides = component.get("v.fieldOverrides");
            helper.createFieldArray(component, helper, fieldList, fieldOverrides);
            helper.setFormula(component, helper);
            helper.recalculateFormula(component, helper);

            if(component.get("v.readOnly")==true) {
                component.set("v.editmodeAllowed",false);
                component.set("v.state",'Read');
            }
            else {
                if(readOnly) {
                    component.set("v.editmodeAllowed",!readOnly);
                    component.set("v.state",'Read');
                }
            }

            BASE.componentEventUtils.fireGenericComponentEvent(component, BASE.componentEventUtils.GENERIC_EVENT_LOADED, responseValues);
        }
    },

    cancel: function(component, event, helper) {
        var requirementsCmp = component.find("requirementsCmp");
        if (requirementsCmp != null) {
            requirementsCmp.cancelAction();
        }
        else {
            if(component.get('v.buttonsVisible')) {
                helper.changeToRead(component, event, helper);
            }
        }
    },

    saveForm: function(component, helper) {
        component.set("v.errorMessages",[]);
        
        var fieldArray = component.get("v.fieldList");
        fieldArray = helper.setPickListDisplayValues(fieldArray);
        var saveArray = helper.getChangedFields(component, helper, fieldArray);
        if(saveArray.length > 0) {
            var action = component.get("c.saveFieldset");
            var sObjectName = component.get("v.sObjectName");
            var sObjectId = component.get("v.recordId");
            var params = {
                sObjectName : sObjectName,
                sObjectId : sObjectId,
                fieldsJson : JSON.stringify(saveArray),
                fieldsetName : helper.getFieldsetName(component,'v.fieldsetName'),
                recordTypeId : component.get('v.recordTypeId')
            }

            var extraOptions = {
                toastError: component.get("v.showToast"),
                afterFunction: helper.hideSpinner
            }
            BASE.baseUtils.executeAction(component, helper, "c.saveFieldset", params, helper.saveFormSuccess, extraOptions);
        }
        else {
            helper.changeToRead(component, event, helper);
            component.set('v.showSpinner', false);
        }
        component.set("v.fieldList",fieldArray);
    },

    saveFormSuccess : function(component, helper, responseValues) {
        var error = responseValues.error;
        var returnRecordId = responseValues.id;
        if(error && error != '') {
            var fieldList = responseValues.fields;
            helper.onSaveError(component, helper,fieldList);
            BASE.baseUtils.showToast(error,"error");
        }
        else {
            helper.onSaveSuccess(component, helper, responseValues);
            helper.getFieldsetSuccess(component, helper, responseValues);

            if(component.get("v.showToast")) {
                var sectionHeader = component.get("v.sectionHeader");
                BASE.baseUtils.showToast(sectionHeader ? sectionHeader + ' '+ "Successfully Saved" : "Record" + ' '+ "Successfully Saved","success");
                
            }

            component.set("v.state","Read");
            if(!component.get('v.isEmbedded')){
                $A.get('e.force:refreshView').fire();
            }
        }
    },

    checkAndSaveForm : function(component, event, helper) {
        component.set('v.showSpinner', true);
        if(helper.checkFieldErrors(component, helper) == false) {
            helper.saveForm(component, helper);
        }
        else {
            component.set('v.showSpinner', false);
            if(component.get('v.buttonsVisible')) {
                BASE.baseUtils.scrollToClass("slds-has-error", -160);
                // this extrascroller is for gmail
                setTimeout(function(){
                    document.getElementsByClassName('slds-has-error')[0].scrollIntoView();
                },10);
            }
        }
    },


    setFormula : function(component, helper){
        var formula = component.get("v.formulaDefinition");
        if (formula && formula.length >0 ) {
            var fieldArray = component.get("v.fieldList");
            var fieldsInFormula = [];
            var  pattern = /\{!([._0-9a-zA-Z]*)\}/i
            var parts = formula.split(' ');
            for (var index in parts) {
                var part = parts[index];
                if (pattern.test(part)) {
                    var fieldName = pattern.exec(part)[1]
                    for (var index2 in fieldArray) {
                        var field = fieldArray[index2];
                        if (field.name == fieldName) {
                            field.isInFormula = true;
                        }
                    }
                }
            }
            component.set("v.fieldList",fieldArray);
        }
    },

    recalculateFormula :function(component, helper) {
        var formula = component.get("v.formulaDefinition");
        if (formula && formula.length >0 ) {
            var fieldArray = component.get("v.fieldList");
            var fieldMap = [];
            for (var index in fieldArray) {
                var field = fieldArray[index];
                if (field.isInFormula) {
                    fieldMap[field.name] = (field.value?field.value:'');
                }
            }

            var  pattern = /\{!([._0-9a-zA-Z]*)\}/i
            var result = '';
            var parts = formula.split(' ');
            for (var index in parts) {
                var part = parts[index];
                if (pattern.test(part)) {
                    var matches = pattern.exec(part);
                    var fieldName = matches[1];
                    formula = formula.replace(matches[0],fieldMap[fieldName]);
                }
            }
            component.set("v.formulaResult",formula);
        }
    },

    recalculateFormulas : function(component, event, helper){
        var recalculateFormulaServerSide = component.get("v.recalculateFields");
        var fieldList = component.get('v.fieldList');
        var hasFormulaFields = false;

        if(recalculateFormulaServerSide){
            for(let fld of fieldList){
                if(fld.isCalculated){
                    hasFormulaFields = true;
                    break;
                }
            }

            if(hasFormulaFields){
                var params = {
                    fieldList : JSON.stringify(fieldList)
                };
                BASE.baseUtils.executeAction(component, helper, "c.recalculateFieldFormulas", params, helper.recalculateFormulasSuccess);
            }
        }
    },

    recalculateFormulasSuccess : function(component, helper, result){
        var fieldList = component.get('v.fieldList');
        var formulaChange = false;
        var field;

        if(fieldList && result) {
            for(let fld of fieldList){
                for(let resultFld of result.fields){
                    if(fld.name == resultFld.name && fld.value != resultFld.value){
                        fld.value = resultFld.value;
                        fld.updated = "";
                        field = fld;
                        formulaChange = true;
                    }
                }
            }
        }

        if(formulaChange){
            component.set('v.fieldList', fieldList);
            BASE.componentEventUtils.fireGenericComponentEvent(component, BASE.componentEventUtils.GENERIC_EVENT_FIELD_CHANGE, field);
        }
    },

    /* Will reload the picklist option override when changes haven been made, like selecting another candidate with different picklist options */
    changePicklistOptionOverrides : function(component, event, helper){
        var options = component.get("v.picklistOptionOverrides");
        var fieldList = component.get("v.fieldList");

        if(options && fieldList){
            for(let opt of options){
                if(opt.hasOwnProperty("key") && opt.hasOwnProperty("options")){
                    for(let fld of fieldList){
                        if(fld.hasOwnProperty("format") && fld.hasOwnProperty("options") && fld.format == opt.key){
                            fld.options = opt.options;
                        }
                    }
                }
            }
            component.set("v.fieldList", fieldList);
        }
    },

    /**
     * Change dependent picklists' options recursively if controlling field's value is changed
     *
     * @param component
     * @param helper
     * @param field  Field data of controlling field which value has been changed
     * @param warnings   holds labels of dependent picklist which were affected in result of its modification
     */
    changeDependentPicklistOptions : function(component, helper, field, warnings, errors) {
        let fieldList = component.get("v.fieldList");

        let isDependentFieldValueAllowedForControllerValue = (depField, value) =>
            (depField.dependentValuesByControllerValue[field.value] || []).includes(value);

        let isFieldValueMatchOptionValue = (field, options) => field.type === 'MULTIPICKLIST'
            ? field.value.split(';').every(value => options.some(option => option.value === value))
            : options.some(option => option.value === field.value);

        if (field && field.isController && !$A.util.isEmpty(field.dependentFields)) {
            let dependentSet = new Set(field.dependentFields);
            fieldList.forEach(fieldItem => {
                if (dependentSet.has(fieldItem.name)) {
                    fieldItem.options = fieldItem.initOptions.filter(option => isDependentFieldValueAllowedForControllerValue(fieldItem, option.value));
                    if (!isFieldValueMatchOptionValue(fieldItem, fieldItem.options)) {
                        //if dependent picklist used to have non-empty value before, show warning notification on done
                        if (fieldItem.value) {
                            warnings.push(fieldItem.label);
                        }
                        //if dependent picklist is controlling field in the same time, change also its dependent picklist options
                        if (fieldItem.isController) {
                            fieldItem.value = '';
                            helper.changeDependentPicklistOptions(component, helper, fieldItem, warnings, errors);
                        }
                    }
                }
            });
            component.set("v.fieldList", fieldList);
        }
    },

    callFieldComponentMethod: function(component, event, helper, data) {
        var fieldComponents= helper.findAll(component, "field");
        var returnDataArray = [];
        for(var f in fieldComponents) {
            let returnedData = fieldComponents[f].callComponentMethod(data);
            if(returnedData) {
                returnDataArray.push(returnedData);
            }
        }
        return returnDataArray;
    },

    getDependentPicklistWarningNotificationParams : function (warnings) {
        warnings[warnings.length - 1] += '<br/><br/>' + "Dependent Picklist";
        return {
            'messages' : warnings,
            'messageTitle' : "Dependent Picklist",
            'severity' : 'warning',
            'border' : true,
            'allowClosing' : true,
            'theme' : 'warning',
            'class' : 'slds-m-around_x-small',
            'timeout' : 6000
        }
    },
    
    setDefaultWorkflowStatus : function (component, helper, jobFieldData) {
    	var fieldList = component.get("v.fieldList");
        var workflowStatusField = fieldList.filter(function(item) {return item.name === BASE.baseUtils.getObjectPrefix(component) + 'Workflow_status__c'});

        if (workflowStatusField) {
        	var params = {
            	"jobId" : jobFieldData.value
            };
            BASE.baseUtils.executeAction(component, helper, "c.getDefaultWorkflowStatus", params, helper.setDefaultWorkflowStatusSuccess);
        }
    },
    
    setDefaultWorkflowStatusSuccess : function (component, helper, result) {
        var fieldList = component.get("v.fieldList");
        var index, workflowStatusField;
        for (let i = 0; i < fieldList.length; i++) {
        	if (fieldList[i].name === BASE.baseUtils.getObjectPrefix(component) + 'Workflow_status__c') {
            	workflowStatusField = fieldList[i];
                index = i;
                break;
            }
       	}

        if(workflowStatusField && result) {
            workflowStatusField.value = result;
            fieldList[index] = workflowStatusField;
            component.set("v.fieldList", fieldList);
        }           
    }
})