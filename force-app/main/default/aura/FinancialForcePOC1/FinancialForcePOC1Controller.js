//Testing POC for CR-20210323-15018 - created by - chirag soni - 05/12/2021
({
    searchField : function(component, event, helper) {
        var currentText = event.getSource().get("v.value");
        var resultBox = component.find('resultBox');
        component.set('v.issearching', false);
        component.set("v.LoadingText", true);
        if(currentText.length > 0) 
        {
            $A.util.addClass(resultBox, 'slds-is-open');
        }
        else {
            $A.util.removeClass(resultBox, 'slds-is-open');
        }
        var action = component.get("c.getResults");
        action.setParams({
            "ObjectName" : component.get("v.objectName"),
            "fieldName" : component.get("v.fieldName"),
            "value" : currentText
        });
        action.setCallback(this, function(response)
        {
            var STATE = response.getState();
            if(STATE === "SUCCESS") 
            {
                console.log('@@@@@ response ' + JSON.stringify(response.getReturnValue()));
                component.set("v.searchRecords", response.getReturnValue());
                if(component.get("v.searchRecords").length == 0) {
                    console.log('000000');
                }
            }
            else if (state === "ERROR") 
            {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            component.set("v.LoadingText", false);
        });
        $A.enqueueAction(action);
    },
    
    setSelectedRecord : function(component, event, helper) {
        var currentText = event.currentTarget.id;
        var resultBox = component.find('resultBox');
        $A.util.removeClass(resultBox, 'slds-is-open');
        component.set("v.selectRecordName", event.currentTarget.dataset.name);
        component.set("v.selectRecordId", currentText);
        component.set("v.reportingCode", event.currentTarget.dataset.status);
        component.find('userinput').set("v.readonly", true);
        component.set("v.isSelected", true);
    }, 
    
    resetData : function(component, event, helper) {
        component.set("v.selectRecordName", "");
        component.set("v.selectRecordId", "");
         component.set("v.isSelected", false);
        component.find('userinput').set("v.readonly", false);
    },
    
    handleCloseModal : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    
    saveAndUpdateEvent : function(component, event, helper){
        component.set("v.isSavingRecord", true);
        component.set("v.isSelected", false);
        
        var action = component.get("c.saveAndUpdateEABEvent");
        action.setParams({
            "eabEventId" : component.get("v.recordId"),
            "reportingCode" : component.get("v.reportingCode"),
        });
        
        action.setCallback(this, function(response){
            
            var STATE = response.getState();
            
            if(STATE === "SUCCESS") {
                var isSuccess = response.getReturnValue();
                if(isSuccess){
                   location.reload();
                }
            } 
            else if (STATE === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
         });
        $A.enqueueAction(action); 
    }
})