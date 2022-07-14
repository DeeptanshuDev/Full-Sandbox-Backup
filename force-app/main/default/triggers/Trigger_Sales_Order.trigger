trigger Trigger_Sales_Order on SCMC__Sales_Order__c (after insert,after update) {
	
    system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@ hello trigger run ++++++++++++++++++++++++++++');
    SalesOrderTriggerHandler.updateSalesOrderLineItems(Trigger.New, Trigger.oldMap);
    //added by Deeptanshu
    //soNeedTriggerHandlerCheckbox.triggerMethod(Trigger.New, Trigger.oldMap);
   // soNeedTriggerHandlerCheckbox.triggerMethod3(Trigger.New, Trigger.oldMap);
}