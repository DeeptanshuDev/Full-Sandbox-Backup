({
    setVersion : function(component, event)
    {
        component.set('v.selectedVersion',component.find('versionId').get('v.value'));
        var vx = component.get("v.method");
        $A.enqueueAction(vx);
    },
    
    setGender : function(component, event, helper)
    {
        component.set('v.selectedGender',component.find('genderId').get('v.value'));
        var vx = component.get("v.method");
        $A.enqueueAction(vx);
    },
    
    setReasonForRevision : function(component, event, helper)
    {
        component.set('v.selectedReasonForRevision',component.find('reasonForRevisionId').get('v.value'));
        var vx = component.get("v.method");
        $A.enqueueAction(vx);
    }
})