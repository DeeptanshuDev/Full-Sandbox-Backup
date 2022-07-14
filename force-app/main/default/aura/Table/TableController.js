({
    tableDoInit : function(component, event, helper) {
        helper.addResizeListener(component, event, helper);
        helper.doInit(component, event, helper);
    },

    tableDataChanged : function(component, event, helper) {
        window.setTimeout(
            $A.getCallback(function() {
                helper.refreshData(component, event, helper,true);
            }), 1000
        );
    },

    tableRender : function(component, event, helper) {
        helper.hideOverflow(component, event, helper, false);
    }
})