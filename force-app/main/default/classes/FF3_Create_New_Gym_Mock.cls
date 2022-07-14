@isTest
public class FF3_Create_New_Gym_Mock implements HttpCalloutMock
{
    public static String responseType = 'success';
    
    public FF3_Create_New_Gym_Mock(String type)
    {
        FF3_Create_New_Gym_Mock.responseType = type;
        //System.debug('type = ' + type);
        //System.debug('FF3_Create_New_Gym_Mock.responseType = ' + FF3_Create_New_Gym_Mock.responseType);
    }
    
    public FF3_Create_New_Gym_Mock()
    {
        FF3_Create_New_Gym_Mock.responseType = 'success';
    }
    
    public HttpResponse respond(HTTPRequest req)
    {
        HttpResponse res = new HttpResponse();
        
        if(responseType == 'success')
        {
            //System.debug('success');
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('{"modified_at":"2020-05-28T07:23:39.116Z","gym_id":"b73a1842-9d97-4e9b-9bff-6a1bea35528b","active":true,"created_at":"2020-05-28T07:23:39.116Z","owner_name":"TestGymOwner","owner":"0d9d09b3-cb73-48f0-9b1f-8fd17fb5f335","location":"Test","gym_type":"AllStar","gym_name":"Gym1","createdAt":"2020-05-28T07:23:39.116Z","team_id":"2cd976ee-a399-4932-b169-a162c4df607c"}');
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