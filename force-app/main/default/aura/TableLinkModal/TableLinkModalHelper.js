/* LABEL PRELOAD, DO NOT REMOVE
$Label.c.Document_Preview
*/
({
    openModalDialog: function(component, helper, data) {
        
        if(data.url) {
            // method to parse the parameter from the modal URL
            var getParameterByName = function(name, url) {
                name = name.replace(/[\[\]]/g, "\\$&");
                var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
                    results = regex.exec(url);
                if (!results) return null;
                if (!results[2]) return '';
                return decodeURIComponent(results[2].replace(/\+/g, " "));
            }
            // data required for document modal preview
            var documentModalData = {
                "recordId": getParameterByName("id", data.url),
                "tabLabel": getParameterByName("value", data.url),
                "objectApiName": (BASE.baseUtils.getObjectPrefix(component) + "Opportunity"),
                "headerLabel": BASE.baseUtils.getLabel(component,"Document_Preview"),
                "sObjectName": data.sObjectName
            };
            helper.showDocumentPreviewModal(component, helper, documentModalData);
        }
    },
    showDocumentPreviewModal: function(component, helper, data) {
        //TODO - Will refactor, when needed.
        /*var modalBody;
        $A.createComponent(
            BASE.baseUtils.getPackagePrefix(component)+":DocumentPreview",
            {
                "sObjectName": data.sObjectName,
                "recordId": data.recordId,
                "mode": "Read",
                "componentHeight": "400",
                "tabPosition": "Top",
                "defaultTabLabel": data.tabLabel
            },
            function(content, status) {
                if (status === "SUCCESS") {
                    modalBody = content;
                    // as the component is extensible, getSuper() is required for find method to work
                    component.find("tableLinkModalDialog").showCustomModal({
                        header: data.headerLabel,
                        body: modalBody,
                        showCloseButton: true,
                        cssClass: "slds-modal_medium"
                    })
                }
            }
        );*/
    }
})