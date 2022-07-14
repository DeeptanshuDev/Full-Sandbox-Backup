/**
*   Purpose         :   Class to have rest resources and services for Fit Freedom App.
*   Created By      :   Ayush Gupta
*   Created Date    :   05/10/2020
*   Revision Log    :   v1.0 - Created - 05/10/2020
**/
@RestResource(urlMapping='/fitfreedomv3Specification/*')
global with sharing class FitFreedomRestServiceSpecification 
{
    //1) Get all charts info
    @HttpGet
    global static SpecResponseWrapper getSpecificationFromSFDC() 
    {
        SpecResponseWrapper res = new SpecResponseWrapper(); 
        RestRequest req = RestContext.request;
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        try
        {
            List<Specification__c> specifications = new List<Specification__c>();
            specifications = [SELECT Spec_Id__c, Active__c, Defined_Measures__c, 
                              Finalized__c, Name,created_at__c,modified_at__c 
                              FROM Specification__c
                              WHERE Deleted_From_FF__c = false
                             ];
            if(specifications.size() > 0)
            {
                res.setSuccess('Get Specifications/Get all charts info');
            }
            else 
            {
                res.setError('No specification found.');        
            }
            res.specifications = getSpecificationMap(specifications); 
        }
        catch(Exception e)
        {
            res.setError(Constants.HTTP_RESPONSE_FAILED + Constants.CHAR_SPACE + 
                         Constants.CHAR_COLON + Constants.CHAR_SPACE + 
                         e.getMessage()
                        );
        }
        wsLog.Operation_Name__c = 'Get Specifications/Get all charts info';
        wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
        insert wsLog;
        return res;
    }
    
    //2) Create new Chart
    /*
    * {
    "name":"TestSpec1",
    "defined_measures":"1.2",
    "id":"SpecId3345",
    "active":"1",
    "finalized":"A",
    "Created_at":""
    }*/
    @HttpPost
    global static SpecResponseWrapper insertSpecificationAtSFDC()
    {
        SpecResponseWrapper res = new SpecResponseWrapper();
        RestRequest req = RestContext.request;
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        try 
        {
            Blob body = req.requestBody;
            if(body != null) 
            {
                String requestString = body.toString();
                if(String.isNotBlank(requestString)){
                    JSONParser parser = JSON.createParser(requestString);
                    Sobject sobjSpecification = new Specification__c();
                    String specId = '';
                    while (parser.nextToken() != null) 
                    {
                        if(parser.getCurrentName() != parser.getText())
                        {
                            if(FitFreedomMappings.mapOfSpecificationSQLAndSFDCFields.containskey(parser.getCurrentName()))
                            {
                                if(parser.getCurrentName() == 'id')
                                {
                                    specId = parser.getText();
                                }   
                                sobjSpecification.put(FitFreedomMappings.mapOfSpecificationSQLAndSFDCFields.get(parser.getCurrentName()),parser.getText());
                            }
                        }
                    }
                    List<Specification__c> specifications = new List<Specification__c>();
                    if(String.isNotBlank(specId)) 
                    {
                        specifications = [SELECT Id, Deleted_From_FF__c, Spec_Id__c 
                                          FROM Specification__c 
                                          WHERE Spec_Id__c =: specId 
                                          AND Deleted_From_FF__c = false];
                    }   
                    else{
                        res.setError('Please Specify the spec_id in the request body');
                        return res;
                        
                    }
                    if(specifications.size() > 0)
                    {
                        sobjSpecification.put('Id', specifications[0].id);
                    }
                    upsert sobjSpecification;
                    wsLog.Specification__c = sobjSpecification.Id;
                    res.setSuccess(Constants.HTTP_RESPONSE_CREATED + Constants.CHAR_SPACE + Constants.CHAR_COLON + 
                                   Constants.CHAR_SPACE + 'Specification Created Successful');
                }
                else
                {
                    res.setError('Please provide the valid request body');
                    return res;
                }
            }
            else
            {
                res.setError('Please provide the valid request body');
            } 
        }
        catch(Exception e) 
        {
            res.setError(Constants.HTTP_RESPONSE_FAILED + Constants.CHAR_SPACE + Constants.CHAR_COLON 
                         + Constants.CHAR_SPACE + e.getMessage());
        }
        wsLog.Operation_Name__c = 'Create new Chart/Specification';
        wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
        insert wsLog;
        return res;
    }
    
    //4) Delete Specification
    @HttpDelete
    global static SpecResponseWrapper deleteSpecificationByIdInSFDC()
    {
        SpecResponseWrapper res = new SpecResponseWrapper();
        RestRequest req = RestContext.request;
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        try
        {
            List<Specification__c> specsToBeDelete = new List<Specification__c>();    
            String specId = req.params.get(Constants.HTTP_HEADER_ID);
            if(String.isNotBlank(specId)) 
            {
                specsToBeDelete = [SELECT ID, Deleted_From_FF__c, Spec_Id__c 
                                   FROM Specification__c 
                                   WHERE Spec_Id__c =: specId
                                   AND Deleted_From_FF__c = false];  
                
                if(specsToBeDelete.size() > 0)
                {
                    specsToBeDelete[0].Deleted_From_FF__c = true;
                    update specsToBeDelete;
                    wsLog.Specification__c = specsToBeDelete[0].Id;
                    res.setSuccess(Constants.HTTP_RESPONSE_SPECIFICATION_DELETE);
                }
                else
                {
                    res.setError('Unable to find specification to delete for the mentioned id.');
                }
            }
            else
            {
                res.setError('Please specify a id (spec id).');
            }
        }
        catch(Exception e)
        {
            res.setError(Constants.HTTP_RESPONSE_FAILED + Constants.CHAR_SPACE + Constants.CHAR_COLON 
                         + Constants.CHAR_SPACE + e.getMessage());
        }
        wsLog.Operation_Name__c = 'Delete Specification';
        wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
        insert wsLog;
        return res;
    }
    
    private static List<Map<String, String>> getSpecificationMap(List<Specification__c> specifications)
    {
        List<Map<String, String>> lst = new List<Map<String, String>>();
        Map<String, String> mp = FitFreedomMappings.mapOfSpecificationSQLAndSFDCFields;
        for(Integer i=0; i<specifications.size(); i++)
        {
            Map<String, String> sc = new Map<String, String>();
            Sobject specification = specifications[i];
            System.debug(specification.get('Name'));
            for(String s : mp.keySet())
            {
                sc.put(s, String.valueOf(specification.get(mp.get(s))));
            }
            lst.add(sc);
        }
        return lst;
    }
    
    global class SpecResponseWrapper 
    {
        global List<Map<String, String>> specifications {get;set;}
        global String status {get;set;}
        global String message {get;set;}
        global Integer statuscode {get;set;}
        global SpecResponseWrapper()
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