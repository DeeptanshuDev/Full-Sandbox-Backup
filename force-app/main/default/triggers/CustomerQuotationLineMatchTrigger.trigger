trigger CustomerQuotationLineMatchTrigger on SCMC__Customer_Quotation_Line__c(before insert, before update) {
	CustomItemProcessor.triggerSalesOrderLine();
}