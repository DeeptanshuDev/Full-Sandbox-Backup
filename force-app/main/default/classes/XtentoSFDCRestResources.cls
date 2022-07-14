/**
*   Purpose         :   Web Service Class for Talend Sunsetting Project for various jobs
*   Created By      :   Abhinav Sharma
*   Created Date    :   02/15/2022
*   Revision Log    :   v1.0 - Created - 02/15/2022
**/
//Endpoint = https://rebelathletic--talendsfdc.my.salesforce.com/services/apexrest/XtentoSFDCWebServices
@RestResource(urlMapping='/XtentoSFDCWebServices/*')
global without sharing class XtentoSFDCRestResources 
{
    public static Double LOWEST_N_DIGIT_NUMBER = getNDigitPositiveLowestNumber(Constants.MIN_ORDER_ID_LENGTH);
    public static String N_TIMES_ZERO_NUMBER_STRING = getNTimesZeroString(Constants.MIN_ORDER_ID_LENGTH);
    public static String data = '[{"Order_Source":"Magento","Zip_Shipping":"72525","Zip_Billing":"72525","Transaction_Id":"60186876207","Total_Tax_Refunded":"0.00","Total_Shipping_Refunded":"0.00","Total_Refunded":"0.00","Tax_Refunded":"0.00","Subtotal_Refunded":"0.00","State_Name_Shipping":"Texas","State_Name_Billing":"Texas","Shipping_Refunded":"0.00","Shipping_Method_Title":"Flat Rate - Fixed","Qty_Refunded":"0","Phone_Billing":"800784233","Payment_Method_Title":"Credit Card","Order_Total_Tax_Amount":"0.00","Order_Total_Amount_without_Tax":"46.5","Order_Total_Amount":"46.50","Order_Tax_Amount":"0.00","Order_Status":"processing","Order_Shipping_Amount":"7.0000","Order_Id":"000142264","Order_Date":"2022.02.17 01:38:51","Line_Id":"588361","Item_SKU":"RR1433-YM","Item_Quantity":"1","Item_Product_Variation":"Color:Black Size Chart:YM Size:M Shoe Size:","Item_Product_Current_Price":"39.50","Item_Name":"Energy Jogger in Black-YM","Item_Id":"63303","Item_Cost":"0.00","GiftCard":"0.00","Gift_Card_Code":"","Full_Name_Shipping":"Nilesh Dhumal","Full_Name_Billing":"Nilesh Dhumal","Email_Billing":"nilesh.dhumal@fexe.com","Customer_Username":"Nilesh Dhumal","Customer_User_Id":"800784233","Customer_Role":"","Customer_Note":"","Custom_Options":"","Currency_Amt":"USD","Coupon_Rule":"","Coupon_Code":"","Coupon_Amount":"0.00","Country_Name_Shipping":"US","Country_Name_Billing":"US","Completed_Date":"2022.02.17 01:38:51","Company_Shipping":"Fexle","Company_Billing":"Fexle","City_Shipping":"Dallas","City_Billing":"Dallas","Adjustment_Positive":"0.00","Adjustment_Negative":"0.00","Address_2_Shipping":"","Address_2_Billing":"","Address_1_Shipping":"6146 Honey Bluff Parkway","Address_1_Billing":"6146 Honey Bluff Parkwayyyyyyyyyyyyyyyyyyyyy"},' + 
        '{"Order_Source":"Magento","Zip_Shipping":"72525","Zip_Billing":"72525","Transaction_Id":"60186876207","Total_Tax_Refunded":"0.00","Total_Shipping_Refunded":"0.00","Total_Refunded":"0.00","Tax_Refunded":"0.00","Subtotal_Refunded":"0.00","State_Name_Shipping":"Texas","State_Name_Billing":"Texas","Shipping_Refunded":"0.00","Shipping_Method_Title":"Flat Rate - Fixed","Qty_Refunded":"0","Phone_Billing":"800784233","Payment_Method_Title":"Credit Card","Order_Total_Tax_Amount":"0.00","Order_Total_Amount_without_Tax":"46.5","Order_Total_Amount":"46.50","Order_Tax_Amount":"0.00","Order_Status":"processing","Order_Shipping_Amount":"7.0000","Order_Id":"000142264","Order_Date":"2022.02.17 01:38:51","Line_Id":"588364","Item_SKU":"CP0000015WT","Item_Quantity":"1","Item_Product_Variation":"Color:Blue Size Chart: Size:M Shoe Size:","Item_Product_Current_Price":"0.00","Item_Name":"FREE -  Pixie Mini Dream Bag Coin Purse","Item_Id":"2344","Item_Cost":"0.00","GiftCard":"0.00","Gift_Card_Code":"","Full_Name_Shipping":"Nilesh Dhumal","Full_Name_Billing":"Nilesh Dhumal","Email_Billing":"nilesh.dhumal@fexe.com","Customer_Username":"Nilesh Dhumal","Customer_User_Id":"800784233","Customer_Role":"","Customer_Note":"","Custom_Options":"","Currency_Amt":"USD","Coupon_Rule":"","Coupon_Code":"","Coupon_Amount":"0.00","Country_Name_Shipping":"US","Country_Name_Billing":"US","Completed_Date":"2022.02.17 01:38:51","Company_Shipping":"Fexle","Company_Billing":"Fexle","City_Shipping":"Dallas","City_Billing":"Dallas","Adjustment_Positive":"0.00","Adjustment_Negative":"0.00","Address_2_Shipping":"","Address_2_Billing":"","Address_1_Shipping":"6146 Honey Bluff Parkway","Address_1_Billing":"6146 Honey Bluff Parkwayyyyyyyyyyyyyyyyyyyyy"},' + 
        '{"Order_Source":"Magento","Zip_Shipping":"15747-8813","Zip_Billing":"15747-8813","Transaction_Id":"60186909198","Total_Tax_Refunded":"0.00","Total_Shipping_Refunded":"0.00","Total_Refunded":"0.00","Tax_Refunded":"0.00","Subtotal_Refunded":"0.00","State_Name_Shipping":"Pennsylvania","State_Name_Billing":"Pennsylvania","Shipping_Refunded":"0.00","Shipping_Method_Title":"Flat Rate - Fixed","Qty_Refunded":"0","Phone_Billing":"8007834233","Payment_Method_Title":"Credit Card","Order_Total_Tax_Amount":"0.00","Order_Total_Amount_without_Tax":"81","Order_Total_Amount":"81.00","Order_Tax_Amount":"0.00","Order_Status":"processing","Order_Shipping_Amount":"7.0000","Order_Id":"000142267","Order_Date":"2022.02.17 03:47:00","Line_Id":"588370","Item_SKU":"RR1440-YM","Item_Quantity":"1","Item_Product_Variation":"Color:Gray Size Chart:YM Size:M Shoe Size:","Item_Product_Current_Price":"74.00","Item_Name":"Revive Cropped Sleeveless Hoodie-YM","Item_Id":"63537","Item_Cost":"0.00","GiftCard":"0.00","Gift_Card_Code":"","Full_Name_Shipping":"Abinav Sharma","Full_Name_Billing":"Abinav Sharma","Email_Billing":"nilesh.dhumal@fele.com","Customer_Username":"Abinav Sharma","Customer_User_Id":"8007834233","Customer_Role":"","Customer_Note":"","Custom_Options":"","Currency_Amt":"USD","Coupon_Rule":"","Coupon_Code":"","Coupon_Amount":"0.00","Country_Name_Shipping":"US","Country_Name_Billing":"US","Completed_Date":"2022.02.17 03:47:00","Company_Shipping":"Fexle","Company_Billing":"Fexle","City_Shipping":"Home","City_Billing":"Home","Adjustment_Positive":"0.00","Adjustment_Negative":"0.00","Address_2_Shipping":"","Address_2_Billing":"","Address_1_Shipping":"83 Kimmel Rd","Address_1_Billing":"83 Kimmel Rd"},' + 
        '{"Order_Source":"Magento","Zip_Shipping":"15747-8813","Zip_Billing":"15747-8813","Transaction_Id":"60186909198","Total_Tax_Refunded":"0.00","Total_Shipping_Refunded":"0.00","Total_Refunded":"0.00","Tax_Refunded":"0.00","Subtotal_Refunded":"0.00","State_Name_Shipping":"Pennsylvania","State_Name_Billing":"Pennsylvania","Shipping_Refunded":"0.00","Shipping_Method_Title":"Flat Rate - Fixed","Qty_Refunded":"0","Phone_Billing":"8007834233","Payment_Method_Title":"Credit Card","Order_Total_Tax_Amount":"0.00","Order_Total_Amount_without_Tax":"81","Order_Total_Amount":"81.00","Order_Tax_Amount":"0.00","Order_Status":"processing","Order_Shipping_Amount":"7.0000","Order_Id":"000142267","Order_Date":"2022.02.17 03:47:00","Line_Id":"588373","Item_SKU":"CP0000015WT","Item_Quantity":"1","Item_Product_Variation":"Color:Blue Size Chart: Size:M Shoe Size:","Item_Product_Current_Price":"0.00","Item_Name":"FREE -  Pixie Mini Dream Bag Coin Purse","Item_Id":"2344","Item_Cost":"0.00","GiftCard":"0.00","Gift_Card_Code":"","Full_Name_Shipping":"Abinav Sharma","Full_Name_Billing":"Abinav Sharma","Email_Billing":"nilesh.dhumal@fele.com","Customer_Username":"Abinav Sharma","Customer_User_Id":"8007834233","Customer_Role":"","Customer_Note":"","Custom_Options":"","Currency_Amt":"USD","Coupon_Rule":"","Coupon_Code":"","Coupon_Amount":"0.00","Country_Name_Shipping":"US","Country_Name_Billing":"US","Completed_Date":"2022.02.17 03:47:00","Company_Shipping":"Fexle","Company_Billing":"Fexle","City_Shipping":"Home","City_Billing":"Home","Adjustment_Positive":"0.00","Adjustment_Negative":"0.00","Address_2_Shipping":"","Address_2_Billing":"","Address_1_Shipping":"83 Kimmel Rd","Address_1_Billing":"83 Kimmel Rd"},' + 
        '{"Order_Source":"Magento","Zip_Shipping":"75252","Zip_Billing":"75252","Transaction_Id":"60186910202","Total_Tax_Refunded":"0.00","Total_Shipping_Refunded":"0.00","Total_Refunded":"0.00","Tax_Refunded":"0.00","Subtotal_Refunded":"0.00","State_Name_Shipping":"Texas","State_Name_Billing":"Texas","Shipping_Refunded":"0.00","Shipping_Method_Title":"Flat Rate - Fixed","Qty_Refunded":"0","Phone_Billing":"8007834233","Payment_Method_Title":"Credit Card","Order_Total_Tax_Amount":"0.00","Order_Total_Amount_without_Tax":"69","Order_Total_Amount":"69.00","Order_Tax_Amount":"0.00","Order_Status":"processing","Order_Shipping_Amount":"7.0000","Order_Id":"000142270","Order_Date":"2022.02.17 03:58:01","Line_Id":"588379","Item_SKU":"RR1437-YXL","Item_Quantity":"1","Item_Product_Variation":"Color:Black Size Chart:YXL Size:M Shoe Size:","Item_Product_Current_Price":"62.00","Item_Name":"Essential Compression Short-YXL","Item_Id":"63426","Item_Cost":"0.00","GiftCard":"0.00","Gift_Card_Code":"","Full_Name_Shipping":"Manuraj  Hada","Full_Name_Billing":"Manuraj  Hada","Email_Billing":"nilesh.dhumal@fxle.com","Customer_Username":"Manuraj  Hada","Customer_User_Id":"8007834233","Customer_Role":"","Customer_Note":"","Custom_Options":"","Currency_Amt":"USD","Coupon_Rule":"","Coupon_Code":"","Coupon_Amount":"0.00","Country_Name_Shipping":"US","Country_Name_Billing":"US","Completed_Date":"2022.02.17 03:58:01","Company_Shipping":"Fexle","Company_Billing":"Fexle","City_Shipping":"Dallas","City_Billing":"Dallas","Adjustment_Positive":"0.00","Adjustment_Negative":"0.00","Address_2_Shipping":"","Address_2_Billing":"","Address_1_Shipping":"6146 Honey Bluff Parkway","Address_1_Billing":"6146 Honey Bluff Parkway"},' + 
        '{"Order_Source":"Magento","Zip_Shipping":"75252","Zip_Billing":"75252","Transaction_Id":"60186910202","Total_Tax_Refunded":"0.00","Total_Shipping_Refunded":"0.00","Total_Refunded":"0.00","Tax_Refunded":"0.00","Subtotal_Refunded":"0.00","State_Name_Shipping":"Texas","State_Name_Billing":"Texas","Shipping_Refunded":"0.00","Shipping_Method_Title":"Flat Rate - Fixed","Qty_Refunded":"0","Phone_Billing":"8007834233","Payment_Method_Title":"Credit Card","Order_Total_Tax_Amount":"0.00","Order_Total_Amount_without_Tax":"69","Order_Total_Amount":"69.00","Order_Tax_Amount":"0.00","Order_Status":"processing","Order_Shipping_Amount":"7.0000","Order_Id":"000142270","Order_Date":"2022.02.17 03:58:01","Line_Id":"588382","Item_SKU":"CP0000015WT","Item_Quantity":"1","Item_Product_Variation":"Color:Blue Size Chart: Size:M Shoe Size:","Item_Product_Current_Price":"0.00","Item_Name":"FREE -  Pixie Mini Dream Bag Coin Purse","Item_Id":"2344","Item_Cost":"0.00","GiftCard":"0.00","Gift_Card_Code":"","Full_Name_Shipping":"Manuraj  Hada","Full_Name_Billing":"Manuraj  Hada","Email_Billing":"nilesh.dhumal@fxle.com","Customer_Username":"Manuraj  Hada","Customer_User_Id":"8007834233","Customer_Role":"","Customer_Note":"","Custom_Options":"","Currency_Amt":"USD","Coupon_Rule":"","Coupon_Code":"","Coupon_Amount":"0.00","Country_Name_Shipping":"US","Country_Name_Billing":"US","Completed_Date":"2022.02.17 03:58:01","Company_Shipping":"Fexle","Company_Billing":"Fexle","City_Shipping":"Dallas","City_Billing":"Dallas","Adjustment_Positive":"0.00","Adjustment_Negative":"0.00","Address_2_Shipping":"","Address_2_Billing":"","Address_1_Shipping":"6146 Honey Bluff Parkway","Address_1_Billing":"6146 Honey Bluff Parkway"}]';
    public static String productData = '[{"Sku":"","StatusCode":"1","ProductName":"RebelLevel Long Sleeve Tee-XS","Quantity":"20","Price":"80"}, ' + 
        '{"Sku":"1602298-YS","StatusCode":"2","ProductName":"RebelFlawlessSportsBra-YS","Quantity":"27","Price":"52"}]';
    public static List<Account> onlineSalesAccountDetails = getAccountDetailsByAccountName(Constants.ACCOUNT_NAME_ONLINE_SALES);
    
    private static List<Account> getAccountDetailsByAccountName(String accountName) {
        return [SELECT Id, Name FROM Account WHERE Name = :accountName];
    }
    
    @HttpPost
    global static String doUpsertsOverSFDCRecords(String dataRecords, String tableName, String operationType) 
    {
        String returnString;
        DateTime syncUpTime = System.now();
        
        if(String.isNotBlank(operationType) && Constants.OPERATION_TYPE_UPSERT.equalsIgnoreCase(operationType)) 
        {
            if(String.isNotBlank(tableName) && Constants.TABLE_NAME_ORDERS.equalsIgnoreCase(tableName)) 
            {
                List<XtentoSFDCOrdersResponseWrapper> xtentoSFDCOrdersResponseWrapperList = new List<XtentoSFDCOrdersResponseWrapper>();
                List<SCMC__Received_Order__c> failedReceivedOrderToUpdate = new List<SCMC__Received_Order__c>();
                List<SCMC__Received_Order_Line__c> failedReceivedOrderLineItemToUpdate = new List<SCMC__Received_Order_Line__c>();
                List<Web_Service_Log__c> webServiceLogListToInsert = new List<Web_Service_Log__c>();
                try 
                {
                    List<XtentoSFDCOrdersWrapper> xtentoSFDCOrdersWrapperList = 
                        (List<XtentoSFDCOrdersWrapper>) JSON.deserialize(dataRecords, List<XtentoSFDCOrdersWrapper>.class);
                    System.debug('xtentoSFDCOrdersWrapperList == ' + JSON.serialize(xtentoSFDCOrdersWrapperList));
                    
                    List<String> orderIds = new List<String>();
                    List<String> orderLineExternalIds = new List<String>();
                    List<String> customerAddressesCustomerNumber = new List<String>();
                    
                    for(XtentoSFDCOrdersWrapper xtentoSFDCOrdersWrapperObj : xtentoSFDCOrdersWrapperList) 
                    {
                        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Order_Id)) 
                        {
                            orderIds.add(getXtentoFormattedOrderId(xtentoSFDCOrdersWrapperObj.Order_Id));
                            orderLineExternalIds.add(getXtentoFormattedOrderId(xtentoSFDCOrdersWrapperObj.Order_Id) + Constants.DISCOUNT_LINE_ID_POSTFIX);
                            orderLineExternalIds.add(getXtentoFormattedOrderId(xtentoSFDCOrdersWrapperObj.Order_Id) + Constants.GIFTCARD_LINE_ID_POSTFIX);
                            orderLineExternalIds.add(getXtentoFormattedOrderId(xtentoSFDCOrdersWrapperObj.Order_Id) + Constants.REFUNDED_LINE_ID_POSTFIX);
                            orderLineExternalIds.add(getXtentoFormattedOrderId(xtentoSFDCOrdersWrapperObj.Order_Id) + Constants.SHIPPPING_LINE_ID_POSTFIX);
                        }
                        
                        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Line_Id)) 
                        {
                            orderLineExternalIds.add(xtentoSFDCOrdersWrapperObj.Line_Id);
                        }
                        
                        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Customer_User_Id)) 
                        {
                            customerAddressesCustomerNumber.add(getXtentoFormattedCustomerBillingNumber(xtentoSFDCOrdersWrapperObj.Customer_User_Id));
                            customerAddressesCustomerNumber.add(getXtentoFormattedCustomerShippingNumber(xtentoSFDCOrdersWrapperObj.Customer_User_Id));
                        }
                    }
                    
                    Map<String, SCMC__Customer_Address__c> customerAddressesCustomerNumberMap = new Map<String, SCMC__Customer_Address__c>();
                    for(SCMC__Customer_Address__c customerAddresses : [SELECT Id, Name, Customer_Number__c 
                                                                       FROM SCMC__Customer_Address__c 
                                                                       WHERE Customer_Number__c IN :customerAddressesCustomerNumber]) 
                    {
                        customerAddressesCustomerNumberMap.put(customerAddresses.Customer_Number__c, customerAddresses);
                    }
                    
                    Map<String, SCMC__Received_Order__c> orderIdReceivedOrderMap = new Map<String, SCMC__Received_Order__c>();
                    for(SCMC__Received_Order__c receivedOrderObj : [SELECT ID, SCMC__Order_Id__c FROM SCMC__Received_Order__c 
                                                                    WHERE SCMC__Order_Id__c IN :orderIds]) 
                    {
                        orderIdReceivedOrderMap.put(receivedOrderObj.SCMC__Order_Id__c, receivedOrderObj);
                    }
                    
                    Map<String, SCMC__Received_Order_Line__c> orderLineExternalIdReceivedOrderLineMap = 
                        new Map<String, SCMC__Received_Order_Line__c>();
                    for(SCMC__Received_Order_Line__c receivedOrderLineObj : [SELECT ID, Line_Id__c, SCMC__Received_Order__c, 
                                                                             SCMC__Received_Order__r.SCMC__Order_Id__c 
                                                                             FROM SCMC__Received_Order_Line__c 
                                                                             WHERE Line_Id__c IN :orderLineExternalIds 
                                                                                AND SCMC__Received_Order__r.SCMC__Order_Id__c IN :orderIdReceivedOrderMap.keySet()]) 
                    {
                        orderLineExternalIdReceivedOrderLineMap.put(
                            (receivedOrderLineObj.SCMC__Received_Order__r.SCMC__Order_Id__c+receivedOrderLineObj.Line_Id__c), 
                            receivedOrderLineObj);
                    }
                    
                    String customerSiteAccountNumber = Constants.CUSTOMER_SITE_ACCOUNT_NUMBER;
                    List<Account> customerSiteAccountList = [SELECT Id FROM ACCOUNT WHERE AccountNumber = :customerSiteAccountNumber];
                    
                    for(XtentoSFDCOrdersWrapper xtentoSFDCOrdersWrapperObj : xtentoSFDCOrdersWrapperList) 
                    {
                        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Customer_User_Id)) 
                        {
                            String billingCustomerUserId = 
                                getXtentoFormattedCustomerBillingNumber(xtentoSFDCOrdersWrapperObj.Customer_User_Id);
                            String shippingCustomerUserId = 
                                getXtentoFormattedCustomerShippingNumber(xtentoSFDCOrdersWrapperObj.Customer_User_Id);
                            SCMC__Customer_Address__c billingCustomerAddressObj = getBillingCustomerAddressObjBySFDCOrderWrapperObj(
                                xtentoSFDCOrdersWrapperObj, customerAddressesCustomerNumberMap, customerSiteAccountList);
                            SCMC__Customer_Address__c shippingCustomerAddressObj = getShippingCustomerAddressObjBySFDCOrderWrapperObj(
                                xtentoSFDCOrdersWrapperObj, customerAddressesCustomerNumberMap, customerSiteAccountList);
                            customerAddressesCustomerNumberMap.put(
                                billingCustomerAddressObj.Customer_Number__c, billingCustomerAddressObj);
                            customerAddressesCustomerNumberMap.put(
                                shippingCustomerAddressObj.Customer_Number__c, shippingCustomerAddressObj);
                        }
                    }
                    
                    List<Database.UpsertResult> addressUpsertResultList = new List<Database.UpsertResult>();
                    if(!customerAddressesCustomerNumberMap.values().isEmpty()) 
                    {
                        addressUpsertResultList = Database.upsert(customerAddressesCustomerNumberMap.values(), false);
                    }
                    
                    Map<String, String> failedOrderIdWithErrorMessageMap = new Map<String, String>();
                    Map<String, String> failedOrderIdWithExistingReceivedOrderIdMap = new Map<String, String>();
                    for(XtentoSFDCOrdersWrapper xtentoSFDCOrdersWrapperObj : xtentoSFDCOrdersWrapperList) 
                    {
                        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Order_Id) 
                            && String.isNotBlank(xtentoSFDCOrdersWrapperObj.Line_Id)) 
                        {
                            String orderId = getXtentoFormattedOrderId(xtentoSFDCOrdersWrapperObj.Order_Id);
                            try 
                            {
                                Double totalRefunded = String.isNotBlank(xtentoSFDCOrdersWrapperObj.Total_Refunded) ?
                                    Constants.NUMERIC_ZERO_VALUE : Double.valueOf(xtentoSFDCOrdersWrapperObj.Total_Refunded);
                                if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Order_Source) 
                                   && xtentoSFDCOrdersWrapperObj.Order_Source.equalsIgnoreCase(Constants.ORDER_STATUS_MAGENTO) 
                                   && totalRefunded == Constants.NUMERIC_ZERO_VALUE) 
                                {
                                    if(!failedOrderIdWithErrorMessageMap.containsKey(orderId)) 
                                    {
                                        SCMC__Received_Order__c receivedOrderObj = createReceivedOrderRecordByWrapper(
                                            xtentoSFDCOrdersWrapperObj, orderIdReceivedOrderMap, customerAddressesCustomerNumberMap, syncUpTime);
                                        orderIdReceivedOrderMap.put(receivedOrderObj.SCMC__Order_Id__c, receivedOrderObj);
                                    }
                                } 
                                else 
                                {
                                    throw new IllegalArgumentException(System.Label.ERROR_REFUNDED_IS_NOT_ZERO);
                                }
                            } 
                            catch(Exception ex) 
                            {
                                failedOrderIdWithErrorMessageMap.put(orderId, ex.getMessage());
                                if(orderIdReceivedOrderMap.containsKey(orderId) 
                                   && orderIdReceivedOrderMap.get(orderId).Id != null) 
                                {
                                    failedReceivedOrderToUpdate.add(new SCMC__Received_Order__c(
                                        Id = orderIdReceivedOrderMap.get(orderId).Id, Last_Sync_On__c = syncUpTime,
                                        Error_Message__c = ex.getMessage()));
                                    failedOrderIdWithExistingReceivedOrderIdMap.put(orderId, orderIdReceivedOrderMap.get(orderId).Id);
                                }
                                orderIdReceivedOrderMap.remove(orderId);                                
                            }
                        }                        
                    }
                    
                    List<Database.UpsertResult> upsertResultList = new List<Database.UpsertResult>();
                    if(!orderIdReceivedOrderMap.values().isEmpty()) 
                    {
                        upsertResultList = Database.upsert(orderIdReceivedOrderMap.values(), false);
                    }
                    
                    Integer counter = 0;
                    for(Database.UpsertResult ur : upsertResultList) 
                    {
                        if(!ur.isSuccess()) 
                        {
                            Database.Error[] errList = ur.getErrors();
                            failedOrderIdWithErrorMessageMap.put(orderIdReceivedOrderMap.values()[counter].SCMC__Order_Id__c, errList[0].getMessage());
                            if(orderIdReceivedOrderMap.values()[counter].Id != null) 
                            {
                                failedOrderIdWithExistingReceivedOrderIdMap.put(
                                    orderIdReceivedOrderMap.values()[counter].SCMC__Order_Id__c, orderIdReceivedOrderMap.values()[counter].Id);
                                failedReceivedOrderToUpdate.add(new SCMC__Received_Order__c(
                                    Id = orderIdReceivedOrderMap.values()[counter].Id, Last_Sync_On__c = syncUpTime,
                                    Error_Message__c = errList[0].getMessage()));
                            }
                        }
                        counter++;
                    }
                    
                    Map<XtentoSFDCOrdersWrapper, String> wrapperErrorMessageMap = new Map<XtentoSFDCOrdersWrapper, String>();
                    List<SCMC__Received_Order_Line__c> receivedOrderLineList = new List<SCMC__Received_Order_Line__c>();
                    List<String> orderIdList = new List<String>();
                    for(XtentoSFDCOrdersWrapper xtentoSFDCOrdersWrapperObj : xtentoSFDCOrdersWrapperList) 
                    {
                        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Order_Id) 
                            && String.isNotBlank(xtentoSFDCOrdersWrapperObj.Line_Id)) 
                        {
                            String orderId = getXtentoFormattedOrderId(xtentoSFDCOrdersWrapperObj.Order_Id);
                            if(!failedOrderIdWithErrorMessageMap.containsKey(orderId)) 
                            {
                                try 
                                {
                                    if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Order_Source) 
                                        && xtentoSFDCOrdersWrapperObj.Order_Source.equalsIgnoreCase(Constants.ORDER_STATUS_MAGENTO) 
                                        && String.isNotBlank(xtentoSFDCOrdersWrapperObj.Qty_Refunded) 
                                        && Double.valueOf(xtentoSFDCOrdersWrapperObj.Qty_Refunded) == Constants.NUMERIC_ZERO_VALUE) 
                                    {
                                        SCMC__Received_Order_Line__c orderLineItemObj = createOrderLineItemByWrapper(
                                            xtentoSFDCOrdersWrapperObj, orderIdReceivedOrderMap.get(orderId), 
                                            orderLineExternalIdReceivedOrderLineMap, syncUpTime);                                    
                                        receivedOrderLineList.add(orderLineItemObj);
                                        orderIdList.add(orderId);
                                    }
                                } 
                                catch(Exception ex) 
                                {
                                    wrapperErrorMessageMap.put(xtentoSFDCOrdersWrapperObj, ex.getMessage());
                                    SCMC__Received_Order__c ROOrderObj = orderIdReceivedOrderMap.get(orderId);
                                    
                                    if(ROOrderObj != null) 
                                    {
                                        if(orderLineExternalIdReceivedOrderLineMap.containsKey(
                                            ROOrderObj.SCMC__Order_Id__c + xtentoSFDCOrdersWrapperObj.Line_Id) 
                                            && orderLineExternalIdReceivedOrderLineMap.get(
                                                ROOrderObj.SCMC__Order_Id__c + xtentoSFDCOrdersWrapperObj.Line_Id).Id != null) 
                                        {
                                            failedReceivedOrderLineItemToUpdate.add(new SCMC__Received_Order_Line__c(
                                                Id = orderLineExternalIdReceivedOrderLineMap.get(ROOrderObj.SCMC__Order_Id__c + xtentoSFDCOrdersWrapperObj.Line_Id).Id, 
                                                Last_Sync_On__c = syncUpTime, Error_Message__c = ex.getMessage()));
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    List<Database.UpsertResult> saveResultList = Database.upsert(receivedOrderLineList, false);
                    
                    Map<String, String> failureROLIOrderIdMap = new Map<String, String>();
                    counter = 0;
                    for(Database.UpsertResult ur :saveResultList) 
                    {
                        if(!ur.isSuccess()) 
                        {
                            Database.Error[] errList = ur.getErrors();
                            failureROLIOrderIdMap.put(orderIdList[counter], errList[0].getMessage());
                            if(!ur.isCreated()) 
                            {
                                failedReceivedOrderLineItemToUpdate.add(new SCMC__Received_Order_Line__c(
                                    Id = ur.getId(), Last_Sync_On__c = syncUpTime,
                                    Error_Message__c = errList[0].getMessage()));
                            }
                        }
                        counter++;
                    }
                    
                    Map<String, List<SCMC__Received_Order_Line__c>> orderIdOtherROLIMap = 
                        new Map<String, List<SCMC__Received_Order_Line__c>>();
                    Map<String, String> orderIdOtherROFailureMesssageMap = new Map<String, String>();
                    for(XtentoSFDCOrdersWrapper xtentoSFDCOrdersWrapperObj : xtentoSFDCOrdersWrapperList) 
                    {
                        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Order_Id) 
                            && String.isNotBlank(xtentoSFDCOrdersWrapperObj.Line_Id)) 
                        {
                            String orderId = getXtentoFormattedOrderId(xtentoSFDCOrdersWrapperObj.Order_Id);
                            if(!failedOrderIdWithErrorMessageMap.containsKey(orderId) 
                                && !wrapperErrorMessageMap.containsKey(xtentoSFDCOrdersWrapperObj) 
                                && !failureROLIOrderIdMap.containsKey(orderId)) 
                            {
                                try 
                                {
                                    List<SCMC__Received_Order_Line__c> otherROLIList = createOtherOrderLineItemByLineItem(
                                        xtentoSFDCOrdersWrapperObj, orderIdReceivedOrderMap.get(orderId), 
                                        orderLineExternalIdReceivedOrderLineMap);
                                    orderIdOtherROLIMap.put(orderId, otherROLIList);
                                    orderIdOtherROFailureMesssageMap.remove(orderId);
                                } 
                                catch(Exception ex) 
                                {
                                    orderIdOtherROFailureMesssageMap.put(orderId, ex.getMessage());
                                    orderIdOtherROLIMap.remove(orderId);
                                }
                            }
                        }
                    }
                    
                    List<SCMC__Received_Order_Line__c> otherROLIListToUpsert = new List<SCMC__Received_Order_Line__c>();
                    orderIdList.clear();
                    for(String oId : orderIdOtherROLIMap.keySet()) 
                    {
                        otherROLIListToUpsert.addAll(orderIdOtherROLIMap.get(oId));
                        for(SCMC__Received_Order_Line__c otherRO : orderIdOtherROLIMap.get(oId)) 
                        {
                            orderIdList.add(oId);
                        }
                    }
                    System.debug('otherROLIListToUpsert == ' + otherROLIListToUpsert);
                    if(!otherROLIListToUpsert.isEmpty()) 
                    {
                        List<Database.UpsertResult> otherROLIUpsertResultList = Database.upsert(otherROLIListToUpsert, false);                        
                        counter = 0;
                        for(Database.UpsertResult ur :otherROLIUpsertResultList) 
                        {
                            if(!ur.isSuccess()) 
                            {
                                Database.Error[] errList = ur.getErrors();
                                if(!orderIdOtherROFailureMesssageMap.containsKey(orderIdList[counter])) 
                                {
                                    orderIdOtherROFailureMesssageMap.put(orderIdList[counter], '');
                                }
                                
                                if(otherROLIListToUpsert[counter].Line_Id__c.endsWith(Constants.DISCOUNT_LINE_ID_POSTFIX)) 
                                {
                                    orderIdOtherROFailureMesssageMap.put(
                                        orderIdList[counter], 
                                        (orderIdOtherROFailureMesssageMap.get(orderIdList[counter]) + String.format(Constants.OTHER_ROLI_ERROR_MESSAGE, new List<Object>{Constants.STRING_DISCOUNT}) + errList[0].getMessage()));
                                } 
                                else if(otherROLIListToUpsert[counter].Line_Id__c.endsWith(Constants.GIFTCARD_LINE_ID_POSTFIX)) 
                                {
                                    orderIdOtherROFailureMesssageMap.put(
                                        orderIdList[counter], 
                                        (orderIdOtherROFailureMesssageMap.get(orderIdList[counter]) + String.format(Constants.OTHER_ROLI_ERROR_MESSAGE, new List<Object>{Constants.STRING_GIFT_CARD}) + errList[0].getMessage()));
                                } 
                                else if(otherROLIListToUpsert[counter].Line_Id__c.endsWith(Constants.REFUNDED_LINE_ID_POSTFIX)) 
                                {
                                    orderIdOtherROFailureMesssageMap.put(
                                        orderIdList[counter], 
                                        (orderIdOtherROFailureMesssageMap.get(orderIdList[counter]) + String.format(Constants.OTHER_ROLI_ERROR_MESSAGE, new List<Object>{Constants.STRING_REFUND}) + errList[0].getMessage()));
                                } 
                                else if(otherROLIListToUpsert[counter].Line_Id__c.endsWith(Constants.SHIPPPING_LINE_ID_POSTFIX)) 
                                {
                                    orderIdOtherROFailureMesssageMap.put(
                                        orderIdList[counter], 
                                        (orderIdOtherROFailureMesssageMap.get(orderIdList[counter]) + String.format(Constants.OTHER_ROLI_ERROR_MESSAGE, new List<Object>{Constants.STRING_SHIPPING}) + errList[0].getMessage()));
                                } 
                                else 
                                {
                                    orderIdOtherROFailureMesssageMap.put(
                                        orderIdList[counter], 
                                        orderIdOtherROFailureMesssageMap.get(orderIdList[counter]) + errList[0].getMessage());
                                }
                            }
                            counter++;
                        }
                    }
                    
                    counter = 0;
                    for(XtentoSFDCOrdersWrapper xtentoSFDCOrdersWrapperObj : xtentoSFDCOrdersWrapperList) 
                    {
                        XtentoSFDCOrdersResponseWrapper response;
                        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Order_Id) 
                            && String.isNotBlank(xtentoSFDCOrdersWrapperObj.Line_Id))
                        {
                            if(wrapperErrorMessageMap.containsKey(xtentoSFDCOrdersWrapperObj)) 
                            {
                                String orderId = getXtentoFormattedOrderId(xtentoSFDCOrdersWrapperObj.Order_Id);
                                if(orderIdReceivedOrderMap.containsKey(orderId)) 
                                {
                                    response = new XtentoSFDCOrdersResponseWrapper(
                                        xtentoSFDCOrdersWrapperObj, orderIdReceivedOrderMap.get(orderId).Id, null, 
                                        null, wrapperErrorMessageMap.get(xtentoSFDCOrdersWrapperObj));
                                    webServiceLogListToInsert.add(new Web_Service_Log__c(
                                        Callout_Type__c = Constants.CALLOUT_TYPE_MAGENTO_TO_SFDC, 
                                        Operation_Name__c = Constants.OPERATION_NAME_DOUPSERTSOVERSFDCRRECORDS, 
                                        Received_Order__c = orderIdReceivedOrderMap.get(orderId).Id, Received_Order_Line__c = null, 
                                        Request_Body__c = JSON.serialize(xtentoSFDCOrdersWrapperObj), 
                                        Request_Method__c = Constants.REQUEST_METHOD_POST, 
                                        Type__c = Constants.TYPE_TALEND_INTEGRATION, 
                                        Error_Message__c = wrapperErrorMessageMap.get(xtentoSFDCOrdersWrapperObj),
                                        Received_Order_Date__c = xtentoSFDCOrdersWrapperObj.Order_Date, 
                                        Received_Order_Item_Name__c=xtentoSFDCOrdersWrapperObj.Item_Name, 
                                        Received_Order_Item_SKU__c=xtentoSFDCOrdersWrapperObj.Item_SKU, 
                                        Received_Order_Number__c=xtentoSFDCOrdersWrapperObj.Order_Id));
                                } 
                                else 
                                {
                                    response = new XtentoSFDCOrdersResponseWrapper(
                                        xtentoSFDCOrdersWrapperObj, null, null, 
                                        null, wrapperErrorMessageMap.get(xtentoSFDCOrdersWrapperObj));
                                    webServiceLogListToInsert.add(new Web_Service_Log__c(
                                        Callout_Type__c = Constants.CALLOUT_TYPE_MAGENTO_TO_SFDC, 
                                        Operation_Name__c = Constants.OPERATION_NAME_DOUPSERTSOVERSFDCRRECORDS, 
                                        Received_Order__c = null, Received_Order_Line__c = null, 
                                        Request_Body__c = JSON.serialize(xtentoSFDCOrdersWrapperObj), 
                                        Request_Method__c = Constants.REQUEST_METHOD_POST, 
                                        Type__c = Constants.TYPE_TALEND_INTEGRATION, 
                                        Error_Message__c = wrapperErrorMessageMap.get(xtentoSFDCOrdersWrapperObj),
                                        Received_Order_Date__c = xtentoSFDCOrdersWrapperObj.Order_Date, 
                                        Received_Order_Item_Name__c=xtentoSFDCOrdersWrapperObj.Item_Name, 
                                        Received_Order_Item_SKU__c=xtentoSFDCOrdersWrapperObj.Item_SKU, 
                                        Received_Order_Number__c=xtentoSFDCOrdersWrapperObj.Order_Id));
                                }
                            } 
                            else 
                            {
                                String orderId = getXtentoFormattedOrderId(xtentoSFDCOrdersWrapperObj.Order_Id);
                                if(failedOrderIdWithErrorMessageMap.containsKey(orderId)) 
                                {
                                    response = new XtentoSFDCOrdersResponseWrapper(
                                        xtentoSFDCOrdersWrapperObj, null, null, 
                                        failedOrderIdWithErrorMessageMap.get(orderId), 
                                        null);
                                    String ROId = null;
                                    if(failedOrderIdWithExistingReceivedOrderIdMap.containsKey(orderId)) 
                                    {
                                        ROId = failedOrderIdWithExistingReceivedOrderIdMap.get(orderId);
                                    }
                                    webServiceLogListToInsert.add(new Web_Service_Log__c(
                                        Callout_Type__c = Constants.CALLOUT_TYPE_MAGENTO_TO_SFDC, 
                                        Operation_Name__c = Constants.OPERATION_NAME_DOUPSERTSOVERSFDCRRECORDS, 
                                        Received_Order__c = ROId, Received_Order_Line__c = null, 
                                        Request_Body__c = JSON.serialize(xtentoSFDCOrdersWrapperObj), 
                                        Request_Method__c = Constants.REQUEST_METHOD_POST, 
                                        Type__c = Constants.TYPE_TALEND_INTEGRATION, 
                                        Error_Message__c = failedOrderIdWithErrorMessageMap.get(orderId),
                                        Received_Order_Date__c = xtentoSFDCOrdersWrapperObj.Order_Date, 
                                        Received_Order_Item_Name__c=xtentoSFDCOrdersWrapperObj.Item_Name, 
                                        Received_Order_Item_SKU__c=xtentoSFDCOrdersWrapperObj.Item_SKU, 
                                        Received_Order_Number__c=xtentoSFDCOrdersWrapperObj.Order_Id));
                                } 
                                else if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Order_Source) 
                                    && xtentoSFDCOrdersWrapperObj.Order_Source.equalsIgnoreCase(Constants.ORDER_STATUS_MAGENTO) 
                                    && String.isNotBlank(xtentoSFDCOrdersWrapperObj.Qty_Refunded) 
                                    && Double.valueOf(xtentoSFDCOrdersWrapperObj.Qty_Refunded) != Constants.NUMERIC_ZERO_VALUE)
                                {
                                    response = new XtentoSFDCOrdersResponseWrapper(
                                        xtentoSFDCOrdersWrapperObj, orderIdReceivedOrderMap.get(orderId).Id, 
                                        null, null, null);
                                } 
                                else 
                                {
                                    if(counter < saveResultList.size()) 
                                    {
                                        Database.UpsertResult saveResult = saveResultList[counter];
                                        if(saveResult.isSuccess()) 
                                        {
                                            if(orderIdOtherROFailureMesssageMap.containsKey(orderId)) 
                                            {
                                                response = new XtentoSFDCOrdersResponseWrapper(
                                                    xtentoSFDCOrdersWrapperObj, receivedOrderLineList[counter].SCMC__Received_Order__c, 
                                                    saveResult.getId(), orderIdOtherROFailureMesssageMap.get(orderId), null);
                                                webServiceLogListToInsert.add(new Web_Service_Log__c(
                                                    Callout_Type__c = Constants.CALLOUT_TYPE_MAGENTO_TO_SFDC, 
                                                    Operation_Name__c = Constants.OPERATION_NAME_DOUPSERTSOVERSFDCRRECORDS, 
                                                    Received_Order__c = receivedOrderLineList[counter].SCMC__Received_Order__c, 
                                                    Received_Order_Line__c = saveResult.getId(), 
                                                    Request_Body__c = JSON.serialize(xtentoSFDCOrdersWrapperObj), 
                                                    Request_Method__c = Constants.REQUEST_METHOD_POST, 
                                                    Type__c = Constants.TYPE_TALEND_INTEGRATION, 
                                                    Is_Other_Received_Order_Failed__c = true, 
                                                    Error_Message__c = orderIdOtherROFailureMesssageMap.get(orderId),
                                                    Received_Order_Date__c = xtentoSFDCOrdersWrapperObj.Order_Date, 
                                                    Received_Order_Item_Name__c=xtentoSFDCOrdersWrapperObj.Item_Name, 
                                                    Received_Order_Item_SKU__c=xtentoSFDCOrdersWrapperObj.Item_SKU, 
                                                    Received_Order_Number__c=xtentoSFDCOrdersWrapperObj.Order_Id));
                                            } 
                                            else 
                                            {
                                                response = new XtentoSFDCOrdersResponseWrapper(
                                                    xtentoSFDCOrdersWrapperObj, receivedOrderLineList[counter].SCMC__Received_Order__c, 
                                                    saveResult.getId(), null, null);
                                            }                                            
                                        } 
                                        else 
                                        {
                                            Database.Error[] errList = saveResult.getErrors();
                                            response = new XtentoSFDCOrdersResponseWrapper(
                                                xtentoSFDCOrdersWrapperObj, receivedOrderLineList[counter].SCMC__Received_Order__c, null, 
                                                null, errList[0].getMessage());
                                            String ROLIId = null;
                                            if(!saveResult.isCreated()) 
                                            {
                                                ROLIId = saveResult.getId();
                                            }
                                            webServiceLogListToInsert.add(new Web_Service_Log__c(
                                                Callout_Type__c = Constants.CALLOUT_TYPE_MAGENTO_TO_SFDC, 
                                                Operation_Name__c = Constants.OPERATION_NAME_DOUPSERTSOVERSFDCRRECORDS, 
                                                Received_Order__c = receivedOrderLineList[counter].SCMC__Received_Order__c, Received_Order_Line__c = ROLIId, 
                                                Request_Body__c = JSON.serialize(xtentoSFDCOrdersWrapperObj), 
                                                Request_Method__c = Constants.REQUEST_METHOD_POST, 
                                                Type__c = Constants.TYPE_TALEND_INTEGRATION, 
                                                Error_Message__c = errList[0].getMessage(),
                                                Received_Order_Date__c = xtentoSFDCOrdersWrapperObj.Order_Date, 
                                                Received_Order_Item_Name__c=xtentoSFDCOrdersWrapperObj.Item_Name, 
                                                Received_Order_Item_SKU__c=xtentoSFDCOrdersWrapperObj.Item_SKU, 
                                                Received_Order_Number__c=xtentoSFDCOrdersWrapperObj.Order_Id));
                                        }
                                    }
                                    counter++;
                                }
                            }
                        } 
                        else 
                        {
                            response = new XtentoSFDCOrdersResponseWrapper(
                                xtentoSFDCOrdersWrapperObj, null, null, Constants.REQUIRED_FIELD_MISSING_ERROR_MESSAGE, 
                                null);
                            webServiceLogListToInsert.add(new Web_Service_Log__c(
                                Callout_Type__c = Constants.CALLOUT_TYPE_MAGENTO_TO_SFDC, 
                                Operation_Name__c = Constants.OPERATION_NAME_DOUPSERTSOVERSFDCRRECORDS, 
                                Received_Order__c = null, Received_Order_Line__c = null, 
                                Request_Body__c = JSON.serialize(xtentoSFDCOrdersWrapperObj), 
                                Request_Method__c = Constants.REQUEST_METHOD_POST, 
                                Type__c = Constants.TYPE_TALEND_INTEGRATION, 
                                Error_Message__c = Constants.REQUIRED_FIELD_MISSING_ERROR_MESSAGE,
                                Received_Order_Date__c = xtentoSFDCOrdersWrapperObj.Order_Date, 
                                Received_Order_Item_Name__c=xtentoSFDCOrdersWrapperObj.Item_Name, 
                                Received_Order_Item_SKU__c=xtentoSFDCOrdersWrapperObj.Item_SKU, 
                                Received_Order_Number__c=xtentoSFDCOrdersWrapperObj.Order_Id));
                        }
                        xtentoSFDCOrdersResponseWrapperList.add(response);
                    }                    
                } 
                catch(Exception e) 
                {
                    XtentoSFDCOrdersResponseWrapper xtentoSFDCOrdersResponseWrapperInstance = 
                        new XtentoSFDCOrdersResponseWrapper(
                            null, null, null, e.getMessage(), null);
                    xtentoSFDCOrdersResponseWrapperList.add(xtentoSFDCOrdersResponseWrapperInstance);
                }
                
                if(!failedReceivedOrderLineItemToUpdate.isEmpty()) 
                {
                    try 
                    {
                        update failedReceivedOrderLineItemToUpdate;
                    }
                    catch(Exception ex) 
                    {
                        System.debug('Exception while updating error ROLI' + ex.getMessage());
                    }
                }
                
                if(!failedReceivedOrderToUpdate.isEmpty()) 
                {
                    try 
                    {
                        update failedReceivedOrderToUpdate;
                    } 
                    catch(Exception ex) 
                    {
                        System.debug('Exception while updating error RO' + ex.getMessage());
                    }
                }
                
                if(!webServiceLogListToInsert.isEmpty()) 
                {
                    try 
                    {
                        insert webServiceLogListToInsert;
                    } 
                    catch(Exception ex) 
                    {
                        System.debug('Exception while insert web service log' + ex.getMessage());
                    }
                }
                
                returnString = JSON.serialize(xtentoSFDCOrdersResponseWrapperList);
            } 
            else if(String.isNotBlank(tableName) && Constants.TABLE_NAME_PRODUCTS.equalsIgnoreCase(tableName)) 
            {
                List<XtentoSFDCProductResponseWrapper> xtentoSFDCProductResponseWrapperList = new List<XtentoSFDCProductResponseWrapper>();
                /*List<Web_Service_Log__c> webServiceLogListToInsert = new List<Web_Service_Log__c>();
                try 
                {
                    List<XtentoSFDCProductWrapper> xtentoSFDCProductsWrapperList = 
                        (List<XtentoSFDCProductWrapper>) JSON.deserialize(dataRecords, List<XtentoSFDCProductWrapper>.class);
                    System.debug('xtentoSFDCProductsWrapperList == ' + JSON.serialize(xtentoSFDCProductsWrapperList));
                    
                    Set<String> skuSet = new Set<String>();
                    for(XtentoSFDCProductWrapper xtentoSFDCProductWrapperObj : xtentoSFDCProductsWrapperList) 
                    {
                        if(String.isNotBlank(xtentoSFDCProductWrapperObj.Sku)) 
                        {
                            skuSet.add(xtentoSFDCProductWrapperObj.Sku);
                        }
                    }
                    
                    Map<String, Inventory__c> skuInventoryObjMap = new Map<String, Inventory__c>();                    
                    for(Inventory__c inventoryObj : [SELECT Id, Sku__c FROM Inventory__c WHERE Sku__c IN :skuSet]) 
                    {
                        skuInventoryObjMap.put(inventoryObj.Sku__c, inventoryObj);
                    }
                    
                    Map<String, String> failedInventorySkuWithErrorMessageMap = new Map<String, String>();
                    for(XtentoSFDCProductWrapper xtentoSFDCProductWrapperObj : xtentoSFDCProductsWrapperList) 
                    {
                        if(String.isNotBlank(xtentoSFDCProductWrapperObj.Sku)) 
                        {
                            try 
                            {
                                if(!failedInventorySkuWithErrorMessageMap.containsKey(xtentoSFDCProductWrapperObj.Sku)) 
                                {
                                    Inventory__c inventoryRecordObj = createInventoryRecordByWrapper(
                                        xtentoSFDCProductWrapperObj, skuInventoryObjMap);
                                    skuInventoryObjMap.put(inventoryRecordObj.Sku__c, inventoryRecordObj);
                                }
                            } 
                            catch(Exception ex) 
                            {
                                failedInventorySkuWithErrorMessageMap.put(xtentoSFDCProductWrapperObj.Sku, ex.getMessage());
                                skuInventoryObjMap.remove(xtentoSFDCProductWrapperObj.Sku);
                            }
                        }
                    }
                    
                    List<Database.UpsertResult> upsertResultList = new List<Database.UpsertResult>();
                    if(!skuInventoryObjMap.values().isEmpty()) 
                    {
                        upsertResultList = Database.upsert(skuInventoryObjMap.values(), false);
                    }
                    
                    Integer counter = 0;
                    for(Database.UpsertResult ur : upsertResultList) 
                    {
                        if(!ur.isSuccess()) 
                        {
                            Database.Error[] errList = ur.getErrors();
                            failedInventorySkuWithErrorMessageMap.put(
                                skuInventoryObjMap.values()[counter].Sku__c, errList[0].getMessage());
                        }
                        counter++;
                    }
                    
                    counter = 0;
                    for(XtentoSFDCProductWrapper xtentoSFDCProductWrapperObj : xtentoSFDCProductsWrapperList) 
                    {
                        XtentoSFDCProductResponseWrapper response;
                        if(String.isNotBlank(xtentoSFDCProductWrapperObj.Sku)) 
                        {
                            if(failedInventorySkuWithErrorMessageMap.containsKey(xtentoSFDCProductWrapperObj.Sku)) 
                            {
                                response = new XtentoSFDCProductResponseWrapper(
                                    xtentoSFDCProductWrapperObj, null, 
                                    failedInventorySkuWithErrorMessageMap.get(xtentoSFDCProductWrapperObj.Sku));
                                webServiceLogListToInsert.add(new Web_Service_Log__c(
                                    Callout_Type__c = Constants.CALLOUT_TYPE_MAGENTO_TO_SFDC, 
                                    Operation_Name__c = Constants.OPERATION_NAME_DOUPSERTSOVERSFDCRRECORDS, 
                                    Inventory__c = (skuInventoryObjMap.containsKey(xtentoSFDCProductWrapperObj.Sku) ? skuInventoryObjMap.get(xtentoSFDCProductWrapperObj.Sku).Id : null),
                                    Request_Body__c = JSON.serialize(xtentoSFDCProductWrapperObj), 
                                    Request_Method__c = Constants.REQUEST_METHOD_POST, 
                                    Type__c = Constants.TYPE_INVENTORY_INTEGRATION, 
                                    Error_Message__c = failedInventorySkuWithErrorMessageMap.get(xtentoSFDCProductWrapperObj.Sku),
                                    Inventory_Item_Sku__c = xtentoSFDCProductWrapperObj.Sku, 
                                    Inventory_Product_Name__c = xtentoSFDCProductWrapperObj.ProductName));
                            } 
                            else 
                            {
                                response = new XtentoSFDCProductResponseWrapper(
                                    xtentoSFDCProductWrapperObj, 
                                    skuInventoryObjMap.get(xtentoSFDCProductWrapperObj.Sku).Id, null);
                            }
                        } 
                        else 
                        {
                            response = new XtentoSFDCProductResponseWrapper(
                                xtentoSFDCProductWrapperObj, null, Constants.PRODUCT_SKU_BLANK_ERROR_MESSAGE);
                            webServiceLogListToInsert.add(new Web_Service_Log__c(
                                Callout_Type__c = Constants.CALLOUT_TYPE_MAGENTO_TO_SFDC, 
                                Operation_Name__c = Constants.OPERATION_NAME_DOUPSERTSOVERSFDCRRECORDS, 
                                Inventory__c = null,
                                Request_Body__c = JSON.serialize(xtentoSFDCProductWrapperObj), 
                                Request_Method__c = Constants.REQUEST_METHOD_POST, 
                                Type__c = Constants.TYPE_INVENTORY_INTEGRATION, 
                                Error_Message__c = Constants.PRODUCT_SKU_BLANK_ERROR_MESSAGE,
                                Inventory_Item_Sku__c = xtentoSFDCProductWrapperObj.Sku, 
                                Inventory_Product_Name__c = xtentoSFDCProductWrapperObj.ProductName));
                        }
                        xtentoSFDCProductResponseWrapperList.add(response);
                    }
                } catch (Exception ex) 
                {
                    XtentoSFDCProductResponseWrapper xtentoSFDCProductResponseWrapperInstance = 
                        new XtentoSFDCProductResponseWrapper(
                            null, null, ex.getMessage());
                    xtentoSFDCProductResponseWrapperList.add(xtentoSFDCProductResponseWrapperInstance);
                }
                
                if(!webServiceLogListToInsert.isEmpty()) 
                {
                    try 
                    {
                        insert webServiceLogListToInsert;
                    } 
                    catch(Exception ex) 
                    {
                        System.debug('Exception while insert web service log for inventory' + ex.getMessage());
                    }
                }*/
                
                returnString = JSON.serialize(xtentoSFDCProductResponseWrapperList);
            } 
            else 
            {
                List<XtentoSFDCOrdersResponseWrapper> invalidOrderResponseList = new List<XtentoSFDCOrdersResponseWrapper>();
                invalidOrderResponseList.add(new XtentoSFDCOrdersResponseWrapper(
                    null, null, null, Constants.INVALID_TABLE_NAME, null));
                returnString = JSON.serialize(invalidOrderResponseList);
            }
        } 
        else 
        {
            List<XtentoSFDCOrdersResponseWrapper> invalidOrderResponseList = new List<XtentoSFDCOrdersResponseWrapper>();
            invalidOrderResponseList.add(new XtentoSFDCOrdersResponseWrapper(
                null, null, null, Constants.INVALID_OPERATION_TYPE, null));
            returnString = JSON.serialize(invalidOrderResponseList);
        }
        System.debug('returnString == ' + returnString);
        return returnString;
    }
    
    private static String getInventoryStatusByStatusCode(String statusCode) 
    {
        String status = '';
        if(String.isNotBlank(statusCode)) 
        {
            if(statusCode.equals(Constants.ONE_STRING)) 
            {
                status = Constants.STATUS_LIVE;
            } 
            else if(statusCode.equals(Constants.TWO_STRING)) 
            {
                status = Constants.STATUS_DISABLED;
            }
        }
        return status;
    }
    
    /*private static Inventory__c createInventoryRecordByWrapper(
        XtentoSFDCProductWrapper xtentoSFDCProductWrapperObj, Map<String, Inventory__c> skuInventoryObjMap) 
    {
        Inventory__c inventoryObj = new Inventory__c();
        if(skuInventoryObjMap.containsKey(xtentoSFDCProductWrapperObj.Sku)) 
        {
            inventoryObj.Id = skuInventoryObjMap.get(xtentoSFDCProductWrapperObj.Sku).Id;
        }
        
        inventoryObj.Sku__c = xtentoSFDCProductWrapperObj.Sku;
        inventoryObj.Status_Code__c = xtentoSFDCProductWrapperObj.StatusCode;
        inventoryObj.Status__c = getInventoryStatusByStatusCode(xtentoSFDCProductWrapperObj.StatusCode);
        inventoryObj.Quantity__c = String.isNotBlank(xtentoSFDCProductWrapperObj.Quantity) ? 
            Double.valueOf(xtentoSFDCProductWrapperObj.Quantity) : Constants.NUMERIC_ZERO_VALUE;
        inventoryObj.Price__c = String.isNotBlank(xtentoSFDCProductWrapperObj.Price) ? 
            Double.valueOf(xtentoSFDCProductWrapperObj.Price) : Constants.NUMERIC_ZERO_VALUE;
        inventoryObj.Product_Name__c = xtentoSFDCProductWrapperObj.ProductName;
        return inventoryObj;
    }*/
    
    private static SCMC__Customer_Address__c getBillingCustomerAddressObjBySFDCOrderWrapperObj(
        XtentoSFDCOrdersWrapper xtentoSFDCOrdersWrapperObj, 
        Map<String, SCMC__Customer_Address__c> customerAddressesCustomerNumberMap, List<Account> customerSiteAccountList) 
    {
        SCMC__Customer_Address__c customerAddress = new SCMC__Customer_Address__c();
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Customer_User_Id)) 
        {
            String billingCustomerUserId = getXtentoFormattedCustomerBillingNumber(xtentoSFDCOrdersWrapperObj.Customer_User_Id);        
            if(customerAddressesCustomerNumberMap.containsKey(billingCustomerUserId)) 
            {
                customerAddress.Id = customerAddressesCustomerNumberMap.get(billingCustomerUserId).Id;
            }
        }
        
        customerAddress.Name = getXtentoFormattedCustomerBillingName(xtentoSFDCOrdersWrapperObj.Full_Name_Billing);
        customerAddress.SCMC__Active__c = true;
        
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Customer_User_Id)) 
        {
            customerAddress.Customer_Number__c = 
                getXtentoFormattedCustomerBillingNumber(xtentoSFDCOrdersWrapperObj.Customer_User_Id);
        }
        
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Address_1_Billing)) 
        {
            customerAddress.SCMC__Mailing_Street__c = xtentoSFDCOrdersWrapperObj.Address_1_Billing;
        }
        
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.City_Billing)) 
        {
            customerAddress.SCMC__Mailing_City__c = xtentoSFDCOrdersWrapperObj.City_Billing;
        }
        
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.State_Name_Billing)) 
        {
            customerAddress.SCMC__Mailing_State_Province__c = xtentoSFDCOrdersWrapperObj.State_Name_Billing;
        }
        
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Zip_Billing)) 
        {
            customerAddress.SCMC__Mailing_Zip_Postal_Code__c = xtentoSFDCOrdersWrapperObj.Zip_Billing;
        }
        
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Country_Name_Billing)) 
        {
            customerAddress.SCMC__Mailing_Country__c = xtentoSFDCOrdersWrapperObj.Country_Name_Billing;
        }
        
        if(!customerSiteAccountList.isEmpty()) 
        {
            customerAddress.SCMC__Customer_Site__c = customerSiteAccountList[0].Id;
        }
        
        return customerAddress;
    }
    
    private static SCMC__Customer_Address__c getShippingCustomerAddressObjBySFDCOrderWrapperObj(
        XtentoSFDCOrdersWrapper xtentoSFDCOrdersWrapperObj, 
        Map<String, SCMC__Customer_Address__c> customerAddressesCustomerNumberMap, List<Account> customerSiteAccountList) 
    {
        SCMC__Customer_Address__c customerAddress = new SCMC__Customer_Address__c();
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Customer_User_Id)) 
        {
            String shippingCustomerUserId = getXtentoFormattedCustomerShippingNumber(xtentoSFDCOrdersWrapperObj.Customer_User_Id);        
            if(customerAddressesCustomerNumberMap.containsKey(shippingCustomerUserId)) 
            {
                customerAddress.Id = customerAddressesCustomerNumberMap.get(shippingCustomerUserId).Id;
            }
        }
        customerAddress.Name = getXtentoFormattedCustomerShippingName(xtentoSFDCOrdersWrapperObj.Full_Name_Shipping);
        customerAddress.SCMC__Active__c = true;
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Customer_User_Id)) 
        {
            customerAddress.Customer_Number__c = 
                getXtentoFormattedCustomerShippingNumber(xtentoSFDCOrdersWrapperObj.Customer_User_Id);
        }
        
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Address_1_Shipping)) 
        {
            customerAddress.SCMC__Mailing_Street__c = xtentoSFDCOrdersWrapperObj.Address_1_Shipping;
        }
        
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.City_Shipping)) 
        {
            customerAddress.SCMC__Mailing_City__c = xtentoSFDCOrdersWrapperObj.City_Shipping;
        }
        
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.State_Name_Shipping)) 
        {
            customerAddress.SCMC__Mailing_State_Province__c = xtentoSFDCOrdersWrapperObj.State_Name_Shipping;
        }
        
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Zip_Shipping)) 
        {
            customerAddress.SCMC__Mailing_Zip_Postal_Code__c = xtentoSFDCOrdersWrapperObj.Zip_Shipping;
        }
        
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Country_Name_Shipping)) 
        {
            customerAddress.SCMC__Mailing_Country__c = xtentoSFDCOrdersWrapperObj.Country_Name_Shipping;
        }
        
        if(!customerSiteAccountList.isEmpty()) 
        {
            customerAddress.SCMC__Customer_Site__c = customerSiteAccountList[0].Id;
        }
        
        return customerAddress;
    }
    
    private static List<SCMC__Received_Order_Line__c> createOtherOrderLineItemByLineItem(
        XtentoSFDCOrdersWrapper xtentoSFDCOrdersWrapperObj, SCMC__Received_Order__c orderDetails, 
        Map<String, SCMC__Received_Order_Line__c> orderLineExternalIdReceivedOrderLineMap) 
    {
        List<SCMC__Received_Order_Line__c> otherROLineItem = new List<SCMC__Received_Order_Line__c>();
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Order_Source) 
            && xtentoSFDCOrdersWrapperObj.Order_Source.equalsIgnoreCase(Constants.ORDER_STATUS_MAGENTO) 
            && String.isNotBlank(xtentoSFDCOrdersWrapperObj.Coupon_Amount) 
            && Double.valueOf(xtentoSFDCOrdersWrapperObj.Coupon_Amount) != Constants.NUMERIC_ZERO_VALUE) 
        {
            otherROLineItem.add(createDiscountOrderLineItem(
                xtentoSFDCOrdersWrapperObj, orderDetails, orderLineExternalIdReceivedOrderLineMap));
        } 
        
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Order_Source) 
            && xtentoSFDCOrdersWrapperObj.Order_Source.equalsIgnoreCase(Constants.ORDER_STATUS_MAGENTO) 
            && String.isNotBlank(xtentoSFDCOrdersWrapperObj.GiftCard) 
            && Double.valueOf(xtentoSFDCOrdersWrapperObj.GiftCard) != Constants.NUMERIC_ZERO_VALUE) 
        {
            otherROLineItem.add(createGiftOrderLineItem(
                xtentoSFDCOrdersWrapperObj, orderDetails, orderLineExternalIdReceivedOrderLineMap));
        }
        
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Order_Source) 
            && xtentoSFDCOrdersWrapperObj.Order_Source.equalsIgnoreCase(Constants.ORDER_STATUS_MAGENTO) 
            && String.isNotBlank(xtentoSFDCOrdersWrapperObj.Qty_Refunded) 
            && Double.valueOf(xtentoSFDCOrdersWrapperObj.Qty_Refunded) != Constants.NUMERIC_ZERO_VALUE) 
        {
            otherROLineItem.add(createRefundOrderLineItem(
                xtentoSFDCOrdersWrapperObj, orderDetails, orderLineExternalIdReceivedOrderLineMap));
        }
        
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Order_Source) 
            && xtentoSFDCOrdersWrapperObj.Order_Source.equalsIgnoreCase(Constants.ORDER_STATUS_MAGENTO)) 
        {
            Double orderShippingAmount = String.isNotBlank(xtentoSFDCOrdersWrapperObj.Order_Shipping_Amount) ? 
                Double.valueOf(xtentoSFDCOrdersWrapperObj.Order_Shipping_Amount) : Constants.NUMERIC_ZERO_VALUE;
            Double totalShippingRefundedAmount = 
                (String.isNotBlank(xtentoSFDCOrdersWrapperObj.total_shipping_refunded) ? 
                 Double.valueOf(xtentoSFDCOrdersWrapperObj.total_shipping_refunded) : Constants.NUMERIC_ZERO_VALUE);
            Double totalShippingAmount = orderShippingAmount - totalShippingRefundedAmount;
            if(totalShippingAmount > 0) 
            {
                otherROLineItem.add(createShippingOrderLineItem(
                    xtentoSFDCOrdersWrapperObj, orderDetails, orderLineExternalIdReceivedOrderLineMap, totalShippingAmount));
            }
        }
        
        return otherROLineItem;
    }
    
    private static SCMC__Received_Order_Line__c createShippingOrderLineItem(
        XtentoSFDCOrdersWrapper xtentoSFDCOrdersWrapperObj, SCMC__Received_Order__c orderDetails, 
        Map<String, SCMC__Received_Order_Line__c> orderLineExternalIdReceivedOrderLineMap, Double totalShippingAmount) 
    {
        String orderId = getXtentoFormattedOrderId(xtentoSFDCOrdersWrapperObj.Order_Id);
        SCMC__Received_Order_Line__c orderLineObj = new SCMC__Received_Order_Line__c();
        if(orderLineExternalIdReceivedOrderLineMap.containsKey(
            orderDetails.SCMC__Order_Id__c + (orderId + Constants.SHIPPPING_LINE_ID_POSTFIX))) 
        {
            orderLineObj = orderLineExternalIdReceivedOrderLineMap.get(
                orderDetails.SCMC__Order_Id__c + (orderId + Constants.SHIPPPING_LINE_ID_POSTFIX));
        }
        
        // Assigning only orderId when line item is new due to avoid parent changes error
        if(String.isBlank(orderLineObj.Id)) 
        {
            orderLineObj.SCMC__Received_Order__c = orderDetails.Id;
        }
        orderLineObj.SCMC__Product_Unit_Price__c = totalShippingAmount;
        orderLineObj.Item_Id__c = Constants.SHIPPPING_LINE_ID_POSTFIX;
        orderLineObj.Line_Id__c = orderId + Constants.SHIPPPING_LINE_ID_POSTFIX;
        orderLineObj.SCMC__Product_Description__c = Constants.ITEM_NAME_SHIPPING_FEES;
        orderLineObj.SCMC__Product_Name__c = Constants.ITEM_NAME_SHIPPING_FEES;
        orderLineObj.SCMC__Product_Quantity__c = Constants.NUMERIC_ONE_VALUE;
        orderLineObj.Product_Discount__c = Constants.NUMERIC_ZERO_VALUE;
        orderLineObj.Product_List_Price__c = Constants.NUMERIC_ZERO_VALUE;
        if(!onlineSalesAccountDetails.isEmpty()) 
        {
            orderLineObj.Related_Account__c = onlineSalesAccountDetails[0].Id;
        }
        
        return orderLineObj;
    }
    
    private static SCMC__Received_Order_Line__c createDiscountOrderLineItem(XtentoSFDCOrdersWrapper xtentoSFDCOrdersWrapperObj, 
        SCMC__Received_Order__c orderDetails, Map<String, SCMC__Received_Order_Line__c> orderLineExternalIdReceivedOrderLineMap) 
    {
        String orderId = getXtentoFormattedOrderId(xtentoSFDCOrdersWrapperObj.Order_Id);
        SCMC__Received_Order_Line__c orderLineObj = new SCMC__Received_Order_Line__c();
        if(orderLineExternalIdReceivedOrderLineMap.containsKey(
            orderDetails.SCMC__Order_Id__c + (orderId + Constants.DISCOUNT_LINE_ID_POSTFIX))) 
        {
            orderLineObj = orderLineExternalIdReceivedOrderLineMap.get(
                orderDetails.SCMC__Order_Id__c + (orderId + Constants.DISCOUNT_LINE_ID_POSTFIX));
        }
        
        // Assigning only orderId when line item is new due to avoid parent changes error
        if(String.isBlank(orderLineObj.Id)) 
        {
            orderLineObj.SCMC__Received_Order__c = orderDetails.Id;
        }
        orderLineObj.SCMC__Product_Unit_Price__c = Double.valueOf(xtentoSFDCOrdersWrapperObj.Coupon_Amount);
        orderLineObj.SCMC__Comments__c = 
            (String.isNotBlank(xtentoSFDCOrdersWrapperObj.Coupon_Code) ? 
            (Constants.COUPON_CODE + Constants.STRING_COLON + xtentoSFDCOrdersWrapperObj.Coupon_Code) : null);
        orderLineObj.Coupon_Rule__c = 
            (String.isNotBlank(xtentoSFDCOrdersWrapperObj.Coupon_Rule) ? xtentoSFDCOrdersWrapperObj.Coupon_Rule : null);
        orderLineObj.Item_Id__c = Constants.DISCOUNT_LINE_ID_POSTFIX;
        orderLineObj.Line_Id__c = orderId + Constants.DISCOUNT_LINE_ID_POSTFIX;
        orderLineObj.SCMC__Product_Description__c = Constants.ITEM_NAME_DISCOUNT;
        orderLineObj.SCMC__Product_Name__c = Constants.ITEM_NAME_DISCOUNT;
        orderLineObj.SCMC__Product_Quantity__c = Constants.NUMERIC_ONE_VALUE;
        orderLineObj.Product_Discount__c = Constants.NUMERIC_ZERO_VALUE;
        orderLineObj.Product_List_Price__c = Constants.NUMERIC_ZERO_VALUE;
        if(!onlineSalesAccountDetails.isEmpty()) 
        {
            orderLineObj.Related_Account__c = onlineSalesAccountDetails[0].Id;
        }
        
        return orderLineObj;
    }
    
    private static SCMC__Received_Order_Line__c createGiftOrderLineItem(XtentoSFDCOrdersWrapper xtentoSFDCOrdersWrapperObj, 
        SCMC__Received_Order__c orderDetails, Map<String, SCMC__Received_Order_Line__c> orderLineExternalIdReceivedOrderLineMap) 
    {
        String orderId = getXtentoFormattedOrderId(xtentoSFDCOrdersWrapperObj.Order_Id);
        SCMC__Received_Order_Line__c orderLineObj = new SCMC__Received_Order_Line__c();
        if(orderLineExternalIdReceivedOrderLineMap.containsKey(
            orderDetails.SCMC__Order_Id__c + (orderId + Constants.GIFTCARD_LINE_ID_POSTFIX))) 
        {
            orderLineObj = orderLineExternalIdReceivedOrderLineMap.get(
                orderDetails.SCMC__Order_Id__c + (orderId + Constants.GIFTCARD_LINE_ID_POSTFIX));
        }
        
        // Assigning only orderId when line item is new due to avoid parent changes error
        if(String.isBlank(orderLineObj.Id)) 
        {
            orderLineObj.SCMC__Received_Order__c = orderDetails.Id;
        }
        orderLineObj.SCMC__Product_Unit_Price__c = Double.valueOf(xtentoSFDCOrdersWrapperObj.GiftCard);
        orderLineObj.Item_Id__c = Constants.GIFTCARD_LINE_ID_POSTFIX;
        orderLineObj.Line_Id__c = orderId + Constants.GIFTCARD_LINE_ID_POSTFIX;
        orderLineObj.SCMC__Product_Description__c = Constants.ITEM_NAME_GIFT_CARD;
        orderLineObj.SCMC__Product_Name__c = Constants.ITEM_NAME_GIFT_CARD;
        orderLineObj.SCMC__Product_Quantity__c = Constants.NUMERIC_ONE_VALUE;
        orderLineObj.Product_Discount__c = Constants.NUMERIC_ZERO_VALUE;
        orderLineObj.Product_List_Price__c = Constants.NUMERIC_ZERO_VALUE;
        orderLineObj.Gift_Card_Code__c = 
            String.isNotBlank(xtentoSFDCOrdersWrapperObj.Gift_Card_Code) ? xtentoSFDCOrdersWrapperObj.Gift_Card_Code : null;
        if(!onlineSalesAccountDetails.isEmpty()) 
        {
            orderLineObj.Related_Account__c = onlineSalesAccountDetails[0].Id;
        }
        
        return orderLineObj;
    }
    
    private static SCMC__Received_Order_Line__c createRefundOrderLineItem(XtentoSFDCOrdersWrapper xtentoSFDCOrdersWrapperObj, 
        SCMC__Received_Order__c orderDetails, Map<String, SCMC__Received_Order_Line__c> orderLineExternalIdReceivedOrderLineMap) 
    {
        String orderId = getXtentoFormattedOrderId(xtentoSFDCOrdersWrapperObj.Order_Id);
        SCMC__Received_Order_Line__c orderLineObj = new SCMC__Received_Order_Line__c();
        if(orderLineExternalIdReceivedOrderLineMap.containsKey(
            orderDetails.SCMC__Order_Id__c + (orderId + Constants.REFUNDED_LINE_ID_POSTFIX))) 
        {
            orderLineObj = orderLineExternalIdReceivedOrderLineMap.get(
                orderDetails.SCMC__Order_Id__c + (orderId + Constants.REFUNDED_LINE_ID_POSTFIX));
        }
        
        // Assigning only orderId when line item is new due to avoid parent changes error
        if(String.isBlank(orderLineObj.Id)) 
        {
            orderLineObj.SCMC__Received_Order__c = orderDetails.Id;
        }
        orderLineObj.Product_List_Price__c = String.isNotBlank(xtentoSFDCOrdersWrapperObj.Item_Cost) ? 
            Double.valueOf(xtentoSFDCOrdersWrapperObj.Item_Cost) : Constants.NUMERIC_ZERO_VALUE;
        orderLineObj.SCMC__Product_Unit_Price__c = String.isNotBlank(xtentoSFDCOrdersWrapperObj.Item_Product_Current_Price) ? 
            Double.valueOf(xtentoSFDCOrdersWrapperObj.Item_Product_Current_Price) : Constants.NUMERIC_ZERO_VALUE;
        orderLineObj.SCMC__Comments__c = 
            (String.isNotBlank(xtentoSFDCOrdersWrapperObj.Coupon_Code) ? 
            (Constants.COUPON_CODE + Constants.STRING_COLON + xtentoSFDCOrdersWrapperObj.Coupon_Code) : null);
        orderLineObj.Product_Discount__c = 
            String.isNotBlank(xtentoSFDCOrdersWrapperObj.Coupon_Amount) ? 
            Double.valueOf(xtentoSFDCOrdersWrapperObj.Coupon_Amount) : Constants.NUMERIC_ZERO_VALUE;
        orderLineObj.SCMC__Product_Quantity__c = String.isNotBlank(xtentoSFDCOrdersWrapperObj.qty_refunded) ? 
            Double.valueOf(xtentoSFDCOrdersWrapperObj.qty_refunded) : Constants.NUMERIC_ZERO_VALUE;
        orderLineObj.Coupon_Rule__c = 
            (String.isNotBlank(xtentoSFDCOrdersWrapperObj.Coupon_Rule) ? xtentoSFDCOrdersWrapperObj.Coupon_Rule : null);
        orderLineObj.Item_Id__c = Constants.REFUNDED_LINE_ID_POSTFIX;
        orderLineObj.Line_Id__c = orderId + Constants.REFUNDED_LINE_ID_POSTFIX;
        orderLineObj.SCMC__Product_Description__c = xtentoSFDCOrdersWrapperObj.Item_Name;
        orderLineObj.SCMC__Product_Name__c = xtentoSFDCOrdersWrapperObj.Item_SKU;
        orderLineObj.Product_Variation__c = xtentoSFDCOrdersWrapperObj.Item_Product_Variation;
        orderLineObj.Gift_Card_Code__c = xtentoSFDCOrdersWrapperObj.Gift_Card_Code;
        if(!onlineSalesAccountDetails.isEmpty()) 
        {
            orderLineObj.Related_Account__c = onlineSalesAccountDetails[0].Id;
        }
        
        return orderLineObj;
    }
    
    private static SCMC__Received_Order_Line__c createOrderLineItemByWrapper(
        XtentoSFDCOrdersWrapper xtentoSFDCOrdersWrapperObj, SCMC__Received_Order__c orderDetails, 
        Map<String, SCMC__Received_Order_Line__c> orderLineExternalIdReceivedOrderLineMap, DateTime syncUpTime) 
    {
        SCMC__Received_Order_Line__c orderLineObj = new SCMC__Received_Order_Line__c();
        orderLineObj.Last_Sync_On__c = syncUpTime;
        orderLineObj.Error_Message__c = null;
        if(orderLineExternalIdReceivedOrderLineMap.containsKey(orderDetails.SCMC__Order_Id__c + xtentoSFDCOrdersWrapperObj.Line_Id)) 
        {
           orderLineObj = orderLineExternalIdReceivedOrderLineMap.get(orderDetails.SCMC__Order_Id__c + xtentoSFDCOrdersWrapperObj.Line_Id);
        }
        // Assigning only orderId when line item is new due to avoid parent changes error
        if(String.isBlank(orderLineObj.Id)) 
        {
            orderLineObj.SCMC__Received_Order__c = orderDetails.Id;
        }
        
        orderLineObj.Item_Id__c = xtentoSFDCOrdersWrapperObj.Item_Id;
        orderLineObj.Line_Id__c = xtentoSFDCOrdersWrapperObj.Line_Id;
        if(!onlineSalesAccountDetails.isEmpty()) 
        {
            orderLineObj.Related_Account__c = onlineSalesAccountDetails[0].Id;
        }
        orderLineObj.SCMC__Product_Description__c = xtentoSFDCOrdersWrapperObj.Item_Name;
        orderLineObj.SCMC__Product_Name__c = xtentoSFDCOrdersWrapperObj.Item_SKU;
        orderLineObj.Product_Variation__c = xtentoSFDCOrdersWrapperObj.Item_Product_Variation;
        orderLineObj.Product_List_Price__c = 
            (String.isNotBlank(xtentoSFDCOrdersWrapperObj.Item_Cost) ? 
             Double.valueOf(xtentoSFDCOrdersWrapperObj.Item_Cost) : Constants.NUMERIC_ZERO_VALUE);
        orderLineObj.SCMC__Product_Unit_Price__c = 
            (String.isNotBlank(xtentoSFDCOrdersWrapperObj.Item_Product_Current_Price) ? 
             Double.valueOf(xtentoSFDCOrdersWrapperObj.Item_Product_Current_Price) : Constants.NUMERIC_ZERO_VALUE);
        orderLineObj.Gift_Card__c = 
            (String.isNotBlank(xtentoSFDCOrdersWrapperObj.GiftCard) ? 
             Double.valueOf(xtentoSFDCOrdersWrapperObj.GiftCard) : Constants.NUMERIC_ZERO_VALUE);
        orderLineObj.SCMC__Comments__c = 
            (String.isNotBlank(xtentoSFDCOrdersWrapperObj.Coupon_Code) ? 
             (Constants.COUPON_CODE + Constants.STRING_COLON + xtentoSFDCOrdersWrapperObj.Coupon_Code) : null);
        orderLineObj.Product_Discount__c = (String.isNotBlank(xtentoSFDCOrdersWrapperObj.Coupon_Amount) ? 
             Double.valueOf(xtentoSFDCOrdersWrapperObj.Coupon_Amount) : Constants.NUMERIC_ZERO_VALUE);
        
        orderLineObj.SCMC__Product_Quantity__c = Constants.NUMERIC_ZERO_VALUE;
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Item_Quantity)) 
        {
            orderLineObj.SCMC__Product_Quantity__c = Decimal.valueOf(xtentoSFDCOrdersWrapperObj.Item_Quantity);
        } 
        orderLineObj.Gift_Card_Code__c = xtentoSFDCOrdersWrapperObj.Gift_Card_Code;
        orderLineObj.Coupon_Rule__c = xtentoSFDCOrdersWrapperObj.Coupon_Rule;
        
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Tax_Refunded)) 
        {
            orderLineObj.Tax_Refunded__c = Decimal.valueOf(xtentoSFDCOrdersWrapperObj.Tax_Refunded);
        }
        
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Qty_Refunded)) 
        {
            orderLineObj.Quantity_Refunded__c = Decimal.valueOf(xtentoSFDCOrdersWrapperObj.Qty_Refunded);
        }
        
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Shipping_Refunded)) 
        {
            orderLineObj.Shipping_Refunded__c = Decimal.valueOf(xtentoSFDCOrdersWrapperObj.Shipping_Refunded);
        }
        
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Adjustment_Negative)) 
        {
            orderLineObj.Adjustment_Negative__c = Decimal.valueOf(xtentoSFDCOrdersWrapperObj.Adjustment_Negative);
        }
        
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Adjustment_Positive)) 
        {
            orderLineObj.Adjustment_Positive__c = Decimal.valueOf(xtentoSFDCOrdersWrapperObj.Adjustment_Positive);
        }
        return orderLineObj;
    }
    
    private static SCMC__Received_Order__c createReceivedOrderRecordByWrapper(
        XtentoSFDCOrdersWrapper xtentoSFDCOrdersWrapperObj, Map<String, SCMC__Received_Order__c> orderIdReceivedOrderMap, 
        Map<String, SCMC__Customer_Address__c> customerAddressesCustomerNumberMap, DateTime syncUpTime) 
    {
        SCMC__Received_Order__c receivedOrderObj = new SCMC__Received_Order__c();
        receivedOrderObj.Last_Sync_On__c = syncUpTime;
        receivedOrderObj.Error_Message__c = null;
        
        String orderId = getXtentoFormattedOrderId(xtentoSFDCOrdersWrapperObj.Order_Id);        
        if(orderIdReceivedOrderMap.containsKey(orderId)) 
        {
            receivedOrderObj.Id = orderIdReceivedOrderMap.get(orderId).Id;
        }
        
        receivedOrderObj.Order_Status__c = getXtentoOrderStatus(xtentoSFDCOrdersWrapperObj.Order_Status);
        receivedOrderObj.SCMC__Account_Name__c = Constants.ACCOUNT_NAME_ONLINE_SALES;
        
        receivedOrderObj.SCMC__Order_Date__c = null;        
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Order_Date)) 
        {
            receivedOrderObj.SCMC__Order_Date__c = convertXtentoFormattedDateToRequiredFormat(xtentoSFDCOrdersWrapperObj.Order_Date, 'Order_Date');
        }
        
        receivedOrderObj.Completed_Date__c = null;
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Completed_Date)) 
        {
            receivedOrderObj.Completed_Date__c = convertXtentoFormattedDateToRequiredFormat(xtentoSFDCOrdersWrapperObj.Completed_Date, 'Completed_Date');
        }
        receivedOrderObj.SCMC__Order_Id__c = orderId;
        receivedOrderObj.Customer_Username__c = xtentoSFDCOrdersWrapperObj.Customer_Username;
        receivedOrderObj.SCMC__Customer_Number__c = xtentoSFDCOrdersWrapperObj.Customer_User_Id;
        receivedOrderObj.SCMC__Customer_Type__c = xtentoSFDCOrdersWrapperObj.Customer_Role;
        receivedOrderObj.SCMC__Order_Comments__c = xtentoSFDCOrdersWrapperObj.Customer_Note;
        receivedOrderObj.Transaction_Id__c = xtentoSFDCOrdersWrapperObj.Transaction_Id;
        receivedOrderObj.Company_Name__c = xtentoSFDCOrdersWrapperObj.Company_Billing;
        receivedOrderObj.Customer_Name__c = xtentoSFDCOrdersWrapperObj.Full_Name_Billing;
        receivedOrderObj.SCMC__Order_Source__c = xtentoSFDCOrdersWrapperObj.Order_Source;
        
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Customer_User_Id)) 
        {
            String xtendtoFormattedCustomerIdBilling = 
                getXtentoFormattedCustomerBillingNumber(xtentoSFDCOrdersWrapperObj.Customer_User_Id);
            if(customerAddressesCustomerNumberMap.containsKey(xtendtoFormattedCustomerIdBilling)) 
            {
                receivedOrderObj.Override_Bill_To_Address__c = 
                    customerAddressesCustomerNumberMap.get(xtendtoFormattedCustomerIdBilling).Id;
            }
            
            String xtendtoFormattedCustomerIdShipping = 
                getXtentoFormattedCustomerShippingNumber(xtentoSFDCOrdersWrapperObj.Customer_User_Id);
            if(customerAddressesCustomerNumberMap.containsKey(xtendtoFormattedCustomerIdShipping)) 
            {
                receivedOrderObj.Override_Ship_To_Address__c = 
                    customerAddressesCustomerNumberMap.get(xtendtoFormattedCustomerIdShipping).Id;
            }
        }        
        
        receivedOrderObj.SCMC__Customer_Address1__c = xtentoSFDCOrdersWrapperObj.Address_1_Billing;
        receivedOrderObj.SCMC__Customer_Address2__c = xtentoSFDCOrdersWrapperObj.Address_2_Billing;
        receivedOrderObj.SCMC__Customer_City__c = xtentoSFDCOrdersWrapperObj.City_Billing;
        receivedOrderObj.SCMC__Customer_State__c = xtentoSFDCOrdersWrapperObj.State_Name_Billing;
        receivedOrderObj.SCMC__Customer_Postal_Code__c = xtentoSFDCOrdersWrapperObj.Zip_Billing;
        receivedOrderObj.SCMC__Customer_Country__c = xtentoSFDCOrdersWrapperObj.Country_Name_Billing;
        receivedOrderObj.SCMC__Customer_Email__c = xtentoSFDCOrdersWrapperObj.Email_Billing;
        receivedOrderObj.SCMC__Customer_Phone__c = xtentoSFDCOrdersWrapperObj.Phone_Billing;
        receivedOrderObj.SCMC__Payment_Method__c = xtentoSFDCOrdersWrapperObj.Payment_Method_Title;
        receivedOrderObj.SCMC__Shipping_Company__c = xtentoSFDCOrdersWrapperObj.Company_Shipping;
        receivedOrderObj.SCMC__Shipping_Address1__c = xtentoSFDCOrdersWrapperObj.Address_1_Shipping;
        receivedOrderObj.SCMC__Shipping_Address2__c = xtentoSFDCOrdersWrapperObj.Address_2_Shipping;
        receivedOrderObj.SCMC__Shipping_City__c = xtentoSFDCOrdersWrapperObj.City_Shipping;
        receivedOrderObj.SCMC__Shipping_State__c = xtentoSFDCOrdersWrapperObj.State_Name_Shipping;
        receivedOrderObj.SCMC__Shipping_Postal_Code__c = xtentoSFDCOrdersWrapperObj.Zip_Shipping;
        receivedOrderObj.SCMC__Shipping_Country__c = xtentoSFDCOrdersWrapperObj.Country_Name_Shipping;
        receivedOrderObj.SCMC__Shipping_Name__c = xtentoSFDCOrdersWrapperObj.Full_Name_Shipping;
        receivedOrderObj.SCMC__Shipping_Method__c = xtentoSFDCOrdersWrapperObj.Shipping_Method_Title;
        receivedOrderObj.Custom_Options__c = xtentoSFDCOrdersWrapperObj.Custom_Options;
        receivedOrderObj.SCMC__Currency__c = xtentoSFDCOrdersWrapperObj.Currency_Value;
        
        Double shippingAmount = 
            (String.isNotBlank(xtentoSFDCOrdersWrapperObj.Order_Shipping_Amount) ? 
             Double.valueOf(xtentoSFDCOrdersWrapperObj.Order_Shipping_Amount) : Constants.NUMERIC_ZERO_VALUE);
        Double totalShippingRefundedAmount = 
            (String.isNotBlank(xtentoSFDCOrdersWrapperObj.total_shipping_refunded) ? 
             Double.valueOf(xtentoSFDCOrdersWrapperObj.total_shipping_refunded) : Constants.NUMERIC_ZERO_VALUE);
        receivedOrderObj.Order_Shipping_Amount__c = shippingAmount - totalShippingRefundedAmount;
        
        Double orderTotalTaxAmount = 
            (String.isNotBlank(xtentoSFDCOrdersWrapperObj.Order_Total_Tax_Amount) ? 
             Double.valueOf(xtentoSFDCOrdersWrapperObj.Order_Total_Tax_Amount) : Constants.NUMERIC_ZERO_VALUE);
        Double totalTaxRefundedAmount = 
            (String.isNotBlank(xtentoSFDCOrdersWrapperObj.total_tax_refunded) ? 
             Double.valueOf(xtentoSFDCOrdersWrapperObj.total_tax_refunded) : Constants.NUMERIC_ZERO_VALUE);
        receivedOrderObj.Order_Total_Tax_Amount__c = orderTotalTaxAmount - totalTaxRefundedAmount;
        receivedOrderObj.SCMC__Total_Tax__c = orderTotalTaxAmount - totalTaxRefundedAmount;
        
        Double totalAmountWithoutTax = 
            (String.isNotBlank(xtentoSFDCOrdersWrapperObj.Order_Total_Amount_without_Tax) ? 
             Double.valueOf(xtentoSFDCOrdersWrapperObj.Order_Total_Amount_without_Tax) : Constants.NUMERIC_ZERO_VALUE);
        Double subtotalRefunded = 
            (String.isNotBlank(xtentoSFDCOrdersWrapperObj.subtotal_refunded) ? 
             Double.valueOf(xtentoSFDCOrdersWrapperObj.subtotal_refunded) : Constants.NUMERIC_ZERO_VALUE);
        receivedOrderObj.Order_Total_Amount_without_Tax__c = totalAmountWithoutTax - subtotalRefunded;
        receivedOrderObj.Order_Subtotal__c = totalAmountWithoutTax - subtotalRefunded;
        
        Double totalAmount = 
            (String.isNotBlank(xtentoSFDCOrdersWrapperObj.Order_Total_Amount) ? 
             Double.valueOf(xtentoSFDCOrdersWrapperObj.Order_Total_Amount) : Constants.NUMERIC_ZERO_VALUE);
        Double totalRefunded = 
            (String.isNotBlank(xtentoSFDCOrdersWrapperObj.total_refunded) ? 
             Double.valueOf(xtentoSFDCOrdersWrapperObj.total_refunded) : Constants.NUMERIC_ZERO_VALUE);
        receivedOrderObj.Order_Total_Amount__c = totalAmount - totalRefunded;
        receivedOrderObj.Order_Total__c = totalAmount - totalRefunded;
        
        receivedOrderObj.Subtotal_Refunded__c = Constants.NUMERIC_ZERO_VALUE;
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Subtotal_Refunded)) 
        {
            receivedOrderObj.Subtotal_Refunded__c = Decimal.valueOf(xtentoSFDCOrdersWrapperObj.Subtotal_Refunded);
        }
        
        receivedOrderObj.Total_Refunded__c = Constants.NUMERIC_ZERO_VALUE;
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Total_Refunded)) 
        {
            receivedOrderObj.Total_Refunded__c = Decimal.valueOf(xtentoSFDCOrdersWrapperObj.Total_Refunded);
        }
        
        receivedOrderObj.Total_Shipping_Refunded__c = Constants.NUMERIC_ZERO_VALUE;
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Total_Shipping_Refunded)) 
        {
            receivedOrderObj.Total_Shipping_Refunded__c = Decimal.valueOf(xtentoSFDCOrdersWrapperObj.Total_Shipping_Refunded);
        }
        
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Coupon_Rule)) 
        {
            receivedOrderObj.Coupon_Rule__c = xtentoSFDCOrdersWrapperObj.Coupon_Rule;
        }
        
        receivedOrderObj.Total_Tax_Refunded__c = Constants.NUMERIC_ZERO_VALUE;
        if(String.isNotBlank(xtentoSFDCOrdersWrapperObj.Total_Tax_Refunded)) 
        {
            receivedOrderObj.Total_Tax_Refunded__c = Decimal.valueOf(xtentoSFDCOrdersWrapperObj.Total_Tax_Refunded);
        }
        
        return receivedOrderObj;
    }
    
    private static String getXtentoFormattedOrderId(String orderId) 
    {
        String xtentoFormattedOrderId = orderId;
        if(String.isNotBlank(xtentoFormattedOrderId) && Double.valueOf(xtentoFormattedOrderId) >= LOWEST_N_DIGIT_NUMBER) 
        {
            return xtentoFormattedOrderId;
        } 
        else if(String.isNotBlank(xtentoFormattedOrderId))
        {
            xtentoFormattedOrderId = N_TIMES_ZERO_NUMBER_STRING.left(Constants.MIN_ORDER_ID_LENGTH - xtentoFormattedOrderId.length()) + xtentoFormattedOrderId;
        }
        /*if(String.isNotBlank(orderId) 
           && orderId.startsWith(Constants.ORDER_ID_PREFIX)) 
        {
            xtentoFormattedOrderId = orderId;
        } else {
            xtentoFormattedOrderId = Constants.ORDER_ID_PREFIX + orderId;
        }*/
        
        return xtentoFormattedOrderId;
    }
    
    private static String getXtentoFormattedCustomerBillingName(String customerName) 
    {
        String xtentoFormattedCustomerName = '';
        if(String.isNotBlank(customerName)) 
        {
            if(customerName.contains(Constants.FULL_NAME_BILLING_POSTFIX)) 
            {
                xtentoFormattedCustomerName = customerName;
            } 
            else 
            {
                xtentoFormattedCustomerName =
                    customerName + Constants.BLANK_SPACE + Constants.FULL_NAME_BILLING_POSTFIX;
            }
        }
        
        return xtentoFormattedCustomerName;
    }
    
    private static String getXtentoFormattedCustomerShippingName(String customerName) 
    {
        String xtentoFormattedCustomerName = '';
        if(String.isNotBlank(customerName)) 
        {
            if(customerName.contains(Constants.FULL_NAME_SHIPPING_POSTFIX)) 
            {
                xtentoFormattedCustomerName = customerName;
            } 
            else 
            {
                xtentoFormattedCustomerName =
                    customerName + Constants.BLANK_SPACE + Constants.FULL_NAME_SHIPPING_POSTFIX;
            }
        }
        return xtentoFormattedCustomerName;
    }
    
    private static String getXtentoFormattedCustomerBillingNumber(String customerNumber) 
    {
        String xtentoFormattedCustomerNumber = '';
        if(String.isNotBlank(customerNumber)) 
        {
            xtentoFormattedCustomerNumber = Constants.BILLING_CUSTOMER_NUMBER_PREFIX + customerNumber;
        }
        return xtentoFormattedCustomerNumber;
    }
    
    private static String getXtentoFormattedCustomerShippingNumber(String customerNumber) 
    {
        String xtentoFormattedCustomerNumber = '';
        if(String.isNotBlank(customerNumber)) 
        {
            xtentoFormattedCustomerNumber = Constants.SHIPPING_CUSTOMER_NUMBER_PREFIX + customerNumber;
        }
        return xtentoFormattedCustomerNumber;
    }
    
    public static DateTime convertXtentoFormattedDateToRequiredFormat(String value, String fieldName) 
    {
        DateTime dateTimeValue;
        if(String.isNotBlank(value)) 
        {
            List<String> dateTimeList = value.split(Constants.BLANK_SPACE);
            if(!dateTimeList.isEmpty() && dateTimeList.size() == 2) {
                List<String> dateList = dateTimeList[0].split(Constants.DATE_DELIMETER_VALUE_DOT);
                List<String> timeList = dateTimeList[1].split(Constants.TIME_DELIMETER_VALUE_COLON);
                if(!dateList.isEmpty() && dateList.size() == 3 && !timeList.isEmpty() && timeList.size() == 3) 
                {
                    dateTimeValue = DateTime.newInstance(
                        Integer.valueOf(dateList[0]), Integer.valueOf(dateList[1]), Integer.valueOf(dateList[2]), 
                        Integer.valueOf(timeList[0]), Integer.valueOf(timeList[1]), Integer.valueOf(timeList[2]));
                }
            }
            
            //dateTimeValue = DateTime.newInstance(Long.valueOf(value)*1000);
            if(dateTimeValue == null) 
            {
                throw new IllegalArgumentException('Invalid Datetime value ' + fieldName);
            }
        }
        return dateTimeValue;
    }
    
    private static String getXtentoOrderStatus(String orderStatus) 
    {
        if(String.isNotBlank(orderStatus) && orderStatus.equalsIgnoreCase('complete')) 
        {
            orderStatus = 'Completed';
        } else if(String.isNotBlank(orderStatus) && orderStatus.equalsIgnoreCase('processing')) 
        {
            orderStatus = 'Processing';
        }  else if(String.isNotBlank(orderStatus) && orderStatus.equalsIgnoreCase('closed')) 
        {
            orderStatus = 'Closed';
        }
        return orderStatus;
    }
    
    private static Double getNDigitPositiveLowestNumber(Integer n) 
    {
        if(LOWEST_N_DIGIT_NUMBER == null) 
        {
            String numberString = Constants.ONE_STRING;
            while(n > numberString.length()) 
            {
                numberString += Constants.ZERO_STRING;
            }
            LOWEST_N_DIGIT_NUMBER = Double.valueOf(numberString);
        }
        return LOWEST_N_DIGIT_NUMBER;
    }
    
    private static String getNTimesZeroString(Integer n) 
    {
        if(N_TIMES_ZERO_NUMBER_STRING == null) 
        {
            String numberString = '';
            while(n > numberString.length()) 
            {
                numberString += Constants.ZERO_STRING;
            }
            N_TIMES_ZERO_NUMBER_STRING = numberString;
        }
        return N_TIMES_ZERO_NUMBER_STRING;
    }
}