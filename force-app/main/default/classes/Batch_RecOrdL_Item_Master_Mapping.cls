/**
*	Description   	:		Batch job that can be scheduled on weekly basis and is there to map Item Master checkbox on Received Order Line.
							For now for the following visual page it belongs to:
					        1) AddToItemMasterOnRecOrdL
*
* 	Created By		:	Abhinav Sharma   
*
* 	Created Date	:   05/07/2020
* 
*  	Version			:   v1.0 - Created - Abhinav Sharma         
**/ 
global class Batch_RecOrdL_Item_Master_Mapping implements Database.Batchable<SObject>, Database.Stateful 
{
    global String query ='';
    global set<string> recLIds;
    
    global Batch_RecOrdL_Item_Master_Mapping(String queryString, List<SCMC__Received_Order_Line__c> recOrdLs)
    {
        
        if(String.isBlank(query) && String.isNotBlank(queryString)) 
        {
            if(queryString.containsIgnoreCase('SCMC__Received_Order_Line__c'))
            {
                query = queryString;
            } 
            else 
            {
                throw new customException(System.Label.Object_Query_Mismatch_Error);
            }
        }
        else if(recOrdLs != null && recOrdLs.size() > 0)
        {            
            Set<String> recOLIds = new Set<String>();
            for(SCMC__Received_Order_Line__c rOL : recOrdLs)
            {
                recOLIds.add(rOL.Id);
            }
            recLIds = recOLIds;
            if(recLIds.size() > 0)
            {
                query = 'SELECT Id, SCMC__Product_Name__c, Item_Master__c From SCMC__Received_Order_Line__c WHERE ID IN : recLIds';
            }  
        }
        else
        { 
            query = 'SELECT Id, SCMC__Product_Name__c, Item_Master__c From SCMC__Received_Order_Line__c';
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {   
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<SCMC__Received_Order_Line__c> recOrdLs)
    {
       
        if(recOrdLs != null && recOrdLs.size() > 0)
        {
            Set<String> productNames = new Set<String>();
            Map<String,SCMC__Item__c> mapOfProductNameWithItem = new Map<String,SCMC__Item__c>();
            
            for(SCMC__Received_Order_Line__c recOrdL : recOrdLs)
            {
                if(String.isNotBlank(recOrdL.SCMC__Product_Name__c) && !recOrdL.Item_Master__c)
                {
                    productNames.add(recOrdL.SCMC__Product_Name__c);
                }
            }
            if(productNames.size() > 0)
            {
                List<SCMC__Item__c> itemMasters = new List<SCMC__Item__c>();
                itemMasters = [SELECT ID, NAME FROM SCMC__Item__c WHERE NAME IN : productNames];
                for(SCMC__Item__c item : itemMasters)
                {
                    if(!mapOfProductNameWithItem.containsKey(item.Name))
                    {
                        mapOfProductNameWithItem.put(item.Name,item);
                    }
                }
                
                if(mapOfProductNameWithItem != null)
                {
                    List<SCMC__Received_Order_Line__c> recOrdLToBeUpdated = new List<SCMC__Received_Order_Line__c>();
                    for(SCMC__Received_Order_Line__c recOrdL : recOrdLs){
                        
                        if(mapOfProductNameWithItem.containsKey(recOrdL.SCMC__Product_Name__c))
                        {
                            recOrdL.Item_Master__c = true;
                            recOrdLToBeUpdated.add(recOrdL);
                        }
                    }
                    if(recOrdLToBeUpdated.size() > 0)
                    {
                        update recOrdLToBeUpdated;
                    }
                }
            }
        }  
    }   
    global void finish(Database.BatchableContext bc)
    { 
        
    }
}