({
	prepareSo : function(component, event, helper, recId, dataFilters) {
        var selectedOrderRecordId = component.get("v.selectedOrderRecordId");
        if(selectedOrderRecordId != null) {
            console.log('You are in good position');
            var action = component.get("c.getSalesOrder");
            action.setParams({ "oppId" : selectedOrderRecordId });
            action.setCallback(this, function(response) {
            
                var state = response.getState();
                if (state === 'SUCCESS') {
                // Do stuff
                component.set('v.soList', response.getReturnValue());
                } 
                else {
                console.log(state);
                }
            });
            $A.enqueueAction(action);
        }
	},
})