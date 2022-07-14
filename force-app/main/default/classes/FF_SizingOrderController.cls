/*
*  Purpose          :   Controller class for fits resizing on a Gym/Account Level. (Add FF Items button)
*
*  Created By       :   Abhinav Sharma
*
*  Created Date     :   05/11/2020
*  
*  Revision Log     :   v1.0 -  Created - 05/11/2020
* 
*/
public with sharing class FF_SizingOrderController 
{
    public String recordId {get; set;}
    public Account account {get;set;}
    public static String accesstoken;
    public String errorMessage {get; set;}
    //public String updateFitRecordId {get; set;}
    public Map<Id, Custom_Item__c> mapOfCustomItems {get; set;}
    public Map<Id, Standardized_Item__c> mapOfStandardItems {get; set;}
    public Integer sizeOfMapCustomItems {get; set;}
    public Integer sizeOfMapStandardItems {get; set;}
    public List<SizingOrderCustomWrapperCls> sizingOrderCustomItemsWrapper {get;set;}
    public List<SizingOrderStandardWrapperCls> sizingOrderStandardItemsWrapper {get;set;}
    
    public FF_SizingOrderController(ApexPages.StandardController controller) 
    { 
        System.Debug('!!!!!!!!!!!!!!!!!!!!!!! Constructor Start');
        this.recordId = ApexPages.currentPage().getParameters().get('Id');
        List<Account> accounts = new List<Account>();
        accounts = [SELECT Id , Name , gym_id__c , FF_Create_Gym_Successful__c 
                    FROM Account 
                    WHERE Id =:recordId];
        
        if(accounts.size() > 0) 
        {
            account = accounts[0];
            
            Boolean hasCustomPermission = FeatureManagement.checkPermission('Fit_Freedom_User');
            if (!hasCustomPermission) 
            {
                errorMessage = 'You do not have the suffiecient permissions to access this page. Please reach out to admin for more details.';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
            }
            
            else if(String.isBlank(account.gym_id__c) && !account.FF_Create_Gym_Successful__c)
            {
                errorMessage = 'Please create an account first for the orders/items on the Fit Freedom Side.';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
            }
            else
            {
                List<Opportunity> opportunities = [SELECT Id, Opportunity_Auto_Number__c
                                                   FROM Opportunity 
                                                   WHERE AccountId =: recordId 
                                                   AND StageName = 'Open' 
                                                   ORDER BY Name ASC];
                if(opportunities.size()>0)
                {
                    this.errorMessage = '';
                    this.mapOfCustomItems = new Map<Id , Custom_Item__c>([SELECT Id , Name , Opportunity__c , 
                                                                          Opportunity__r.Opportunity_Auto_Number__c , 
                                                                          Stage__c , Gender__c , Fit__c,Fit__r.fit_id__c,Fit__r.Name , Quantity__c , 
                                                                          Category__c , Style__c , Price__c ,Opportunity__r.team_id__c, Rosters__r.rosters_id__c,
                                                                          Item_Number_Edit__c,Additional_Description__c,Rosters__c, Opportunity_Number__c,FF_Create_Item_Successful__c
                                                                          FROM Custom_Item__c 
                                                                          WHERE Opportunity__c IN: opportunities 
                                                                          AND Fit__c != null
                                                                          AND Stage__c !=: Constants.CUSTOM_ITEM_STAGE_GREY_OUT
                                                                          AND FF_Create_Item_Successful__c = false
                                                                          AND Design_Status__c != '(S) Hold - Not Ready for Designer Assignment'  
                                                                          AND Design_Status__c != '(S) Waiting for Designer Assignment'  
                                                                          AND Design_Status__c != 'Initial Art in Process'  
                                                                          AND Design_Status__c != '(D) In Pricing'  
                                                                          AND Design_Status__c != '(D) Initial Art Completed and Sent'  
                                                                          AND Design_Status__c != '(S) Revision Comments Sent, Waiting for Revised Art'  
                                                                          AND Design_Status__c != '(D) Revision 1 Complete'  
                                                                          AND Design_Status__c != '(D) Revision 2 Complete'  
                                                                          AND Design_Status__c != '(D) Revision 3 Complete'  
                                                                          AND Design_Status__c != '(D) Revision 4 Complete'  
                                                                          AND Design_Status__c != 'Confirmed to Send'  
                                                                          AND Design_Status__c != 'Art Approval Sent'  
                                                                          AND Design_Status__c != '(S) Art Approval Audit - Needs Changes'
                                                                          ORDER BY Opportunity__r.Opportunity_Auto_Number__c,Name ASC]);
                    
                    
                    this.sizeOfMapCustomItems = this.mapOfCustomItems.size();
                    System.debug('sizeOfMapCustomItems = ' + sizeOfMapCustomItems);
                    
                    this.mapOfStandardItems = new Map<Id , Standardized_Item__c>([SELECT Id , Name, Style__c , Opportunity__c , 
                                                                                  Opportunity__r.Opportunity_Auto_Number__c, Stage__c , Fit__c , 
                                                                                  List_Price__c,Opportunity__r.team_id__c , 
                                                                                  Quantity__c ,Rosters__c,Fit__r.fit_id__c,Fit__r.Name, 
                                                                                  Total_Price__c , Total_Price_per_Item__c,
                                                                                  FF_Create_Item_Successful__c,Rosters__r.rosters_id__c
                                                                                  FROM Standardized_Item__c 
                                                                                  WHERE Opportunity__c IN: opportunities 
                                                                                  AND Fit__c != null
                                                                                  AND Stage__c !=: Constants.STANDARDIZED_ITEM_STAGE_GREY_OUT
                                                                                  AND FF_Create_Item_Successful__c = false
                                                                                  ORDER BY Opportunity__r.Opportunity_Auto_Number__c,Name ASC]);
                    
                    this.sizeOfMapStandardItems = this.mapOfStandardItems.size();
                    System.debug('sizeOfMapStandardItems = ' + sizeOfMapStandardItems);
                    
                    initialize();
                    
                    this.sizingOrderCustomItemsWrapper = new List<SizingOrderCustomWrapperCls>();
                    this.sizingOrderStandardItemsWrapper = new List<SizingOrderStandardWrapperCls>();
                    
                    //Add Custom items
                    for(Custom_Item__c cI : this.mapOfCustomItems.values())
                    {
                        this.sizingOrderCustomItemsWrapper.add(new SizingOrderCustomWrapperCls(cI));
                    }
                    
                    //Add Standard items
                    for(Standardized_Item__c sI : this.mapOfStandardItems.values())
                    {
                        this.sizingOrderStandardItemsWrapper.add(new SizingOrderStandardWrapperCls(sI));
                    }
                }
                else
                {
                    this.errorMessage = System.Label.FF_SizingOrder_No_Opportunity_Error;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
                }
            }
        }
        else 
        {
            errorMessage = 'Unable to retrieve account details.';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
        }
        
        System.Debug('!!!!!!!!!!!!!!!!!!!!!!! Constructor End');
    }
    public void initialize() 
    {
        
        sizingOrderCustomItemsWrapper = new List<SizingOrderCustomWrapperCls>();
        sizingOrderStandardItemsWrapper = new List<SizingOrderStandardWrapperCls>();
    }
    // @description :   Method use to nevigate Visual Force page to Detail Page.
    public pagereference backMethod()
    {
        
        Pagereference pg =  new Pagereference('/'+this.recordId); 
        pg.setRedirect(true);
        return pg;
    }
    
    
    
    
    
    // @description :   Method use to update Custom And Standard Items records.
    public pagereference updateCustomAndStandardItemsRecord()
    {
        try{
            
            //This wrapper class hold gym response
            OrderResponseWrapper orderResponse = new OrderResponseWrapper();
            
            List<Custom_Item__c> updatedCustomItems = new List<Custom_Item__c>();
            List<Standardized_Item__c> updatedStandardizedItems = new List<Standardized_Item__c>();
            
            //String to hold key value (Combination of Opportunity id and Fit Id)
            String key = '';
            
            //Map to hold order fits records
            Map<String , Order_Fit__c> mapOfOrderFits = new Map<String , Order_Fit__c>();
            List<OrderFitsRelatedDetails> orderFitDetails = new List<OrderFitsRelatedDetails>();
            List<Order_Fit__c> orderFitToBeInsert = new List<order_Fit__c>();
            
            //List to hold the Custom Items and StandardItems 
            set<String> setCustomItemId = new set<String>();
            set<String> setStandardItemId = new set<String>();
            
            List<Custom_Item__c> customItems = new List<Custom_Item__c>();
            List<Standardized_Item__c> standardizedItems = new List<Standardized_Item__c>();
            Map<Id,String> mapOfCustomItemIdWithRosterId = new Map<Id,String>();            
            Map<Id,String> mapOfStandardItemIdWithRosterId = new Map<Id,String>();
            List<Custom_Item__c> customItemsToBeUpdate = new List<Custom_Item__c>();
            List<Standardized_Item__c> standardizedItemsToBeUpdate = new List<Standardized_Item__c>();
            
            List<Custom_Item__c> ci = new List<Custom_Item__c>();
            for(SizingOrderCustomWrapperCls customItemWrapper : sizingOrderCustomItemsWrapper)
            {
                if(customItemWrapper.isSelected)
                {
                    if(String.isBlank(customItemWrapper.customItem.Rosters__c))
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,System.Label.FF_SizingOrder_Cust_And_Stand_Items_Related_Error));
                        return null;
                    }
                    ci.add(customItemWrapper.customItem);
                    setCustomItemId.add(customItemWrapper.customItem.Id);
                    mapOfCustomItemIdWithRosterId.put(customItemWrapper.customItem.Id, customItemWrapper.customItem.Rosters__c);
                }
            }
            
            for(SizingOrderStandardWrapperCls standardItemWrapper : sizingOrderStandardItemsWrapper)
            {
                if(standardItemWrapper.isSelected)
                {
                    if(String.isBlank(standardItemWrapper.standardItem.Rosters__c))
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,System.Label.FF_SizingOrder_Cust_And_Stand_Items_Related_Error));
                        return null;
                    }
                    
                    setStandardItemId.add(standardItemWrapper.standardItem.Id);
                    mapOfCustomItemIdWithRosterId.put(standardItemWrapper.standardItem.Id, standardItemWrapper.standardItem.Rosters__c);
                }
            }
            
            //Returning if nothing is selected
            if( (setStandardItemId.size() + setCustomItemId.size()) <= 0)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please select atleast one custom/Standard Item.'));
                return null;
            }
            
            for(Rosters__c ros : [SELECT Id, Rosters_id__c FROM Rosters__c WHERE Id IN: mapOfCustomItemIdWithRosterId.values()]){
                mapOfStandardItemIdWithRosterId.put(ros.Id, ros.rosters_id__c);
            }
            
            customItems = [SELECT Id,Opportunity__r.account.team_id__c,ff_order_name__c,Additional_Description__c,Opportunity__r.Opportunity_Auto_Number__c,Name,Item_Number_Edit__c,Rosters__r.rosters_id__c 
                           FROM Custom_Item__c 
                           WHERE Id IN: setCustomItemId];
            
            standardizedItems = [SELECT Id,Opportunity__r.account.team_id__c,Item_Name__c,Opportunity__r.Opportunity_Auto_Number__c ,Name,team_id__c,Rosters__r.rosters_id__c
                                 FROM Standardized_Item__c 
                                 WHERE Id IN: setStandardItemId];
            
             accesstoken = Constants.HTTP_BEARER + Constants.CHAR_SPACE + FF_GetAccessToken.getAccessToken();
            //service.setHeaderParameter(Constants.HTTP_AUTHORIZATION, accessToken);
           
            HttpCalloutService service;
            HttpRequest request;
            HTTPResponse response;
            service = new HTTPCalloutService('FF3_0_Create_Order');
            service.setHeaderParameter(Constants.HTTP_AUTHORIZATION, accessToken);
            
            String body = '';
            List<Web_Service_Log__c> listOfWebServiceLogs = new List<Web_Service_Log__c>();
            
            if(ci.size() > 0){
                
               
                for(Custom_Item__c cItem : ci){
                  
                    Custom_Item__c cIt = new Custom_Item__c();
                   
                    body = '{"order_name":"'+cItem.Opportunity__r.Opportunity_Auto_Number__c+'-'+cItem.Item_Number_Edit__c+'-'+cItem.Name+'", "team_id":"'+mapOfStandardItemIdWithRosterId.get(mapOfCustomItemIdWithRosterId.get(cItem.Id))+'", "additional_description":"'+cItem.Additional_Description__c+'"}';
                    
                    service.setRequestBody(body);
                   request = service.getRequest();
                    if(Test.isRunningTest())
                    {
                        response = new HttpResponse();
                        response.setStatusCode(200);
                        response.setHeader('Content-Type', 'text/json');
                        response.setBody('{"order_id":"713754df-a880-49c0-975f-76ab7620b772","is_deleted":"true","is_finalized":"false","fits":"null","order_name":"0061047-2014936-All Star Couture  Girls Full-length Top","team_id":"42915cd7-e66b-4a57-a78f-bdaf79ba7983","modified_at":"2020-07-31T06:44:26.969Z","createdAt":"2020-07-31T06:44:26.969Z"}');
                        
                    }else{
                        
                        response = service.sendRequest(request);
                    }
                    if(response != null && response.getStatusCode() == 200 && String.isNotBlank(response.getBody()))
                    {
                        String str = String.valueOf(response.getBody());
                        str = str.substring(1, str.length()-1);
                        if(str != 'This order already exists')
                        {
                            orderResponse = parse(response.getBody());
                            String teamId = response.getBody().subStringbetween('"' , '"');
                            
                            cIt.Id = cItem.Id;
                            cIt.order_id__c = orderResponse.order_id;
                            cIt.Is_deleted__c = orderResponse.is_deleted;
                            cIt.is_finalized__c = orderResponse.is_finalized;
                            cIt.is_submitted__c = orderResponse.is_submitted;
                            cIt.created_at__c = orderResponse.created_at;
                            cIt.ff_order_name__c = orderResponse.order_name;
                            cIt.team_id__c = orderResponse.team_id;     
                            cIt.modified_at__c = orderResponse.modified_at;
                            cIt.Fit__c = cItem.Fit__c;
                            cIt.Deleted_From_FF__c = false;
                             System.debug('fit = ' + cItem.Fit__c);
                            customItemsToBeUpdate.add(cIt);
                        }
                    }
                    else
                    {
                        cIt.Id = cItem.Id;
                        cIt.FF_Error_Message__c = String.valueOf(response);
                        customItemsToBeUpdate.add(cIt);
                    }
                    system.debug(customItemsToBeUpdate);
                    Web_Service_Log__c wLog = webServiceLogs.populateCalloutLog(request, response, 'Create new Order');
                    wLog.Custom_Item__c = cItem.Id;
                    listOfWebServiceLogs.add(wLog);
                }
            }
            
            if(standardizedItems.size() > 0){
                
                for(Standardized_Item__c sItem : standardizedItems){
                    
                    Standardized_Item__c sIt = new Standardized_Item__c();
                    
                    body = '{"order_name":"'+sItem.Opportunity__r.Opportunity_Auto_Number__c+'-'+sItem.Name+'", "team_id":"'+mapOfStandardItemIdWithRosterId.get(mapOfCustomItemIdWithRosterId.get(sItem.Id))+'", "additional_description":""}';
                   
                    service.setRequestBody(body);
                    request = service.getRequest();
                     if(Test.isRunningTest())
                    {
                        response = new HttpResponse();
                        response.setStatusCode(200);
                        response.setHeader('Content-Type', 'text/json');
                        response.setBody('{"order_id":"713754df-a880-49c0-975f-76ab7620b772","is_deleted":"true","is_finalized":"false","fits":"null","order_name":"0061047-2014936-All Star Couture  Girls Full-length Top","team_id":"42915cd7-e66b-4a57-a78f-bdaf79ba7983","modified_at":"2020-07-31T06:44:26.969Z","createdAt":"2020-07-31T06:44:26.969Z"}');
                        
                    }else{
                        
                        response = service.sendRequest(request);
                    }
                    if(response != null && response.getStatusCode() == 200 && String.isNotBlank(response.getBody()))
                    {
                        String str = String.valueOf(response.getBody());
                        str = str.substring(1, str.length()-1);
                        if(str != 'This order already exists'){
                            
                            orderResponse = parse(response.getBody());
                            String teamId = response.getBody().subStringbetween('"' , '"');
                            
                            sIt.Id = sItem.Id;
                            sIt.order_id__c = orderResponse.order_id;
                            sIt.Is_deleted__c = orderResponse.is_deleted;
                            sIt.is_finalized__c = orderResponse.is_finalized;
                            sIt.is_submitted__c = orderResponse.is_submitted;
                            sIt.created_at__c = orderResponse.created_at;
                            sIt.Item_Name__c = orderResponse.order_name;
                            sIt.team_id__c = orderResponse.team_id;
                            sIt.modified_at__c = orderResponse.modified_at;
                            sIt.Deleted_From_FF__c = false;
                            standardizedItemsToBeUpdate.add(sIt);
                        }
                    }
                    else
                    {
                        sIt.Id = sItem.Id;
                        sIt.FF_Error_Message__c = String.valueOf(response);
                        standardizedItemsToBeUpdate.add(sIt);
                    }
                    Web_Service_Log__c wLog = webServiceLogs.populateCalloutLog(request, response, 'Create a new Order');
                    wLog.Standardized_Item__c = sItem.Id;
                    listOfWebServiceLogs.add(wLog);
                }
            }
            
            if(customItemsToBeUpdate.size() > 0){
                Util.BypassAllTriggers = true;
                update customItemsToBeUpdate;
                Util.BypassAllTriggers = false;
            }
            
            if(standardizedItemsToBeUpdate.size() > 0){
                Util.BypassAllTriggers = true;
                update standardizedItemsToBeUpdate;
                Util.BypassAllTriggers = false;
            }
            for(SizingOrderCustomWrapperCls customItemWrapper : sizingOrderCustomItemsWrapper)
            {
                
                if(customItemWrapper.isSelected)
                {
                    
                    if(String.isNotBlank(customItemWrapper.customItem.Rosters__c))
                    {
                        key = customItemWrapper.customItem.Opportunity__c+'-'+customItemWrapper.customItem.Fit__c;
                        //Update Custom Items
                        updatedCustomItems.add(new Custom_Item__c(Id = customItemWrapper.customItem.Id,FF_Create_Item_Successful__c = true,Rosters__c = customItemWrapper.customItem.Rosters__c,fits__c = customItemWrapper.customItem.Fit__r.fit_id__c , FF_Reorder_Sizing__c = true)); // Fit__c = customItemWrapper.customItem.Fit__c,
                        //Add order fits values
                        if(!mapOfOrderFits.containskey(key)){
                            mapOfOrderFits.put(key , new Order_Fit__c(Item_Name__c = customItemWrapper.customItem.Item_Number_Edit__c +'-'+customItemWrapper.customItem.Name
                                                                      ,fit_id__c = customItemWrapper.customItem.Fit__r.Fit_id__c,order_id__c = customItemWrapper.customItem.Rosters__r.rosters_id__c,Rosters__c = customItemWrapper.customItem.Rosters__c , Fit__c = customItemWrapper.customItem.Fit__c , custom_item_numbers__c = customItemWrapper.customItem.Item_Number_Edit__c, standard_items_number__c = ''));
                            
                        }else{
                            mapOfOrderFits.put(key , new Order_Fit__c(Item_Name__c = customItemWrapper.customItem.Item_Number_Edit__c +'-'+customItemWrapper.customItem.Name
                                                                      ,order_id__c = customItemWrapper.customItem.Rosters__r.rosters_id__c,
                                                                      fit_id__c = customItemWrapper.customItem.Fit__r.Fit_id__c,Rosters__c = customItemWrapper.customItem.Rosters__c , Fit__c = customItemWrapper.customItem.Fit__c , custom_item_numbers__c = mapOfOrderFits.get(key).custom_item_numbers__c+','+customItemWrapper.customItem.Item_Number_Edit__c , standard_items_number__c = ''));
                        } 
                    }
                }
            }
            //Traverse Standard items
            for(SizingOrderStandardWrapperCls standardItemWrapper : sizingOrderStandardItemsWrapper)
            {
                if(standardItemWrapper.isSelected)
                {
                    
                    if(String.isNotBlank(standardItemWrapper.standardItem.Rosters__c))
                    {
                        
                        key = standardItemWrapper.standardItem.Opportunity__c+'-'+standardItemWrapper.standardItem.Fit__c;
                        
                        //Update Standard Items
                        updatedStandardizedItems.add(new Standardized_Item__c(Id = standardItemWrapper.standardItem.Id ,FF_Create_Item_Successful__c = true, Fit__c = standardItemWrapper.standardItem.Fit__c, Rosters__c = standardItemWrapper.standardItem.Rosters__c));
                        
                        //Add order fits values
                        if(!mapOfOrderFits.containskey(key)){
                            mapOfOrderFits.put(key , new Order_Fit__c(Item_Name__c =standardItemWrapper.standardItem.Name
                                                                      ,order_id__c = standardItemWrapper.standardItem.Rosters__r.rosters_id__c,fit_id__c = standardItemWrapper.standardItem.Fit__r.Fit_id__c,Rosters__c = standardItemWrapper.standardItem.Rosters__c , Fit__c = standardItemWrapper.standardItem.Fit__c , standard_items_number__c = standardItemWrapper.standardItem.Name , custom_item_numbers__c = ''));
                        }
                        else{
                            mapOfOrderFits.put(key , new Order_Fit__c(Item_Name__c = standardItemWrapper.standardItem.Name
                                                                      ,Rosters__c = standardItemWrapper.standardItem.Rosters__c ,
                                                                      order_id__c = standardItemWrapper.standardItem.Rosters__r.rosters_id__c,
                                                                      fit_id__c = standardItemWrapper.standardItem.Fit__r.Fit_id__c,
                                                                      Fit__c = standardItemWrapper.standardItem.Fit__c , standard_items_number__c = mapOfOrderFits.get(key).standard_items_number__c+','+standardItemWrapper.standardItem.Name , custom_item_numbers__c = mapOfOrderFits.get(key).custom_item_numbers__c));
                        }
                    }
                }
            }
            
            
            
            //Fill Wrapper to hold Order Fit related Details
            if(mapOfOrderFits.size() >0)
            {
                
                for(Order_Fit__c oFit : mapOfOrderFits.values()){
                    
                    orderFitToBeInsert.add(new order_fit__c(Item_Name__c = oFit.Name,Rosters__c = oFit.Rosters__c,order_id__c = oFit.Order_id__c, Fit__c = oFit.Fit__c,fit_id__c = oFIt.Fit_id__c,standard_items_number__c = oFit.standard_items_number__c,custom_item_numbers__c = oFit.custom_item_numbers__c));
                    orderFitDetails.add(new OrderFitsRelatedDetails(oFit.Order__c , oFit.Fit__c , oFit.custom_item_numbers__c , oFit.standard_items_number__c.removeStartIgnoreCase(',')));
                }
            }
            
            
                system.debug('in update '+updatedCustomItems);
                if(updatedCustomItems.size()> 0)
                {
                    Util.BypassAllTriggers = true;
                    update updatedCustomItems;
                    Util.BypassAllTriggers = false;
                }
                if(updatedStandardizedItems.size()> 0)
                {
                    Util.BypassAllTriggers = true;
                    update updatedStandardizedItems;
                    Util.BypassAllTriggers = false;
                }    
                
                if(orderFitToBeInsert.size() > 0){
                    Util.BypassAllTriggers = true;
                    insert orderFitToBeInsert;
                    Util.BypassAllTriggers = false;
                }
                
                if(listOfWebServiceLogs.size() >0)
                {
                    Util.BypassAllTriggers = true;
                    insert listOfWebServiceLogs;
                    Util.BypassAllTriggers = false;
                }
                
                FF_SizingOrderController.invokeAddFitToOrderCallout(new List<String>(setCustomItemId), new List<String>(setStandardItemId),accesstoken);
              
                //Nevigate to Detail Page Record
                Pagereference pg =  backMethod(); 
                return pg;
            
        }
        catch(exception ex){
           
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, ex.getMessage() + ex.getLineNumber()));
        }
        return null;
    }
    
    @future(callout=true)
    private static void invokeAddFitToOrderCallout(List<string> customItemIds, List<string> standardItemIds,string accesstoken) 
    {
        List<Custom_Item__c> cItemsToUpdate = new List<Custom_Item__c>();
        List<Standardized_Item__c> sItemsToUpdate = new List<Standardized_Item__c>();
        List<Custom_Item__c> customItemDetails = [SELECT Id,order_id__c,ff_order_name__c,Name,fit__r.fit_id__c 
                                                  FROM Custom_Item__c 
                                                  WHERE Id IN: customItemIds];
        
        List<Standardized_Item__c>  standardizedItemDetails = [SELECT Id,order_id__c,Item_Name__c,fit__r.fit_id__c 
                                                               FROM Standardized_Item__c 
                                                               WHERE Id IN: standardItemIds];  
        
        
        HttpCalloutService serviceAddFitToOrder;
        HttpRequest requestAddFitToOrder;
        HTTPResponse responseAddFitToOrder;
        
        serviceAddFitToOrder = new HTTPCalloutService('FF3_0_Add_Fit_To_Order');
        serviceAddFitToOrder.setHeaderParameter(Constants.HTTP_AUTHORIZATION, accessToken);
        
        String body = '';
        List<Web_Service_Log__c> listOfWebServiceLogs = new List<Web_Service_Log__c>();
        for(Custom_Item__c cc : customItemDetails)
        {
            body = '{"order_id":"'+cc.order_id__c+'", "fit_id":"'+ cc.fit__r.fit_id__c+ '" , "type":"add"}';
            
            serviceAddFitToOrder.setRequestBody(body);
            requestAddFitToOrder = serviceAddFitToOrder.getRequest();
            
            if(Test.isRunningTest())
            {
                responseAddFitToOrder = new HttpResponse();
                responseAddFitToOrder.setStatusCode(200);
            }
            else
            {
                
                responseAddFitToOrder = serviceAddFitToOrder.sendRequest(requestAddFitToOrder);
                
                if(responseAddFitToOrder != null && responseAddFitToOrder.getStatusCode() != 200)
                {
                    cItemsToUpdate.add(new Custom_Item__c(Id = cc.Id, FF_Error_Message__c = String.valueOf(responseAddFitToOrder)));
                }
            }
            
            
            Web_Service_Log__c wLog = webServiceLogs.populateCalloutLog(requestAddFitToOrder, responseAddFitToOrder, 'Add Fit to Order');
            wLog.Custom_Item__c = cc.Id;
            listOfWebServiceLogs.add(wLog);
        }
        
        for(Standardized_Item__c cc : standardizedItemDetails)
        {
            body = '{"order_id":"'+cc.order_id__c+'", "fit_id":"'+ cc.fit__r.fit_id__c+ '" , "type":"add"}';
            serviceAddFitToOrder.setRequestBody(body);
            requestAddFitToOrder = serviceAddFitToOrder.getRequest();
            if(Test.isRunningTest())
            {
                responseAddFitToOrder = new HttpResponse();
                responseAddFitToOrder.setStatusCode(200);
            }
            else
            {
                responseAddFitToOrder = serviceAddFitToOrder.sendRequest(requestAddFitToOrder);
                
                if(responseAddFitToOrder != null && responseAddFitToOrder.getStatusCode() != 200)
                {
                    sItemsToUpdate.add(new Standardized_Item__c(Id = cc.Id, FF_Error_Message__c = String.valueOf(responseAddFitToOrder)));
                }
            }
            
            
            Web_Service_Log__c wLog = webServiceLogs.populateCalloutLog(requestAddFitToOrder, responseAddFitToOrder, 'Add Fit to Order');
            wLog.Standardized_Item__c = cc.Id;
            listOfWebServiceLogs.add(wLog);
        }
        
        HttpCalloutService serviceFinalizeOrder;
        HttpRequest requestFinalizeOrder;
        HTTPResponse responseFinalizeOrder;
        
        serviceFinalizeOrder = new HTTPCalloutService('FF3_0_Finalize_Order');
        serviceFinalizeOrder.setHeaderParameter(Constants.HTTP_AUTHORIZATION, accessToken);
        
        for(Custom_Item__c cc : customItemDetails){
            
            body = '{"order_id":"'+cc.order_id__c+'"}';
            serviceFinalizeOrder.setRequestBody(body);
            requestFinalizeOrder = serviceFinalizeOrder.getRequest();
            
            if(Test.isRunningTest())
            {
                responseFinalizeOrder = new HttpResponse();
                responseFinalizeOrder.setStatusCode(200);
            }
            else
            {
                
                responseFinalizeOrder = serviceFinalizeOrder.sendRequest(requestFinalizeOrder);
                
                if(responseFinalizeOrder != null && responseFinalizeOrder.getStatusCode() != 200)
                {
                    if(cItemsToUpdate.size() > 0)
                    {
                        Boolean isNotAlreadyAdded = true;
                        for(Custom_Item__c c : cItemsToUpdate)
                        {
                            if(c.Id == cc.Id)
                            {
                                c.FF_Error_Message__c = String.valueOf(responseFinalizeOrder);
                                isNotAlreadyAdded = false;
                                break;
                            }
                        }
                        if(isNotAlreadyAdded)
                        {
                            cItemsToUpdate.add(new Custom_Item__c(Id = cc.Id, FF_Error_Message__c = String.valueOf(responseFinalizeOrder)));
                        }
                    }
                    else
                    {
                        cItemsToUpdate.add(new Custom_Item__c(Id = cc.Id, FF_Error_Message__c = String.valueOf(responseFinalizeOrder)));
                    }
                }
                
            } 
            
            Web_Service_Log__c wLog = webServiceLogs.populateCalloutLog(requestFinalizeOrder, responseFinalizeOrder, 'Finalize Order');
            wLog.Custom_Item__c = cc.Id;
            listOfWebServiceLogs.add(wLog);
        }
        
        for(Standardized_Item__c cc : standardizedItemDetails){
            
            body = '{"order_id":"'+cc.order_id__c+'"}';
            serviceFinalizeOrder.setRequestBody(body);
            requestFinalizeOrder = serviceFinalizeOrder.getRequest();
            if(Test.isRunningTest())
            {
                responseFinalizeOrder = new HttpResponse();
                responseFinalizeOrder.setStatusCode(200);
            }
            else
            {
                
                responseFinalizeOrder = serviceFinalizeOrder.sendRequest(requestFinalizeOrder);
                
                if(responseFinalizeOrder != null && responseFinalizeOrder.getStatusCode() != 200)
                {
                    if(sItemsToUpdate.size() > 0)
                    {
                        Boolean isNotAlreadyAdded = true;
                        for(Standardized_Item__c c : sItemsToUpdate)
                        {
                            if(c.Id == cc.Id)
                            {
                                c.FF_Error_Message__c = String.valueOf(responseFinalizeOrder);
                                isNotAlreadyAdded = false;
                                break;
                            }
                        }
                        if(isNotAlreadyAdded)
                        {
                            sItemsToUpdate.add(new Standardized_Item__c(Id = cc.Id, FF_Error_Message__c = String.valueOf(responseFinalizeOrder)));
                        }
                    }
                    else
                    {
                        sItemsToUpdate.add(new Standardized_Item__c(Id = cc.Id, FF_Error_Message__c = String.valueOf(responseFinalizeOrder)));
                    }
                }
            } 
            
            Web_Service_Log__c wLog = webServiceLogs.populateCalloutLog(requestFinalizeOrder, responseFinalizeOrder, 'Finalize Order');
            wLog.Standardized_Item__c = cc.Id;
            listOfWebServiceLogs.add(wLog);
        }
        
        
        if(listOfWebServiceLogs.size() >0)
        {
            Util.BypassAllTriggers = true;
            insert listOfWebServiceLogs;
            Util.BypassAllTriggers = false;
        }
        
        if(cItemsToUpdate.size() >0)
        {
            Util.BypassAllTriggers = true;
            update cItemsToUpdate;
            Util.BypassAllTriggers = false;
        }
        
        if(sItemsToUpdate.size() >0)
        {
            Util.BypassAllTriggers = true;
            update sItemsToUpdate;
            Util.BypassAllTriggers = false;
        }
        
    }
    //This wrapper class hold custom object details
    public class SizingOrderCustomWrapperCls 
    {
        public Boolean isSelected {get;set;}
        public Custom_Item__c customItem {get;set;}
        
        public SizingOrderCustomWrapperCls(Custom_Item__c customItem)
        {
            this.customItem = customItem;
            this.isSelected = false;
        }
    }
    
    //This wrapper class hold Standard object details
    public class SizingOrderStandardWrapperCls 
    {
        public Boolean isSelected {get;set;}
        public Standardized_Item__c standardItem {get;set;}
        
        public SizingOrderStandardWrapperCls(Standardized_Item__c standardItem)
        {
            this.standardItem = standardItem;
            this.isSelected = false;
        }
    }
    
    //This wrapper class hold Order fit details
    public class OrderFitsRelatedDetails 
    {
        public Id opportunityId {get;set;}
        public Id fitId {get;set;}
        public String custom_item_number {get;set;}
        public String standard_item_number {get;set;}
        
        public OrderFitsRelatedDetails(Id opportunityId , Id fitId , String custom_item_number , String standard_item_number)
        {
            this.opportunityId = opportunityId;
            this.fitId = fitId;
            this.custom_item_number = custom_item_number;
            this.standard_item_number = standard_item_number;
        }
    }
    public static OrderResponseWrapper parse(String json) 
    {
        return (OrderResponseWrapper) System.JSON.deserialize(json, OrderResponseWrapper.class);
    }
    
    public class OrderResponseWrapper
    {
        public String modified_at;
        public String order_id;
        public String is_deleted;
        public String is_finalized;
        public String is_submitted;
        public String created_at;
        public string order_name;
        public string team_id;
    }
}