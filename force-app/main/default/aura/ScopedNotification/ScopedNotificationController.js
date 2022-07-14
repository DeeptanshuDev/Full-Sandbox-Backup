({
    /* Initialization */
    closeMessage : function(component, event, helper){
        if(component.get('v.allowClosing')) {
            event.preventDefault();
            component.set('v.messages',[]);
            component.set('v.messageTitle','');
            $A.util.addClass(component.find('container'),'slds-hide');
        }
    },
    
    showMessage : function(component, event, helper){
        $A.util.removeClass(component.find('container'),'slds-hide');
    },
    
    setMessage : function(component, event, helper) {
        var params = event.getParam("arguments");
        if(params && params.data) {
            component.set("v.severity",params.data.severity);
            component.set("v.messages",params.data.messages);
        }
    }
})