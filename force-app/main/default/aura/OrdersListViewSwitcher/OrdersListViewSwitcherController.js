/* LABEL PRELOAD, DO NOT REMOVE
$Label.c.View_as_all_orders
$Label.c.Display_as_all_orders
$Label.c.View_as_open_orders
$Label.c.Display_as_open_orders
$Label.c.View_as_closed_orders
$Label.c.Display_as_closed_orders
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