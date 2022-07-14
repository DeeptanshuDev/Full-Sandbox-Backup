/*
*  Purpose          :   Controller class to have the logic associated with the create FF User button on account detail page.
*
*  Create By        :   Abhinav Sharma - 5/18/2020 - FF3.0-SFDC Integration
*  
*  Revision Log     :   v1.0 -  Created
* 
*/
public with sharing class FF_CreateGymController 
{
    private Id accountId { get; set; }
    public Account account {get; set;}
    public List<Contact> contacts {get; set;} 
    public List<Rosters__c> rosters {get; set;} 
    public Contact contact { get; set; }
    public Rosters__c roster { get; set; }
    public String selectedContactId { get; set; }
    public String selectedRosterId { get; set; }
    public Map<String , Contact> mapOfContacts { get; set; }
    public Map<String , Rosters__c> mapOfRosters { get; set; }
    public Boolean gymScreen { get; set; }
    public Boolean gymOwnerScreen { get; set; }
    public Boolean teamScreen { get; set; }
    public Boolean reviewScreen { get; set; } 
    public Boolean successScreen { get; set; } 
    public Boolean isContactUpdate { get; set; } 
    public Boolean isTeamUpdate { get; set; } 
    public String errorMessage { get; set; } 
    
    public FF_CreateGymController()
    {
        this.accountId = ApexPages.currentPage().getParameters().get('Id');
        List<Account> accounts = new List<Account>();
        accounts = [SELECT ID, Name, Type, ShippingCity, FF_Create_Gym_Successful__c, gym_id__c
                    FROM Account 
                    WHERE ID =: this.accountId];
         contact = new Contact();
        roster = new Rosters__c();
        if(accounts.size() > 0) 
        {
            account = accounts[0];
            
            Boolean hasCustomPermission = FeatureManagement.checkPermission('Fit_Freedom_User');
            if (!hasCustomPermission) 
            {
                errorMessage = 'You do not have the suffiecient permissions to access this page. Please reach out to admin for more details.';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
            }
            
            else if(account.gym_id__c != null && account.FF_Create_Gym_Successful__c)
            {
                errorMessage = 'This account already exists on the Fit Freedom Side.';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
            }
            else
            {
                errorMessage = '';
                mapOfContacts = new Map<String , Contact>([SELECT Id, FirstName, LastName, Email, 
                                                           MobilePhone, Contact_Type__c, fit_freedom_Type__c, 
                                                           FF_Create_Owner_Successfully__c 
                                                           FROM Contact 
                                                           WHERE AccountId =: accountId 
                                                           AND fit_freedom_type__c != 'Athlete' 
                                                           AND fit_freedom_type__c != 'Parent' 
                                                           AND FF_Create_Owner_Successfully__c = false]);
                this.contacts = mapOfContacts.values();
                
                mapOfRosters = new Map<String , Rosters__c>([SELECT Id, Name, Account__c, coach_ids__c, created_at__c, Deleted_From_FF__c, FF_Create_Rosters_Successful__c 
                                                                    FROM Rosters__c 
                                                                    WHERE Account__c =: this.accountId 
                                                                    AND FF_Create_Rosters_Successful__c = false]);
                rosters = mapOfRosters.values();
               
            }
             initialize();
        }
        else 
        {
            errorMessage = 'Unable to retrieve account details.';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
        }
    }
    
    public void initialize() 
    {
        contact = new Contact();
        roster = new Rosters__c();
       selectedContactId = '';
        gymScreen = true;
        gymOwnerScreen = false;
        teamScreen = false;
        reviewScreen = false;
        successScreen = false;
        isContactUpdate = false;
        isTeamUpdate = false;    
    }
    
    public PageReference step1() 
    {
        if(String.isBlank(account.Name) || String.isBlank(account.Type) || String.isBlank(account.ShippingCity)) 
        {
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please have a value for all the inputs.'));            
        }
        else
        {
            gymScreen = false;
            gymOwnerScreen = true;
            teamScreen = false; 
            reviewScreen = false; 
        } 
        return null;
    }
    
    public PageReference step2() 
    {
        if(String.isBlank(contact.FirstName) || String.isBlank(contact.LastName) 
           || String.isBlank(contact.Email) || String.isBlank(contact.MobilePhone)) 
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please have a value for all the inputs.'));
        }
        else
        {
            gymScreen = false;
            gymOwnerScreen = false;
            teamScreen = true; 
            reviewScreen = false;
        }
        return null;   
    }
    
    public PageReference step3() 
    {
        if(String.isBlank(roster.Name)) 
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please have a value for all the inputs.'));
        }
        else
        {
            gymScreen = false;
            gymOwnerScreen = false;
            teamScreen = false; 
            reviewScreen = true; 
        }
        return null;
    }
    
    public PageReference navigateToAccountDetailPage() 
    {
        PageReference navigateToAccountDetailPage = new PageReference('/' + accountId);
        navigateToAccountDetailPage.setRedirect(true);
        return navigateToAccountDetailPage;
    }
    
    public PageReference goToGym() 
    {
        gymScreen = true;
        gymOwnerScreen = false;
        teamScreen = false; 
        reviewScreen = false; 
        return null; 
    }
    
    public PageReference goToGymOwner() 
    {
        gymOwnerScreen = true;
        teamScreen = false; 
        reviewScreen = false; 
        return null; 
    }
    
    public PageReference goToTeam() 
    {
        gymOwnerScreen = false;
        teamScreen = true; 
        reviewScreen = false; 
        return null; 
    }  
    
    public PageReference goToReviewPage() 
    {
        gymOwnerScreen = false;
        teamScreen = false; 
        reviewScreen = true; 
        return null; 
    } 
    
    public PageReference useDefaultGymOwner() 
    {
        //This instanse hold Custom Setting details
        Fit_Freedom_Configuration_Settings__c fitFreedomConfiSetting = CoreUtilitiesGYM.getFitFreedomConfiguration();
        
        if(fitFreedomConfiSetting != null)
        {
            contact.FirstName = fitFreedomConfiSetting.First_Name__c;
            contact.LastName = fitFreedomConfiSetting.Last_Name__c;
            contact.Email = fitFreedomConfiSetting.Email__c;
            contact.MobilePhone = fitFreedomConfiSetting.MobilePhone__c;
        }
        
        gymOwnerScreen = true;
        teamScreen = false; 
        reviewScreen = false; 
        return null;
    }
    
    public PageReference selectedContact()
    {
        isContactUpdate = true;
        selectedContactId = selectedContactId.trim();
        Contact selectedContact = mapOfContacts.get(selectedContactId);
        contact.FirstName = selectedContact.FirstName;
        contact.LastName = selectedContact.LastName;
        contact.Email = selectedContact.Email;
        contact.MobilePhone = selectedContact.MobilePhone;
        return null;
    }
    
    public PageReference selectedRoster()
    {
        isTeamUpdate = true;
        selectedRosterId = selectedRosterId.trim();
        
        Rosters__c selectedRoster = mapOfRosters.get(selectedRosterId);
        roster.Name = selectedRoster.Name;
        roster.Account__c = selectedRoster.Account__c;
        roster.coach_ids__c = selectedRoster.coach_ids__c;
        roster.created_at__c = selectedRoster.created_at__c;
        roster.Deleted_From_FF__c = selectedRoster.Deleted_From_FF__c;
        return null;
    }
    
    public PageReference save() 
    {
        try 
        {
            //Update account with the screen inputs user provided values
            Account updatedGym = new Account();
            updatedGym.Id = account.Id;
            updatedGym.Name = account.Name;
            updatedGym.Type = account.Type;
            updatedGym.ShippingCity = account.ShippingCity;
            
            Util.BypassAllTriggers = true;
            update updatedGym;
            Util.BypassAllTriggers = false;
            
            //Upsert contact (FF Owner) with the screen inputs user provided values
            Contact con = new Contact();
            if(isContactUpdate) 
            {
                con.Id = selectedContactId;
            }                
            con.FirstName = contact.FirstName;
            con.LastName = contact.LastName;
            con.Email = contact.Email;
            con.MobilePhone = contact.MobilePhone;
            con.AccountId = updatedGym.Id;
            con.fit_freedom_Type__c = 'Owner';
            
            Util.BypassAllTriggers = true;
            upsert con;
            Util.BypassAllTriggers = false;
            
            //Upsert team  with the screen inputs user provided values
            Rosters__c team = new Rosters__c();
            if(isTeamUpdate) 
            {
                team.Id = selectedRosterId;
            }
                
			team.Name = roster.Name;            
            team.coach_ids__c = roster.coach_ids__c;
            team.Account__c = updatedGym.Id;
           
            Util.BypassAllTriggers = true;
            upsert team;
            Util.BypassAllTriggers = false;
            
            FF_CreateGymController.invokeCreateAGymCallout(updatedGym.Id, con.Id, team.Id);
            
            /*PageReference navigateToAccountDetailPage = new PageReference('/' + updatedGym.Id);
            navigateToAccountDetailPage.setRedirect(true);*/
            return navigateToAccountDetailPage();
		}
        catch(Exception exp)
        {
            System.debug('method errorr = ' + exp.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, exp.getMessage() + exp.getLineNumber()));
        	return null;
        }
    } 
    
    @future(callout=true)
    private static void invokeCreateAGymCallout(String gymId, String ownerId, String defaultTeamId) 
    {
        try
        {
            Account accountToUpdate = new Account();
            List<Account> accounts = [SELECT ID, Name, Type, ShippingCity, FF_Create_Gym_Successful__c,
                                      gym_id__c, active__c, gym_type__c, location__c, owner__c, owner_name__c,
                                      sales_rep_ids__c, created_at__c, modified_at__c, team_id__c
                                      FROM Account 
                                      WHERE ID =: gymId];
            
            if(accounts.size() > 0) 
            {
                accountToUpdate = accounts[0];
            }
            
            Contact contactToUpdate = new Contact();
            List<Contact> contacts = [SELECT Id, FirstName, LastName, Email, 
                                      MobilePhone, Contact_Type__c, fit_freedom_Type__c, 
                                      FF_Create_Owner_Successfully__c, gym_id__c, member_id__c
                                      FROM Contact 
                                      WHERE ID =: ownerId];
            
            if(contacts.size() > 0) 
            {
                contactToUpdate = contacts[0];
            }
            
            Rosters__c rosterToUpdate = new Rosters__c();
            List<Rosters__c> rosters = [SELECT Id, Name, Account__c, coach_ids__c, created_at__c, 
                                        Deleted_From_FF__c, FF_Create_Rosters_Successful__c , rosters_id__c
                                        FROM Rosters__c 
                                        WHERE ID =: defaultTeamId];
            
            if(rosters.size() > 0) 
            {
                rosterToUpdate = rosters[0];
            }
            
            //This wrapper class hold gym response
            GymResponseWrapper gymResponse = new GymResponseWrapper();
            HttpCalloutService service;
            HttpRequest request;
            HTTPResponse response;
            
            String body = '{"admin": { "email":"'+contactToUpdate.Email+'", "first_name": "'+contactToUpdate.FirstName+'", "last_name": "'+contactToUpdate.LastName+'"},';
            body += '"gym": {"gym_name":"'+ accountToUpdate.Name +'","gym_type": "'+accountToUpdate.Type+'","location": "'+accountToUpdate.ShippingCity+'"},';
            
            if(String.isNotBlank( rosterToUpdate.Name)){
                body += '"team": {"team_name":"' + rosterToUpdate.Name +'"}}';
                
            }
            
            service = new HTTPCalloutService('FF3_Create_New_Gym');
            service.setRequestBody(body);
            String accesstoken = Constants.HTTP_BEARER + Constants.CHAR_SPACE + FF_GetAccessToken.getAccessToken();
            service.setHeaderParameter(Constants.HTTP_AUTHORIZATION, accessToken);
            request = service.getRequest();
            response = service.sendRequest(request);
            if(response != null) 
            {
                if(response.getStatusCode() == 200 && String.isNotBlank(response.getBody()))
                {
                    gymResponse = parse(response.getBody());
                    
                    /*{
                    "modified_at": "2020-05-28T07:23:39.116Z",
                    "gym_id": "b73a1842-9d97-4e9b-9bff-6a1bea35528b",
                    "active": true,
                    "created_at": "2020-05-28T07:23:39.116Z",
                    "owner_name": "Test Contact",
                    "owner": "0d9d09b3-cb73-48f0-9b1f-8fd17fb5f335",
                    "location": "Atlanta",
                    "gym_type": "All Star",
                    "gym_name": "Successful Test",
                    "createdAt": "2020-05-28T07:23:39.116Z",
                    "team_id": "2cd976ee-a399-4932-b169-a162c4df607c"
                    }*/
                    
                    //Populate account instance with response returned details
                    accountToUpdate.gym_id__c = gymResponse.gym_id;
                    accountToUpdate.active__c = gymResponse.active;
                    if(String.isNotBlank(gymResponse.gym_name)) 
                    {
                        accountToUpdate.Name = gymResponse.gym_name;    
                    }
                    accountToUpdate.gym_type__c = gymResponse.gym_type;
                    accountToUpdate.location__c = gymResponse.location;
                    accountToUpdate.owner__c = gymResponse.owner;
                    accountToUpdate.owner_name__c = gymResponse.owner_name;
                    accountToUpdate.sales_rep_ids__c = gymResponse.Sales_rep_ids;
                    accountToUpdate.created_at__c = gymResponse.created_at;
                    accountToUpdate.modified_at__c = gymResponse.modified_at;
                    accountToUpdate.team_id__c = gymResponse.team_id;
                    accountToUpdate.FF_Create_Gym_Successful__c = true;
                    accountToUpdate.Gym_Owner__c = contactToUpdate.Id;
                    //accountToUpdate.Opportunity__c = rosterToUpdate.Id;
                    
                    //Populate contact instance with response returned details
                    contactToUpdate.member_id__c = gymResponse.owner;
                    contactToUpdate.gym_id__c = gymResponse.gym_id;
                    contactToUpdate.FF_Create_Owner_Successfully__c = true;                
                    
                    //Populate team instance with response returned details
                    rosterToUpdate.gym_id__c = gymResponse.gym_id;
                    rosterToUpdate.FF_Create_Rosters_Successful__c = true;
                    rosterToUpdate.rosters_id__c = gymResponse.team_id;
                    rosterToUpdate.created_at__c = gymResponse.created_at;
                    rosterToUpdate.modified_at__c = gymResponse.modified_at;
                    
                    Util.BypassAllTriggers = true;
                    update accountToUpdate;
                    Util.BypassAllTriggers = false;
                    
                    Util.BypassAllTriggers = true;
                    update contactToUpdate;
                    Util.BypassAllTriggers = false;
                    
                    Util.BypassAllTriggers = true;
                    update rosterToUpdate;
                    Util.BypassAllTriggers = false;
                }
                else
                {
                    system.debug(' response --'+response);
                    accountToUpdate.FF_Error_Message__c = String.valueOf(response);
                    Util.BypassAllTriggers = true;
                    update accountToUpdate;
                    Util.BypassAllTriggers = false;
                }
            }
            
            if(service != null && request != null)
            {
                Web_Service_Log__c wLog = WebServiceLogs.populateCalloutLog(request, response, 'Create a Gym');
                wLog.Account__c = accountToUpdate.Id;
                Util.BypassAllTriggers = true;
                insert wLog;
                Util.BypassAllTriggers = false;
            }
        }
        catch(Exception e)
        {
            System.debug('future method error = ' + e.getMessage());
        }
    }	
    
    public static GymResponseWrapper parse(String json) 
    {
        return (GymResponseWrapper) System.JSON.deserialize(json, GymResponseWrapper.class);
    }
    
    public class GymResponseWrapper
    {
        public String modified_at;
        public String gym_id;
        public String active;
        public String created_at;
        public String owner_name;
        public String owner;
        public string team_id;
        public String gym_name;
        public String gym_type;
        public String location;
        public String Sales_rep_ids;
    }
}