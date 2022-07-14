global class Batch_ListOutDesignsWithDeletedFiles implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT ID, Content_Version_Id__c, Content_Version_Deleted__c FROM Design__c WHERE Content_Version_Id__c != null AND Content_Public_Link_Value__c = null');
    }
    
    global void execute(Database.BatchableContext BC, List<Design__c> designs) {
        Map<Id, Design__c> mapOfEligibleDesigns = new Map<Id, Design__c>();
        for(Design__c design : designs) {
            if(String.isNotBlank(design.Content_Version_Id__c)) {
                mapOfEligibleDesigns.put(design.Content_Version_Id__c, design);
            }           
        }
        if(mapOfEligibleDesigns.values().size() > 0) {
            Map<Id, Id> mapContentVersionIdWithContentDocumentId = new Map<Id, Id>();
            for(ContentVersion cV : [SELECT ID, ContentDocumentID 
                                     FROM ContentVersion 
                                     WHERE ID IN : mapOfEligibleDesigns.keySet()]) {
            	mapContentVersionIdWithContentDocumentId.put(cV.Id, cV.ContentDocumentID);	
            }
            List<Design__c> designsToBeUpdated = new List<Design__c>();
            for(Design__c design : designs) {
            	if(mapContentVersionIdWithContentDocumentId.containsKey(design.Content_Version_Id__c)
                	&& mapContentVersionIdWithContentDocumentId.get(design.Content_Version_Id__c) != null) {
                } else {
                	design.Content_Version_Deleted__c = true;
                    designsToBeUpdated.add(design);
                } 
            }
            if(designsToBeUpdated.size() > 0) {
                update designsToBeUpdated;
            }
        }
    }        
     
    global void finish(Database.BatchableContext BC) {}
}