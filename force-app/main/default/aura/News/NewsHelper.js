({
    doInit : function(component, event, helper) {
        if(!component.get("v.filters")) {
            component.set("v.filters", {
                filterFields: []
            });
        }
        var utilityAPI = component.find('utilitybar');
        if(utilityAPI) {
            BASE.baseUtils.doUtilityBarExists(utilityAPI,function(hasUtilityBar) {
                component.set("v.hasUtilityBar",hasUtilityBar);
            });
        }
		var extraOptions = {
            toastError: true,
        };
        BASE.baseUtils.executeAction(component, helper, "c.getInit", {}, helper.doInitSuccess, extraOptions);
    },
    doInitSuccess : function(component, helper, result, event) {
        if(result) {
            if(result.isSuccess) {
                let data = JSON.parse(result.body);
                component.set("v.filters", data.filters);
                component.set("v.isCommunityUser", data.isCommunityUser);
            }
            else {
                BASE.baseUtils.showToast(result.message, result.status);
            }
        }
        var extraOptions = {
            toastError: true,
        };
        BASE.baseUtils.executeAction(component, helper, "c.getInfoMessage", {}, helper.handleInfoMessageSuccess, extraOptions);
    },
    handleInfoMessageSuccess : function (component, helper, result, event) {
        if(result) {
            console.log('result ' + result);
            component.set("v.infoMessage", result);
        }
        component.set("v.initDone", true);
    },
    doRefreshCurrentView: function(component, event, helper) {
        var dataServiceComponent = component.find("MyNewsDataService");
        if(dataServiceComponent)
            dataServiceComponent.doRefreshCurrentPage();
    },
    doRefreshCurrentPage: function(component, event, helper) {
        var dataServiceComponent = component.find("MyNewsDataService");
        if(dataServiceComponent){
            dataServiceComponent.doHardRefresh();
        }
        var mainGrid = component.find("grid");
        if(mainGrid){
            mainGrid.focusAction();
        }
    },
    clearAllDataServiceFilters: function(component, event, helper) {
        let dataServiceFitler = component.find("MyNewsDataService");
        if(dataServiceFitler) {
            [].concat(dataServiceFitler)[0].clearAllFilters();
        }
    }
})