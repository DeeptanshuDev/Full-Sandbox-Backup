/*
    Work in progress, is not completed.
    TODO:
     1. Fill remaining attributes in getFieldConfig()
     2. Invoke dynamic component creation on component load
     3. replace scary looking aura:if-else ladder with {!v.body} for dynamic component creation
     4. Handle when component is not loaded gracefully
*/

({

    KEYUP_TIMEOUT: null,
    
    keyup: function(component, event, helper) {

        var field =component.get('v.fieldData');

        if(field.fireFieldKeyUpEvent){
            clearTimeout(this.KEYUP_TIMEOUT);

            this.KEYUP_TIMEOUT = setTimeout($A.getCallback(function() {
                var fieldValue =component.get('v.fieldData.value');

                if (field.isInFormula && (fieldValue != field.oldValue)) {
                    field.value = fieldValue;
                    component.set('v.fieldData',field);
                    var compEvent = component.getEvent("formulaFieldChange");
                    compEvent.fire();
                }

                CXSREC.componentEventUtils.fireGenericComponentEvent(component, CXSREC.componentEventUtils.GENERIC_EVENT_FIELD_KEYUP, field);
            }),250);
        }
    },

    callComponentMethod: function(component, event, helper, data) {
        var componentId = data.componentId;
        var auraMethodName = data.auraMethodName;
        var auraMethodData = data.auraMethodData;
        var isReturnData = data.isReturnData;
        
        if(componentId && auraMethodName) {
            var fieldComponent= component.find(componentId);
            if(fieldComponent) {
                var returnedData = fieldComponent[auraMethodName](auraMethodData);
                if(isReturnData) {
                    var field =component.get('v.fieldData');
                    return { "name" : field.name, "returnedData" : returnedData};
                }
            }   
        }
    },
    
    isOverrideField: function(component,event,helper) {
        let fieldData = component.get("v.fieldData");
        if(fieldData && fieldData.type && fieldData.type == 'REFERENCE' && fieldData.name && fieldData.name.toLowerCase().endsWith("_override__c")) {
            component.set("v.isOverrideField",true);
        }
    }

})