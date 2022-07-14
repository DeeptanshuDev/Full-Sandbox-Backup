public without sharing class OppChildRelatedListCtrl {
    
    @AuraEnabled
    public static List<SCMC__Shipping__c> getShipping(Id oppId)
    {
        System.debug('Opp id is : ' + oppId);
        Set<ID> salesOrderId = new Set<ID> ();
        for(SCMC__Sales_Order__c so: [SELECT Id FROM SCMC__Sales_Order__c WHERE Opportunity__c = :oppId]) {
            salesOrderId.add(so.Id);
        }
        System.debug('Sales order id are : ' + salesOrderId);
        List<SCMC__Shipping__c> obj = new List<SCMC__Shipping__c>([SELECT Id, SCMC__Carrier__c,SCMC__Status__c, SCMC__Carrier_Service__c, SCMC__Carrier_Tracking_Number__c, SCMC__Supplier_Name__c, SCMC__Purchase_Order__c,SCMC__Sales_Order__c, SCMC__Customer_Name__c, Name FROM SCMC__Shipping__c WHERE SCMC__Sales_Order__c In : salesOrderId]);
        System.debug('shippings are : '+ obj);
        return obj;

    }
    
    @AuraEnabled (cacheable=true)
    public static List<SCMC__Picklist__c> getPickList(Id oppId)
    {
        System.debug('Opp id is : ' + oppId);
        Set<ID> salesOrderIds = new Set<ID> ();
        for(SCMC__Sales_Order__c so: [SELECT Id FROM SCMC__Sales_Order__c WHERE Opportunity__c = :oppId]) {
            salesOrderIds.add(so.Id);
        }
        System.debug('Sales order id are : ' + salesOrderIds);
        List<SCMC__Picklist__c> obj1 = new List<SCMC__Picklist__c>([SELECT Id, SCMC__Status__c, SCMC__Purchase_Order__c,SCMC__Sales_Order__c, SCMC__Pick_List_Type__c, Name FROM SCMC__Picklist__c WHERE SCMC__Sales_Order__c In : salesOrderIds]);
        System.debug('Picklist are : '+ obj1);
        return obj1;

    }
    
    public static List<SCMC__Pick_list_Detail__c> getPickListDetails(Id oppId)
    {
        System.debug('Opp id is : ' + oppId);
        Set<ID> salesOrderId = new Set<ID> ();
        for(SCMC__Sales_Order__c so: [SELECT Id FROM SCMC__Sales_Order__c WHERE Opportunity__c = :oppId]) {
            salesOrderId.add(so.Id);
        }
        System.debug('Sales order id are : ' + salesOrderId);
        List<SCMC__Picklist__c> obj = new List<SCMC__Picklist__c>([SELECT Id, Name FROM SCMC__Picklist__c WHERE SCMC__Sales_Order__c In : salesOrderId]);
        System.debug('picklist in picklistdetails method are : '+ obj);
        Set<Id> pickListId = new Set<Id>();
        for(SCMC__Picklist__c var : obj)
        {
            pickListId.add(var.Id);
        }
        System.debug('Picklist ids are : '+ pickListId);
        List<SCMC__Pick_list_Detail__c> obj2 = new List<SCMC__Pick_list_Detail__c>([SELECT Custom_Item_Number__c, Item_Name__c,Transfer_Request_Number__c,SCMC__Issueing_Warehouse__c, SCMC__Inventory_Detail__c, Name, SCMC__Picklist__c,SCMC__Purchase_Order_Line_Item__c,SCMC__Quantity__c, SCMC__Sales_Order_Line_Item__c, SCMC__Status__c FROM SCMC__Pick_list_Detail__c WHERE SCMC__Picklist__c In : pickListId]);
        System.debug('picklistdetail are: '+ obj2);
        return obj2;

    }

}