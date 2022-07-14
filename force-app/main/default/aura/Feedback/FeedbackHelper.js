/* LABEL PRELOAD, DO NOT REMOVE
$Label.c.Save
$Label.c.Cancel
$Label.c.Send_Feedback
*/
({
    onClickLikeButton : function(component, event, helper) {
        helper.createShowFeedbackOverlay(component, event, helper, 'likeFieldSet');
    },
    
    onClickDislikeButton : function(component, event, helper) {
        helper.createShowFeedbackOverlay(component, event, helper, 'dislikeFieldSet');
    },
    
    onClickSuggestionButton : function(component, event, helper) {
        helper.createShowFeedbackOverlay(component, event, helper, 'suggestionsFieldSet');
    },
    
    createShowFeedbackOverlay : function(component, event, helper, fieldSetName) {
        var overlayComponents = [];
        
        //Overlay Header
        overlayComponents.push(
            [
                "aura:html", {
                    "tag": "h2",
                    "body": BASE.baseUtils.getLabel(component,'Send_Feedback'),
                    HTMLAttributes: { "class": "slds-text-heading_medium slds-hyphenate" }
                }
            ]
        );
        
        //Overlay Content/Body
        overlayComponents.push(
            [
                BASE.baseUtils.getPackagePrefix(component)+":FeedbackForm", {
                    fieldSetName: fieldSetName,
                    genericComponentEvent : component.getReference("c.closeModal")
                }
            ]
        );
        
        //Checking for length size
        if(overlayComponents.length > 0) {
            
            //Calling helper class method to dynamically creating component
            BASE.baseUtils.createComponents
            (component, helper, overlayComponents,
            function(component, helper, components){
                 
                //Setting attribute and functions for lightning overlay
                component.find('overlayLib').showCustomModal({
                    header: components[0],
                    body: components[1],
                    showCloseButton: true,
                    cssClass: 'slds-modal_small',
                    closeCallback: function() {}
                }).then(function (overlay) {
                    component.set("v.overlay",overlay);
                });
            });
        }
    }
})