/**
*   Purpose         :   Class to have rest resources and services for Fit Freedom App.
*   Created By      :   Ayush Gupta
*   Created Date    :   04/06/2020
*   Revision Log    :   v1.0 - Created - 04/06/2020
**/
@RestResource(urlMapping='/fitfreedomv3Fit/*')
global with sharing class FitFreedomRestServiceFit
{
    //4) Modify Fit Details - TBD - We skipped it for now.   
   /*
    * Currently Get Request is not being used
    @HttpGet
    global static FitResponseWrapper getFitFromSFDC() 
    {
        FitResponseWrapper res = new FitResponseWrapper();
        RestRequest req = RestContext.request;  
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        try
        {
            List<Fit__c> fits = new List<Fit__c>();
            String catId = req.params.get(Constants.HTTP_CATEGORY_ID);
            
            //3) Find all Fits by Category (GET)
            if(String.isNotBlank(catId)) 
            {
                wsLog.Operation_Name__c = 'Find all Fits by Category';
                fits = [SELECT Name,fit_id__c,categories_id__c,condition_apply__c,created_by__c,edit_id__c,
                        fabric__c,fit_desc__c,fit_image__c,
                        fit_number__c,is_deleted__c,modified_at__c,lining__c,spec_id__c,created_at__c  
                        FROM Fit__c 
                        WHERE Categories_Id__c =: catId
                        AND Deleted_From_FF__c = false
                ];
                
                if(fits.size() > 0)
                {
                    res.setSuccess('Find all Fits by Category Successful');
                    wsLog.Fit__c = fits[0].Id;
                }
                else 
                {
                    res.setError('No fit found for the given category id');        
                }
            }
            
            //2) Find all Fits (GET)
            else 
            {
                wsLog.Operation_Name__c = 'Find all Fits';
                fits = [SELECT Name,fit_id__c,categories_id__c,condition_apply__c,
                        created_by__c,edit_id__c,fabric__c,fit_desc__c,fit_image__c,
                        fit_number__c,is_deleted__c,modified_at__c,lining__c,spec_id__c,
                        created_at__c  
                        FROM Fit__c
                        WHERE Deleted_From_FF__c = false];
                
                if(fits.size() > 0)
                {
                    res.setSuccess('Find all Fits Successful');
                }
                else
                {
                    res.setError('No fit found.');    
                }
            } 
            res.fits = getFitsMap(fits);
        }
        catch(Exception e)
        {
            res.setError(Constants.HTTP_RESPONSE_FAILED + Constants.CHAR_SPACE + Constants.CHAR_COLON + Constants.CHAR_SPACE + 
                         e.getMessage());
            wsLog.Operation_Name__c = 'Fit GET Requests - Exception';
        }
        wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
        insert wsLog;
        return res;
    } 
*/
    
    /*
        *   {
        "fit_id":"F1234334569",
        "Name":"FName Ayush",
        "category_id" : "C1234",
        "spec_id" : "S1234",
        "fit_desc" : "Desc-1",
        "fit_number" : "01245",
        "conditions_apply" : "1",
        "created_by" : "",
        "edit_id" : "F1234",
        "fabric" : "cotton",
        "fit_image" : "Img-1",
        "is_Deleted":"0",
        "lining":"1",
        "modified_at":"",
        "created_at":""
        }
    */
    //1) Create Fit (POST)
     @HttpPut
    global static FitResponseWrapper updateFITATSFDC()
    {
        FitResponseWrapper res = new FitResponseWrapper();
        
        RestRequest req = RestContext.request;
        String fitId = req.params.get(Constants.HTTP_FIT_ID);
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        try 
        {
            Blob body = req.requestBody;
            if(body != null) 
            {
                Sobject sObjFit = new Fit__c();
                String fit_id = '';
                String category_id = '';
                String spec_id = '';
                string edit_id = ''; 
                
                JSONParser parser = JSON.createParser(body.toString());
                while (parser.nextToken() != null) 
                { 
                    if(parser.getCurrentName() != parser.getText())
                    {
                        if(FitFreedomMappings.mapOfFitSQLAndSFDCFields.containskey(parser.getCurrentName()))
                        {   
                            if(parser.getCurrentName() == 'fit_id')
                            {
                                fit_id = parser.getText();
                            }
                            
                            if(parser.getCurrentName() == 'category_id')
                            {
                                category_id = parser.getText();
                            }
                            
                            if(parser.getCurrentName() == 'spec_id')
                            {
                                spec_id = parser.getText();
                            }   
                            
                            if(parser.getCurrentName() == 'edit_id')
                            {
                                edit_id = parser.getText();
                            }   
                            sObjFit.put(FitFreedomMappings.mapOfFitSQLAndSFDCFields.get(parser.getCurrentName()),parser.getText());
                        }
                    }
                }
                
                if(String.isBlank(fitId)) 
                {
                    res.setError('please have a value for fit_id in the Parameters');
                    return res;
                }
                
                
                List<Fit__c> fits = new List<Fit__c>();
                if(String.isNotBlank(fitId)) 
                {
                    fits = [SELECT Name,fit_id__c,categories_id__c,condition_apply__c,created_by__c,edit_id__c,
                            fabric__c,fit_desc__c,
                            fit_image__c,fit_number__c,is_deleted__c,modified_at__c,lining__c,spec_id__c,created_at__c  
                            FROM Fit__c 
                            WHERE fit_id__c =: fitId 
                            AND Deleted_From_FF__c = false];
                }   
                if(fits.size() > 0)
                {
                    sObjFit.put('Id', fits[0].id);
                }
                
                Map<String, Id> mapFitCategory = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Fit__c', 'categories_id__c', new Set<String>{(String)sObjFit.get('categories_id__c')});
                if(mapFitCategory != null && mapFitCategory.values().size() > 0) 
                {
                    sObjFit.put('category__c', mapFitCategory.get((String)sObjFit.get('categories_id__c')));
                }
                
                
                Map<String, Id> mapFitSpecs = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Fit__c', 'spec_id__c', new Set<String>{(String)sObjFit.get('spec_id__c')});
                if(mapFitSpecs != null && mapFitSpecs.values().size() > 0) 
                {
                    sObjFit.put('specification__c', mapFitSpecs.get((String)sObjFit.get('spec_id__c')));
                }
                
                
                Map<String, Id> mapFitEdit = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Fit__c', 'edit_id__c', new Set<String>{(String)sObjFit.get('edit_id__c')});
                if(mapFitEdit != null && mapFitEdit.values().size() > 0) 
                {
                    sObjFit.put('edit__c', mapFitEdit.get((String)sObjFit.get('edit_id__c')));
                }
                if(fits.size() > 0){
                    upsert sObjFit;
                    wsLog.Fit__c = sObjFit.Id;
                    res.setSuccess('Edited :' + Constants.CHAR_SPACE + Constants.CHAR_COLON + 
                                   Constants.CHAR_SPACE + 'Fit Updated Successful');
                }else{
                    res.setError('No Fit Found for the given Id');
                    wsLog.Operation_Name__c = 'Edit Fit POST Requests - Blank Body';
                }
                
            }
            else 
            {
                res.setError('Please Provide Valid Request Body');
                wsLog.Operation_Name__c = 'Edit Fit POST Requests - Blank Body';
            }
        }
        catch(Exception e) 
        {
            System.debug('catch error = ' + e.getMessage());
            res.setError(Constants.HTTP_RESPONSE_FAILED + Constants.CHAR_SPACE + Constants.CHAR_COLON + Constants.CHAR_SPACE + 
                         e.getMessage() + e.getLineNumber());
        }
        wsLog.Operation_Name__c = 'Update Fit';
        wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
        insert wsLog;
        return res;
        
    }
    
    @HttpPost
    global static FitResponseWrapper insertFitAtSFDC()
    {
        FitResponseWrapper res = new FitResponseWrapper();
        RestRequest req = RestContext.request;
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        try 
        {
            Blob body = req.requestBody;
            if(body != null) 
            {
                Sobject sObjFit = new Fit__c();
                String fit_id = '';
                String category_id = '';
                String spec_id = '';
                string edit_id = ''; 
                
                JSONParser parser = JSON.createParser(body.toString());
                while (parser.nextToken() != null) 
                { 
                    if(parser.getCurrentName() != parser.getText())
                    {
                        if(FitFreedomMappings.mapOfFitSQLAndSFDCFields.containskey(parser.getCurrentName()))
                        {   
                            if(parser.getCurrentName() == 'fit_id')
                            {
                                fit_id = parser.getText();
                            }
                            
                            if(parser.getCurrentName() == 'category_id')
                            {
                                category_id = parser.getText();
                            }
                            
                            if(parser.getCurrentName() == 'spec_id')
                            {
                                spec_id = parser.getText();
                            }   
                            
                            if(parser.getCurrentName() == 'edit_id')
                            {
                                edit_id = parser.getText();
                            }   
                            sObjFit.put(FitFreedomMappings.mapOfFitSQLAndSFDCFields.get(parser.getCurrentName()),parser.getText());
                        }
                    }
                }
                
                if(String.isBlank(fit_id)) 
                {
                    res.setError('please have a value for fit_id for the Fit in the request body');
                    return res;
                }
                
                if(String.isBlank(category_id)) 
                {
                    res.setError('please have a value for category_id for the Fit in the request body');
                    return res;
                }
                
                if(String.isBlank(spec_id)) 
                {
                    res.setError('please have a value for spec_id for the Fit in the request body');
                    return res;
                }
                
                               
                List<Fit__c> fits = new List<Fit__c>();
                if(String.isNotBlank(fit_id)) 
                {
                    fits = [SELECT Name,fit_id__c,categories_id__c,condition_apply__c,created_by__c,edit_id__c,
                            fabric__c,fit_desc__c,
                            fit_image__c,fit_number__c,is_deleted__c,modified_at__c,lining__c,spec_id__c,created_at__c  
                            FROM Fit__c 
                            WHERE fit_id__c =: fit_id 
                            AND Deleted_From_FF__c = false];
                }   
                if(fits.size() > 0)
                {
                    sObjFit.put('Id', fits[0].id);
                }
                
                Map<String, Id> mapFitCategory = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Fit__c', 'categories_id__c', new Set<String>{(String)sObjFit.get('categories_id__c')});
                if(mapFitCategory != null && mapFitCategory.values().size() > 0) 
                {
                    sObjFit.put('category__c', mapFitCategory.get((String)sObjFit.get('categories_id__c')));
                }
                else
                {
                    res.setError('unable to find a Category for the categories_id that we have in the request body');
                    return res;
                }
                
                Map<String, Id> mapFitSpecs = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Fit__c', 'spec_id__c', new Set<String>{(String)sObjFit.get('spec_id__c')});
                if(mapFitSpecs != null && mapFitSpecs.values().size() > 0) 
                {
                    sObjFit.put('specification__c', mapFitSpecs.get((String)sObjFit.get('spec_id__c')));
                }
               
                
                Map<String, Id> mapFitEdit = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Fit__c', 'edit_id__c', new Set<String>{(String)sObjFit.get('edit_id__c')});
                if(mapFitEdit != null && mapFitEdit.values().size() > 0) 
                {
                    sObjFit.put('edit__c', mapFitEdit.get((String)sObjFit.get('edit_id__c')));
                }
                
                upsert sObjFit;
                wsLog.Fit__c = sObjFit.Id;
                res.setSuccess(Constants.HTTP_RESPONSE_CREATED + Constants.CHAR_SPACE + Constants.CHAR_COLON + 
                               Constants.CHAR_SPACE + 'Fit Created Successful');
            }
            else 
            {
                res.setError('Please Provide Valid Request Body');
                wsLog.Operation_Name__c = 'Create Fit POST Requests - Blank Body';
            }
        }
        catch(Exception e) 
        {
            res.setError(Constants.HTTP_RESPONSE_FAILED + Constants.CHAR_SPACE + Constants.CHAR_COLON + Constants.CHAR_SPACE + 
                         e.getMessage());
        }
        wsLog.Operation_Name__c = 'Create Fit';
        wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
        insert wsLog;
        return res;
    }
    
    //5) Remove Fit By fit id
   /* 
    * Currently Delete Request is not being used
    @HttpDelete
    global static FitResponseWrapper deleteFitByIdInSFDC() 
    {
        FitResponseWrapper res = new FitResponseWrapper();
        RestRequest req = RestContext.request;
        String actionType = req.requestURI.subStringbetween('/fitfreedomv3Fit/', '/');
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        try
        {
            System.debug('actionType = ' + actionType);
            if(actionType == FitFreedomUrlMappings.FIT_AT_DELETE_FIT_BY_ID)
            {
                List<Fit__c> fitToBeDelete = new List<Fit__c>();
                String fitId = req.params.get(Constants.HTTP_FIT_ID);
                if(String.isNotBlank(fitId))
                {
                    fitToBeDelete = [SELECT ID,Deleted_From_FF__c  
                                     FROM Fit__c 
                                     WHERE fit_id__c =: fitId
                                     AND Deleted_From_FF__c = false
                                    ];
                    
                    if(fitToBeDelete.size() > 0)
                    {
                        fitToBeDelete[0].Deleted_From_FF__c = true;
                        update fitToBeDelete;
                        wsLog.Fit__c = fitToBeDelete[0].Id;
                        res.setSuccess('Fit Deleted');
                    }
                    else
                    {
                        res.setError('Unable to find fit to delete for the mentioned fit id.');
                    }
                }
                else
                {
                    res.setError('Please specify a fit id.');
                }
            }
        }
        catch(Exception e)
        {
            res.setError(Constants.HTTP_RESPONSE_FAILED + Constants.CHAR_SPACE + Constants.CHAR_COLON + Constants.CHAR_SPACE + 
                         e.getMessage());
        }
        wsLog.Operation_Name__c = 'Remove Fit By fit id';
        wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
        insert wsLog;
        return res;
    }
    */
    
    /*
     * used for Get Request
    private static List<Map<String, String>> getFitsMap(List<Fit__c> fits)
    {
        List<Map<String, String>> lst = new List<Map<String, String>>();
        Map<String, String> mp = FitFreedomMappings.mapOfFitSQLAndSFDCFields;
        for(Integer i=0; i<fits.size(); i++)
        {
            Map<String, String> sc = new Map<String, String>();
            Sobject Fit = fits[i];
            for(String s : mp.keySet())
            {
                sc.put(s, String.valueOf(fit.get(mp.get(s))));
            }
            lst.add(sc);
        }
        return lst;
    }
    */
    
    global class FitResponseWrapper 
    {
        global List<Map<String, String>> fits {get;set;}
        global String status {get;set;}
        global String message {get;set;}
        global Integer statuscode {get;set;}
        
        global FitResponseWrapper()
        {
            fits = new List<Map<String, String>>();
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