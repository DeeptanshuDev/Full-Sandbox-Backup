({
    doInit : function(component, event, helper){
        //helper.initialize(component, event, helper);
    },
    
    /* When a searchtext is filled in an has 2 or more characters, then do a search, else give error */
    searchRecords : function(component, event, helper){
        helper.searchRecords(component, event, helper);
    },
    
    setSearchAttributes : function(component, event, helper){
        var args = event.getParams().arguments;
        var fieldList = [];
        for(var fldIndex in args.fields){
            fieldList.push(args.fields[fldIndex].fieldName);
        }
        component.set("v.fieldList", fieldList);
    },
    
    initializeData : function(component, event, helper){
        helper.initialize(component, event, helper);
    },
    
    keyAction : function(component, event, helper){
        if(event.getParams().keyCode == 13){
            helper.searchRecords(component, event, helper);
        }
    },
    
    retrieveInitialItems : function(component, event, helper){
        var args = event.getParams().arguments;
        args = args.ids.slice(0);
        helper.retrieveInitialItems(component, event, helper, args);
    }
})