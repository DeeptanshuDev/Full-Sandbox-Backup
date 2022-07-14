({

    doInit: function(component, event, helper) {
        // $Label.c.Pagination
        if(!component.get("v.onlyQueryData")){
            helper.getInitInfo(component, event, helper);
        }
    },

    onFiltersChanged: function(component, event, helper) {
        if(!component.get("v.onlyQueryData")){
           helper.onFiltersChanged(component, event, helper);
        }
    },

    doDataSetRefresh : function(component, event, helper) {
        if(!component.get("v.onlyQueryData")){
            component.set("v.currentPageNumber",1);
            component.set("v.isInitialData",false);
            helper.getRecordsToDisplay(component, event, helper,1);
        }
    },

    doPrevious: function(component, event, helper) {
        if(!component.get("v.onlyQueryData")){
            var page = component.get("v.currentPageNumber") || 1;
            page = page - 1;
            component.set("v.isInitialData",false);
            helper.getRecordsToDisplay(component, event, helper,page);
        }
    },
    doNext: function(component, event, helper) {
        if(!component.get("v.onlyQueryData")){
            var page = component.get("v.currentPageNumber") || 1;
            page = page + 1;
            component.set("v.isInitialData",false);
            helper.getRecordsToDisplay(component, event, helper,page);
        }
    },

    /*
        Method to refresh current page with limited data scope
    */
    doRefreshCurrentPage : function(component, event, helper) {
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.isInitialData",false);
        helper.getRecordsToDisplay(component, event, helper,pageNumber);
    },
    
    /*
        Method to perform hard refresh opertion that will basic invoke the init load for data
    */
    doHardRefresh : function(component, event, helper) {
        helper.getInitInfo(component, event, helper);
    },

    queryData : function(component, event, helper) {
         var params = event.getParam('arguments');

         if(params){
            BASE.dataServiceDesignUtil.getOrders(component, event, helper,params.ordersString,'orders');
            BASE.dataServiceDesignUtil.getFilters(component, event, helper,params.filtersString,params.filtersLogicString,'filters',true);
            BASE.dataServiceDesignUtil.getFields(component, event, helper,params.fieldsString,'fields');
            component.set("v.sObjectName",params.sObjectName);
            component.set("v.callback", params.callback);
            //queryData is storable by default , but you can override this settings
            if(params.isStorable != null && params.isStorable != undefined){
                component.set('v.isStorable', params.isStorable);
            }else{
                component.set('v.isStorable', true);
            }
            //queryData by default will return describe info , but you can override this settings
            if(params.returnDescribeData != null && params.returnDescribeData != undefined){
                component.set('v.returnDescribeData', params.returnDescribeData);
            }else{
                component.set('v.returnDescribeData', true);
            }
            helper.getInitInfo(component, event, helper);
         }
    },
})