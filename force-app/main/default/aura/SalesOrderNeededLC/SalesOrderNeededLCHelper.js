({
	MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000, //Chunk Max size 750Kb 

    uploadHelper: function(component, event,f) {
       	component.set("v.showLoadingSpinner", true);
       	var file = f;
        var self = this;
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function  
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.showLoadingSpinner", false);
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            return;
        }

        // Convert file content in Base64
        var objFileReader = new FileReader();
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            fileContents = fileContents.substring(dataStart);
            self.uploadProcess(component, file, fileContents);
        });

        objFileReader.readAsDataURL(file);
    },

    uploadProcess: function(component, file, fileContents) {
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);

        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '');
    },


    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId) {
        // call the apex method 'saveFile'
        var getchunk = fileContents.substring(startPosition, endPosition);
        /*var action = component.get("c.saveFile");
        action.setParams({
            // Take current object's opened record. You can set dynamic values here as well
            parentId: component.get("v.recordId"), 
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId
        });*/
        console.log('apex method is being calleddddddd0');
        var action = component.get("c.uploadFile");
        action.setParams({
            // Take current object's opened record. You can set dynamic values here as well
            recordId: component.get("v.recordId"), 
            filename: file.name,
            base64: encodeURIComponent(getchunk),
        });

        // set call back 
        action.setCallback(this, function(response) {
            attachId = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                // update the start position with end postion
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId);
                } else {
                    var isUIThemeClassic = component.get("v.isUIThemeClassic");
                	if(isUIThemeClassic) {
                        alert('Your File is uploaded successfully');
                    } else {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Success',
                            message: 'Your File is uploaded successfully',
                            duration:' 5000',
                            key: 'info_alt',
                            type: 'success',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                    }
                    component.set("v.showLoadingSpinner", false);
                }
                // handel the response errors        
            } else if (state === "INCOMPLETE") {
                var err = response.getReturnValue();
                alert(err);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    /*showMessage : function(message,isSuccess) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": isSuccess?"Success!":"Error!",
            "type":isSuccess?"success":"error",
            "message": message
        });
        toastEvent.fire();
    },*/
    updateText: function(component, event, helper)
    {
        
        var opId = component.get("v.recordId");
        console.log('record id is : ' + opId);
        var textValue = component.get("v.componentString2");
        console.log('text value is : ' + textValue);
        
        var action = component.get("c.updateDescription");
        action.setParams({
            // Take current object's opened record. You can set dynamic values here as well
            recId: component.get("v.recordId"), 
            texts: component.get("v.componentString"),
            text2: component.get("v.componentString2")
        });
        console.log('apex method is called');
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                
            }else{
                
            }
        });
        $A.enqueueAction(action);
        
    },
    
    sendMail: function(component, event, helper) {
        var action = component.get("c.sendMailMethod");
        action.setParams({
            oppId: component.get('v.recordId'),
        });
        action.setCallback(this, function(a){
            var state = a.getState();
            if(state == 'SUCCESS') {
                var isUIThemeClassic = component.get("v.isUIThemeClassic");
                if(isUIThemeClassic) {
                    alert('Email has been send');
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
    },

    chatter: function(component, event, helper) {
        alert('you are inside chatter');
        var fileCount=component.find("fileId").get("v.files").length;
        if(fileCount>=1){
            console.log('file count is : ' + fileCount);
        var action = component.get("c.postChatter");
        action.setParams({
            oppId: component.get('v.recordId'),
            fileCount : fileCount,
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
    }
    
})