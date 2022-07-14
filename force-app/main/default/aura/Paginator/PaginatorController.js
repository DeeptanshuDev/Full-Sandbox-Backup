/* LABEL PRELOAD, DO NOT REMOVE
 $Label.c.Explain_pagination_limit_message
*/
({
    previousPage : function(component) {
        var pageChangeEvent = component.getEvent("pagePrevious");
        pageChangeEvent.fire();
    },
    nextPage : function(component) {
        var pageChangeEvent = component.getEvent("pageNext");
        pageChangeEvent.fire();
    }
})