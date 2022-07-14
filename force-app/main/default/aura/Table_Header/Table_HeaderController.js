({
    doInit : function(component, event, helper) {
        let fieldName = component.get("v.column.fieldName");
        let tuncateFields = component.get("v.truncateFields");
        var isTurncate = tuncateFields.find(function(value) {
            return value == fieldName;
        });
        component.set("v.isTruncateHeader",isTurncate);
        helper.fixOrderFields(component);
    },

    handleSort : function(component, event, helper) {
        var column = component.get("v.column");
        var orders = component.get("v.orders");
        var hasOrder = orders != null && orders.length != 0;

        var sortingOnThisColumn = hasOrder && (orders[0].fieldName == column.fieldName);

        if(hasOrder && sortingOnThisColumn) {
            orders[0].direction = orders[0].direction == 'ORDER_ASC'?'ORDER_DESC':'ORDER_ASC';
        }
        else {
            if(orders == null) {
                orders = [];
            }

            for(var o in orders) {
                if(orders[o].fieldName == column.fieldName) {
                    orders.splice(o, 1);
                    break;
                }
            }

            orders.unshift({fieldName:column.fieldName, direction:'ORDER_ASC'});
        }

        component.set('v.orders', orders);
    }
})