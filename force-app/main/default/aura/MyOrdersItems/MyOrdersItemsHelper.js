/**Please do not remove preloaded labels
 * $Label.c.Process_Reorder
 * $Label.c.Close
**/
({
	doInit : function(component, event, helper) {
        var utilityAPI = component.find('utilitybar');
        if(utilityAPI) {
            BASE.baseUtils.doUtilityBarExists(utilityAPI,function(hasUtilityBar) {
                component.set("v.hasUtilityBar",hasUtilityBar);
            });
        }
        var selectedOrderRecordId = component.get("v.selectedOrderRecordId");
        component.set("v.fieldSetsDetails", helper.prepareResults(component, event, helper, selectedOrderRecordId));
    },
    
    prepareFilters : function(component, event, helper, recId, dataFilters) {
        var selectedOrderRecordId = component.get("v.selectedOrderRecordId");
        if(selectedOrderRecordId != null) {
            helper.prepareFilterForOrders(component, event, helper, selectedOrderRecordId);
            helper.prepareFiltersForCustomItems(component, event, helper, selectedOrderRecordId);
            helper.prepareFiltersForStandizedItems(component, event, helper, selectedOrderRecordId);
            helper.prepareFiltersForDesignRound(component, event, helper, selectedOrderRecordId);
            var extraOptions = {
            	toastError: true,
        	};
            BASE.baseUtils.executeAction(component, helper, "c.getDesigns", {'selectedOrderId': selectedOrderRecordId}, helper.doInitSuccess, extraOptions);
        }
	},

    prepareFilters2 : function(component, event, helper, recId, dataFilters) {
        var selectedOrderRecordId = component.get("v.selectedOrderRecordId");
        if(selectedOrderRecordId != null) {
            helper.prepareFilterForOrders(component, event, helper, selectedOrderRecordId);
            helper.prepareFiltersForCustomItems(component, event, helper, selectedOrderRecordId);
            helper.prepareFiltersForStandizedItems(component, event, helper, selectedOrderRecordId);
            helper.prepareFiltersForDesignRound(component, event, helper, selectedOrderRecordId);
            var extraOptions = {
            	toastError: true,
        	};
            BASE.baseUtils.executeAction(component, helper, "c.getDesigns2", {'selectedOrderId': selectedOrderRecordId}, helper.doInitSuccessUnapproved, extraOptions);
        }
        
	},
    
    
    
    //Success Method for getInit callback
    doInitSuccess : function(component, helper, result, event) {
        if(result) {
            if(result.isSuccess) {
                let data = JSON.parse(result.body);
                
                let filters = data.filters;
                if(filters.filterFields && filters.filterFields[0] && filters.filterFields[0].filterValue) {
                    if(filters.filterFields[0].filterValue.stringValues && filters.filterFields[0].filterValue.stringValues.length == 0) {
                        filters.filterFields[0].filterValue.stringValues.push('');
                    }
                }
                component.set("v.filtersDesign", filters);
                component.set("v.isCommunityUser", data.isCommunityUser);
            } else {
                BASE.baseUtils.showToast(result.message, result.status);
            }
        }
        component.set("v.initDone",true);
        // component.set("v.showButton", !component.get("v.showButton"));
    },
    
    doInitSuccessUnapproved : function(component, helper, result, event) {
        if(result) {
            if(result.isSuccess) {
                let data = JSON.parse(result.body);
                
                let filters = data.filters;
                if(filters.filterFields && filters.filterFields[0] && filters.filterFields[0].filterValue) {
                    if(filters.filterFields[0].filterValue.stringValues && filters.filterFields[0].filterValue.stringValues.length == 0) {
                        filters.filterFields[0].filterValue.stringValues.push('');
                    } else {
                        component.set("v.showApprovedDesignButtons", true);
                    }
                }
                component.set("v.filtersUnapprovedDesign", filters);
                component.set("v.isCommunityUser", data.isCommunityUser);
            } else {
                BASE.baseUtils.showToast(result.message, result.status);
            }
        }
        // component.set("v.showButton", !component.get("v.showButton"));
    },
    
    /* filter values for the single opportunity table */
    prepareFilterForOrders : function(component, event, helper, recId) {
        let updatedFilterField = [];
        let opportunityFilter = {
            "restriction": "EQ",
            "filterValue": {
                "stringValues": [recId],
                "integerValues": [],
                "booleanValues": []
            },
            "fieldName": "id"
        }
        updatedFilterField.push(opportunityFilter);
        component.set("v.filtersOpp.filterFields", updatedFilterField);
    },
    
    /* filter values for the custom item table */
    prepareFiltersForCustomItems : function(component, event, helper, recId) {
        let updatedFilterField = [];
        let customItemFilter = {
            "restriction": "EQ",
            "filterValue": {
                "stringValues": [recId],
                "integerValues": [],
                "booleanValues": []
            },
            "fieldName": "Opportunity__c"
        }
        updatedFilterField.push(customItemFilter);
        
        let customItemGreyOutFilter = {
            "restriction": "NE",
            "filterValue": {
                "stringValues": ['Grey out'],
                "integerValues": [],
                "booleanValues": []
            },
            "fieldName": "Stage__c"
        }
        updatedFilterField.push(customItemGreyOutFilter);
        component.set("v.filtersCustomItem.filterFields", updatedFilterField);
    },
    
    /* filter values for the standard item table */
    prepareFiltersForStandizedItems : function(component, event, helper, recId) {
        let updatedFilterField = [];
        let standardItemFilter = {
            "restriction": "EQ",
            "filterValue": {
                "stringValues": [recId],
                "integerValues": [],
                "booleanValues": []
            },
            "fieldName": "Opportunity__c"
        }
        updatedFilterField.push(standardItemFilter);
        
        let standardItemGreyOutFilter = {
            "restriction": "NE",
            "filterValue": {
                "stringValues": ['Grey out'],
                "integerValues": [],
                "booleanValues": []
            },
            "fieldName": "Stage__c"
        }
        updatedFilterField.push(standardItemGreyOutFilter);
        component.set("v.filtersStandardItem.filterFields", updatedFilterField);
    },
    
    prepareFiltersForDesignRound : function(component, event, helper, recId) {
        let updatedFilterField = [];
        let standardItemFilter = {
            "restriction": "EQ",
            "filterValue": {
                "stringValues": [recId],
                "integerValues": [],
                "booleanValues": []
            },
            "fieldName": "Design_Request__r.Opportunity__c"
        }
        updatedFilterField.push(standardItemFilter);
        
        component.set("v.filtersDesignRound.filterFields", updatedFilterField);
    },
    
    doReOrder: function(component, event, helper) {
       helper.createDoReorderOverlay(component, event, helper);
    	// var navigationUrl = '/customers/s/clone-opportunity?id=';
        // var recordId = component.get("v.selectedOrderRecordId");
        // window.open(navigationUrl + recordId, '_blank');  
        
    },
    
    prepareResults : function(component, event, helper, selectedOrderRecordId) {
        let results = [
            {
                "sectionHeader":"Selected Order",
                "sectionDescription":"",
                "sectionOpen": true,
                "fieldsetName": "My_Orders_Fields",
                "fieldList": [],
                "fieldsToBlock": [],
                "sObjectName": "Opportunity",
                "selectedRecordId": selectedOrderRecordId,
                "recordTypeId": null,
                "readOnly": true,
                "isEmbedded": true,
                "buttonsVisible": false,
                "showToast": false,
                "editmodeAllowed":true,
                "columns": '3'
            }
        ];
        return results;
    },
    
    createDoReorderOverlay : function(component, event, helper) {
        var overlayComponents = [];
        
        //Overlay Header
        overlayComponents.push(
            [
                "aura:html", {
                    "tag": "h2",
                    "body": BASE.baseUtils.getLabel(component,'Reorder'),
                    HTMLAttributes: { "class": "slds-text-heading_medium slds-hyphenate" }
                }
            ]
        );
        
        //Overlay Content/Body
        overlayComponents.push(
            [
                BASE.baseUtils.getPackagePrefix(component)+":ReorderOverlay", {
                    "selectedOrderRecordId": component.get("v.selectedOrderRecordId"),
                    "selectedCustomItems": component.get("v.selectedCustomItems"),
                    "doRefreshParent": component.getReference("v.doRefreshParent"),
                    "closeReorderOverlay": component.getReference("c.handleCancel"),
                    "aura:id":"ReorderOverlayId"
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
        
        //Footer Reorder button
        overlayComponents.push(
            [
                "lightning:button", {
                    "name": "Reorder",
                    "variant":"brand",
                    "label": BASE.baseUtils.getLabel(component,'Process_Reorder'),
                    "onclick": component.getReference("c.doProcessReorder")
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
                    footer: [components[2],components[3]],
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
    
    openESignaturePadPopup: function(component, event, helper) {
        var selectedUnapprovedItems = component.get("v.selectedUnapprovedItems");
        if(selectedUnapprovedItems && selectedUnapprovedItems.length > 0) {
            var overlayComponents = [];
            
            //Overlay Header
            overlayComponents.push(
                [
                    "aura:html", {
                        "tag": "h2",
                        "body": BASE.baseUtils.getLabel(component, 'Approve_Design'),
                        HTMLAttributes: { "class": "slds-text-heading_medium slds-hyphenate" }
                    }
                ]
            );
            
            //Overlay Content/Body
            overlayComponents.push(
                [
                    BASE.baseUtils.getPackagePrefix(component)+":SignaturePad", {
                        "minWidth":"0.5", 
                        "maxWidth":"1.5",
                        "selectedOrderRecordId": component.get("v.selectedOrderRecordId"),
                        "selectedUnapprovedItems": component.get("v.selectedUnapprovedItems"),
                        "doRefreshParent": component.getReference("v.doRefreshParent"),
                        "closeReorderOverlay": component.getReference("c.handleCancel"),
                        "aura:id":"signatureOverlayId"
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
            
            overlayComponents.push(
                [
                    "lightning:button", {
                        "name": "Clear",
                        "variant":"destructive",
                        "label": "Clear",
                        "onclick": component.getReference("c.clearSignature")
                    }
                ]
            );
            
            //Footer Reorder button
            overlayComponents.push(
                [
                    "lightning:button", {
                        "name": "Submit",
                        "variant":"brand",
                        "label": "Submit",
                        "onclick": component.getReference("c.submitDesignForApproval")
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
                        footer: [components[3], components[2], components[4]],
                        showCloseButton: true,
                        cssClass: 'slds-modal_large',
                        closeCallback: function() {}
                    }).then(function (overlay) {
                        component.set("v.overlay",overlay);
                    });
                });
            }
        } else {
            BASE.baseUtils.showToast('No Design Selected', 'Error');
        }
    },
    
    clearSignature: function(component, event, helper) {
        var signatureOverlay = component.find("signatureOverlayId");
        if(signatureOverlay) {
            [].concat(signatureOverlay)[0].clear();
        }
    }
})