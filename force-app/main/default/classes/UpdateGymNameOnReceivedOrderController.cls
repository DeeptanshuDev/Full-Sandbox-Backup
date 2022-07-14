public class UpdateGymNameOnReceivedOrderController {
    
    @TestVisible static Boolean isClassic = UserInfo.getUiThemeDisplayed() == 'Theme3';
    @TestVisible static Boolean isLightning = UserInfo.getUiThemeDisplayed() == 'Theme4d';
    
    public UpdateGymNameOnReceivedOrderController(ApexPages.StandardSetController  std) 
    {
    }
    
    //To navigate Apex job page to see status of batch
    public PageReference  callBatch()
    {
        //To get base url and concate with Apex Job page url
        String sfUrl = URL.getSalesforceBaseUrl().toExternalForm();
        
        if(isClassic)
        {
            sfUrl+='/apexpages/setup/listAsyncApexJobs.apexp?';
        }
        if(isLightning)
        {
            sfUrl+='/lightning/setup/AsyncApexJobs/home';
        }
        
        try
        {
            Batch_UpdateGymNameOnReceivedOrder updateGymName = new Batch_UpdateGymNameOnReceivedOrder();
            Database.executeBatch(updateGymName, Integer.valueOf(System.Label.UpdateGymNameOnReceivedOrder_BatchSize));
            
            PageReference pageRef = new PageReference(sfurl);
            pageRef.setRedirect(true);
            return pageRef;
        }
        Catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.WARNING, ex.getMessage()));
            return null;                     
        }
    }  
}