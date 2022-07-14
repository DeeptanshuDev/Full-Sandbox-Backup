/**
*   Purpose         :   Class to have rest resources and services for Fit Freedom App.
*   Created By      :   Ayush Gupta
*   Created Date    :   04/06/2020
*   Revision Log    :   v1.0 - Created - 04/06/2020
**/
@RestResource(urlMapping='/fitfreedomv3Athlete/*')
global class FitFreedomRestServiceAthlete
{
    //1) Get Athlete By Id (GET)
    @HttpGet
    global static AthleteResponseWrapper getAthleteFromSFDC() 
    {
        AthleteResponseWrapper res = new AthleteResponseWrapper();
        RestRequest req = RestContext.request;
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        try
        {
            String athId = req.params.get(Constants.HTTP_HEADER_ID);
            if(String.isNotBlank(athId)) 
            {
                List<Contact> contacts = [SELECT dob__c, Email, is_deleted__c, FirstName, gender__c, 
                                          LastName, Phone, team_id__c, created_at__c, modified_at__c, age__c,
                                          member_id__c, device_ids__c, first_login__c, gym_id__c, is_active__c,FF_Measured__c,
                                          pass__c, role__c, social_handles__c, user_id__c
                                          FROM Contact 
                                          WHERE Member_Id__c =: athId 
                                          AND Deleted_From_FF__c = false
                                         ];
                if(contacts.size() > 0) 
                {
                    wsLog.Contact__c = contacts[0].Id;
                    res.athletes = getAthleteMap(contacts);    
                    res.setSuccess('Get Athlete Successful');
                }
                else 
                {
                    res.setError('No athlete found for the specified id (athlete id)');
                }
            }
            else 
            {
                res.setError('Please specify a id (athlete id) in request params.');    
            }
        }
        catch(Exception e)
        {
            res.setError(Constants.HTTP_RESPONSE_FAILED + Constants.CHAR_SPACE + Constants.CHAR_COLON 
                         + Constants.CHAR_SPACE + e.getMessage());
        }
        wsLog.Operation_Name__c = 'Get Athlete By Id';
        wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
        insert wsLog;
        return res;
    }
    
     @HttpDELETE
    global static AthleteResponseWrapper removeathlete() 
    {
        AthleteResponseWrapper res = new AthleteResponseWrapper(); 
        RestRequest req = RestContext.request;
        
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        try 
        {
            Sobject sobjToBeUpsert = new Contact();
            Blob body = req.requestBody;
            
            if(body != null) 
            {
                String requestString = body.toString();
                
                String teamIds = '';
                String memberId = '';
                String last_name = '';
                String gymId = '';
                String user_id = '';
                
                String actionType = req.requestURI.subStringbetween('/fitfreedomv3Athlete/', '/');
                 if(actionType == FitFreedomUrlMappings.ATHLETE_AT_REMOVE_ATHLETE) 
                {
                    wsLog.Operation_Name__c = 'Remove Athlete';
                    if(String.isNotBlank(requestString)) 
                    {
                        JSONParser parser = JSON.createParser(requestString);  
                        String teamId = '';
                        String removememberId = '';
                        while (parser.nextToken() != null) 
                        {
                            if(parser.getCurrentName() != parser.getText())
                            {
                                if(parser.getCurrentName() == 'team_id')
                                {
                                    teamId = parser.getText();
                                } 
                                if(parser.getCurrentName() == 'member_id')
                                {
                                    removememberId = parser.getText();
                                } 
                            }
                        }
                        
                        List<Contact> athletes = new List<contact>();
                        if(String.isNotBlank(removememberId) && String.isNotBlank(teamId))
                        {
                            athletes = [SELECT dob__c,Email,is_deleted__c,FirstName,gender__c,
                                        LastName,Phone,team_id__c,created_at__c,modified_at__c,age__c,member_id__c,FF_Measured__c,
                                        device_ids__c,first_login__c,gym_id__c,is_active__c,pass__c,role__c,social_handles__c,
                                        Fit_Freedom_Type__c,Deleted_From_FF__c , user_id__c
                                        FROM Contact
                                        WHERE Team_Id__c =: teamId
                                        AND Member_Id__c =: removememberId
                                        AND Deleted_From_FF__c = false
                                       ];
                            if(athletes.size() > 0)
                            {
                                athletes[0].Deleted_From_FF__c = true;
                                update athletes;
                                wsLog.Contact__c = athletes[0].Id;
                                res.athletes = new List<Map<String, String>>();
                                res.setSuccess('Removed');
                            }
                            else
                            {
                                res.setError('No Athlete Found For Given Memeber Id And Team Id');
                                return res;
                            }
                        }
                        else
                        {
                            if(String.isBlank(removememberId))
                            {
                                res.setError('please specify member_id for Remove Athlete in the request body');
                                return res;
                            }
                            else if(String.isBlank(teamId))
                            {
                                res.setError('please specify team_id for Remove Athlete in the request body');
                                return res;
                            }
                        }    
                    }
                    else 
                    {
                        res.setError('please have a valid request body for Remove Athlete request.');
                    }
                }
                
            }
            
        }catch(Exception e){
            
            res.setError(Constants.HTTP_RESPONSE_FAILED + Constants.CHAR_SPACE + Constants.CHAR_COLON 
                         + Constants.CHAR_SPACE + e.getMessage() + e.getLineNumber());
            wsLog.Operation_Name__c = 'Athlete POST Requests - Exception';
            
            System.debug('Errorrrr '+e.getMessage());
            
        }
        
        wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
        insert wsLog;
        return res;
    }
    
    @HttpPost
    global static AthleteResponseWrapper athletePostRequest() 
    {
        AthleteResponseWrapper res = new AthleteResponseWrapper(); 
        RestRequest req = RestContext.request;
         
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        try 
        {
            Sobject sobjToBeUpsert = new Contact();
            Blob body = req.requestBody;
            
            if(body != null) 
            {
                String requestString = body.toString();
                
                String teamIds = '';
                String memberId = '';
                String last_name = '';
                String gymId = '';
                String user_id = '';
                
                String actionType = req.requestURI.subStringbetween('/fitfreedomv3Athlete/', '/');
                
                /* {
                    "age": "26",
                    "first_name": "",
                    "last_name": "Brandon",
                    "gender": "Female",
                    "team_id":"d250330f-1906-4175-a874-67a608fef44e",
                    "member_id": "b3284308-8a19-41dc-bb94-ee2310322222",
                    "email":"test@test.com",
                    "measured":false
                }*/
                //3) Create New Athlete (POST)
                if(actionType == FitFreedomUrlMappings.ATHLETE_AT_ADD_TEAM_MEMBER)
                {
                    wsLog.Operation_Name__c = 'Create New Athlete';
                    if(String.isNotBlank(requestString)) 
                    {
                        JSONParser parser = JSON.createParser(requestString);
                        while (parser.nextToken() != null) 
                        {
                            if(parser.getCurrentName() != parser.getText())
                            {
                                if(FitFreedomMappings.mapOfAthleteSQLAndSFDCFields.containskey(parser.getCurrentName()))
                                {
                                    if(parser.getCurrentName() == 'team_id')
                                    {
                                        teamIds = parser.getText();
                                    }
                                    if(parser.getCurrentName() == 'member_id')
                                    {
                                        memberId = parser.getText();
                                    }
                                    if(parser.getCurrentName() == 'last_name')
                                    {
                                        last_name = parser.getText();
                                    }
                                    if(parser.getCurrentName() == 'user_id')
                                    {
                                        user_id = parser.getText();
                                    }
                                    
                                    if(parser.getCurrentName() == 'gym_id')
                                    {
                                        gymId = parser.getText();
                                    }
                                    sobjToBeUpsert.put(FitFreedomMappings.mapOfAthleteSQLAndSFDCFields.get(parser.getCurrentName()),parser.getText());
                                }
                            }
                        }
                        
                        if(String.isBlank(memberId)) 
                        {
                            res.setError('please specify member_id for Athlete in the request body');
                            return res;
                        }
                        
                        if(String.isBlank(gymId)) 
                        {
                            res.setError('please specify gym_id for Athlete in the request body');
                            return res;
                        }    
                            
                        if(String.isBlank(teamIds)) 
                        {
                            res.setError('please specify team_id for Athlete in the request body');
                            return res;
                        }
                        
                        if(String.isBlank(last_name)) 
                        {
                            res.setError('please specify last_name for Athlete in the request body');
                            return res;
                        }
                        
                        List<Contact> contacts = new List<Contact>();
                        SYstem.debug('memberId = ' + memberId);
                        SYstem.debug('user_id = ' + user_id);
                        if(string.isNotBlank(memberId))
                        {
                            SYstem.debug('inside query');
                            contacts = [SELECT Id,Deleted_From_FF__c FROM Contact 
                                        WHERE Member_Id__c =: memberId
                                        AND Deleted_From_FF__c = false];
                        }
                        
                        if(String.isNotBlank(user_id))
                        {
                            SYstem.debug('inside query');
                            contacts = [SELECT Id,Deleted_From_FF__c FROM Contact 
                                        WHERE user_id__c =: user_id
                                        AND Deleted_From_FF__c = false];
                        }
                        
                        SYstem.debug('contacts.size() = ' + contacts.size());
                        if(contacts.size()> 0)
                        {
                            sobjToBeUpsert.put('Id',contacts[0].Id);
                        }
                        
                       
                        
                        sobjToBeUpsert.put('fit_freedom_Type__c','Athlete');  
                        Map<String, Id> mapContact = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Contact', 'team_id__c', new Set<String>{(String)sobjToBeUpsert.get('team_id__c')});

                        if(mapContact != null && mapContact.values().size() > 0 && sobjToBeUpsert.get('team_id__c') != null) 
                        {
                            sobjToBeUpsert.put('Rosters__c', mapContact.get((String)sobjToBeUpsert.get('team_id__c')));
                              
                        }
                        else
                        {
                            res.setError('unable to find a team for the team_id that we have in the request body');
                            return res;
                        }
                        
                        Map<String, Id> mapGymOnContact = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Contact', 'gym_id__c', new Set<String>{(String)sobjToBeUpsert.get('gym_id__c')});
                        
                        if(mapGymOnContact != null && mapGymOnContact.values().size() > 0) 
                        {
                            sobjToBeUpsert.put('AccountId',  mapGymOnContact.get((String)sobjToBeUpsert.get('gym_id__c')));
                        }
                        else
                        {
                            res.setError('unable to find a gym for the gym_id that we have in the request body');
                            return res;
                        }
                        
                        upsert sobjToBeUpsert;
                        
                        wsLog.Contact__c = sobjToBeUpsert.Id;
                        res.setsuccess(Constants.HTTP_RESPONSE_CREATED + Constants.CHAR_SPACE + Constants.CHAR_COLON 
                                       + Constants.CHAR_SPACE + Constants.Athlete_Created_Successfully);    
                    }
                    else 
                    {
                        res.setError('please have a valid request body for Create New Athlete/Add team member request.');
                    }
                }
                
                /*{
                "team_id":"d250330f-1906-4175-a874-67a608fef44e"
                }*/
                //2) Get Athletes By Team (POST)
                else if(actionType == FitFreedomUrlMappings.ATHLETE_AT_GET_ATHLETE_BY_TEAM_ID)
                {
                    wsLog.Operation_Name__c = 'Get Athletes By Team';
                    if(String.isNotBlank(requestString)) 
                    {
                        JSONParser parser = JSON.createParser(requestString);
                        String teamId = '';
                        while (parser.nextToken() != null) 
                        {
                            if(parser.getCurrentName() != parser.getText())
                            {
                                if(parser.getCurrentName() == 'team_id')
                                {
                                    teamId = parser.getText();
                                }     
                            }
                        }
                        
                        if(String.isBlank(teamId))
                        {
                            res.setError('please specify team_id for Get Athlete in the request body');
                            return res;
                        }
                        else
                        {
                            List<Contact> athletes = [SELECT dob__c, Email, is_deleted__c, Measured__c,FirstName,gender__c,
                                                      LastName,Phone,team_id__c,created_at__c,modified_at__c,age__c,
                                                      member_id__c,device_ids__c,first_login__c,gym_id__c,is_active__c,FF_Measured__c,
                                                      pass__c,role__c,social_handles__c,Deleted_From_FF__c,Fit_Freedom_Type__c , user_id__c
                                                      FROM Contact
                                                      WHERE Team_Id__c =: teamId 
                                                      AND Fit_Freedom_Type__c = 'Athlete'
                                                      AND Deleted_From_FF__c = false
                                                     ];
                            if(athletes.size() > 0) 
                            {
                                res.athletes = getAthleteMap(athletes);
                                wsLog.Contact__c = athletes[0].Id;
                                res.setSuccess('Get Athlete By Team Succcessful');    
                            }
                            else 
                            {
                                res.setError('No athlete found for the specified team_id ');
                                return res;
                            }
                        }
                    }
                    else 
                    {
                        res.setError('please have a valid request body for Get Athletes By Team request.');
                    }
                }
                
                /*{
                "member_id": "b3284308-8a19-41dc-bb94-ee2310322222",
                "team_id":"d250330f-1906-4175-a874-67a608fef44e"
                }*/
                //4) Remove Athlete (POST)
              
                
                /*{
                "age": "26",
                "first_name": "Kelly",
                "last_name": "Laszjfed",
                "gender": "Female",
                "gym_id":"545b5091-7f8b-404b-8d8a-4232",
                "member_id": "b3284308-8a19-41dc-bb94-ee2310322222",
                "email":"afkelly785@yahoo.com"
                }*/
                else if(actionType == FitFreedomUrlMappings.ATHLETE_AT_CREATE_COACH)
                {
                    wsLog.Operation_Name__c = 'Create new Coach';
                    if(String.isNotBlank(requestString)) 
                    {
                        JSONParser parser = JSON.createParser(requestString);
                        while (parser.nextToken() != null) 
                        {
                            if(parser.getCurrentName() != parser.getText())
                            {
                                if(FitFreedomMappings.mapOfAthleteSQLAndSFDCFields.containskey(parser.getCurrentName()))
                                {
                                    if(parser.getCurrentName() == 'gym_id')
                                    {
                                        gymId = parser.getText();
                                    }
                                    if(parser.getCurrentName() == 'member_id')
                                    {
                                        memberId = parser.getText();
                                    }
                                    if(parser.getCurrentName() == 'last_name')
                                    {
                                        last_name = parser.getText();
                                    }
                                    sobjToBeUpsert.put(FitFreedomMappings.mapOfAthleteSQLAndSFDCFields.get(parser.getCurrentName()),parser.getText());
                                }
                            }
                        }
                        
                        if(String.isBlank(memberId)) 
                        {
                            res.setError('please specify member_id for Athlete in the request body');
                            return res;
                        }
                        
                        if(String.isBlank(gymId)) 
                        {
                            res.setError('please specify gym_id for Athlete in the request body');
                            return res;
                        }
                        
                        if(String.isBlank(last_name)) 
                        {
                            res.setError('please specify last_name for Athlete in the request body');
                            return res;
                        }
                        
                        List<Contact> contacts = new List<Contact>();
                        if(string.isNotBlank(memberId))
                        {
                            contacts = [SELECT Id,Deleted_From_FF__c FROM Contact 
                                        WHERE Member_Id__c =: memberId AND Deleted_From_FF__c = false];
                        }
                        
                        if(contacts.size()> 0)
                        {
                            sobjToBeUpsert.put('Id',contacts[0].Id);
                        }
                        
                        Map<String, Id> mapContact = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Contact', 'gym_id__c', new Set<String>{(String)sobjToBeUpsert.get('gym_id__c')});
                        
                        if(mapContact != null && mapContact.values().size() > 0 && sobjToBeUpsert.get('gym_id__c') != null) 
                        {
                            sobjToBeUpsert.put('AccountId', mapContact.get((String)sobjToBeUpsert.get('gym_id__c')));
                            sobjToBeUpsert.put('fit_freedom_Type__c','Coach');    
                        }
                        else
                        {
                            res.setError('unable to find a team for the gym_id that we have in the request body');
                            return res;
                        }
                        upsert sobjToBeUpsert;
                        
                        wsLog.Contact__c = sobjToBeUpsert.Id;
                        res.setsuccess(Constants.HTTP_RESPONSE_CREATED + Constants.CHAR_SPACE + Constants.CHAR_COLON 
                                       + Constants.CHAR_SPACE + 'Create Coach Successful');    
                    }
                    else 
                    {
                        res.setError('please have a valid request body for Create New Athlete/Add team member request.');
                    }
                    
                }
                else
                {
                    res.setError('Resource Not Found or unsupported action type.');
                    wsLog.Operation_Name__c = 'Athlete POST Requests - unsupported action type';
                }
            }
            else 
            {
                res.setError('Please provide the valid request body');
                wsLog.Operation_Name__c = 'Athlete POST Requests - Blank Body';
            }
        }
        catch(Exception e) 
        {
            res.setError(Constants.HTTP_RESPONSE_FAILED + Constants.CHAR_SPACE + Constants.CHAR_COLON 
                         + Constants.CHAR_SPACE + e.getMessage() + e.getLineNumber());
            wsLog.Operation_Name__c = 'Athlete POST Requests - Exception';
            
            System.debug('Errorrrr '+e.getMessage());
        }
        wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
        insert wsLog;
        return res;
    }
    
    private static List<Map<String, String>> getAthleteMap(List<Contact> athletes)
    {
        List<Map<String, String>> lst = new List<Map<String, String>>();
        Map<String, String> mp = FitFreedomMappings.mapOfAthleteSQLAndSFDCFields;
        for(Integer i=0; i<athletes.size(); i++)
        {
            Map<String, String> sc = new Map<String, String>();
            Sobject acc = athletes[i];
            for(String s : mp.keySet())
            {
                sc.put(s, String.valueOf(acc.get(mp.get(s))));
            }
            //sc.put('measured', String.valueOf(acc.get('Measured__c')));
            lst.add(sc);
        }
        return lst;
    }
    
    global class AthleteResponseWrapper 
    {
        global List<Map<String, String>> athletes {get;set;}
        global String status {get;set;}
        global String message {get;set;}
        global Integer statuscode {get;set;}
        
        global AthleteResponseWrapper()
        {
            athletes = new List<Map<String, String>>();
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