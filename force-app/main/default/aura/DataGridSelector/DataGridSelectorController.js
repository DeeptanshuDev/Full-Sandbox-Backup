/* LABEL PRELOAD, DO NOT REMOVE
$Label.c.View_as_table
$Label.c.Display_as_table
$Label.c.View_as_kanban
$Label.c.Display_as_kanban
$Label.c.View_as_tiles
$Label.c.Display_as_tiles
$Label.c.View_as_grouped_tiles
$Label.c.Display_as_grouped_tiles
*/
({
    doInit : function(component, event, helper) {
        var views = component.get('v.views');
        var view = component.get('v.view');

        component.set('v.viewInfos', views.map(view => helper.getViewInfo(component, event, helper, view)));
        component.set('v.viewInfo', helper.getViewInfo(component, event, helper, view));
    },

    switchView : function(component, event, helper) {
        var view = BASE.baseUtils.getIdOfCurrentTargetFromEvent(event);
        component.set('v.view', view);
        component.set('v.viewInfo', helper.getViewInfo(component, event, helper, view));
        component.find("dropdown").close();
    }
})