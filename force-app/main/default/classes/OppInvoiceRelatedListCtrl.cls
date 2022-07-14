public without sharing class OppInvoiceRelatedListCtrl {

    public String oppId { get; set; }												// Current record Id
    public List<SCMC__Sales_Order__c> salesOrderList { get; set; }					//List of Sales order
    public List<SCMC__Invoicing__c> invoiceList { get; set; }					    //List of Invoice
    public List<c2g__codaInvoice__c> salesInvoiceList { get; set; }	                //List of Sales Invoice

    public OppInvoiceRelatedListCtrl(ApexPages.StandardController cont) {

        This.oppId = cont.getId();
        Set<Id> soId = new Set<Id>();
        List<SCMC__Sales_Order__c> listOfSalesOrder = new List<SCMC__Sales_Order__c>();
        for(SCMC__Sales_Order__c so: [SELECT Id FROM SCMC__Sales_Order__c WHERE Opportunity__c = :oppId]) {
            soId.add(so.Id);
        }
        for(SCMC__Sales_Order__c si: [SELECT Id,Sales_Order_Number_Text__c,SCMC__Sales_Order_Name__c,SCMC__Sales_Order_Date__c,Opportunity_Number__c, Order_Type__c, SCMC__Total_Value__c,Total_Percentage_Paid__c, SCMC__Shipment_Status__c, Remaining_Payment_Balance__c, SCMC__Fulfillment_Date__c FROM SCMC__Sales_Order__c WHERE Opportunity__c = :oppId]) {
            listOfSalesOrder.add(si);
        }
        System.debug('sales order list are : '+ listOfSalesOrder); 
        this.salesOrderList = listOfSalesOrder;
        System.debug('sales order detail to show are : ' + salesOrderList);
        
        List<SCMC__Invoicing__c> listOfInvoice = [SELECT Id, Name, SCMC__Status__c, SCMC__Invoice_Date__c,Payment_Status__c FROM SCMC__Invoicing__c WHERE SCMC__Sales_Order__r.Id IN: soId];
        this.invoiceList = listOfInvoice;

        List<c2g__codaInvoice__c> listofSalesinvoice = [SELECT Id, c2g__AccountName__c, c2g__CompanyReference__c, Convenience_Fee__c,c2g__DueDate__c, c2g__InvoiceDate__c, Name, c2g__InvoiceStatus__c FROM c2g__codaInvoice__c WHERE Sales_Order__r.Id IN: soId];
        this.salesInvoiceList = listofSalesinvoice;
        
    }
}