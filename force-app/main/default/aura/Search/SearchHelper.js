/* LABEL PRELOAD, DO NOT REMOVE
$Label.c.Search_keyword_message
*/

({
    initialize : function(component, event, helper){
        var hasInitialItems = component.get("v.hasInitialItems");

        if (!hasInitialItems) {
            component.set("v.showInputSpinner", "true");
            //helper.showSpinner(component, helper);

            var objectApiName = component.get("v.objectApiName");
            var fieldList = JSON.stringify(component.get("v.fieldList"));
            var relatedObjects = JSON.stringify(component.get("v.relatedObjects"));
            var whereClause = component.get("v.whereClause");
            var params = {
                "objectApiName" : objectApiName,
                "jsonRelatedObjects" : relatedObjects,
                "jsonFieldList" : fieldList,
                "whereClause" : whereClause
            };
            var extraOptions = {"afterFunction" : helper.hideInlineSpinner};
            BASE.baseUtils.executeAction(component, helper, "c.retrieveSearchData", params, helper.initializeSuccess, extraOptions);
        }
    },

    initializeSuccess : function(component, helper, response){
        component.set("v.recordsFound", response.recordsFound);
        component.set("v.recordCount", response.recordsFound.length);
        component.set("v.labelPlural", response.objectLabel);
    },

    searchRecords : function(component, event, helper){
        var searchText = component.get("v.searchText");

        if(searchText == null || searchText.length < 2){
            BASE.baseUtils.showToast(BASE.baseUtils.getLabel(component,"Search_keyword_message"), "error");
            
        }else{
            component.set("v.showInputSpinner", "true");

            var objectApiName = component.get("v.objectApiName");
            var fieldList = JSON.stringify(component.get("v.fieldList"));
            var relatedObjects = JSON.stringify(component.get("v.relatedObjects"));
            var whereClause = component.get("v.whereClause");

            var params = {
                "searchText" : searchText,
                "objectApiName" : objectApiName,
                "jsonRelatedObjects" : relatedObjects,
                "jsonFieldList" : fieldList,
                "whereClause" : whereClause
            };
            var extraOptions = {"afterFunction" : helper.hideInlineSpinner};

            BASE.baseUtils.executeAction(component, helper, "c.SearchFor", params, helper.searchRecordsSuccess, extraOptions);
        }
    },

    searchRecordsSuccess : function(component, helper, searchResponse){
        //Success
        if(searchResponse.status == "SUCCESS"){
            component.set("v.recordsFound", searchResponse.recordsFound);
            component.set("v.recordCount", searchResponse.recordsFound.length);
            component.set("v.responseData", null);
        }
        //Error
        if(searchResponse.status == "ERROR"){
            BASE.baseUtils.showToast(searchResponse.message, 'error');
        }
        //Empty list - No records found
        else if(searchResponse.recordsFound.length == 0 || searchResponse.status == "NO_RECORDS_FOUND"){
            BASE.baseUtils.showToast(searchResponse.message, "info");
            component.set("v.recordsFound", searchResponse.recordsFound);
        }
    },

    hideInlineSpinner : function(component, event, helper){
        component.set("v.showInputSpinner", "false");
    },

    retrieveInitialItems : function(component, event, helper, ids){
		var ids = JSON.stringify(ids);
        var objectApiName = component.get("v.objectApiName");
        var fieldList = JSON.stringify(component.get("v.fieldList"));
        var relatedObjects = JSON.stringify(component.get("v.relatedObjects"));

        var params = {
            "ids" : ids,
            "objectApiName" : objectApiName,
            "jsonRelatedObjects" : relatedObjects,
            "jsonFieldList" : fieldList
        };

        BASE.baseUtils.executeAction(component, helper, "c.SearchIds", params, helper.retrieveInitialSuccess);
    },

    retrieveInitialSuccess : function(component, helper, searchResponse){
        if(searchResponse.status == "SUCCESS"){
            component.set("v.recordsFound", searchResponse.recordsFound);
            // throw event to select these records
            BASE.componentEventUtils.fireGenericComponentEvent(component, 'SELECT_ALL',searchResponse.recordsFound);
        }
        helper.hideInlineSpinner(component, null, helper);
    },
})