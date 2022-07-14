/* LABEL PRELOAD, DO NOT REMOVE
$Label.c.Save
$Label.c.Cancel
$Label.c.Sales_Order_Details
*/
({
    handleSelect : function(component, event, helper) {
        var selectedMenuItemValue = event.getParam("value");
        if(selectedMenuItemValue == 'showDetails') {
            //helper.openInvoiceDetailsInNewTab(component, event, helper);
            helper.createShowDetailsOverlay(component, event, helper);
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
                    "body": BASE.baseUtils.getLabel(component,'Sales_Order_Details'),
                    HTMLAttributes: { "class": "slds-text-heading_medium slds-hyphenate" }
                }
            ]
        );
        
        var orderDetails = [];
        orderDetails = helper.prepareResults(component, event, helper);
        
        //Overlay Content/Body
        overlayComponents.push(
            [
                BASE.baseUtils.getPackagePrefix(component)+":ObjectDetailPage", {
                    "fieldSetsDetails": orderDetails,
                    "showSpinner":true
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
                     closeCallback: function() {}
                 }).then(function (overlay) {
                     component.set("v.overlay",overlay);
                 });
             });
        }
    },

	prepareResults : function(component, event, helper) {
        let results = [
            {
                "sectionHeader":"Basic Information",
                "sectionDescription":"",
                "sectionOpen": true,
                "fieldsetName": "My_Sales_Order_Details_1",
                "fieldList": [],
                "fieldsToBlock": [],
                "sObjectName": "SCMC__Sales_Order__c",
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
                "sectionHeader":"Address Information",
                "sectionDescription":"",
                "sectionOpen": true,
                "fieldsetName": "My_Sales_Order_Details_2",
                "fieldList": [],
                "fieldsToBlock": [],
                "sObjectName": "SCMC__Sales_Order__c",
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
                "sectionHeader":"Pricing Information",
                "sectionDescription":"",
                "sectionOpen": true,
                "fieldsetName": "My_Sales_Order_Details_3",
                "fieldList": [],
                "fieldsToBlock": [],
                "sObjectName": "SCMC__Sales_Order__c",
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
    
    openInvoiceDetailsInNewTab : function(component, event, helper) {
        var navigationUrl = '/customers/s/sales-order/';
        var recordId = component.get('v.row.id');
        window.open(navigationUrl + recordId, '_blank');  
    }
})