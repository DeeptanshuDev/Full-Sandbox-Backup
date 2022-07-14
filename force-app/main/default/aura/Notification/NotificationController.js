({
    closeMessage : function(component, event, helper){
        if(component.get('v.allowClosing')) {
            event.preventDefault();
            component.set('v.messages',[]);
            component.set('v.messageTitle','');
            component.set("v.isShow", false);
        }
    },
    showMessage : function(component, event, helper){
        component.set("v.isShow", true);
    }
})