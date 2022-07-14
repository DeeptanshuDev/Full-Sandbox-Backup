@isTest
public class FF3_0_Add_Fit_To_Order_Mock implements HttpCalloutMock
{
    public static String responseType = 'success';
    
    public FF3_0_Add_Fit_To_Order_Mock(String type)
    {
        FF3_0_Add_Fit_To_Order_Mock.responseType = type;
        //System.debug('type = ' + type);
        //System.debug('FF3_0_Add_Fit_To_Order_Mock.responseType = ' + FF3_0_Add_Fit_To_Order_Mock.responseType);
    }
    
    public FF3_0_Add_Fit_To_Order_Mock()
    {
        FF3_0_Add_Fit_To_Order_Mock.responseType = 'success';
    }
    
    public HttpResponse respond(HTTPRequest req)
    {
        HttpResponse res = new HttpResponse();
        
        if(responseType == 'success')
        {
            //System.debug('success');
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('');
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