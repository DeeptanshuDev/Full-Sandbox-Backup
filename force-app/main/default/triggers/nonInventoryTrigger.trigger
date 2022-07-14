trigger nonInventoryTrigger on Non_Inventory_item__c (after insert,before insert) {
    
    if(Trigger.isAfter)
    {
        nonInventoryTriggerHandler.nonInventoryMail(Trigger.new, Trigger.oldMap);
    }
    
    if (Trigger.isAfter && Trigger.isInsert) 
    {
        shippingTriggerHandler.nonInventoryChatter(Trigger.new, Trigger.oldMap);
    }

}