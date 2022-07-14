({
    handleFilesChange: function(component, event, helper) {
        var oppId = component.get("v.recordId");
        var fileName = "No File Selected..";
        var fileCount = component.find("fileId").get("v.files").length;
        var files = '';
        if (fileCount > 0) {
            fileName = component.find("fileId").get("v.files")[0]["name"];
            files = fileName;
        } else {
            files = fileName;
        }
        component.set("v.fileName", files);
    },
    
    uploadFiles: function(component, event, helper) {
        if (component.find("fileId").get("v.files") != undefined && component.find("fileId").get("v.files").length > 0) {
            var s = component.get("v.FilesUploaded");
            var fileName = "";
            var fileType = "";
            var fileCount = component.find("fileId").get("v.files").length;
            if (fileCount > 0) {
                helper.uploadHelper(component, event, helper, component.find("fileId").get("v.files")[0]).then(
                    $A.getCallback(function(result) {
                        
                        var isUIThemeClassic = component.get("v.isUIThemeClassic");
                        if(isUIThemeClassic) {
                            console.log('you are here123');                            
                            window.location.href = '/' + component.get("v.recordId");
                            console.log('you are here1423');
                        } else {
                            $A.get("e.force:closeQuickAction").fire();
                        }
                    }),
                    // reject handler
                    $A.getCallback(function(error) {
                        alert(error);
                        console.log("Promise was rejected: ", error);
                    })
                );
            }
              
        } else {
            var isUIThemeClassic = component.get("v.isUIThemeClassic");
            if(isUIThemeClassic) {
                alert('No files selected. Please select csv file');
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: 'No files selected. Please select csv file',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
        }
        
    },
    
    cancelButton: function(component, event, helper) 
    {
        var isUIThemeClassic = component.get("v.isUIThemeClassic");
        if(isUIThemeClassic) {
            window.location.href = '/' + component.get("v.recordId");
        } else {
            $A.get("e.force:closeQuickAction").fire();
        }        
    }
});