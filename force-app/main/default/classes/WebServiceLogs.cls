/**
*	Purpose      	:   Class to create Records of object = Web_Service_Log__c , for both call-outs and call-ins
*	Created By   	:   Ayush Gupta
* 	Created Date 	:	05/07/2020
*	Revision Log	:	v1.0 - Created - 05/07/2020
**/
public with sharing class WebServiceLogs 
{
   
    
    public static Web_Service_Log__c populateWebServiceLogDetails(RestRequest req, 
                                                                  String responseBody, 
                                                                  Web_Service_Log__c wsLog) 
    {
        if(wsLog == null)
        {
            wsLog = new Web_Service_Log__c();
        }
        wsLog.Callout_Type__c = 'CallIn';
        wsLog.Type__c = 'Fit_Freedom';
        wsLog.Endpoint__c = req.requestURI;
        if(req.requestBody != null)
        {
            wsLog.Request_Body__c = req.requestBody.toString();
        }        
        wsLog.Request_Method__c = req.httpMethod;
        if(req.params != null)
        {
            wsLog.Request_Params__c = JSON.serialize(req.params);
        }        
        wsLog.Response_Body__c = responseBody;
        return wsLog;
    }
    
       public static Web_Service_Log__c populateCalloutLog(HttpRequest req, HttpResponse res, String operationName)
    {
    	Web_Service_Log__c wsLog = new Web_Service_Log__c();
        wsLog.Callout_Type__c = 'CallOut';
        wsLog.Type__c = 'Fit_Freedom';
        wsLog.Endpoint__c = req.getEndpoint();//.substringBefore('?')
        wsLog.Operation_Name__c = operationName;      
        wsLog.Request_Body__c = req.getBody();
        wsLog.Request_Method__c = req.getMethod();
        if(req.getEndpoint() != null)
        {
            wsLog.Request_Params__c = req.getEndpoint().substringAfter('?');
        }
        
        if(res != null)
        {
            wsLog.Response_Body__c = res.getBody();
        }
		return wsLog;
    }
}