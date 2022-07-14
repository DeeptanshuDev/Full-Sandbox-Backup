({
    VIEW_INFO_LIST: {
        allOrders: {
            view: "allOrders",
            icon: "utility:filter",
            labelOption: "View_as_all_orders",
            labelDisplay: "Display_as_all_orders",
            cssClass: ""
        },
        openOrders: {
            view: "openOrders",
            icon: "utility:filter",
            labelOption: "View_as_open_orders",
            labelDisplay: "Display_as_open_orders",
            cssClass: "hidden"
        },
        closeOrders: {
            view: "closeOrders",
            icon: "utility:filter",
            labelOption: "View_as_closed_orders",
            labelDisplay: "Display_as_closed_orders",
            cssClass: ""
        }
    },


    getViewInfo : function(component, event, helper, view) {
        return {
            view: helper.VIEW_INFO_LIST[view].view,
            icon: helper.VIEW_INFO_LIST[view].icon,
            labelOption: BASE.baseUtils.getLabel(component, helper.VIEW_INFO_LIST[view].labelOption),
            labelDisplay: BASE.baseUtils.getLabel(component, helper.VIEW_INFO_LIST[view].labelDisplay),
            cssClass: helper.VIEW_INFO_LIST[view].cssClass
        }
    }
})