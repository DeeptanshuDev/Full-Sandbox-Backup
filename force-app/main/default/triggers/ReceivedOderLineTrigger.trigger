trigger ReceivedOderLineTrigger on SCMC__Received_Order_Line__c (after insert, after update, after delete)
{
    try{
        
        if(Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert || Trigger.isDelete )) {
            
            List<SCMC__Received_Order_Line__c> updateParentRecords = new List<SCMC__Received_Order_Line__c>();
            Set<String> updateReceivedOrderAccounts = new Set<String>();
            
            if(Trigger.isDelete){
                updateParentRecords = Trigger.old ;
            }else{
                updateParentRecords = Trigger.new ;
            }
            
            for (SCMC__Received_Order_Line__c recOrderLine : updateParentRecords) {               
                
                if(Trigger.isDelete || Trigger.isInsert)
                {
                    
                    if(recOrderLine.SCMC__Received_Order__c != null 
                       && recOrderLine.Order_Date__c != null 
                       && String.isNotBlank(recOrderLine.Gym_Name__c) 
                       && recOrderLine.Gym_Name__c.startsWith('A-') )
                    {
                        updateReceivedOrderAccounts.add(recOrderLine.SCMC__Received_Order__c);
                    }
                    
                }else{
                    //updateReceivedOrderAccounts.add(recOrderLine.SCMC__Received_Order__c);
                    SCMC__Received_Order_Line__c recOrderLineOld = Trigger.oldMap.get(recOrderLine.ID);
                    if(recOrderLine.Gym_Name__c != recOrderLineOld.Gym_Name__c)
                    {
                        updateReceivedOrderAccounts.add(recOrderLine.SCMC__Received_Order__c);
                    }
                    
                }                
            }
            if(updateReceivedOrderAccounts.size()>0){
                TriggerHelperForReceivedOrderAndLine.updateReceivedOrderAccounts(updateReceivedOrderAccounts);
            }
            
        }
        
        
        //Catching all Exceptions
    } catch(Exception e) {
        
        //Add Error Message on Page
        if(Trigger.isDelete)
            Trigger.Old[0].addError(e.getMessage());
        else
            Trigger.New[0].addError(e.getMessage());
    }
}