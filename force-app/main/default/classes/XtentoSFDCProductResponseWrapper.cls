/**
*   Purpose         :   Magento --> Salesforce - Inventory Job - Response Wrapper Class
*   Created By      :   Abhinav Sharma
*   Created Date    :   03/09/2022
*   Revision Log    :   v1.0 - Created - 03/09/2022
**/
public without sharing class XtentoSFDCProductResponseWrapper 
{
    public XtentoSFDCResponseRowDetailsWrapper xtentoSFDCRowDetails {get; set;}
    public String inventoryId {get; set;}
    public String errorMessage {get; set;}
    
    public XtentoSFDCProductResponseWrapper() 
    {
        inventoryId = null;
        xtentoSFDCRowDetails = new XtentoSFDCResponseRowDetailsWrapper();
    }
    
    public XtentoSFDCProductResponseWrapper(XtentoSFDCProductWrapper xtentoSFDCRowDetails, String inventoryId, String errorMessage) 
    {
        //this.xtentoSFDCRowDetails = xtentoSFDCRowDetails;
        if(xtentoSFDCRowDetails != null) 
        {
            this.xtentoSFDCRowDetails = new XtentoSFDCResponseRowDetailsWrapper(xtentoSFDCRowDetails.Sku);
        }
        this.inventoryId = inventoryId;
        this.errorMessage = errorMessage;
    }
    
    private class XtentoSFDCResponseRowDetailsWrapper 
    {
        private String Sku;
        
        XtentoSFDCResponseRowDetailsWrapper() 
        {
            this.Sku = null;
        }
        
        XtentoSFDCResponseRowDetailsWrapper(String Sku) 
        {
            this.Sku = Sku;
        }
    }
}