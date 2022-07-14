/**
*   Purpose         :   Test Class for "XtentoSFDCRestResources" apex class
*   Created By      :   Abhinav Sharma
*   Created Date    :   03/15/2022
*   Revision Log    :   v1.0 - Created - 03/15/2022
**/
@isTest
private without sharing class Test_XtentoSFDCRestResources 
{    
    @testSetup
    private static void setup() {}
    
    @isTest
    private static void testDoUpsertsOverSFDCRecordsShouldInsertROAndROLI() 
    {
        XtentoSFDCOrdersResponseWrapper responseObj = new XtentoSFDCOrdersResponseWrapper();
        List<XtentoSFDCOrdersWrapper> wrapperObjList = new List<XtentoSFDCOrdersWrapper>();
        wrapperObjList.add(TestXtentoSFDCRestResourcesDataHelper.createXtentoSFDCOrderWrapper('000142264', '588361', '63303'));
        wrapperObjList.add(TestXtentoSFDCRestResourcesDataHelper.createXtentoSFDCOrderWrapper('000142264', '588364', '2344'));
        
        Test.startTest();
       		String returnResponse = XtentoSFDCRestResources.doUpsertsOverSFDCRecords(JSON.serialize(wrapperObjList), Constants.TABLE_NAME_ORDERS, Constants.OPERATION_TYPE_UPSERT);
        Test.stopTest();
        
        List<XtentoSFDCOrdersResponseWrapper> responseWrapperList = (List<XtentoSFDCOrdersResponseWrapper>) JSON.deserialize(returnResponse, List<XtentoSFDCOrdersResponseWrapper>.class);
        System.assertEquals(true, !responseWrapperList.isEmpty(), 'Response is empty.');
        System.assertEquals(2, responseWrapperList.size(), 'Response list size is not 2.');
    }
    
    @isTest
    private static void testDoUpsertsOverSFDCRecordsShouldNotInsertROAndROLIWhenInvalidData() 
    {
        List<XtentoSFDCOrdersWrapper> wrapperObjList = new List<XtentoSFDCOrdersWrapper>();
        wrapperObjList.add(TestXtentoSFDCRestResourcesDataHelper.createXtentoSFDCOrderWrapper('000142264', '588361', '63303'));
        wrapperObjList.add(TestXtentoSFDCRestResourcesDataHelper.createXtentoSFDCOrderWrapper('000142264', '588364', '2344'));
        
        Test.startTest();
        	String returnResponse = XtentoSFDCRestResources.doUpsertsOverSFDCRecords(null, Constants.TABLE_NAME_PRODUCTS, Constants.OPERATION_TYPE_UPSERT);
        Test.stopTest();
        
        List<XtentoSFDCProductResponseWrapper> responseWrapperList = (List<XtentoSFDCProductResponseWrapper>) JSON.deserialize(returnResponse, List<XtentoSFDCProductResponseWrapper>.class);
        System.assertEquals(true, responseWrapperList.isEmpty(), 'Response is empty.');
        System.assertEquals(0, responseWrapperList.size(), 'Response list size is not 0.');
    }
    
    @isTest
    private static void testDoUpsertsOverSFDCRecordsShouldNotInsertROAndROLIWhenInvalidTableName() 
    {
        List<XtentoSFDCOrdersWrapper> wrapperObjList = new List<XtentoSFDCOrdersWrapper>();
        wrapperObjList.add(TestXtentoSFDCRestResourcesDataHelper.createXtentoSFDCOrderWrapper('000142264', '588361', '63303'));
        wrapperObjList.add(TestXtentoSFDCRestResourcesDataHelper.createXtentoSFDCOrderWrapper('000142264', '588364', '2344'));
        
        Test.startTest();
        	String returnResponse = XtentoSFDCRestResources.doUpsertsOverSFDCRecords(JSON.serialize(wrapperObjList), Constants.TABLE_NAME_ORDERS, 'Invalid');
        Test.stopTest();
        
        List<XtentoSFDCOrdersResponseWrapper> responseWrapperList = (List<XtentoSFDCOrdersResponseWrapper>) JSON.deserialize(returnResponse, List<XtentoSFDCOrdersResponseWrapper>.class);
        System.assertEquals(true, !responseWrapperList.isEmpty(), 'Response is empty.');
        System.assertEquals(1, responseWrapperList.size(), 'Response list size is not 1.');
    }
    
    @isTest
    private static void testDoUpsertsOverSFDCRecordsShouldNotInsertROAndROLIWhenInvalidOperationName() 
    {
        List<XtentoSFDCOrdersWrapper> wrapperObjList = new List<XtentoSFDCOrdersWrapper>();
        wrapperObjList.add(TestXtentoSFDCRestResourcesDataHelper.createXtentoSFDCOrderWrapper('000142264', '588361', '63303'));
        wrapperObjList.add(TestXtentoSFDCRestResourcesDataHelper.createXtentoSFDCOrderWrapper('000142264', '588364', '2344'));
        
        Test.startTest();
        	String returnResponse = XtentoSFDCRestResources.doUpsertsOverSFDCRecords(JSON.serialize(wrapperObjList), 'Invalid', Constants.OPERATION_TYPE_UPSERT);
        Test.stopTest();
        
        List<XtentoSFDCOrdersResponseWrapper> responseWrapperList = (List<XtentoSFDCOrdersResponseWrapper>) JSON.deserialize(returnResponse, List<XtentoSFDCOrdersResponseWrapper>.class);
        System.assertEquals(true, !responseWrapperList.isEmpty(), 'Response is empty.');
        System.assertEquals(1, responseWrapperList.size(), 'Response list size is not 1.');
    }
    
    @isTest
    private static void testDoUpsertsOverSFDCRecordsShouldNotInsertROWhenRefundQuantityIsNotNull() 
    {
        List<XtentoSFDCOrdersWrapper> wrapperObjList = new List<XtentoSFDCOrdersWrapper>();
      	XtentoSFDCOrdersWrapper wrapper1 = TestXtentoSFDCRestResourcesDataHelper.createXtentoSFDCOrderWrapper('000142264', '588361', '63303');
        wrapper1.Qty_Refunded = '1';
        wrapperObjList.add(wrapper1);
        wrapperObjList.add(TestXtentoSFDCRestResourcesDataHelper.createXtentoSFDCOrderWrapper('000142264', '588364', '2344'));
        
        Test.startTest();
        	String returnResponse = XtentoSFDCRestResources.doUpsertsOverSFDCRecords(JSON.serialize(wrapperObjList), Constants.TABLE_NAME_ORDERS, Constants.OPERATION_TYPE_UPSERT);
        Test.stopTest();
        
        List<XtentoSFDCOrdersResponseWrapper> responseWrapperList = (List<XtentoSFDCOrdersResponseWrapper>) JSON.deserialize(returnResponse, List<XtentoSFDCOrdersResponseWrapper>.class);
        System.assertEquals(true, !responseWrapperList.isEmpty(), 'Response is empty.');
        System.assertEquals(2, responseWrapperList.size(), 'Response list size is not 2.');
    }
    
    @isTest
    private static void testDoUpsertsOverSFDCRecordsShouldNotInsertROLIWhenQuantityIsNotNumeric() 
    {
        List<XtentoSFDCOrdersWrapper> wrapperObjList = new List<XtentoSFDCOrdersWrapper>();
      	XtentoSFDCOrdersWrapper wrapper1 = TestXtentoSFDCRestResourcesDataHelper.createXtentoSFDCOrderWrapper('000142264', '588361', '63303');
        wrapper1.Item_Quantity = 'ABC';
        wrapperObjList.add(wrapper1);
        wrapperObjList.add(TestXtentoSFDCRestResourcesDataHelper.createXtentoSFDCOrderWrapper('000142264', '588364', '2344'));
        
        Test.startTest();
        	String returnResponse = XtentoSFDCRestResources.doUpsertsOverSFDCRecords(JSON.serialize(wrapperObjList), Constants.TABLE_NAME_ORDERS, Constants.OPERATION_TYPE_UPSERT);
        Test.stopTest();
        
        List<XtentoSFDCOrdersResponseWrapper> responseWrapperList = (List<XtentoSFDCOrdersResponseWrapper>) JSON.deserialize(returnResponse, List<XtentoSFDCOrdersResponseWrapper>.class);
        System.assertEquals(true, !responseWrapperList.isEmpty(), 'Response is empty.');
        System.assertEquals(2, responseWrapperList.size(), 'Response list size is not 2.');
    }
    
    @isTest
    private static void testDoUpsertsOverSFDCRecordsShouldNotInsertROAndROLIWhenOrderIdAndLineIdIsBlank() 
    {
        List<XtentoSFDCOrdersWrapper> wrapperObjList = new List<XtentoSFDCOrdersWrapper>();
        wrapperObjList.add(TestXtentoSFDCRestResourcesDataHelper.createXtentoSFDCOrderWrapper('', '', ''));
        
        Test.startTest();
        	String returnResponse = XtentoSFDCRestResources.doUpsertsOverSFDCRecords(JSON.serialize(wrapperObjList), Constants.TABLE_NAME_ORDERS, Constants.OPERATION_TYPE_UPSERT);
        Test.stopTest();
        
        List<XtentoSFDCOrdersResponseWrapper> responseWrapperList = (List<XtentoSFDCOrdersResponseWrapper>) JSON.deserialize(returnResponse, List<XtentoSFDCOrdersResponseWrapper>.class);
        System.assertEquals(true, !responseWrapperList.isEmpty(), 'Response is empty.');
        System.assertEquals(1, responseWrapperList.size(), 'Response list size is not 1.');
    }
    
    @isTest
    private static void testDoUpsertsOverSFDCRecordsShouldInsertROAndROLIWhenGiftCardAndCouponApplied() 
    {
        List<XtentoSFDCOrdersWrapper> wrapperObjList = new List<XtentoSFDCOrdersWrapper>();
        XtentoSFDCOrdersWrapper wrapper1 = TestXtentoSFDCRestResourcesDataHelper.createXtentoSFDCOrderWrapper('000142264', '588361', '63303');
        wrapper1.Order_Total_Amount_without_Tax = '67.5';
        wrapper1.Order_Total_Amount = '67.50';
        wrapper1.Item_Product_Current_Price = '95.00';
        wrapper1.GiftCard = '-25.00';
        wrapper1.Gift_Card_Code = 'Gift Card (TGTJJ-6X)';
        wrapper1.Coupon_Rule = '4%off on second order';
        wrapper1.Coupon_Code = '4%off';
        wrapper1.Coupon_Amount = '-9.50';
        
        XtentoSFDCOrdersWrapper wrapper2 = TestXtentoSFDCRestResourcesDataHelper.createXtentoSFDCOrderWrapper('000142264', '588364', '2344');
        wrapper2.Order_Total_Amount_without_Tax = '67.5';
        wrapper2.Order_Total_Amount = '67.50';
        wrapper2.Item_Product_Current_Price = '95.00';
        wrapper2.GiftCard = '-25.00';
        wrapper2.Gift_Card_Code = 'Gift Card (TGTJJ-6X)';
        wrapper2.Coupon_Rule = '4%off on second order';
        wrapper2.Coupon_Code = '4%off';
        wrapper2.Coupon_Amount = '-9.50';
        wrapperObjList.add(wrapper1);
        wrapperObjList.add(wrapper2);
        
        Test.startTest();
        	String returnResponse = XtentoSFDCRestResources.doUpsertsOverSFDCRecords(JSON.serialize(wrapperObjList), Constants.TABLE_NAME_ORDERS, Constants.OPERATION_TYPE_UPSERT);
        Test.stopTest();
        
        List<XtentoSFDCOrdersResponseWrapper> responseWrapperList = (List<XtentoSFDCOrdersResponseWrapper>) JSON.deserialize(returnResponse, List<XtentoSFDCOrdersResponseWrapper>.class);
        System.assertEquals(true, !responseWrapperList.isEmpty(), 'Response is empty.');
        System.assertEquals(2, responseWrapperList.size(), 'Response list size is not 2.');
    }
    
    @isTest
    private static void testDoUpsertsOverSFDCRecordsShouldNotInsertROAndROLIWhenOrderSourceIsNotMagento() 
    {
        List<XtentoSFDCOrdersWrapper> wrapperObjList = new List<XtentoSFDCOrdersWrapper>();
        XtentoSFDCOrdersWrapper wrapper1 = TestXtentoSFDCRestResourcesDataHelper.createXtentoSFDCOrderWrapper('000142264', '588361', '63303');
        XtentoSFDCOrdersWrapper wrapper2 = TestXtentoSFDCRestResourcesDataHelper.createXtentoSFDCOrderWrapper('000142264', '588361', '63303');
        wrapper1.Order_Source = 'Woo';
        wrapper2.Order_Source = 'Woo';
        wrapperObjList.add(wrapper1);
        wrapperObjList.add(wrapper2);
        
        Test.startTest();
        	String returnResponse = XtentoSFDCRestResources.doUpsertsOverSFDCRecords(JSON.serialize(wrapperObjList), Constants.TABLE_NAME_ORDERS, Constants.OPERATION_TYPE_UPSERT);
        Test.stopTest();
        
        List<XtentoSFDCOrdersResponseWrapper> responseWrapperList = (List<XtentoSFDCOrdersResponseWrapper>) JSON.deserialize(returnResponse, List<XtentoSFDCOrdersResponseWrapper>.class);
        System.assertEquals(true, !responseWrapperList.isEmpty(), 'Response is empty.');
        System.assertEquals(2, responseWrapperList.size(), 'Response list size is not 2.');
    }
    
    @isTest
    private static void testDoUpsertsOverSFDCRecordsShouldInsertInventory() 
    {
        XtentoSFDCProductResponseWrapper responseObj = new XtentoSFDCProductResponseWrapper();
        List<XtentoSFDCProductWrapper> wrapperObjList = new List<XtentoSFDCProductWrapper>();
        wrapperObjList.add(
            TestXtentoSFDCRestResourcesDataHelper.createXtentoSFDCProductWrapper(
                '1610065-XS', 'RebelLevel Long Sleeve Tee-XS', '1', '20', '80'));
        wrapperObjList.add(
            TestXtentoSFDCRestResourcesDataHelper.createXtentoSFDCProductWrapper(
                '1602298-YS', 'RebelFlawlessSportsBra-YS', '2', '27', '50'));
        
        Test.startTest();
        	String returnResponse = XtentoSFDCRestResources.doUpsertsOverSFDCRecords(JSON.serialize(wrapperObjList), Constants.TABLE_NAME_PRODUCTS, Constants.OPERATION_TYPE_UPSERT);
        Test.stopTest();
        
        List<XtentoSFDCProductResponseWrapper> responseWrapperList = (List<XtentoSFDCProductResponseWrapper>) JSON.deserialize(returnResponse, List<XtentoSFDCProductResponseWrapper>.class);
        System.assertEquals(true, responseWrapperList.isEmpty(), 'Response is not empty.');
        System.assertEquals(0, responseWrapperList.size(), 'Response list size is not 0.');
    }
    
    @isTest
    private static void testDoUpsertsOverSFDCRecordsShouldNotInsertInventoryWhenInalidData() 
    {
        List<XtentoSFDCProductWrapper> wrapperObjList = new List<XtentoSFDCProductWrapper>();
        wrapperObjList.add(
            TestXtentoSFDCRestResourcesDataHelper.createXtentoSFDCProductWrapper(
                '1610065-XS', 'RebelLevel Long Sleeve Tee-XS', '1', '20', '80'));
        wrapperObjList.add(
            TestXtentoSFDCRestResourcesDataHelper.createXtentoSFDCProductWrapper(
                '1602298-YS', 'RebelFlawlessSportsBra-YS', '2', '27', '50'));
        
        Test.startTest();
        	String returnResponse = XtentoSFDCRestResources.doUpsertsOverSFDCRecords(null, Constants.TABLE_NAME_ORDERS, Constants.OPERATION_TYPE_UPSERT);
        Test.stopTest();
        
        List<XtentoSFDCOrdersResponseWrapper> responseWrapperList = (List<XtentoSFDCOrdersResponseWrapper>) JSON.deserialize(returnResponse, List<XtentoSFDCOrdersResponseWrapper>.class);
        System.assertEquals(true, !responseWrapperList.isEmpty(), 'Response is empty.');
        System.assertEquals(1, responseWrapperList.size(), 'Response list size is not 1.');
    }
    
    @isTest
    private static void testXtentoSFDCProductResponseWrapper() 
    {
        XtentoSFDCProductWrapper pw = new XtentoSFDCProductWrapper();
        pw.Sku = 'Test';
        
        Test.startTest();
        	XtentoSFDCProductResponseWrapper prw = new XtentoSFDCProductResponseWrapper(pw, 'test', null);
        Test.stopTest();
        
        System.assertEquals(true, prw != null, 'Response is empty.');
    }
}