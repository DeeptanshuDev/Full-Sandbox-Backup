({
	fetchDetails : function(component, event, helper) {

        var action = component.get("c.getShipping");
        var opId = component.get("v.recordId");
        console.log('record id is: ' + opId);
        action.setParams({
            oppId : opId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                component.set("v.shippingList", response.getReturnValue());
                console.log('shipping list vales are : ' + JSON.stringify(shippingList));
            }
            else
            {
                alert('Error in getting data');
            }
            
        });
		$A.enqueueAction(action);
	}
})