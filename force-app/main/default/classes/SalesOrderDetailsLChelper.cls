public without sharing class SalesOrderDetailsLChelper {
    
    @AuraEnabled
    public static List<SCMC__Sales_Order__c> getSalesOrder(Id oppId){
        List<SCMC__Sales_Order__c> listOfSo = new List<SCMC__Sales_Order__c>();
        for(SCMC__Sales_Order__c oCon : [SELECT Id, Name From SCMC__Sales_Order__c WHERE Opportunity__c =: oppId]){
            listOfSo.add(oCon); 
        }
        return listOfSo;
    }
    
    @AuraEnabled
    public static List<SCMC__Sales_Order__c> getSalesOrderdisplay(Id sid){
        List<SCMC__Sales_Order__c> listOfSo = new List<SCMC__Sales_Order__c>();
        for(SCMC__Sales_Order__c oCon : [SELECT Id, Name,SCMC__Shipment_Status__c,
                                         SCMC__Partial_Shipments__c,Carrier__c,Carrier_Service__c,SCMC__Total_Value__c,
                                         SCMC__Total_Open_Value__c,Commission_Amount__c,Total_Percentage_Paid__c,
                                         Deposit_Amount_Paid__c,Remaining_Payment_Balance__c,SCMAVA__Total_Tax__c,
                                         SCMC__Customer_Purchase_Order__c From SCMC__Sales_Order__c WHERE Id =: sid]){
            listOfSo.add(oCon); 
        }
        return listOfSo;
    }
    
    @AuraEnabled
    public static List<SCMC__Shipping__c> getShipping(String sid){
        List<SCMC__Shipping__c> listOfShipping = new List<SCMC__Shipping__c> ();
        for(SCMC__Shipping__c obj : [SELECT Id, Name, SCMC__Status__c FROM SCMC__Shipping__c WHERE SCMC__Sales_Order__c =: sid])
        {
            listOfShipping.add(obj);
        }
        return listOfShipping;                              
    }
    
    @AuraEnabled
    public static List<SCMC__Shipping__c> getdisplayShipping(String sId){
        List<SCMC__Shipping__c> listOfShipping = new List<SCMC__Shipping__c> ();
        for(SCMC__Shipping__c obj : [SELECT Id, Name, SCMC__Status__c,SCMC__Carrier__c,SCMC__Carrier_Tracking_Number__c,SCMC__Carrier_Service__c,SCMC__Number_of_Boxes__c,SCMC__Shipment_Date_Time__c,SCMC__Picklist__c,SCMC__Picklist__r.Name,SCMC__Picklist__r.Drop_Bulk_Address__c FROM SCMC__Shipping__c WHERE Id =: sId])
        {
            listOfShipping.add(obj);
        }
        return listOfShipping;                               
    }

    @AuraEnabled
    public static List<SCMC__Picklist__c> getPicklist(String sid){
        List<SCMC__Picklist__c> listOfPicklist = new List<SCMC__Picklist__c> ();
        for(SCMC__Picklist__c obj : [SELECT Id, Name, SCMC__Status__c FROM SCMC__Picklist__c WHERE SCMC__Shipper__c =: sid])
        {
            listOfPicklist.add(obj);
        }
        return listOfPicklist;                                     
    }
    
    @AuraEnabled
    public static List<SCMC__Picklist__c> getPicklistdisplay(String sid){
        List<SCMC__Picklist__c> listOfPicklist = new List<SCMC__Picklist__c> ();
        for(SCMC__Picklist__c obj : [SELECT Id, Name, SCMC__Status__c,Drop_Bulk_Address__c FROM SCMC__Picklist__c WHERE Id =: sid])
        {
            listOfPicklist.add(obj);
        }
        return listOfPicklist;                                     
    }
    
    @AuraEnabled
    public static List<SCMC__Pick_list_Detail__c> getPicklistDetail(String sid){
        List<SCMC__Pick_list_Detail__c> listOfPicklistDetail = new List<SCMC__Pick_list_Detail__c> ();
        for(SCMC__Pick_list_Detail__c obj : [SELECT Id, Name,SCMC__Item__c,SCMC__Item__r.Name,SCMC__Quantity__c,SCMC__Status__c,SCMC__Picklist__c,SCMC__Picklist__r.Name FROM SCMC__Pick_list_Detail__c WHERE SCMC__Sales_Order_Line_Item__c =: sid])
        {
            listOfPicklistDetail.add(obj);
        }
        return listOfPicklistDetail;                           
    }
    
    @AuraEnabled
    public static List<SCMC__Pick_list_Detail__c> getPicklistDetaildisplay(String sid){
        List<SCMC__Pick_list_Detail__c> listOfPicklistDetail = new List<SCMC__Pick_list_Detail__c> ();
        for(SCMC__Pick_list_Detail__c obj : [SELECT Id, Name,SCMC__Item__c,Item_Name__c,SCMC__Issueing_Warehouse__c,SCMC__Item__r.Name,SCMC__Quantity__c,SCMC__Status__c,SCMC__Picklist__c,SCMC__Picklist__r.Name FROM SCMC__Pick_list_Detail__c WHERE Id =: sid])
        {
            listOfPicklistDetail.add(obj);
        }
        return listOfPicklistDetail;                           
    }
    
    @AuraEnabled
    public static List<SCMC__Invoicing__c> getIn(String sid){
        List<SCMC__Invoicing__c> listOfPicklist = new List<SCMC__Invoicing__c> ();
        for(SCMC__Invoicing__c obj : [SELECT Id, Name, SCMC__Status__c,SCMC__Total_Invoice__c,Deposit_Amount__c FROM SCMC__Invoicing__c WHERE SCMC__Sales_Order__c =: sid])
        {
            listOfPicklist.add(obj); 
        }
        return listOfPicklist;                                
    }

    @AuraEnabled
    public static List<c2g__codaInvoice__c> getSI(String sid){
        List<c2g__codaInvoice__c> listOfPicklist = new List<c2g__codaInvoice__c> ();
        for(c2g__codaInvoice__c obj : [SELECT Id, Name, c2g__InvoiceStatus__c,Latest_Document_Created_Date__c,Subtotal__c,c2g__InvoiceTotal__c FROM c2g__codaInvoice__c WHERE Sales_Order__c =: sid])
        {
            listOfPicklist.add(obj);
        }
        return listOfPicklist;                             
    }
    
    @AuraEnabled
    public static List<Non_Inventory_item__c> getNonInvenItem(String sid){
        List<Non_Inventory_item__c> listOfNiI = new List<Non_Inventory_item__c>();
        for(Non_Inventory_item__c obj : [SELECT Id, Name,PackageTrackingNumber__c,Non_Inventory__c FROM Non_Inventory_item__c WHERE SO__c =: sid])
        {
            listOfNiI.add(obj);
        }
        return listOfNiI;                                     
    }
    
    @AuraEnabled
    public static List<Non_Inventory_item__c> getNonInvenItemdisplay(String sid){
        List<Non_Inventory_item__c> listOfNiI = new List<Non_Inventory_item__c>();
        for(Non_Inventory_item__c obj : [SELECT Id, Name,PackageTrackingNumber__c,Non_Inventory__c,ShipToAddress1__c,ShipToAddress2__c,ShipToAttention__c,ShipToCityorTown__c,ShipToCompanyorName__c,ShipToCountryTerritory__c,ShipToStateProvinceCounty__c FROM Non_Inventory_item__c WHERE Id =: sid])
        {
            listOfNiI.add(obj);
        }
        return listOfNiI;                                     
    }
    
    @AuraEnabled
    public static List<SCMC__Sales_Order_Line_Item__c> getSOLI(String sid){
        List<SCMC__Sales_Order_Line_Item__c> listOfNiI = new List<SCMC__Sales_Order_Line_Item__c>();
        for(SCMC__Sales_Order_Line_Item__c obj : [SELECT Id, Name FROM SCMC__Sales_Order_Line_Item__c WHERE SCMC__Sales_Order__c =: sid])
        {
            listOfNiI.add(obj);
        }
        return listOfNiI;                                     
    }
    
    @AuraEnabled
    public static List<SCMC__Sales_Order_Line_Item__c> getSOLIdisplay(String sid){
        List<SCMC__Sales_Order_Line_Item__c> listOfNiI = new List<SCMC__Sales_Order_Line_Item__c>();
        for(SCMC__Sales_Order_Line_Item__c obj : [SELECT Id, Name,Item__c,Custom_Item_Number__c,SCMC__Status__c,SCMC__Quantity__c,SCMC__Quantity_Shipped__c,SCMC__Extended_Price__c FROM SCMC__Sales_Order_Line_Item__c WHERE Id =: sid])
        {
            listOfNiI.add(obj);
        }
        return listOfNiI;                                     
    }
    
    @AuraEnabled
    public static List<SCMC__Sales_Order__History > getSOH(String sid){
        List<SCMC__Sales_Order__History > listOfNiI = new List<SCMC__Sales_Order__History >();
        for(SCMC__Sales_Order__History  obj : [SELECT Id, parentId,parent.name, IsDeleted,OldValue, NewValue, CreatedDate, DataType, Field FROM SCMC__Sales_Order__History WHERE parentId =: sid])
        {
            System.debug('the value of sohistory is : ' + obj);                
            listOfNiI.add(obj);
        }
        return listOfNiI;                                     
    }
    
    @AuraEnabled
    public static List<salesOrderHistoryWrapper> getSOHdisplay(String sid){ 
        List<SCMC__Sales_Order__History > listOfNiI = new List<SCMC__Sales_Order__History >();
        List<salesOrderHistoryWrapper> listSo = new List<salesOrderHistoryWrapper>();
        
        Map<String, Schema.SObjectField> caseFieldMap = Schema.getGlobalDescribe().get('SCMC__Sales_Order__c').getDescribe().fields.getMap();
        for(SCMC__Sales_Order__History  obj : [SELECT Id, parentId,parent.name, IsDeleted,OldValue,CreatedBy.Name, NewValue, CreatedDate, DataType, Field FROM SCMC__Sales_Order__History WHERE parentId =: sid ORDER BY CreatedDate DESC])
        {
            if(obj.DataType != 'EntityId')
            {
                System.debug('the value of sohistory is : ' + obj); 
                salesOrderHistoryWrapper so = new salesOrderHistoryWrapper();
                so.parentName = obj.CreatedBy.Name;
                string sTime = obj.CreatedDate.format('h:mm a');
                Date myDate = obj.CreatedDate.date();
                String dateStr = myDate.year() + '/' + myDate.month() + '/' + myDate.day();
                dateStr = dateStr +' '+ sTime;
                so.CreatedDate = dateStr;
                String act;
                String fieldlabel = caseFieldMap.get(obj.Field) == null ? 
                    String.valueOf(obj.Field) : caseFieldMap.get(obj.Field).getDescribe().getLabel();
                if(obj.NewValue != NULL)
                {
                    if(fieldlabel != 'Total Tax')
                    {
                        if(obj.OldValue!=NULL)
                        {
                            act = 'Changed '+fieldlabel+' '+'from '+obj.OldValue+' to '+obj.NewValue+'.'; 
                        }
                        else
                        {
                            act = 'Changed '+fieldlabel+' to '+obj.NewValue+'.'; 
                        }
                    }
                    else
                    {
                        //System.assert(false,obj.NewValue);
                        if(obj.OldValue!=NULL)
                        {
                            act = 'Changed '+fieldlabel+' '+'from $'+obj.OldValue+' to $'+obj.NewValue+'.'; 
                        }
                        else
                        {
                            act = 'Changed '+fieldlabel+' to $'+obj.NewValue+'.'; 
                        }
                    }
                    
                }else{
                    act = 'Created.';
                }
                
                so.action = act;
                listOfNiI.add(obj);
                listSo.add(so);
                
            }
            
        }
        //return listOfNiI;  
        return listSo;                                     
    }
    
    @AuraEnabled
    public static List<SCMC__Invoicing__c> getSalesOrderInvoice(Id sId){
        List<SCMC__Invoicing__c> listOfSo = new List<SCMC__Invoicing__c>();
        for(SCMC__Invoicing__c oCon : [SELECT Id, Name,SCMC__Invoice_Date__c,SCMC__Status__c,Payment_Status__c From SCMC__Invoicing__c WHERE SCMC__Sales_Order__c =: sId]){
            listOfSo.add(oCon); 
        }
        
        return listOfSo;
    } 
    
    @AuraEnabled
    public static List<SCMC__Invoicing__c> getSalesOrderInvoicedisplay(Id sId){
        List<SCMC__Invoicing__c> listOfSo = new List<SCMC__Invoicing__c>();
        for(SCMC__Invoicing__c oCon : [SELECT Id, Name,SCMC__Invoice_Date__c,SCMC__Status__c,Payment_Status__c From SCMC__Invoicing__c WHERE Id =: sId]){
            listOfSo.add(oCon); 
        }
        
        return listOfSo;
    } 
    
    @AuraEnabled
    public static List<c2g__codaInvoice__c> getSalesInvoice(Id sId){
        List<c2g__codaInvoice__c> listOfSo = new List<c2g__codaInvoice__c>();
        for(c2g__codaInvoice__c oCon : [SELECT Id,c2g__AccountName__c,Latest_Document_Created_Date__c, c2g__CompanyReference__c, Convenience_Fee__c,c2g__DueDate__c,Subtotal__c,c2g__InvoiceTotal__c, c2g__InvoiceDate__c, Name, c2g__InvoiceStatus__c From c2g__codaInvoice__c WHERE SCMFFA__SCM_Invoice__c =: sId]){
            listOfSo.add(oCon); 
        }
        
        return listOfSo;
    } 
    
    @AuraEnabled
    public static List<c2g__codaInvoice__c> getSalesInvoicedisplay(Id sId){
        List<c2g__codaInvoice__c> listOfSo = new List<c2g__codaInvoice__c>();
        for(c2g__codaInvoice__c oCon : [SELECT Id,CreatedDate,c2g__AccountName__c,Latest_Document_Created_Date__c, c2g__CompanyReference__c, Convenience_Fee__c,c2g__DueDate__c,Subtotal__c,c2g__InvoiceTotal__c, c2g__InvoiceDate__c, Name, c2g__InvoiceStatus__c From c2g__codaInvoice__c WHERE Id =: sId]){
            listOfSo.add(oCon); 
        }
        
        return listOfSo;
    }
    
    @AuraEnabled
    public static List<SCMC__Inventory_Action_Queue__c> getInventoryActionQueue(Id pId){
        System.debug('pidd is  : '   + pId);
        List<SCMC__Inventory_Action_Queue__c> listOfiaq = new List<SCMC__Inventory_Action_Queue__c>();
        for(SCMC__Inventory_Action_Queue__c obj : [SELECT Id, Name,LastModifiedBy.FirstName,CreatedDate,SCMC__Action__c, SCMC__Picklist__c FROM SCMC__Inventory_Action_Queue__c WHERE SCMC__Picklist__c =: pId AND SCMC__Action__c = 'Ship Material to Customer'])
        {
            System.debug('value of iaq is  : ' + obj);
            listOfiaq.add(obj);
        }
        
        return listOfiaq;
    }
    
    @AuraEnabled
    public static List<inventoryActionQueueWrapper> getInventoryActionQueuedisplay(Id pId){
        System.debug('pidd is  : '   + pId);
        List<SCMC__Inventory_Action_Queue__c> listOfiaq = new List<SCMC__Inventory_Action_Queue__c>();
        List<inventoryActionQueueWrapper> listIA = new List<inventoryActionQueueWrapper>();
        for(SCMC__Inventory_Action_Queue__c obj : [SELECT Id, Name,CreatedDate,LastModifiedBy.Name,SCMC__Action__c, SCMC__Picklist__c FROM SCMC__Inventory_Action_Queue__c WHERE Id =: pId])
        {
            System.debug('value of iaq is  : ' + obj);
            inventoryActionQueueWrapper so = new inventoryActionQueueWrapper();
            so.createdDate = obj.CreatedDate;
            so.action = obj.SCMC__Action__c;
            so.lastModifiedBy = obj.LastModifiedBy.Name;
            listIA.add(so);
            //listOfiaq.add(obj);
        }
        //return listOfiaq;
        return listIA;
    }
    
    
    public class salesOrderHistoryWrapper
    {
        @AuraEnabled public String objectName;
        @AuraEnabled public String recordName;
        @AuraEnabled public String fieldAPIName;
        @AuraEnabled public String fieldLabel;
        @AuraEnabled public String oldValue;
        @AuraEnabled public String newValue;
        @AuraEnabled public String CreatedDate;
        @AuraEnabled public String createdById;
        @AuraEnabled public String createdByName;
        @AuraEnabled public String customText;
        @AuraEnabled public String parentName;
        @AuraEnabled public String action;
    }
    
    public class inventoryActionQueueWrapper
    {
        @AuraEnabled public DateTime createdDate;
        @AuraEnabled public String action;
        @AuraEnabled public String lastModifiedBy;
    }
    
}