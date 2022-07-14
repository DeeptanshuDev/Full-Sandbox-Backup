({
    doInit: function(component, event, helper) {
        
        var fieldName = component.get('v.column.fieldName');
        var fieldValue;
        var fieldType;
        
        if(component.get('v.row') && component.get('v.row')['extraData'] && component.get('v.row')['extraData'][fieldName]) {
            if(component.get('v.row')['extraData'][fieldName].displayValue) {
                fieldValue = component.get('v.row')['extraData'][fieldName].displayValue;
            }
            if(component.get('v.row')['extraData'][fieldName].type) {
                fieldType = component.get('v.row')['extraData'][fieldName].type;
            }
        }
        
        //In future we move this method to field component
        let parseValue = BASE.baseUtils.parseHtml(fieldValue || '');
        component.set("v.fieldValue",!parseValue || !parseValue.replace(/\s/g,'').length ? '':parseValue);
        
        if(fieldType && (fieldType == "DATETIME" || fieldType == "DATE")) {
            component.set("v.fieldValue", '');
        }
        
        var value = component.get("v.value");
        var row = component.get("v.row");
        var componentSpec = helper.getComponentSpec(component, row, component.get("v.column"), value, helper);
        
        if(componentSpec) {
            $A.createComponent(componentSpec.name, componentSpec.attributes, function(newComponent, status, errorMessage){
                if (status === "SUCCESS") {
                    var targetComponent = component.find("cell");
                    var body = targetComponent.get("v.body");
                    body.push(newComponent);
                    targetComponent.set("v.body", body);
                }else{
                    console.log(errorMessage);
                }
            });
        }        
    },
    
    selectChange : function(component, event, helper){
        var selected = component.get("v.selected");
        var row = component.get("v.row");
        
        if(selected){
            helper.fireGenericComponentEvent(component, helper.GENERIC_EVENT_ROW_SELECTED, row);
        }
        else{
            helper.fireGenericComponentEvent(component, helper.GENERIC_EVENT_ROW_DESELECTED, row);
        }
    },
    
    doNavigation : function(component, event, helper) {
    	alert('Do Something');
    }    
})