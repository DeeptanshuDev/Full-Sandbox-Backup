trigger CustomerPurchaseOrderTrigger on Customer_Purchase_Order__c (after insert, after update) {
    if(Trigger.isAfter)
    {
        CustomerPurchaseOrderTriggerHandler.getSalesOrderNumber(Trigger.new,Trigger.oldMap);
    }

}