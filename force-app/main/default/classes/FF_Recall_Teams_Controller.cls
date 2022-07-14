/*
*  Purpose          :   Controller class to have the logic associated with the create FF Order button on account detail page.
*
*  Create By        :   Abhinav Sharma - 5/21/2020 - FF3.0-SFDC Integration
*  
*  Revision Log     :   v1.0 -  Created - 5/21/2020
* 
*/
public with sharing class FF_Recall_Teams_Controller
{
    
    private Id accountId { get; set; }
    public Account account {get; set;}
    public List<Rosters__c> rosters {get; set;} 
    public static String accesstoken;
    public List<Rosters__c> rosterDetails {get; set;} 
    public Rosters__c roster { get; set; }
    public String selectedRosterId { get; set; }
    public Map<String , Rosters__c> mapOfRosters { get; set; }
    public Boolean teamScreen { get; set; }
    public Boolean successScreen { get; set; } 
    public Boolean isTeamUpdate { get; set; } 
    public String errorMessage { get; set; }
    public List<RosterWrapperCls> teamDetails {get; set;}
    
    public FF_Recall_Teams_Controller()
    {
        this.accountId = ApexPages.currentPage().getParameters().get('Id');
        List<Account> accounts = new List<Account>();
        accounts = [SELECT ID, Name, Type, ShippingCity, FF_Create_Gym_Successful__c, gym_id__c
                    FROM Account 
                    WHERE ID =: this.accountId];
        initialize();
        if(accounts.size() > 0) 
        {
            account = accounts[0];
            Boolean hasCustomPermission = FeatureManagement.checkPermission('Fit_Freedom_User');
            if (!hasCustomPermission) 
            {
                errorMessage = 'You do not have the suffiecient permissions to access this page. Please reach out to admin for more details.';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
            }
            if(String.isBlank(account.gym_id__c) && !account.FF_Create_Gym_Successful__c)
            {
                errorMessage = 'Please create an account first for this order on Fit Freedom Side.';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
            }
            
            
            rosters = [SELECT Id, Name, Account__c, coach_ids__c,rosters_id__c, Createddate,CreatedBy.Name,created_at__c, Deleted_From_FF__c, FF_Create_Rosters_Successful__c 
                       FROM Rosters__c 
                       WHERE Account__c =: this.accountId 
                       AND FF_Create_Rosters_Successful__c = true
                      AND Deleted_From_FF__c = false];
            if(rosters.size() > 0)
            {                    
                for(Rosters__c ros : rosters)
                {
                    teamDetails.add(new RosterWrapperCls(ros));
                }
            }
            
            
        }
        else 
        {
            errorMessage = 'Unable to retrieve account details.';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
        }
    }
    
    private void initialize() 
    {
        teamDetails = new List<RosterWrapperCls>();
        roster = new Rosters__c();
        teamScreen = true;
        successScreen = false;
        isTeamUpdate = false; 
        rosterDetails = new List<Rosters__c>();
        
    }
    
    public PageReference navigateToAccountDetailPage() 
    {
        PageReference navigateToAccountDetailPage = new PageReference('/' + accountId);
        navigateToAccountDetailPage.setRedirect(true);
        return navigateToAccountDetailPage;
    }    
    public PageReference save() 
    {
        rosterDetails = new List<Rosters__c>();
        try{
            if(String.isNotBlank(roster.Name)) 
            {
                
                errorMessage = '';
                roster.Account__c = account.Id;
                rosterDetails.add(roster);
            }
            List<Web_Service_Log__c> listOfWebServiceLogs = new List<Web_Service_Log__c>();
            List<Rosters__c> rostersToUpdate = new List<Rosters__c>();
            List<String> rosterIds = new List<String>();
            List<String> customItems = new List<String>();
            List<String> standardizedItems = new List<String>();
            
            //Handling old Coach
            for(RosterWrapperCls ros : teamDetails)
            {
                if(ros.isSelected == true)
                {
                    rosterDetails.add(ros.roster);
                    rosterIds.add(ros.roster.Id);
                }
            }
            
             for(Custom_Item__c cus : [SELECT Id,Opportunity__r.account.team_id__c,ff_order_name__c,Rosters__c,Opportunity__r.Opportunity_Auto_Number__c,Name,order_id__c,Item_Number_Edit__c,Rosters__r.rosters_id__c 
                           FROM Custom_Item__c 
                                               WHERE Rosters__c IN: rosterIds]){
                                                   
                                              customItems.add(cus.Id);     
                                               }
            
            for(Standardized_Item__c std : [SELECT Id,Opportunity__r.account.team_id__c,Rosters__c,order_id__c,Item_Name__c,Opportunity__r.Opportunity_Auto_Number__c ,Name,team_id__c,Rosters__r.rosters_id__c
                                 FROM Standardized_Item__c 
                                                          WHERE Rosters__c IN: rosterIds]){
                                                           standardizedItems.add(std.Id);   
                                                          }
             List<Order_Sizes__c> orderSizesToUpdate = new List<Order_Sizes__c>();
            List<order_sizes__c> CustomOrderSizes = [select id,Order__c from order_Sizes__c where Order__c IN: customItems];
            List<order_sizes__c> standardOrderSizes = [select id,standard_order__c from order_Sizes__c where standard_order__c IN: standardizedItems];
          
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
            
            accesstoken = Constants.HTTP_BEARER + Constants.CHAR_SPACE + FF_GetAccessToken.getAccessToken();
            HttpCalloutService service;
            HttpRequest request;
            HTTPResponse response;
            service = new HTTPCalloutService('FF3_0_Delete_Rosters');
            service.setHeaderParameter(Constants.HTTP_AUTHORIZATION, accessToken);
            
            String body = '';
            if(rosterDetails.size() > 0)
            {
                for(Rosters__c ros : rosterDetails){
                    service.setURLParameter('id',ros.rosters_id__c);
            if(!Test.isRunningTest()){

                    request = service.getRequest();
                    response = service.sendRequest(request);
            }else{
                response = new HTTPResponse();
                request = service.getRequest();
                 response.setHeader('Content-Type', 'text/json');
                        response.setBody('fullJson');
                        response.setStatusCode(200);
            }
                    if(response != null && response.getStatusCode() == 200 && String.isNotBlank(response.getBody()))
                    {
                        Rosters__c rr = new Rosters__c();
                        rr.Id = ros.Id;
                        rr.Deleted_From_FF__c = false;
                        rr.FF_Create_Rosters_Successful__c = false;
                        rostersToUpdate.add(rr);
                    }
                    Web_Service_Log__c wLog = webServiceLogs.populateCalloutLog(request, response, 'Delete Rosters');
                    wLog.Rosters__c = ros.Id;
                    listOfWebServiceLogs.add(wLog);
                }
            }
            
            if(rostersToUpdate.size() > 0){
                update rostersToUpdate;
            }
            if(listOfWebServiceLogs.size() > 0){
                insert listOfWebServiceLogs;
            }
            
            if(orderSizesToUpdate.size() > 0){
                update orderSizesToUpdate;
            }
            FF_Recall_Teams_Controller.invokeGetTeamCallout(customITems,standardizedItems,accesstoken);
            return backMethod();
            
        }
        catch(Exception exp)
        {
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, exp.getMessage() +exp.getLineNumber() ));
            return null;
        }
        
    }
    
    @future(callout=true)
    private static void invokeGetTeamCallout(List<String> custIds, List<String> standIds,string accesstoken) 
    {
        
        List<Custom_Item__c> customItemsToBeUpdate = new List<Custom_Item__c>();
        List<Standardized_Item__c> standardizedItemsToBeUpdate = new List<Standardized_Item__c>();
        List<Custom_Item__c> cust  = [SELECT Id,Fit__c,Opportunity__r.account.team_id__c,ff_order_name__c,Rosters__c,Opportunity__r.Opportunity_Auto_Number__c,Name,order_id__c,Item_Number_Edit__c,Rosters__r.rosters_id__c 
                           FROM Custom_Item__c 
                                               WHERE Id IN: custIds];
         List<Standardized_Item__c> std  = [SELECT Id,Fit__c,Opportunity__r.account.team_id__c,ff_order_name__c,Rosters__c,Opportunity__r.Opportunity_Auto_Number__c,Name,order_id__c,Rosters__r.rosters_id__c 
                           FROM Standardized_Item__c 
                                               WHERE Id IN: standIds];
        
        
        try{
            
            //service.setHeaderParameter(Constants.HTTP_AUTHORIZATION, accessToken);
          
            HttpCalloutService service;
            HttpRequest request;
            HTTPResponse response;
            service = new HTTPCalloutService('FF3_0_Delete_Order');
            service.setHeaderParameter(Constants.HTTP_AUTHORIZATION, accessToken);
            
            String body = '';
            List<Web_Service_Log__c> listOfWebServiceLogs = new List<Web_Service_Log__c>();
            
            if(cust.size() > 0){
                
               
                for(Custom_Item__c cItem : cust){
                  
                    Custom_Item__c cIt = new Custom_Item__c();
                   
                    body = '{"order_id":"'+cItem.order_id__c+'"}';
                    service.setRequestBody(body);
                    if(!Test.isRunningTest()){

                    request = service.getRequest();
                    response = service.sendRequest(request);
                    }else{
                        response = new HTTPResponse();
                        request = service.getRequest();
                        response.setHeader('Content-Type', 'text/json');
                        response.setBody('fullJson');
                        response.setStatusCode(200);
                        
                    }
                    if(response != null && response.getStatusCode() == 200 && String.isNotBlank(response.getBody()))
                    {
                        String str = String.valueOf(response.getBody());
                        str = str.substring(1, str.length()-1);
                        if(str != 'This order already exists')
                        {
                            cIt.Id = cItem.Id;
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
            
            if(std.size() > 0){
                
                for(Standardized_Item__c sItem : std){
                    
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
                        response.setBody('fullJson');
                        
                        response.setStatusCode(200);
                       
                    }
                    if(response != null && response.getStatusCode() == 200 && String.isNotBlank(response.getBody()))
                    {
                        String str = String.valueOf(response.getBody());
                        str = str.substring(1, str.length()-1);
                        if(str != 'This order already exists'){
                            sIt.Id = sItem.Id;
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

            if(listOfWebServiceLogs.size() > 0){
                insert listOfWebServiceLogs;
            }
            
        }catch(exception ex){
            
        }
    }
    
    public pagereference backMethod()
    {
        
        Pagereference pg =  new Pagereference('/'+this.accountId); 
        pg.setRedirect(true);
        return pg;
    }
    public static TeamResponseWrapper parse(String json) 
    {
        return (TeamResponseWrapper) System.JSON.deserialize(json, TeamResponseWrapper.class);
    }
    
    public class TeamResponseWrapper
    {
        public String modified_at;
        public String gym_id;
        public String member_count;
        public String created_at;
        public String team_name;
        public String owner;
        public string team_id;
        public List<String> sales_rep_ids;
        public List<String> coach_ids;
    }
    //This wrapper class hold Opportunity details
    public class RosterWrapperCls 
    {
        public Boolean isSelected {get;set;}
        public Rosters__c roster {get;set;}
        
        public RosterWrapperCls(Rosters__c roster)
        {
            this.roster = roster;
            this.isSelected = false;
        }
    }
}