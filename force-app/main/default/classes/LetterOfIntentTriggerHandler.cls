/*
* Purpose : This is a trigger helper class for Trigger LetterOfIntentTrigger
* 
* Create By : Deeptanshu
* 
* Created Date : 04/22/2022
* 
* Revision Logs : V_1.0 - Created – Deeptanshu
*
*/
public with sharing class LetterOfIntentTriggerHandler {
    /**
    *
    * @description : This trigger method is used to update LOI field in sales order.
    *
    * @args : List<Letter_Of_Intent__c>, Map<Id, Letter_Of_Intent__c>
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 04/22/2022 - Deeptanshu Bharti
    *
    **/
    public static void getSalesOrderNumber(List<Letter_Of_Intent__c> newList, Map<Id, Letter_Of_Intent__c> oldMap)
    {
        Map<String,String> mapOfString = new Map<String,String>();
        Map<String,String> mapOfString2 = new Map<String,String>();
        List<String> listOfSO = new List<String>();
        List<SCMC__Sales_Order__c> listOfSoToUpdate = new List<SCMC__Sales_Order__c>();
        for(Letter_Of_Intent__c obj : newList)
        {
            if(obj.Status__c == 'Approved')
            {
                String temp = obj.Sales_Orders__c;
                listOfSO = temp.split( ';' );
                for(String str : listOfSO)
                {
                    mapOfString.put(str,obj.Name);
                    mapOfString2.put(str,obj.Id);
                }
            }
        }
        System.debug('sales order are : ' + listOfSO);
        System.debug('map are : ' + mapOfString);
        if(!mapOfString.isEmpty())
        {
            for(SCMC__Sales_Order__c so : [SELECT Id, Name,LOI_Lookup__c,SCMC__Customer_Purchase_Order__c FROM SCMC__Sales_Order__c WHERE Name IN : mapOfString.keySet()])
            { 
                System.debug('value of map is : ' + so);
                so.LOI_Lookup__c = mapOfString2.get(so.Name);
                String temp = mapOfString.get(so.Name);
                System.debug('so cpo lookup field value name is  :L ' + temp);
                so.SCMC__Customer_Purchase_Order__c = temp;
                so.DepositDateandTime__c = System.now();
                /*if(temp == NULL)
                {
                    so.SCMC__Customer_Purchase_Order__c =temp2;
                }
                else
                {
                    Boolean b = temp.containsIgnoreCase(temp2);
                    System.debug('the value booleans is : ' + b);
                    if(!b)
                    {
                        so.SCMC__Customer_Purchase_Order__c = temp + ', ' + temp2;
                    }
                    
                } */
                
                listOfSoToUpdate.add(so);
            }
        }
        if(!listOfSoToUpdate.isEmpty())
        {
            update listOfSoToUpdate;
        }
    }
}