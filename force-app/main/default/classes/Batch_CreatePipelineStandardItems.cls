/**
*  Description     :   Batch Class for creating a pipeline item record when Standard item is created 
*
*  Created By      :   
*
*  Created Date    :    
*
*  Current Version :   v1.0
*       
*  Revision Log    :   V_1.0 Created               
**/
global class Batch_CreatePipelineStandardItems implements Database.Batchable<sObject>, Database.Stateful {
    global List<Pipeline_Items__c> newPipelineList = new  List<Pipeline_Items__c>();
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        List<Pipeline_Items__c> newPipeline = [SELECT Id,Parent_Standardized_Item__c FROM Pipeline_Items__c WHERE CreatedDate = TODAY AND Parent_Standardized_Item__c != null];
        Set<Id> standardId = new  Set<Id>();
        for(Pipeline_Items__c pli :newPipeline ){
            standardId.add(pli.Parent_Standardized_Item__c);
        }
       return Database.getQueryLocator('SELECT Id,Pipeline_Category__c,Opportunity__r.OwnerId FROM Standardized_Item__c WHERE CreatedDate = TODAY AND Id NOT IN:standardId');
    }
    
    global void execute(Database.BatchableContext BC, List<Standardized_Item__c> standardList) {
        
        // process each batch of records default size is 200
        for(Standardized_Item__c standardItem : standardList) {        
            Pipeline_Items__c newPipe = new Pipeline_Items__c();
            newPipe.Parent_Standardized_Item__c = standardItem.Id;
            newPipe.OwnerId = standardItem.Opportunity__r.OwnerId;
            newPipe.Pipeline_Category__c = standardItem.Pipeline_Category__c;
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