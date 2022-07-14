({
	getChildDetail : function(component, event, helper) {
        
        component.set('v.mycolumns', [
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'Customer Name', fieldName: 'SCMC__Customer_Name__c', type: 'text'},
            {label: 'Sales Order', fieldName: 'SCMC__Sales_Order__c', type: 'text'},
            {label: 'Supplier Name', fieldName: 'SCMC__Supplier_Name__c', type: 'text '},
            {label: 'Purchase order', fieldName: 'SCMC__Purchase_Order__c', type: 'text '},
            {label: 'Carrier', fieldName: 'SCMC__Carrier__c', type: 'text '},
            {label: 'Carrier Service', fieldName: 'SCMC__Carrier_Service__c', type: 'text '},
            {label: 'Carrier Tracking Number', fieldName: 'SCMC__Carrier_Tracking_Number__c', type: 'number '},
            {label: 'Status', fieldName: 'SCMC__Status__c', type: 'text '},
            ]);
            var action = component.get('c.getShipping');
            var opId = component.get("v.recordId");
            console.log('record id is: ' + opId);
            action.setParams({
                oppId : opId
            });
            //"force:lightningQuickActionWithoutHeader,force:hasRecordId"
            action.setCallback(this, function(response){
            	var state = response.getState();
            	console.log('state is : '+state);
                if(state === 'SUCCESS' || state ==='DRAFT'){
                    var resonseValuess = response.getReturnValue();
                    console.log('shipping data are : ' + JSON.stringify(resonseValuess));
                    component.set('v.shippingList', resonseValuess);
                
                }
            
            });
            
        $A.enqueueAction(action);
		
	}
})