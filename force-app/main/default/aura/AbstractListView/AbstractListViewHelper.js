({
    doInit : function(component, event, helper) {
        helper.setSelected(component, helper, component.get('v.currentSelectedItems') || [], true);
    },
    
    setSelected : function(component, helper, selectItems, selected){
        var rows;
        if(component.find("tableRow")) {
            rows = component.find("tableRow");
        }
        else if (component.find("tileRow")) {
            rows = component.find("tileRow");
        }
        // Wait till all components are showing.
        if(!rows) {
            window.setTimeout(
                $A.getCallback(function() {
                    helper.setSelected(component, helper, selectItems, selected);
                }), 100
            );
        }
        else {
            if(!Array.isArray(rows)) {
                rows = [rows];
            }
            if(!Array.isArray(selectItems)) {
                selectItems = [selectItems];
            }
            var selectedRecordCount = 0;
            for(var rowIndex=0,rowIndexSize=rows.length; rowIndex<rowIndexSize; rowIndex++) {
                var rowData = rows[rowIndex].get("v.row");
                if(rowData != undefined){
                    if(selectItems.length > 0){
                        for(var itemIndex=0,itemIndexSize=selectItems.length; itemIndex<itemIndexSize; itemIndex++) {
                            //Check if selectedItems[itemIndex] == undefined when checking on Id, else it will select all records
                            if(selectItems[itemIndex] == rowData.Id || selectItems[itemIndex] == rowData.id || (selectItems[itemIndex].id == rowData.id && selectItems[itemIndex].id)){
                                rows[rowIndex].setSelectedAction(selected);
                                selectedRecordCount ++;
                            }
                        }
                    }
                }
            }
            component.set("v.selectAll", rows.length == selectedRecordCount);
        }
    }    
})