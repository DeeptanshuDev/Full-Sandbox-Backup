/*
*  Purpose          :   Controller class for VF page - FF_Add_Coach_To_Team_Page, it will be used to add coach/s to team 
						and also hit FF side to create coach at FF side and get FF side external id.
*
*  Create By        :   
*  
*  Revision Log     :   v1.0 -  Created - 6/15/2020
* 
*/
public class FF_Add_Coach_To_Team_Controller
{
	//private Id accountId { get; set; }
    //private String accountExtId { get; set; }
    public String errorMessage {get; set;}
    public Boolean isConstructorError {get;set;}
    public Id rostersId {get;set;}
    public Rosters__c rosters {get; set;}
   // public Contact newContact {get;set;}
    //public List<Contact> contacts {get; set;} 
    public List<ContactWrapper> contactData {get; set;}
    public List<Contact> selectedContacts {get; set;}
    
    public void initialize()
    {
        //accountId = '';
        //accountExtId = '';
        isConstructorError = false;
        errorMessage = '';
        contactData = new List<ContactWrapper>();
        selectedContacts = new List<Contact>();
    }
    
    public FF_Add_Coach_To_Team_Controller()
    {
        System.debug('controller');
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
                    if(rosters.FF_Create_Rosters_Successful__c && String.isNotBlank(rosters.rosters_id__c) 
                       && (!rosters.Deleted_From_FF__c) && (!rosters.Account__r.Deleted_From_FF__c)
                       && rosters.Account__r.FF_Create_Gym_Successful__c && String.isNotBlank(rosters.Account__r.gym_id__c) 
                      )
                    {
                        set<Id> conIds = new set<Id>();
                        List<Coach_Roster_MTM__c> coMTM = [SELECT Id, Name, Coach__c,Rosters__c FROM Coach_Roster_MTM__c where Rosters__c =: rostersId];
                        
                        if(coMTM.size() > 0){
                            
                            for(Coach_Roster_MTM__c cc : coMTM){
                                conIds.add(cc.Coach__c);
                            }
                        }
                        List<Contact> coaches = [SELECT Id,Name, FirstName, LastName, Email, 
                                                 MobilePhone, fit_freedom_Type__c,
                                                 member_id__c, user_id__c
                                                 FROM Contact 
                                                 WHERE AccountId =: rosters.Account__c 
                                                 AND Id NOT IN: conIds  
                                                 AND  (fit_freedom_type__c = null
                                                       OR fit_freedom_type__c = 'Coach')
                                                     AND FF_Create_Owner_Successfully__c = true
                                                 AND (user_id__c  != null OR member_id__c != null) 
                                                ];
                        
                        if(coaches.size() > 0)
                        {             
                            
                            for(Contact con : coaches)
                            {
                                contactData.add(new ContactWrapper(con));
                            }
                        }
                        else
                        {
                            isConstructorError = true;
                            errorMessage = 'There are no eligible Coach for FF or they are already in FF.';
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
                else
                {
                    isConstructorError = true;
                    errorMessage = 'No team found.';
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
    
    public PageReference save()
    {
        try
        {
            System.debug('Save');
            selectedContacts = new List<Contact>();
            
            for(ContactWrapper con : contactData)
            {
                if(con.checked == true)
                {
                    selectedContacts.add(con.con);
                }
            }
            
            if(selectedContacts.size() > 0)
            {
                List<Contact> contactsToUpdate = new List<Contact>();
                List<Coach_Roster_MTM__c> conRosterMTM = new List<Coach_Roster_MTM__c>();
                List<Web_Service_Log__c> listOfWebServiceLogs = new List<Web_Service_Log__c>();
                
                String accesstoken = Constants.HTTP_BEARER + Constants.CHAR_SPACE + FF_GetAccessToken.getAccessToken();
                for(Contact con : selectedContacts)
                {
                    Coach_Roster_MTM__c coRost = new Coach_Roster_MTM__c();
                    System.debug('callout =' + con.Email);
                    HttpCalloutService service;
                    HttpRequest request;
                    HTTPResponse response;
                    
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
                        errorMessage = 'Some error occured.';
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
                        return null;
                    }
                    
                    service = new HTTPCalloutService('FF3_0_Add_Coach_To_Team');
                    service.setRequestBody(body);
                    service.setHeaderParameter(Constants.HTTP_AUTHORIZATION, accessToken);
                    service.setURLParameter(Constants.HTTP_HEADER_ID, rosters.rosters_id__c);
                    request = service.getRequest();
                    response = service.sendRequest(request);
                    
                    System.debug('response = ' + String.valueOf(response));
                    if(response != null && response.getStatusCode() == 200 && String.isNotBlank(response.getBody())) 
                    {
                        String res = response.getBody().substringBetween('"');
                        if( String.isNotBlank(res) && res.equalsIgnoreCase(Constants.RESPONSE_ADD_COACH_TO_TEAM))
                        {
                            con.Fit_Freedom_Type__c = 'Coach';
                            con.FF_Create_Owner_Successfully__c = true;
                            con.Rosters__c = rosters.Id;
                            coRost.Coach__c = con.Id;
                            coRost.Name = con.LastName;
                            coRost.Rosters__c = rosters.Id;
                            conRosterMTM.add(coRost);
                            contactsToUpdate.add(con);
                        }
                        else
                        {
                            con.FF_Error_Message__c = String.valueOf(response);
                            contactsToUpdate.add(con);
                        }
                    }
                    else
                    {
                        con.FF_Error_Message__c = String.valueOf(response);
                        contactsToUpdate.add(con);
                        
                    }
                    
                    Web_Service_Log__c wLog = webServiceLogs.populateCalloutLog(request, response, 'Add Coach To Team');
                    wLog.Rosters__c = rosters.Id;
                    listOfWebServiceLogs.add(wLog);
                }
                
                if(conRosterMTM.size() > 0){
                    
                    insert conRosterMTM;
                }
                System.debug('contactsToUpdate = ' + contactsToUpdate);
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
}