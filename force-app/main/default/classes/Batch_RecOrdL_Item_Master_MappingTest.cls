@isTest
private class Batch_RecOrdL_Item_Master_MappingTest {
    //Setup method to create the test data
    @testSetup static void testSetup() {
        
        List<SCMC__Item__c> items = new List<SCMC__Item__c>();
        items.add(new SCMC__Item__c(Name = 'PRODUCT_ITEM_01', SCMC__Item_Description__c= 'Item 01'));
        items.add(new SCMC__Item__c(Name = 'PRODUCT_ITEM_02', SCMC__Item_Description__c= 'Item 02'));
        items.add(new SCMC__Item__c(Name = 'PRODUCT_ITEM_03', SCMC__Item_Description__c= 'Item 03'));
        insert items;
        
        List<SCMC__Received_Order__c> receivedOrders = new List<SCMC__Received_Order__c>();
        receivedOrders.add(new SCMC__Received_Order__c(Customer_Name__c = 'CUST_OF_REC_ORD_01',SCMC__Order_Date__c = system.today()));
        insert receivedOrders;
        
        List<SCMC__Received_Order_Line__c> receivedOrderLines = new List<SCMC__Received_Order_Line__c>();
        receivedOrderLines.add(new SCMC__Received_Order_Line__c(SCMC__Received_Order__c = receivedOrders[0].Id, SCMC__Product_Name__c = items[0].Name,Gym_Name__c ='A-Test'));
        receivedOrderLines.add(new SCMC__Received_Order_Line__c(SCMC__Received_Order__c = receivedOrders[0].Id, SCMC__Product_Name__c =items[1].Name));
        receivedOrderLines.add(new SCMC__Received_Order_Line__c(SCMC__Received_Order__c = receivedOrders[0].Id, SCMC__Product_Name__c ='No_Item_Available'));
        insert receivedOrderLines;
    }
    @isTest
    private static void callToBatch_NormalScenario(){
        
        Test.startTest();
        List<SCMC__Received_Order_Line__c> receivedOrderLines1 = [SELECT ID,Item_Master__c FROM SCMC__Received_Order_Line__c];
        receivedOrderLines1[0].Item_Master__c = false;
        update receivedOrderLines1;
        
        Database.executeBatch(new Batch_RecOrdL_Item_Master_Mapping(null,null), 200);
        Test.stopTest();
        
        System.assertEquals(2, [SELECT ID FROM SCMC__Received_Order_Line__c WHERE Item_Master__c = true].size());
        System.assertEquals(1, [SELECT ID FROM SCMC__Received_Order_Line__c WHERE Item_Master__c = false].size());
        
    }
    @isTest
    private static void callToBatch_FilteredRecordsScenario(){
        
        Test.startTest();
        List<SCMC__Received_Order_Line__c> recOrdLines = [SELECT ID FROM SCMC__Received_Order_Line__c LIMIT 2];
        Database.executeBatch(new Batch_RecOrdL_Item_Master_Mapping(null,recOrdLines), 200);
        Test.stopTest();
        
        System.assertEquals(2, [SELECT ID FROM SCMC__Received_Order_Line__c WHERE Item_Master__c = true].size());
        System.assertEquals(1, [SELECT ID FROM SCMC__Received_Order_Line__c WHERE Item_Master__c = false].size());
        
    }
    @isTest
    private static void callToBatch_PredefinedQueryStructure(){
        
        Test.startTest();
        Database.executeBatch(new Batch_RecOrdL_Item_Master_Mapping('SELECT Id, SCMC__Product_Name__c, Item_Master__c From SCMC__Received_Order_Line__c',null), 200);
        Test.stopTest();
        
        System.assertEquals(2, [SELECT ID FROM SCMC__Received_Order_Line__c WHERE Item_Master__c = true].size());
        System.assertEquals(1, [SELECT ID FROM SCMC__Received_Order_Line__c WHERE Item_Master__c = false].size());
        
    }
    @isTest
    private static void callToBatch_Negative(){
        
        Test.startTest();
        try {
            Database.executeBatch(new Batch_RecOrdL_Item_Master_Mapping('SELECT Id, SCMC__Product_Name__c, Item_Master__c From Order_Line__c',null), 200);
        }
        catch (Exception ex) {
                  system.assertEquals(true, ex.getMessage().contains('Mismatching exists')) ;
                }
        
        Test.stopTest();
      
    }
}