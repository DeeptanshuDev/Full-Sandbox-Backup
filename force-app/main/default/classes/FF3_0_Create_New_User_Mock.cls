@isTest
public class FF3_0_Create_New_User_Mock implements HttpCalloutMock
{
    public static String responseType = 'success';
    
    public FF3_0_Create_New_User_Mock(String type)
    {
        FF3_0_Create_New_User_Mock.responseType = type;
        //System.debug('type = ' + type);
        //System.debug('FF3_0_Create_New_User_Mock.responseType = ' + FF3_0_Create_New_User_Mock.responseType);
    }
    
    public FF3_0_Create_New_User_Mock()
    {
        FF3_0_Create_New_User_Mock.responseType = 'success';
    }
    
    public HttpResponse respond(HTTPRequest req)
    {
        HttpResponse res = new HttpResponse();
        
        if(responseType == 'success')
        {
            //System.debug('success');
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('"46e51ef9-d5df-4d02-8bbb-42262sds77ebe"');
        }
        else if(responseType == 'success_WrongMsg')
        {
            //System.debug('success_WrongMsg');
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('{"' + 'xyz' + '"}');
        }
        else if(responseType == 'error')
        {
            //System.debug('error');
            res.setStatus('Internal Server Error');
            res.setStatusCode(500);
            res.setBody('{"' + 'error' + '"}');
        }
        
        return res;
    }
}