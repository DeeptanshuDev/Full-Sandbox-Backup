/**
*   Purpose         :   Magento --> Salesforce - Order Job - Request Wrapper Class
*   Created By      :   Abhinav Sharma
*   Created Date    :   02/08/2022
*   Revision Log    :   v1.0 - Created - 02/08/2022
**/
public without sharing class XtentoSFDCOrdersWrapper 
{
    //Magento side Order Table row ID
    public String Order_Id {get; set;}
    
    public String Order_Status {get; set;}
    public String Order_Date {get; set;}
    public String Completed_Date {get; set;}
    public String Customer_Username {get; set;}
    public String Customer_User_Id {get; set;}
    public String Customer_Role {get; set;}
    public String Customer_Note {get; set;}
    public String Transaction_Id {get; set;}
    
    //Magento side Order Line row --> Product ID
    public String Item_Id {get; set;}
    
    //Magento side Order Line Table row ID
    public String Line_Id {get; set;}
    
    public String Item_Name {get; set;}
    public String Item_SKU {get; set;}
    public String Item_Product_Variation {get; set;}
    public String Item_Quantity {get; set;}
    public String Custom_Options {get; set;}
    public String Item_Cost {get; set;}
    public String Item_Product_Current_Price {get; set;}
    public String GiftCard {get; set;}
    public String Coupon_Code {get; set;}
    public String Coupon_Amount {get; set;}
    public String Company_Billing {get; set;}
    public String Full_Name_Billing {get; set;}
    public String Address_1_Billing {get; set;}
    public String Address_2_Billing {get; set;}
    public String City_Billing {get; set;}
    public String State_Name_Billing {get; set;}
    public String Zip_Billing {get; set;}
    public String Country_Name_Billing {get; set;}
    public String Email_Billing {get; set;}
    public String Phone_Billing {get; set;}
    public String Payment_Method_Title {get; set;}
    public String Company_Shipping {get; set;}
    public String Full_Name_Shipping {get; set;}
    public String Address_1_Shipping {get; set;}
    public String Address_2_Shipping {get; set;}
    public String City_Shipping {get; set;}
    public String State_Name_Shipping {get; set;}
    public String Zip_Shipping {get; set;}
    public String Country_Name_Shipping {get; set;}
    public String Shipping_Method_Title {get; set;}
    public String Currency_Amt {get; set;}
    public String Currency_Value {get; set;}
    public String Order_Tax_Amount {get; set;}
    public String Order_Shipping_Amount {get; set;}
    public String Order_Total_Tax_Amount {get; set;}
    public String Order_Total_Amount_without_Tax {get; set;}
    public String Order_Total_Amount {get; set;}
    public String Tax_Refunded {get; set;}
    public String Qty_Refunded {get; set;}
    public String Shipping_Refunded {get; set;}
    public String Adjustment_Negative {get; set;}
    public String Adjustment_Positive {get; set;}
    public String Subtotal_Refunded {get; set;}
    public String Total_Refunded {get; set;}
    public String Total_Shipping_Refunded {get; set;}
    public String Total_Tax_Refunded {get; set;}
    public String Gift_Card_Code {get; set;}
    public String Coupon_Rule {get; set;}
    public String Order_Date_Timestamp {get; set;}
    public String Completed_Date_Timestamp {get; set;}
    public String Website_Id {get; set;}
    public String Order_Source {get; set;}
}