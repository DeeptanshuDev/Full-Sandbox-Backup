/**
*  Description     :   Test class to test the functionality FitFreedomRestServiceOrderSize apex class.
*            
*  Create By       :   Abhinav Sharma
*
*  Created Date    :   18-05-2020
*
*  Revision Log    :   V_1.0 - Created - Abhinav Sharma
*
*  Coverage        :   97%
*
**/

@isTest(seeAllData = false)
private with sharing class Test_FitFreedomRestServiceOrderSize 
{

    //Create Order Size data
    static void createOrderSizes(){
                
        //Insert Order Size record
        //List to hold Order Size records
        List<Order_Sizes__c> orderSizes = new List<Order_Sizes__c>();
        orderSizes.add(new Order_Sizes__c(Name = 'Order Size Demo 001' , order_size_id__c = 'b3284308-8a19-41dc-bb94-eo2' , order_id__c = '0041817' , member_id__c = 'b3284308-8a19-41dc-bb94-ee23103263m1' , order_sizes__c = 'A2XL' , team_id__c = 'd250330f-1906-4175-a874-67a608fef44t1'));
        orderSizes.add(new Order_Sizes__c(Name = 'Order Size Demo 002' , order_size_id__c = 'b3284308-8a19-41dc-bb94-eo3' , order_id__c = '0041818' , member_id__c = 'b3284308-8a19-41dc-bb94-ee23103263m2' , order_sizes__c = 'A2XL' , team_id__c = 'd250330f-1906-4175-a874-67a608fef44t2'));
        orderSizes.add(new Order_Sizes__c(Name = 'Order Size Demo 003' , order_size_id__c = 'b3284308-8a19-41dc-bb94-eo4' , order_id__c = '0041819' , member_id__c = 'b3284308-8a19-41dc-bb94-ee23103263m3' , order_sizes__c = 'A2XL' , team_id__c = 'd250330f-1906-4175-a874-67a608fef44t3'));
        insert orderSizes;

    }
    
    //Create Order Size data
    static void createOrderSizesRelatedData(){
        
        //Insert account
        Account account = new Account(Name = 'Gym Account 001' , Type = 'All Star');
        insert account;
        
        //Insert Contacts
        List<Contact> contacts = new List<Contact>();
        contacts.add(new Contact(LastName = '001' , FirstName = 'Contact Demo ' , Email = 'contactdemo001@gmail.com' , AccountId = account.Id , member_id__c = 'b3284308-8a19-41dc-bb94-ee2310326321'));
        contacts.add(new Contact(LastName = '002' , FirstName = 'Contact Demo ' , Email = 'contactdemo001@gmail.com' , AccountId = account.Id , member_id__c = 'm845b5091-7f8b-404b-8d8a-124'));
        contacts.add(new Contact(LastName = '003' , FirstName = 'Contact Demo ' , Email = 'contactdemo001@gmail.com' , AccountId = account.Id , member_id__c = 'b3284308-8a19-41dc-bb94-ee2310387451'));
        insert contacts;
        
        //Insert team
        Opportunity opp = new Opportunity(  Name = 'Opportunity Demo 001' , StageName = 'Open' , AccountId = account.Id , CloseDate = System.today() , Type = 'New Order' , Primary_Contact__c = contacts[0].Id , Collection_Picklist__c = 'N/A' , Category_Picklist__c = 'All Star' );
        insert opp;
        
        Rosters__c ros = new Rosters__c(Name = 'Fusion All Star', rosters_id__c = 'd250330f-1906-4175-a874-67a608fef44e', gym_id__c = 'b3284308-8a19-41dc-bb94-ee231039f8g3', Account__c = account.Id);
        insert ros;
        
        Custom_Item__c cItem = new Custom_Item__c(order_id__c = '111-ci-111', team_id__c = 'd250330f-1906-4175-a874-67a608fef44e',  Stated_Quantity__c=5, Opportunity__c = opp.Id); //Rosters__c = ros.id,
        insert cItem;
        
        Standardized_Item__c sItem = new Standardized_Item__c(Stated_Quantity__c = 2, Quantity__c = 2, order_id__c = '111-si-111', team_id__c = 'd250330f-1906-4175-a874-67a608fef44e',Opportunity__c = opp.Id); //, Rosters__c = ros.id
        insert sItem;
        
        //Insert Measurement
        Measurement__c measurement = new Measurement__c(Name = 'Measurement Demo 001' , measure_id__c = '0711a3f0-7bf1-47f3-81f0-a4eda45bae9w');
        insert measurement;

    }
    
    //Get Order Sizes
    static testMethod void test_GetOrderSizesFromSFDC()
    {
        
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_ORDER_SIZE+ FitFreedomUrlMappings.ORDERSIZE_AT_GET_ALL_ORDER_SIZES + '/';
        request.httpMethod = 'GET';
        request.requestBody = Blob.valueof('');
        RestContext.request = request;

        FitFreedomRestServiceOrderSize.OrderSizeResponseWrapper res = new FitFreedomRestServiceOrderSize.OrderSizeResponseWrapper();
        
        Test.startTest();
        
        res = FitFreedomRestServiceOrderSize.getOrderSizesFromSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('No order size found.' , res.message);

        //Create data
        createOrderSizes();
        
        res = FitFreedomRestServiceOrderSize.getOrderSizesFromSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_SUCCESS , res.status);
        System.assertEquals(200 , res.statuscode);
        System.assertEquals('Get Order Sizes Successful' , res.message);
        System.assertEquals(3 , res.orderSizes.size());
        
        request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_ORDER_SIZE;
        RestContext.request = request;

        res = FitFreedomRestServiceOrderSize.getOrderSizesFromSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('No Resource found or unknown action type.' , res.message);
        
        Test.stopTest();

    }
    
    //Create Order Sizes
    static testMethod void testPositive_CreateOrderSizeAtSFDC_CustomItem()
    {
        createOrderSizesRelatedData();
        
        List<Order_Sizes__c> oSIzeOld = [SELECT Id FROM Order_Sizes__c];
        System.assertEquals(0, oSIzeOld.size());
        String reqBody = '';
        
        reqBody = '{"order_size_id":"b3284308-8a19-41dc-bb94-eo2","order_id":"111-ci-111","member_id":"b3284308-8a19-41dc-bb94-ee2310326321","measure_id":"0711a3f0-7bf1-47f3-81f0-a4eda45bae9w","team_id":"d250330f-1906-4175-a874-67a608fef44e","approved_by":"m845b5091-7f8b-404b-8d8a-124","modified_by":"b3284308-8a19-41dc-bb94-ee2310387451"}';        
        
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_ORDER_SIZE+ FitFreedomUrlMappings.ORDERSIZE_AT_CREATE_SINGLE_ORDERSIZE + '/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;

        FitFreedomRestServiceOrderSize.OrderSizeResponseWrapper res = new FitFreedomRestServiceOrderSize.OrderSizeResponseWrapper();
        
        Test.startTest();

        res = FitFreedomRestServiceOrderSize.createOrderSizeAtSFDC();
      
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_SUCCESS , res.status);
        System.assertEquals(200 , res.statuscode);
        System.assertEquals(Constants.HTTP_RESPONSE_CREATED + Constants.CHAR_SPACE + Constants.CHAR_COLON + 
                            Constants.CHAR_SPACE + 'Order Sizes Created Successful' , res.message);
        
        List<Order_Sizes__c> oSIze = [SELECT Id FROM Order_Sizes__c];
        System.assertEquals(1, oSIze.size());
        
        Test.stopTest();
    }
    
    //Create Order Sizes
    static testMethod void testPositive_CreateOrderSizeAtSFDC_Standardizedtem()
    {
        createOrderSizesRelatedData();
        
        List<Order_Sizes__c> oSIzeOld = [SELECT Id FROM Order_Sizes__c];
        System.assertEquals(0, oSIzeOld.size());
        
        String reqBody = '';
        
        reqBody = '{"order_size_id":"b3284308-8a19-41dc-bb94-eo2","order_id":"111-si-111","member_id":"b3284308-8a19-41dc-bb94-ee2310326321","measure_id":"0711a3f0-7bf1-47f3-81f0-a4eda45bae9w","team_id":"d250330f-1906-4175-a874-67a608fef44e","approved_by":"m845b5091-7f8b-404b-8d8a-124","modified_by":"b3284308-8a19-41dc-bb94-ee2310387451"}';        
        
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_ORDER_SIZE+ FitFreedomUrlMappings.ORDERSIZE_AT_CREATE_SINGLE_ORDERSIZE + '/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;

        FitFreedomRestServiceOrderSize.OrderSizeResponseWrapper res = new FitFreedomRestServiceOrderSize.OrderSizeResponseWrapper();
        
        Test.startTest();

        res = FitFreedomRestServiceOrderSize.createOrderSizeAtSFDC();
      
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_SUCCESS , res.status);
        System.assertEquals(200 , res.statuscode);
        System.assertEquals(Constants.HTTP_RESPONSE_CREATED + Constants.CHAR_SPACE + Constants.CHAR_COLON + 
                            Constants.CHAR_SPACE + 'Order Sizes Created Successful' , res.message);
        
        List<Order_Sizes__c> oSIze = [SELECT Id FROM Order_Sizes__c];
        System.assertEquals(1, oSIze.size());
        
        Test.stopTest();
    }
    
    //Create Order Sizes
    static testMethod void testNegative_CreateOrderSizeAtSFDC()
    {
        //Create data
        createOrderSizes();

        createOrderSizesRelatedData();
        
        String reqBody = '';
        
        reqBody = '{"order_size_id":"b3284308-8a19-41dc-bb94-eo2","order_id":"0041817","member_id":"b3284308-8a19-41dc-bb94-ee2310326321","measure_id":"0711a3f0-7bf1-47f3-81f0-a4eda45bae9w","team_id":"d250330f-1906-4175-a874-67a608fef44e","approved_by":"m845b5091-7f8b-404b-8d8a-124","modified_by":"b3284308-8a19-41dc-bb94-ee2310387451"}';        
        
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_ORDER_SIZE+ FitFreedomUrlMappings.ORDERSIZE_AT_CREATE_SINGLE_ORDERSIZE + '/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;

        FitFreedomRestServiceOrderSize.OrderSizeResponseWrapper res;
        Test.startTest();
        
        //Error Handling
        reqBody = '{"order_size_id":"","order_id":"111-ci-111","member_id":"b3284308-8a19-41dc-bb94-ee2310326321","measure_id":"0711a3f0-7bf1-47f3-81f0-a4eda45bae9w","team_id":"d250330f-1906-4175-a874-67a608fef44e","approved_by":"m845b5091-7f8b-404b-8d8a-124","modified_by":"b3284308-8a19-41dc-bb94-ee2310387451"}';        
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
        res = FitFreedomRestServiceOrderSize.createOrderSizeAtSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('please have a value for order_size_id for the order sizes in the request body' , res.message);

        //Error Handling
        reqBody = '{"order_size_id":"b3284308-8a19-41dc-bb94-eo2","order_id":"","member_id":"b3284308-8a19-41dc-bb94-ee2310326321","measure_id":"0711a3f0-7bf1-47f3-81f0-a4eda45bae9w","team_id":"d250330f-1906-4175-a874-67a608fef44e","approved_by":"m845b5091-7f8b-404b-8d8a-124","modified_by":"b3284308-8a19-41dc-bb94-ee2310387451"}';        
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
        res = FitFreedomRestServiceOrderSize.createOrderSizeAtSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('please have a value for order_id for the order sizes in the request body' , res.message);

        //Error Handling
        reqBody = '{"order_size_id":"b3284308-8a19-41dc-bb94-eo2","order_id":"111-ci-111","member_id":"","measure_id":"0711a3f0-7bf1-47f3-81f0-a4eda45bae9w","team_id":"d250330f-1906-4175-a874-67a608fef44e","approved_by":"m845b5091-7f8b-404b-8d8a-124","modified_by":"b3284308-8a19-41dc-bb94-ee2310387451"}';        
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
        res = FitFreedomRestServiceOrderSize.createOrderSizeAtSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('please have a value for member_id for the order sizes in the request body' , res.message);

        //Error Handling
        reqBody = '{"order_size_id":"b3284308-8a19-41dc-bb94-eo2","order_id":"111-ci-111","member_id":"b3284308-8a19-41dc-bb94-ee2310326321","measure_id":"","team_id":"d250330f-1906-4175-a874-67a608fef44e","approved_by":"m845b5091-7f8b-404b-8d8a-124","modified_by":"b3284308-8a19-41dc-bb94-ee2310387451"}';        
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
        res = FitFreedomRestServiceOrderSize.createOrderSizeAtSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('please have a value for measure_id for the order sizes in the request body' , res.message);

        //Error Handling
        reqBody = '{"order_size_id":"b3284308-8a19-41dc-bb94-eo2","order_id":"111-ci-111","member_id":"b3284308-8a19-41dc-bb94-ee2310326321","measure_id":"0711a3f0-7bf1-47f3-81f0-a4eda45bae9w","team_id":"","approved_by":"m845b5091-7f8b-404b-8d8a-124","modified_by":"b3284308-8a19-41dc-bb94-ee2310387451"}';        
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
        res = FitFreedomRestServiceOrderSize.createOrderSizeAtSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('please have a value for team_id for the order sizes in the request body' , res.message);
        
        //Error Handling
        reqBody = '{"order_size_id":"b3284308-8a19-41dc-bb94-eo2","order_id":"004187","member_id":"b3284308-8a19-41dc-bb94-ee2310326321","measure_id":"0711a3f0-7bf1-47f3-81f0-a4eda45bae9w","team_id":"d250330f-1906-4175-a874-67a608fef44e","approved_by":"m845b5091-7f8b-404b-8d8a-124","modified_by":"b3284308-8a19-41dc-bb94-ee2310387451"}';        
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
        res = FitFreedomRestServiceOrderSize.createOrderSizeAtSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('unable to find a Order for the order_id that we have in the request body' , res.message);

        //Error Handling
        reqBody = '{"order_size_id":"b3284308-8a19-41dc-bb94-eo2","order_id":"111-ci-111","member_id":"b3284308-8a19-41dc-bb94-ee23103261","measure_id":"0711a3f0-7bf1-47f3-81f0-a4eda45bae9w","team_id":"d250330f-1906-4175-a874-67a608fef44e","approved_by":"m845b5091-7f8b-404b-8d8a-124","modified_by":"b3284308-8a19-41dc-bb94-ee2310387451"}';        
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
        res = FitFreedomRestServiceOrderSize.createOrderSizeAtSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('unable to find a Member for the memeber_id that we have in the request body' , res.message);

        //Error Handling
        reqBody = '{"order_size_id":"b3284308-8a19-41dc-bb94-eo2","order_id":"111-ci-111","member_id":"b3284308-8a19-41dc-bb94-ee2310326321","measure_id":"0711a3f0-7bf1-47f3-81f0-a4eda45bae9w","team_id":"d250330f-1906-4175-a874-67a608fefe","approved_by":"m845b5091-7f8b-404b-8d8a-124","modified_by":"b3284308-8a19-41dc-bb94-ee2310387451"}';        
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
        res = FitFreedomRestServiceOrderSize.createOrderSizeAtSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('unable to find a Team  for the team_id that we have in the request body' , res.message);

        //Error Handling
        reqBody = '{"order_size_id":"b3284308-8a19-41dc-bb94-eo2","order_id":"111-ci-111","member_id":"b3284308-8a19-41dc-bb94-ee2310326321","measure_id":"0711a3f0-7bf1-47f3-81f0-a4eda45baaw","team_id":"d250330f-1906-4175-a874-67a608fef44e","approved_by":"m845b5091-7f8b-404b-8d8a-124","modified_by":"b3284308-8a19-41dc-bb94-ee2310387451"}';        
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
        res = FitFreedomRestServiceOrderSize.createOrderSizeAtSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('unable to find a Measurement  for the measure_id that we have in the request body' , res.message);
        
        //Error Handling
        request.requestBody = null;
        RestContext.request = request;
        res = FitFreedomRestServiceOrderSize.createOrderSizeAtSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('Please Provide Valid Request Body' , res.message);

        //Error Handling
        reqBody = '{"order_size_id":"b3284308-8a19-41dc-bb94-eo2",order_id":"111-ci-111","member_id":"b3284308-8a19-41dc-bb94-ee2310326321","measure_id":"0711a3f0-7bf1-47f3-81f0-a4eda45bae9w","team_id":"d250330f-1906-4175-a874-67a608fef44e","approved_by":"m845b5091-7f8b-404b-8d8a-124","modified_by":"b3284308-8a19-41dc-bb94-ee231038741"}';        
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
        res = FitFreedomRestServiceOrderSize.createOrderSizeAtSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        
        //Error Handling
        reqBody = '{"order_size_id":"b3284308-8a19-41dc-bb94-eo2","order_id":"111-ci-111","member_id":"b3284308-8a19-41dc-bb94-ee2310326321","measure_id":"0711a3f0-7bf1-47f3-81f0-a4eda45bae9w","team_id":"d250330f-1906-4175-a874-67a608fef44e","approved_by":"m845b5091-7f8b-404b-8d8a-124","modified_by":"b3284308-8a19-41dc-bb94-ee231038741"}';        
        request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_ORDER_SIZE+'xyz/';
        request.requestBody = Blob.valueof(reqBody);
        RestContext.request = request;
        res = FitFreedomRestServiceOrderSize.createOrderSizeAtSFDC();
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('No Resource Found or unsupport action type.' , res.message);

        Test.stopTest();

    }
    
    //Update Order Sizes
    @isTest
    static void testPositive_UpdateOrderSizeAtSFDC_CustomItem()
    {
        createOrderSizesRelatedData();
        createOrderSizes();
        
        String reqBody = '';
        
        reqBody = '{"order_size_id":"b3284308-8a19-41dc-bb94-eo2","order_id":"111-ci-111","member_id":"b3284308-8a19-41dc-bb94-ee2310326321","measure_id":"0711a3f0-7bf1-47f3-81f0-a4eda45bae9w","team_id":"d250330f-1906-4175-a874-67a608fef44e","approved_by":"m845b5091-7f8b-404b-8d8a-124","modified_by":"b3284308-8a19-41dc-bb94-ee2310387451"}';        
        
        // Set up a test request
        RestContext.request = createRequest('updateOrderSize', 'PUT', reqBody, Constants.HTTP_HEADER_ID, 'b3284308-8a19-41dc-bb94-eo2');
        
        FitFreedomRestServiceOrderSize.OrderSizeResponseWrapper res = new FitFreedomRestServiceOrderSize.OrderSizeResponseWrapper();
        
        Test.startTest();

        res = FitFreedomRestServiceOrderSize.updateOrderSizeAtSFDC();
      
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_SUCCESS , res.status);
        System.assertEquals(200 , res.statuscode);
        System.assertEquals('Edit' + Constants.CHAR_SPACE + Constants.CHAR_COLON + 
                                   Constants.CHAR_SPACE + 'Order Sizes Updated Successful' , res.message);
        
        Test.stopTest();
    }

     @isTest
    static void testNeg_BlankId_UpdateOrderSizeAtSFDC_CustomItem()
    {
        createOrderSizesRelatedData();
        createOrderSizes();
        
       
        String reqBody = '';
        
        reqBody = '{"order_size_id":"","order_id":"111-ci-111","member_id":"b3284308-8a19-41dc-bb94-ee2310326321","measure_id":"0711a3f0-7bf1-47f3-81f0-a4eda45bae9w","team_id":"d250330f-1906-4175-a874-67a608fef44e","approved_by":"m845b5091-7f8b-404b-8d8a-124","modified_by":"b3284308-8a19-41dc-bb94-ee2310387451"}';        
        
        // Set up a test request
        RestContext.request = createRequest('updateOrderSize', 'PUT', reqBody, Constants.HTTP_HEADER_ID, 'b3284308-8a19-41dc-bb94-eo2');
        
        FitFreedomRestServiceOrderSize.OrderSizeResponseWrapper res = new FitFreedomRestServiceOrderSize.OrderSizeResponseWrapper();
        
        Test.startTest();

        res = FitFreedomRestServiceOrderSize.updateOrderSizeAtSFDC();
      
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('please have a value for order_size_id for the order sizes in the request body' , res.message);
                
        Test.stopTest();
    }
    
    
    @isTest
    static void testNeg_BlankOderId_UpdateOrderSizeAtSFDC_CustomItem()
    {
        createOrderSizesRelatedData();
        createOrderSizes();
        
        String reqBody = '';
        
        reqBody = '{"order_size_id":"b3284308-8a19-41dc-bb94-eo2","order_id":"","member_id":"b3284308-8a19-41dc-bb94-ee2310326321","measure_id":"0711a3f0-7bf1-47f3-81f0-a4eda45bae9w","team_id":"d250330f-1906-4175-a874-67a608fef44e","approved_by":"m845b5091-7f8b-404b-8d8a-124","modified_by":"b3284308-8a19-41dc-bb94-ee2310387451"}';        
        
        // Set up a test request
        RestContext.request = createRequest('updateOrderSize', 'PUT', reqBody, Constants.HTTP_HEADER_ID, 'b3284308-8a19-41dc-bb94-eo2');
        
        FitFreedomRestServiceOrderSize.OrderSizeResponseWrapper res = new FitFreedomRestServiceOrderSize.OrderSizeResponseWrapper();
        
        Test.startTest();

        res = FitFreedomRestServiceOrderSize.updateOrderSizeAtSFDC();
      
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('please have a value for order_id for the order sizes in the request body' , res.message);
        
        Test.stopTest();
    }
    
    @isTest
    static void testNeg_BlankMemeberId_UpdateOrderSizeAtSFDC_CustomItem()
    {
        createOrderSizesRelatedData();
        createOrderSizes();
        
        String reqBody = '';
        
        reqBody = '{"order_size_id":"b3284308-8a19-41dc-bb94-eo2","order_id":"111-ci-111","member_id":"","measure_id":"0711a3f0-7bf1-47f3-81f0-a4eda45bae9w","team_id":"d250330f-1906-4175-a874-67a608fef44e","approved_by":"m845b5091-7f8b-404b-8d8a-124","modified_by":"b3284308-8a19-41dc-bb94-ee2310387451"}';        
        
        // Set up a test request
        RestContext.request = createRequest('updateOrderSize', 'PUT', reqBody, Constants.HTTP_HEADER_ID, 'b3284308-8a19-41dc-bb94-eo2');
        
        FitFreedomRestServiceOrderSize.OrderSizeResponseWrapper res = new FitFreedomRestServiceOrderSize.OrderSizeResponseWrapper();
        
        Test.startTest();

        res = FitFreedomRestServiceOrderSize.updateOrderSizeAtSFDC();
      
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('please have a value for member_id for the order sizes in the request body' , res.message);
        
        Test.stopTest();
    }
    
    @isTest
    static void testNeg_BlankMeasureId_UpdateOrderSizeAtSFDC_CustomItem()
    {
        createOrderSizesRelatedData();
        createOrderSizes();
        
        String reqBody = '';
        
        reqBody = '{"order_size_id":"b3284308-8a19-41dc-bb94-eo2","order_id":"111-ci-111","member_id":"b3284308-8a19-41dc-bb94-ee2310326321","measure_id":"","team_id":"d250330f-1906-4175-a874-67a608fef44e","approved_by":"m845b5091-7f8b-404b-8d8a-124","modified_by":"b3284308-8a19-41dc-bb94-ee2310387451"}';        
        
        // Set up a test request
        RestContext.request = createRequest('updateOrderSize', 'PUT', reqBody, Constants.HTTP_HEADER_ID, 'b3284308-8a19-41dc-bb94-eo2');
        
        FitFreedomRestServiceOrderSize.OrderSizeResponseWrapper res = new FitFreedomRestServiceOrderSize.OrderSizeResponseWrapper();
        
        Test.startTest();

        res = FitFreedomRestServiceOrderSize.updateOrderSizeAtSFDC();
      
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('please have a value for measure_id for the order sizes in the request body' , res.message);
        
        Test.stopTest();
    }
    
    @isTest
    static void testNeg_BlankTeamId_UpdateOrderSizeAtSFDC_CustomItem()
    {
        createOrderSizesRelatedData();
        createOrderSizes();
        
        String reqBody = '';
        
        reqBody = '{"order_size_id":"b3284308-8a19-41dc-bb94-eo2","order_id":"111-ci-111","member_id":"b3284308-8a19-41dc-bb94-ee2310326321","measure_id":"0711a3f0-7bf1-47f3-81f0-a4eda45bae9w","team_id":"","approved_by":"m845b5091-7f8b-404b-8d8a-124","modified_by":"b3284308-8a19-41dc-bb94-ee2310387451"}';        
        
        // Set up a test request
        RestContext.request = createRequest('updateOrderSize', 'PUT', reqBody, Constants.HTTP_HEADER_ID, 'b3284308-8a19-41dc-bb94-eo2');
        
        FitFreedomRestServiceOrderSize.OrderSizeResponseWrapper res = new FitFreedomRestServiceOrderSize.OrderSizeResponseWrapper();
        
        Test.startTest();

        res = FitFreedomRestServiceOrderSize.updateOrderSizeAtSFDC();
      
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL , res.status);
        System.assertEquals(400 , res.statuscode);
        System.assertEquals('please have a value for team_id for the order sizes in the request body' , res.message);
        
        Test.stopTest();
    }
    
   /* @isTest
    static void testNeg_JsonComputedDiff_UpdateOrderSizeAtSFDC_CustomItem()
    {
        createOrderSizesRelatedData();
        createOrderSizes();
        
        String reqBody = '';
        String computedDiff = '{"selected_size":"xyz","edit_size":"xyz"}';
        
        reqBody = '{"order_size_id":"b3284308-8a19-41dc-bb94-eo2","order_id":"111-ci-111","member_id":"b3284308-8a19-41dc-bb94-ee2310326321","measure_id":"0711a3f0-7bf1-47f3-81f0-a4eda45bae9w","team_id":"d250330f-1906-4175-a874-67a608fef44e","computed_diff":"'+computedDiff+'","approved_by":"m845b5091-7f8b-404b-8d8a-124","modified_by":"b3284308-8a19-41dc-bb94-ee2310387451"}';        
        
        // Set up a test request
        RestContext.request = createRequest('updateOrderSize', 'PUT', reqBody, Constants.HTTP_HEADER_ID, 'b3284308-8a19-41dc-bb94-eo2');
        
        FitFreedomRestServiceOrderSize.OrderSizeResponseWrapper res = new FitFreedomRestServiceOrderSize.OrderSizeResponseWrapper();
        
        Test.startTest();

        res = FitFreedomRestServiceOrderSize.updateOrderSizeAtSFDC();
      
        System.assertEquals(Constants.HTTP_RESPONSEWRAPPER_STATUS_SUCCESS , res.status);
        System.assertEquals(200 , res.statuscode);
        System.assertEquals('Edit' + Constants.CHAR_SPACE + Constants.CHAR_COLON + 
                                   Constants.CHAR_SPACE + 'Order Sizes Updated Successful' , res.message);
        
        Test.stopTest();
    }*/
    
    static RestRequest createRequest(String requestUrl, String method, String body, String paramKey, String paramValue)
    {
        RestRequest request = new RestRequest();
        if(requestUrl != null)
        {
           request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_ORDER_SIZE + requestUrl + '/'; 
        }
        else
        {
            request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_ORDER_SIZE; 
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
    
}