/**
*	Description   	:		This class is used to provide the mapping between Item Master and Received Order Line Item.
					
*
* 	Created By		:	Abhinav Sharma   
*
* 	Created Date	:   05/07/2020
* 
*  	Version			:   v1.0 - Created - Abhinav Sharma         
**/ 
public class ReceivedOrderLineTriggerHandler {
    
   /**
    *  @description    :   This method is used to connect Item Master Checkbx on Received Order Line Item.
    *
    *  @args           :   List<SCMC__Received_Order_Line__c> newReceivedOrderLines
    *
    *  @return         :   Void
    * 
    **/
    public static void populateItemMaster(List<SCMC__Received_Order_Line__c> newReceivedOrderLines, Map<Id,SCMC__Received_Order_Line__c> 
                                         oldReceivedOrderLines)
    {	   
        
        system.debug('ordre '+newReceivedOrderLines);
        if(newReceivedOrderLines != null || oldReceivedOrderLines != null)
        {
            Set<String> productNames = new Set<String>();
            Map<String,SCMC__Item__c> mapOfProductNameWithItem = new Map<String,SCMC__Item__c>();
            
            for(SCMC__Received_Order_Line__c recOrdL : newReceivedOrderLines)
            {
                if(String.isNotBlank(recOrdL.SCMC__Product_Name__c) && !recOrdL.Item_Master__c)
                {
                    productNames.add(recOrdL.SCMC__Product_Name__c);
                }
            }
           system.debug('product name '+productNames);
            if(productNames.size() > 0)
            {
                List<SCMC__Item__c> itemMasters = new List<SCMC__Item__c>();
                itemMasters = [SELECT ID, NAME FROM SCMC__Item__c WHERE NAME IN : productNames];
                system.debug('item masters --'+itemMasters);
                for(SCMC__Item__c item : itemMasters)
                {
                    if(!mapOfProductNameWithItem.containsKey(item.Name))
                    {
                        string name = item.name.toUpperCase();
                        mapOfProductNameWithItem.put(name,item);
                    }
                }
                system.debug('maps '+mapOfProductNameWithItem);
                if(mapOfProductNameWithItem != null)
                {
                    List<SCMC__Received_Order_Line__c> recOrdLToBeUpdated = new List<SCMC__Received_Order_Line__c>();
                    for(SCMC__Received_Order_Line__c recOrdL : newReceivedOrderLines){
                        system.debug('recOrdL.SCMC__Product_Name__c' +recOrdL.SCMC__Product_Name__c);
                        string name = String.isNotBlank(recOrdL.SCMC__Product_Name__c) ? 
                            recOrdL.SCMC__Product_Name__c.touppercase() : recOrdL.SCMC__Product_Name__c;
                        if(mapOfProductNameWithItem.containsKey(name))
                        {
                            system.debug('neame');
                            recOrdL.Item_Masters__c = mapOfProductNameWithItem.get(name).Id;
                        }
                    }
                }
            }
        }  
    }
}