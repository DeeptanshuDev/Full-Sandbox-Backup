({
    navigate:function(component, event, helper) {
        var isCommunityUser = component.get("v.isCommunityUser");
        var objName = component.get("v.objName");
        if(isCommunityUser) {
            console.log('@@@@@ objName ' + objName);
            if(objName == 'Opportunity') {
                helper.openModalForOrderDetails(component, event, helper);    
            } else if(objName == 'SCMC__Sales_Order__c') {
                helper.openModalForSalesOrderDetails(component, event, helper);    
            }
        } else {
            var navigationSObject = $A.get("e.force:navigateToSObject");
            navigationSObject.setParams({
                "recordId": component.get("v.id")
            });
            navigationSObject.fire();
        }
    },
    
    handleClose: function(component, event, helper) {
        helper.closeModal(component, event, helper);
    }    
})