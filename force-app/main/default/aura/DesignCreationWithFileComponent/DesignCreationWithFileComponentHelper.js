({
    doInit : function(component, event) {
        component.set('v.showLoadingSpinner',true);
        var allFiles = component.get('v.allFiles');
        var alreadyAvailableDetailsOfDesign = component.get('v.alreadyAvailableDetailsOfDesign');
        console.log("allFiles:", allFiles);
        console.log("alreadyAvailableDetailsOfDesign:", alreadyAvailableDetailsOfDesign);
        var action = component.get("c.getFieldSet");
        console.log("designObjApiName" +component.get("v.designObjApiName"));
        console.log("fieldSetForDesignObj" +component.get("v.fieldSetForDesignObj"));
        action.setParams({
            designObjApiName: component.get("v.designObjApiName"),
            fieldSetForDesignObj: component.get("v.fieldSetForDesignObj")
        });
        action.setCallback(this, function(response) {
            var coulmnsForDesign = JSON.parse(response.getReturnValue());
            component.set("v.coulmnsForDesign", coulmnsForDesign);
            console.log("coulmnsForDesign:", coulmnsForDesign);
            var allDetailsOfDesign= [];
            console.log("allFiles" +allFiles);
            for(var i = 0; i< allFiles.length; i++){
                var design = [];
                var items ={
                    'seQ':i+1,
                    'key':'DocumentId',
                    'value': allFiles[i].documentId
                };
                design.push(items);
                items ={
                    'seQ':i+1,
                    'key':'DocumentName',
                    'value': allFiles[i].name
                };
                design.push(items);
                for(var j = 0; j< coulmnsForDesign.length;j++){
                    /*if(coulmnsForDesign[j].name == 'Needs_Pricing__c'){
                        items ={
                            'seQ':i+1,
                            'key':coulmnsForDesign[j].name,
                            'value': 'true'
                        };
                    }
                    else{
                        items ={
                            'seQ':i+1,
                            'key':coulmnsForDesign[j].name,
                            'value': ''
                        };
                    }*/
                    var dataName = alreadyAvailableDetailsOfDesign[i];
                    console.log("dataName:", dataName);
                    items ={
                        'seQ':i+1,
                        'key':coulmnsForDesign[j].name,
                        'value': dataName[coulmnsForDesign[j].name]
                    };
                    design.push(items);
                } 
                allDetailsOfDesign.push(design); 
            }
            component.set("v.allDetailsOfDesign",allDetailsOfDesign);
            console.log("allDetailsOfDesign2:", component.get('v.allDetailsOfDesign'));
        })
        $A.enqueueAction(action);
        
        var selectedCustomItems = component.get("v.selectedCustomItems");
        if(selectedCustomItems.length > 0)
            component.set('v.buttonDisabled',false);
        else
            component.set('v.buttonDisabled',true);  
        component.set('v.showLoadingSpinner',false);
    },
    handleUploadFinished : function(component, event) {
        var uploadedFiles = event.getParam("files");
        var documentId = uploadedFiles[0].documentId;
        var fileName = uploadedFiles[0].name;
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "File "+fileName+" Uploaded successfully."
        });
        toastEvent.fire();
        component.set("v.documentId",documentId); 
        console.log("documentId:", documentId);
    },
    handleSave : function(component, event){
        
        component.set('v.showLoadingSpinner',true);
        var requiredTypeError = [];
        var requiredAttributesError = false;
        
        var allDetailsOfDesign = component.get("v.allDetailsOfDesign");
        var allDetailsOfDesignRound = component.get("v.allDetailsOfDesignRound");
        console.log("allDetailsOfDesignRound:", allDetailsOfDesignRound);
      
        if(allDetailsOfDesignRound.length == 0){
            requiredTypeError.push('Please fill version and Gender as it is required.');
            requiredAttributesError = true;   
        }
        else if(allDetailsOfDesignRound.length > 0){
            for(var m=0; m< allDetailsOfDesignRound.length; m++){
                for(var n=0; n< allDetailsOfDesignRound[m].length; n++){
                    if(allDetailsOfDesignRound[m][n].key == 'Version__c' && allDetailsOfDesignRound[m][n].value.trim() == ''){
                        requiredTypeError.push('Please fill version and Gender as it is required.');
                        requiredAttributesError = true;  
                        break;
                    }
                    else if(allDetailsOfDesignRound[m][n].key == 'Gender__c' && allDetailsOfDesignRound[m][n].value.trim() == ''){
                        requiredTypeError.push('Please fill version and Gender as it is required.');
                        requiredAttributesError = true;    
                        break;
                    }
                }
            }
        }
        
        var relatedRequiredAttributes = false;
        for(var i=0; i< allDetailsOfDesign.length; i++){
            for(var j=0; j< allDetailsOfDesign[i].length; j++){
                if(allDetailsOfDesign[i][j].key == 'Option_Number__c' && allDetailsOfDesign[i][j].value == ''){
                    requiredTypeError.push('Record No '+(i+1)+' ) Please fill the option no.');
                    relatedRequiredAttributes = true;
                    break;
                }
                if(allDetailsOfDesign[i][j].key == 'Option_Number__c' && allDetailsOfDesign[i][j].value < 1){
                    requiredTypeError.push('Record No '+(i+1)+' ) Option no should be between 1 to 6. Zero and negative number are not allowed.');
                    relatedRequiredAttributes = true;
                    break;
                }
                if(allDetailsOfDesign[i][j].key == 'Option_Number__c' && allDetailsOfDesign[i][j].value > 6){
                    requiredTypeError.push('Record No '+(i+1)+' ) Option no should be between 1 to 6. Option no should not be greater than 6.');
                    relatedRequiredAttributes = true;
                    break;
                }
            }
        }
        
        if(!requiredAttributesError && !relatedRequiredAttributes){
            var selectedCustomItems = component.get("v.selectedCustomItems");
            
            var selectedCustomItemsIds = [];
            for ( var i = 0; i < selectedCustomItems.length; i++ ) {
                selectedCustomItemsIds.push(selectedCustomItems[i].id);
            }
            
            component.set('v.disableButton',true);
            console.log('you are above calling recordssave method');
            var action = component.get("c.recordsSave");
            
            action.setParams({
                'recordId': component.get('v.recordId'),
                'sObjectName': component.get("v.sObjectName"),
                'objectForDataToBeCreated': 'Design_Round__c',
                'allDetailsOfDesignRound' : component.get("v.allDetailsOfDesignRound"),
                'designObjApiName': component.get("v.designObjApiName"),
                'allDetailsOfDesign': component.get("v.allDetailsOfDesign"),
                'selectedCustomItemsIds': selectedCustomItemsIds
            });
            action.setCallback(this, function(response) {
                var sObjectRecordsWithErrors = response.getReturnValue();
                console.log('sObjectRecordsWithErrors are : ' + sObjectRecordsWithErrors);
                if(sObjectRecordsWithErrors.length > 0){
                    console.log('sObjectRecordsWithErrors.length : ' + sObjectRecordsWithErrors.length);
                    var allErrors = [];
                    for(var i=0; i<sObjectRecordsWithErrors.length; i++){
                        console.log('in test');
                        var recSeq = sObjectRecordsWithErrors[i].recSeq;
                        console.log('recSeq'+recSeq);
                        var error = sObjectRecordsWithErrors[i].error;
                        console.log('error'+error);
                        if(!error || error == undefined || error == "" || error.length == 0){
                            
                        }
                        else{
                            allErrors.push('Record No '+recSeq+' ) '+error);
                        }
                    }
                    console.log('allErrors'+allErrors);
                    if(!allErrors || allErrors == undefined || allErrors == "" || allErrors.length == 0){
                        
                        component.set('v.showLoadingSpinner',false);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : "Success!",
                            message: "The record has been insert successfully.",
                            duration:' 5000',
                            key: 'info_alt',
                            type: 'success',
                            mode: 'dismissible'
                        });
                        toastEvent.fire();
                        var dismissActionPanel = $A.get("e.force:closeQuickAction");
                        dismissActionPanel.fire();
                        $A.get('e.force:refreshView').fire();
                    }
                    else{
                        console.log('thre is in else');
                        component.set('v.showLoadingSpinner',false);
                        component.set('v.infoMessage',allErrors);
                        var cmpEvent = component.getEvent("passAllErrorOnMainComponent");
                        // Get the value from Component and set in Event
                        cmpEvent.setParams( { "allError" : allErrors } );
                        cmpEvent.fire();
                    }
                }
                else{
                    console.log('You are in else section');
                    component.set('v.showLoadingSpinner',false);
                }
            })
            $A.enqueueAction(action);
        }
        else{
            component.set('v.showLoadingSpinner',false);
            component.set('v.infoMessage',requiredTypeError);
            var cmpEvent = component.getEvent("passAllErrorOnMainComponent");
            // Get the value from Component and set in Event
            cmpEvent.setParams( { "allError" : requiredTypeError } );
            cmpEvent.fire();
        }
    },
    handleDelete : function(component, event){
        var seqNo = event.getSource().get("v.name");
        var allDetailsOfDesign = component.get("v.allDetailsOfDesign");
        var alreadyAvailableDetailsOfDesign = component.get('v.alreadyAvailableDetailsOfDesign');
        var requiredAttributesError = false;
        
        for(var i=0; i< allDetailsOfDesign.length; i++){
            if(i+1 == seqNo){
                 allDetailsOfDesign.splice(i,1);
            }
        }
        
        for(var i=0; i< alreadyAvailableDetailsOfDesign.length; i++){
            if(i+1 == seqNo){
                 alreadyAvailableDetailsOfDesign.splice(i,1);
            }
        }
       
        for(var i=0; i< allDetailsOfDesign.length; i++){
            for(var j=0; j< allDetailsOfDesign[i].length; j++){    
                allDetailsOfDesign[i][j].seQ = i+1;
            }
        }
        
        component.set("v.allDetailsOfDesign",allDetailsOfDesign);
       
        if(allDetailsOfDesign.length == 0)
        	component.set("v.isFileAvailable",false);
        
        var cmpEvent = component.getEvent("passDesignAttributes");
        // Get the value from Component and set in Event
        cmpEvent.setParams( { "allDetailsOfDesign" : allDetailsOfDesign } );
        cmpEvent.fire();
    },
    
    changeDetailsOfDesign : function(component, event){
        var Name = event.getSource().get("v.name");
        console.log("name:", Name);
        var NameArray = Name.split(";");
        var Id = NameArray[0];
        var changeValueOfField = NameArray[1];
        console.log("Id:", Id);
        console.log("changeValueOfField:", changeValueOfField);
        if(changeValueOfField == "Needs_Pricing__c") {
            var value = event.getSource().get("v.checked");
        } else {
            var value = event.getSource().get("v.value");
        }
        var alreadyAvailableDetailsOfDesign = component.get('v.alreadyAvailableDetailsOfDesign');
        console.log("value:", value);
        for(var key in alreadyAvailableDetailsOfDesign) {
            if(alreadyAvailableDetailsOfDesign[key].DocumentId == Id) {
                alreadyAvailableDetailsOfDesign[key][changeValueOfField] = value;
            }
        }
        component.set('v.alreadyAvailableDetailsOfDesign', alreadyAvailableDetailsOfDesign);
        console.log("alreadyAvailableDetailsOfDesign:", alreadyAvailableDetailsOfDesign);
    }
})