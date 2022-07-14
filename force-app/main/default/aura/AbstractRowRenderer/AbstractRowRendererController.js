({
    /* Initialization function */
    doInit: function(component, event, helper) {
        component.set('v.showSpinner', true);
        helper.setTileIcon(component, event, helper);
        var components = helper.getComponents(component, event, helper);
        BASE.baseUtils.createComponents(component, helper, components, helper.createdComponents);

        var roes = component.get("v.rows");
        
        var selected = component.get("v.selected");
        var row = component.get("v.row");

     
        var actionComponents = helper.getActionsComponents(component, event, helper);
       
        BASE.baseUtils.createComponents(component, helper, actionComponents, helper.createdActionComponents);
    },

    /* This function is called by the auta:method setSelectedAction */

    setSelected : function(component, event, helper){
        var args = event.getParams().arguments;
        var selected = args.selected;
        component.set("v.selected", selected);
    },

    /* This function will fire an even when the select checkbox is changed */
    selectChange : function(component, event, helper){
        var selected = component.get("v.selected");
        var row = component.get("v.row");

        if(selected){
            BASE.componentEventUtils.fireGenericComponentEvent(component, BASE.componentEventUtils.GENERIC_EVENT_ROW_SELECTED, [row]);
        }
        else{
            BASE.componentEventUtils.fireGenericComponentEvent(component, BASE.componentEventUtils.GENERIC_EVENT_ROW_DESELECTED, [row]);
        }
    },
})