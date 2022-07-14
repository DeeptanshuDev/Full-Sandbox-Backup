({
    prepareResults : function(component, event, helper, params) {
        var objRecordId = params['oppId'];
        
        
        let results = [
            {
                "sectionHeader":"Opportunity Information",
                "sectionDescription":"",
                "sectionOpen": true,
                "fieldsetName": "My_Order_Details_1",
                "fieldList": [],
                "fieldsToBlock": [],
                "sObjectName": "Opportunity",
                "selectedRecordId": objRecordId,
                "recordTypeId": null,
                "readOnly": true,
                "isEmbedded": true,
                "buttonsVisible": false,
                "showToast": false,
                "editmodeAllowed":true,
                "columns": '2'
            },
            {
                "sectionHeader":"Order Dates",
                "sectionDescription":"",
                "sectionOpen": true,
                "fieldsetName": "My_Order_Details_2",
                "fieldList": [],
                "fieldsToBlock": [],
                "sObjectName": "Opportunity",
                "selectedRecordId": objRecordId,
                "recordTypeId": null,
                "readOnly": true,
                "isEmbedded": true,
                "buttonsVisible": false,
                "showToast": false,
                "editmodeAllowed":true,
                "columns": '2'
            }
        ];
        return results;
    },
    
    updateHeaderWithDetails: function(component, event, helper, data) {
        for(var i = 0; i < data.fields.length; i++) {
            if(data.fields[i].sObjectName == 'Opportunity') {
                if(data.fields[i].name == 'Name') {
                    component.set("v.title", data.fields[i].displayValue);
                    component.set("v.showHeader", true);
                }
            }
        }
    },
	hideSpinnerForDetailPage: function(component, event, helper) {
    	var noOfFieldSets = component.get("v.noOfFieldSets");
        var currentFieldSetNumber = noOfFieldSets + 1;
        component.set("v.noOfFieldSets", currentFieldSetNumber);
        var fieldSetsDetails = component.get("v.fieldSetsDetails");
        if(fieldSetsDetails && fieldSetsDetails.length == currentFieldSetNumber) {
            component.set("v.showSpinnerOverDetailsPage", false);
        } else {
            component.set("v.showSpinnerOverDetailsPage", true);
        }
    }    
})