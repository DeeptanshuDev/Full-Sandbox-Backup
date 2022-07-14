({
	cancelButton: function(component, event, helper) 
    {
        var isUIThemeClassic = component.get("v.isUIThemeClassic");
        if(isUIThemeClassic) {
        	window.location.href = '/' + component.get("v.recordId");
        } else {
            $A.get("e.force:closeQuickAction").fire();
        }        
    }
})