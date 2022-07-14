({
    doInit: function(cmp) {
        // Set the attribute value. 
        // You could also fire an event here instead.
        var action = component.get("c.getPromoCode");
        action.setParams({
                recId: component.get('v.recordId'),
            });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                component.set('v.componentString2', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
    },
    handleFilesChange: function(component, event, helper) {
       	var opId=component.get("v.recordId");
        console.log('opp id is : ' + opId);
        var fileName = "No File Selected..";
        var fileCount=component.find("fileId").get("v.files").length;
        var files='';
        if (fileCount > 0) {
            for (var i = 0; i < fileCount; i++) 
            {
                fileName = component.find("fileId").get("v.files")[i]["name"];
                files=files+','+fileName;
            }
        }
        else
        {
            files=fileName;
        }
        component.set("v.fileName", files);
    },
    
    uploadFiles: function(component, event, helper) {
        helper.updateText(component, event, helper);
        /*if(component.find("fileId").get("v.files")==undefined)
        {
            console.log('Select file or files');
            var action = component.get("c.postChatter");
            action.setParams({
                oppId: component.get('v.recordId'),
                fileCount : 0,
            });
            action.setCallback(this, function(a){
                var state = a.getState();
                if(state == 'SUCCESS') {
                    var isUIThemeClassic = component.get("v.isUIThemeClassic");
                    if(isUIThemeClassic) {
                        console.log('hello');
                    } else {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Success',
                            message: 'Email has been send',
                            duration:' 5000',
                            key: 'info_alt',
                            type: 'success',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                    }
                }
            });
            $A.enqueueAction(action);
            window.location.href = '/' + component.get("v.recordId");
            console.log('nicely done without image uploading');
            return;
        }
        /*var filess = component.get("v.files");
        console.log('files re : ' + filess);
        var filelength = component.find("fileId").get("v.files").length;
        console.log('file length is  : ' + filelength);
        alert('total number of files are : ' + filelength);
        if (component.find("fileId").get("v.files").length > 0) {
            var s = component.get("v.FilesUploaded");
            var fileName = "";
            var fileType = "";
            var fileCount=component.find("fileId").get("v.files").length;
            if (fileCount > 0) {
                for (var i = 0; i < fileCount; i++) 
                {
                    helper.uploadHelper(component, event,component.find("fileId").get("v.files")[i]);
                } 
            }
            var isUIThemeClassic = component.get("v.isUIThemeClassic");
            if(isUIThemeClassic) {
                window.location.href = '/' + component.get("v.recordId");
                console.log('nicely done');
            } else {
                $A.get("e.force:closeQuickAction").fire();
            }  
        } else {
            var isUIThemeClassic = component.get("v.isUIThemeClassic");
            if(isUIThemeClassic) {
                alert('Please select a valid file');
            }else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: 'Please select a valid file',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
        }*/
       // helper.sendMail(component, event, helper);
       var lengths = component.get("v.len");
        console.log('total files uploaded are : ' + lengths);
        
        var opId=component.get("v.recordId");
        console.log('Id is : ' +opId);
         
        if(lengths>0)
        {
            
            var action = component.get("c.postChatter");
                action.setParams({
                    oppId: component.get('v.recordId'),
                    fileCount : lengths,
                });
            action.setCallback(this, function(a){
                var state = a.getState();
                if(state == 'SUCCESS') {
                    var isUIThemeClassic = component.get("v.isUIThemeClassic");
                    if(isUIThemeClassic) {
                        console.log('hello');
                    } else {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Success',
                            message: 'Email has been send',
                            duration:' 5000',
                            key: 'info_alt',
                            type: 'success',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                    }
                }
            });
            $A.enqueueAction(action);
        }
        else
        {
            
            var action = component.get("c.postChatter");
                action.setParams({
                    oppId: component.get('v.recordId'),
                    fileCount : 0,
                });
            action.setCallback(this, function(a){
                var state = a.getState();
                if(state == 'SUCCESS') {
                    var isUIThemeClassic = component.get("v.isUIThemeClassic");
                    if(isUIThemeClassic) {
                        console.log('hello');
                    } else {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Success',
                            message: 'Email has been send',
                            duration:' 5000',
                            key: 'info_alt',
                            type: 'success',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                    }
                }
            });
            $A.enqueueAction(action);
        }
        
       window.location.href = '/' + component.get("v.recordId");
       
    },
    cancelButton: function(component, event, helper) 
    {
        var isUIThemeClassic = component.get("v.isUIThemeClassic");
        if(isUIThemeClassic) {
        	window.location.href = '/' + component.get("v.recordId");
        } else {
            $A.get("e.force:closeQuickAction").fire();
        }        
    },
    uploadFinished : function(component, event, helper) {  
        console.log('good to see you');
        var uploadedFiles = event.getParam("files");
        
        component.set("v.len",uploadedFiles.length);  
        console.log('file is uploaded');
        var toastEvent = $A.get("e.force:showToast");
        // show toast on file uploaded successfully 
        toastEvent.setParams({
            "message": "Files have been uploaded successfully!",
            "type": "success",
            "duration" : 2000
        });
        toastEvent.fire();
    }, 
});