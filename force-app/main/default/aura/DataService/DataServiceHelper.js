({
    // Timeout to throttle rapid firing change events when clearing all filters
    filtersChangedTimeout: null,

    getRecordsToDisplay : function(component, event, helper,page) {
        if(!component.get("v.onlyQueryData")){
            component.set('v.isLoading',true);
            component.set('v.showSpinner',true);
        }
        component.set('v.currentPageNumber', page);
        var params = {
            encryptedQueryStructureJson : component.get('v.queryStructure'),
            currentPage : page || 1,
            pageSize : component.get('v.pageSize'),
            ordersJson: JSON.stringify(component.get('v.orders')),
            filtersJson: JSON.stringify(component.get("v.filters")),
        };
        var extraOptions = {
            isStorable: component.get("v.isStorable"),
        };

        BASE.baseUtils.executeAction(component, helper, "c.getDataScope", params, helper.getRecordsToDisplaySuccess, extraOptions);
    },

    getRecordsToDisplaySuccess : function(component, helper, result) {
        var returnDescribeData = component.get('v.returnDescribeData');
        result = JSON.parse(result);
        var dataScope = [];
        for(var i in result){
            dataScope[i] = {};
            dataScope[i]['id'] =result[i].id ;
            if(returnDescribeData){
               dataScope[i]['extraData'] = {};
            }
            for(var j in result[i].fields){
                dataScope[i][result[i].fields[j].fieldPath] = result[i].fields[j].value ;
                if(returnDescribeData){
                    dataScope[i]['extraData'][result[i].fields[j].fieldPath] = result[i].fields[j];
                }
            }
        }
        if(!component.get("v.onlyQueryData")){
            component.set("v.dataScope", dataScope);
            component.set('v.isLoading',false);
            component.set('v.showSpinner',false);
            component.set('v.recordsFromTo',helper.calculateRecords(component, helper));
            //Clear the selected items
            component.set("v.selectedItems", []);
        }

        if(component.get("v.onlyQueryData")){
             var callback = component.get("v.callback");
             if (callback) {
                 callback(dataScope);
             }
        }

    },

    getInitInfo : function(component, event, helper) {
        // on initialization check if currentPageNumber has a value
        component.set("v.currentPageNumber" , 1);
        if(!component.get("v.onlyQueryData")){
            component.set('v.isLoading',true);
            component.set('v.showSpinner',true);
        }

        var params = {
            sObjectName : component.get('v.sObjectName'),
            fields : component.get('v.fields'),
            fieldSets : component.get('v.fieldSets'),
            pageSize : component.get('v.pageSize'),
            filtersJson: JSON.stringify(component.get('v.filters')),
            groupFields : component.get('v.groupFields'),
            hiddenFields: component.get('v.hiddenFields'),
        };

        var extraOptions = {
            isStorable: true,
        };
        BASE.baseUtils.executeAction(component, helper, "c.getInitInfo", params, helper.getInitInfoSuccess, extraOptions);
	},

    getInitInfoSuccess : function(component,helper, result) {
        if(result) {
            component.set('v.queryStructure',result.encryptedQueryStructureJson);
            component.set('v.fieldsDescribe',result.fieldDescribe);
			component.set("v.isInitialData",true);
            helper.getRecordsToDisplay(component,null,helper,component.get("v.currentPageNumber"));
            window.setTimeout(function() {
               helper.getPaginationInfo(component,null,helper,component.get("v.currentPageNumber"));
            }, 5);
        }
    },

    getPaginationInfo : function(component, event, helper,page) {
		var params = {
            encryptedQueryStructureJson : component.get('v.queryStructure'),
            pageSize : component.get('v.pageSize'),
        };
        var extraOptions = {
            isStorable: component.get("v.isStorable"),
        };
		BASE.baseUtils.executeAction(component, helper, "c.getPaginationDetails", params, helper.getPaginationInfoSuccess, extraOptions);
    },

    getPaginationInfoSuccess : function(component,helper, result) {
        component.set('v.totalPages',result.totalPages);
        component.set('v.totalNumberOfRecords',result.totalNumberOfRecords);
        component.set('v.hasMoreRecords',result.hasMoreRecords);
        component.set('v.recordsFromTo',helper.calculateRecords(component, helper));

    },

    onFiltersChanged: function(component, event, helper) {
        this.filtersChangedTimeout && clearTimeout(this.filtersChangedTimeout);

        this.filtersChangedTimeout = setTimeout($A.getCallback(function() {
            helper.getInitInfo(component, event, helper);
        }), 25);
    },

    calculateRecords: function(component, helper) {
        // $Label.c.Pagination
         var recordsFrom = 0;
         var recordsTo = 0;
         var currentPage = component.get('v.currentPageNumber');
         var pageSize = component.get('v.pageSize');
         var numberOfRecords = component.get('v.totalNumberOfRecords');
         var numberOfRecordsLabel = numberOfRecords;

         if(component.get('v.hasMoreRecords') === true){
             numberOfRecordsLabel = numberOfRecordsLabel + '+';
         }
         if(currentPage > 0){
             recordsFrom = (currentPage - 1) >=0 ?(currentPage - 1) * pageSize + 1 :0 ;
             recordsTo = currentPage * pageSize < numberOfRecords ? currentPage * pageSize : numberOfRecords;
         }
         if(recordsFrom == recordsTo){
			return BASE.baseUtils.getLabel(component,"Pagination" ,recordsFrom,numberOfRecordsLabel);
         }
        return BASE.baseUtils.getLabel(component,"Pagination" ,recordsFrom + ' - ' + recordsTo,numberOfRecordsLabel);
    }
})