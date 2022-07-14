/**
*   Description     :   Apex Test class for FitFreedomRestServiceMeasurement . 
*
*   Created By      :   
*
*   Created Date    :   06/08/2020
* 
*   Version         :   v1.0 - Created - 06/08/2020
**/
@isTest
public class Test_FitFreedomRestServiceOrder
{

    //Valid Find All Order
    @isTest
    public static void valid_FindAllOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"team_id":"111-team-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_GET_ALL_ORDERS, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        System.assertEquals(2, res.orders.size());
		Test.stopTest();
    }
    
    //Valid Find Order By Id
    @isTest
    public static void valid_FindOrderById()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"111-order-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_GET_ORDER_BY_ID, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        System.assertEquals(1, res.orders.size());
		Test.stopTest();
    }
    
    //Valid Finalize Order
    @isTest
    public static void valid_FinalizeOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"111-order-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_FINALIZE_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
		List<Custom_Item__c> cItemsUpdated = [SELECT Id,is_finalized__c  FROM Custom_Item__c WHERE order_id__c = '111-order-111' ];
        String sr = 'ss';
		System.assert(cItemsUpdated[0].is_finalized__c.equalsIgnoreCase('true'));
		Test.stopTest();
    }
    
    //Valid Submit Order
    @isTest
    public static void valid_SubmitOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"111-order-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_SUBMIT_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
		List<Custom_Item__c> cItemsUpdated = [SELECT Id,is_submitted__c  FROM Custom_Item__c WHERE order_id__c = '111-order-111' ];
		System.assert(cItemsUpdated[0].is_submitted__c.equalsIgnoreCase('true'));
		Test.stopTest();
    }
    
    //Valid Add Fit To  Order
    @isTest
    public static void valid_AddFitToOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"111-order-111","fit_id":"111-fit-111","type":"add"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_ADD_FIT_TO_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
		List<Custom_Item__c> cItemsUpdated = [SELECT Id,fits__c, fit__c  FROM Custom_Item__c WHERE order_id__c = '111-order-111' ];
		System.assertEquals('111-fit-111', cItemsUpdated[0].fits__c);
		System.assert(cItemsUpdated[0].fit__c != null);
		Test.stopTest();
    }
    
    //Valid Update Order
    @isTest
    public static void valid_UpdateOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"111-order-111","fit":"111-fit-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_UPDATE_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
		List<Custom_Item__c> cItemsUpdated = [SELECT Id,fits__c, fit__c  FROM Custom_Item__c WHERE order_id__c = '111-order-111' ];
		System.assertEquals('111-fit-111', cItemsUpdated[0].fits__c);
		System.assert(cItemsUpdated[0].fit__c != null);
		Test.stopTest();
    }
    
    //Valid Delete Order
    @isTest
    public static void valid_DeleteOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"111-order-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_DELETE_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
		List<Custom_Item__c> cItemsUpdated = [SELECT Id,Deleted_From_FF__c  FROM Custom_Item__c WHERE order_id__c = '111-order-111' ];
		System.assertEquals(true, cItemsUpdated[0].Deleted_From_FF__c);
		Test.stopTest();
    }
    
    //Valid Get Order Details
    @isTest
    public static void valid_GetOrderDetails()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"111-order-111","s_id":"6699ebbd-db09-461d-b88e-7902ac5e75d1"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_GET_ORDER_DETAILS, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
		System.assertEquals(1, res.orders.size());
		Test.stopTest();
    }
    
    //Valid Create Order
    /*@isTest
    public static void valid_CrateOrder()
    {
        //Creating Record
        createRelatedRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(1, opps.size());
		
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"111-order-111","order_name":"Order 1","team_id":"111-team-111","created_at":"02.12.30","modified_at":"02.12.30"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_CREATE_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(1, cItems.size());
		Test.stopTest();
    }*/
    
     //inValid 
    @isTest
    public static void invalid_nullActionType()
    {
        // Set up a test request
		Test.startTest();
		String body = '{"team_id":"111-team-111"}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
    
     //inValid 
    @isTest
    public static void invalid_wrongActionType()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"team_id":"111-team-111"}';
        RestContext.request = createRequest('xyz', 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
    
     //inValid 
    @isTest
    public static void invalid_Body()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"team_id":"111-team-11';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_CREATE_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
    
    //inValid 
    @isTest
    public static void invalid_nullBody()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_CREATE_ORDER, 'POST', null, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
    
    //inValid Find All Order
    @isTest
    public static void invalid_noRecord_FindAllOrder()
    {

        // Set up a test request
		Test.startTest();
		String body = '{"team_id":"111-team-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_GET_ALL_ORDERS, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
	
	//inValid Find All Order
    @isTest
    public static void valid_wrongTeamId_FindAllOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"team_id":"123-team-123"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_GET_ALL_ORDERS, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
    
    //inValid Find All Order
    @isTest
    public static void valid_blankTeamId_FindAllOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"team_id":""}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_GET_ALL_ORDERS, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
    
    //inValid Find All Order
    @isTest
    public static void valid_wrongBody_FindAllOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"xyz":"111-team-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_GET_ALL_ORDERS, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
    
    //inValid Get One Order
    @isTest
    public static void invalid_noRecord_GetOneOrder()
    {

        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"111-order-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_GET_ORDER_BY_ID, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
	
	//inValid Get One Order
    @isTest
    public static void valid_wrongOrderId_GetOneOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"123-order-123"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_GET_ORDER_BY_ID, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
    
    //inValid Get One Order
    @isTest
    public static void valid_blankOrderId_GetOneOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":""}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_GET_ORDER_BY_ID, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
    
    //inValid Get One Order
    @isTest
    public static void valid_wrongBody_GetOneOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"xyz":"111-order-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_GET_ORDER_BY_ID, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
    
    //inValid  
    @isTest
    public static void invalid_noRecord_FinalizeOrder()
    {

        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"111-order-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_FINALIZE_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
	
	//inValid 
    @isTest
    public static void valid_wrongOrderId_FinalizeOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"123-order-123"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_FINALIZE_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
    
    //inValid 
    @isTest
    public static void valid_blankOrderId_FinalizeOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":""}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_FINALIZE_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
    
    //inValid  
    @isTest
    public static void valid_wrongBody_FinalizeOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"xyz":"111-order-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_FINALIZE_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
	
	
    //inValid  
    @isTest
    public static void invalid_noRecord_SubmitOrder()
    {

        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"111-order-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_SUBMIT_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
	
	//inValid 
    @isTest
    public static void valid_wrongOrderId_SubmitOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"123-order-123"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_SUBMIT_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
    
    //inValid  
    @isTest
    public static void valid_blankOrderId_SubmitOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":""}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_SUBMIT_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
    
    //inValid  
    @isTest
    public static void valid_wrongBody_SubmitOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"xyz":"111-order-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_SUBMIT_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
	
	//inValid 
    @isTest
    public static void invalid_noRecord_DeleteOrder()
    {

        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"111-order-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_DELETE_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
	
	//inValid Get One Order
    @isTest
    public static void valid_wrongOrderId_DeleteOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"123-order-123"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_DELETE_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
    
    //inValid 
    @isTest
    public static void valid_blankOrderId_DeleteOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":""}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_DELETE_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
    
    //inValid 
    @isTest
    public static void valid_wrongBody_DeleteOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"xyz":"111-order-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_DELETE_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
    
    //inValid Add fit To Order
    @isTest
    public static void invalid_noRecord_AddFitToOrder()
    {

        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"111-order-111","fit_id":"111-fit-111","type":"add"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_ADD_FIT_TO_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
	
	//inValid Add fit To Order
    @isTest
    public static void valid_wrongOrderId_AddFitToOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"123-order-123","fit_id":"111-fit-111","type":"add"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_ADD_FIT_TO_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
	
	//inValid Add fit To Order
    @isTest
    public static void valid_wrongFitId_AddFitToOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"111-order-111","fit_id":"123-fit-123","type":"add"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_ADD_FIT_TO_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
	
	//inValid Add fit To Order
    @isTest
    public static void valid_wrongType_AddFitToOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"111-order-111","fit_id":"111-fit-111","type":"xyz"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_ADD_FIT_TO_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
	
	//inValid Add fit To Order
    @isTest
    public static void valid_blankOrderId_AddFitToOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"","fit_id":"111-fit-111","type":"add"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_ADD_FIT_TO_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
	
    //inValid Add fit To Order
    @isTest
    public static void valid_blankFitID_AddFitToOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"111-order-111","fit_id":"","type":"add"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_ADD_FIT_TO_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
	
	//inValid Add fit To Order
    @isTest
    public static void valid_blankType_AddFitToOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"111-order-111","fit_id":"111-fit-111","type":""}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_ADD_FIT_TO_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
	
	//inValid Add fit To Order
    @isTest
    public static void valid_noFitInBody_AddFitToOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"111-order-111","type":"add"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_ADD_FIT_TO_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
    
    //inValid Update Order
    @isTest
    public static void invalid_noRecord_UpdateOrder()
    {

        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"111-order-111","fit":"111-fit-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_UPDATE_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
	
	//inValid Update Order
    @isTest
    public static void valid_wrongOrderId_UpdateOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"123-order-123","fit":"111-fit-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_UPDATE_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
	
	//inValid Update Order
    @isTest
    public static void valid_wrongFitId_UpdateOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"111-order-111","fit":"123-fit-123"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_UPDATE_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
	
	
	//inValid Update Order
    @isTest
    public static void valid_blankOrderId_UpdateOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"","fit":"111-fit-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_UPDATE_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
	
    //inValid Update Order
    @isTest
    public static void valid_blankFitID_UpdateOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"111-order-111","fit":""}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_UPDATE_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
    
	//inValid Update Order
    @isTest
    public static void valid_noFitInBody_UpdateOrder()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"111-order-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_UPDATE_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
    
    //inValid Get Order Details
    @isTest
    public static void invalid_noRecord_GetOrderDetails()
    {
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"111-order-111","s_id":"111-sid-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_GET_ORDER_DETAILS, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
		System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
	
	//inValid Get Order Details
    @isTest
    public static void invalid_wrongOderId_GetOrderDetails()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"123-order-123","s_id":"111-sid-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_GET_ORDER_DETAILS, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
		System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
	
	//inValid Get Order Details
    @isTest
    public static void invalid_blankOrderId_GetOrderDetails()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"","s_id":"111-sid-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_GET_ORDER_DETAILS, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
		System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
	
	//inValid Get Order Details
    @isTest
    public static void invalid_noOrderNode_GetOrderDetails()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"s_id":"111-sid-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_GET_ORDER_DETAILS, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
		System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
	
	//inValid Get Order Details
    @isTest
    public static void invalid_blankSid_GetOrderDetails()
    {
        //Creating Record
        createRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(2, opps.size());
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(4, cItems.size());
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"111-order-111","s_id":""}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_GET_ORDER_DETAILS, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
		System.assertEquals(0, res.orders.size());
		Test.stopTest();
    }
	
	//inValid Create Order
    @isTest
    public static void invalid_wrongTeamId_CrateOrder()
    {
        //Creating Record
        createRelatedRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(1, opps.size());
		
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"111-order-111","order_name":"Order 1","team_id":"123-team-123","created_at":"02.12.30","modified_at":"02.12.30"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_CREATE_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(0, cItems.size());
		Test.stopTest();
    }
	
	//inValid Create Order
    @isTest
    public static void invalid_blankTeamId_CrateOrder()
    {
        //Creating Record
        createRelatedRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(1, opps.size());
		
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"111-order-111","order_name":"Order 1","team_id":"","created_at":"02.12.30","modified_at":"02.12.30"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_CREATE_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(0, cItems.size());
		Test.stopTest();
    }
	
	//inValid Create Order
    @isTest
    public static void invalid_blankOrderId_CrateOrder()
    {
        //Creating Record
        createRelatedRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(1, opps.size());
		
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"","order_name":"Order 1","team_id":"111-team-111","created_at":"02.12.30","modified_at":"02.12.30"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_CREATE_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(0, cItems.size());
		Test.stopTest();
    }
	
	//inValid Create Order
    @isTest
    public static void invalid_noOrderNode_CrateOrder()
    {
        //Creating Record
        createRelatedRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(1, opps.size());
		
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_name":"Order 1","team_id":"111-team-111","created_at":"02.12.30","modified_at":"02.12.30"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_CREATE_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(0, cItems.size());
		Test.stopTest();
    }
	
	//inValid Create Order
    @isTest
    public static void invalid_noTeamNode_CrateOrder()
    {
        //Creating Record
        createRelatedRecord();
		List<Opportunity> opps = [SELECT Id FROM Opportunity];
		System.assertEquals(1, opps.size());
		
        
        // Set up a test request
		Test.startTest();
		String body = '{"order_id":"111-order-111","order_name":"Order 1","created_at":"02.12.30","modified_at":"02.12.30"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.ORDER_AT_CREATE_ORDER, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceOrder.OrderResponseWrapper res = new FitFreedomRestServiceOrder.OrderResponseWrapper();
        res = FitFreedomRestServiceOrder.postMethodOrder();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
		List<Custom_Item__c> cItems = [SELECT Id FROM Custom_Item__c];
		System.assertEquals(0, cItems.size());
		Test.stopTest();
    }
    
    static RestRequest createRequest(String requestUrl, String method, String body, String paramKey, String paramValue)
    {
        RestRequest request = new RestRequest();
        if(requestUrl != null)
        {
           request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_ORDER + requestUrl; 
        }
        else
        {
            request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_ORDER; 
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
    
    static void createRecord()
    {
        Account account = new Account(Name = 'Gym Account 001' , Type = 'All Star');
        insert account;
        
        List<Opportunity> opps = new List<Opportunity>();
        opps.add(new Opportunity(team_id__c = '111-team-111', team_name__c = 'Fusion All Star', gym_id__c = '111-gym-111', Name = 'Opportunity Demo 001' , StageName = 'Open' , AccountId = account.Id , CloseDate = System.today() , Type = 'New Order' , Primary_Contact__c = null , Collection_Picklist__c = 'N/A' , Category_Picklist__c = 'All Star' ));
        opps.add(new Opportunity(team_id__c = '222-team-222', team_name__c = 'Fusion All Star 2', gym_id__c = '111-gym-111', Name = 'Opportunity Demo 002' , StageName = 'Open' , AccountId = account.Id , CloseDate = System.today() , Type = 'New Order' , Primary_Contact__c = null , Collection_Picklist__c = 'N/A' , Category_Picklist__c = 'All Star' ));
        insert opps;
        
        List<Custom_Item__c> citems = new List<Custom_Item__c>();
        citems.add(new Custom_Item__c(order_id__c = '111-order-111', team_id__c = '111-team-111', Team__c = opps[0].id, Stated_Quantity__c=5, Opportunity__c = opps[0].Id));
        citems.add(new Custom_Item__c(order_id__c = '222-order-222', team_id__c = '111-team-111', Team__c = opps[0].id, Stated_Quantity__c=5, Opportunity__c = opps[0].Id));
        citems.add(new Custom_Item__c(order_id__c = '333-order-333', team_id__c = '222-team-222', Team__c = opps[1].id, Stated_Quantity__c=5, Opportunity__c = opps[1].Id));
        citems.add(new Custom_Item__c(order_id__c = '444-order-444', team_id__c = '222-team-222', Team__c = opps[1].id, Stated_Quantity__c=5, Opportunity__c = opps[1].Id));
        insert cItems;
        
        Fit__c fit = new Fit__c(Name = 'Fit1', fit_id__c = '111-fit-111');
        insert fit;
    }
    
    static void createRelatedRecord()
    {
        Account account = new Account(Name = 'Gym Account 001' , Type = 'All Star');
        insert account;
        List<Opportunity> opps = new List<Opportunity>();
        opps.add(new Opportunity(team_id__c = '111-team-111', team_name__c = 'Fusion All Star', gym_id__c = '111-gym-111', Name = 'Opportunity Demo 001' , StageName = 'Open' , AccountId = account.Id , CloseDate = System.today() , Type = 'New Order' , Primary_Contact__c = null , Collection_Picklist__c = 'N/A' , Category_Picklist__c = 'All Star' ));
        insert opps;
    }
}