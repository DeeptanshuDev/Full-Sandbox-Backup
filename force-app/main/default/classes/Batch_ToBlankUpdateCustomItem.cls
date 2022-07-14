/** 
* 
* Description : Batch class to do bank update custom item.
* 
* Created By : Deeptanshu Bharti
* 
* Created Date : 01/24/2022 
* 
* Revision Logs : V1.0 - Created - Deeptanshu Bharti 
* 
**/
 
global class Batch_ToBlankUpdateCustomItem implements Database.Batchable<sObject>{
    /**
    *
    * @description : This method will start the batch and return all the custom item.
    *
    * @args :
    *
    * @return : Database.QueryLocator
    *
    * @revision Log : V1.1 - Created - 01/24/2022  - Deeptanshu Bharti
    *
    **/
 
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator('SELECT Id,LastModifiedDate,Lining__c,Blank_Update__c, Price_Expiration_Completed__c, Custom_Item_Reorder__c, Pricing_Expiration_Date__c FROM Custom_Item__c WHERE Custom_Item_Reorder__c= NULL AND Pricing_Expiration_Date__c <= TODAY ');
    }
 
    /**
    *
    * @description : This method will execute the batch.
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 01/24/2022  - Deeptanshu Bharti
    *
    **/
 
    global void execute(Database.BatchableContext bc, List<Custom_Item__c> customItem)
    {
        /*Map<Id, Custom_Item__c> mapOfCustomItem = new Map<Id, Custom_Item__c> ();
        for(Custom_Item__c obj : customItem){
            System.debug(obj);
            mapOfCustomItem.put(obj.Id, obj);
        }
        
        if(mapOfCustomItem != NULL){
           update customItem; 
        }
        */
        
        List<Custom_Item__c> listOfCustomItem = new List<Custom_Item__c>();
        for(Custom_Item__c obj : customItem)
        {
            obj.Lining__c = '';
            System.debug('blank update value before is : ' + obj.Blank_Update__c);
            obj.Blank_Update__c = true;
            System.debug(obj.LastModifiedDate);
            listOfCustomItem.add(obj);
            System.debug(obj);
        }
        if(listOfCustomItem != NULL )
        {
            Util.BypassAllTriggers= True;
           	update listOfCustomItem;
            //update customItem;
            
            Util.BypassAllTriggers= false;
        }
        /*List<Custom_Item__c> listOfCIToCheck = [SELECT Id,LastModifiedDate, Price_Expiration_Completed__c, Custom_Item_Reorder__c, Pricing_Expiration_Date__c FROM Custom_Item__c WHERE Custom_Item_Reorder__c= NULL AND Pricing_Expiration_Date__c <= TODAY];
        for(Custom_Item__c obj : listOfCIToCheck)
        {
            
            System.assert(false,obj.LastModifiedDate);
            
        }*/
        
        System.debug('custom item has been updated');
           
    }
 
    /**
    *
    * @description : This method will finish the batch.
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 01/24/2022  - Deeptanshu Bharti
    *
    **/
 
    global void finish(Database.BatchableContext bc)
    {
        System.debug('Done with the code');
        List<Custom_Item__c> obj = [SELECT Id,LastModifiedDate,Lining__c,Blank_Update__c, Price_Expiration_Completed__c, Custom_Item_Reorder__c, Pricing_Expiration_Date__c FROM Custom_Item__c WHERE Custom_Item_Reorder__c= NULL AND Pricing_Expiration_Date__c <= TODAY];
        for(Custom_Item__c t : obj)
        {
            System.debug('last modified date arev : ' + t.LastModifiedDate);
            System.debug('blank update field vaue after is : ' + t.Blank_Update__c);
            System.debug(t);
        }
    }


}