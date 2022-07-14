({
    
    getMemoSuccess: function(component, helper, result) {
        if(result == null) {
            result = '';
        }
        result = result.split("\n").join("<br>");
        component.set('v.memo',result);
        component.set('v.memoOld',result);
        component.set('v.loading',false);
        component.set('v.edit',false);
        if(ratingStatus) {
            ratingStatus.resetEdit();
        }    
    },
    
    readMemo: function (component, helper) {
        component.set('v.edit',false)
        var memo = component.get('v.memoOld');
        component.set('v.memo',memo);
        if(ratingStatus) {
            ratingStatus.resetEdit();        
        }
    },
    
    closeMemo: function (component, event, helper) {
        if(ratingStatus) {
            ratingStatus.resetEdit();
        }
        component.set("v.methodName",'hideMemo');
        var compEvent = component.getEvent("genericComponentEvent");
        compEvent.fire();
    },
    
    mouseleave: function (component, event, helper) {
        if(ratingStatus) {
            ratingStatus.resetEdit();
        }    
        component.set("v.methodName",'onmouseleave');
        var compEvent = component.getEvent("genericComponentEvent");
        compEvent.fire();
    }
})