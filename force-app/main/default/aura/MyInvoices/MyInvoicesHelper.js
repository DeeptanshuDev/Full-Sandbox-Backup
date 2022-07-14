({
    doInit : function(component, event, helper) {
        var navigationHash = component.get('v.navigationHash');
        if(navigationHash){
            var localStorageData = window.localStorage.getItem(navigationHash);
            if(localStorageData){
                try{
                    var workflowAttributes =JSON.parse(atob(localStorageData));
                    window.localStorage.removeItem(navigationHash);
                    if(workflowAttributes.filters){
                        component.set('v.filters' ,workflowAttributes.filters);
                    }
                } catch(e){
                    window.localStorage.removeItem(navigationHash);
                }
            }
        }
        var objPrefix = BASE.baseUtils.getObjectPrefix(component);

        if(!component.get("v.filters")) {
            component.set("v.filters", {
                filterFields: []
            });
        }

        // Translate the labels for the tabs in the Browse component
        // This is also done for the English language as customers may have overridden the default values
        helper.ensureOrdersCorrectFieldNames(component);

        //Process design attributes
        BASE.dataServiceDesignUtil.getOrders(component, event, helper,component.get('v.ordersString'),'orders');
        BASE.dataServiceDesignUtil.getFields(component, event, helper,component.get('v.fieldsString'),'fields');
        BASE.dataServiceDesignUtil.getFieldSets(component, event, helper,component.get('v.fieldSetsString'),'fieldSets');

        //Design bug with default value
        var fieldSets = component.get('v.fieldSetsString')
        if(fieldSets) {
           component.set("v.fieldSets", fieldSets.split(',').map(fieldset => fieldset.trim()));
        }

        if(component.get('v.showFilters') == null || component.get('v.showFilters') == undefined){
            component.set("v.showFilters", 'true');
            //component.set("v.filterFieldSet", 'DataServiceFilters');
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
    
    //Success Method for getInit callback
    doInitSuccess : function(component, helper, result) {
        if(result) {
            let data = JSON.parse(result.body);
            component.set("v.filters", data.filters);
            component.set("v.isCommunityUser", data.isCommunityUser);
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
    
    ensureOrdersCorrectFieldNames : function (component) {
        component.set('v.ordersString',
            component.get('v.ordersString').replace(/([\w]+__c)/g, BASE.baseUtils.getPackagePrefix(component) + '__$1'));
    },
    
    doRefreshCurrentView: function(component, event, helper) {
        var dataServiceComponent = component.find("MyinvoicesDataService");
        if(dataServiceComponent)
            dataServiceComponent.doRefreshCurrentPage();
    },
    
    doRefreshCurrentPage: function(component, event, helper) {
        var dataServiceComponent = component.find("MyinvoicesDataService");
        if(dataServiceComponent){
            dataServiceComponent.doHardRefresh();
        }
        var mainGrid = component.find("grid");
        if(mainGrid){
            mainGrid.focusAction();
        }
    }
})