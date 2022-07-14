/**
*   Purpose         :   Test Data helper class for Magento-->Salesforce integration
*   Created By      :   Abhinav Sharma
*   Created Date    :   03/18/2022
*   Revision Log    :   v1.0 - Created - 03/18/2022
**/
public without sharing class TestXtentoSFDCRestResourcesDataHelper 
{
    public static XtentoSFDCOrdersWrapper createXtentoSFDCOrderWrapper(String orderId, String lineId, String itemId) 
    {
        XtentoSFDCOrdersWrapper wrapperObj = new XtentoSFDCOrdersWrapper();
        wrapperObj.Order_Source = 'Magento';
        wrapperObj.Zip_Shipping = '72525';
        wrapperObj.Zip_Billing = '72525';
        wrapperObj.Transaction_Id = '60186876207';
        wrapperObj.Total_Tax_Refunded = '0.00';
        wrapperObj.Total_Shipping_Refunded = '0.00';
        wrapperObj.Total_Refunded = '0.00';
        wrapperObj.Tax_Refunded = '0.00';
        wrapperObj.Subtotal_Refunded = '0.00';
        wrapperObj.State_Name_Shipping = 'Texas';
        wrapperObj.State_Name_Billing = 'Texas';
        wrapperObj.Shipping_Refunded = '0.00';
        wrapperObj.Shipping_Method_Title = 'Flat Rate - Fixed';
        wrapperObj.Qty_Refunded = '0';
        wrapperObj.Phone_Billing = '800784233';
        wrapperObj.Payment_Method_Title = 'Credit Card';
        wrapperObj.Order_Total_Tax_Amount = '0.00';
        wrapperObj.Order_Total_Amount_without_Tax = '46.5';
        wrapperObj.Order_Total_Amount = '46.50';
        wrapperObj.Order_Tax_Amount = '0.00';
        wrapperObj.Order_Status = 'processing';
        wrapperObj.Order_Shipping_Amount = '7.0000';
        wrapperObj.Order_Id = orderId;
        wrapperObj.Order_Date = '2022.02.17 01:38:51';
        wrapperObj.Line_Id = lineId;
        wrapperObj.Item_SKU = 'RR1433-YM';
        wrapperObj.Item_Quantity = '1';
        wrapperObj.Item_Product_Variation = 'Color:Black Size Chart:YM Size:M Shoe Size:';
        wrapperObj.Item_Product_Current_Price = '39.50';
        wrapperObj.Item_Name = 'Energy Jogger in Black-YM';
        wrapperObj.Item_Id = itemId;
        wrapperObj.Item_Cost = '0.00';
        wrapperObj.GiftCard = '0.00';
        wrapperObj.Gift_Card_Code = '';
        wrapperObj.Full_Name_Shipping = 'Nilesh Dhumal';
        wrapperObj.Full_Name_Billing = 'Nilesh Dhumal';
        wrapperObj.Email_Billing = 'nilesh.dhumal@fexe.com';
        wrapperObj.Customer_Username = 'Nilesh Dhumal';
        wrapperObj.Customer_User_Id = '800784233';
        wrapperObj.Customer_Role = '';
        wrapperObj.Customer_Note = '';
        wrapperObj.Custom_Options = '';
        wrapperObj.Currency_Amt = 'USD';
        wrapperObj.Coupon_Rule = '';
        wrapperObj.Coupon_Code = '';
        wrapperObj.Coupon_Amount = '0.00';
        wrapperObj.Country_Name_Shipping = 'US';
        wrapperObj.Country_Name_Billing = 'US';
        wrapperObj.Completed_Date = '2022.02.17 01:38:51';
        wrapperObj.Company_Shipping = 'Fexle';
        wrapperObj.Company_Billing = 'Fexle';
        wrapperObj.City_Shipping = 'Dallas';
        wrapperObj.City_Billing = 'Dallas';
        wrapperObj.Adjustment_Positive = '0.00';
        wrapperObj.Adjustment_Negative = '0.00';
        wrapperObj.Address_2_Shipping = '';
        wrapperObj.Address_2_Billing = '';
        wrapperObj.Address_1_Shipping = '6146 Honey Bluff Parkway';
        wrapperObj.Address_1_Billing = '6146 Honey Bluff Parkwayyyyyyyyyyyyyyyyyyyyy';
        return wrapperObj;
    }
    
    public static XtentoSFDCProductWrapper createXtentoSFDCProductWrapper(String sku, String productName, String statusCode, String quantity, String price) 
    {
        XtentoSFDCProductWrapper wrapperObj = new XtentoSFDCProductWrapper();
        wrapperObj.Sku = sku;
        wrapperObj.StatusCode = statusCode;
        wrapperObj.ProductName = productName;
        wrapperObj.Quantity = quantity;
        wrapperObj.Price = price;
        return wrapperObj;
    }
}