@isTest
public class FF3_0_Find_One_Team_Mock implements HttpCalloutMock
{
    public static String responseType = 'success';
    
    public FF3_0_Find_One_Team_Mock(String type)
    {
        FF3_0_Find_One_Team_Mock.responseType = type;
        //System.debug('type = ' + type);
        //System.debug('FF3_0_Find_One_Team_Mock.responseType = ' + FF3_0_Find_One_Team_Mock.responseType);
    }
    
    public FF3_0_Find_One_Team_Mock()
    {
        FF3_0_Find_One_Team_Mock.responseType = 'success';
    }
    
    public HttpResponse respond(HTTPRequest req)
    {
        HttpResponse res = new HttpResponse();
        
        if(responseType == 'success')
        {
            //System.debug('success');
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('{"team_name":"New Roster","gym_id":"111-gym-111","team_id":"111-ros-111","modified_at":"2020-07-24T05:13:32.870Z","created_at":"2020-07-24T05:13:32.869Z","member_count":"2"}');
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