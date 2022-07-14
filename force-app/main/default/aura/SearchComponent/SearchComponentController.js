({
    /* Initialization */
    doInit : function(component, event, helper){
        setTimeout(function() {
        	helper.retrieveFieldMetadata(component, event, helper);
        }, 100);
    },

    /* Function adds the table data when a search is returning result */
    addToTable : function(component, event, helper){
        //Add new response data from search to table
        var responseData = component.get("v.contactResponseData");
        var selectedItems = component.get("v.selectedItems");
        var tableComponent = component.find("tableComponent");
        tableComponent.setDataAction(responseData);

        if(selectedItems != undefined){
            if(selectedItems.length > 0){
                var selectIdList = [];
                for(var item in selectedItems){
                    selectIdList.push(selectedItems[item].Id);
                }
                tableComponent.selectItemsAction(selectIdList);
            }
        }
    },

    /* Function is processing component event from table row (select and deselect) or table component (select all, deselect all) */
    onGenericComponentEvent : function(component, event, helper){
        var genericComponentEvent = BASE.componentEventUtils.getGenericComponentEvent(event);
        var maxSelect = component.get("v.maximumSelected");
        var currSelectList = component.get("v.selectedItems");

        if(genericComponentEvent){
            if(genericComponentEvent.getState() == BASE.componentEventUtils.GENERIC_EVENT_ROW_SELECTED){
                var dataList = genericComponentEvent.getData();
                if(currSelectList == undefined){
                    currSelectList = [];
                }

                var totalSelection = dataList.length + currSelectList.length;
                if(!maxSelect || maxSelect >= totalSelection){
                    for(var item in dataList){
                        currSelectList.push(dataList[item]);
                    }
                    component.set("v.selectedItems", currSelectList);

                    var tableRows = component.find('tableComponent').find("tableRow");

                    if(!Array.isArray(tableRows)) {
                        tableRows = [tableRows];
                    }

                    var allSelected = true;

                    for(var rowIndex=0,rowIndexSize=tableRows.length; rowIndex<rowIndexSize; rowIndex++) {
                        if(tableRows && tableRows[rowIndex]) {
                            var rowData = tableRows[rowIndex].get("v.row");
                            var rowSelected = tableRows[rowIndex].get("v.selected");
                            if(rowData && !rowSelected){
                                allSelected = false;
                                break;
                            }
                        }
                    }
                    component.find('tableComponent').set("v.selectAll",allSelected);
                    //If selection was successfull, then remove any raised errors
                    BASE.componentEventUtils.fireGenericComponentEvent(component, BASE.componentEventUtils.GENERIC_EVENT_NO_ERROR);
                }else{
                    //Deselect rows the user tried to select
                    var dataIdList = [];
                    for(var x=0, xSize=dataList.length; x<xSize; x++){
                        dataIdList.push(dataList[x].Id);
                    }
                    var tableComponent = component.find("tableComponent");
                    tableComponent.deselectItemsAction(dataIdList);
                    //Fire error event
                    BASE.componentEventUtils.fireGenericComponentEvent(component, BASE.componentEventUtils.GENERIC_EVENT_ERROR, {
                         "message":BASE.baseUtils.getLabel(component, "Table_max_selection", maxSelect, totalSelection),
                         "severity":"error",
                         "type":"scoped"
                    });
                }
            }
            else if(genericComponentEvent.getState() == BASE.componentEventUtils.GENERIC_EVENT_ROW_DESELECTED){
                var dataList = genericComponentEvent.getData();
                helper.removeSelectedItems(component, helper, dataList);
                var totalSelection = currSelectList.length - dataList.length;
                if(maxSelect >= totalSelection){
                    BASE.componentEventUtils.fireGenericComponentEvent(component, BASE.componentEventUtils.GENERIC_EVENT_NO_ERROR);
                }
            }
            else if(genericComponentEvent.getState() == 'SELECT_ALL'){
                var dataList = genericComponentEvent.getData();
                var selectList = [];
                var totalSelection = dataList.length + currSelectList.length;
                if(!maxSelect || maxSelect >= totalSelection){
                    for(var item in dataList){
                        selectList.push(dataList[item].Id);
                    }
                    component.find('tableComponent').selectAllItemsAction(selectList);
                    component.set("v.selectedItems", dataList);
                    BASE.componentEventUtils.fireGenericComponentEvent(component, BASE.componentEventUtils.GENERIC_EVENT_NO_ERROR);
                }else{
                    //Deselect rows the user tried to select
                    var dataIdList = [];
                    for(var x=0, xSize=dataList.length; x<xSize; x++){
                        dataIdList.push(dataList[x].Id);
                    }
                    var tableComponent = component.find("tableComponent");
                    tableComponent.deselectItemsAction(dataIdList);
                    //Fire error event
                    BASE.componentEventUtils.fireGenericComponentEvent(component, BASE.componentEventUtils.GENERIC_EVENT_ERROR, {
                        "message":BASE.baseUtils.getLabel(component, "Table_max_selection", maxSelect, totalSelection),
                        "severity":"error",
                        "type":"scoped"
                    });
                }
            }
        }
    },

    /* Function removes selected item from the list and updates the table component */
    removeSelected : function(component, event, helper){
        event.preventDefault();

        var chosenId = event.getSource().get("v.name");
        var tableComponent = component.find("tableComponent");
        tableComponent.deselectItemsAction([chosenId]);
        helper.removeSelectedItem(component, helper, chosenId);
    },

    /* Function returns a lost of selected items. Called from an aura:method */
    getSelectedItems : function(component, event, helper){
        var selectedItems = component.get("v.selectedItems");
        return selectedItems;
    },

    /* Function will clear the complete selection */
    clearSelection : function(component, event, helper){
        var selection = component.get("v.selectedItems");
        var deselectIdList = [];
        for(var item in selection){
            deselectIdList.push(selection[item].Id);
        }
        var tableComponent = component.find("tableComponent");
        tableComponent.deselectItemsAction(deselectIdList);
        component.set("v.selectedItems", []);
    },

    /* Returns the available column headers */
    getAvailableTableColumns : function(component, event, helper){
        return component.get("v.tableColumns");
    },
})