/**
*   Purpose         :   Class to have rest resources and services for Fit Freedom App.
*   Created By      :   Ayush Gupta
*   Created Date    :   04/06/2020
*   Revision Log    :   v1.0 - Created - 04/06/2020
**/
@RestResource(urlMapping='/fitfreedomv3User/*')
global with sharing class FitFreedomRestServiceUser 
{    
    @HttpGet
    global static UserResponseWrapper getUsersFROMSFDC() 
    {
        UserResponseWrapper res = new UserResponseWrapper();
        RestRequest req = RestContext.request;
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        try
        {      
            String actionType = req.requestURI.substringBetween('/fitfreedomv3User/', '/');
            System.debug('actionType = ' + actionType);
            List<Contact> contacts = new List<Contact>();
            /*Final String getParents = 'get_Parents';
            Final String getParentsByTeamId = 'get_Parents_By_Team';
            Final String getParentCoaches = 'get_Parent_Coaches';
            Final String getTeamCoaches = 'get_Team_Choaches';*/
            
            /*if(actionType == FitFreedomUrlMappings.USER_AT_GET_ALL_USERS)
            {
                wsLog.Operation_Name__c = 'Find all Users';    
                contacts = [SELECT member_id__c, Device_Ids__c, dob__c,user_id__c,Email, First_Login__c, 
                            FirstName, Gender__c, Gym_Id__c, Is_Active__c, Is_Deleted__c, LastName, Pass__c, Phone, 
                            Role__c, Social_Handles__c, Team_Id__c, created_at__c, modified_at__c,Fit_Freedom_Type__c,age__c,FF_Measured__c
                            FROM Contact 
                            WHERE Fit_Freedom_Type__c = 'Sales Rep'
                            AND Deleted_From_FF__c = false
                           ];
                
                if(contacts.size() > 0)
                {
                    res.setSuccess('Get All Users Successful');
                }
                else
                {
                    res.setError('No Users found.');
                }
            }
            
            else if(actionType == FitFreedomUrlMappings.USER_AT_GET_USER_BY_GYM_ID)
            {
                wsLog.Operation_Name__c = 'Get Users by Gym id';
                String reqId = req.params.get(Constants.HTTP_HEADER_GYM_ID);
                if(String.isNotBlank(reqId)){
                    
                    contacts = [SELECT member_id__c, Device_Ids__c, dob__c,user_id__c,Email, First_Login__c, 
                                FirstName, Gender__c, Gym_Id__c, Is_Active__c, Is_Deleted__c, LastName, Pass__c, Phone, 
                                Role__c, Social_Handles__c, Team_Id__c, created_at__c, modified_at__c,Fit_Freedom_Type__c,age__c,FF_Measured__c
                                FROM Contact 
                                WHERE Fit_Freedom_Type__c = 'Sales Rep'
                                AND Deleted_From_FF__c = false
                                AND gym_Id__c =: reqId];
                    if(contacts.size() > 0)
                    {
                        wsLog.Contact__c = contacts[0].Id;
                        res.setSuccess('Get Users BY Gym Id Successful');
                    }
                    else
                    {
                        res.setError('No Users found for Gym Id');
                    }
                }
                else
                {
                    res.setError('Please specify a gym_id in request params.');
                }
            }*/
            
             if(actionType == FitFreedomUrlMappings.USER_AT_GET_USER_BY_USER_ID)
            {
                wsLog.Operation_Name__c = 'Get Users by ID';
                String reqId = req.params.get(Constants.HTTP_HEADER_ID);
                if(String.isNotBlank(reqId))
                {
                    contacts = [SELECT member_id__c, Device_Ids__c, dob__c,user_id__c,Email, First_Login__c, 
                                FirstName, Gender__c, Gym_Id__c, Is_Active__c, Is_Deleted__c, LastName, Pass__c, Phone, 
                                Role__c, Social_Handles__c, Team_Id__c, created_at__c, modified_at__c,Fit_Freedom_Type__c,age__c,FF_Measured__c
                                FROM Contact 
                                WHERE Fit_Freedom_Type__c = 'Sales Rep'
                                AND Deleted_From_FF__c = false
                                AND user_id__c =: reqId];
                    
                    if(contacts.size() > 0)
                    {
                        wsLog.Contact__c = contacts[0].Id;
                        res.setSuccess('Get Users BY Id Successful');
                    }
                    else
                    {
                        res.setError('No Users found for Gym Id');
                    }
                }
                else
                {
                    res.setError('Please specify a user_id in request params.');
                }
            }
            /*
            else if(actionType == FitFreedomUrlMappings.USER_AT_GET_PARENTS) 
            {
                wsLog.Operation_Name__c = 'Find Parent';
                contacts = [SELECT member_id__c, Device_Ids__c, dob__c,user_id__c,Email, First_Login__c, 
                            FirstName, Gender__c, Gym_Id__c, Is_Active__c, Is_Deleted__c, LastName, Pass__c, Phone, 
                            Role__c, Social_Handles__c, Team_Id__c, created_at__c, modified_at__c,Fit_Freedom_Type__c,age__c,FF_Measured__c
                            FROM Contact 
                            WHERE Fit_Freedom_Type__c = 'Parent'
                            AND Deleted_From_FF__c = false
                           ];
                if(contacts.size() > 0)
                {
                    
                    res.setSuccess('Get Parent Successful');
                }
                else
                {
                    res.setError('No Parent Found');
                }
            }
            
            else if(actionType == FitFreedomUrlMappings.USER_AT_GET_PARENTS_BY_TEAM)
            {
                wsLog.Operation_Name__c = 'Find Parent By Team';
                String reqId = req.params.get('team_id');
                if(String.isNotBlank(reqId))
                {
                    contacts = [SELECT member_id__c, Device_Ids__c, dob__c,user_id__c,Email, First_Login__c, 
                                FirstName, Gender__c, Gym_Id__c, Is_Active__c, Is_Deleted__c, LastName, Pass__c, Phone, 
                                Role__c, Social_Handles__c, Team_Id__c, created_at__c, modified_at__c,Fit_Freedom_Type__c,age__c,FF_Measured__c
                                FROM Contact 
                                WHERE Fit_Freedom_Type__c = 'Parent'
                                AND Deleted_From_FF__c = false
                                AND team_id__c =: reqId];
                    if(contacts.size() > 0)
                    {
                        wsLog.Contact__c = contacts[0].Id;
                        res.setSuccess('Get Parent BY Team id Successful');
                    }
                    else
                    {
                        res.setError('No Parent Found for Team Id');
                    }
                }
                else
                {
                    res.setError('Please specify a team_id in request params.');
                }
            }
            
            else if(actionType == FitFreedomUrlMappings.USER_AT_GET_TEAM_COACHES) 
            {
                wsLog.Operation_Name__c = 'Find Team Coach';
                String reqId = req.params.get('team_id');
                if(String.isNotBlank(reqId))
                {
                    contacts = [SELECT member_id__c, Device_Ids__c, dob__c,user_id__c,Email, First_Login__c, 
                                FirstName, Gender__c, Gym_Id__c, Is_Active__c, Is_Deleted__c, LastName, Pass__c, Phone, 
                                Role__c, Social_Handles__c, Team_Id__c, created_at__c, modified_at__c,Fit_Freedom_Type__c,age__c,FF_Measured__c
                                FROM Contact 
                                WHERE Fit_Freedom_Type__c = 'Coach'
                                AND Deleted_From_FF__c = false
                                AND team_id__c =: reqId];
                    if(contacts.size() > 0)
                    {
                        wsLog.Contact__c = contacts[0].Id;
                        res.setSuccess('Get Coach By Team Successful');
                    }
                    else
                    {
                        res.setError('No Coaches Found for Team Id');
                    }
                }
                else
                {
                    res.setError('Please specify a team_id in request params.');
                }
            }
*/
            else 
            {
                res.setError('Resource not found or unsupported action type');
                wsLog.Operation_Name__c = 'User GET Requests - unsupported action type';    
            }
            res.users = getUsersMap(contacts);
        }
        catch(Exception e)
        {
            res.setError(Constants.HTTP_RESPONSE_FAILED + Constants.CHAR_SPACE + Constants.CHAR_COLON + Constants.CHAR_SPACE + 
                         e.getMessage());
            wsLog.Operation_Name__c = 'User GET Requests - Exception';
        }
        wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
        insert wsLog;
        return res;
    }
    
    @HttpPost
    global static UserResponseWrapper insertUserAtSFDC()
    {
        UserResponseWrapper res = new UserResponseWrapper();
        RestRequest req = RestContext.request;
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        String actionType = req.requestURI.substringBetween('/fitfreedomv3User/', '/');
        try 
        {
            String last_name = '';
            String user_id = '';
            String gym_id = '';
            String teamId = '';
            String role = '';
            Blob body = req.requestBody;
            if(body != null)
            {
                JSONParser parser = JSON.createParser(body.toString());
                Contact sobjContact = new Contact();
                if(actionType == FitFreedomUrlMappings.USER_AT_CREATE_USER){
                    wsLog.Operation_Name__c = 'Create new Coach';
                    while (parser.nextToken() != null) 
                    {
                        if(parser.getCurrentName() != parser.getText())
                        {
                            if(FitFreedomMappings.mapOfAdminSQLAndSFDCFields.containskey(parser.getCurrentName()))
                            {
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
                                    gym_id = parser.getText();
                                }
                                
                                if(parser.getCurrentName() == 'role'){
                                    role = parser.getText();
                                }
                                sobjContact.put(FitFreedomMappings.mapOfAdminSQLAndSFDCFields.get(parser.getCurrentName()),parser.getText());
                            }
                        }
                    }
                    
                    if(String.isBlank(last_name)) 
                    {
                        res.setError('please specify last_name for the users in the request body');
                        return res;
                    }
                    
                    if(String.isBlank(gym_id)) 
                    {
                        res.setError('please specify gym_id for the users in the request body');
                        return res;
                    }
                    
                    if(String.isBlank(user_id)) 
                    {
                        res.setError('please specify user_id for the users in the request body');
                        return res;
                    } 
                    
                    List<Contact> contacts = new List<Contact>();
                    List<User> users = new List<User>();
                    if(String.isNotBlank(user_id)) 
                    {
                        contacts = [SELECT Id 
                                    FROM Contact 
                                    where user_Id__c =: user_id
                                    AND Deleted_From_FF__c = false
                                   ];
                        users = [SELECT Id,sales_rep_id__c 
                                 FROM User 
                                 WHERE sales_rep_id__c =: user_id];
                    }
                    
                    if(contacts.size() > 0)
                    {
                        sobjContact.put('Id', contacts[0].Id);
                    }
                    
                    if(role == 'Coach' || role =='coach'){
                        sobjContact.put('fit_freedom_Type__c', 'Coach');
                        sobjContact.put('FF_Create_Owner_Successfully__c', true);
                    }else{
                        sobjContact.put('fit_freedom_Type__c', 'Sales Rep');
                        /*if(users.size() > 0){
                        //sobjContact.put('FF_Sales_Rep_FF__c', users[0].Id);
                        }else{
                        //res.setError('unable to find a users for the user_id that we have in the request body');
                        //return res;
                        }*/
                    }
                    Map<String, Id> mapGymId = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Contact', 'gym_id__c', new Set<String>{(String)sobjContact.get('gym_id__c')});
                    
                    if(mapGymId != null && mapGymId.values().size() > 0) 
                    {
                        sobjContact.put('AccountId', mapGymId.get((String)sobjContact.get('gym_id__c')));
                    }
                    else
                    {
                        res.setError('unable to find a Gym for the gym_id that we have in the request body');
                        return res;
                    }
                    
                    upsert sobjContact;
                    wsLog.Contact__c = sobjContact.Id;
                    if(role == 'Coach'){
                    res.setSuccess('New Coach Created successfully');
                    }else{
                        res.setSuccess('New user Created successfully');
                    }
                }
                
                else if(actionType == FitFreedomUrlMappings.USER_AT_CREATE_PARENT){
                    String teamIds = '';
                    String memberId = '';
                    wsLog.Operation_Name__c = 'Create New Parent';
                    
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
                                sobjContact.put(FitFreedomMappings.mapOfAthleteSQLAndSFDCFields.get(parser.getCurrentName()),parser.getText());
                            }
                        }
                    }
                    
                    if(String.isBlank(memberId)) 
                    {
                        res.setError('please specify member_id for Parent in the request body');
                        return res;
                    }
                    
                    if(String.isBlank(teamIds)) 
                    {
                        res.setError('please specify team_id for Parent in the request body');
                        return res;
                    }
                    
                    if(String.isBlank(last_name)) 
                    {
                        res.setError('please specify last_name for Parent in the request body');
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
                        sobjContact.put('Id',contacts[0].Id);
                    }
                    sobjContact.put('fit_freedom_Type__c','Parent'); 
                    Map<String, Id> mapContact = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Contact', 'team_id__c', new Set<String>{(String)sobjContact.get('team_id__c')});
                    
                    if(mapContact != null && mapContact.values().size() > 0 && sobjContact.get('team_id__c') != null) 
                    {
                        teamId = mapContact.get((String)sobjContact.get('team_id__c'));
                        sobjContact.put('Rosters__c', mapContact.get((String)sobjContact.get('team_id__c')));
                           
                    }
                    else
                    {
                        res.setError('unable to find a team for the team_id that we have in the request body');
                        return res;
                    }
                    
                    if(teamId != null){
                        for(Rosters__c acc : [SELECT Id,Account__c FROM Rosters__c where Id =: teamId]){
                             sobjContact.put('AccountId', acc.Account__c);
                        }
                    }
                  
                    upsert sobjContact;
                    
                    wsLog.Contact__c = sobjContact.Id;
                    res.setsuccess(Constants.HTTP_RESPONSE_CREATED + Constants.CHAR_SPACE + Constants.CHAR_COLON 
                                   + Constants.CHAR_SPACE + 'Parent Created Sucessful');
                    
                }
                else{
                    res.setError('Unsupported action type.'); 
                    wsLog.Operation_Name__c = 'User Post Requests - Unsupported action type';
                }
            }
            else
            {
                res.setError('Please provide the valid request body');
            }
        }
        catch(Exception e) 
        {
            res.setError(Constants.HTTP_RESPONSE_FAILED + Constants.CHAR_SPACE + Constants.CHAR_COLON + Constants.CHAR_SPACE + 
                         e.getMessage());
        }
        
        wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
        insert wsLog;
        return res;
    }
    
    @HttpPut
    global static UserResponseWrapper updateUser() 
    {
        RestRequest req = RestContext.request;
        UserResponseWrapper res = new UserResponseWrapper();
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        try
        {
            Blob body = req.requestBody;
            if(body != null){
                JSONParser parser = JSON.createParser(body.toString());
                
                String actionType = req.requestURI.subStringbetween('/fitfreedomv3User/', '/');
                List<Contact> contacts = new List<Contact>();
               
                /*Final String removeTeamFROMUser = 'removeTeam';
                Final String updateRepByUserId = 'updateRepByUserId';
                Final String removeUsersFROMGym = 'removeUsersFROMGym';
                Final String addGymAndTeamsToUsers = 'addGymAndTeamsToUsers';
                Final String updateParent = 'update_parent'; */
               
               /* if(actionType == FitFreedomUrlMappings.USER_AT_UPDATE_PARENT)
                {
                    
                    wsLog.Operation_Name__c = 'Update Parent';
                    
                    String userId  = req.params.get('user_id');
                    String emails = '';
                    if(String.isNotBlank(userId)){
                        while (parser.nextToken() != null)
                        {
                            if(parser.getCurrentName() != parser.getText())
                            {
                                if(parser.getCurrentName() == 'email')
                                {
                                    emails = parser.getText();
                                }
                            }
                        }
                        contacts = [SELECT Id,Team_Id__c,Email 
                                    FROM Contact 
                                    WHERE member_id__c =: userId
                                    AND Deleted_From_FF__c = false];
                        
                        if(contacts.size() > 0)
                        {
                            contacts[0].Email = emails;
                            wsLog.Contact__c = contacts[0].Id;
                            res.setSuccess('Updated');
                        }
                        else
                        {
                            res.setError('No user found for given user id');
                        }
                        
                    }
                    else{
                        res.setError('Please Specify the userId in the Params');
                    }
                }*/
                
                if(actionType == FitFreedomUrlMappings.USER_AT_DELETE_PARENT)
                {
                    wsLog.Operation_Name__c = 'Delete Parent';
                    
                    String userId  = req.params.get('user_id');
                    String emails = '';
                    if(String.isNotBlank(userId)){
                        
                        contacts = [SELECT Id,Team_Id__c,Email 
                                    FROM Contact 
                                    WHERE member_id__c =: userId
                                    AND Deleted_From_FF__c = false];
                        
                        if(contacts.size() > 0)
                        {
                            contacts[0].Deleted_From_FF__c = true;
                            wsLog.Contact__c = contacts[0].Id;
                            res.setSuccess('Parent Deleted Successful');
                        }
                        else
                        {
                            
                            res.setError('No user found for given user id');
                        }
                        
                    }
                    else{
                        res.setError('Please Specify the userId in the Params');
                    }
                }
                /*
                else if(actionType == FitFreedomUrlMappings.USER_AT_REMOVE_TEAM_FROM_USER)
                {
                    wsLog.Operation_Name__c = 'Remove Team from User';
                    String userId  = req.params.get('user_id');
                    String teamId = '';
                    
                    if(String.isNotBlank(userId)){
                        while (parser.nextToken() != null)
                        {
                            if(parser.getCurrentName() != parser.getText())
                            {
                                if(parser.getCurrentName() == Constants.HTTP_TEAM_ID)
                                {
                                    teamId = parser.getText();
                                }
                            }
                        } 
                        teamsDet = [SELECT Id,sales_rep_ids__c  
                                    FROM Team__c 
                                    WHERE team_id__c =: teamId
                                    AND Deleted_From_FF__c = false];
                        if(teamsDet.size() > 0)
                        {
                            teamsDet[0].sales_rep_ids__c = null;
                            //wsLog.Team__c = teamsDet[0].Id;
                            res.setSuccess('User Removed from the Team');
                        }
                        else
                        {
                            res.setError('No user found for given user id and team_id');
                        }
                        update teamsDet;
                    }
                    else{
                        res.setError('Please Specify the userId in the Params');
                    }
                }
                else if(actionType == FitFreedomUrlMappings.USER_AT_UPDATE_REP_BY_USER_ID)
                {
                    wsLog.Operation_Name__c = 'Update Rep By User ID';
                    String userId  = req.params.get(Constants.HTTP_HEADER_ID);
                    String gymId = '';
                    String updateType = '';
                    if(String.isNotBlank(userId)){
                        while (parser.nextToken() != null)
                        {
                            if(parser.getCurrentName() != parser.getText())
                            {
                                if(parser.getCurrentName() == Constants.HTTP_HEADER_GYM_ID)
                                {
                                    gymId = parser.getText();
                                }
                                else if(parser.getCurrentName() == Constants.HTTP_ACTION)
                                {
                                    updateType = parser.getText();
                                }
                            }
                        }
                        
                        if(String.isBlank(gymId)){
                            res.setError('Please Specify the gymId in the request Body');
                            return res;
                        }
                        List<Account> acc = new List<Account>();
                        List<user> users = new List<User>();
                        if(String.isNotBlank(gymId)){
                            acc = [SELECT Id,Deleted_From_FF__c,sales_rep_ids__c
                                   FROM Account
                                   WHERE gym_id__c =: gymId
                                   AND Deleted_From_FF__c = false];
                        }
                        
                        if(String.isNotBlank(userId)){
                            users = [SELECT Id,sales_rep_id__c 
                                     FROM User 
                                     WHERE sales_rep_id__c =: userId];
                        }
                        if(acc.size() > 0){
                            
                            acc[0].sales_rep_ids__c = userid;
                            if(users.size() > 0){
                                acc[0].Sales_Rep_FF__c = users[0].Id;
                            }else{
                                res.setError('User not found found for the given userId');
                            }
                            update acc;
                            
                        }else{
                            res.setError('No Gym found for the given gym_id');
                            return res;
                        }
                        
                    }
                    else{
                        res.setError('Please Specify the userId in the Parmas');
                    }
                }
                
                else if(actionType == FitFreedomUrlMappings.USER_AT_REMOVE_USERS_FROM_GYM)
                { 
                    wsLog.Operation_Name__c = 'Remove Users from Gym';
                    String gymId  = req.params.get('gym_id');
                    String userids = '';
                    
                    if(String.isNotBlank(gymId)){
                        while (parser.nextToken() != null)
                        {
                            if(parser.getCurrentName() != parser.getText())
                            {
                                if(parser.getCurrentName() == Constants.HTTP_USER_ID)
                                {
                                    userids = parser.getText();
                                }
                            }
                        }
                        if(String.isBlank(userids)){
                            res.setError('Please Specify the userId in the request Body');
                            return res;
                        }
                        List<Account> acc = new List<Account>();
                        if(String.isNotBlank(gymId)){
                            acc = [SELECT Id,Deleted_From_FF__c,sales_rep_ids__c
                                   FROM Account
                                   WHERE gym_id__c =: gymId
                                   AND Deleted_From_FF__c = false];
                        }
                        
                        if(acc.size() > 0){
                            acc[0].sales_rep_ids__c = '';
                            acc[0].Sales_Rep_FF__c = null;
                            update acc;
                            
                        }else{
                            res.setError('No Gym found for the given gym_id');
                            return res;
                        }
                    }else{
                        res.setError('Please Specify the gymId in the Params');
                    }
                }
                
                else if(actionType == FitFreedomUrlMappings.USER_AT_ADD_TEAM_TO_USER)
                {
                    wsLog.Operation_Name__c = 'Add Only Team to User';
                    String userId  = req.params.get(Constants.HTTP_HEADER_ID);
                    String teamId = '';
                    String updateType = '';
                    if(String.isNotBlank(userId)){
                        while (parser.nextToken() != null)
                        {
                            if(parser.getCurrentName() != parser.getText())
                            {
                                if(parser.getCurrentName() == 'team_id')
                                {
                                    teamId = parser.getText();
                                }
                                else if(parser.getCurrentName() == Constants.HTTP_ACTION)
                                {
                                    updateType = parser.getText();
                                }
                            }
                        }
                        
                        if(String.isBlank(teamId)){
                            res.setError('Please Specify the TeamId in the request Body');
                            return res;
                        }
                        List<Team__c> teams = new List<Team__c>();
                        List<user> users = new List<User>();
                        if(String.isNotBlank(teamId)){
                            teams = [SELECT Id,Deleted_From_FF__c,sales_rep_ids__c
                                   FROM Team__c
                                   WHERE team_id__c =: teamId
                                   AND Deleted_From_FF__c = false];
                        }
                        
                        if(String.isNotBlank(userId)){
                            users = [SELECT Id,sales_rep_id__c 
                                     FROM User 
                                     WHERE sales_rep_id__c =: userId];
                        }
                        if(teams.size() > 0){
                            
                            teams[0].sales_rep_ids__c = userid;
                            if(users.size() > 0)
                            {
                                //teams[0].FF_Sales_Rep__c = users[0].Id;
                            }
                            else
                            {
                                res.setError('User not found found for the given userId');
                                return res;
                            }
                            update teams;
                            res.setSuccess('User Added to Team Successful');
                        }else{
                            res.setError('No Team found for the given team_id');
                            return res;
                        }
                    }
                    else{
                        res.setError('Please Specify the userId in the Parmas');
                    }
                }
                
                
                else if(actionType == FitFreedomUrlMappings.USER_AT_ADD_GYMS_AND_TEAMS_TO_USER)
                {
                    wsLog.Operation_Name__c = 'Add Gym and Teams to Users';
                    res.message = 'Updated';
                    List<Account> accToUpdate = new List<Account>();
                    List<team__c> teamToUpdate = new List<team__c>();
                    String userid  = req.params.get('user_id');
                    if(String.isNotBlank(userid)){
                        Set<String> gymIds = new Set<String>();
                        Set<String> teamIds = new Set<String>();
                        while (parser.nextToken() != null){
                            if(parser.getCurrentName() != parser.getText()){
                                if(parser.getCurrentName() == 'gym_id'){
                                    gymIds.add(parser.getText());
                                }
                                if(parser.getCurrentName() == 'team_id'){
                                    teamIds.add(parser.getText());
                                }
                            }
                        }
                        
                        List<User> users = [SELECT Id,sales_rep_id__c 
                                            FROM User 
                                            WHERE sales_rep_id__c =: userId];
                        List<Account> acc = new List<Account>();
                        List<Team__c> teams = new List<Team__c>();
                        
                        if(users.size() > 0){
                            if(gymIds.size() > 0){
                                for(Account accs :[SELECT Id, Deleted_From_FF__c FROM Account  WHERE Gym_Id__c IN: gymIds AND Deleted_From_FF__c = false]){
                                    
                                    Account sobjAcc = new Account();
                                    sobjAcc.sales_rep_ids__c = userid;
                                    sobjAcc.Sales_Rep_FF__c = users[0].Id;
                                    sobjAcc.Id = accs.Id;
                                    accToUpdate.add(sobjAcc);
                                    
                                }
                            }else{
                                res.setError('No Gym found for the request body');
                                return res;
                            }
                            if(teamIds.size() > 0){
                                for(Team__c teamDet :[SELECT Id, Team_Id__c FROM Team__c  WHERE Team_Id__c IN: teamIds AND Deleted_From_FF__c = false]){
                                    
                                    Team__c sobjTeam = new Team__c();
                                    sobjTeam.sales_rep_ids__c = userid;
                                    //sobjTeam.FF_Sales_Rep__c = users[0].Id;
                                    sobjTeam.Id = teamDet.Id;
                                    teamToUpdate.add(sobjTeam);
                                }
                                
                            }else{
                                res.setError('No Teams found for the request body');
                                return res;
                            }
                        }else{
                            res.setError('Users not found for given userId');
                            return res;
                        }
                        if(teamToUpdate.size() > 0){
                            update teamToUpdate;    
                        }
                        else{
                            res.setError('No Team found for the Team id');
                            return res;
                        }
                        if(accToUpdate.size() > 0){
                            update accToUpdate;
                        }else{
                            res.setError('No Gym found for the gym id');
                            return res;
                        }
                        
                    }
                    else{
                        res.setError('Please specify the userid in the Params');
                    }
                }*/
                else 
                {
                    res.setError('Resource not found or unsupported action type');
                    wsLog.Operation_Name__c = 'User GET Requests - unsupported action type';    
                }
                
                if(contacts.size() > 0)
                {
                    update contacts;
                }
                
            }else{
                res.setError('Please Provide Valid request Body');
            }
        }
        catch(Exception e)
        {
            res.setError(Constants.HTTP_RESPONSE_FAILED + Constants.CHAR_SPACE + Constants.CHAR_COLON + Constants.CHAR_SPACE + 
                         e.getMessage() + e.getLineNumber());
            wsLog.Operation_Name__c = 'User PUT Requests - Exception';
        }
        wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
        insert wsLog;
        return res;
    }
    
    private static List<Map<String, String>> getUsersMap(List<Contact> contacts)
    {
        List<Map<String, String>> lst = new List<Map<String, String>>();
        Map<String, String> mp = FitFreedomMappings.mapOfAdminSQLAndSFDCFields;
        for(Integer i=0; i<contacts.size(); i++)
        {
            Map<String, String> sc = new Map<String, String>();
            Sobject con = contacts[i];
            for(String s : mp.keySet())
            {
                sc.put(s, String.valueOf(con.get(mp.get(s))));
            }
            lst.add(sc);
        }
        return lst;
    }
    
    global class UserResponseWrapper 
    {
        global List<Map<String, String>> users {get;set;}
        global String status {get;set;}
        global String message {get;set;}
        global Integer statuscode {get;set;}
        
        global UserResponseWrapper()
        {
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