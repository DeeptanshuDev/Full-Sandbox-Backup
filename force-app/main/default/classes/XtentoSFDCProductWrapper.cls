/**
*   Purpose         :   Magento --> Salesforce - Inventory Job - Request Wrapper Class
*   Created By      :   Abhinav Sharma
*   Created Date    :   03/08/2022
*   Revision Log    :   v1.0 - Created - 03/08/2022
**/
public without sharing class XtentoSFDCProductWrapper 
{    
    public String Sku {get; set;}
    public String StatusCode {get; set;}
    public String ProductName {get; set;}
    public String Quantity {get; set;}
    public String Price {get; set;}
}