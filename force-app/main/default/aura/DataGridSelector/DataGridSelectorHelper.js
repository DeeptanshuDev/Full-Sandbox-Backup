({
    VIEW_INFO_LIST: {
        table: {
            view: "table",
            icon: "utility:table",
            labelOption: "View_as_table",
            labelDisplay: "Display_as_table",
            cssClass: ""
        },
        kanban: {
            view: "kanban",
            icon: "utility:kanban",
            labelOption: "View_as_kanban",
            labelDisplay: "Display_as_kanban",
            cssClass: "hidden"
        },
        tiles: {
            view: "tiles",
            icon: "utility:apps",
            labelOption: "View_as_tiles",
            labelDisplay: "Display_as_tiles",
            cssClass: ""
        },
        groupedTiles: {
            view: "groupedTiles",
            icon: "utility:summarydetail",
            labelOption: "View_as_grouped_tiles",
            labelDisplay: "Display_as_grouped_tiles",
            cssClass: "hidden"
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