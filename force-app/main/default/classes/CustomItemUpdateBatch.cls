global class CustomItemUpdateBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
         
        String query = 'SELECT Id,Name,LastModifiedDate,Lining__c, Price_Expiration_Completed__c, Custom_Item_Reorder__c, Pricing_Expiration_Date__c FROM Custom_Item__c WHERE Custom_Item_Reorder__c= NULL AND Pricing_Expiration_Date__c <= TODAY';
        //String query = 'SELECT Id, Name, Stated_Quantity__c FROM Custom_Item__c';
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<Custom_Item__c> listOfCustomItem) {
        
        // process each batch of records default size is 200
        for(Custom_Item__c acc : listOfCustomItem) {        
            // Update the Account Name 
            System.debug('custom item are : ' + acc.LastModifiedDate);
            acc.Name = acc.Name;
            acc.Grey_Out_Reason__c	 = 'Silent';
            //acc.Stated_Quantity__c	= 2;
            System.debug('the custom item is : ' + acc);
        }
        try {
            // Update the Account Record
            update listOfCustomItem;
         
        } catch(Exception e) {
            System.debug(e);
        }
         
    }   
     
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
        System.debug('done with the batch');
        List<Custom_Item__c> obj = [SELECT Id,Name,LastModifiedDate,Lining__c, Price_Expiration_Completed__c, Custom_Item_Reorder__c, Pricing_Expiration_Date__c FROM Custom_Item__c WHERE Custom_Item_Reorder__c= NULL AND Pricing_Expiration_Date__c <= TODAY];
        for(Custom_Item__c temp : obj)
        {
            System.debug('custom item for checking lastmodified dte are : ' +temp);
            System.debug('custom item for checking lastmodified dte are : ' +temp.Lining__c);
            System.debug('custom item for checking lastmodified dte are : ' +temp.LastModifiedDate);
        }
        System.debug('custom item for checking lastmodified dte are : ' +obj);
    }

}