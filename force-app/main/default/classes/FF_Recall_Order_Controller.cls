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
public with sharing class FF_Recall_Order_Controller 
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
    
    public FF_Recall_Order_Controller(ApexPages.StandardController controller) 
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
                    this.mapOfCustomItems = new Map<Id , Custom_Item__c>([SELECT Id , Name , Opportunity__c , order_id__c,
                                                                          Opportunity__r.Opportunity_Auto_Number__c , 
                                                                          Stage__c , Gender__c , Fit__c,Fit__r.fit_id__c,Fit__r.Name , Quantity__c , 
                                                                          Category__c , Style__c , Price__c ,Opportunity__r.team_id__c, Rosters__r.rosters_id__c,
                                                                          Item_Number_Edit__c,Rosters__c, Opportunity_Number__c,FF_Create_Item_Successful__c
                                                                          FROM Custom_Item__c 
                                                                          WHERE Opportunity__c IN: opportunities 
                                                                          AND Fit__c != null
                                                                          AND Stage__c !=: Constants.CUSTOM_ITEM_STAGE_GREY_OUT
                                                                          AND FF_Create_Item_Successful__c = true
                                                                          AND FF_Is_Submitted__c = false
                                                                          ORDER BY Item_Number_Edit__c DESC]);
                    
                    
                    this.sizeOfMapCustomItems = this.mapOfCustomItems.size();
                    System.debug('sizeOfMapCustomItems = ' + sizeOfMapCustomItems);
                    
                    this.mapOfStandardItems = new Map<Id , Standardized_Item__c>([SELECT Id , Name, Style__c , Opportunity__c ,order_id__c, 
                                                                                  Opportunity__r.Opportunity_Auto_Number__c, Stage__c , Fit__c , 
                                                                                  List_Price__c,Opportunity__r.team_id__c , 
                                                                                  Quantity__c ,Rosters__c,Fit__r.fit_id__c,Fit__r.Name, 
                                                                                  Total_Price__c , Total_Price_per_Item__c,
                                                                                  FF_Create_Item_Successful__c,Rosters__r.rosters_id__c
                                                                                  FROM Standardized_Item__c 
                                                                                  WHERE Opportunity__c IN: opportunities 
                                                                                  AND Fit__c != null
                                                                                  AND Stage__c !=: Constants.STANDARDIZED_ITEM_STAGE_GREY_OUT
                                                                                  AND FF_Create_Item_Successful__c = true
                                                                                  ORDER BY Name DESC]);
                    
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
            
           List<Order_Sizes__c> orderSizesToUpdate = new List<Order_Sizes__c>();
            List<order_sizes__c> CustomOrderSizes = [select id,Order__c from order_Sizes__c where Order__c IN: setCustomItemId];
            List<order_sizes__c> standardOrderSizes = [select id,standard_order__c from order_Sizes__c where standard_order__c IN: setCustomItemId];
          
            for(order_sizes__c oz : CustomOrderSizes){
                Order_Sizes__c os = new Order_Sizes__c();
                os.Id = oz.Id;
                os.Order__c = null;
                orderSizesToUpdate.add(os);
                
            }
             
            for(order_sizes__c oz : standardOrderSizes){
                Order_Sizes__c os = new Order_Sizes__c();
                os.Id = oz.Id;
                os.standard_order__c = null;
                orderSizesToUpdate.add(os);
            }
            
           
            customItems = [SELECT Id,Opportunity__r.account.team_id__c,ff_order_name__c,Opportunity__r.Opportunity_Auto_Number__c,Name,order_id__c,Item_Number_Edit__c,Rosters__r.rosters_id__c 
                           FROM Custom_Item__c 
                           WHERE Id IN: setCustomItemId];
            
            standardizedItems = [SELECT Id,Opportunity__r.account.team_id__c,order_id__c,Item_Name__c,Opportunity__r.Opportunity_Auto_Number__c ,Name,team_id__c,Rosters__r.rosters_id__c
                                 FROM Standardized_Item__c 
                                 WHERE Id IN: setStandardItemId];
            
            
            
             accesstoken = Constants.HTTP_BEARER + Constants.CHAR_SPACE + FF_GetAccessToken.getAccessToken();
            //service.setHeaderParameter(Constants.HTTP_AUTHORIZATION, accessToken);
          
            HttpCalloutService service;
            HttpRequest request;
            HTTPResponse response;
            service = new HTTPCalloutService('FF3_0_Delete_Order');
            service.setHeaderParameter(Constants.HTTP_AUTHORIZATION, accessToken);
            
            String body = '';
            List<Web_Service_Log__c> listOfWebServiceLogs = new List<Web_Service_Log__c>();
            
            if(ci.size() > 0){
                
               
                for(Custom_Item__c cItem : ci){
                  
                    Custom_Item__c cIt = new Custom_Item__c();
                   
                    body = '{"order_id":"'+cItem.order_id__c+'"}';
                    
                    service.setRequestBody(body);
                    if(!Test.isRunningTest()){
                        
                        request = service.getRequest();
                        response = service.sendRequest(request);
                        
                    }
                    else{
                        response = new HTTPResponse();
                        request = service.getRequest();
                        response.setHeader('Content-Type', 'text/json');
                        response.setBody('{"order_id":"713754df-a880-49c0-975f-76ab7620b772","is_deleted":"true","is_finalized":"false","fits":"null","order_name":"0061047-2014936-All Star Couture  Girls Full-length Top","team_id":"42915cd7-e66b-4a57-a78f-bdaf79ba7983","modified_at":"2020-07-31T06:44:26.969Z","createdAt":"2020-07-31T06:44:26.969Z"}');
     
                        response.setStatusCode(200);
                        
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
                            cIt.FF_Create_Item_Successful__c = false;
                           
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
                    Web_Service_Log__c wLog = webServiceLogs.populateCalloutLog(request, response, 'Delete Order');
                    wLog.Custom_Item__c = cItem.Id;
                    listOfWebServiceLogs.add(wLog);
                }
            }
           
            if(standardizedItems.size() > 0){
                
                for(Standardized_Item__c sItem : standardizedItems){
                    
                    Standardized_Item__c sIt = new Standardized_Item__c();
                    
                    body = '{"order_id":"'+sItem.order_id__c+'"}';
                   
                    service.setRequestBody(body);
                    if(!Test.isRunningTest()){
                        
                        request = service.getRequest();
                        response = service.sendRequest(request);
                        
                    }
                    else{
                        response = new HTTPResponse();
                        request = service.getRequest();
                        response.setHeader('Content-Type', 'text/json');
                        response.setBody('{"order_id":"713754df-a880-49c0-975f-76ab7620b772","is_deleted":"true","is_finalized":"false","fits":"null","order_name":"0061047-2014936-All Star Couture  Girls Full-length Top","team_id":"42915cd7-e66b-4a57-a78f-bdaf79ba7983","modified_at":"2020-07-31T06:44:26.969Z","createdAt":"2020-07-31T06:44:26.969Z"}');
     
                        response.setStatusCode(200);
                        
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
                            sIt.FF_Create_Item_Successful__c = false;
                           
                            standardizedItemsToBeUpdate.add(sIt);
                        }
                    }
                    else
                    {
                        sIt.Id = sItem.Id;
                        sIt.FF_Error_Message__c = String.valueOf(response);
                        standardizedItemsToBeUpdate.add(sIt);
                    }
                    Web_Service_Log__c wLog = webServiceLogs.populateCalloutLog(request, response, 'Delete Order');
                    wLog.Standardized_Item__c = sItem.Id;
                    listOfWebServiceLogs.add(wLog);
                }
            }
            
            if(customItemsToBeUpdate.size() > 0){
                update customItemsToBeUpdate;
            }
            
            if(standardizedItemsToBeUpdate.size() > 0){
                update standardizedItemsToBeUpdate;
            }
             if(orderSizesToUpdate.size() > 0){
                
                update orderSizesToUpdate;
            }
            
            if(listOfWebServiceLogs.size() > 0){
                
                insert listOfWebServiceLogs;
            }
            //Nevigate to Detail Page Record
                Pagereference pg =  backMethod(); 
                return pg;
            
        }
        catch(exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, ex.getMessage() + ex.getLineNumber()));
        }
        return null;
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