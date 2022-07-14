({
    doInit : function(component, event, helper) {
        //{oppId: "0061500000RtgCIAAZ", isCommunityUser: "true", 
        //objName: "Opportunity", customComponentName: "",showSpinner : true}
        var vars = {};
        var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
            vars[key] = value;
        });
        var objectName = vars['objName']; 
        var recId = vars['oppId'];
        var isCommunityUser = vars['isCommunityUser'];
        console.log('@@@@ objectName ' + objectName);
        console.log('@@@@ recId ' + recId);
        console.log('@@@@ isCommunityUser ' + isCommunityUser);
        console.log('field set details ----'+JSON.stringify(component.get("v.fieldSetsDetails")));
        var fielddetails = component.get("v.fieldSetsDetails");
        var newRecId = '';
        for(var x in fielddetails){
           
            newRecId = fielddetails[x].selectedRecordId;
        }
        if(objectName && recId && isCommunityUser && isCommunityUser == 'true') {
            component.set("v.fieldSetsDetails", helper.prepareResults(component, event, helper, vars));
            component.set("v.showSpinner", vars['showSpinner']);
        } else {
            console.log('Not logged into a community');
        }
        component.set("v.initDone", true);
        
        var action = component.get('c.getStage');
        action.setParams({
            "id" : newRecId
        });
        action.setCallback(this, function(a){
            var state = a.getState();
            if(state == 'SUCCESS') {
                component.set("v.selectedStep", a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
    },
    
    onGenericComponentEvent : function(component, event, helper) {
        var componentEvent = BASE.componentEventUtils.getGenericComponentEvent(event);
        if(componentEvent.isSource("FIELDSET") 
        	&& componentEvent.getState() == BASE.componentEventUtils.GENERIC_EVENT_LOADED) {
            helper.updateHeaderWithDetails(component, event, helper, componentEvent.getData());
            helper.hideSpinnerForDetailPage(component, event, helper);
            

        }
    },
    
    handleEdit : function (component, event, helper) {

        var idx = event.target.id;
        console.log(idx);
        console.log('nrew ');
        console.log('record id is :'+selectedRecordId);
        console.log('record id is :',selectedRecordId);
        console.log('object record id is :'+objRecordId);
        console.log('object record id is :',objRecordId);
        
        
    
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": component.get("v.recordId")
        });
        console.log('record id is',component.get("v.recordId"));
        editRecordEvent.fire();
        
        console.log("done with the edit page");
    }
    
})