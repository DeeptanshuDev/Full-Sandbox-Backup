trigger shippingTrigger on SCMC__Shipping__c (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) 
    {
        shippingTriggerHandler.shippingChatter(Trigger.new, Trigger.oldMap);
    }

}