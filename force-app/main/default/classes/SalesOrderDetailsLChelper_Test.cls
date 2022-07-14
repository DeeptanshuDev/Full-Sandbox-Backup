/** 
* 
* Description : Test class for SalesOrderDetailsLChelper class.
* 
* Created By : Deeptanshu Bharti
* 
* Created Date : 05/13/2022 
* 
* Revision Logs : V1.0 - Created - Deeptanshu Bharti 
* 
**/
 
@isTest (seeAllData=false)
public class SalesOrderDetailsLChelper_Test {
    
    
    /**
    *
    * @description : Test method for salesOrderDetailsLChelper class
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 05/13/2022  - Deeptanshu Bharti
    *
    * coverage : 81%
    *
    **/
    
    
    //making a class
    static testMethod void myFirstMethod_Test()
    {
        Account acc = TestData.account(true);
        Opportunity opp = TestData.opportunity(new Opportunity(AccountId = acc.Id),true);
        SCMC__Currency_Master__c cm = new SCMC__Currency_Master__c(SCMC__Active__c = true, SCMC__Corporate_Currency__c = true, SCMC__Number_of_decimals__c = 2);
        insert cm;
        SCMC__Sales_Order__c so = new SCMC__Sales_Order__c(SCMC__Sales_Order_Date__c = Date.today(), Opportunity__c = opp.Id, SCMC__Currency__c = cm.Id,Order_Type__c = 'Reorder', SCMC__Customer_Account__c = acc.Id);
        insert so;
        SCMC__Item__c it = new SCMC__Item__c(Name  = 'Test', SCMC__Item_Description__c = 'tesing new');
        insert it;
        
        SCMC__Sales_Order_Line_Item__c so1 = new SCMC__Sales_Order_Line_Item__c(SCMC__Sales_Order__c = so.Id, SCMC__Item_Master__c = it.Id, SCMC__Quantity__c = 4, SCMC__Price__c = 5);
        insert so1;
        
        SCMC__Shipping__c sh =new SCMC__Shipping__c(SCMC__Sales_Order__c = so.Id);
        insert sh;
        
        SCMC__Picklist__c pl = new SCMC__Picklist__c(SCMC__Sales_Order__c = so.Id,SCMC__Shipper__c=sh.Id);
        insert pl;
        
        SCMC__Pick_list_Detail__c plDl = new SCMC__Pick_list_Detail__c(SCMC__Picklist__c = pl.Id,SCMC__Sales_Order_Line_Item__c=so1.Id);
        insert plDl;
        
        SCMC__Invoicing__c inV = new SCMC__Invoicing__c(SCMC__Sales_Order__c = so.Id);
        insert inV;
        
        Non_Inventory_Item__c nonIn = new Non_Inventory_Item__c(SO__c = so.Id,Opportunity__c=opp.Id);
        insert nonIn;
        
        
        SCMC__Inventory_Action_Queue__c iAQ = new SCMC__Inventory_Action_Queue__c(SCMC__Picklist__c = pl.Id,SCMC__Action__c='Ship Material to Customer');
        insert iAQ;
        
        
        Test.startTest();
        List<SCMC__Sales_Order__c> listOfSo = SalesOrderDetailsLChelper.getSalesOrder(opp.Id);
        System.assertEquals(so.Id, listOfSo[0].Id);
        
        SCMC__Sales_Order__c saOr = [SELECT Id, Name From SCMC__Sales_Order__c LIMIT 1];
        List<SCMC__Sales_Order__c> listOfSo1 = SalesOrderDetailsLChelper.getSalesOrderdisplay(saOr.Id);
        System.assertEquals(so.Id, listOfSo1[0].Id);
        
        List<SCMC__Shipping__c> listOfSh = SalesOrderDetailsLChelper.getShipping(saOr.Id);
        System.assertEquals(sh.Id, listOfSh[0].Id);
        
        List<SCMC__Shipping__c> listOfSh1 = SalesOrderDetailsLChelper.getdisplayShipping(sh.Id);
        System.assertEquals(sh.Id, listOfSh1[0].Id);
        
        List<SCMC__Picklist__c> listOfPl = SalesOrderDetailsLChelper.getPicklist(sh.Id);
        System.assertEquals(pl.Id, listOfPl[0].Id);
        
        List<SCMC__Picklist__c> listOfPl1 = SalesOrderDetailsLChelper.getPicklistdisplay(pl.Id);
        System.assertEquals(pl.Id, listOfPl1[0].Id);
        
        List<SCMC__Pick_list_Detail__c> listOfPlDi = SalesOrderDetailsLChelper.getPicklistDetail(so1.Id);
        System.assertEquals(plDl.Id, listOfPlDi[0].Id);
        
        List<SCMC__Pick_list_Detail__c> listOfPlDi1 = SalesOrderDetailsLChelper.getPicklistDetaildisplay(plDl.Id);
        System.assertEquals(plDl.Id, listOfPlDi1[0].Id);
        
        List<SCMC__Invoicing__c> listOfIn = SalesOrderDetailsLChelper.getIn(so.Id);
        System.debug('pl is L: ' + plDl);
        System.debug('listOfPl is : '  + listOfIn);
        System.assertEquals(inV.Id, listOfIn[0].Id);
        
        List<c2g__codaInvoice__c> listOfSaIn = SalesOrderDetailsLChelper.getSI(so.Id);
        
        List<Non_Inventory_item__c> listOfNi = SalesOrderDetailsLChelper.getNonInvenItem(so.Id);
        System.assertEquals(nonIn.Id, listOfNi[0].Id);
        
        List<Non_Inventory_item__c> listOfNi1 = SalesOrderDetailsLChelper.getNonInvenItemdisplay(nonIn.Id);
        System.assertEquals(nonIn.Id, listOfNi1[0].Id);
        
        List<SCMC__Sales_Order_Line_Item__c> listOfSoLi = SalesOrderDetailsLChelper.getSOLI(so.Id);
        System.assertEquals(so1.Id, listOfSoLi[0].Id);
        
        List<SCMC__Sales_Order_Line_Item__c> listOfSoLi1 = SalesOrderDetailsLChelper.getSOLIdisplay(so1.Id);
        System.assertEquals(so1.Id, listOfSoLi1[0].Id);
        
        so.SCMC__Shipment_Status__c = 'Partially Shipped';
        so.SCMC__Billed_Status__c = 'Partially Billed';
        update so;
        
        List<SCMC__Sales_Order__History> listOfSoHi = SalesOrderDetailsLChelper.getSOH(so.Id);
        
        List<SalesOrderDetailsLChelper.salesOrderHistoryWrapper> soHiWrapperList = SalesOrderDetailsLChelper.getSOHdisplay(so.Id);
        
        List<SCMC__Invoicing__c> soIn = SalesOrderDetailsLChelper.getSalesOrderInvoice(so.Id);
        System.assertEquals(inV.Id, soIn[0].Id);
        
        List<SCMC__Invoicing__c> soIn1 = SalesOrderDetailsLChelper.getSalesOrderInvoicedisplay(inV.Id);
        System.assertEquals(inV.Id, soIn[0].Id);
        
        List<c2g__codaInvoice__c> saIn = SalesOrderDetailsLChelper.getSalesInvoice(inV.Id);
        
        List<SCMC__Inventory_Action_Queue__c> listOfIAQ = SalesOrderDetailsLChelper.getInventoryActionQueue(pl.Id);
        System.assertEquals(iAQ.Id, listOfIAQ[0].Id);
        
        List<SalesOrderDetailsLChelper.inventoryActionQueueWrapper> iaqHiWrapperList = SalesOrderDetailsLChelper.getInventoryActionQueuedisplay(iAQ.Id);

        Test.stopTest();
    }

}