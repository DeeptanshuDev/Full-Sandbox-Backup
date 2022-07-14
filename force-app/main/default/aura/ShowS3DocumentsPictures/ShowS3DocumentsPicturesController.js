({
	doInit : function(component, event, helper) {
        var designRequestId = component.get("v.recordId");
		var action = component.get("c.getDocumentsList");
        action.setParams({
            designRequestId: designRequestId,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var result = response.getReturnValue();
                console.log("result:", result);
                if(result.isSuccess) {                    
                    component.set("v.isMessage", false);
                    component.set("v.errorMessage", "");
                    helper.setTableColumns(component, event, helper);
                    helper.setTableData(component, event, helper, result);
                } else {                    
                    component.set("v.isMessage", true);
                    component.set("v.errorMessage", result.message);
                }
            } else {                
                component.set("v.isMessage", true);
                component.set("v.errorMessage", "Some error occured. Please refresh the page.");
            }
        });
        $A.enqueueAction(action);
	}
})