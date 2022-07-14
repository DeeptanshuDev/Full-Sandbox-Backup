trigger Trigger_Order_Sizes on Order_Sizes__c (before insert, before update, after insert, after update) 
{
    if(Util.BypassAllTriggers) 
    {
    	return;    
    }
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
    {
        OrderSizeTriggerHelper.populateReccomendedAndRecommendedOverride(Trigger.new, Trigger.oldMap);
    }
    
    if(Trigger.isAfter && Trigger.isInsert){
        OrdersizeTriggerHelper.updateNumonOpportunity(Trigger.new);
       // OrdersizeTriggerHelper.updateGenerateAFSOnOpportunity(Trigger.new);
        OrderSizeTriggerHelper.updateItemNumberOnOrderSizes(Trigger.new);
    }
     if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
    {
        OrderSizeTriggerHelper.updateCustomItemWithRecommendSizes(Trigger.new, Trigger.oldMap);
    }
}