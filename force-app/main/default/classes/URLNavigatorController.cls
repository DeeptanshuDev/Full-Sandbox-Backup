/**
    Description   :   Controller class to act redirect point for various button with pre-population logic
    Created By    :   Abhinav Sharma
    Created Date  :   07/09/2018
    Version       :   V1.0 Created
**/ 
public class URLNavigatorController 
{
    public Map<String,String>mapOfParameters;
    public String JsonMap{get;set;}
    public URLNavigatorController() 
    {
         
        mapOfParameters = new Map<String,String>();
        mapOfParameters = ApexPages.currentPage().getParameters();
        
        JsonMap=JSON.serialize(mapOfParameters);
    }
    //Method to redirect when theme is classic
    public PageReference redirect() 
    {
        PageReference redirectPage;
        String operationType = mapOfParameters.get('operationtype');
        if(String.isNotBlank(operationType)) 
        {
            if(operationType.toUpperCase() == 'BACK') 
            {
                redirectPage = new PageReference('/'+ApexPages.currentPage().getParameters().get('retURL'));
                redirectPage.setRedirect(Boolean.valueOf(mapOfParameters.get('refresh')));
            }
            else if(operationType.toUpperCase() == 'NAVIGATETOSOBJECT') 
            {
                redirectPage = new PageReference('/'+mapOfParameters.get('recordId'));
            }
            else if(operationType.toUpperCase() == 'NAVIGATETOURL') 
            {
                redirectPage = new PageReference('/'+mapOfParameters.get('url'));
                redirectPage.setRedirect(Boolean.valueOf(mapOfParameters.get('isredirect')));
            }
            else if(operationType.toUpperCase() == 'NAVIGATETOFEED') 
            {
                //TODO
            }
            else if(operationType.toUpperCase() == 'NAVIGATETOFEEDITEMDETAIL') 
            {
                redirectPage = new PageReference('/'+mapOfParameters.get('feedItemId'));
            }
            else if(operationType.toUpperCase() == 'NAVIGATETORELATEDLIST') 
            {
                redirectPage = new PageReference('/'+mapOfParameters.get('parentRecordId')+'/#'+mapOfParameters.get('parentRecordId')+'_'+mapOfParameters.get('relatedListId'));
            }
            else if(operationType.toUpperCase() == 'NAVIGATETOLIST') 
            {
                redirectPage = new PageReference('/'+Schema.getGlobalDescribe().get(mapOfParameters.get('scope')).getDescribe().getKeyPrefix());
                redirectPage.getParameters().put('fcf',mapOfParameters.get('listViewId'));
            }
            else if(operationType.toUpperCase() == 'CREATERECORD') 
            {
                String fields = mapOfParameters.get('classicfieldsid');
                List<String> fieldsList = String.isNotBlank(fields)?fields.split('@~@'):new List<String>();
                redirectPage = new PageReference('/'+Schema.getGlobalDescribe().get(mapOfParameters.get('entityName').toLowerCase()).getDescribe().getKeyPrefix()+'/e');
                redirectPage.getParameters().put('RecordType',mapOfParameters.get('recordTypeId'));
                String values = mapOfParameters.get('defaults');
                List<String> valuesList = String.isNotBlank(values)?values.split('@~@'):new List<String>();
                if(fieldsList.size() > 0 && valuesList.size() > 0) 
                {
                    for(Integer i=0; i<fieldsList.size(); i++) 
                    {
                        for(Integer j=0; j<valuesList.size(); j++) 
                        {
                            if(fieldsList[j] != null && String.isNotBlank(fieldsList[j]))
                            {
                                if(valuesList[j] != null && String.isNotBlank(valuesList[j] ))
                                {
                                    redirectPage.getParameters().put(fieldsList[j],EncodingUtil.urlDecode(valuesList[j], 'UTF-8'));
                                }
                            }
                        }
                    }
                }
                else
                {
                }
            }
            else if(operationType.toUpperCase() == 'EDITRECORD') 
            {
                redirectPage = new PageReference('/'+mapOfParameters.get('recordId')+'/e');
            }
        }
       
        return redirectPage;
    }
}