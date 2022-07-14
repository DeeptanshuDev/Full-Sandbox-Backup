/**
    Description   :   Controller class to have controller logic for "Check Process SOLI" button on Standardized Item object.
    Created By    :   Abhinav Sharma
    Created Date  :   12/16/2019
    Version       :   V1.0 Created
**/ 
public class CheckProcessSOLIOnStandardizedController 
{
    private ApexPages.StandardSetController standardController;
    private Map<String, Schema.SObjectType> globalSchemaDesc  = Schema.getGlobalDescribe() ;
    public Id oppId;
    public String listFilterId {get; set;}
    
    public CheckProcessSOLIOnStandardizedController(ApexPages.StandardSetController standardController)
    {
        this.standardController = standardController;
        this.oppId = ApexPages.currentPage().getParameters().get('id'); 
        this.listFilterId = standardController.getFilterId();
    }
    public pageReference redirectBackToDetailPage() 
    { 
        try 
        {
            List<Standardized_Item__c> standardItemsToBeUpdate = new List<Standardized_Item__c>();
            List<Standardized_Item__c> standardItemList = (List<Standardized_Item__c>)standardController.getSelected();
            if(standardItemList.size() > 0)
            {
                for(Standardized_Item__c standardItem : standardItemList)
                {
                    standardItem.Process_SOLI__c = true;
                    standardItemsToBeUpdate.add(standardItem);
                }
                if(standardItemList.size() > 0)
                {
                    update standardItemList;
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
        String objectprefix= globalSchemaDesc.get('Standardized_Item__c').getDescribe().getKeyPrefix();
       
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