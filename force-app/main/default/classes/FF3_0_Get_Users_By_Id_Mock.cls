@isTest
public class FF3_0_Get_Users_By_Id_Mock implements HttpCalloutMock
{
    public static String responseType = 'success';
    
    public FF3_0_Get_Users_By_Id_Mock(String type)
    {
        FF3_0_Get_Users_By_Id_Mock.responseType = type;
        //System.debug('type = ' + type);
        //System.debug('FF3_0_Get_Users_By_Id_Mock.responseType = ' + FF3_0_Get_Users_By_Id_Mock.responseType);
    }
    
    public FF3_0_Get_Users_By_Id_Mock()
    {
        FF3_0_Get_Users_By_Id_Mock.responseType = 'success';
    }
    
    public HttpResponse respond(HTTPRequest req)
    {
        HttpResponse res = new HttpResponse();
        
        if(responseType == 'success')
        {
            //System.debug('success');
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('{"user_id":"46e51ef9-d5df-4d02-8bbb-422620b77ebe","device_ids":"xyz","email":"con1@con.com","first_login":"xyz","first_name":"Test","last_name":"Con1","gender":"Male","gym_id":"46e51ef9-d5df-4d02-8bbb-2620b77ebe","is_active":"xyz","modified_at":"2020-07-24T05:13:32.870Z","created_at":"2020-07-24T05:13:32.869Z","is_deleted":"xyz","phone":"9876543210","role":"Coach","team_id":"xyz","social_handles":"xyz"}');
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