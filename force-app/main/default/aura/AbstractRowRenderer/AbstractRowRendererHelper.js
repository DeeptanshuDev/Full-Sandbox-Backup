({
    createdComponents:function(component, helper, components, scope) {
        component.set("v.body", components);
        component.set('v.showSpinner', false);
    },
    
    createdActionComponents:function(component, helper, components, scope) {
        component.set("v.renderedActionComponents", components);
    },
    
    getComponents: function(component, event, helper) {
        var columns = component.get("v.columns");
        var row = component.get("v.row");
        var rowNumber = component.get("v.rowNumber");
        var generateReferenceLinks = component.get("v.generateReferenceLinks");
        var isCommunityUser = component.get("v.isCommunityUser");
        var navigationType = component.get("v.navigationType");
        // set the cellComponentName with the right prefix
        var labelPrefix = BASE.baseUtils.getPackagePrefix(component); //component.get("v.labelPrefix");
        var cellComponentValue = component.get("v.cellComponentName");
        var cellComponentName ;
        if(cellComponentValue.indexOf(labelPrefix)== -1){
            cellComponentName = labelPrefix + ':' + cellComponentValue;
        }else{
            cellComponentName = cellComponentValue;
        }
        //var cellComponentName = labelPrefix + ':' + cellComponentValue;
        component.set("v.cellComponentName", cellComponentName);
        let mobileShrinkFields = component.get("v.mobileShrinkFields");
        
        var components = [];
        
        //Add select checkbox if selectable is activated
        var selectable = component.get("v.selectable");
        
        for(var i = 0; i < columns.length; i++) {
            if(!columns[i].isHiddenField){
                components.push([cellComponentName, {
                    "column": columns[i],
                    "value": row[columns[i].fieldName],
                    "row": component.getReference("v.row"),
                    "rowNumber": rowNumber,
                    "generateReferenceLink": generateReferenceLinks,
                    "isCommunityUser": isCommunityUser,
                    "navigationType": navigationType,
                    "isMobileShrink": i < mobileShrinkFields?true:false
                }]);
            }        
        }
        return components;
    },
    
    getActionsComponents: function(component, event, helper) {
        var actionComponents = component.get('v.actionComponents');
        var row = component.get("v.row");
        var objAccess = component.get("v.objectAccess");
        var navigationType = component.get("v.navigationType");
        var renderedActionComponents = [];
        for(var i = 0; i < actionComponents.length; i++) {
            var prefix = BASE.baseUtils.getPackagePrefix(component);
            
            renderedActionComponents.push([prefix+':'+actionComponents[i], {
                row: row,
                objectAccess: objAccess,
                navigationType: navigationType
            }]);
        }
        return renderedActionComponents;
    },
    
    setTileIcon: function(component, event, helper) {}
    
})