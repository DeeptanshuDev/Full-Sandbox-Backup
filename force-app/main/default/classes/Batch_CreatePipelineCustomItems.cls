/**
*  Description     :   Batch Class for creating a pipeline item record when custom item is created 
*
*  Created By      :   
*
*  Created Date    :    
*
*  Current Version :   v1.0
*       
*  Revision Log    :   V_1.0 Created               
**/
global class Batch_CreatePipelineCustomItems implements Database.Batchable<sObject>, Database.Stateful {
    global List<Pipeline_Items__c> newPipelineList = new  List<Pipeline_Items__c>();
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        List<Pipeline_Items__c> newPipeline = [SELECT Id,Parent_Custom_Item__c FROM Pipeline_Items__c WHERE CreatedDate = TODAY AND Parent_Custom_Item__c != null];
        Set<Id> customId = new  Set<Id>();
        for(Pipeline_Items__c pli :newPipeline ){
            customId.add(pli.Parent_Custom_Item__c);
        }
        return Database.getQueryLocator('SELECT Id, Pipeline_Category__c, Opportunity__r.OwnerId FROM Custom_Item__c WHERE CreatedDate = TODAY AND Id NOT IN:customId');
    }
    
    global void execute(Database.BatchableContext BC, List<Custom_Item__c> cusList) {
        // process each batch of records default size is 200
        for(Custom_Item__c cus : cusList) {        
            Pipeline_Items__c newPipe = new Pipeline_Items__c();
            newPipe.Parent_Custom_Item__c = cus.Id;
            newPipe.OwnerId = cus.Opportunity__r.OwnerId;
            newPipe.Pipeline_Category__c = cus.Pipeline_Category__c;
            newPipelineList.add(newPipe);  
        }
    }   
    
    global void finish(Database.BatchableContext BC) {
        // inserting the Pipeline Items
        if(newPipelineList.size() > 0)
            system.debug(newPipelineList);
        insert newPipelineList;
    }
}