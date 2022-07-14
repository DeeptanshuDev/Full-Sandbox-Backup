/**
*   Purpose         :   Class to have rest resources and services for Fit Freedom App.
*   Created By      :   Ayush Gupta
*   Created Date    :   05/15/2020
*   Revision Log    :   v1.0 - Created - 05/15/2020
**/
@RestResource(urlMapping='/fitfreedomv3OrderSize/*')
global class FitFreedomRestServiceOrderSize
{
    @HttpGet
    global static OrderSizeResponseWrapper getOrderSizesFromSFDC() 
    {
        OrderSizeResponseWrapper res = new OrderSizeResponseWrapper();
        RestRequest req = RestContext.request;
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        try
        {
            String actionType = req.requestURI.subStringbetween('/fitfreedomv3OrderSize/', '/');
            List<Order_Sizes__c> orderSizes = new List<Order_Sizes__c>();

            //2) Get Order Sizes (GET)
            if(actionType == FitFreedomUrlMappings.ORDERSIZE_AT_GET_ALL_ORDER_SIZES)
            {
                orderSizes = [SELECT order_size_id__c, order_id__c, member_id__c, active__c, approved_by__c,
                              changed__c, computed_diff__c, deviated__c, measure_id__c, 
                              modified_by__c, order_sizes__c, team_id__c, created_at__c, full_recommended_sizes__c, recommended_sizes__c, 
                              modified_at__c
                              FROM Order_Sizes__c
                              WHERE Deleted_From_FF__c = false
                             ];
                if(orderSizes.size() > 0)
                {
                    res.setSuccess('Get Order Sizes Successful');
                    wsLog.Order_Sizes__c  = orderSizes[0].Id;
                }
                else
                {
                    res.setError('No order size found.');    
                }
            }
            else
            {
                res.setError('No Resource found or unknown action type.');
            }
            res.orderSizes = getOrderSizesMap(orderSizes);
        }
        catch(Exception e)
        {            
            res.setError(Constants.HTTP_RESPONSE_FAILED + Constants.CHAR_SPACE + Constants.CHAR_COLON + 
                Constants.CHAR_SPACE + e.getMessage());
        }
        wsLog.Operation_Name__c = 'Get Order Sizes';
        wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
        insert wsLog;
        return res;
    }
    
    /*
     * "{
        ""order_size_id"":""123-osid-1235"",
        ""order_id"":""123-ordid-123"",
        ""member_id"":""123-memid-123"",
        ""active"":"""",
        ""approved_by"":""123-oppid-123"",
        ""changed"":"""",
        ""computed_diff"":"""",
        ""deviated"":"""",
        ""full_recommended_sizes"":"""",
        ""measure_id"":""123-msid-123"",
        ""modified_by"":""123-mfid-123"",
        ""order_sizes"":"""",
        ""recommended_sizes"":"""",
        ""team_id"":""123-tmid-123"",
        ""created_at"":"""",
        ""modified_at"":""""
    }"*/
    @HttpPost
    global static OrderSizeResponseWrapper createOrderSizeAtSFDC() 
    {
        OrderSizeResponseWrapper res = new OrderSizeResponseWrapper();
        RestRequest req = RestContext.request;
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        try
        {
            Blob body = req.requestBody;
            if(body != null) 
            {
                JSONParser parser = JSON.createParser(body.toString());
                String actionType = req.requestURI.subStringbetween('/fitfreedomv3OrderSize/', '/');
                
                //1) Create and Recomend (POST)
                if(actionType == FitFreedomUrlMappings.ORDERSIZE_AT_CREATE_SINGLE_ORDERSIZE)
                {
                    Sobject sobjOrderSize = new Order_Sizes__c();
                    String orderSizeId = '';
                    String orderId = '';
                    String memberId = '';
                    String measureId = '';
                    String teamId = '';
                    
                    while (parser.nextToken() != null) 
                    {
                        if(parser.getCurrentName() != parser.getText())
                        {       
                            if(FitFreedomMappings.mapOfOrderSizeSQLAndSFDCFields.containskey(parser.getCurrentName()))
                            {
                                if(parser.getCurrentName() == 'order_size_id')
                                {
                                    orderSizeId = parser.getText();
                                }  
                                
                                if(parser.getCurrentName() == 'order_id')
                                {
                                    orderId = parser.getText();
                                }
                                
                                if(parser.getCurrentName() == 'member_id')
                                {
                                    memberId = parser.getText();
                                }
                                
                                if(parser.getCurrentName() == 'measure_id')
                                {
                                    measureId = parser.getText();
                                }
                                
                                if(parser.getCurrentName() == 'team_id')
                                {
                                    teamId = parser.getText();
                                }
                                
                                sobjOrderSize.put(FitFreedomMappings.mapOfOrderSizeSQLAndSFDCFields.get(parser.getCurrentName()), parser.getText());
                            }
                        }
                    }
                    
                    if(String.isBlank(orderSizeId)) 
                    {
                        res.setError('please have a value for order_size_id for the order sizes in the request body');
                        return res;
                    }
                    
                    if(String.isBlank(orderId)) 
                    {
                        res.setError('please have a value for order_id for the order sizes in the request body');
                        return res;
                    }
                    
                    if(String.isBlank(memberId)) 
                    {
                        res.setError('please have a value for member_id for the order sizes in the request body');
                        return res;
                    }
                    
                    if(String.isBlank(measureId)) 
                    {
                        res.setError('please have a value for measure_id for the order sizes in the request body');
                        return res;
                    }
                    
                    if(String.isBlank(teamId)) 
                    {
                        res.setError('please have a value for team_id for the order sizes in the request body');
                        return res;
                    }
                    
                    List<Order_Sizes__c> orderSizes = new List<Order_Sizes__c>();
                    if(String.isNotBlank(orderSizeId)) 
                    {
                        orderSizes = [SELECT Id, Deleted_From_FF__c, order_size_id__c  
                                          FROM Order_Sizes__c 
                                          WHERE order_size_id__c =: orderSizeId 
                                          AND Deleted_From_FF__c = false];
                    }   
                    
                    if(orderSizes.size() > 0)
                    {
                        sobjOrderSize.put('Id', orderSizes[0].id);
                    }
                    
                    List<Standardized_Item__c> std = new List<Standardized_Item__c>();
                    List<Custom_Item__c> cust = new List<Custom_Item__c>();
                    
                    std = [SELECT Id, Order_id__c from Standardized_Item__c WHERE Order_id__c =: orderId];
                    cust = [SELECT Id, Order_id__c from Custom_Item__c WHERE Order_id__c =: orderId];
                    
                    if(std.size() > 0 || cust.size() > 0)
                    {
                        if(std.size() > 0)
                        {
                            List<Standardized_Item__c> standardItems = [SELECT Id,Opportunity__c FROM Standardized_Item__c where Id =: std[0].Id];
                            sobjOrderSize.put('Opportunity__c', standardItems[0].Opportunity__c);
                            sobjOrderSize.put('standard_order__c',std[0].Id);
                        }
                        else
                        {
                            List<Custom_Item__c> customItems = [SELECT Id,Opportunity__c FROM Custom_Item__c where Id =: cust[0].Id];
                            sobjOrderSize.put('Opportunity__c', customItems[0].Opportunity__c);
                            sobjOrderSize.put('Order__c',cust[0].Id);
                        }
                    }
                    else
                    {
                        res.setError('unable to find a Order for the order_id that we have in the request body');
                        return res;
                    }
                    

                    Map<String, Id> mapMemberId = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Order_Sizes__c', 'member_id__c', new Set<String>{(String)sobjOrderSize.get('member_id__c')});
                    
                    if(mapMemberId != null && mapMemberId.values().size() > 0) 
                    {
                        sobjOrderSize.put('Member__c', mapMemberId.get((String)sobjOrderSize.get('member_id__c')));
                    }
                    else
                    {
                        res.setError('unable to find a Member for the memeber_id that we have in the request body');
                        return res;
                    }
                    
                    Map<String, Id> mapTeams = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Order_Sizes__c', 'team_id__c', new Set<String>{(String)sobjOrderSize.get('team_id__c')});
                    
                    if(mapTeams != null && mapTeams.values().size() > 0) 
                    {
                        sobjOrderSize.put('Rosters__c', mapTeams.get((String)sobjOrderSize.get('team_id__c')));
                    }
                    else
                    {
                        res.setError('unable to find a Team  for the team_id that we have in the request body');
                        return res;
                    }
                    
                     Map<String, Id> mapApprovedBy = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Order_Sizes__c', 'approved_by__c', new Set<String>{(String)sobjOrderSize.get('approved_by__c')});
                    
                    if(mapApprovedBy != null && mapApprovedBy.values().size() > 0) 
                    {
                        sobjOrderSize.put('Approved_By_Contact__c', mapApprovedBy.get((String)sobjOrderSize.get('approved_by__c')));
                    }
                   /* else
                    {
                        res.setError('unable to find a Approver for the approved_by that we have in the request body');
                        return res;
                    }*/
                    
                     Map<String, Id> mapMeasurement = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Order_Sizes__c', 'measure_id__c', new Set<String>{(String)sobjOrderSize.get('measure_id__c')});
                    
                    if(mapMeasurement != null && mapMeasurement.values().size() > 0) 
                    {
                        sobjOrderSize.put('Measurement__c', mapMeasurement.get((String)sobjOrderSize.get('measure_id__c')));
                    }
                    else
                    {
                        res.setError('unable to find a Measurement  for the measure_id that we have in the request body');
                        return res;
                    }
                    
                     Map<String, Id> mapModifiedBY = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Order_Sizes__c', 'modified_by__c', new Set<String>{(String)sobjOrderSize.get('modified_by__c')});
                    
                    if(mapModifiedBY != null && mapModifiedBY.values().size() > 0) 
                    {
                        sobjOrderSize.put('Modified_By_Contact__c', mapModifiedBY.get((String)sobjOrderSize.get('modified_by__c')));
                    }
                   
                    
                    upsert sobjOrderSize;
                    wsLog.Order_Sizes__c = sobjOrderSize.Id;
                    
                    res.setSuccess(Constants.HTTP_RESPONSE_CREATED + Constants.CHAR_SPACE + Constants.CHAR_COLON + 
                                   Constants.CHAR_SPACE + 'Order Sizes Created Successful');
                    wsLog.Operation_Name__c = 'Create and Recomend (Order Sizes)';	
                }
                else
                {
                    res.setError('No Resource Found or unsupport action type.');
                }    
            }
            else 
            {
                res.setError('Please Provide Valid Request Body');
            }
        }
        catch(Exception e)
        {
            System.debug('Error '+e.getMessage());
            res.setError(Constants.HTTP_RESPONSE_FAILED + Constants.CHAR_SPACE + Constants.CHAR_COLON + 
                         Constants.CHAR_SPACE + e.getMessage() +e.getLineNumber());
            
            wsLog.Operation_Name__c = 'Order Size POST Requests - Exception';

        }
        
        wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
        insert wsLog;
        return res;
    }
    
    @HttpPut
    global static OrderSizeResponseWrapper updateOrderSizeAtSFDC() 
    {
        OrderSizeResponseWrapper res = new OrderSizeResponseWrapper();
        RestRequest req = RestContext.request;
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        String orderSizesId = req.params.get(Constants.HTTP_HEADER_ID);
                String name ='';
        try{
            
            if(String.isNotBlank(orderSizesId)){
        Blob body = req.requestBody;
            if(body != null) 
            {
                JSONParser parser = JSON.createParser(body.toString());
                String actionType = req.requestURI.subStringbetween('/fitfreedomv3OrderSize/', '/');
                
                //1) Create and Recomend (POST)
                if(actionType == 'updateOrderSize')
                {
                    Sobject sobjOrderSize = new Order_Sizes__c();
                    String orderSizeId = '';
                    String orderId = '';
                    String memberId = '';
                    String measureId = '';
                    String teamId = '';
                    String computedDiff = '';
                    
                    while (parser.nextToken() != null) 
                    {
                        if(parser.getCurrentName() != parser.getText())
                        {       
                            if(FitFreedomMappings.mapOfOrderSizeSQLAndSFDCFields.containskey(parser.getCurrentName()))
                            {
                                if(parser.getCurrentName() == 'order_size_id')
                                {
                                    orderSizeId = parser.getText();
                                }  
                                
                                if(parser.getCurrentName() == 'order_id')
                                {
                                    orderId = parser.getText();
                                }
                                
                                if(parser.getCurrentName() == 'member_id')
                                {
                                    memberId = parser.getText();
                                }
                                
                                if(parser.getCurrentName() == 'measure_id')
                                {
                                    measureId = parser.getText();
                                }
                                
                                if(parser.getCurrentName() == 'team_id')
                                {
                                    teamId = parser.getText();
                                }
                                
                                if(parser.getCurrentName() == 'computed_diff'){
                                    computedDiff = parser.getText();
                                    
                                }
                                sobjOrderSize.put(FitFreedomMappings.mapOfOrderSizeSQLAndSFDCFields.get(parser.getCurrentName()), parser.getText());
                            }
                        }
                    }
                    
                    if(String.isBlank(orderSizeId)) 
                    {
                        res.setError('please have a value for order_size_id for the order sizes in the request body');
                        return res;
                    }
                    
                    if(String.isBlank(orderId)) 
                    {
                        res.setError('please have a value for order_id for the order sizes in the request body');
                        return res;
                    }
                    
                    if(String.isBlank(memberId)) 
                    {
                        res.setError('please have a value for member_id for the order sizes in the request body');
                        return res;
                    }
                    
                    if(String.isBlank(measureId)) 
                    {
                        res.setError('please have a value for measure_id for the order sizes in the request body');
                        return res;
                    }
                    
                    if(String.isBlank(teamId)) 
                    {
                        res.setError('please have a value for team_id for the order sizes in the request body');
                        return res;
                    }
                    
                    List<Order_Sizes__c> orderSizes = new List<Order_Sizes__c>();
                    if(String.isNotBlank(orderSizesId)) 
                    {
                        orderSizes = [SELECT Id, Deleted_From_FF__c, order_size_id__c  
                                          FROM Order_Sizes__c 
                                          WHERE order_size_id__c =: orderSizesId 
                                          AND Deleted_From_FF__c = false];
                    }   
                    
                    if(orderSizes.size() > 0)
                    {
                        sobjOrderSize.put('Id', orderSizes[0].id);
                        sobjOrderSize.put('Order_Overrides__c',true);
                    }
                    else{
                        res.setError('No Order Sizes are found with the given Id');
                    }
                    List<Standardized_Item__c> std = new List<Standardized_Item__c>();
                    List<Custom_Item__c> cust = new List<Custom_Item__c>();
                    
                    std = [SELECT Id, Order_id__c from Standardized_Item__c WHERE Order_id__c =: orderId];
                    cust = [SELECT Id, Order_id__c from Custom_Item__c WHERE Order_id__c =: orderId];
                    
                    if(std.size() > 0 || cust.size() > 0)
                    {
                        if(std.size() > 0)
                        {
                            List<Standardized_Item__c> standardItems = [SELECT Id,Opportunity__c FROM Standardized_Item__c where Id =: std[0].Id];
                            sobjOrderSize.put('Opportunity__c', standardItems[0].Opportunity__c);
                            sobjOrderSize.put('standard_order__c',std[0].Id);
                        }
                        else
                        {
                            List<Custom_Item__c> customItems = [SELECT Id,Opportunity__c FROM Custom_Item__c where Id =: cust[0].Id];
                            sobjOrderSize.put('Opportunity__c', customItems[0].Opportunity__c);
                            sobjOrderSize.put('Order__c',cust[0].Id);
                        }
                    }
                    else
                    {
                        res.setError('unable to find a Order for the order_id that we have in the request body');
                        return res;
                    }
                    

                    Map<String, Id> mapMemberId = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Order_Sizes__c', 'member_id__c', new Set<String>{(String)sobjOrderSize.get('member_id__c')});
                    
                    if(mapMemberId != null && mapMemberId.values().size() > 0) 
                    {
                        sobjOrderSize.put('Member__c', mapMemberId.get((String)sobjOrderSize.get('member_id__c')));
                    }
                    else
                    {
                        res.setError('unable to find a Member for the memeber_id that we have in the request body');
                        return res;
                    }
                    
                    Map<String, Id> mapTeams = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Order_Sizes__c', 'team_id__c', new Set<String>{(String)sobjOrderSize.get('team_id__c')});
                    
                    if(mapTeams != null && mapTeams.values().size() > 0) 
                    {
                        sobjOrderSize.put('Rosters__c', mapTeams.get((String)sobjOrderSize.get('team_id__c')));
                    }
                    else
                    {
                        res.setError('unable to find a Team  for the team_id that we have in the request body');
                        return res;
                    }
                    
                     Map<String, Id> mapApprovedBy = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Order_Sizes__c', 'approved_by__c', new Set<String>{(String)sobjOrderSize.get('approved_by__c')});
                    
                    if(mapApprovedBy != null && mapApprovedBy.values().size() > 0) 
                    {
                        sobjOrderSize.put('Approved_By_Contact__c', mapApprovedBy.get((String)sobjOrderSize.get('approved_by__c')));
                    }
                    /*else
                    {
                        res.setError('unable to find a Approver for the approved_by that we have in the request body');
                        return res;
                    }*/
                    
                     Map<String, Id> mapMeasurement = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Order_Sizes__c', 'measure_id__c', new Set<String>{(String)sobjOrderSize.get('measure_id__c')});
                    
                    if(mapMeasurement != null && mapMeasurement.values().size() > 0) 
                    {
                        sobjOrderSize.put('Measurement__c', mapMeasurement.get((String)sobjOrderSize.get('measure_id__c')));
                    }
                    else
                    {
                        res.setError('unable to find a Measurement  for the measure_id that we have in the request body');
                        return res;
                    }
                    
                     Map<String, Id> mapModifiedBY = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Order_Sizes__c', 'modified_by__c', new Set<String>{(String)sobjOrderSize.get('modified_by__c')});
                    
                    if(mapModifiedBY != null && mapModifiedBY.values().size() > 0) 
                    {
                        sobjOrderSize.put('Modified_By_Contact__c', mapModifiedBY.get((String)sobjOrderSize.get('modified_by__c')));
                    }
                   
                     String str = '';
                    Integer count = 1;
                    if(String.isNotBlank(computedDiff)){
                       
                        JSONParser parserRec = JSON.createParser(computedDiff);
                        while (parserRec.nextToken() != null) 
                        {
                            if(parserRec.getCurrentName() != parserRec.getText())
                            {       
                                
                                if(parserRec.getCurrentName() == 'selected_size')
                                {
                                    sobjOrderSize.put('Recommended_Override__c', parserRec.getText());         
                                }
                                if(parserRec.getCurrentName() == 'edit_size' && count ==1)
                                {
                                         sobjOrderSize.put('Recommended_adjustment1__c', parserRec.getText()); 
                                     count++;
                                }
                                else if(parserRec.getCurrentName() == 'edit_size' && count ==2)
                                {
                                         sobjOrderSize.put('Override_adjustment1__c', parserRec.getText()); 
                                     count++;
                                }
                                else if(parserRec.getCurrentName() == 'edit_size' && count ==3)
                                {
                                        sobjOrderSize.put('Recommended_adjustment2__c', parserRec.getText());  
                                     count++;
                                }
                                else if(parserRec.getCurrentName() == 'edit_size' && count ==4)
                                {
                                     sobjOrderSize.put('Override_adjustment2__c', parserRec.getText());   
                                     count++;
                                }
                            }
                           
                        }
                       
                    }
                    
                    upsert sobjOrderSize;
                    wsLog.Order_Sizes__c = sobjOrderSize.Id;
                    
                    res.setSuccess('Edit' + Constants.CHAR_SPACE + Constants.CHAR_COLON + 
                                   Constants.CHAR_SPACE + 'Order Sizes Updated Successful');
                }
                else
                {
                    res.setError('No Resource Found or unsupport action type.');
                }    
            }
            else 
            {
                res.setError('Please Provide Valid Request Body');
            }
            }else{
                res.setError('Please specify Order sizes id in request params');
            }
        }
        catch(Exception e)
        {
            System.debug('Error '+e.getMessage());
            res.setError(Constants.HTTP_RESPONSE_FAILED + Constants.CHAR_SPACE + Constants.CHAR_COLON + 
                         Constants.CHAR_SPACE + e.getMessage() +e.getLineNumber());
        }
        wsLog.Operation_Name__c = 'Edit and Recomend (Order Sizes)';
        wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
        insert wsLog;
        return res;
    }
    private static List<Map<String, String>> getOrderSizesMap(List<Order_Sizes__c> orderSizes)
    {
        List<Map<String, String>> lst = new List<Map<String, String>>();
        Map<String, String> mp = FitFreedomMappings.mapOfOrderSizeSQLAndSFDCFields;
        for(Integer i=0; i<orderSizes.size(); i++)
        {
            Map<String, String> sc = new Map<String, String>();
            Sobject acc = orderSizes[i];
            for(String s : mp.keySet())
            {
                sc.put(s , String.valueOf(acc.get(mp.get(s))));
            }
            lst.add(sc);
        }
        return lst;
    }
    
    global class OrderSizeResponseWrapper
    {
        global  List<Map<String, String>> orderSizes {get;set;}
        global String status {get;set;}
        global Integer statuscode {get;set;}
        global String message {get;set;}
        
        global OrderSizeResponseWrapper()
        {
            orderSizes = new List<Map<String, String>>();
            statuscode = 200;
            status = Constants.HTTP_RESPONSEWRAPPER_STATUS_SUCCESS;
            message = Constants.HTTP_RESPONSEWRAPPER_STATUS_SUCCESS;
        }
        
        global void setSuccess(String str)
        {
            statuscode = 200;
            message = str;
            status = Constants.HTTP_RESPONSEWRAPPER_STATUS_SUCCESS;
        }
        
        global void setError(String str)
        {
            statuscode = 400;
            message = str;
            status = Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL;
        }
    }
}