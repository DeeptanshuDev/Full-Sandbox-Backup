public with sharing class TriggerHelperForReceivedOrderAndLine {
	public static Boolean updateReceivedOrder = true;
    public static void updateRelatedAccount(List<SCMC__Received_Order__c> newReceivedOrders, Map<Id, SCMC__Received_Order__c> newReceivedOrderMap)
    {	   
        TriggerHelperForReceivedOrderAndLine.updateParentAccount(newReceivedOrders, False);
    }
    
    public static void updateParentAccount(List<SCMC__Received_Order__c> newReceivedOrders, Boolean updateAcc)
    {  
        if(updateReceivedOrder = false) return;
		WrapperClass resultWrapper = TriggerHelperForReceivedOrderAndLine.receivedOrderMap(newReceivedOrders) ;                
        Map<String,String> receivedOrderMap = resultWrapper.receivedOrderMap;               
        Map<String,String> accountNumIdMap = resultWrapper.accountNumIdMap;
        
        Set<Id> recOrderIds = new Set<Id>();
        for(SCMC__Received_Order__c recOrder : newReceivedOrders)
        {
            recOrderIds.add(recOrder.Id);
        }
        List<SCMC__Received_Order__c> recOrderToUpdate = [SELECT Related_Account__c, Gym_Name__c FROM SCMC__Received_Order__c WHERE ID =: recOrderIds];
        for(SCMC__Received_Order__c recOrder : recOrderToUpdate)
        {
            if(receivedOrderMap.containsKey(recOrder.Id))
            {
                String recOrderId = receivedOrderMap.get(recOrder.Id) ;
                if(accountNumIdMap.containsKey(recOrderId))
                {
                    String recAccId = accountNumIdMap.get(recOrderId) ;
                    recOrder.Related_Account__c = recAccId;
                    recOrder.Gym_Name__c = recOrderId;
                }
                else
                {
                    recOrder.Related_Account__c = null;
                	recOrder.Gym_Name__c = '';
                }
            }else{
                recOrder.Related_Account__c = null;
                recOrder.Gym_Name__c = '';
            }
        }         
        // updated Received Orders for their Account to update, if any Received Order Line is updated/inserted/deleted  
        if(recOrderToUpdate.size() > 0)
        {
            updateReceivedOrder = false;
            update recOrderToUpdate ;  
        }
                  
    }   
    public static WrapperClass receivedOrderMap(List<SCMC__Received_Order__c> newReceivedOrders){
        Final String REBEL_CHEER_WHOLESALE = System.Label.PopoulateAccOnReceivedOderFor_AccountName;
        Final Date ORDER_DATE = Date.valueOf(System.Label.PopoulateAccOnReceivedOderFor_Date);
        Set<String> accountNumbers = new Set<String>();       
        Map<String,String> receivedOrderMap = new Map<String,String>();
        List<SCMC__Received_Order_Line__c>  listOfRecOrdLine = [Select Id, Gym_Name__c,SCMC__Received_Order__c 
                                                                From SCMC__Received_Order_Line__c
                                                                Where Gym_Name__c !='' AND Gym_Name__c Like '%A-%' 
                                                                AND SCMC__Received_Order__c IN : newReceivedOrders
                                                                AND SCMC__Received_Order__r.SCMC__Order_Date__c > :ORDER_DATE
                                                                AND SCMC__Received_Order__r.SCMC__Account_Name__c =: REBEL_CHEER_WHOLESALE
                                                                ORDER BY CreatedDate DESC
                                                               ] ;
        // get the account number set from received order line
        if(listOfRecOrdLine.size() >0 )
        {
            for( SCMC__Received_Order_Line__c recOrdLine : listOfRecOrdLine)
            {
                accountNumbers.add(recOrdLine.Gym_Name__c);
            }
        }        
        Map<String,String> accountNumIdMap = TriggerHelperForReceivedOrderAndLine.findAccountNumberAndIdFromAccNumber(accountNumbers);  
        
        if(listOfRecOrdLine.size() >0 )
        {
            for( SCMC__Received_Order_Line__c recOrdLine : listOfRecOrdLine)
            {
                if(accountNumIdMap.containsKey(recOrdLine.Gym_Name__c) && (! receivedOrderMap.containsKey(recOrdLine.SCMC__Received_Order__c)) )
                {
                    receivedOrderMap.put(recOrdLine.SCMC__Received_Order__c, recOrdLine.Gym_Name__c) ;
                }
            }
        }   
        
        WrapperClass wrp = new WrapperClass( receivedOrderMap,accountNumIdMap) ;
        return wrp;        
    }    
    
    public static Map<String,String> findAccountNumberAndIdFromAccNumber(Set<String> accountNumbers){
        Map<String,String> accountNumIdMap = new Map<String,String>() ;
        if(accountNumbers.size() > 0 ){            
            List<Account> accounts = [Select Id, Account_Number__c From Account 
                                    	Where Account_Number__c IN :accountNumbers
                                    ] ;            
            if(accounts.size()>0){
                for(Account acc : accounts){
                    accountNumIdMap.put(acc.Account_Number__c,acc.Id);
                }
            }
        }        
        return accountNumIdMap ;
    }
    
    public static void updateReceivedOrderAccounts(Set<String> receivedOrderIds){
        List<SCMC__Received_Order__c> newReceivedOrders = new List<SCMC__Received_Order__c>();
        
        for(String str :receivedOrderIds){
            SCMC__Received_Order__c newRecOrd = new SCMC__Received_Order__c(Id=str) ;
            newReceivedOrders.add(newRecOrd);
        }        
        TriggerHelperForReceivedOrderAndLine.updateParentAccount(newReceivedOrders, True);        
    }
    
    public class WrapperClass{                      
        Map<String,String> receivedOrderMap = new Map<String,String>();        
        Map<String,String> accountNumIdMap = new Map<String,String>();
        
        WrapperClass( Map<String,String> receivedOrderMap,Map<String,String> accountNumIdMap){             
            this.receivedOrderMap = receivedOrderMap;
            this.accountNumIdMap = accountNumIdMap;
        }        
    }   
}