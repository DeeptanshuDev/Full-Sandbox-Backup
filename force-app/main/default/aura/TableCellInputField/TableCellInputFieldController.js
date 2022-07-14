({
	doInit:function(component, event, helper) {
        component.set('v.initDone',true);
	},
    
    valueChange : function(component, event, helper) {
        let type = component.get("v.type");
        let fieldName = type.fieldName;
        let row = component.get("v.row");
        row[fieldName] = component.get("v.value");
    }
})