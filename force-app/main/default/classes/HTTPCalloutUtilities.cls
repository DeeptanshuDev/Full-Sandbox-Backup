/**
*  Purpose      :   Class to have HTTP Callout utilities
*  Created By   :   Abhinav Sharma
*  Created Date :   02/25/2020
**/
public without sharing class HTTPCalloutUtilities 
{
    public static HttpResponse makeSandboxCreateCallout(String bodyStr) 
    {
        if(String.isNotBlank(bodyStr)) 
        {
            HttpRequest req = new HttpRequest();
            req.setHeader(Constants.AUTHORIZATION, Constants.BEARER + Constants.CHAR_SPACE + UserInfo.getSessionId());
            req.setHeader(Constants.CONTENT_TYPE, Constants.CONTENT_TYPE_APP_JSON);
            String endPointURL = System.Label.End_Point_For_Sandbox_Creation;
            req.setEndpoint(endPointURL);
            req.setBody(bodyStr);
            req.setMethod(Constants.HTTP_REQUEST_POST_TYPE);
            
            System.debug('@@ req ' + req);
            System.debug('@@ endPointURL ' + endPointURL);
            
            Http h = new Http();
            HttpResponse res;
            String body = '';
            
            if(!Test.isRunningTest()) 
            {
                res = h.send(req);
                System.debug('@@ res makeSandboxCreateCallout ' + req);
                return res;
            }
            else
            {
                MockHTTPResponseGenerator mHRG = new MockHTTPResponseGenerator();
                mHRG.responseNumber = 1;
                HttpResponse resp = mHRG.respond(req);
                return resp;
            }
        }
        return null;
    }
    
    public static HttpResponse querySandboxProcessDetails(List<SandboxCreateWrapper> listOfSandboxCreateResultsWrapper) 
    {
        if(listOfSandboxCreateResultsWrapper != null && listOfSandboxCreateResultsWrapper.size() > 0)
        {
            if(setOfSandboxInfoIds(listOfSandboxCreateResultsWrapper) != null) 
            {	
               String InfoIds = '(';
                Set<Id> sBInfoIds = HTTPCalloutUtilities.setOfSandboxInfoIds(listOfSandboxCreateResultsWrapper);
                for(Id sbId  : sBInfoIds){
                    InfoIds += '%27' + sbId + '%27,';
                }
                InfoIds = InfoIds.removeEnd(',') + ')';  
                
                HttpRequest req = new HttpRequest();
                req.setHeader(Constants.AUTHORIZATION, Constants.BEARER + Constants.CHAR_SPACE + UserInfo.getSessionId());
                req.setHeader(Constants.CONTENT_TYPE, Constants.CONTENT_TYPE_APP_JSON);
                String endPointURL =  System.Label.Sandbox_Creation_End_Point_Url 
                                                        + System.Label.Sandbox_Creation_Query +InfoIds;
                System.debug('@@ endPointURL'+endPointURL);
                req.setEndpoint(endPointURL);
                req.setMethod('GET');
                
                Http h = new Http();
                HttpResponse response;
               	if(!Test.isRunningTest()) 
                {
                    response = h.send(req);
                    return response;  
                }
                else
                {
                    MockHTTPResponseGenerator mHRG = new MockHTTPResponseGenerator();
                    mHRG.responseNumber = 2;
                    HttpResponse resp = mHRG.respond(req);
                    System.debug('%%%%%%%'+resp);
                    return resp;	    
                }
            }
        }
        return null;
    }
    
    public static Set<Id> setOfSandboxInfoIds(List<SandboxCreateWrapper> listOfSandboxCreateResultsWrapper) 
    {
        if(listOfSandboxCreateResultsWrapper != null && listOfSandboxCreateResultsWrapper.size() > 0)
        {
            Set<Id> setOfSBInfoIds = new Set<Id>();
            for(SandboxCreateWrapper sW : listOfSandboxCreateResultsWrapper) 
            {
                if(sW.cSRequest != null && String.isNotBlank(sW.cSRequest.SandboxInfo_Id__c)) 
                {
                    setOfSBInfoIds.add(sW.cSRequest.SandboxInfo_Id__c);
                }
            }
            return setOfSBInfoIds;   
        }
        else 
        {
            return null;    
        }
    }
}