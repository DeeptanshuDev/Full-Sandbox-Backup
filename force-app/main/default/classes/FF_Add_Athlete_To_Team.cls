/*
*  Purpose          :   Controller class for VF page - FF_Add_Athlete_To_Team, it will be used to add athlete/s to team 
						and also hit FF side to create athkete at FF side and get FF side external id.
*
*  Create By        :   
*  
*  Revision Log     :   v1.0 -  Created - 6/15/2020
* 
*/
public class FF_Add_Athlete_To_Team
{
    public String errorMessage {get; set;}
    public Boolean isConstructorError {get;set;}
    public String rostersId {get;set;}
    public Rosters__c rosters {get; set;}
    public List<ContactWrapper> contactData {get; set;}
    public List<Contact> selectedContacts {get; set;}
    
    public void initialize()
    {
        isConstructorError = false;
        errorMessage = '';
        contactData = new List<ContactWrapper>();
        selectedContacts = new List<Contact>();
    }
    
    public FF_Add_Athlete_To_Team()
    {
        //System.debug('hello');
        this.rostersId = ApexPages.currentPage().getParameters().get('Id');
        if(String.isNotBlank(rostersId))
        {
            if (FeatureManagement.checkPermission('Fit_Freedom_User')) 
            {
                initialize();
                List<Rosters__c> rostersList = [SELECT Id, Name, rosters_id__c, FF_Create_Rosters_Successful__c, Deleted_From_FF__c, 
                                                Account__c, Account__r.gym_id__c, Account__r.FF_Create_Gym_Successful__c, Account__r.Deleted_From_FF__c
                                                FROM Rosters__c
                                                WHERE Id =: rostersId];
                
                if(rostersList.size() > 0)
                {
                    rosters = rostersList[0];
                    if(rosters.FF_Create_Rosters_Successful__c 
                       && String.isNotBlank(rosters.rosters_id__c) 
                       && (!rosters.Deleted_From_FF__c) 
                       && (!rosters.Account__r.Deleted_From_FF__c)
                       && rosters.Account__r.FF_Create_Gym_Successful__c 
                       && String.isNotBlank(rosters.Account__r.gym_id__c) 
                      )
                    {
                        List<Contact> athletes = [SELECT Id, FirstName, LastName, Email, 
                                                 MobilePhone, fit_freedom_Type__c,
                                                 gender__c
                                                 FROM Contact 
                                                 WHERE AccountId =: rosters.Account__c 
                                                 AND Rosters__c = null 
                                                 AND  (fit_freedom_type__c = null
                                                       OR fit_freedom_type__c = 'Athlete')
                                                 AND FF_Create_Owner_Successfully__c = false
                                                 AND (user_id__c  = null OR member_id__c = null) 
                                                ];
                        
                        if(athletes.size() > 0)
                        {                    
                            for(Contact con : athletes)
                            { 
                                contactData.add(new ContactWrapper(con));
                            }
                        }
                        else
                        {
                            isConstructorError = true;
                            errorMessage = 'There are no eligible Athlete for FF or they are already in FF.';
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
                        }
                    }
                    else
                    {
                        isConstructorError = true;
                        errorMessage = 'Some Error Occoured.';
                        
                        if( (!rosters.FF_Create_Rosters_Successful__c) || String.isBlank(rosters.rosters_id__c))
                        {
                            errorMessage = 'This Team doesn\'t exist on FF side. First add this Team on FF side.';
                        }
                        
                        if((!rosters.Account__r.FF_Create_Gym_Successful__c) || String.isBlank(rosters.Account__r.gym_id__c))
                        {
                            errorMessage = 'This Gym doesn\'t exist on FF side. First add this Gym and Team on FF side.';
                        }
                        
                        if(rosters.Deleted_From_FF__c)
                        {
                            errorMessage = 'This Team is deleted.';
                        }
                        
                        if(rosters.Account__r.Deleted_From_FF__c)
                        {
                            errorMessage = 'This Gym is deleted.';
                        }
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
                    }
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

	private String generateBody(Contact con)
    {
        String body = '{' 
            + '"first_name":"' + con.FirstName + '",'
            + '"last_name":"' + con.LastName + '",'
            + '"email":"' + con.Email + '",'
            + '"gender":"' + con.gender__c + '",'
            + '"team_id":"' + rosters.rosters_id__c + '"'
            + '}'
            ;
        
        return body;
    }
    
    public PageReference save()
    {
        try
        {
             //This wrapper class hold gym response
            ContactResponseWrapper contactResponse = new ContactResponseWrapper();
            selectedContacts = new List<Contact>();
            for(ContactWrapper con : contactData)
            {
                if(con.checked == true)
                {
                    selectedContacts.add(con.con);
                }
            }

            //Callouts Limit
            if(selectedContacts.size() > 99)
            {
                errorMessage = 'Please select less than 100 contacts.';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
            }
            
            System.debug('selectedContacts = ' + selectedContacts.size());
            //if(true) return null;
            
            if(selectedContacts.size() > 0)
            {
                List<Contact> contactsToUpdate = new List<Contact>();
                List<Web_Service_Log__c> listOfWebServiceLogs = new List<Web_Service_Log__c>();
                
                String accesstoken = Constants.HTTP_BEARER + Constants.CHAR_SPACE + FF_GetAccessToken.getAccessToken();
                for(Contact con : selectedContacts)
                {
                    HttpCalloutService service;
                    HttpRequest request;
                    HTTPResponse response;
                    
                    String body = generateBody(con);
                    System.debug('con.id = ' +con.Id);
                    System.debug('body = ' +body);
                    
                    service = new HTTPCalloutService('FF_3_0_Create_New_Athlete');
                    service.setRequestBody(body);
                    service.setHeaderParameter(Constants.HTTP_AUTHORIZATION, accessToken);
                    //service.setHeaderParameter(Constants.HTTP_AUTHORIZATION, accessToken);
                    //service.setURLParameter(Constants.HTTP_HEADER_ID, rosters.rosters_id__c);
                    request = service.getRequest();
                    response = service.sendRequest(request);
                    
                    System.debug('request.getBody() = ' +request.getBody());
                    System.debug('request.getHeader() = ' +request.getHeader('Content-Type'));
                    System.debug('request = ' +request);
                    System.debug('response = ' +String.valueOf(response));
                    System.debug('response getStatus = ' +response.getBody());
                    //if(true) return null;
                    
                    if(response != null && response.getStatusCode() == 200) 
                    {
                         contactResponse = parse(response.getBody());
                        if(String.isNotBlank(String.valueOf(response.getBody())))
                        {
                            con.Member_Id__c = contactResponse.member_id;
                        }
                        con.Fit_Freedom_Type__c = 'Athlete';
                        con.FF_Create_Owner_Successfully__c = true;
                        con.Rosters__c = rosters.Id;
                        con.FF_Error_Message__c = '';
                        contactsToUpdate.add(con);
                    }
                    else
                    {
                        con.FF_Error_Message__c = String.valueOf(response);
                        contactsToUpdate.add(con);
                        
                    }
                    
                    Web_Service_Log__c wLog = webServiceLogs.populateCalloutLog(request, response, 'Create Athlete');
                    wLog.Contact__c = con.Id;
                    listOfWebServiceLogs.add(wLog);
                }
                
                System.debug('contactsToUpdate.size() = '  + contactsToUpdate.size() );
                if(contactsToUpdate.size() > 0)
                {
                    Util.BypassAllTriggers = true;
                    update contactsToUpdate;
                    Util.BypassAllTriggers = false;
                }
                
                if(listOfWebServiceLogs.size() > 0)
                {
                    Util.BypassAllTriggers = true;
                    insert listOfWebServiceLogs;
                    Util.BypassAllTriggers = false;
                }
                
                return cancel();
            }
            else
            {
                errorMessage = 'Please select atleast 1 contact.';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
            }
        }
        catch(Exception e)
        {
            system.debug(e.getMessage() + ' @@ ' + e.getStackTraceString());
            errorMessage = e.getMessage();
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
        }
        return null;
    }
    
    public PageReference cancel()
    {
        PageReference navigateToRecordPage = new PageReference('/' + rostersId);
        navigateToRecordPage.setRedirect(true);
        return navigateToRecordPage;
    }

    public static ContactResponseWrapper parse(String json) 
    {
        return (ContactResponseWrapper) System.JSON.deserialize(json, ContactResponseWrapper.class);
    }    
    public class ContactWrapper
    {
        public Contact con {get; set;}
        public Boolean checked {get; set;}
        public String modified_at;
        public String member_id;
        public String first_name;
        public String last_name;
        public String gender;
        public String created_at;
        public string age;
        public string team_id;
        public string gym_id;
        
        public ContactWrapper(Contact c)
        {
            con = c;
            checked = false;
        }
    }
    
    public class ContactResponseWrapper
    {
        public Contact con {get; set;}
        public Boolean checked {get; set;}
        public String modified_at;
        public String member_id;
        public String first_name;
        public String last_name;
        public String gender;
        public String created_at;
        public string age;
        public string team_id;
        public string gym_id;
        
        
    }
}