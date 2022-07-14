/**
*   Purpose         :   Class to have rest resources and services for Fit Freedom App.
*   Created By      :   Ayush Gupta
*   Created Date    :   05/20/2020
*   Revision Log    :   v1.0 - Created - 05/20/2020
**/
@RestResource(urlMapping='/fitfreedomv3Order/*')
global class FitFreedomRestServiceOrder
{
    @HttpPost
    global static OrderResponseWrapper postMethodOrder() 
    {
        /*final String getAllOrders = 'get_orders';
        final String getorderByOrderId = 'get_order';
        final String finalizeOrder = 'finalize-order';
        final String addFitToOrder = 'addfitToOrder';
        final String createOrder = 'createOrder';
        final String submitOrder = 'submit-order';
        final String updateOrder = 'update-order';
        final String deleteOrder = 'delete-order';
        final String getOrderDetails = 'get-order-details';*/
        
        OrderResponseWrapper res = new OrderResponseWrapper();
        RestRequest req = RestContext.request;
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        
        try
        {
            Blob body = req.requestBody;
            if(body != null) 
            {
                JSONParser parser = JSON.createParser(body.toString());
                String actionType = req.requestURI.substringAfter('/fitfreedomv3Order/');
                List<Custom_Item__c> orders = new List<Custom_Item__c>();
                List<Standardized_Item__c> standOrders = new List<Standardized_Item__c>();
                System.debug('actionType--'+actionType);
                //4) Get All Orders (POST)
                if(actionType == FitFreedomUrlMappings.ORDER_AT_GET_ALL_ORDERS)
                {
                    wsLog.Operation_Name__c = 'Get All Orders';
                    String teamId = '';
                    while (parser.nextToken() != null)
                    {
                        if(parser.getCurrentName() != parser.getText())
                        {
                            if(parser.getCurrentName() == Constants.HTTP_TEAM_ID)
                            {
                                teamId = parser.getText();
                            }
                        }
                    }
                    
                    if(String.isBlank(teamId)) 
                    {
                        res.setError('please have a value for team_id for the order in the request body');
                        return res;
                    }
                    orders = [SELECT Name,order_id__c,ff_order_name__c,finalize__c,fits__c,
                              is_deleted__c,is_finalized__c,is_submitted__c,team_id__c,
                              created_at__c,modified_at__c,Opportunity__c 
                              FROM Custom_Item__c 
                              WHERE Team_Id__c =: teamId
                              AND Deleted_From_FF__c = false
                             ];   
                    if(orders.size() > 0)
                    {System.debug('in if size more');
                        res.setSuccess('Get All Orders Successful');
                    }
                    else
                    {System.debug('in else size 0');
                        res.setError('No order found.');    
                    }
                    res.orders = getOrderMap(orders);
                }
                
                //5) Get Single Order (POST)
                else if(actionType == FitFreedomUrlMappings.ORDER_AT_GET_ORDER_BY_ID)
                {
                    //system.assert(false, 'hello');
                    wsLog.Operation_Name__c = 'Get Single Order';
                    String orderId = '';
                    while (parser.nextToken() != null)
                    {
                        if(parser.getCurrentName() != parser.getText())
                        {
                            if(parser.getCurrentName() == Constants.HTTP_ORDER_ID)
                            {
                                orderId = parser.getText();
                            }
                        }
                    }
                    
                    if(String.isBlank(orderId)) 
                    {
                        res.setError('please have a value for order_id for the order in the request body');
                        return res;
                    }
                    orders = [SELECT Name,order_id__c,ff_order_name__c,finalize__c,fits__c,
                              is_deleted__c,is_finalized__c,is_submitted__c,team_id__c,
                              created_at__c,modified_at__c ,Opportunity__c
                              FROM Custom_Item__c 
                              WHERE order_id__c =: orderId
                              AND Deleted_From_FF__c = false
                             ];
                    
                    standOrders = [SELECT Name,order_id__c,ff_order_name__c,finalize__c,fits__c,
                                  is_deleted__c,is_finalized__c,is_submitted__c,team_id__c,
                                  created_at__c,modified_at__c ,Opportunity__c
                                  FROM Standardized_Item__c 
                                  WHERE order_id__c =: orderId
                                  AND Deleted_From_FF__c = false
                             ];
                    if(orders.size() > 0)
                    {
                        wsLog.Custom_Item__c = orders[0].Id;
                        res.orders = getOrderMap(orders);
                        res.setSuccess('Get Single Order Successful');
                    }
                    else if(standOrders.size() > 0){
                        wsLog.Standardized_Item__c = standOrders[0].Id;
                        res.orders = getOrderMap(standOrders);
                        res.setSuccess('Get Single Order Successful');
                    }else
                    {
                        res.setError('No order found.');    
                    }
                }
                
                //8) Finalize Order (POST)
                else if(actionType == FitFreedomUrlMappings.ORDER_AT_FINALIZE_ORDER)
                {
                    wsLog.Operation_Name__c = 'Finalize Order';
                    String finalizedorderId = '';
                    while (parser.nextToken() != null)
                    {
                        if(parser.getCurrentName() != parser.getText())
                        {
                            if(parser.getCurrentName() == Constants.HTTP_ORDER_ID)
                            {
                                finalizedorderId = parser.getText();
                            }
                        }
                    }
                    
                    if(String.isBlank(finalizedorderId)) 
                    {
                        res.setError('please have a value for order_id for the order in the request body');
                        return res;
                    }
                    orders = [SELECT Name,order_id__c,ff_order_name__c,finalize__c,fits__c,
                              is_deleted__c,is_finalized__c,is_submitted__c,team_id__c,
                              created_at__c,modified_at__c 
                              FROM Custom_Item__c 
                              WHERE order_id__c =: finalizedorderId
                              AND Deleted_From_FF__c = false
                             ];   
                    
                    standOrders = [SELECT Name,order_id__c,ff_order_name__c,finalize__c,fits__c,
                                  is_deleted__c,is_finalized__c,is_submitted__c,team_id__c,
                                  created_at__c,modified_at__c ,Opportunity__c
                                  FROM Standardized_Item__c 
                                  WHERE order_id__c =: finalizedorderId 
                                  AND Deleted_From_FF__c = false
                             ];
                    if(orders.size() > 0)
                    {
                        orders[0].is_finalized__c = 'true';
                        update orders;
                        wsLog.Custom_Item__c = orders[0].Id;
                        res.setSuccess('Updated');
                        // res.setSuccess('Get Single Order Successful');
                    }
                    else if(standOrders.size() > 0){
                        
                        standOrders[0].is_finalized__c = 'true';
                        update standOrders;
                        wsLog.Standardized_Item__c = standOrders[0].Id;
                        res.setSuccess('Updated');
                    }
                    else
                    {
                        res.setError('No order found.');    
                    }
                }
                
                //3) Submit Order (POST)
                else if(actionType == FitFreedomUrlMappings.ORDER_AT_SUBMIT_ORDER)
                {
                    wsLog.Operation_Name__c = 'Submit Order';
                    String submitOrderId = '';
                    while (parser.nextToken() != null)
                    {
                        if(parser.getCurrentName() != parser.getText())
                        {
                            if(parser.getCurrentName() == Constants.HTTP_ORDER_ID)
                            {
                                submitOrderId = parser.getText();
                            }
                        }
                    }
                    
                    if(String.isBlank(submitOrderId)) 
                    {
                        res.setError('please have a value for order_id for the order in the request body');
                        return res;
                    }
                    orders = [SELECT Name,order_id__c,ff_order_name__c,finalize__c,fits__c,
                              is_deleted__c,is_finalized__c,is_submitted__c,team_id__c,
                              created_at__c,modified_at__c 
                              FROM Custom_Item__c 
                              WHERE order_id__c =: submitOrderId
                              AND Deleted_From_FF__c = false
                             ];   
                    
                    standOrders = [SELECT Name,order_id__c,ff_order_name__c,finalize__c,fits__c,
                                  is_deleted__c,is_finalized__c,is_submitted__c,team_id__c,
                                  created_at__c,modified_at__c ,Opportunity__c
                                  FROM Standardized_Item__c 
                                  WHERE order_id__c =: submitOrderId 
                                  AND Deleted_From_FF__c = false
                             ];
                    if(orders.size() > 0)
                    {
                       
                        orders[0].is_submitted__c = 'true';
                        update orders;
                        wsLog.Custom_Item__c = orders[0].Id;
                        res.setSuccess('Submit Order Successful');
                    }
                    else if(standOrders.size() > 0){
                        
                        standOrders[0].is_submitted__c = 'true';
                        update standOrders;
                        wsLog.Standardized_Item__c = standOrders[0].Id;
                        res.setSuccess('Submit Order Successful');
                    }else
                    {
                        res.setError('No order found.');    
                    }
                }
                
                //7) Add fit to order (POST)
                /*
                 * "{
                        ""order_id"":""8956231359016"",
                        ""fit_id"":""4d8e3ced-f297-4878-853a-aebb677371b3"",
                        ""type"":""add""
                    }"
                */
                else if(actionType == FitFreedomUrlMappings.ORDER_AT_ADD_FIT_TO_ORDER)
                {
                    wsLog.Operation_Name__c = 'Add fit to order';
                    String orderIdParam = '';
                    String fitIdParam = '';
                    String updateTypeParam = '';
                    Sobject sObjOrder = new Custom_Item__c();
                    while (parser.nextToken() != null)
                    {
                        if(parser.getCurrentName() != parser.getText())
                        {
                            if(parser.getCurrentName() == Constants.HTTP_ORDER_ID)
                            {
                                orderIdParam = parser.getText();
                            }
                            
                            if(parser.getCurrentName() == Constants.HTTP_FIT_ID)
                            {
                                fitIdParam = parser.getText();
                            }
                            
                            if(parser.getCurrentName() == 'type')
                            {
                                updateTypeParam = parser.getText();
                            }
                        }
                    }
                    
                    if(String.isBlank(orderIdParam)) 
                    {
                        res.setError('please have a value for order_id for the order in the request body');
                        return res;
                    }
                    
                    if(String.isBlank(fitIdParam)) 
                    {
                        res.setError('please have a value for fit_id for the order in the request body');
                        return res;
                    }
                    
                    if(String.isBlank(updateTypeParam)) 
                    {
                        res.setError('please have a value for type for the order in the request body');
                        return res;
                    }
                    
                    if(updateTypeParam == 'add')
                    {
                        orders = [SELECT Name,order_id__c,ff_order_name__c,finalize__c,fits__c,
                                  is_deleted__c,is_finalized__c,is_submitted__c,team_id__c,
                                  created_at__c,modified_at__c 
                                  FROM Custom_Item__c 
                                  WHERE order_id__c =: orderIdParam
                                  AND Deleted_From_FF__c = false
                                 ];   
                        standOrders = [SELECT Name,order_id__c,ff_order_name__c,finalize__c,fits__c,
                                  is_deleted__c,is_finalized__c,is_submitted__c,team_id__c,
                                  created_at__c,modified_at__c ,Opportunity__c
                                  FROM Standardized_Item__c 
                                  WHERE order_id__c =: orderIdParam
                                  AND Deleted_From_FF__c = false
                             ];
                        List<Fit__c> fits = [SELECT Id FROM Fit__c
                                            WHERE FIT_id__c =: fitIdParam];
                        if(orders.size() > 0)
                        {
                            orders[0].fits__c = fitIdParam;
                            if(fits.size() > 0){
                                orders[0].fit__c = fits[0].Id;
                            }else{
                                res.setError('No Fits found');
                                return res;
                                
                            }
                            update orders;
                            wsLog.Custom_Item__c = orders[0].Id;
                            res.setSuccess('Add fit to order Successful');
                        }
                        else if(standOrders.size() > 0)
                        {
                            standOrders[0].fits__c = fitIdParam;
                            if(fits.size() > 0){
                                standOrders[0].fit__c = fits[0].Id;
                            }else{
                                res.setError('No Fits found');
                                return res;
                                
                            }
                            update standOrders;
                            wsLog.Standardized_Item__c = standOrders[0].Id;
                            res.setSuccess('Add fit to order Successful');
                        }
                        else
                        {
                            res.setError('No order found.');    
                        }
                    }
                    else 
                    {
                        res.setError('Unsupported action type.'); 
                    }    
                }
                
                /*
                 * "{
                        ""order_id"":""895623158956"",
                        ""order_name"":""Test Ayush Opp New "",
                        ""finalize"":""1"",
                        ""fits"":""xyz"",
                        ""is_deleted"":""1"",
                        ""is_finalized"":""1"",
                        ""is_submitted"":""1"",
                        ""team_id"":""895212153"",
                        ""created_at"":"""",
                        ""modified_at"":""""
                }"*/
                //1) Create New Order (POST)
                else if(actionType == FitFreedomUrlMappings.ORDER_AT_CREATE_ORDER)
                {
                    wsLog.Operation_Name__c = 'Create New Order';
                    String order_id_createOrder = '';
                    String team_id_createOrder = '';
                    String old_order_id = '';
                    Sobject sObjOrder = new Custom_Item__c();
                    while (parser.nextToken() != null) 
                    {
                        if(parser.getCurrentName() != parser.getText())
                        {
                            if(FitFreedomMappings.mapOfOrderSQLAndSFDCFields.containskey(parser.getCurrentName()))
                            {
                                if(parser.getCurrentName() == 'order_id')
                                {
                                    order_id_createOrder = parser.getText();
                                } 
                                
                                if(parser.getCurrentName() == 'team_id')
                                {
                                    team_id_createOrder = parser.getText();
                                } 
                                
                                system.debug('get name --'+parser.getCurrentName());
                                if(parser.getCurrentName() == 'old_order_id')
                                {
                                    old_order_id = parser.getText();
                                }
                                sObjOrder.put(FitFreedomMappings.mapOfOrderSQLAndSFDCFields.get(parser.getCurrentName()),parser.getText());
                            }
                        }
                    }
                    System.debug('sobjorder---'+sObjOrder);
                    if(String.isBlank(order_id_createOrder)) 
                    {
                        res.setError('please have a value for order_id for the order in the request body');System.debug('blank orderidcreateorder');
                        return res;
                    }
                    
                    if(String.isBlank(team_id_createOrder)) 
                    {
                        res.setError('please have a value for team_id for the order in the request body');System.debug('blank teamidcreateorder');
                        return res;
                    }
                    
                    if(String.isNotBlank(order_id_createOrder) && String.isNotBlank(old_order_id)) 
                    {
                        orders = [SELECT Id, Deleted_From_FF__c, order_id__c  
                                        FROM Custom_Item__c 
                                        WHERE order_id__c =: old_order_id 
                                        AND Deleted_From_FF__c = false];
                    }   
                    if(orders.size() > 0)
                    {
                        sObjOrder.put('Id', orders[0].id);
                        sObjOrder.put('order_id__c',order_id_createOrder);
                    }
                   
                    Map<String, Id> mapTeams = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Custom_Item__c', 'team_id__c', new Set<String>{(String)sObjOrder.get('team_id__c')});
                    
                    if(mapTeams != null && mapTeams.values().size() > 0) 
                    {
                        sObjOrder.put('Rosters__c', mapTeams.get((String)sObjOrder.get('team_id__c')));
                    }
                    else
                    {
                        res.setError('unable to find a team for the team_id that we have in the request body');
                        return res;
                    }
                    sObjOrder.put('Stated_Quantity__c',5);
                    update sObjOrder;
                    
                   wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
                    wsLog.Custom_Item__c = sObjOrder.Id;
                    res.setSuccess(Constants.HTTP_RESPONSE_CREATED + Constants.CHAR_SPACE + Constants.CHAR_COLON + 
                                   Constants.CHAR_SPACE + 'Order Created Successful');                    
                }
                
                /*
                 * {
                    "order_id":"3cafa2e5-f49c-4b0d-b3f3-fdf8e4ff4d06",
                    "fit": [
                        "2d9c594d-bfc6-4b86-8270-9c36e4832d12"
                        ]
                }*/
                //2) Update Order (POST)
                else if(actionType == FitFreedomUrlMappings.ORDER_AT_UPDATE_ORDER) 
                {
                    wsLog.Operation_Name__c = 'Update Order';
                    String updateOrderId = '';
                    String fits = '';
                    while (parser.nextToken() != null)
                    {
                        if(parser.getCurrentName() != parser.getText())
                        {
                            if(parser.getCurrentName() == Constants.HTTP_ORDER_ID)
                            {
                                updateOrderId = parser.getText();
                            }
                            
                            if(parser.getCurrentName() == 'fit')
                            {
                                fits = parser.getText();
                            }
                        }
                    }
                    
                    if(String.isBlank(updateOrderId)) 
                    {
                        res.setError('please have a value for order_id for the order in the request body');
                        return res;
                    }
                    
                    if(String.isBlank(fits)) 
                    {
                        res.setError('please have a value for fit for the order in the request body');
                        return res;
                    }
                    
                    orders = [SELECT ID, Deleted_From_FF__c, order_id__c 
                              FROM Custom_Item__c 
                              WHERE order_id__c =: updateOrderId
                              AND Deleted_From_FF__c = false
                             ];
                    
                    List<Fit__c> fitsdetail = [SELECT Id FROM Fit__c
                                         WHERE FIT_id__c =: fits];
                    if(orders.size() > 0)
                    {
                        orders[0].fits__c = fits;
                        if(fitsdetail.size() > 0){
                            orders[0].fit__c = fitsdetail[0].Id;
                        }else{
                            res.setError('No Fits found');
                            return res;
                            
                        }
                        update orders;
                        wsLog.Custom_Item__c = orders[0].Id;
                        res.setSuccess('Order has been updated successfully.');
                    }
                    else
                    {
                        res.setError('Unable to find order to update for the mentioned order_id.');
                    }
                }
                
                /*{
                    "order_id":"7d1261a0-d03a-46c7-9e9c-596ced2bb09d"
                }*/
                //6) Delete Single Order (POST)
                else if(actionType == FitFreedomUrlMappings.ORDER_AT_DELETE_ORDER) 
                {
                    wsLog.Operation_Name__c = 'Delete Single Order';
                    String deleteOrderId = '';
                    while (parser.nextToken() != null)
                    {
                        if(parser.getCurrentName() != parser.getText())
                        {
                            if(parser.getCurrentName() == Constants.HTTP_ORDER_ID)
                            {
                                deleteOrderId = parser.getText();
                            }
                        }
                    }
                    
                    if(String.isBlank(deleteOrderId)) 
                    {
                        res.setError('please have a value for order_id for the order in the request body');
                        return res;
                    }
                    
                    orders = [SELECT ID, Deleted_From_FF__c, order_id__c 
                              FROM Custom_Item__c 
                              WHERE order_id__c =: deleteOrderId
                              AND Deleted_From_FF__c = false
                             ];
                    
                    standOrders = [SELECT Name,order_id__c,ff_order_name__c,finalize__c,fits__c,
                                  is_deleted__c,is_finalized__c,is_submitted__c,team_id__c,
                                  created_at__c,modified_at__c ,Opportunity__c
                                  FROM Standardized_Item__c 
                                  WHERE order_id__c =: deleteOrderId
                                  AND Deleted_From_FF__c = false];
                
                    if(orders.size() > 0)
                    {
                        orders[0].Deleted_From_FF__c = true;
                        orders[0].FF_Create_Item_Successful__c = false;
                        update orders;
                        wsLog.Custom_Item__c = orders[0].Id;
                        res.setSuccess('Order has been deleted successfully.');
                    }
                    else if(standOrders.size() > 0){
                        standOrders[0].Deleted_From_FF__c = true;
                        standOrders[0].FF_Create_Item_Successful__c = false;
                        update standOrders;
                        wsLog.Custom_Item__c = standOrders[0].Id;
                        res.setSuccess('Order has been deleted successfully.');
                    }
                    else
                    {
                        res.setError('Unable to find order to delete for the mentioned order_id.');
                    }
                }
                
                /*{
                    "s_id":"6699ebbd-db09-461d-b88e-7902ac5e75d1",
                    "order_id":"adb9e061-e16b-4892-a614-d1b87b93ed79"
                }*/
                //9) Get Order Details (POST)
                else if(actionType == FitFreedomUrlMappings.ORDER_AT_GET_ORDER_DETAILS) 
                {
                    wsLog.Operation_Name__c = 'Get Order Details';
                    String orderExtId = '';
                    String s_id = '';
                    while (parser.nextToken() != null)
                    {
                        if(parser.getCurrentName() != parser.getText())
                        {
                            if(parser.getCurrentName() == Constants.HTTP_ORDER_ID)
                            {
                                orderExtId = parser.getText();
                            }
                            
                            if(parser.getCurrentName() == 's_id')
                            {
                                s_id = parser.getText();
                            }
                        }
                    }
                    
                    if(String.isBlank(orderExtId)) 
                    {
                        res.setError('please have a value for order_id for the order in the request body');
                        return res;
                    }
                    
                    if(String.isBlank(s_id)) 
                    {
                        res.setError('please have a value for s_id for the order in the request body');
                        return res;
                    }
                    orders = [SELECT Name,order_id__c,ff_order_name__c,finalize__c,fits__c,
                              is_deleted__c,is_finalized__c,is_submitted__c,team_id__c,
                              created_at__c,modified_at__c 
                              FROM Custom_Item__c 
                              WHERE (Deleted_From_FF__c = false AND order_id__c =: orderExtId)
                             ];   
                     standOrders = [SELECT Name,order_id__c,ff_order_name__c,finalize__c,fits__c,
                                  is_deleted__c,is_finalized__c,is_submitted__c,team_id__c,
                                  created_at__c,modified_at__c ,Opportunity__c
                                  FROM Standardized_Item__c 
                                  WHERE Deleted_From_FF__c = false AND order_id__c =: orderExtId
                             ];
                    if(orders.size() > 0)
                    {
                       
                        res.orders = getOrderMap(orders);
                        res.setSuccess('Get Orders Successful');
                    }
                    else if(standOrders.size() > 0){
                        
                        res.orders = getOrderMap(standOrders);
                        res.setSuccess('Get Orders Successful');
                    }else
                    {
                        res.setError('No order found.');    
                    }
                   
                }
                else 
                {
                    res.setError('Unsupported action type.'); 
                    wsLog.Operation_Name__c = 'Order POST Requests - Unsupported action type';
                }
            }   
            else 
            {
                res.setError('Please Provide Valid Request Body');
                wsLog.Operation_Name__c = 'Order POST Requests - Blank Body';
            }
        }
        catch(Exception e)
        {
            res.setError(Constants.HTTP_RESPONSE_FAILED + Constants.CHAR_SPACE + Constants.CHAR_COLON 
                         + Constants.CHAR_SPACE + e.getMessage() + e.getLineNumber());
            wsLog.Operation_Name__c = 'Order POST Requests - Exception';
        }
        wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
        insert wsLog;
        return res;
    }
    
    private static List<Map<String, String>> getOrderMap(List<Sobject> orders)
    {
        List<Map<String, String>> lst = new List<Map<String, String>>();
        Map<String, String> mp = FitFreedomMappings.mapOfOrderSQLAndSFDCFields;
        for(Integer i=0; i<orders.size(); i++)
        {
            Map<String, String> sc = new Map<String, String>();
            Sobject acc = orders[i];
            for(String s : mp.keySet())
            {
                sc.put(s, String.valueOf(acc.get(mp.get(s))));
            }
            lst.add(sc);
        }
        return lst;
    }
    
    global class OrderResponseWrapper 
    {
        global List<Map<String, String>> orders {get;set;}
        global  String message {get;set;}
        global  String errorMsg {get;set;}
        global Integer statuscode {get;set;}
        global String status {get;set;}
        
        global OrderResponseWrapper()
        {
            orders = new List<Map<String, String>>();
            status = Constants.HTTP_RESPONSEWRAPPER_STATUS_SUCCESS;
            message = Constants.HTTP_RESPONSEWRAPPER_STATUS_SUCCESS;
            statuscode = 200;
        }
        
        global void setSuccess(String str)
        {
            statuscode = 200;
            message = str;
            status = Constants.HTTP_RESPONSEWRAPPER_STATUS_SUCCESS;
        }
        
        global void setError(String str)
        {
            message = str;
            status = Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL;
            statuscode = 400;
        }
    }
}