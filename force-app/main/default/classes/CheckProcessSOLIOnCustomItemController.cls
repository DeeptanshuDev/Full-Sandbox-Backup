/**
    Description   :   Controller class to have controller logic for "Check Process SOLI" button on Custom Item object.
    Created By    :   Abhinav Sharma
    Created Date  :   12/16/2019
    Version       :   V1.0 Created
**/ 
public class CheckProcessSOLIOnCustomItemController 
{
    private ApexPages.StandardSetController standardController;
    private Map<String, Schema.SObjectType> globalSchemaDesc  = Schema.getGlobalDescribe() ;
    public Id oppId;
    public String listFilterId {get; set;}
    
    public CheckProcessSOLIOnCustomItemController(ApexPages.StandardSetController standardController)
    {
        this.standardController = standardController;
        this.oppId = ApexPages.currentPage().getParameters().get('id'); 
        this.listFilterId = standardController.getFilterId();
    }
    public pageReference redirectBackToDetailPage() 
    { 
        try 
        {
            List<Custom_Item__c> customItemsToBeUpdate = new List<Custom_Item__c>();
            List<Custom_Item__c> customItemList = (List<Custom_Item__c>)standardController.getSelected();
            if(customItemList.size() > 0)
            {
                for(Custom_Item__c customItem : customItemList)
                {
                    customItem.Process_SOLI__c = true;
                    customItemsToBeUpdate.add(customItem);
                }
                if(customItemList.size() > 0)
                {
                    update customItemList;
                }
                return back();
            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.ERROR_RECORD_SELECTION));   
                return null;
            }
        }
        catch(DmlException e) 
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
            return null;
        }
    }
    
    public pageReference back() 
    {   
        String idForNavigation;
        String objectprefix= globalSchemaDesc.get('Custom_Item__c').getDescribe().getKeyPrefix();
       
        if(String.isNotBlank(oppId))
        {
            idForNavigation = oppId;
        }   
        else{
            idForNavigation = objectprefix+'?fcf='+listFilterId ;
        }
                  
        PageReference page = new PageReference('/' + idForNavigation);
        page.setRedirect(true);
        return page;  
    }   
}