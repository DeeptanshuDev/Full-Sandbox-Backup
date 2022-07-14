global class Batch_UpdateCustomItem implements Database.Batchable<SObject>, Database.Stateful 
{
    global String query ='';
    global String debugLog ='';
    global List<Custom_Item__c> custToBeUpdated = new List<Custom_Item__c>();
        
        
    global Batch_UpdateCustomItem(String queryString)
    {
       
            if(String.isNotBlank(queryString)) 
            {
                query = queryString;   
            }   
        }
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {   
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Sobject> recordToBeUpdated)
    {
      for(Sobject cs : recordToBeUpdated){
            Custom_Item__c cust = new Custom_Item__c();
            cust.Id = cs.Id;
            cust.FF_Style__c = String.valueOf(cs.get('Style__c'));
            custToBeUpdated.add(cust);
        }
        system.debug('custToBeUpdated '+custToBeUpdated);
         if(custToBeUpdated.size() > 0){
            update custToBeUpdated;
        }
    }   
    global void finish(Database.BatchableContext bc)
    { 
       
    }
}