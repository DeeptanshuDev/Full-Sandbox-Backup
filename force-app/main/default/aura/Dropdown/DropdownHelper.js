({
    GENERIC_EVENT_DROPDOWN_OPENED: "DROPDOWN_OPENED",
    GENERIC_EVENT_DROPDOWN_CLOSED: "DROPDOWN_CLOSED",
    MAX_WIDTH_DROPDOWN: 320,
    HEIGHT_OF_SALESFORCE_NATIVE_HEADER: 100,
    
    toggle: function(component, event, helper) {
        let isOpened = component.get("v.isOpened");
        
        if(!isOpened) {
            helper.open(component, event, helper);
        }
        else {
            helper.close(component, event, helper);
        }
    },
    
    open: function(component, event, helper) {
        component.set("v.isOpened", true);
        !component.get("v.persistent") && BASE.baseUtils.addClickoutsideListener(component, event, helper, 'dropdown', function(){
            helper.close(component, event, helper);
        });
        helper.setDropdownPosition(component, event, helper);
        BASE.componentEventUtils.fireGenericComponentEvent(component, helper.GENERIC_EVENT_DROPDOWN_OPENED, {}, 'onOpen');
        component.set("v.invisible", true);
    },
    
    close: function(component, event, helper) {
        component.set("v.isOpened", false);
        BASE.componentEventUtils.fireGenericComponentEvent(component, helper.GENERIC_EVENT_DROPDOWN_CLOSED, {}, 'onClose');
    },
    
    setDropdownPosition: function(component, event, helper) {
        if(component.get("v.isOpened")) {
            var rect = component.find("dropdownButton").getElement().getBoundingClientRect();
            component.set("v.dropdownPositionClass", 'slds-dropdown_' + (rect.left + rect.width < helper.MAX_WIDTH_DROPDOWN ? 'left' : 'right'));
        }
        
        setTimeout($A.getCallback(() => {
            var dropdownBody = component.find("dropdown").getElement();
            dropdownBody.style.height='auto';
            var bodyRect = dropdownBody.getBoundingClientRect();
            var salesforceNativeHeader = document.getElementsByClassName('oneHeader');
            var positionIsBottom = true;
            var dropDownPosition = component.get('v.dropDownPosition');
            
            var availableHighOnTop = salesforceNativeHeader ? bodyRect.top -helper.HEIGHT_OF_SALESFORCE_NATIVE_HEADER : bodyRect.top ;
            var availableHighOnBottom =  window.innerHeight - bodyRect.top;
            
            if(dropDownPosition == 'auto') {
            	if((bodyRect.height + bodyRect.top > window.innerHeight - 5) ) {
            		if(  availableHighOnTop > availableHighOnBottom){
                        component.set("v.dropdownPositionClass", component.get("v.dropdownPositionClass") + ' slds-dropdown--bottom');
                        positionIsBottom = false;
        			}
				}
			}
			
			if(dropDownPosition == 'bottom') {
				positionIsBottom = true;
			}
			if(dropDownPosition == 'top') {
            	positionIsBottom = false;
        	}
        
            if(!positionIsBottom){
                if( bodyRect.top - helper.HEIGHT_OF_SALESFORCE_NATIVE_HEADER  < bodyRect.height){
                    if(((bodyRect.top - helper.HEIGHT_OF_SALESFORCE_NATIVE_HEADER ) - 25) < bodyRect.height){
                        component.set("v.dropdownPositionClass", component.get("v.dropdownPositionClass") + ' slds-scrollable');
                        dropdownBody.style.height=(bodyRect.top - helper.HEIGHT_OF_SALESFORCE_NATIVE_HEADER ) - 25 + 'px';
                    }
                    
                }
            }
            else{
                if(bodyRect.height + bodyRect.top > window.innerHeight){
                    if(((window.innerHeight - bodyRect.top) -5 ) < bodyRect.height){
                        component.set("v.dropdownPositionClass", component.get("v.dropdownPositionClass") + ' slds-scrollable');
                        dropdownBody.style.height=(window.innerHeight - bodyRect.top) -5 + 'px';
                    }
                    
                }
            }
            if(event){
                var params = event.getParam('arguments');
                if (params) {
                    var showDropDownBody = params.showDropDownBody;
                    
                    if(showDropDownBody){
                        component.set("v.invisible", false);
                    }
                }
            }
            
            if(component.get("v.displayAutomatically")){
                component.set("v.invisible", false);
            }
        }), 50)
	}
 })