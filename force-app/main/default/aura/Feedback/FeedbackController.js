({
    onClickLikeButton : function(component, event, helper) {
        helper.onClickLikeButton(component, event, helper);
    },
    onClickDislikeButton : function(component, event, helper) {
        helper.onClickDislikeButton(component, event, helper);
    },
    onClickSuggestionButton : function(component, event, helper) {
        helper.onClickSuggestionButton(component, event, helper);
    },
    closeModal : function(component, event, helper) {
        var overlay = component.get("v.overlay");
        if(overlay) {
            [].concat(overlay)[0].close();
        }
    },
    doInit : function(component, event, helper) {}
})