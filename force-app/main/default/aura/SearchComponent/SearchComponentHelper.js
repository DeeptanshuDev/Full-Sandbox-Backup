({
    removeSelectedItem : function(component, helper, chosenId){
        var selectedItems = component.get("v.selectedItems");
        if(selectedItems != undefined){
            for(var x = 0, xSize = selectedItems.length; x < xSize; x++) {
                if(selectedItems[x].Id == chosenId) {
                    selectedItems.splice(x, 1);
                    component.set('v.selectedItems', selectedItems);
                    break;
                }
            }
        }
    },

    removeSelectedItems: function(component, helper, items) {
        var selectedItems = component.get("v.selectedItems");
        if(selectedItems != undefined){
            for(var i = selectedItems.length -1; i >= 0; i--) {
                if(items.filter(x => x.Id == selectedItems[i].Id).length) {
                    selectedItems.splice(i, 1);
                }
            }
            component.set('v.selectedItems', selectedItems);
        }
    },

    retrieveFieldMetadata : function(component, event, helper){
        var objectName = component.get("v.objectApiName");
        var fieldsetName = component.get("v.fieldSet");

        helper.showSpinner(component, helper);

        var options = {
            "sObjectName" : objectName,
            "fieldSetName" : fieldsetName,
        };
        var extraOptions = {"afterFunction" : helper.hideSpinner};
        BASE.baseUtils.executeAction(component, helper, "c.RetrieveFieldSetData", options, helper.retrieveFieldMetadataSuccess, extraOptions);
    },

    retrieveFieldMetadataSuccess : function(component, helper, response){
        var searchFields = response["searchFields"];
        var searchFieldsWithAdditional = searchFields.slice(0);
        var additionalFields = component.get('v.additionalFields');
        for(var x=0,xSize=additionalFields.length; x < xSize; x++) {
            if(searchFieldsWithAdditional.indexOf(additionalFields[x]) == -1){
                searchFieldsWithAdditional.push(additionalFields[x]);
            }
        }

        component.find("searchComponent").setSearchAttributesAction(searchFieldsWithAdditional);
        component.find("tableComponent").setColumnsAction(searchFields);
        component.set("v.tableColumns", searchFields);
        var ids = component.get('v.initialItems');
        if(ids && ids.length > 0) {
            component.find("searchComponent").retrieveInitialItems(ids);
        }
        else{
            component.find("searchComponent").initializeDataAction();
        }
    },
})