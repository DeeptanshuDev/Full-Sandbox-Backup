({
    enableButtons: function(component, helper, saveButtonMethod, buttonsVisible, cancelButtonMethod) {
        if(buttonsVisible == null) buttonsVisible = false;
        if(cancelButtonMethod == null) cancelButtonMethod = helper.defaultCancelButtonMethod;
		helper.privateEnableButtons(component, helper, saveButtonMethod, buttonsVisible, cancelButtonMethod);
    },

    privateEnableButtons: function(component, helper, saveButtonMethod, buttonsVisible, cancelButtonMethod) {
        if(component == null) throw "The parameter component is required";
        if(helper == null) throw "The parameter helper is required";
        if(saveButtonMethod == null) throw "The parameter saveButtonMethod is required";

        if(buttonsVisible == null) buttonsVisible = true;

        component.set("v.callerComponent", component);
        component.set("v.callerHelper", helper);
        component.set("v.saveButtonMethod", saveButtonMethod);
        component.set("v.buttonsVisible", buttonsVisible);
        component.set("v.cancelButtonMethod", cancelButtonMethod);
    },

    defaultCancelButtonMethod: function(component, event, helper) {
        helper.changeToRead(component, event, helper);
    },

    createFieldArray : function(component, helper, fieldList, fieldOverrides) {
        var prefix = component.get('v.packagePrefix');
        var fieldArray = [];
        var controllers = new Map();
        for(var f in fieldList) {
            var field = fieldList[f];
            var fieldDefault = helper.getFieldDefault(component, field.name);

            var newField = {
                "name" : field.name,
                "sObjectName": field.sObjectName,
                "label" : field.label ? field.label : field.name,
                "type" : field.type ? field.type : 'STRING',
                "help" : field.help ? field.help : '',
                "required" : field.required ?field.required : false,
                "readOnly" : field.readOnly ?field.readOnly : false,
                "value" : (fieldDefault && fieldDefault.value != null) ? fieldDefault.value : field.value,
                "displayValue" : (fieldDefault && fieldDefault.displayValue != null) ? fieldDefault.displayValue : field.displayValue,
                "oldValue" : field.value,
                "oldDisplayValue" : field.displayValue,
                "databaseValue" : field.value,
                "options" : field.options,
                "maxLength" : field.maxLength,
                "format" : field.format,
                "requirements" : field.requirements,
                "oldRequirements" : helper.copyList(field.requirements),
                "styleClass" : field.styleClass ? field.styleClass : '',
                "placeholder" : field.placeholder ? field.placeholder : '',
                "referencedObjectName" : field.referencedObjectName,
                "referencedObjectLabel" : field.referencedObjectLabel,
                "error" : '',
                "updated" : '',
                "viewable" : field.viewable,
                "useRequirementsComponent":  (field.type == 'REQUIREMENTS'),
                "namePointingList": field.namePointingList ? field.namePointingList.sort(helper.sortNamePointers) : [],
                "extraResultFields": field.extraResultFields ? field.extraResultFields : [],
                "fireFieldChangeEvent" : field.fireFieldChangeEvent,
                "fireFieldKeyUpEvent" : field.fireFieldKeyupEvent,
                'showDropFile' : true,
                'isCalculated' : field.isCalculated?field.isCalculated:false,
                'controllingField' : field.controllingField,
                'dependentValuesByControllerValue' : field.dependentValuesByControllerValue,
                'isHiddenField' : field.isHiddenField
            };
            if (field.type == 'REQUIREMENTS') {
                newField["recordId"] = field.recordId;
                newField["isStandaloneComponent"] = true;
            }
            if (field.type == 'REQUIREMENT_ASSESSMENT') {
                newField["isStandaloneComponent"] = true;
            }
            if(fieldOverrides && (fieldOverrides[newField.name] || fieldOverrides[newField.name.toLowerCase()])) {
                var override = fieldOverrides[newField.name];
                newField = Object.assign(newField, override);
            }

            if(typeof newField.value == 'undefined') {
                newField.value = null;
            }

            if(newField.type == 'BOOLEAN') {
                newField.value = (newField.value == true || newField.value == 'true');
                newField.oldValue = newField.value;
            }
            if(newField.type == 'CHECKBOX') {
                newField = helper.calcFieldOptions(newField);
            }
            if (newField.controllingField) {
                let dependentFields = controllers.get(newField.controllingField) || [];
                controllers.set(newField.controllingField, dependentFields.concat(newField.name));
            }
            fieldArray.push(newField);
        }
        fieldArray.forEach(field => {
            if (controllers.has(field.name)) {
                field.fireFieldChangeEvent = true;
                field.isController = true;
                field.dependentFields = controllers.get(field.name);
            }
        })

        fieldArray = helper.setPickListDisplayValues(fieldArray);

        component.set("v.fieldList",fieldArray);
    },

    getFieldDefault : function(component, fieldName) {
        var selectedRecordTypeId = component.get("v.recordTypeId");

        var defaults = component.get('v.defaults');
        var recordId = component.get('v.recordId');

        if(!recordId && defaults != null) {
            for(let d in defaults) {
                let fieldDefault = defaults[d];
                // sadly not all data is passed case sensitive
                if(fieldDefault.name.toLowerCase() == fieldName.toLowerCase()) {
                    if(fieldDefault.recordTypeId == selectedRecordTypeId || fieldDefault.recordTypeId == undefined) {
                        fieldDefault.isOnScreen = true;
                        return fieldDefault;
                    }
                }
            }
        }

        return null;
    },

    calcFieldOptions : function (field) {
        for( var o in field.options) {
            var option = field.options[o];
            option.id = option.value;
            option.value = (field.value.indexOf(option.id) > -1);
        }
        return field;
    },

    sortNamePointers : function (a,b) {
        if(a.objectLabel < b.objectLabel) return -1
        if(a.objectLabel > b.objectLabel) return 1
        return 0;
    },

    setMultiCheckboxValues : function (fieldArray) {
        for(var f in fieldArray) {
            var myField = fieldArray[f];

            if(myField.type == 'CHECKBOX') {
                var valueList = [];
                for(var o in myField.options) {
                    var option = myField.options[o];
                    if (option.value) {
                        valueList.push(option.id);
                    }
                }
                myField.value = valueList.join(';');
            }
        }
    },

    setPickListDisplayValues : function(fieldArray) {
        this.setMultiCheckboxValues(fieldArray);
        let controllersArray = fieldArray.filter(field => field.isController) || [];
        let controllers = new Map(controllersArray.map(field => [field.name, field]));
        for(var f in fieldArray) {
            var myField = fieldArray[f];
            if(myField && myField.options && myField.options.length > 0) {
                var valueList = [];
                myField.displayValue = '';

                if((myField.type == 'MULTIPICKLIST' || myField.type == 'CHECKBOX' )&& myField.value != null && myField.value != '') {
                    valueList = myField.value.split(';');
                }
                else {
                    valueList.push(myField.value);
                }
                var seperator = '';
                for(var p in myField.options) {
                    var myOption = myField.options[p];
                    for(var v in valueList) {
                        var myValue = valueList[v];
                        if(myValue && (myOption.value == myValue || myOption.id == myValue)){
                            myField.displayValue += seperator+myOption.label;
                            var seperator = '\n';
                        }
                    }
                }

                //set dependent picklist values and options
				myField.initOptions = myField.options;
                if (myField.controllingField && controllers.has(myField.controllingField)) {
                    let controller = controllers.get(myField.controllingField);
                    let controllerValue = typeof(controller.value) === 'boolean'
                        ? controller.value.toString()
                        : controller.value;
                    if (controllerValue && myField.dependentValuesByControllerValue
                            && myField.dependentValuesByControllerValue[controller.value]) {
                        let dependentSet = new Set(myField.dependentValuesByControllerValue[controller.value]);
                        myField.options = myField.options.filter(option => dependentSet.has(option.value));
                    }
                    if (!controllerValue) {
                        myField.options = [];
                    }
                }
            }
            if(myField && myField.oldOptions) {
             	myField.oldOptions = myField.options;   
            }
        }
        return fieldArray;
    },

    getAllFields: function(component, helper, includeEmptyFieldValue) {
        var fieldArray = component.get("v.fieldList");
        fieldArray = helper.setPickListDisplayValues(fieldArray);
        var dataArray = [];
        var fieldComponents= helper.findAll(component, "field");
        for(var field of fieldComponents) {
            var keyValue = field.getValueAction();
            // when includeEmptyFieldValue is true, it would return list of empty fields as well
            if(keyValue.value || includeEmptyFieldValue) {
                dataArray.push(keyValue);
            }
        }
        dataArray = helper.addHiddenFieldData(component, dataArray);
        return dataArray;
    },

    getChangedFields : function(component, helper, fieldArray) {
        if(!fieldArray) {
            fieldArray = component.get("v.fieldList");
        }
        fieldArray = helper.setPickListDisplayValues(fieldArray);
        var saveArray = [];
        var fieldComponents= helper.findAll(component, "field");
        for(var field of fieldComponents ) {
            if (field.isChangedAction()) {
                saveArray.push(field.getValueAction());
            }
        }
        saveArray = helper.addHiddenFieldData(component, saveArray);
        return saveArray;
    },

    checkFieldErrors : function(component, helper) {  // check for clientside errors of the fields
        var errorsFound = false;
        var fieldArray = component.get("v.fieldList");
        for(var f in fieldArray) {
            var field = fieldArray[f];
            field.error = '';

            if(field.value == null || field.value == '' ||
                (Array.isArray(field.value) && field.value.length < 1) ) {
                if(field.required && field.readOnly !='true' && field.type != "BOOLEAN") {
                    field.error = "Required Field";
                    errorsFound = true;
                }
                if(field.type == 'REFERENCE' && !(field.displayValue == '' || field.displayValue == null)) {
                    field.error = "Invalid Reference";
                    errorsFound = true;
                }
            }
            else{
                if(field.maxLength && field.maxLength < (field.value+'').length) {
                    field.error = "Field too long";
                    errorsFound = true;
                }
                switch(field.type) {
                    case "EMAIL" :
                        var myMailValue = field.value.toLowerCase();
                        if(!myMailValue.match(/(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])/)) {
                            field.error = "Invalid Email";
                            errorsFound = true;
                        }
                        break;
                    case "URL" :
                        var urlCheck =  /^(?:https?:\/\/)?(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})).?)(?::\d{2,5})?(?:[/?#]\S*)?$/i.test(field.value);
                        if(!urlCheck) {
                            "Invalid Url";
                            errorsFound = true;
                        }
                        break;
                    case "DATETIME" :
                        var regex = /\d{4}-[01]\d-[0-3]\dT[0-2]\d:[0-5]\d:[0-5]\d(?:\.\d+)?Z?/gm;
                        if(!field.value.match(regex)){
                            field.error = "Invalid Datetime";
                            errorsFound = true;
                        }
                        break;
                }
            }
        }
        component.set("v.fieldList",fieldArray);
        return errorsFound;
    },

    onSaveSuccess : function(component, helper, result) {
        var fieldArray = component.get("v.fieldList");
        for(var f in fieldArray) {
            var field = fieldArray[f];
            field.oldValue = field.value;
            field.oldDisplayValue = field.displayValue;
            field.error = '';
        }

        BASE.componentEventUtils.fireGenericComponentEvent(component, BASE.componentEventUtils.GENERIC_EVENT_SAVED, result);
    },

    onSaveError : function(component, helper, fieldErrorList) { // show the serverside errors of the fields
         var fieldArray = component.get("v.fieldList");
         for(var f in fieldArray) {
                var field = fieldArray[f];
                field.error = '';
                for(var ef in fieldErrorList) {
                    var errorField = fieldErrorList[ef];
                    if(errorField.name == field.name && errorField.value == field.value) {
                        if(errorField.error) {
                            field.error = errorField.error;
                        }
                    }
                }
         }
         component.set("v.fieldList",fieldArray);
    },

    changeToRead:function(component, event, helper) {
        var fieldArray = component.get("v.fieldList");
        for(var f in fieldArray) {
            var field = fieldArray[f];
            field.value = field.oldValue;
            field.options = field.oldOptions;
            field.requirements = field.oldRequirements;
            if(field.type == 'REFERENCE') {
                field.displayValue = field.oldDisplayValue;
            }
            field.error = '';
        }
        component.set("v.fieldList",fieldArray);
        component.set("v.state","Read");
    },

    changeStateToEdit :function(component, event, helper) {
        component.set("v.state","Edit");
    },

    copyList : function (list) {
        var copiedList = [];
        for (var i in list) {
            var elem = JSON.parse(JSON.stringify(list[i]));
            copiedList.push(elem);
        }
        return copiedList;
    },

    setOverrideDataAction: function(component, helper, data){
        helper.setData(component, helper, data, "override");
    },

    setPreviousDataAction: function(component, helper, data){
        helper.setData(component, helper, data, "previous");
    },

    setDatabaseValueAction: function(component, helper, data){
        helper.setData(component, helper, data, "database");
    },

    setDatabaseValueWithPreviousAction: function(component, helper, data){
        helper.setData(component, helper, data, "databaseWithPrevious");
    },

    setData: function(component, helper, data, actionName, reverse){

        if (data && data.length > 0) {
            var fieldArray = component.get("v.fieldList");
            // group each field's data with the field name, easier for comparison across two arrays
            var currentFieldsetArray = helper.convertArrayToObject(fieldArray, 'name');
            var passedFieldsArray = helper.convertArrayToObject(data, 'name');

            // iterate over passFieldsArray as focus is on passed data
            for(var key in passedFieldsArray) {

                // check if the key/property exists in both field objects
                if(key && passedFieldsArray.hasOwnProperty(key) && currentFieldsetArray && currentFieldsetArray.hasOwnProperty(key)) {
                    var passedField = passedFieldsArray[key];
                    var currentField = currentFieldsetArray[key];
                    var previousValue = currentField.value;

                    if(actionName === "previous") {

                        var currentFieldCopy = Object.assign({}, currentField);

                        // set the passed value to fieldset's current input field
                        currentField.value = passedField.value;

                    } else if(actionName === "database") {

                        // set the passed value to fieldset's current input field
                        currentField.value = passedField.value;
                        
                        // show database value as a undo option
                        currentField.updated = "";
                        if(currentField.value != currentField.databaseValue) {
                            currentField.updated = currentField.databaseValue;
                        }
                    } else if(actionName === "databaseWithPrevious") {

                        // show database value as a undo option
                        currentField.updated = "";
                        if(currentField.value != passedField.value) {
                            currentField.updated = passedField.value;
                        }
                    } else if(actionName === "override") {
                        // with this action, all the passed properties would be copied to current field in fieldset
                        for(var key in passedField) {
                            if (key && currentField.hasOwnProperty(key)) {
                                currentField[key] = passedField[key];
                            }
                        }
                    }
                }
            }

            fieldArray = helper.setPickListDisplayValues(fieldArray);
            component.set("v.fieldList",fieldArray);
        }
    },

    // converts the array to object with key as the property name
    convertArrayToObject: function(dataArray, propertyName) {
        var objectMap = {};

        for(var index = 0; index < dataArray.length; index++) {
            if(dataArray[index] && dataArray[index][propertyName]) {
                var key = dataArray[index][propertyName];
                objectMap[key.toLowerCase()] = dataArray[index];
            }
        }

        return objectMap;
    },

    getAllDataAction: function(component, helper, fetchAllFields) {
        var dataArray = helper.getAllFields(component, helper, fetchAllFields);
        return dataArray;
    },

    getSaveDataAction: function(component, event, helper) {
        var result = null;
        var embeddedHelper = component.get('v.embeddedHelper');
        if(embeddedHelper && embeddedHelper.overrideEmbeddedSave) {
            result= embeddedHelper.overrideEmbeddedSave(component, event, embeddedHelper);
        }
        else {

            if(helper.checkFieldErrors(component, helper) == false) {
                var fieldArray = component.get("v.fieldList");
                fieldArray = helper.setPickListDisplayValues(fieldArray);
                var saveArray = helper.getChangedFields(component, helper, fieldArray);

                saveArray = helper.addHiddenFieldData(component, saveArray);
                result = { 'error':false, 'fields':saveArray };
            }
            else {
                result = { 'error':true };
            }
        }

        return result;
    },

    /* Clears the value and displayvalue of the fieldlist */
    clearFieldValues : function(component, event, helper){
        var fieldArray = component.get("v.fieldList");
        fieldArray = helper.setPickListDisplayValues(fieldArray);
        for(var fieldIndex in fieldArray){
            fieldArray[fieldIndex].value = "";
            fieldArray[fieldIndex].displayValue = "";
        }
        component.set("v.fieldList", fieldArray);
    },

    setHiddenFieldData: function(component, data) {
        var additionalDataSaveMap = component.get("v.additionalDataSaveMap");
        for(var field of data) {
            var isFound = false;
            for(var additionalField of additionalDataSaveMap) {
                if(additionalField.name == field.name) {
                    additionalField.value = field.value;
                    isFound = true;
                    break;
                }
            }
            if(!isFound) {
                additionalDataSaveMap.push(field);
            }
        }
        component.set("v.additionalDataSaveMap", additionalDataSaveMap);
    },

    addHiddenFieldData: function(component, saveArray) {
        var additionalDataSaveMap = component.get("v.additionalDataSaveMap");
        if(additionalDataSaveMap) {
            for(var field of additionalDataSaveMap) {
                var isFound = false;
                for(var savedField of saveArray) {
                    if(savedField.name == field.name) {
                        isFound = true;
                        break;
                    }
                }
                if(!isFound) {
                    saveArray.push(field);
                }
            }
        }
        return saveArray;
    },

    getFieldByFieldData : function(fieldData, components){
        let targetComponent = null;
        for(let index in components){
            let fieldComponent = components[index];
            let fieldComponentData = fieldComponent.getFieldData();
            if(fieldComponentData.name == fieldData.name && fieldComponentData.sObjectName == fieldData.sObjectName){
                targetComponent = fieldComponent;
                break;
            }

        }
        return targetComponent;
    }
})