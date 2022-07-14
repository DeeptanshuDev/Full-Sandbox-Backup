({
    doInit : function(component, event, helper) 
    {
        var pageReference = component.get("v.pageReference");
        var state = pageReference.state;
        var entityName = state.hasOwnProperty('c__entityName')?state.c__entityName:null;
        component.set("v.entityName",entityName);
        var recordTypeSelection = state.hasOwnProperty('c__recordTypeSelection')?state.c__recordTypeSelection:null;
        component.set("v.recordTypeSelection",recordTypeSelection);
        var returnURL = state.hasOwnProperty('c__returnURL')?state.c__returnURL:null;
        component.set("v.returnURL",returnURL);
        var recTypeId = state.hasOwnProperty('c__recTypeId')?state.c__recTypeId:null;
        if(recTypeId) 
        {
            component.set("v.recTypeId", recTypeId);
        }
        var defaults = state.hasOwnProperty('c__defaults')?state.c__defaults:null;
        if(defaults) 
        {
            component.set("v.defaults",JSON.parse(decodeURIComponent(defaults)));
        }
        if(entityName) 
        {
            //If recTypeId parameter is not specified on button or invocation point
            if(!recTypeId) 
            {
                //if recordTypeSelection=true then to fetch all record type options 
                //if recordTypeSelection=false then fetch the default record type ID for the user
                var action = recordTypeSelection == 'true'?component.get("c.getRecordType"):component.get("c.getDefaultRecordType");
                action.setParams({objName: entityName});
                action.setCallback(this,function(response) {
                    if(response.getState() === 'SUCCESS') 
                    {
                        var result = response.getReturnValue();
                        var options = [];
                        for(var key in result) 
                        {
                            options.push({label:key,value:result[key]});
                        }
                        if(options.length > 0) 
                        {
                            if(recordTypeSelection == 'false')
                            {
                                component.set("v.selectedRecordType",options[0].value);
                                helper.handleNextNavigation(component,event,helper);                                
                            }
                            else
                            {
                                component.set("v.selectedRecordType",options[0].value);
                                var overlayComponents = [];
                                overlayComponents.push(
                                    [
                                        "aura:html", {
                                            "tag": "h2",
                                            "body": 'Select Record Type',
                                            HTMLAttributes: { "class": "slds-text-heading_medium slds-hyphenate" }
                                        }
                                    ]
                                );
                                overlayComponents.push(
                                    [
                                        "lightning:radioGroup", {
                                            "name": 'Record Types',
                                            "label": 'Record Types',
                                            "required":"true",
                                            "options": options,
                                            "value": component.getReference("v.selectedRecordType")
                                        }
                                    ]
                                );
                                overlayComponents.push(
                                    [
                                        "lightning:button", {
                                            "name": "Next",
                                            "class": "slds-button_brand",
                                            "label": 'Next',
                                            "onclick": component.getReference("c.handleNext")
                                        }
                                    ]
                                );
                                if(overlayComponents.length > 0) 
                                {
                                    $A.createComponents(overlayComponents,function(components, status, errorMessage) {
                                        if (status === "SUCCESS") {
                                            component.find('overlayLib').showCustomModal({
                                                header: components[0],
                                                body: components[1],
                                                footer: components[2],
                                                showCloseButton: false,
                                                cssClass: "slds-modal_small",
                                                closeCallback: function() {}
                                            }).then(function (overlay) {
                                                component.set("v.recordTypeOverlay",overlay);
                                            });
                                        } 
                                    });
                                }
                            }
                        }
                        else 
                        {
                            component.set("v.selectedRecordType", null);
                            component.set("v.recTypeId", null);
                            helper.handleNextNavigation(component,event,helper);
                        }
                    }
                });
                $A.enqueueAction(action);
            } else 
            {
                helper.handleNextNavigation(component,event,helper);
            }        
        }
    },
    
    handleNext: function(component,event,helper) 
    {
        helper.handleNextNavigation(component,event,helper);
    }
})