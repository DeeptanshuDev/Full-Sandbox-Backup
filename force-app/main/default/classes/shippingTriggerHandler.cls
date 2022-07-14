/** 
* 
* Description : Class which is used to place chatter with the link of so invoice, so shipping.
* 
* Created By : Deeptanshu Bharti
* 
* Created Date : 04/05/2022
* 
* Revision Logs : V1.0 - Created - Deeptanshu Bharti 
* 
**/
public class shippingTriggerHandler {
    /**
    *
    * @description : using this method we are placing chatter in opportunity when invoices are inserted.
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 04/05/2022 - Deeptanshu Bharti 
    *
    **/
    public static void invoiceChatter(List<SCMC__Invoicing__c> newList, Map<Id, SCMC__Invoicing__c> oldMap)
    {
        Set<Id> setOfSoId = new Set<Id>();
        Set<Id> setOfOppId = new Set<Id>();
        for(SCMC__Invoicing__c obj : newList)
        {
            System.debug('the new invoice are : ' + obj);
            setOfSoId.add(obj.SCMC__Sales_Order__c);
        }
        if(setOfSoId.size()>0)
        {
            for(SCMC__Sales_Order__c obj : [SELECT Id, Name, Opportunity__c FROM SCMC__Sales_Order__c WHERE Id IN : setOfSoId])
            {
                System.debug('the sales order are : ' + obj);
                setOfOppId.add(obj.Opportunity__c);
                System.debug(' the oppiortunity are :   ' + obj.Opportunity__c);
                if(obj.Opportunity__c != NULL)
                {
                    placeChatter(obj.Opportunity__c);
                }
                
            }
        }
    }
    
    /**
    *
    * @description : using this method we are placing chatter in opportunity when shipping are inserted.
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 04/05/2022 - Deeptanshu Bharti 
    *
    **/
    public static void shippingChatter(List<SCMC__Shipping__c> newList, Map<Id, SCMC__Shipping__c> oldMap)
    {
        Set<Id> setOfSoId = new Set<Id>();
        Set<Id> setOfOppId = new Set<Id>();
        for(SCMC__Shipping__c obj : newList)
        {
            System.debug('the new invoice are : ' + obj);
            setOfSoId.add(obj.SCMC__Sales_Order__c);
        }
        if(setOfSoId.size()>0)
        {
            for(SCMC__Sales_Order__c obj : [SELECT Id, Name, Opportunity__c FROM SCMC__Sales_Order__c WHERE Id IN : setOfSoId])
            {
                System.debug('the sales order are : ' + obj);
                setOfOppId.add(obj.Opportunity__c);
                System.debug(' the oppiortunity are :   ' + obj.Opportunity__c);
                if(obj.Opportunity__c != NULL)
                {
                    placeChatter2(obj.Opportunity__c);
                }
                
            }
        }
    }
    
    /**
    *
    * @description : using this method we are placing chatter in opportunity when custom item shipment are inserted.
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 04/05/2022 - Deeptanshu Bharti 
    *
    **/
    public static void nonInventoryChatter(List<Non_Inventory_item__c> newList, Map<Id, Non_Inventory_item__c> oldMap)
    {
        /*Set<Id> setOfSoId = new Set<Id>();
        Set<Id> setOfOppId = new Set<Id>();*/
        //converted set to list because we have to place chatter multiple time may be for same so thatswhy
        List<Id> listOfSoId = new List<Id>();
        List<Id> listOfOppId = new List<Id>();
        
        for(Non_Inventory_item__c obj : newList)
        {
            System.debug('the new invoice are : ' + obj);
            listOfSoId.add(obj.SO__c);
        }
        //System.assert(false,listOfSoId);
        //Added by Deeptanshu for placing different chatter
        List<SCMC__Sales_Order__c> so = new List<SCMC__Sales_Order__c>();
        if(listOfSoId.size()>0)
        {
            for(integer i = 0;i<listOfSoId.size();i++)
            {
                SCMC__Sales_Order__c saales = [SELECT Id, Name, Opportunity__c FROM SCMC__Sales_Order__c WHERE Id=: listOfSoId[i]];
                so.add(saales);
                listOfOppId.add(saales.Opportunity__c);
                System.debug(' the oppiortunity are :   ' + saales.Opportunity__c);
                if(saales.Opportunity__c != NULL)
                {
                    placeChatter2(saales.Opportunity__c);
                }
            }
        }
        
        //System.assert(false,so);
        //till here
        /*if(listOfSoId.size()>0)
        {
            
            for(SCMC__Sales_Order__c obj : [SELECT Id, Name, Opportunity__c FROM SCMC__Sales_Order__c WHERE Id =: listOfSoId])
            {
                System.debug('the sales order are : ' + obj);
                listOfOppId.add(obj.Opportunity__c);
                System.debug(' the oppiortunity are :   ' + obj.Opportunity__c);
                if(obj.Opportunity__c != NULL)
                {
                    placeChatter2(obj.Opportunity__c);
                }
                
            }
        }*/
    }
    
    /**
    *
    * @description : this method is used to place chatter on Opportunity based on custom object insertion.
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 04/05/2022 - Deeptanshu Bharti
    *
    **/
     public static void placeChatter(Id Ids)
     {
         String body =' https://rebelathletic--full--c.visualforce.com/apex/OppInvoiceDetail?scontrolCaching=1&id='+Ids;
         System.debug('body for chatter are : ' + body);
         FeedItem post = new FeedItem();
         post.ParentId = Ids;
         post.Body = body;
         insert post; 
         
     }
    
    /**
    *
    * @description : this method is used to place chatter on Opportunity based on custom object insertion.
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 04/05/2022 - Deeptanshu Bharti
    *
    **/
     public static void placeChatter2(Id Ids)
     {
         //System.assert(false,Ids);
         String body =' https://rebelathletic--full--c.visualforce.com/apex/OppNewPage?scontrolCaching=1&id='+Ids;
         System.debug('body for chatter are : ' + body);
         FeedItem post = new FeedItem();
         post.ParentId = Ids;
         post.Body = body;
         insert post;   
     }

}