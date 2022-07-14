global class Batch_InsertPublicLinksForDesigns implements Database.Batchable<sObject> {
    
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
                Map<Id, ContentDistribution> mapConVersionIdKeyWithCD = new Map<Id, ContentDistribution>();
                Set<Id> setOfDesignIdWithCDExists = new Set<Id>();
                for(ContentDistribution cD : [SELECT Id, ContentVersionId, DistributionPublicUrl 
                                              FROM ContentDistribution 
                                              WHERE ContentVersionId IN : mapOfEligibleDesigns.keySet()]) {
                                                  mapConVersionIdKeyWithCD.put(cD.ContentVersionId, cD);
                                                  if(mapOfEligibleDesigns.containsKey(cD.ContentVersionId)) {
                                                      setOfDesignIdWithCDExists.add(mapOfEligibleDesigns.get(cD.ContentVersionId).Id);  
                                                  }                               
                                              }
                Map<Id, Design__C> mapOfDesignsCDDoesntExists = new Map<Id, Design__c>();
                for(Design__c dsn : designs) {
                    if(dsn.Content_Version_Id__c != null && !setOfDesignIdWithCDExists.contains(dsn.Content_Version_Id__c)) {
                        mapOfDesignsCDDoesntExists.put(dsn.Id, dsn);    
                    }    
                }
                if(mapOfDesignsCDDoesntExists.values().size() > 0) {
                    List<ContentDistribution> listOfContentDistributiontoBeInserted = new List<ContentDistribution>();
                    for(Design__c design : mapOfDesignsCDDoesntExists.values()) {
                        ContentDistribution cd = new ContentDistribution();
                        cd.Name = 'PublicLink' + String.valueof(Math.random());
                        cd.ContentVersionId = design.Content_Version_Id__c;
                        cd.PreferencesAllowViewInBrowser= true;
                        cd.PreferencesLinkLatestVersion=true;
                        cd.PreferencesNotifyOnVisit=false;
                        cd.PreferencesPasswordRequired=false;
                        cd.PreferencesAllowOriginalDownload= true;
                        listOfContentDistributiontoBeInserted.add(cd);
                    }
                    if(listOfContentDistributiontoBeInserted.size() > 0) {
                        Database.insert(listOfContentDistributiontoBeInserted, false);
                    }    
                }
            }
        }        
    } 
    global void finish(Database.BatchableContext BC) 
    {
        // Find all scheduled jobs with no Next Fire date and un-schedule them... 
        // Why keep them if they've already fired!?
        for (CronTrigger job : [SELECT Id, NextFireTime FROM CronTrigger 
                                WHERE NextFireTime = null 
                                LIMIT : Limits.getLimitDMLStatements()]) 
        {
            try 
            {
                system.abortJob(job.Id);
            } catch(Exception ex) 
            {
                if(ex.getMessage().contains('Invalid parameter value'))
                    continue;
                else if(ex.getMessage().contains('Job does not exist or is already aborted'))
                    continue;
                else
                    throw new CustomException(ex.getMessage());
            }  
        }
        
        //Schedule the next job, and give it the system time so name is unique
        if(!Test.isRunningTest()) {
            Batch_UpdateDesignsWithPublicLinks bU = new Batch_UpdateDesignsWithPublicLinks();
            System.scheduleBatch(bU, ('Update Public Links ' + String.valueOf(Math.random())), 1);
        }
    }
}