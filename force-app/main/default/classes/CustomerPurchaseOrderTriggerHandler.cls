/*
* Purpose : This is a trigger helper class for Trigger CustomerPurchaseOrderTrigger
* 
* Create By : Deeptanshu
* 
* Created Date : 04/22/2022
* 
* Revision Logs : V_1.0 - Created – Deeptanshu
*
*/

public with sharing class CustomerPurchaseOrderTriggerHandler {
    /**
    *
    * @description : This trigger method is used to update CPO field in sales order.
    *
    * @args : List<Customer_Purchase_Order__c>, Map<Id, Customer_Purchase_Order__c>
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 04/22/2022 - Deeptanshu Bharti
    *
    **/
    public static void getSalesOrderNumber(List<Customer_Purchase_Order__c> newList, Map<Id, Customer_Purchase_Order__c> oldMap)
    {
        Map<String,String> mapOfString = new Map<String,String>();
        Map<String,String> mapOfString2 = new Map<String,String>();
        Map<String,String> mapOfString3 = new Map<String,String>();
        List<String> listOfSO = new List<String>();
        List<SCMC__Sales_Order__c> listOfSoToUpdate = new List<SCMC__Sales_Order__c>();
        for(Customer_Purchase_Order__c obj : newList)
        {
            if(obj.Status__c == 'Approved')
            {
                String temp = obj.Sales_Orders__c;
                System.debug('the temp value from test class us : '+temp);
                if(temp!=NULL)
                {
                    listOfSO = temp.split( ';' );
                    for(String str : listOfSO)
                    {
                        mapOfString.put(str,obj.Name);
                        mapOfString2.put(str,obj.Id);
                        mapofString3.put(str,obj.PO_Number__c);
                    }
                }
                
            }
        }
        if(!mapOfString.isEmpty())
        {
            for(SCMC__Sales_Order__c so : [SELECT Id, Name,CPO_Lookup__c,CPO_Lookup__r.Name,CPO_Lookup__r.PO_Number__c,SCMC__Customer_Purchase_Order__c FROM SCMC__Sales_Order__c WHERE Name IN : mapOfString.keySet()])
            {
                so.CPO_Lookup__c = mapOfString2.get(so.Name);
                System.debug('so cpo lookup field value is  : ' + so.CPO_Lookup__c);
                //String temp = mapOfString.get(so.Name);
                //System.debug('so cpo lookup field value name is  :L ' + temp);
                String temp = mapOfString3.get(so.Name);
                so.SCMC__Customer_Purchase_Order__c = temp;
                so.DepositDateandTime__c = System.now();
                listOfSoToUpdate.add(so);
            }
        }
        if(!listOfSoToUpdate.isEmpty())
        {
            update listOfSoToUpdate;
        }
    }
}