@isTest
public class FF_3_0_Create_New_Athlete_Mock implements HttpCalloutMock
{
    public static String responseType = 'success';
    
    public FF_3_0_Create_New_Athlete_Mock(String type)
    {
        FF_3_0_Create_New_Athlete_Mock.responseType = type;
        //System.debug('type = ' + type);
        //System.debug('FF_3_0_Create_New_Athlete_Mock.responseType = ' + FF_3_0_Create_New_Athlete_Mock.responseType);
    }
    
    public FF_3_0_Create_New_Athlete_Mock()
    {
        FF_3_0_Create_New_Athlete_Mock.responseType = 'success';
    }
    
    public HttpResponse respond(HTTPRequest req)
    {
        HttpResponse res = new HttpResponse();
        
        if(responseType == 'success')
        {
            //System.debug('success');
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('{"member_id":"713754df-a880-49c0-975f-76ab7620b772","is_deleted":false,"first_name":"Test","last_name":"Con1","gender":"","age":"1","team_id":"42915cd7-e66b-4a57-a78f-bdaf79ba7983","modified_at":"2020-07-31T06:44:26.969Z","createdAt":"2020-07-31T06:44:26.969Z","gym_id":"5a2b3ca2-532c-4bf1-8796-5679034fab31"}');
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