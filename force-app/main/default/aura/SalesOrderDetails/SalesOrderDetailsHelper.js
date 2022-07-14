({
	prepareFilters : function(component, event, helper, recId, dataFilters) {
        var selectedOrderRecordId = component.get("v.selectedOrderRecordId");
        if(selectedOrderRecordId != null) {
            helper.prepareFiltersForShippingItems(component, event, helper, selectedOrderRecordId);
            helper.prepareFiltersForPicklistItems(component, event, helper, selectedOrderRecordId);
            helper.prepareFiltersForPicklistDetailsItems(component, event, helper, selectedOrderRecordId);
        }
	},

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
                    console.log('some problem'+JSON.stringify(response.getError()));
                }
            });
            $A.enqueueAction(action);
        }
	},
    
    prepareSh : function(component, event, helper, openSections) {
        console.log('You are inside preparesh');
        console.log('sales order id is : ' + openSections);
        /*var selectedOrderRecordId = component.get("v.selectedOrderRecordId");
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
            $A.enqueueAction(action);*/
        
	},
    
    
    /* filter values for the standard item table */
    prepareFiltersForShippingItems : function(component, event, helper, recId) {
        let updatedFilterField = [];
        let shippingItemFilter = {
            "restriction": "EQ",
            "filterValue": {
                "stringValues": [recId],
                "integerValues": [],
                "booleanValues": []
            },
            "fieldName": "SCMC__Sales_Order__r.Opportunity__c"
        }
        
        updatedFilterField.push(shippingItemFilter);
        component.set("v.filtersShippingItem.filterFields", updatedFilterField);
    },
    
    prepareFiltersForPicklistItems : function(component, event, helper, recId) {
        let updatedFilterField = [];
        let shippingItemFilter = {
            "restriction": "EQ",
            "filterValue": {
                "stringValues": [recId],
                "integerValues": [],
                "booleanValues": []
            },
            "fieldName": "SCMC__Sales_Order__r.Opportunity__c"
        }
        
        updatedFilterField.push(shippingItemFilter);
        component.set("v.filtersPicklistItem.filterFields", updatedFilterField);
    },
    
    prepareFiltersForPicklistDetailsItems : function(component, event, helper, recId) {
        let updatedFilterField = [];
        let shippingItemFilter = {
            "restriction": "EQ",
            "filterValue": {
                "stringValues": [recId],
                "integerValues": [],
                "booleanValues": []
            },
            "fieldName": "SCMC__Picklist__r.SCMC__Sales_Order__r.Opportunity__c"
        }
        
        updatedFilterField.push(shippingItemFilter);
        component.set("v.filtersPicklistDetailsItem.filterFields", updatedFilterField);
    }
})