({
    showMemo : function(component, event, helper) {
       if (component.get('v.showMemo') === false) {
            component.set('v.showMemo',true);
            helper.createPopover(component, event, helper);
        }
    },

    getPermission : function(component,event,helper){
        BASE.baseUtils.executeAction(component, helper, "c.getPermission", {}, helper.getPermissionSuccess);
    },

    getPermissionSuccess: function(component, helper, responseValues) {
        component.set("v.fieldPermission", responseValues);
    },

    onSavedSuccess : function(component, event, helper) {
        var record = component.get('v.row');
        if (record) {
            record[BASE.baseUtils.getObjectPrefix(component)+'starDisplay__c']= component.get('v.value');
            component.set('v.row',record);
            BASE.componentEventUtils.fireGenericComponentEvent(component,BASE.componentEventUtils.GENERIC_EVENT_TABLE_CELL_RATING_UPDATED, {"row" : record}, null);
        } else {
            //The star rating is changed through Compare Component, which doesn't populate row value
            var record = {};
            record.id = component.get('v.id');
            record.value = component.get('v.value');
            //passing record Id and updated Star Rating value back to Compare component
            BASE.componentEventUtils.fireGenericComponentEvent(component,BASE.componentEventUtils.GENERIC_EVENT_TABLE_CELL_RATING_UPDATED, {"row" : record}, null);
        }

    },

    createPopover: function(component, event, helper) {
        var thisRecordId = component.get('v.id');
        var tableHelper = component.get("v.tableHelper");
        var nubbin = '-';
        var extraClass = 'slds-nubbin_left-top';
        var position = 'east';
        var windowWidth = window.innerWidth ;

        if(event && event.clientX > windowWidth- 380) {
            nubbin = 'right-top';
            position = 'west';
            extraClass = '';
        }
        component.set('v.isCreating',true);
        var componentAttributes = {thisRecordId:thisRecordId, 
                                   memoOld:component.getReference("v.updatedMemo"), 
                                   methodName:component.getReference("v.methodName"), 
                                   genericComponentEvent: component.getReference("c.ratingMemoEvent"),
                                   nubbin:nubbin+' '+position,
                                   readOnlyMode : component.get('v.fieldPermission.memo')
                                  };
        $A.createComponent(BASE.baseUtils.getPackagePrefix(component)+":RatingMemo", componentAttributes, $A.getCallback(function(newComponent, status, errorMessage){
            if (status === "SUCCESS") {
                var _referenceSelector = "."+component.get("v.componentRatingClass");
                component.find('overlayLib').showCustomPopover({
                    body: newComponent,
                    referenceSelector: _referenceSelector,
                    cssClass: "popoverclass,no-pointer,"+extraClass+",RatingMemo"
                }).then(function (overlay) {
                    component.set('v.overlay',overlay);
                    component.set('v.memoComponent', newComponent);
                    if (newComponent && newComponent.getElement()) {
                        newComponent.getElement().addEventListener('mouseover', $A.getCallback(() => {
                            helper.onmouseover(component, event, helper);
                        }));
                       newComponent.getElement().addEventListener('mouseleave', $A.getCallback(() => {
                            helper.onmouseleave(component, event, helper);
                       }));

                    }
                    component.set('v.isCreating',false);
                })
                .catch(function (error) {
                    component.set('v.overlay',null);
                });
            }
            else if (status === "INCOMPLETE") {
               BASE.baseUtils.showToast("No response from server or client is offline.", "error");
                component.set('v.showMemo',false);
                component.set('v.overlay',null);

            }
            else if (status === "ERROR") {
                BASE.baseUtils.showToast("Error: "+errorMessage, "error");
                component.set('v.showMemo',false);
                component.set('v.overlay',null);
            }
        }));
    },

    hideMemo : function(component, helper) {

        var showMemo = component.get("v.showMemo");
        if(ratingStatus) {
            ratingStatus.resetEdit();
        }
        	
        if (showMemo === true) {
            var overlayObject = component.get("v.overlay");
            if(overlayObject && Array.isArray(overlayObject) && overlayObject[0] && overlayObject[0].close) {
                setTimeout( () => {
                    if (component.get("v.isCreating") === false) {
                        var memoComponent = component.get('v.memoComponent');
                        overlayObject[0].close(0); //0 of close is an undocumented feature about returning focus. It prevents the page to scroll to the top.
                        if (memoComponent && memoComponent.destroy) {
                            memoComponent.destroy();
                        }
                        setTimeout( () => {
                            component.set('v.showMemo',false);
                        },200);

                    }
                }, 10);
            }
        }

    },

    formatId: function(htmlGlobalId) {
        return htmlGlobalId.replace(':', '-').replace(';', '-');
    },

    onmouseleave: function(component, event, helper) {
        clearTimeout(component.get('v.openTimeout'));
        clearTimeout(component.get('v.closeTimeout'));

        if (ratingStatus && !ratingStatus.isEdit()) {
            component.set("v.closeTimeout", setTimeout($A.getCallback(function() {
                helper.hideMemo(component, event, helper);
            }), 750));
        }
    },

    onmouseover: function(component, event, helper) {
        clearTimeout(component.get('v.openTimeout'));
        clearTimeout(component.get('v.closeTimeout'));
        if (ratingStatus && !ratingStatus.isEdit() && component.get('v.id')) {
            component.set("v.openTimeout", setTimeout($A.getCallback(function() {
                helper.showMemo(component, event, helper);
            }), 500));
        }
	}
})