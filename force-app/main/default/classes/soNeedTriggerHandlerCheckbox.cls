/*
* Purpose : This is a trigger helper class for Trigger OpportunityTrigger
* 
* Create By : Deeptanshu
* 
* Created Date : 01/31/2022 
* 
* Revision Logs : V_1.0 - Created – Deeptanshu
*
*/
 
public with sharing class soNeedTriggerHandlerCheckbox {
    
    /*
    * Purpose : This trigger is to uncheck so needed checkbox after so is created. 
    * 
    * Create By : Deeptanshu
    * 
    * Created Date : 01/31/2022 
    * 
    * Revision Logs : V_1.0 - Created – Deeptanshu
    *                
    */ 
    public static void triggerMethod(List<SCMC__Sales_Order__c> items, Map<Id, SCMC__Sales_Order__c> oldItems)
    {
        System.debug('items are : '  + items);
        System.debug('old map are : ' + oldItems);
        if(items!= NULL)
        {
            Set<Id> setOfOppId = new Set<Id> ();
            for(SCMC__Sales_Order__c obj : items)
            {
                setOfOppId.add(obj.Opportunity__c);
            }
            System.debug('if of opp are : ' + setOfOppId);
            List<Opportunity> listOfOpp = [SELECT Id, Name, SO_Needed__c, so_need_Date_and_Time__c FROM Opportunity WHERE Id IN : setOfOppId];
            List<Opportunity> listOfOppToUpdate = new List<Opportunity>();
			System.debug('opp are : ' + listOfOpp);            
            for(integer i = 0; i<listOfOpp.size(); i++)
            {
                System.debug('value of i is : ' + i);
                System.debug('so needed date and time are : ' + listOfOpp[i].so_need_Date_and_Time__c);
                for(integer j = 0;j<items.size();j++)
                {
                    
                    System.debug('value of j is : ' + j);
                    System.debug('sales order created date are :' + items[j].CreatedDate);
                    if(items[j].CreatedDate >= listOfOpp[i].so_need_Date_and_Time__c)
                    {
                        
                        listOfOpp[i].SO_Needed__c = FALSE;
                        listOfOppToUpdate.add(listOfOpp[i]);
                        break;
                    }
                }
            }
            System.debug('list to update are : ' + listOfOppToUpdate);
            if(listOfOppToUpdate != NULL)
            {
                update listOfOppToUpdate;
            }
        }


    }
    
    /*
    * Purpose : This trigger is to update the value of so needed date and time if so needed is checked and also if uncheck then so needed date and time is null. 
    * 
    * Create By : Deeptanshu
    * 
    * Created Date : 01/31/2022 
    * 
    * Revision Logs : V_1.0 - Created – Deeptanshu
    *                
    */     
    public static void triggerMethod2(List<Opportunity> opp, Map<Id, Opportunity> oldMap)
    {
        System.debug('new opp are : ' + opp);
        System.debug('old opp are : '+ oldMap);
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        List<Opportunity> oppFromMap = new List<Opportunity> ();
        
        for(Opportunity opps : opp)
        {
            System.debug('list values are : ' + opps);
            oppFromMap.add(opps);
            System.debug('opp so needed dateandtime values are : ' + opps.so_need_Date_and_Time__c);
            System.debug('opp so needed checkbox values are : ' + opps.SO_Needed__c);
            if((opps.SO_Needed__c == TRUE) &&(opps.so_need_Date_and_Time__c == NULL))
            {
                opps.so_need_Date_and_Time__c = System.now();
                oppToUpdate.add(opps);
                System.debug('current time are : '  + System.now());
            }
            if(opps.SO_Needed__c == FALSE)
            {
                opps.so_need_Date_and_Time__c = NULL;
            }
        }
        System.debug('map to update are : ' + oppToUpdate);
      
        
    }
    
    /*
    * Purpose : This trigger is to update the value on opportunity based on fields in ci, si and so. 
    * 
    * Create By : Deeptanshu
    * 
    * Created Date : 01/31/2022 
    * 
    * Revision Logs : V_1.0 - Created – Deeptanshu
    *                
    */     
    public static void triggerMethod3(List<SCMC__Sales_Order__c> items, Map<Id, SCMC__Sales_Order__c> oldItems)
    {
        System.debug('items are : '  + items);
        System.debug('old map are : ' + oldItems);
        Set<Id> setOfOppId = new Set<Id>();
        for(SCMC__Sales_Order__c obj : items)
        {
            System.debug('sales order are : ' + obj);
            setOfOppId.add(obj.Opportunity__c);
            
        }
        System.debug('opportunities are : ' + setOfOppId);
        List<Opportunity> listOfAllOpp = [SELECT Id, Name, Amount FROM Opportunity WHERE Id IN : setOfOppId];
        List<Opportunity> listOfOppToUpdate = new List<Opportunity>();
        
        System.debug('opp are : ' + listOfAllOpp);
        for(Opportunity obj1 : listOfAllOpp)
        {
            Double TotalSo = 0;
            Double TotalOpp = 0;
            System.debug('obj1 values are: '+ obj1);
            List<SCMC__Sales_Order__c> listOfAllSo = [SELECT Id, Name, Sales_Order_Number_Text__c, SCMC__Total_Value__c FROM SCMC__Sales_Order__c WHERE Opportunity__c =: obj1.Id];
            for(SCMC__Sales_Order__c obj : listOfAllSo)
            {
                System.debug('sales order are : ' + obj);
                System.debug('sales order total value is : ' + obj.SCMC__Total_Value__c);
                TotalSo = TotalSo + obj.SCMC__Total_Value__c;
            }
            System.debug('amount in opp is : '+ obj1.Amount);
            TotalOpp = TotalOpp + obj1.Amount;
            Double temp = TotalOpp - TotalSo;
            System.debug('difference value are : ' +temp);
            obj1.Amount = TotalSo;
            listOfOppToUpdate.add(obj1);
            
        }
        System.debug('list to update are : ' + listOfOppToUpdate);
        if(listOfOppToUpdate!=NULL)
        {
            update listOfOppToUpdate;
        }
    } 



}