({
    handleNextNavigation : function(component,event,helper) 
    {
        var pageReference = component.get("v.pageReference");
        var state = pageReference.state;
        var returnURL = state.hasOwnProperty('c__returnURL')?state.c__returnURL:null;       
        var defaults = component.get("v.defaults");
        var entityName = component.get("v.entityName");
        var selectedRecordType = component.get("v.selectedRecordType");
        var recordTypeIdvalue = component.get("v.recTypeId");
        var returnURL = component.get("v.returnURL");
        if(!selectedRecordType && recordTypeIdvalue) 
        {
            selectedRecordType = recordTypeIdvalue;
        }
        
        var createRecordEvent = $A.get("e.force:createRecord");
        var params = {
            "entityApiName": entityName,
            "defaultFieldValues": defaults,
            "panelOnDestroyCallback": function(event) 
            {
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": "/"+returnURL
                });
                urlEvent.fire();

            }, 
            "navigationLocation":"LOOKUP"
            
        };
        if(selectedRecordType) 
        {
            params["recordTypeId"] = selectedRecordType;
        }
        
        createRecordEvent.setParams(params);
        var overlay = component.get("v.recordTypeOverlay")[0];
        if(overlay) 
        {
            setTimeout(function() {
                overlay.close();
            },50);
        }
        createRecordEvent.fire();
    }
})