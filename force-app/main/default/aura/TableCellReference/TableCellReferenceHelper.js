/* LABEL PRELOAD, DO NOT REMOVE
$Label.c.Order_Details
$Label.c.Sales_Order_Details
*/
({
    openModalForOrderDetails : function(component, event, helper) {
        var overlayComponents = [];
        
        //Overlay Header
        overlayComponents.push(
            [
                "aura:html", {
                    "tag": "h2",
                    "body": BASE.baseUtils.getLabel(component,'Order_Details'),
                    HTMLAttributes: { "class": "slds-text-heading_medium slds-hyphenate" }
                }
            ]
        );
        
        var orderDetails = [];
        orderDetails = helper.prepareResultsForOpportunity(component, event, helper);
        
        //Overlay Content/Body
        overlayComponents.push(
            [
                BASE.baseUtils.getPackagePrefix(component)+":ObjectDetailPage", {
                    "fieldSetsDetails": orderDetails,
                    "showSpinner": true
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
                    "onclick": component.getReference("c.handleClose")
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
                     closeCallback: function() {}
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
    
    prepareResultsForOpportunity : function(component, event, helper) {
        let results = [
            {
                "sectionHeader":"Opportunity Information",
                "sectionDescription":"",
                "sectionOpen": true,
                "fieldsetName": "My_Order_Details_1",
                "fieldList": [],
                "fieldsToBlock": [],
                "sObjectName": "Opportunity",
                "selectedRecordId": component.get("v.id"),
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
                "selectedRecordId": component.get("v.id"),
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
    
    openModalForSalesOrderDetails : function(component, event, helper) {
        var overlayComponents = [];
        
        //Overlay Header
        overlayComponents.push(
            [
                "aura:html", {
                    "tag": "h2",
                    "body": BASE.baseUtils.getLabel(component,'Sales_Order_Details'),
                    HTMLAttributes: { "class": "slds-text-heading_medium slds-hyphenate" }
                }
            ]
        );
        
        var orderDetails = [];
        orderDetails = helper.prepareResultsForSalesOrder(component, event, helper);
        console.log('@@@@@ orderDetails ' + JSON.stringify(orderDetails));
        
        //Overlay Content/Body
        overlayComponents.push(
            [
                BASE.baseUtils.getPackagePrefix(component)+":ObjectDetailPage", {
                    "fieldSetsDetails": orderDetails,
                    "showSpinner": true
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
                    "onclick": component.getReference("c.handleClose")
                }
            ]
        );
        
        if(overlayComponents.length > 0) {
            BASE.baseUtils.createComponents
            (component, helper, overlayComponents,
             function(component, helper, components){
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
    
    prepareResultsForSalesOrder : function(component, event, helper) {
        let results = [
            {
                "sectionHeader":"Basic Information",
                "sectionDescription":"",
                "sectionOpen": true,
                "fieldsetName": "My_Sales_Order_Details_1",
                "fieldList": [],
                "fieldsToBlock": [],
                "sObjectName": "SCMC__Sales_Order__c",
                "selectedRecordId": component.get("v.id"),
                "recordTypeId": null,
                "readOnly": true,
                "isEmbedded": true,
                "buttonsVisible": false,
                "showToast": false,
                "editmodeAllowed":true,
                "columns": '2'
            },
            {
                "sectionHeader":"Address Information",
                "sectionDescription":"",
                "sectionOpen": true,
                "fieldsetName": "My_Sales_Order_Details_2",
                "fieldList": [],
                "fieldsToBlock": [],
                "sObjectName": "SCMC__Sales_Order__c",
                "selectedRecordId": component.get("v.id"),
                "recordTypeId": null,
                "readOnly": true,
                "isEmbedded": true,
                "buttonsVisible": false,
                "showToast": false,
                "editmodeAllowed":true,
                "columns": '2'
            },
            {
                "sectionHeader":"Pricing Information",
                "sectionDescription":"",
                "sectionOpen": true,
                "fieldsetName": "My_Sales_Order_Details_3",
                "fieldList": [],
                "fieldsToBlock": [],
                "sObjectName": "SCMC__Sales_Order__c",
                "selectedRecordId": component.get("v.id"),
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
    }
})