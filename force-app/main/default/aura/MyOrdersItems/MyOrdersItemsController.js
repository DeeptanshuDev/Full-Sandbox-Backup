({
	doInit : function(component, event, helper) {
		helper.doInit(component, event, helper);
        helper.prepareFilters(component, event, helper);
        helper.prepareFilters2(component, event, helper);
    },
    
    /* pagination for custom item */
    doPreviousCustomItem: function(component, event, helper) {
        component.find("customItemDataService").doPrevious();
        component.find("customItemTable").focusAction();
    },
    
    doNextCustomItem: function(component, event, helper) {
        component.find("customItemDataService").doNext();
        component.find("customItemTable").focusAction();
    },
    
    /* pagination for standard item */
    doPreviousStandardItem: function(component, event, helper) {
        component.find("standardItemDataService").doPrevious();
        component.find("standardItemTable").focusAction();
    },
    
    doNextStandardItem: function(component, event, helper) {
        component.find("standardItemDataService").doNext();
        component.find("standardItemTable").focusAction();
    },
    
    /* pagination for design */
    doPreviousDesign: function(component, event, helper) {
        component.find("designDataService").doPrevious();
        component.find("designTable").focusAction();
    },
    
    doNextDesign: function(component, event, helper) {
        component.find("designDataService").doNext();
        component.find("designTable").focusAction();
    },
    
    /* pagination for design rounds */
    doPreviousDesignRound: function(component, event, helper) {
        component.find("designRoundDataService").doPrevious();
        component.find("designRoundTable").focusAction();
    },
    
    doNextDesignRound: function(component, event, helper) {
        component.find("designRoundDataService").doNext();
        component.find("designRoundTable").focusAction();
    },
    
    doPreviousUnapprovedDesign: function(component, event, helper) {
        component.find("unapprovedDesignDataService").doPrevious();
        component.find("unapprovedDesignTable").focusAction();
    },
    
    doNextDesign: function(component, event, helper) {
        component.find("unapprovedDesignDataService").doNext();
        component.find("UnapprovedDesignTable").focusAction();
    },
    
    doReOrder: function(component, event, helper) {
    	helper.doReOrder(component, event, helper);
    },
    
    handleCancel: function(component, event, helper) {
        helper.closeModal(component, event, helper);
    },
    
    doProcessReorder: function(component, event, helper) {
        var reorderOverlay = component.find("ReorderOverlayId");
        if(reorderOverlay) {
            [].concat(reorderOverlay)[0].processReorder();
        }
    },
    
    openESignaturePadPopup: function(component, event, helper) {
        helper.openESignaturePadPopup(component, event, helper);
    },
    
    submitDesignForApproval: function(component, event, helper) {
        var signatureOverlay = component.find("signatureOverlayId");
        if(signatureOverlay) {
            [].concat(signatureOverlay)[0].capture();
        }
    },
    
    clearSignature: function(component, event, helper) {
        helper.clearSignature(component, event, helper);
    }
})