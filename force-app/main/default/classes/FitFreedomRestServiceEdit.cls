/**
*   Purpose         :   Class to have rest resources and services for Fit Freedom App.
*   Created By      :   Ayush Gupta
*   Created Date    :   04/06/2020
*   Revision Log    :   v1.0 - Created - 04/06/2020
**/
@RestResource(urlMapping='/fitfreedomv3Edit/*')
global with sharing class FitFreedomRestServiceEdit 
{
    //1) Get Edits (GET)
    @HttpGet
    global static EditResonseWrapper getEditFromSFDC() 
    {
        EditResonseWrapper res = new EditResonseWrapper();
        RestRequest req = RestContext.request;
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        try
        {
            List<Edit__c> edits = new List<Edit__c>();
            edits = [SELECT edit_id__c, cap_max__c, cap_min__c, default_index__c, edit_measure__c,
                      Name, edit_type__c, map_max__c, map_min__c, max__c, min__c, options__c, 
                      sensitivity__c, created_at__c, modified_at__c 
                      FROM Edit__c
                      WHERE Deleted_From_FF__c = false
                     ];
            if(edits.size() > 0)
            {
                res.setSuccess('Get Edits Successful');
            }
            else 
            {
                res.setError('No Edits found.');        
            }
            res.edits = getEditsMap(edits); 
        }
        catch(Exception e)
        {           
            res.setError(Constants.HTTP_RESPONSE_FAILED + Constants.CHAR_SPACE + Constants.CHAR_COLON 
                         + Constants.CHAR_SPACE + e.getMessage());
        }
        wsLog.Operation_Name__c = 'Get Edits';
        wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
        insert wsLog;
        return res;
    }
    
    private static List<Map<String, String>> getEditsMap(List<Edit__c> edits)
    {
        List<Map<String, String>> lst = new List<Map<String, String>>();
        Map<String, String> mp = FitFreedomMappings.mapOfEditSQLAndSFDCFields;
        for(Integer i=0; i<edits.size(); i++)
        {
            Map<String, String> sc = new Map<String, String>();
            Sobject acc = edits[i];
            System.debug(acc.get('Name'));
            for(String s : mp.keySet())
            {
                sc.put(s, String.valueOf(acc.get(mp.get(s))));
            }
            lst.add(sc);
        }
        return lst;
    }    
    
    global class EditResonseWrapper 
    {
        global List<Map<String, String>> edits {get;set;}
        global String status {get;set;}
        global String message {get;set;}
        global Integer statuscode {get;set;}
        
        global EditResonseWrapper()
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