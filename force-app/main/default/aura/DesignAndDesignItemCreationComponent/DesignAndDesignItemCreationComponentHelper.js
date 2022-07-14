({
    doInit : function(component, event){
                   
        var fileDragAndDropHint = ['You can drag and drop upto 10 files at a time.','File upload is supported for all file types but image preview cannot be shown for some file types like mp3, mp4 files.','Previously entered data will not be retained on uploading new images.'] ;            
        component.set('v.infoMessage',fileDragAndDropHint);
       
        var columns = [
            { label: 'Item', fieldName: 'itemNumber' },
            { label: 'Gender', fieldName: 'gender'},
            { label: 'Name', fieldName: 'name'},
            { label: 'Type', fieldName: 'type'}
        ];
        component.set('v.customItemColumns', columns);
        
        var action = component.get("c.getCustomStandardizedItemsWrapper");
        action.setParams({
            "designRequestId": component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            var customItems = response.getReturnValue();
            component.set('v.customItems',customItems);
        })
        $A.enqueueAction(action);
    },
    handleUploadFinished : function(component, event) {
        component.set("v.isFileAvailable",false);
        
        var uploadedFiles = event.getParam("files");
        var allFiles=[];
        var allDetailsOfDesign=[];
        var documentNames = [];
        var documentIds = [];
        var fileNames = '';
        
        for(var i = 0; i < uploadedFiles.length; i++) {
            allDetailsOfDesign.push({"DocumentId": uploadedFiles[i].documentId,
                                     "DocumentName": uploadedFiles[i].name,
                                     "Option_Number__c": "",
                                     "Needs_Pricing__c": true,
                                     "Notes__c": "" });
        }
        allDetailsOfDesign = allDetailsOfDesign.concat(component.get('v.alreadyAvailableDetailsOfDesign'));
        component.set('v.alreadyAvailableDetailsOfDesign',allDetailsOfDesign); 
      
        var allUploadedFiles = uploadedFiles.concat(component.get('v.alreadyUploadedFiles'));
        component.set('v.alreadyUploadedFiles',allUploadedFiles); 
        console.log("allUploadedFiles:", allUploadedFiles);
       
        for(var i = 0; i < allUploadedFiles.length; i++) {
            allFiles.push(allUploadedFiles[i]);
            documentIds.push(allUploadedFiles[i].documentId);
            documentNames.push(allUploadedFiles[i].name);
            
            var a,b;
            a =(i+1) % 3;
            b = 0;
            
            if(a == b)
                fileNames += allUploadedFiles[i].name + ', \n';
            else
                fileNames += allUploadedFiles[i].name + ', ';
        }
        
        fileNames = fileNames.substring(0, fileNames.length - 2);
        fileNames +=' Files uploaded Successfully!!!';
        
        var infoMessage =[];
        infoMessage.push(fileNames);
        component.set('v.infoMessage',infoMessage);
        component.set("v.allFiles",allFiles);
        component.set("v.allDetailsOfDesign",allDetailsOfDesign);
        component.set("v.documentIds",documentIds);
        component.set("v.isFileAvailable",true);
        
        var action = component.get("c.cleanUp");
        action.setParams({
            "designRequestId": component.get('v.recordId'),
            'documentIds': documentIds
            
        });
        action.setCallback(this, function(response) {
            var objRecords = response.getReturnValue();
        })
        $A.enqueueAction(action);   
    },
    onCustomItemSelection : function(component,event){
        var selectedCustomItems = event.getParam('selectedRows');
        component.set('v.selectedCustomItems',selectedCustomItems); 
    },
    handlePassDesignAttributes : function(component,event,helper){
        var allDetailsOfDesign = event.getParam("allDetailsOfDesign");
        var allFiles = component.get("v.allFiles");
        var documentIds = component.get("v.documentIds");
        
        var updatedFiles = [];
        var updatedDocumentIds = [];
        var fileNames = '';
        console.log('allFiles--'+JSON.stringify(allFiles));
        console.log('allDetailsOfDesign--'+JSON.stringify(allDetailsOfDesign));
        for(var k=0; k< allFiles.length; k++){
            for(var i=0; i< allDetailsOfDesign.length; i++){
                for(var j=0; j< allDetailsOfDesign[i].length; j++){
                    if(allDetailsOfDesign[i][j].key == 'DocumentId' && allDetailsOfDesign[i][j].value == allFiles[k].documentId){
                        updatedFiles.push(allFiles[k]);
                        updatedDocumentIds.push(allFiles[k].DocumentId);
                        
                    }
                    if(allDetailsOfDesign[i][j].key == 'DocumentName' && allDetailsOfDesign[i][j].value == allFiles[k].name){
                        var a,b;
                        a =(i+1) % 3;
                        b = 0;
                        
                        if(a == b)
                            fileNames += allFiles[k].name + ', \n';
                        else
                            fileNames += allFiles[k].name + ', ';
                    }
                }
            }
        }
        console.log('files name '+fileNames);
        fileNames = fileNames.substring(0, fileNames.length - 2);
        if(fileNames.length > 0)
        {
            fileNames +=' Files uploaded Successfully!!!';
            
            var infoMessage =[];
            infoMessage.push(fileNames);
            component.set('v.infoMessage',infoMessage);
        }
        else
        {
             component.set('v.infoMessage',[]);
        }
       
        console.log('updatedFiles--'+JSON.stringify(updatedFiles));
      
        component.set('v.alreadyUploadedFiles',updatedFiles); 
     
    }
})