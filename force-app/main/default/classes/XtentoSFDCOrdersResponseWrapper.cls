/**
*   Purpose         :   Magento --> Salesforce - Order Job - Response Wrapper Class
*   Created By      :   Abhinav Sharma
*   Created Date    :   02/09/2022
*   Revision Log    :   v1.0 - Created - 02/09/2022
**/
public without sharing class XtentoSFDCOrdersResponseWrapper 
{
    public XtentoSFDCResponseRowDetailsWrapper xtentoSFDCRowDetails {get; set;}
    public String idValue {get; set;}
    public String orderErrorMessage {get; set;}
    public String idValueLineItem {get; set;}
    public String lineErrorMessage {get; set;}
    
    public XtentoSFDCOrdersResponseWrapper() 
    {
        idValue = null;
        idValueLineItem = null;
        xtentoSFDCRowDetails = new XtentoSFDCResponseRowDetailsWrapper();
    }
    
    public XtentoSFDCOrdersResponseWrapper(XtentoSFDCOrdersWrapper xtentoSFDCRowDetails, String idValue, String idValueLineItem, 
                                           String orderErrorMessage, String lineErrorMessage) 
    {
    	//this.xtentoSFDCRowDetails = xtentoSFDCRowDetails;
        if(xtentoSFDCRowDetails != null) 
        {
            this.xtentoSFDCRowDetails = new XtentoSFDCResponseRowDetailsWrapper(xtentoSFDCRowDetails.Order_Id, xtentoSFDCRowDetails.Item_Id,
                                                                               xtentoSFDCRowDetails.Line_Id);
        }
        this.idValue = idValue;
        this.idValueLineItem = idValueLineItem;
        this.orderErrorMessage = orderErrorMessage;
        this.lineErrorMessage = lineErrorMessage;
    }
    
    private class XtentoSFDCResponseRowDetailsWrapper 
    {
        private String Order_Id;
        private String Item_Id;
        private String Line_Id;
        
        XtentoSFDCResponseRowDetailsWrapper() 
        {
            this.Order_Id = null;
            this.Item_Id = null;
            this.Line_Id = null;
        }
        
        XtentoSFDCResponseRowDetailsWrapper(String Order_Id, String Item_Id, String Line_Id) 
        {
            this.Order_Id = Order_Id;
            this.Item_Id = Item_Id;
            this.Line_Id = Line_Id;
        }
    }
}