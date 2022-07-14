/**
*   Purpose         :   Class to get Access Token for FF integration
*   Created By      :   
*   Created Date    :   06/09/2020
*   Revision Log    :   v1.0 - Created - 06/09/2020
**/
public without sharing class FF_GetAccessToken
{
    
    public static String getAccessToken()
    {
        String aToken = '';
        String endpoint = '';
        String body = '';
        
        FF_Credentials__c ffCreds = new FF_Credentials__c();
        ffCreds = FF_Credentials__c.getOrgDefaults();
        if(ffCreds != null)
        {
            endpoint = ffCreds.Endpoint__c;
            body = '{"email":"' + ffcreds.User_Id__c + '","password":"' + ffCreds.Password__c + '"}';
        }
        
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        
        // Set values to Params
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setBody(body);
        
        res = http.send(req);
        if(res.getStatusCode() == 200)
        {
            String sJson = res.getBody();
            aToken = sJson.substringBetween('"token":', ',');
            atoken = atoken.substringBetween('"');
        }
        return aToken;
    }
}