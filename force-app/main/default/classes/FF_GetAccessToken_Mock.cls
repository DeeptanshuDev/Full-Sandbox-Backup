@isTest
public class FF_GetAccessToken_Mock implements HttpCalloutMock
{
    public HttpResponse respond(HTTPRequest req)
    {
        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setStatusCode(200);
        res.setBody('{"token": "AccessToken", "user": "user"}');
        return res;
    }
}