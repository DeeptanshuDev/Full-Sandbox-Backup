global class Batch_UpdateDesignsWithPublicLinks implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT ID, Content_Version_Id__c FROM Design__c WHERE Content_Version_Id__c != null AND Content_Public_Link_Value__c = null AND Content_Version_Deleted__c = false AND CreatedDate > '+Datetime.now().addMinutes(-30).formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''));
    }
    
    global void execute(Database.BatchableContext BC, List<Design__c> designs) {
        if(designs.size()>0)
        {    
            Map<Id, Design__c> mapOfEligibleDesigns = new Map<Id, Design__c>();
            for(Design__c design : designs) {
                if(String.isNotBlank(design.Content_Version_Id__c)) {
                    mapOfEligibleDesigns.put(design.Content_Version_Id__c, design);
                }           
            }
            if(mapOfEligibleDesigns.values().size() > 0) {
                Map<Id, String> mapOfContentVersionIdWithPublicLink = new Map<Id, String>();
                for(ContentDistribution cD : [SELECT Id, ContentVersionId, DistributionPublicUrl 
                                              FROM ContentDistribution 
                                              WHERE ContentVersionId IN : mapOfEligibleDesigns.keySet()]) {
                                                  if(mapOfEligibleDesigns.containsKey(cD.ContentVersionId)) {
                                                      if(String.isNotBlank(cD.DistributionPublicUrl) 
                                                         && cD.DistributionPublicUrl.contains('/a/')
                                                         && cD.DistributionPublicUrl.split('/a/').size() > 0
                                                        ) {
                                                            String publicLink = '';
                                                            publicLink += '&versionId=' + String.valueOf(cD.ContentVersionId);
                                                            publicLink += '&operationContext=DELIVERY&page=0&d=/a/';
                                                            publicLink += cD.DistributionPublicUrl.split('/a/')[1];
                                                            publicLink += '&oid=';
                                                            publicLink += String.valueOf(UserInfo.getOrganizationId());
                                                            publicLink += '&dpt=null';
                                                            mapOfContentVersionIdWithPublicLink.put(cD.ContentVersionId, publicLink);
                                                        }
                                                  }                               
                                              }
                if(mapOfContentVersionIdWithPublicLink.values().size() > 0) {
                    Map<Id, Design__c> mapOfDesignsToBeUpdated = new Map<Id, Design__c>();
                    for(Design__c dsn : designs) {
                        if(dsn.Content_Version_Id__c != null && mapOfContentVersionIdWithPublicLink.containsKey(dsn.Content_Version_Id__c)) {
                            dsn.Content_Public_Link_Value__c = mapOfContentVersionIdWithPublicLink.get(dsn.Content_Version_Id__c);
                            mapOfDesignsToBeUpdated.put(dsn.Id, dsn);    
                        }    
                    }
                    if(mapOfDesignsToBeUpdated.size() > 0) {
                        Database.update(mapOfDesignsToBeUpdated.values(), false);
                    }
                }
            }
        }        
    }  
    global void finish(Database.BatchableContext BC) {}
}