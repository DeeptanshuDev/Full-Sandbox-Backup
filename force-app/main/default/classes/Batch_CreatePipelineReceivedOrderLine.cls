/**
*  Description     :   Batch Class for creating a pipeline item record when Received Order Line is created 
*
*  Created By      :   
*
*  Created Date    :    
*
*  Current Version :   v1.0
*       
*  Revision Log    :   V_1.0 Created               
**/
global class Batch_CreatePipelineReceivedOrderLine implements Database.Batchable<sObject>, Database.Stateful {
    global List<Pipeline_Items__c> newPipelineList = new  List<Pipeline_Items__c>();
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        List<Pipeline_Items__c> newPipeline = [SELECT Id,Parent_Received_Order_Line_Item__c FROM Pipeline_Items__c WHERE CreatedDate = TODAY AND Parent_Received_Order_Line_Item__c != null];
        Set<Id> receivedOrderLineId = new  Set<Id>();
        for(Pipeline_Items__c pli :newPipeline ){
            receivedOrderLineId.add(pli.Parent_Received_Order_Line_Item__c);
        }
        system.debug('receivedOrderLineId--'+receivedOrderLineId);
       return Database.getQueryLocator('SELECT Id,Rep_Name__c,Pipeline_Category__c,Product_Extended_Price__c FROM SCMC__Received_Order_Line__c WHERE CreatedDate = TODAY AND Id NOT IN:receivedOrderLineId AND Rep_Name__c !=\'\' ');
        
    }
    
    global void execute(Database.BatchableContext BC, List<SCMC__Received_Order_Line__c> receivedOrderLineList) {
        
        Set<String> userNameSet = new Set<String>();
        Map<String,Id> mapUsers = new Map<String,Id>();
        system.debug('receivedOrderLineList---'+receivedOrderLineList);
        if(receivedOrderLineList.size() > 0){
        	//get users names
            for(SCMC__Received_Order_Line__c receivedOrderLineItem : receivedOrderLineList) {        
                if(receivedOrderLineItem.Rep_Name__c != ''){
                    userNameSet.add(receivedOrderLineItem.Rep_Name__c);
                }
                    
       		}
        	//get users
            for(User uRec : [SELECT Id,Name FROM User WHERE Name IN: userNameSet AND Profile.UserLicense.LicenseDefinitionKey != 'PID_Customer_Community_Login']){
                mapUsers.put(uRec.Name,uRec.id);
            }
            system.debug('mapUsers---'+mapUsers);
            // process each batch of records default size is 200
            for(SCMC__Received_Order_Line__c receivedOrderLineItem : receivedOrderLineList) {    
                if(mapUsers!= null && mapUsers.containsKey(receivedOrderLineItem.Rep_Name__c)){
                	Pipeline_Items__c newPipe = new Pipeline_Items__c();
                    newPipe.Parent_Received_Order_Line_Item__c = receivedOrderLineItem.Id;
                    newPipe.OwnerId = mapUsers.get(receivedOrderLineItem.Rep_Name__c);
                    newPipe.Recevied_Order_Line_Amount__c = receivedOrderLineItem.Product_Extended_Price__c;
                    newPipe.Pipeline_Category__c = receivedOrderLineItem.Pipeline_Category__c;
                    newPipelineList.add(newPipe);      
                }
                
            }
        }
   }   
    
    global void finish(Database.BatchableContext BC) {
        system.debug('newPipelineList----'+newPipelineList);
        // inserting the Pipeline Items
        if(newPipelineList.size() > 0)
            system.debug(newPipelineList);
        insert newPipelineList;
    }
}