@isTest
global class MockHTTPResponseGenerator implements HttpCalloutMock 
{
    public integer responseNumber = 0;
    global HttpResponse respond(HttpRequest req) 
    {   
        if(responseNumber == 1)
        {
            String bodyStr = '{"AutoActivate" : true,' 
                + '"Description": "From tooling API",'
                +'"LicenseType": "DEVELOPER",'
                +'"SandboxName": "STP"'
                +'}';
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            return res;
        }
        else if(responseNumber == 2)
        {
        	HttpResponse res = new HttpResponse();
            req.setHeader(Constants.CONTENT_TYPE, Constants.CONTENT_TYPE_APP_JSON);
            res.setStatusCode(200);
            return res;    
        }
        else
        {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"success"}');
            res.setStatusCode(200);
            return res; 
        }
    }
}