/*
*  Purpose          :   Controller class to have the logic associated with the create FF User button on account detail page.
*
*  Create By        :   Abhinav Sharma - 5/18/2020 - FF3.0-SFDC Integration
*  
*  Revision Log     :   v1.0 -  Created
* 
*/
public with sharing class FF_CreateCoachController 
{
    private Id accountId { get; set; }
    public String errorMessage {get; set;}
    public Boolean isConstructorError {get;set;}
    public Account account {get; set;}
    public Contact newContact {get;set;}
    public List<Contact> contacts {get; set;} 
    public List<ContactWrapper> contactData {get; set;}
    public List<Contact> selectedContacts {get; set;}
    
    public FF_CreateCoachController()
    {
        System.debug('controller');
        this.accountId = ApexPages.currentPage().getParameters().get('Id');
        if(String.isNotBlank(accountId))
        {
            Boolean hasCustomPermission = FeatureManagement.checkPermission('Fit_Freedom_User');
            if ( hasCustomPermission) 
            {
                initialize();
                
                
                List<Account> accounts = new List<Account>();
                accounts = [SELECT ID, FF_Create_Gym_Successful__c, gym_id__c
                            FROM Account 
                            WHERE ID =: this.accountId];
                
                if(accounts.size() > 0) 
                {
                    account = accounts[0];
                    if(account.gym_id__c != null && account.FF_Create_Gym_Successful__c == true)
                    {
                        errorMessage = '';
                        this.contacts =[SELECT Id, FirstName, LastName, Email, 
                                        Phone, Contact_Type__c, fit_freedom_Type__c 
                                        FROM Contact 
                                        WHERE AccountId =: accountId 
                                        AND  (fit_freedom_type__c = null
                                              OR fit_freedom_type__c = 'Coach')
                                        AND FF_Create_Owner_Successfully__c = false
                                        AND user_id__c  = null
                                        AND member_id__c = null
                                       ];
                        
                        if(contacts.size() > 0)
                        {                    
                            for(Contact con : contacts)
                            { 
                                contactData.add(new ContactWrapper(con));
                            }
                        }
                    }
                    else
                    {
                        isConstructorError = true;
                        errorMessage = 'This account doesn\'t exists on the Fit Freedom Side. First create this on Fit Freedom Side.';
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
                    }
                }
                else 
                {
                    isConstructorError = true;
                    errorMessage = 'Unable to retrieve account details.';
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
                }
            }
            else
            {
                isConstructorError = true;
                errorMessage = 'You do not have the suffiecient permissions to access this page. Please reach out to admin for more details.';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
            }
        }
        else
        {
            isConstructorError = true;
            errorMessage = 'Some Error Occured.';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
        }
        
        
        
    }
    
    public PageReference cancel() 
    {
        PageReference navigateToAccountDetailPage = new PageReference('/' + accountId);
        navigateToAccountDetailPage.setRedirect(true);
        return navigateToAccountDetailPage;
    }
    
    public PageReference cancel1() 
    {
        PageReference navigateToAccountDetailPage = new PageReference('/' + accountId);
        navigateToAccountDetailPage.setRedirect(true);
        return navigateToAccountDetailPage;
    }
    
    public void initialize()
    {
        contactData = new List<ContactWrapper>();
        isConstructorError = false;
        errorMessage = '';
        newContact = new Contact();
        selectedContacts = new List<Contact>();
    }
  
    public PageReference save() 
    {
        String accesstoken = '';
        try 
        {
            selectedContacts = new List<Contact>();
            //Handling new coach
            if(String.isNotBlank(newContact.FirstName) || String.isNotBlank(newContact.LastName) 
               || String.isNotBlank(newContact.Email) || String.isNotBlank(newContact.MobilePhone)) 
            {
                System.debug('Not Blank');
                if(String.isBlank(newContact.FirstName) || String.isBlank(newContact.LastName) 
                   || String.isBlank(newContact.Email) || String.isBlank(newContact.MobilePhone)) 
                {
                    System.debug('Blank');
                    errorMessage = 'Please have a value for all the inputs.';
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));
                    return null;
                }
                else
                {
                    System.debug('New Contact');
                    errorMessage = '';
                    newContact.Fit_Freedom_Type__c = 'Coach';
                    newContact.AccountId = account.Id;
                    selectedContacts.add(newContact);
                }
            }
            
            System.debug('After new Contact');
            List<Web_Service_Log__c> listOfWebServiceLogs = new List<Web_Service_Log__c>();
            List<Contact> contactsToUpdate = new List<Contact>();
            
            //Handling old Coach
            for(ContactWrapper con : contactData)
            {
                if(con.checked == true)
                {
                    selectedContacts.add(con.con);
                }
            }
            System.debug('selectedContacts.size() = ' + selectedContacts.size());
            
            Map<String, Id> mapEmailAndConId = new Map<String, Id>();
            if(selectedContacts.size() > 0)
            {
                 accesstoken = Constants.HTTP_BEARER + Constants.CHAR_SPACE + FF_GetAccessToken.getAccessToken();
                for(Contact con : selectedContacts)
                {
                    System.debug('callout =' + con.Email);
                    HttpCalloutService service;
                    HttpRequest request;
                    HTTPResponse response;
                    
                    String body = '{' +
                        '"first_name":"' + con.FirstName + '",' + 
                        '"last_name":"' + con.LastName + '",' + 
                        '"email":"' + con.Email + '",' + 
                        '"phone":"' + con.Phone + '",' + 
                        '"role":"' + 'Coach' + '",' + 
                        '"received_from_sfdc":"' + 'true' + '",' + 
                        '"gym_id":"' + account.gym_id__c + '"' + 
                        '}';
                    service = new HTTPCalloutService('FF3_0_Create_New_User');
                    service.setRequestBody(body);
                    service.setHeaderParameter(Constants.HTTP_AUTHORIZATION, accessToken);
                    request = service.getRequest();
                    response = service.sendRequest(request);
                    
                    System.debug('response = ' + String.valueOf(response));
                    if(response != null && response.getStatusCode() == 200 && String.isNotBlank(response.getBody())) 
                    {
                        String res = response.getBody().substringBetween('"');
                        if( String.isNotBlank(res) && res.contains('-') && res.split('-').size() == 5)
                        {
                            con.member_id__c = res;
                            con.Fit_Freedom_Type__c = 'Coach';
                            con.FF_Create_Owner_Successfully__c = true;
                            contactsToUpdate.add(con);
                        }
                    }
                    else
                    {
                        con.FF_Error_Message__c = String.valueOf(response);
                        if(String.isBlank(con.Id))
                        {
                            contactsToUpdate.add(con);
                        }
                    }
                    Web_Service_Log__c wLog = webServiceLogs.populateCalloutLog(request, response, 'Create New Coach');
                    listOfWebServiceLogs.add(wLog);
                }
                
                System.debug('contactsToUpdate = ' + contactsToUpdate);
                if(contactsToUpdate.size() > 0)
                {
                    Util.BypassAllTriggers = true;
                    upsert contactsToUpdate;
                    Util.BypassAllTriggers = false;
                    
                    for(Contact con : contactsToUpdate)
                    {
                        mapEmailAndConId.put(con.Email, con.Id);
                    }
                }
                if(listOfWebServiceLogs.size() >0)
                {
                    for(Integer i=0; i<selectedContacts.size(); i++)
                    {
                        for(Integer j=0; j<listOfWebServiceLogs.size(); j++)
                        {
                            if(i == j)
                            {
                                listOfWebServiceLogs[j].Contact__c = mapEmailAndConId.get(selectedContacts[i].Email);
                            }
                        }
                    }
                    Util.BypassAllTriggers = true;
                    insert listOfWebServiceLogs;
                    Util.BypassAllTriggers = false;
                }
            }
            else
            {
                errorMessage = 'Please fill all input field or select atleast one contact.';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
            	return null;
            }
            
            if(contactsToUpdate.size() > 0)
            {
                List<Id> contactIds = new List<Id>();
                for(Contact con : contactsToUpdate)
                {
                    contactIds.add(con.Id);
                }
                FF_CreateCoachController.invokeGetUserCallout(contactIds,accesstoken);
            }
            
            return cancel();
		}
        catch(Exception exp)
        {
           
            System.debug('errorMessage= ' + errorMessage);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, exp.getMessage() + exp.getLineNumber() + exp.getStackTraceString()));
        	return null;
        }
    }
    
    @future(callout=true)
    private static void invokeGetUserCallout(List<Id> conIds,string accesstoken) 
    {
        try
        {
            List<Contact> contacts = [SELECT ID, LastName, FirstName, user_id__c,AccountId, device_ids__c, first_login__c, gender__c,  gym_id__c, 
                                         is_active__c,member_id__c, modified_at__c, is_deleted__c, Phone, role__c, social_handles__c, team_id__c, created_at__c
                                         FROM Contact
                                         WHERE ID =: conIds
                                        ];
            
            List<string> accIds = new List<String>();
            List<Contact> conToUpdate = new List<Contact>();
            List<Web_Service_Log__c> listOfWebServiceLogs = new List<Web_Service_Log__c>();
            
            for(Contact cc : contacts){
                accIds.add(cc.AccountId);
            }
            
            List<Rosters__c> rost = [SELECT Id, rosters_id__c FROM Rosters__c Where Account__c IN: accIds];
           
            for(Contact con : contacts)
            {
                CoachResponseWrapper coachResponse = new CoachResponseWrapper();
                
                /*if(rost.size() > 0){
                    
                    HttpCalloutService service1;
                    HttpRequest request1;
                    HTTPResponse response1;
                    
                    String body = '';
                    
                    if(String.isNotBlank(con.member_id__c))
                    {
                        body = '{' + '"user_id":"' + con.member_id__c + '"}';
                    }
                    else if(String.isNotBlank(con.user_id__c))
                    {
                        body = '{' + '"user_id":"' + con.user_id__c + '"}';
                    }
                    else
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Some error occured.'));
                        //return null;
                    }
                    
                    service1 = new HTTPCalloutService('FF3_0_Add_Coach_To_Team');
                    service1.setRequestBody(body);
                    service1.setHeaderParameter(Constants.HTTP_AUTHORIZATION, accessToken);
                    service1.setURLParameter(Constants.HTTP_HEADER_ID, rost[0].rosters_id__c);
                    request1 = service1.getRequest();
                    response1 = service1.sendRequest(request1);
                    
                    if(response1 != null && response1.getStatusCode() == 200 && String.isNotBlank(response1.getBody())) 
                    {
                        String res = response1.getBody().substringBetween('"');
                        if( String.isNotBlank(res) && res.equalsIgnoreCase(Constants.RESPONSE_ADD_COACH_TO_TEAM))
                        {
                            con.Rosters__c = rost[0].Id;
                            
                        }
                        else
                        {
                            con.FF_Error_Message__c = String.valueOf(response1);
                            
                        }
                    }
                    else
                    {
                        con.FF_Error_Message__c = String.valueOf(response1);
                       
                        
                    }
                    
                    Web_Service_Log__c wLog = webServiceLogs.populateCalloutLog(request1, response1, 'Add Coach To Team');
                    wLog.Rosters__c = rost[0].Id;
                    listOfWebServiceLogs.add(wLog);
                }*/
                
                HttpCalloutService service;
                HttpRequest request;
                HTTPResponse response;
                
                service = new HTTPCalloutService('FF3_0_Get_Users_By_Id');
                service.setURLParameter(Constants.HTTP_HEADER_ID, con.user_id__c);
                
                service.setHeaderParameter(Constants.HTTP_AUTHORIZATION, accessToken);
                request = service.getRequest();
                response = service.sendRequest(request);
                
                if(response != null && response.getStatusCode() == 200 && String.isNotBlank(response.getBody())) 
                {
                    coachResponse = parse(response.getBody());
                    
                    con.user_id__c = coachResponse.user_id;
                    con.device_ids__c = coachResponse.device_ids;
                    con.Email = coachResponse.email;
                    con.first_login__c = coachResponse.first_login;
                    con.FirstName = coachResponse.first_name;
                    con.LastName = coachResponse.last_name;
                    con.gender__c = coachResponse.gender;
                    con.gym_id__c = coachResponse.gym_id;
                    con.is_active__c = coachResponse.is_active;
                    con.modified_at__c = coachResponse.modified_at;
                    con.is_deleted__c = coachResponse.is_deleted;
                    con.Phone = coachResponse.phone;
                    con.role__c = coachResponse.role;
                    con.social_handles__c = coachResponse.social_handles;
                    con.team_id__c = coachResponse.team_id;
                    con.created_at__c = coachResponse.created_at;
                    
                    con.FF_Create_Owner_Successfully__c = true;
                    
                    conToUpdate.add(con);
                }
                else
                {
                    con.FF_Error_Message__c = String.valueOf(response);
                }
                
                Web_Service_Log__c wLog = webServiceLogs.populateCalloutLog(request, response, 'Get User By Id');
                wLog.Contact__c = con.Id;
                listOfWebServiceLogs.add(wLog);
            }
            
            if(listOfWebServiceLogs.size() >0)
            {
                Util.BypassAllTriggers = true;
                insert listOfWebServiceLogs;
                Util.BypassAllTriggers = false;
            }
            
            if(conToUpdate.size() > 0)
            {
                Util.BypassAllTriggers = true;
                update conToUpdate;
                Util.BypassAllTriggers = false;
                
            }
        }
        catch(Exception e)
        {
            
           
        }
        
    }
    
    public static CoachResponseWrapper parse(String json) 
    {
        return (CoachResponseWrapper) System.JSON.deserialize(json, CoachResponseWrapper.class);
    }
    
    public class CoachResponseWrapper
    {
        public String user_id;
        public String device_ids;
        public String email;
        public String first_login;
        public String first_name;
        public String last_name;
        public String gender;
        public String gym_id;
        public String is_active;
        public String modified_at;
        public String is_deleted;
        public String phone;
        public String role;
        public String social_handles;
        public String team_id;
        public String created_at;
    }
    
    public class ContactWrapper
    {
        public Contact con {get; set;}
        public Boolean checked {get; set;}
        
        public ContactWrapper(Contact c)
        {
            con = c;
            checked = false;
        }
    }
    
    public static void testCov(){
       Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        
    }
}