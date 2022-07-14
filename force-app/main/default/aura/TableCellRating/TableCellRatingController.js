({
    doInit:function(component, event, helper) {
        component.set("v.componentRatingClass", "ratingCell-" + helper.formatId(component.getGlobalId()));
        helper.getPermission(component,event,helper);
        component.set('v.initDone',true);
	},
    
    click:function(component, event, helper) {
        if(component.get('v.fieldPermission.rating') == true){
            var currentValue = component.get('v.value');
            var starClicked = parseInt(event.currentTarget.dataset.index);
            if(currentValue == starClicked) {
                starClicked--;
            }
            if (ratingStatus && !ratingStatus.isEdit() && component.get('v.id')) {
                helper.showMemo(component, event, helper);
            }
            component.set('v.value',starClicked);
            var tableHelper = component.get("v.tableHelper");
            if (component.get('v.id')) {
                BASE.baseUtils.executeAction(component, helper, "c.saveRating", {thisRecordId:component.get('v.id'), newRating:starClicked}, helper.onSavedSuccess, {toastError:true});
            }
            else {
                BASE.componentEventUtils.fireGenericComponentEvent(component,BASE.componentEventUtils.GENERIC_EVENT_TABLE_CELL_RATING_UPDATED, null, null);
            }
       }
    },

    mouseover:function(component, event, helper) {
        helper.onmouseover(component, event, helper);
    },

    mouseleave: function(component, event, helper) {
        helper.onmouseleave(component, event, helper);
    },

    handleDestroy: function(component, event, helper) {
        try{
            if(component.get('v.initDone')) {
                if(ratingStatus) {
                    ratingStatus.resetEdit();
                }

                var overlayObject = component.get("v.overlay");

                if(overlayObject && Array.isArray(overlayObject) && overlayObject[0] && overlayObject[0].close) {
                      setTimeout( () => {
                         overlayObject[0].close(0)//0 of close is an undocumented feature about returning focus. It prevents the page to scroll to the top.
                     }, 10);
                }
            }
        }
        catch(e) {
            console.log('TableCellRatingController.js handleDestroy',e);
        }
    },

    updateMemo: function(component, event, helper) {
        if (component.get("v.standAlone")) {
            var args = event.getParams().arguments;
            component.find("RatingMemo").setMemoValue(args.value);
        }

    },
    
    ratingMemoEvent: function(component, event, helper) {
        var methodName = component.get("v.methodName");
        if(methodName) {
            helper[methodName](component, event, helper);
            component.set("v.methodName",null);
        }
    },
    
})