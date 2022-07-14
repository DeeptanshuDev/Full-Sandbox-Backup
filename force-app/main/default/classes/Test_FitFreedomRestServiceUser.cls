/**
*   Description     :   Apex Test class for FitFreedomRestServiceUser
*
*   Created By      :   
*
*   Created Date    :   31/07/2020
* 
*   Version         :   v1.0 - Created - 31/07/2020
*  
*   Coverage        :   
**/
@isTest
public class Test_FitFreedomRestServiceUser
{
    //Valid Get User By ID
    @isTest
    public static void valid_GetUserById()
    {
        //Inserting Record
		createSalesRep('1', FALSE);
        
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(FitFreedomUrlMappings.USER_AT_GET_USER_BY_USER_ID, 'GET', null, Constants.HTTP_HEADER_ID, '111-rep-111');
        
        //Calling Method
        FitFreedomRestServiceUser.UserResponseWrapper res = new FitFreedomRestServiceUser.UserResponseWrapper();
        res = FitFreedomRestServiceUser.getUsersFROMSFDC();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        System.assertEquals(1, res.users.size());
        
        Test.stopTest();
    }
    
    //inValid Get User By ID
    @isTest
    public static void invalid_GetUserById_WrongId()
    {
        //Inserting Record
		createSalesRep('1', FALSE);
        
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(FitFreedomUrlMappings.USER_AT_GET_USER_BY_USER_ID, 'GET', null, Constants.HTTP_HEADER_ID, '123-rep-123');
        
        //Calling Method
        FitFreedomRestServiceUser.UserResponseWrapper res = new FitFreedomRestServiceUser.UserResponseWrapper();
        res = FitFreedomRestServiceUser.getUsersFROMSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals('No Users found for Gym Id', res.message);
        
        Test.stopTest();
    }
    
	//inValid Get User By ID
    @isTest
    public static void invalid_GetUserById_WrongActionType()
    {
        //Inserting Record
		createSalesRep('1', FALSE);
        
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest('xyz', 'GET', null, Constants.HTTP_HEADER_ID, '123-rep-123');
        
        //Calling Method
        FitFreedomRestServiceUser.UserResponseWrapper res = new FitFreedomRestServiceUser.UserResponseWrapper();
        res = FitFreedomRestServiceUser.getUsersFROMSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals('Resource not found or unsupported action type', res.message);
        
        Test.stopTest();
    }
	
    //Valid Create Parent
    @isTest
    public static void valid_CreateParent()
    {
        //Inserting Record
        createRosters();
        
        Test.startTest();
        
        String body = '{"last_name":"TestParent","member_id":"111-mem-111","team_id":"111-ros-111"}';
        // Set up a test request
        RestContext.request = createRequest(FitFreedomUrlMappings.USER_AT_CREATE_PARENT, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceUser.UserResponseWrapper res = new FitFreedomRestServiceUser.UserResponseWrapper();
        res = FitFreedomRestServiceUser.insertUserAtSFDC();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        System.assertEquals(Constants.HTTP_RESPONSE_CREATED + Constants.CHAR_SPACE + Constants.CHAR_COLON + Constants.CHAR_SPACE + 'Parent Created Sucessful', 
                            res.message);
        
        List<Contact> cons = [Select Id From Contact];
		System.assertEquals(1, cons.size());
        
        Test.stopTest();
    }
   
    	//inValid Create Parent
    @isTest
    public static void invalid_CreateParent_BlankName()
    {
        //Inserting Record
        createRosters();
        
        Test.startTest();
        
        String body = '{"last_name":"","member_id":"111-mem-111","team_id":"111-ros-111"}';
        // Set up a test request
        RestContext.request = createRequest(FitFreedomUrlMappings.USER_AT_CREATE_PARENT, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceUser.UserResponseWrapper res = new FitFreedomRestServiceUser.UserResponseWrapper();
        res = FitFreedomRestServiceUser.insertUserAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals('please specify last_name for Parent in the request body' , res.message);
        
        List<Contact> cons = [Select Id From Contact];
		System.assertEquals(0, cons.size());
        Test.stopTest();
    }
	
	//inValid Create Parent
    @isTest
    public static void invalid_CreateParent_BlankMemId()
    {
        //Inserting Record
        createRosters();
        
        Test.startTest();
        
        String body = '{"last_name":"TestParent","member_id":"","team_id":"111-ros-111"}';
        // Set up a test request
        RestContext.request = createRequest(FitFreedomUrlMappings.USER_AT_CREATE_PARENT, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceUser.UserResponseWrapper res = new FitFreedomRestServiceUser.UserResponseWrapper();
        res = FitFreedomRestServiceUser.insertUserAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals('please specify member_id for Parent in the request body' , res.message);
        List<Contact> cons = [Select Id From Contact];
		System.assertEquals(0, cons.size());
        Test.stopTest();
    }
	
	//inValid Create Parent
    @isTest
    public static void invalid_CreateParent_BlankTeamId()
    {
        //Inserting Record
        createRosters();
        
        Test.startTest();
        
        String body = '{"last_name":"TestParent","member_id":"111-mem-111","team_id":""}';
        // Set up a test request
        RestContext.request = createRequest(FitFreedomUrlMappings.USER_AT_CREATE_PARENT, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceUser.UserResponseWrapper res = new FitFreedomRestServiceUser.UserResponseWrapper();
        res = FitFreedomRestServiceUser.insertUserAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals('please specify team_id for Parent in the request body' , res.message);
        List<Contact> cons = [Select Id From Contact];
		System.assertEquals(0, cons.size());
        Test.stopTest();
    }
	
	//inValid Create Parent
    @isTest
    public static void invalid_CreateParent_WrongActionType()
    {
        //Inserting Record
        createRosters();
        
        Test.startTest();
        
        String body = '{"last_name":"TestParent","member_id":"111-mem-111","team_id":"111-ros-111"}';
        // Set up a test request
        RestContext.request = createRequest('xyz', 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceUser.UserResponseWrapper res = new FitFreedomRestServiceUser.UserResponseWrapper();
        res = FitFreedomRestServiceUser.insertUserAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals('Unsupported action type.' , res.message);
        List<Contact> cons = [Select Id From Contact];
		System.assertEquals(0, cons.size());
        Test.stopTest();
    }
   
   //Valid Delete Parent
    @isTest
    public static void valid_DeleteParent()
    {
        //Inserting Record
        createSalesRep('1', FALSE);
        
        Test.startTest();
        
        // Set up a test request
        RestContext.request = createRequest(FitFreedomUrlMappings.USER_AT_DELETE_PARENT, 'PUT', '', Constants.HTTP_USER_ID, '111-rep-111');
        
        //Calling Method
        FitFreedomRestServiceUser.UserResponseWrapper res = new FitFreedomRestServiceUser.UserResponseWrapper();
        res = FitFreedomRestServiceUser.updateUser();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        System.assertEquals('Parent Deleted Successful', res.message);
        List<Contact> cons = [Select Id From Contact WHERE Deleted_From_FF__c = TRUE];
		System.assertEquals(1, cons.size());
        Test.stopTest();
    }
   
    //inValid Delete Parent
    @isTest
    public static void invalid_DeleteParent_WrongUserId()
    {
        //Inserting Record
        createSalesRep('1', FALSE);
        
        Test.startTest();
        
        // Set up a test request
        RestContext.request = createRequest(FitFreedomUrlMappings.USER_AT_DELETE_PARENT, 'PUT', '', Constants.HTTP_USER_ID, '123-rep-123');
        
        //Calling Method
        FitFreedomRestServiceUser.UserResponseWrapper res = new FitFreedomRestServiceUser.UserResponseWrapper();
        res = FitFreedomRestServiceUser.updateUser();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals('No user found for given user id', res.message);
        List<Contact> cons = [Select Id From Contact WHERE Deleted_From_FF__c = FALSE];
		System.assertEquals(1, cons.size());
        Test.stopTest();
    }
	
	
	 //inValid Delete Parent
    @isTest
    public static void invalid_DeleteParent_NullParam()
    {
        //Inserting Record
        createSalesRep('1', FALSE);
        
        Test.startTest();
        
        // Set up a test request
        RestContext.request = createRequest(FitFreedomUrlMappings.USER_AT_DELETE_PARENT, 'PUT', '', null, null);
        
        //Calling Method
        FitFreedomRestServiceUser.UserResponseWrapper res = new FitFreedomRestServiceUser.UserResponseWrapper();
        res = FitFreedomRestServiceUser.updateUser();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals('Please Specify the userId in the Params', res.message);
        List<Contact> cons = [Select Id From Contact WHERE Deleted_From_FF__c = FALSE];
		System.assertEquals(1, cons.size());
        Test.stopTest();
    }
	
	
	 //inValid Delete Parent
    @isTest
    public static void invalid_DeleteParent_WrongActionType()
    {
        //Inserting Record
        createSalesRep('1', FALSE);
        
        Test.startTest();
        
        // Set up a test request
        RestContext.request = createRequest('xyz', 'PUT', '', Constants.HTTP_USER_ID, '111-rep-111');
        
        //Calling Method
        FitFreedomRestServiceUser.UserResponseWrapper res = new FitFreedomRestServiceUser.UserResponseWrapper();
        res = FitFreedomRestServiceUser.updateUser();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals('Resource not found or unsupported action type', res.message);
        List<Contact> cons = [Select Id From Contact WHERE Deleted_From_FF__c = FALSE];
		System.assertEquals(1, cons.size());
        Test.stopTest();
    }
	
	
	 //inValid Delete Parent
    @isTest
    public static void invalid_DeleteParent_NullBody()
    {
        //Inserting Record
        createSalesRep('1', FALSE);
        
        Test.startTest();
        
        // Set up a test request
        RestContext.request = createRequest(FitFreedomUrlMappings.USER_AT_DELETE_PARENT, 'PUT', null, Constants.HTTP_USER_ID, '111-rep-111');
        
        //Calling Method
        FitFreedomRestServiceUser.UserResponseWrapper res = new FitFreedomRestServiceUser.UserResponseWrapper();
        res = FitFreedomRestServiceUser.updateUser();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals('Please Provide Valid request Body', res.message);
        List<Contact> cons = [Select Id From Contact WHERE Deleted_From_FF__c = FALSE];
		System.assertEquals(1, cons.size());
        Test.stopTest();
    }
	
    //Valid Create Coach
    @isTest
    public static void valid_CreateCoach()
    {
        //Inserting Record
        createGym();
        
        Test.startTest();
        
        String body = '{"last_name":"TestParent","user_id":"111-mem-111","gym_id":"111-gym-111","role":"Coach"}';
        // Set up a test request
        RestContext.request = createRequest(FitFreedomUrlMappings.USER_AT_CREATE_USER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceUser.UserResponseWrapper res = new FitFreedomRestServiceUser.UserResponseWrapper();
        res = FitFreedomRestServiceUser.insertUserAtSFDC();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        System.assertEquals('New Coach Created successfully', res.message);
        
		List<Contact> cons = [Select Id From Contact];
		System.assertEquals(1, cons.size());
        Test.stopTest();
    }
	
	
	
	//Valid Create SalesRep
    @isTest
    public static void valid_CreateSalesRep()
    {
        //Inserting Record
        createGym();
        
        Test.startTest();
        
        String body = '{"last_name":"TestParent","user_id":"111-mem-111","gym_id":"111-gym-111"}';
        // Set up a test request
        RestContext.request = createRequest(FitFreedomUrlMappings.USER_AT_CREATE_USER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceUser.UserResponseWrapper res = new FitFreedomRestServiceUser.UserResponseWrapper();
        res = FitFreedomRestServiceUser.insertUserAtSFDC();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        System.assertEquals('New user Created successfully', res.message);
        
		List<Contact> cons = [Select Id From Contact];
		System.assertEquals(1, cons.size());
        Test.stopTest();
    }
    
    static RestRequest createRequest(String requestUrl, String method, String body, String paramKey, String paramValue)
    {
        RestRequest request = new RestRequest();
        if(requestUrl != null)
        {
           request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_User + requestUrl + '/'; 
        }
        else
        {
            request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_User; 
        }
        
        request.httpMethod = method.toUpperCase();
        
        if(body != null)
        {
            request.requestBody = Blob.valueof(body);
        }
        if(paramKey != null && paramValue != null)
        {
            request.addParameter(paramKey, paramValue);
        }
        return request;
    }
    
    static Id createSalesRep(String num, Boolean addTeamId)
    {
        String idNum = num + num + num;
        Contact record = new Contact();
        record.LastName = 'Sales Rep' + num;
        record.user_id__c = idNum + '-rep-' + idNum;
        record.member_id__c = idNum + '-rep-' + idNum;
        record.Fit_Freedom_Type__c = 'Sales Rep';
		if(addTeamId)
		{
			record.team_id__c = idNum + '-team-' + idNum;
		}
        
        insert record;
        return record.Id;
    }
    
    static Id createRosters()
    {
        Account acc = new Account(Name = 'Test Acc');
        insert acc;
        
        Rosters__c ros = new Rosters__c(Name = 'Test Ros', rosters_id__c = '111-ros-111', Account__c = acc.Id);
        insert ros;
        
        return ros.Id;
    }
    
    static Id createGym()
    {
        Account acc = new Account(Name = 'Test Acc', gym_id__c = '111-gym-111');
        insert acc;
        return acc.Id;
    }
}