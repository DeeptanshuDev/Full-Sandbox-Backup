//Controller to run batch to create community user and navigate to apex job execution page. If batch 
//execution fails for some users then error message will auto populate on Error Message field on 
//contact.
public class CommunityUserCreateController 
{
    @TestVisible static Boolean isClassic = UserInfo.getUiThemeDisplayed() == 'Theme3';
    @TestVisible static Boolean isLightning = UserInfo.getUiThemeDisplayed() == 'Theme4d';
    
    public CommunityUserCreateController(ApexPages.StandardSetController  acon) 
    {
    }
    
    //To navigate Apex job page to see status of batch and verify created community user
    public PageReference  callBatchToCreateCommunityUser()
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
            Batch_CreateCommunityUsers batchToCreateCommunityUsers = new Batch_CreateCommunityUsers();
            Database.executeBatch(batchToCreateCommunityUsers,Integer.valueOf(System.Label.Create_Community_User_Batch_Size));
            
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