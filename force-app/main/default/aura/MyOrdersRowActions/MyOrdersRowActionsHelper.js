/* LABEL PRELOAD, DO NOT REMOVE
$Label.c.Save
$Label.c.Cancel
$Label.c.Items_Details
$Label.c.Order_Details
*/ 
({
    handleSelect : function(component, event, helper) {
        var selectedMenuItemValue = event.getParam("value");
        console.log('selectedMenuItemValue--'+selectedMenuItemValue);
        if(selectedMenuItemValue == 'showItems'){
            helper.createShowItemsOverlay(component, event, helper);
        } else if(selectedMenuItemValue == 'showDetails') {
            let navigationType = component.get("v.navigationType");
            //Setting overlay as a value for now
            navigationType = 'Overlay';
            if(navigationType == 'CommunityPage') {
        		//TODO - Need to add logic here if needed community page navigation here	        
            } else {
                helper.createShowDetailsOverlay(component, event, helper);
            }
        } else if(selectedMenuItemValue == 'salesOrder') {
            helper.createShowSalesOrderOverlay(component, event, helper);
        }       
    },
    
    createShowItemsOverlay : function(component, event, helper) {
        var overlayComponents = [];
        
        //Overlay Header
        overlayComponents.push(
            [
                "aura:html", {
                    "tag": "h2",
                    "body": BASE.baseUtils.getLabel(component,'Items_Details'),
                    HTMLAttributes: { "class": "slds-text-heading_medium slds-hyphenate" }
                },
                
            ]
        );
        
        //Overlay Content/Body
        overlayComponents.push(
            [
                BASE.baseUtils.getPackagePrefix(component)+":MyOrdersItems", {
                    "selectedOrderRecordId": component.get("v.row.id"),
                    "doRefreshParent": component.getReference("v.doRefreshParent")
                }
            ]
        );
        
        //Footer cancel button
        overlayComponents.push(
            [
                "lightning:button", {
                    "name": "cancel",
                    "aura:id": "cancelButton",
                    "label": BASE.baseUtils.getLabel(component,'Close'),
                    "onclick": component.getReference("c.handleCancel")
                }
            ]
        );
        
        //Checking for length size
        if(overlayComponents.length > 0) {
            
            //Calling helper class method to dynamically creating component
            BASE.baseUtils.createComponents
            (component, helper, overlayComponents,
            function(component, helper, components){
                 
                //Setting attribute and functions for lightning overlay
                component.find('overlayLib').showCustomModal({
                    header: components[0],
                    body: components[1],
                    footer: [components[2]],
                    showCloseButton: true,
                    cssClass: 'slds-modal_large',
                    closeCallback: function() {
                        let doRefresh = component.get("v.doRefreshParent");
                        if(doRefresh) {
                            $A.get('e.force:refreshView').fire();
                        }
                    }
                }).then(function (overlay) {
                    component.set("v.overlay",overlay);
                });
            });
        }
    },
    
    closeModal: function(component, event, helper) {
        var overlay = component.get("v.overlay")[0];
        if(overlay) {
            setTimeout(function() {
                overlay.close();
            },50);
        }
    },
    
    createShowDetailsOverlay : function(component, event, helper) {
        var overlayComponents = [];
    	
        //Overlay Header
        overlayComponents.push(
            [
                "aura:html", {
                    "tag": "h2",
                    "body": BASE.baseUtils.getLabel(component,'Order_Details'),
                    HTMLAttributes: { "class": "slds-text-heading_medium slds-hyphenate" },
                    
                }
            ]
        );
        
        var orderDetails = [];
        orderDetails = helper.prepareResults(component, event, helper);
        console.log('orderDetails=='+JSON.stringify(orderDetails));
        //Overlay Content/Body
        overlayComponents.push(
            [
                
                BASE.baseUtils.getPackagePrefix(component)+":ObjectDetailPage", {
                    "fieldSetsDetails": orderDetails,
                    "showSpinner":true
                },

                

            ]
        );
        
        //Footer cancel button
        overlayComponents.push(
            [
                "lightning:button", {
                    "name": "cancel",
                    "aura:id": "cancelButton",
                    "label": BASE.baseUtils.getLabel(component,'Close'),
                    "onclick": component.getReference("c.handleCancel")
                },
               
            ]
        );
        
        //Checking for length size
        if(overlayComponents.length > 0) {
            
            //Calling helper class method to dynamically creating component
            BASE.baseUtils.createComponents
            (component, helper, overlayComponents,
             function(component, helper, components){
                 
                 //Setting attribute and functions for lightning overlay
                 component.find('overlayLib').showCustomModal({
                     header: components[0],
                     body: components[1],
                     footer: [components[2]],
                     showCloseButton: true,
                     cssClass: 'slds-modal_large',
                     closeCallback: function() {}
                 }).then(function (overlay) {
                     component.set("v.overlay",overlay);
                 });
             });
        }
    },

	prepareResults : function(component, event, helper) {
        
        var opppId = component.get("v.row.id");
        
        console.log('oppId' + opppId);
        let results = [
            {
                "sectionHeader":"Opportunity Information",
                "sectionDescription":"",
                "sectionOpen": true,
                "fieldsetName": "My_Order_Details_1",
                "fieldList": [],
                "fieldsToBlock": [],
                "sObjectName": "Opportunity",
                "selectedRecordId": component.get("v.row.id"),
                "recordTypeId": null,
                "readOnly": true,
                "isEmbedded": true,
                "buttonsVisible": false,
                "showToast": false,
                "editmodeAllowed":true,
                "columns": '2'
            },
            {
                "sectionHeader":"Order Dates",
                "sectionDescription":"",
                "sectionOpen": true,
                "fieldsetName": "My_Order_Details_2",
                "fieldList": [],
                "fieldsToBlock": [],
                "sObjectName": "Opportunity",
                "selectedRecordId": component.get("v.row.id"),
                "recordTypeId": null,
                "readOnly": true,
                "isEmbedded": true,
                "buttonsVisible": false,
                "showToast": false,
                "editmodeAllowed":true,
                "columns": '2'
            }
        ];
        return results;
    },

	createShowSalesOrderOverlay : function(component, event, helper) {
        var overlayComponents = [];
        
        //Overlay Header
        overlayComponents.push(
            [
                "aura:html", {
                    "tag": "h2",
                    "body": BASE.baseUtils.getLabel(component,'Sales_Order_Details'),
                    HTMLAttributes: { "class": "slds-text-heading_medium slds-hyphenate" }
                },
                
            ]
        );
        
        //Overlay Content/Body
        overlayComponents.push(
            [
                BASE.baseUtils.getPackagePrefix(component)+":SalesOrderDetails", {
                    "selectedOrderRecordId": component.get("v.row.id"),
                    "doRefreshParent": component.getReference("v.doRefreshParent")
                }
            ]
        );
        
        //Footer cancel button
        overlayComponents.push(
            [
                "lightning:button", {
                    "name": "cancel",
                    "aura:id": "cancelButton",
                    "label": BASE.baseUtils.getLabel(component,'Close'),
                    "onclick": component.getReference("c.handleCancel")
                }
            ]
        );
        
        //Checking for length size
        if(overlayComponents.length > 0) {
            
            //Calling helper class method to dynamically creating component
            BASE.baseUtils.createComponents
            (component, helper, overlayComponents,
            function(component, helper, components){
                 
                //Setting attribute and functions for lightning overlay
                component.find('overlayLib').showCustomModal({
                    header: components[0],
                    body: components[1],
                    footer: [components[2]],
                    showCloseButton: true,
                    cssClass: 'slds-modal_large',
                    closeCallback: function() {
                        let doRefresh = component.get("v.doRefreshParent");
                        if(doRefresh) {
                            $A.get('e.force:refreshView').fire();
                        }
                    }
                }).then(function (overlay) {
                    component.set("v.overlay",overlay);
                });
            });
        }
    },    
})