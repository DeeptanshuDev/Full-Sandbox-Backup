({
    getDesignBoundAttributes : function(component, event) 
    {
        var designRoundComponent = component.find('UpdateDetailPageRecordCmpId');
        var version = designRoundComponent.get('v.selectedVersion');
        var gender = designRoundComponent.get('v.selectedGender');
        var reasonForRevision = designRoundComponent.get('v.selectedReasonForRevision');
        var designRoundToBeCreated = [];
        var allDetailsOfDesignRound = [];
        
        var versionDetail = {
            'key': 'Version__c',
            'value': version
        };
        designRoundToBeCreated.push(versionDetail);
        
        var genderDetail = {
            'key': 'Gender__c',
            'value': gender
        };
        designRoundToBeCreated.push(genderDetail);
        
        var reasonForRevisionDetail = {
            'key': 'Reason_for_Revision__c',
            'value': reasonForRevision
        };
        designRoundToBeCreated.push(reasonForRevisionDetail);
        
        allDetailsOfDesignRound.push(designRoundToBeCreated);
        component.set('v.allDetailsOfDesignRound',allDetailsOfDesignRound);
    },
    
    handleCloseModal: function(component, event) 
    {
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    
    handleCancel : function(component, event)
    {
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
        $A.get('e.force:refreshView').fire(); 
    },
    
    handlePassAllErrorOnMainComponent : function(component, event)
    {
        var allError = event.getParam("allError");
        component.set('v.infoMessage',allError);
    }
})