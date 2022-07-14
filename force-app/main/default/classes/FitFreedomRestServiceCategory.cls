/**
*   Purpose         :   Class to have rest resources and services for Fit Freedom App.
*   Created By      :   Ayush Gupta
*   Created Date    :   04/06/2020
*   Revision Log    :   v1.0 - Created - 04/06/2020
**/
@RestResource(urlMapping='/fitfreedomv3Category/*')
global with sharing class FitFreedomRestServiceCategory 
{
    //1) Get Category (GET)
    @HttpGet
    global static CategoryResonseWrapper getCategoryFromSFDC() 
    {
        CategoryResonseWrapper res = new CategoryResonseWrapper(); 
        RestRequest req = RestContext.request;
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        try
        {
            List<Category__c> categories = new List<Category__c>();
            categories = [SELECT category_id__c, edit_options__c, Name, category_type__c, 
                          sort__c, created_at__c,
                          modified_at__c
                          FROM Category__c 
                          WHERE Deleted_From_FF__c = false
                         ];
            if(categories.size() > 0)
            {
                res.setSuccess('Get Category Successful');
            }
            else 
            {
                res.setError('No category found.');        
            }
            res.categories = getCategoriesMap(categories);  
        }
        catch(Exception e)
        {
            res.setError(Constants.HTTP_RESPONSE_FAILED + Constants.CHAR_SPACE + 
                         Constants.CHAR_COLON + Constants.CHAR_SPACE + 
                         e.getMessage()
                        );
            
        }
        wsLog.Operation_Name__c = 'Get Category';
        wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
        insert wsLog;
        return res;
    }
    
    private static List<Map<String, String>> getCategoriesMap(List<Category__c> categories)
    {
        List<Map<String, String>> lst = new List<Map<String, String>>();
        Map<String, String> mp = FitFreedomMappings.mapOfCategorySQLAndSFDCFields;
        for(Integer i=0; i<categories.size(); i++)
        {
            Map<String, String> sc = new Map<String, String>();
            Sobject acc = categories[i];
            System.debug(acc.get('Name'));
            for(String s : mp.keySet())
            {
                sc.put(s, String.valueOf(acc.get(mp.get(s))));
            }
            lst.add(sc);
        }
        return lst;
    }
    
    global class CategoryResonseWrapper 
    {
        global List<Map<String, String>> categories {get;set;}
        global String status {get;set;}
        global String message {get;set;}
        global Integer statuscode {get;set;}
        global CategoryResonseWrapper()
        {
            status = Constants.HTTP_RESPONSEWRAPPER_STATUS_SUCCESS;
            message = Constants.HTTP_RESPONSEWRAPPER_STATUS_SUCCESS;
            statuscode = 200;
        }
        global void setSuccess(String str)
        {
            statuscode = 200;
            message = str;
            status = Constants.HTTP_RESPONSEWRAPPER_STATUS_SUCCESS;
        }
        global void setError(String str)
        {
            message = str;
            status = Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL;
            statuscode = 400;
        }
    }    
}