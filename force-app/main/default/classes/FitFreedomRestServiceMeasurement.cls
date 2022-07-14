/**
*   Purpose         :   Class to have rest resources and services for Fit Freedom App.
*   Created By      :   Ayush Gupta
*   Created Date    :   04/06/2020
*   Revision Log    :   v1.0 - Created - 04/06/2020
**/
@RestResource(urlMapping='/fitfreedomv3Measurement/*')
global with sharing class FitFreedomRestServiceMeasurement
{   
    //4) Delete Measurement BAI - Deprecated (No web service needed)
    //1) Get Measurement by ID (GET)
    //2) Get Measurement By Raw Query (GET)
    @HttpGet
    global static MeasurementResponseWrapper getMeasurementFromSFDC() 
    {
        MeasurementResponseWrapper res = new MeasurementResponseWrapper();
        RestRequest req = RestContext.request;
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        try
        {         
            List<Measurement__c> measurements = new List<Measurement__c>();
            String measureId = req.params.get(Constants.HTTP_PARAM_MEASUREMENT_ID);
            
            if(String.isNotBlank(measureId)) 
            {
                wsLog.Operation_Name__c = 'Get Measurement by ID';
                measurements = [SELECT measure_id__c,Name,member_id__c,Team_Member__c,FF_Active__c,active__c,
                                measured_by__c,Measured_By_Contact__c,
                                measured_sizes__c,team_id__c,Opportunity__c,y_values__c,person_height__c,created_at__c,
                                modified_at__c
                                FROM Measurement__c
                                WHERE Measure_Id__c =: measureId
                                AND Deleted_From_FF__c = false
                               ];
                if(measurements.size() > 0)
                {
                    res.setSuccess('Get Measurement by ID Successful');
                    wsLog.Measurement__c = measurements[0].Id;   
                }
                else 
                {
                    res.setError('No measurement found for the given id');        
                }
            }
            else 
            {
                wsLog.Operation_Name__c = 'Get Measurement By Raw Query';
                measurements = [SELECT measure_id__c,Name,member_id__c,Team_Member__c,FF_Active__c,active__c,measured_by__c,Measured_By_Contact__c,
                                measured_sizes__c,team_id__c,Opportunity__c,y_values__c,person_height__c,created_at__c,modified_at__c
                                FROM Measurement__c
                                WHERE Deleted_From_FF__c = false
                               ];   
                if(measurements.size() > 0)
                {
                    res.setSuccess('Get All Measurements Successful');
                }
                else
                {
                    res.setError('No measurement found.');    
                }
            }
            res.measurements = getMeasurementsMap(measurements);
        }
        catch(Exception e)
        {
            res.setError(Constants.HTTP_RESPONSE_FAILED + Constants.CHAR_SPACE + Constants.CHAR_COLON 
                         + Constants.CHAR_SPACE + e.getMessage());
            wsLog.Operation_Name__c = 'Measurement GET Requests - Exception';
        }
        wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
        insert wsLog;
        return res;
    }
    
    /*{
        "measure_id": "0711a3f0-7bf1-47f3-81f0-a4eda45bae9w",
        "name": "Measurement 3",
        "person_height":"65",
        "member_id":"0729a3f0-7bf1-47f3-81f0-a4eda45bae3f",
        "measured_sizes":"{leg:78}",
        "y_values":"{leg:78:",
        "team_id":"a9acfe40-338a-4d21-b93b-634a2fd9af10",
        "measured_by":"013381fb-ad99-4a24-a016-95f294e6da61",
        "active":"1",
        "team_id ":"",
        "createdat":"",
        "Modifiedat":""
    }*/
    //3) Create New Measurement (POST)
    @HttpPost
    global static MeasurementResponseWrapper insertMeasurementAtSFDC()
    {
        MeasurementResponseWrapper res = new MeasurementResponseWrapper();
        RestRequest req = RestContext.request;
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        try 
        {
            Blob body = req.requestBody;
            if(body != null) 
            {
                String measure_id = '';
                String member_id = '';
                String team_id = '';
                String measured_by = '';
                string orderId = '';
                Sobject sObjMeasurement = new Measurement__c();
                
                JSONParser parser = JSON.createParser(body.toString());
                while (parser.nextToken() != null) 
                {
                    if(parser.getCurrentName() != parser.getText())
                    {
                        if(FitFreedomMappings.mapOfMeasurementSQLAndSFDCFields.containskey(parser.getCurrentName()))
                        {
                            if(parser.getCurrentName() == 'measure_id')
                            {
                                measure_id = parser.getText();
                            }
                            
                            if(parser.getCurrentName() == 'member_id')
                            {
                                member_id = parser.getText();
                            }
                            
                            if(parser.getCurrentName() == 'team_id')
                            {
                                team_id = parser.getText();
                            }   
                            
                            if(parser.getCurrentName() == 'measured_by')
                            {
                                measured_by = parser.getText();
                            }   
                             if(parser.getCurrentName() == 'order_id')
                            {
                                orderId = parser.getText();
                            }  
                            sObjMeasurement.put(FitFreedomMappings.mapOfMeasurementSQLAndSFDCFields.get(parser.getCurrentName()),parser.getText());
                        }
                    }
                }
                
                if(String.isBlank(measure_id)) 
                {
                    res.setError('please have a value for measure_id for the measurement in the request body');
                    return res;
                }
                
                if(String.isBlank(member_id)) 
                {
                    res.setError('please have a value for member_id for the measurement in the request body');
                    return res;
                }
                
                if(String.isBlank(team_id)) 
                {
                    res.setError('please have a value for team_id for the measurement in the request body');
                    return res;
                }
                
                if(String.isBlank(measured_by)) 
                {
                    res.setError('please have a value for measured_by for the measurement in the request body');
                    return res;
                }
                
                List<Measurement__c> measurements = new List<Measurement__c>();
                if(String.isNotBlank(measure_id)) 
                {
                    measurements = [SELECT Id, Deleted_From_FF__c, measure_id__c  
                                    FROM Measurement__c 
                                    WHERE measure_id__c =: measure_id 
                                    AND Deleted_From_FF__c = false];
                }   
                if(measurements.size() > 0)
                {
                    sObjMeasurement.put('Id', measurements[0].id);
                }
               
                
                Map<String, Id> mapMeasurementTeamMember = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Measurement__c', 'member_id__c', new Set<String>{(String)sObjMeasurement.get('member_id__c')});
                if(mapMeasurementTeamMember != null && mapMeasurementTeamMember.values().size() > 0) 
                {
                    sObjMeasurement.put('Team_Member__c', mapMeasurementTeamMember.get((String)sObjMeasurement.get('member_id__c')));
                }
                else
                {
                    res.setError('unable to find a Team Member for the member_id that we have in the request body');
                    return res;
                }
                
                Map<String, Id> mapMeasuredBy = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Measurement__c', 'measured_by__c', new Set<String>{(String)sObjMeasurement.get('measured_by__c')});
                if(mapMeasuredBy != null && mapMeasuredBy.values().size() > 0) 
                {
                    sObjMeasurement.put('Measured_By_Contact__c', mapMeasuredBy.get((String)sObjMeasurement.get('measured_by__c')));
                }
                else
                {
                    res.setError('unable to find a Measured By for the measured_by that we have in the request body');
                    return res;
                }
                
                Map<String, Id> mapMeasurementTeam = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Measurement__c', 'team_id__c', new Set<String>{(String)sObjMeasurement.get('team_id__c')});
                
                if(mapMeasurementTeam != null && mapMeasurementTeam.values().size() > 0) 
                {
                    sObjMeasurement.put('Rosters__c', mapMeasurementTeam.get((String)sObjMeasurement.get('team_id__c')));
                }
                else
                {
                    res.setError('unable to find a Team  for the team_id that we have in the request body');
                    return res;
                }
                upsert sObjMeasurement;
                wsLog.Measurement__c = sObjMeasurement.Id;
                res.setSuccess(Constants.HTTP_RESPONSE_CREATED + Constants.CHAR_SPACE + Constants.CHAR_COLON + 
                               Constants.CHAR_SPACE + 'Measurement Created Successful');
            }
            else
            {
                res.setError('Please Provide Valid Request Body');
            }
        }
        catch(Exception e) 
        {
            res.setError(Constants.HTTP_RESPONSE_FAILED + Constants.CHAR_SPACE + Constants.CHAR_COLON 
                         + Constants.CHAR_SPACE + e.getMessage());
        }
        wsLog.Operation_Name__c = 'Create New Measurement';
        wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
        insert wsLog;
        return res;
    }
    
    private static List<Map<String, String>> getMeasurementsMap(List<Measurement__c> measurements)
    {
        List<Map<String, String>> lst = new List<Map<String, String>>();
        Map<String, String> mp = FitFreedomMappings.mapOfMeasurementSQLAndSFDCFields;
        for(Integer i=0; i<measurements.size(); i++)
        {
            Map<String, String> sc = new Map<String, String>();
            Sobject measurement = measurements[i];
            for(String s : mp.keySet())
            {
                sc.put(s, String.valueOf(measurement.get(mp.get(s))));
            }
            lst.add(sc);
        }
        return lst;
    }
    
    global class MeasurementResponseWrapper 
    {
        global List<Map<String, String>> measurements {get;set;}
        global String status {get;set;}
        global String message {get;set;}
        global Integer statuscode {get;set;}
        
        global MeasurementResponseWrapper()
        {
            measurements = new List<Map<String, String>>();
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