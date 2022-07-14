trigger SalesOrderLineItemMatchTrigger on SCMC__Sales_Order_Line_Item__c(before insert, before update, after insert, after update) {
	CustomItemProcessor.triggerSalesOrderLine();

	
	//added by Deeptanshu Bharti
	/*CustomItemTriggerHandler handler = new CustomItemTriggerHandler();
	if (Trigger.isAfter) 
	{
		handler.updateSalesOrderLineItems(Trigger.new, Trigger.oldMap);
	}
	*/
    
	if(Trigger.isAfter ){
		if(Trigger.isInsert || Trigger.isUpdate ){
			//SalesOrderLineItemTriggerHelper.updateCISITotalAmount(Trigger.New, Trigger.oldMap);
		}
	}
	

}