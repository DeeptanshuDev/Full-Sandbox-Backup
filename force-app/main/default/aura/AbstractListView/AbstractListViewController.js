({
    doInit : function(component, event, helper) {
        helper.doInit(component, event, helper);
    },
    
    /* Sets the table data from an aura:method */
    setData : function(component, event, helper){
        component.set("v.selectAll", false);
        var args = event.getParams().arguments;
        var data = args.rowData;
        component.set("v.data", data);
    },

    /* Sets the table columns from an aura:method */
    setColumns : function(component, event, helper){
        var args = event.getParams().arguments;
        var columns = args.columnData;
        component.set("v.columns", columns);
    },

    /* Sets the selected items from an aura:method */
    selectItems : function(component, event, helper){
        var args = event.getParams().arguments;
        var selectedItems = args.selectedItems;
        helper.setSelected(component, helper, selectedItems, true);
    },

    /* Sets the deselected items from an aura:method */
    deselectItems : function(component, event, helper){
        var args = event.getParams().arguments;
        var deselectedItems = args.deselectedItems;
        helper.setSelected(component, helper, deselectedItems, false);
    },

    /* Selects all items from an aura:method */
    selectAll : function(component, event, helper){
        var selected = component.get("v.selectAll");
        var tableRows = component.find("tableRow");
        var idList = [];
        var rowList = [];

        if(tableRows) {
            if(!Array.isArray(tableRows)) {
                tableRows = [tableRows];
            }

            for(var rowIndex=0,rowIndexSize=tableRows.length; rowIndex<rowIndexSize; rowIndex++) {
                var rowData = tableRows[rowIndex].get("v.row");
                var rowSelected = tableRows[rowIndex].get("v.selected");
                if(rowData != undefined && rowSelected != selected){
                    idList.push(rowData.Id);
                    rowList.push(rowData);
                }
            }
        }

        //Select or deselect all items that are not yet selected or deselected
        helper.setSelected(component, helper, idList, selected);

        //Fire an event to send the selected or deselected rows to the parent
        if(selected){
            BASE.componentEventUtils.fireGenericComponentEvent(component, BASE.componentEventUtils.GENERIC_EVENT_ROW_SELECTED, rowList);
        }
        else{
            BASE.componentEventUtils.fireGenericComponentEvent(component, BASE.componentEventUtils.GENERIC_EVENT_ROW_DESELECTED, rowList);
        }
    },

    /* Processes the component event form the table row (select, deselect) */
    onGenericComponentEvent : function(component, event, helper){
        var genericComponentEvent = BASE.componentEventUtils.getGenericComponentEvent(event);
        if(genericComponentEvent){
            if(genericComponentEvent.getState() == BASE.componentEventUtils.GENERIC_EVENT_ROW_SELECTED){
                var data = genericComponentEvent.getData();
                var selectedItems = component.get('v.currentSelectedItems');
                if(!selectedItems) {
                    selectedItems = [];
                }
                for(var item of data){
                    selectedItems.push(item);
                }
                component.set('v.currentSelectedItems', selectedItems);
				
                //Is this the last item checked?
                var tableRows = component.find("tableRow");

                if(tableRows) {
                    if(!Array.isArray(tableRows)) {
                          tableRows = [tableRows];
                    }
                    var allSelected = true;
                    for(var row of tableRows) {
                        var rowData = row.get("v.row");
                        var rowSelected = row.get("v.selected");
                        if (!rowSelected) {
                            allSelected = false;
                            break;
                        }
                    }
                }
                component.set("v.selectAll", allSelected);
            }
            else if(genericComponentEvent.getState() == BASE.componentEventUtils.GENERIC_EVENT_ROW_DESELECTED){
                //if one of the items is deselected and the selecAll is true, then deselect the selectAll checkbox
                var selectAll = component.get("v.selectAll");
                if(selectAll){
                    component.set("v.selectAll", false);
                }
				
                var data = genericComponentEvent.getData();
                var selectedItems = component.get('v.currentSelectedItems');
                if(!selectedItems) {
                    selectedItems = [];
                }
                for(var item of data){
                    selectedItems = selectedItems.filter(record => record.id != item.id);
                }
                component.set('v.currentSelectedItems', selectedItems);

            }
        }
    },

    /* We have new data, deselect the "select all" checkbox */
    dataChanged : function(component, event, helper) {
        if(!component.get("v.isInitialData")) {
            component.set("v.selectAll", false);
            component.set("v.currentSelectedItems",[]);   
        }
    },

    focusAction: function(component, event, helper) {
        // offset required for displaying filters, 160 - Salesforce standard header height, 70 - filter height
        var offset = 160 + 70;
        // check if the table header is in viewport
        if((component.find("scroll-position-id").getElement().getBoundingClientRect().top - offset) < 0) {
            BASE.baseUtils.scrollToClass("scroll-position-" + component.getGlobalId(), - offset);
        }
    }
})