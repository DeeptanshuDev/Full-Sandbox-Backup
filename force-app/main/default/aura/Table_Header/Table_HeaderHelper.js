({
    fixOrderFields : function(component) {
        var orders = component.get('v.orders');
        var hasOrder = orders != null && orders.length > 0;

        component.set('v.hasOrder', hasOrder);
        if(hasOrder) {
            component.set('v.orderDirection', orders[0].direction == 'ORDER_DESC'?'desc':'asc');
            component.set('v.orderFieldName', orders[0].fieldName);
        }
    }
})