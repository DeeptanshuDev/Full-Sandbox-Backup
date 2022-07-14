/*
*  Purpose          :   Controller class to have the logic associated with the create FF Order button on account detail page.
*
*  Create By        :   Abhinav Sharma - 5/21/2020 - FF3.0-SFDC Integration
*  
*  Revision Log     :   v1.0 -  Created - 5/21/2020
* 
*/
public with sharing class FF_Create_FF_Order_Controller
{
    
    private Id accountId { get; set; }
    public Account account {get; set;}
    public List<Rosters__c> rosters {get; set;} 
    public List<Rosters__c> rosterDetails {get; set;} 
    public Rosters__c roster { get; set; }
    public String selectedRosterId { get; set; }
    public Map<String , Rosters__c> mapOfRosters { get; set; }
    public Boolean teamScreen { get; set; }
    public Boolean successScreen { get; set; } 
    public Boolean isTeamUpdate { get; set; } 
    public String errorMessage { get; set; }
    public List<RosterWrapperCls> teamDetails {get; set;}
    
    public FF_Create_FF_Order_Controller()
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
            
            
            rosters = [SELECT Id, Name, Account__c, coach_ids__c,rosters_id__c, created_at__c, Deleted_From_FF__c, FF_Create_Rosters_Successful__c 
                       FROM Rosters__c 
                       WHERE Account__c =: this.accountId 
                       AND FF_Create_Rosters_Successful__c = false];
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
            
            //Handling old Coach
            for(RosterWrapperCls ros : teamDetails)
            {
                if(ros.isSelected == true)
                {
                    rosterDetails.add(ros.roster);
                }
            }
            
            Map<String, Id> mapEmailAndConId = new Map<String, Id>();
            
            if(rosterDetails.size() > 0)
            {
                String accesstoken = Constants.HTTP_BEARER + Constants.CHAR_SPACE + FF_GetAccessToken.getAccessToken();
               
                HttpCalloutService service;
                HttpRequest request;
                HTTPResponse response;
                service = new HTTPCalloutService('FF3_0_Create_Team');
                service.setHeaderParameter(Constants.HTTP_AUTHORIZATION, accessToken);
                
                for(Rosters__c ros : rosterDetails)
                {
                    String body = '{"gym_id":"'+account.gym_id__c+'", "team_name":"'+ ros.Name + '"}';
                    
                    service.setRequestBody(body);
                    request = service.getRequest();
                    response = service.sendRequest(request);
                    
                    System.debug('response = ' + String.valueOf(response));
                    System.debug('response.getBody() = ' + String.valueOf(response.getBody()));
                    if(response != null && response.getStatusCode() == 200 && String.isNotBlank(response.getBody())) 
                    {
                        Rosters__c tt = new Rosters__c();
                        if(String.isNotBlank(ros.Id)){
                            System.debug('ros.id = '  + ros.id);
                            tt.Id = ros.Id;
                        }
                        else
                        {
                            tt.Name = ros.Name;
                            tt.Account__c = ros.Account__c;
                        }
                        String teamId = response.getBody().subStringbetween('"' , '"');
                        tt.Rosters_id__c = teamId;
                        
                        tt.FF_Create_Rosters_Successful__c = true;
                        rostersToUpdate.add(tt);
                        
                    }
                    Web_Service_Log__c wLog = webServiceLogs.populateCalloutLog(request, response, 'Create New Team');
                    listOfWebServiceLogs.add(wLog);
                }
                
                if(rostersToUpdate.size() > 0)
                {
                    Util.BypassAllTriggers = true;
                    upsert rostersToUpdate;
                    Util.BypassAllTriggers = false;
                }
                
                if(listOfWebServiceLogs.size () > 0){
                    Util.BypassAllTriggers = true;
                    insert listOfWebServiceLogs;
                    Util.BypassAllTriggers = false;
                }
                
                if(rostersToUpdate.size() > 0)
                {
                    List<Id> rostersIds = new List<Id>();
                    for(Rosters__c ros : rostersToUpdate)
                    {
                        rostersIds.add(ros.Id);
                    }
                    FF_Create_FF_Order_Controller.invokeGetTeamCallout(rostersIds); 
                }
            }
            return backMethod();
            
        }
        catch(Exception exp)
        {
            System.debug('catch block error = ' + exp.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, exp.getMessage() +exp.getLineNumber() ));
            return null;
        }
        
    }
    
    @future(callout=true)
    private static void invokeGetTeamCallout(List<Id> rosterIds) 
    {
        
        try{
            Rosters__c rostersToUpdate = new Rosters__c();
            List<Rosters__c> roster = [SELECT Id, Name, Account__c, coach_ids__c, created_at__c, Deleted_From_FF__c, FF_Create_Rosters_Successful__c ,rosters_id__c
                                       FROM Rosters__c 
                                       WHERE ID =: rosterIds];
            
            
            List<Rosters__c> roastToUpdate = new List<Rosters__c>();
            List<Web_Service_Log__c> listOfWebServiceLogs = new List<Web_Service_Log__c>();
            
            if(roster.size() > 0)
            {
                String accesstoken = Constants.HTTP_BEARER + Constants.CHAR_SPACE + FF_GetAccessToken.getAccessToken();
                HttpCalloutService service;
                HttpRequest request;
                HTTPResponse response;
                
                service = new HTTPCalloutService('FF3_0_Find_One_Team');
                service.setHeaderParameter(Constants.HTTP_AUTHORIZATION, accessToken);
                
                for(Rosters__c ros : roster)
                {
                    TeamResponseWrapper teamResponse = new TeamResponseWrapper();
                    
                    service.setURLParameter('id',ros.rosters_id__c);
                    request = service.getRequest();
                    response = service.sendRequest(request);
                    
                    if(response != null && response.getStatusCode() == 200 && String.isNotBlank(response.getBody())) 
                    {
                        teamResponse = parse(response.getBody());
                        
                        ros.Id = ros.Id;
                        ros.member_count__c = teamResponse.member_count;
                        ros.created_at__c = teamResponse.created_at;
                        ros.modified_at__c = teamResponse.modified_at;
                        ros.rosters_id__c = teamResponse.team_id;
                        ros.gym_id__c = teamResponse.gym_id;
                        ros.Name = teamResponse.team_name;
                        roastToUpdate.add(ros);
                    }
                    else
                    {
                        ros.FF_Error_Message__c = String.valueOf(response);
                    }
                    
                    Web_Service_Log__c wLog = webServiceLogs.populateCalloutLog(request, response, 'Get One Team');
                    wLog.Rosters__c = ros.Id;
                    listOfWebServiceLogs.add(wLog);
                }
            }
            
            
            if(roastToUpdate.size() > 0)
            {
                Util.BypassAllTriggers = true;
                update roastToUpdate;
                Util.BypassAllTriggers = false;
                
            }
            if(listOfWebServiceLogs.size() >0)
            {
                Util.BypassAllTriggers = true;
                insert listOfWebServiceLogs;
                Util.BypassAllTriggers = false;
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