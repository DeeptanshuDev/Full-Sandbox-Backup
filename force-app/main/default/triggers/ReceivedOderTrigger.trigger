trigger ReceivedOderTrigger on SCMC__Received_Order__c (after update, before update) {
    try{
        
        if(Trigger.isAfter && Trigger.isUpdate) 
        {
            if(TriggerHelperForReceivedOrderAndLine.updateReceivedOrder)
            {
                TriggerHelperForReceivedOrderAndLine.updateRelatedAccount(Trigger.New, Trigger.NewMap);
            }
            
        }
        
        if(Trigger.isBefore && Trigger.isUpdate) 
        {
            Final String REBEL_CHEER_WHOLESALE = System.Label.PopoulateAccOnReceivedOderFor_AccountName;
            Final Date ORDER_DATE = Date.valueOf(System.Label.PopoulateAccOnReceivedOderFor_Date);
            
            for(SCMC__Received_Order__c recOrder : Trigger.New)
            {
                // SCMC__Account_Name__c, SCMC__Order_Date__c,
                if(String.isBlank(recOrder.SCMC__Account_Name__c)
                   || recOrder.SCMC__Account_Name__c != REBEL_CHEER_WHOLESALE
                   || recOrder.SCMC__Order_Date__c == null
                   || recOrder.SCMC__Order_Date__c <= ORDER_DATE
                  )
                {
                    recOrder.Related_Account__c = null;
                    recOrder.Gym_Name__c = null;
                }
            }
        }
        
    }
    catch(Exception e) {
        
        //Add Error Message on Page
        if(Trigger.isDelete)
            Trigger.Old[0].addError(e.getMessage());
        else
            Trigger.New[0].addError(e.getMessage());
    }
}