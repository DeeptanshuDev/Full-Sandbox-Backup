/**
*   Purpose         :   Class to have rest resources and services for Fit Freedom App.
*   Created By      :   Ayush Gupta
*   Created Date    :   04/06/2020
*   Revision Log    :   v1.0 - Created - 04/06/2020
**/
@RestResource(urlMapping='/fitfreedomv3Team/*')
global class FitFreedomRestServiceTeam 
{
    @HttpGet
    global static TeamResponseWrapper getTeamFromSFDC() 
    {
        TeamResponseWrapper res = new TeamResponseWrapper();
        RestRequest req = RestContext.request;
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        List<Rosters__c> teamList = new List<Rosters__c>();
        try
        {        
            String actionType = req.requestURI.subStringbetween('/fitfreedomv3Team/', '/');
            
            //Get All Teams
            if(actionType == FitFreedomUrlMappings.TEAM_AT_GET_ALL_TEAMS)
            {
                wsLog.Operation_Name__c = 'Get All Teams';
                teamList = [SELECT rosters_id__c, Name, gym_id__c,Deleted_From_FF__c, member_count__c, 
                            created_at__c, modified_at__c, sales_rep_ids__c, coach_ids__c
                            FROM Rosters__c 
                            WHERE Deleted_From_FF__c = false
                           ];
                if(teamList.size() > 0)
                {
                    res.setSuccess('Get All Teams Successful');
                }
                else
                {
                    res.setError('No Teams found.');    
                }
            }
            
            //Get Team by Team ID
            else if(actionType == FitFreedomUrlMappings.TEAM_AT_GET_TEAM_BY_ID)
            {            
                wsLog.Operation_Name__c = 'Get Team by Team ID';
                String reqId = req.params.get(Constants.HTTP_TEAM_ID);
                if(String.isNotBlank(reqId))
                {
                    teamList = [SELECT rosters_id__c, Name, gym_id__c,Deleted_From_FF__c, member_count__c, 
                                created_at__c, modified_at__c, sales_rep_ids__c, coach_ids__c
                                FROM Rosters__c 
                                WHERE rosters_id__c	 =: reqId
                                AND Deleted_From_FF__c = false
                               ];
                    if(teamList.size() > 0)
                    {
                        wsLog.Rosters__c = teamList[0].Id;
                        res.setSuccess('Get Team by Team ID Successful');
                    }
                    else
                    {
                        res.setError('No Team found for given TeamId');
                    }
                }
                else
                {
                    res.setError('Please specify a team_id in request params.');
                }
            }
            
            //Get Teams by Gym ID
            else if(actionType == FitFreedomUrlMappings.TEAM_AT_GET_TEAM_BY_GYM_ID)
            {
                wsLog.Operation_Name__c = 'Get Teams by Gym ID';
                String gymId = req.params.get(Constants.HTTP_GYM_ID);
                if(String.isNotBlank(gymId))
                {
                    teamList = [SELECT rosters_id__c, Name, gym_id__c,Deleted_From_FF__c, member_count__c, 
                                created_at__c, modified_at__c, sales_rep_ids__c, coach_ids__c
                                FROM Rosters__c
                                WHERE gym_id__c =:gymId
                                AND Deleted_From_FF__c = false
                               ];
                    if(teamList.size() > 0)
                    {
                        res.setSuccess('Get Teams by Gym ID Successful');
                    }
                    else
                    {
                        res.setError('No team found for given gym_id.');
                    }
                }
                else
                {
                    res.setError('Please specify a gym_id in request params.');
                }
            }
            else
            { 
                res.setError('Resource Not Found or unsupported action type.');
                wsLog.Operation_Name__c = 'Team GET Requests - unsupported action type';
            }
            res.teams = getTeamsMap(teamList);
        }
        catch(Exception e)
        {
            res.setError(Constants.HTTP_RESPONSE_FAILED + Constants.CHAR_SPACE + Constants.CHAR_COLON 
                         + Constants.CHAR_SPACE + e.getMessage());
            wsLog.Operation_Name__c = 'Team GET Requests - Exception';
        }
        wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
        insert wsLog;
        return res;
    }
    
    /*  {
    "team_id" : "d250330f-1906-4175-a874-67a608fef4098",
    "gym_id" : "545b5091-7f8b-404b-8d8a-4232",
    "member_count" : "3",
    "team_name" : "Fusion All Star",
    "created_at":"",
    "modified_at":""
    }*/
    //Create New Team
    @HttpPost
    global static TeamResponseWrapper insertTeamAtSFDC()
    {
        TeamResponseWrapper res = new TeamResponseWrapper();
        RestRequest req = RestContext.request;
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        try 
        {
            String team_id = '';
            String gym_id = '';
            String team_name = '';
            Blob body = req.requestBody;
            
            if(body != null)
            {
                JSONParser parser = JSON.createParser(body.toString());
                List<Opportunity> teams = new List<Opportunity>(); 
                Rosters__c sobjTeam = new Rosters__c();
                
                while (parser.nextToken() != null) 
                {
                    if(parser.getCurrentName() != parser.getText())
                    {                    
                        if(FitFreedomMappings.mapOfTeamSQLAndSFDCFields.containskey(parser.getCurrentName()))
                        {
                            if(parser.getCurrentName() == 'team_id')
                            {
                                team_id = parser.getText();
                            }
                            if(parser.getCurrentName() == 'team_name')
                            {
                                team_name = parser.getText();
                            }
                            if(parser.getCurrentName() == 'gym_id')
                            {
                                gym_id = parser.getText();
                            }   
                            sobjTeam.put(FitFreedomMappings.mapOfTeamSQLAndSFDCFields.get(parser.getCurrentName()),parser.getText());
                        }
                    }
                }
                
                if(String.isBlank(team_id)) 
                {
                    res.setError('please specify team_id for the team in the request body');
                    return res;
                }
                
                if(String.isBlank(team_name)) 
                {
                    res.setError('please specify team_name for the team in the request body');
                    return res;
                } 
                
                if(String.isBlank(gym_id)) 
                {
                    res.setError('please specify gym_id for the team in the request body');
                    return res;
                } 
                
                List<Rosters__c> teamDetails = new List<Rosters__c>();
                res.tId = team_id;
                if(String.isNotBlank(team_id)) 
                {
                    teamDetails = [SELECT Id 
                                   FROM Rosters__c 
                                   WHERE rosters_id__c =: team_id
                                   AND Deleted_From_FF__c = false
                                  ];
                }
                
                if(teamDetails.size() > 0)
                {
                    res.Id = teamDetails[0];
                    sobjTeam.put('Id', teamDetails[0].Id);
                }else{
                    res.Id = sobjTeam;
                }
                
                Map<String, Id> mapTeams = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Rosters__c', 'gym_id__c', new Set<String>{(String)sobjTeam.get('gym_id__c')});
                
                if(mapTeams != null && mapTeams.values().size() > 0) 
                {
                    sobjTeam.put('Account__c', mapTeams.get((String)sobjTeam.get('gym_id__c')));
                }
                else
                {
                    res.setError('unable to find a gym for the gym_id that we have in the request body');
                    return res;
                }
                /*sobjTeam.put('StageName', 'New');
                sobjTeam.put('Type', 'New Order');
                sobjTeam.put('Primary_Contact__c', null);
                sobjTeam.put('Collection_Picklist__c', 'N/A');
                sobjTeam.put('Category_Picklist__c', 'All Star');
                sobjTeam.put('CloseDate', system.today() + 30);*/
                upsert sobjTeam;
                wsLog.Rosters__c = sobjTeam.Id;
                res.setSuccess('Team Created Successful');
            }
            else
            {
                res.setError('Please provide the valid request body');
            }
        }
        catch(Exception e) 
        {
            res.setError(Constants.HTTP_RESPONSE_FAILED + Constants.CHAR_SPACE + Constants.CHAR_COLON + 
                         Constants.CHAR_SPACE + e.getMessage());
        }
        wsLog.Operation_Name__c = 'Create New Team';
        wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
        insert wsLog;
        return res;
    }
    
    @HttpPut
    global static TeamResponseWrapper updateTeam()
    {
        TeamResponseWrapper res = new TeamResponseWrapper();
        RestRequest req = RestContext.request;
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        Sobject sobjToBeUpsert = new Contact();
        try
        {            
            String actionType = req.requestURI.subStringbetween('/fitfreedomv3Team/', '/');
            
            /*
            * {
                id=d250330f-1906-4175-a874-67a608fef4098 (Team Id)
              }
            * 
            * {
                "member_id": "92028c2a-d4e1-4d30-8740-86a58dd06a10"  
              }
            * 
            */
            //Handling Add Coach To Team
            if(actionType == FitFreedomUrlMappings.TEAM_AT_ADD_COACH_TO_TEAM)
            {
                wsLog.Operation_Name__c = 'Add Coach to Team';
                String teamId = req.params.get(Constants.HTTP_HEADER_ID);
                String coachId = '';
                if(String.isNotBlank(teamId))
                {
                    Blob body = req.requestBody;
                    if(body != null)
                    {
                        JSONParser parser = JSON.createParser(body.toString());
                        while (parser.nextToken() != null) 
                        {
                            if(parser.getCurrentName() != parser.getText())
                            {
                                if(parser.getCurrentName() == 'member_id')
                                {
                                    coachId = parser.getText();
                                }     
                            }
                        }
                        List<contact> contacts = new List<contact>();
                        if(String.isBlank(coachId))
                        {
                            res.setError('please specify coachId for the Team in the request body');
                            return res;
                        }
                        if(String.isNotBlank(coachId))
                        {
                            contacts = [SELECT Id 
                                        FROM Contact 
                                        WHERE member_id__c =: coachId
                                        AND Deleted_From_FF__c = false
                                       ];
                        }
                        
                        
                        if(contacts.size() > 0)
                        {
                            Map<String, Id> mapContact = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Contact', 'team_id__c', new Set<String>{teamId});
                            if(mapContact != null && mapContact.values().size() > 0) 
                            {
                                sobjToBeUpsert.put('Id',contacts[0].Id);  
                                sobjToBeUpsert.put('team_id__c', teamId);
                                sobjToBeUpsert.put('Rosters__c', mapContact.get(teamId));
                                upsert sobjToBeUpsert;
                                res.setSuccess('Coach Added to the Team Successful');
                                wsLog.Rosters__c = mapContact.get(teamId);
                            }
                            else
                            {
                                res.setError('unable to find a team for the team_id that we have in the request body');
                                return res;
                            }
                        }
                        else
                        {
                            res.setError('No Coach Found for given Coach Id');
                            return res;
                        }
                    }
                    else
                    {
                        res.setError('Please provide the valid request body');
                    }
                }
                else
                {
                    res.setError('Please specify team_id in request params.');
                }
            } 
            
            /*
            * * {
                id=d250330f-1906-4175-a874-67a608fef4098 (Team Id)
            }
            * 
            * {
                "member_id": "92028c2a-d4e1-4d30-8740-86a58dd06a10"  
            }
            * 
            */
            //Handling Remove Coach From Team
            else if(actionType == FitFreedomUrlMappings.TEAM_AT_REMOVE_COACH_FROM_TEAM)
            {
                
                wsLog.Operation_Name__c = 'Remove Coach From Team';
                String teamId = req.params.get(Constants.HTTP_HEADER_ID);
                String coachId = '';
                if(String.isNotBlank(teamId))
                {
                    Blob body = req.requestBody;
                    if(body != null)
                    {
                        JSONParser parser = JSON.createParser(body.toString());
                        while (parser.nextToken() != null) 
                        {
                            if(parser.getCurrentName() != parser.getText())
                            {
                                if(parser.getCurrentName() == 'member_id')
                                {
                                    coachId = parser.getText();
                                }     
                            }
                        }
                        if(String.isBlank(coachId))
                        {
                            res.setError('please specify coachId for the Team in the request body');
                            return res;
                        }
                        List<contact> contacts = new List<contact>();
                        if(String.isNotBlank(coachId))
                        {
                            contacts = [SELECT Id, Rosters__c 
                                        FROM Contact 
                                        WHERE member_id__c =: coachId
                                        AND Deleted_From_FF__c = false
                                       ];
                        }
                        
                        if(contacts.size() > 0)
                        {
                            sobjToBeUpsert.put('Rosters__c', '');
                            sobjToBeUpsert.put('Id',contacts[0].Id);  
                            
                            sobjToBeUpsert.put('Deleted_From_FF__c',true);
                            wsLog.Rosters__c = contacts[0].Rosters__c;
                            update sobjToBeUpsert;
                            res.setSuccess('Coach is removed from the Team');
                        }
                        else
                        {
                            res.setError('No Coach Found for given Coach Id');
                            return res;
                        }
                    }
                    else
                    {
                        res.setError('Please provide valid request body');
                    }
                }
                else
                {
                    res.setError('lease specify team_id in request params.');
                }
            }
            
            /*
            *  {
                id=d250330f-1906-4175-a874-67a608fef4098 (Team Id)
            }
            * 
            * 
            * {
                "team_name":"The Mighty Ameobas"
            } 
            *
            */
            //Handling Edit Team Name
            else if(actionType == FitFreedomUrlMappings.TEAM_AT_EDIT_TEAM_NAME)
            {
                wsLog.Operation_Name__c = 'Edit Team Name';
                String teamId = req.params.get(Constants.HTTP_HEADER_ID);
                String name ='';
                if(String.isNotBlank(teamId))
                {
                    Blob body = req.requestBody;
                    if(body != null)
                    {
                        JSONParser parser = JSON.createParser(body.toString());
                        while (parser.nextToken() != null) 
                        {
                            if(parser.getCurrentName() != parser.getText())
                            {
                                if(parser.getCurrentName() == 'team_name')
                                {
                                    name = parser.getText();
                                }     
                            }
                        }
                        if(String.isBlank(name))
                        {
                            res.setError('please specify Team Name for the Team in the request body');
                            return res;
                        }
                        
                        List<Rosters__c> teams = [SELECT Id, Name, rosters_id__c 
                                               FROM Rosters__c 
                                               WHERE rosters_id__c =: teamId
                                               AND Deleted_From_FF__c = false
                                              ];                        
                        if(teams.size() > 0)
                        {
                            teams[0].Name = name;
                            wsLog.Rosters__c = teams[0].Id;
                            update teams;
                            res.setSuccess('Team Name updated');
                        }
                        else
                        {
                            res.setError('No Team found for given team id');
                        }
                    }
                    else
                    {
                        res.setError('Please provide valid request body');
                    }
                }
                else
                {
                    res.setError('Please specify team_id in request params.');
                }
            }
            
            /*
            * {
                id=d250330f-1906-4175-a874-67a608fef4098 (Team Id)
            }
            * 
            * {
                "action":"remove",
                "sales_rep_ids": "0f506b95-c8a0-40d5-989e-0bd814f1049c" 
            } 
            */
            else if(actiontype == FitFreedomUrlMappings.TEAM_AT_MODIFY_SALES_REP)
            {
                wsLog.Operation_Name__c = 'Modify list of sales rep for team';    
                Boolean isUpdate = false;
                Boolean isRemove = false;
                String teamId = req.params.get(Constants.HTTP_HEADER_ID);
                String salesrepIds ='';
                List<Rosters__c> teams = new List<Rosters__c>();
                if(String.isNotBlank(teamId))
                {
                    teams = [SELECT Id,sales_rep_ids__c 
                             FROM Rosters__c
                             WHERE rosters_id__c =: teamId
                             AND Deleted_From_FF__c = false
                            ];
                    Blob body = req.requestBody;
                    if(body != null)
                    {
                        if(teams.size() > 0)
                        {
                            JSONParser parser = JSON.createParser(body.toString());
                            while (parser.nextToken() != null) 
                            {
                                if(parser.getCurrentName() != parser.getText())
                                {
                                    if(parser.getCurrentName() == 'action')
                                    {
                                        if(parser.getText() == 'add')
                                        {
                                            isUpdate=true;
                                        }
                                        else if(parser.getText() == 'remove')
                                        {
                                            isRemove = true;
                                        }
                                    }
                                    if(parser.getCurrentName() == 'sales_rep_ids')
                                    {
                                        salesrepIds = parser.getText();
                                    }     
                                }
                            }
                            if(String.isNotBlank(salesrepIds)) 
                            {
                                if(isRemove)
                                {
                                    teams[0].sales_rep_ids__c = '';
                                    res.setSuccess('Removed');
                                }
                                else if(isUpdate)
                                {
                                    teams[0].sales_rep_ids__c = salesrepIds;
                                    res.setSuccess('Updated');
                                    //TODO - We need write out a logic here to fill out "Sales_Rep_FF__c" on team
                                    //by looking for matching User record with sales rep id
                                }
                                else
                                {
                                    res.setError('Please provide Add/remove action in request body');
                                }
                            }
                            else 
                            {
                                res.setError('Please provide the sales rep id for add/remove.');
                            }
                            update teams;
                        }
                        else
                        {
                            res.setError('No teams found for the corresponding team_Id');
                        }
                    }
                    else
                    {
                        res.setError('Please provide valid request body');
                    }
                }
                else
                {
                    res.setError('Please specify team_id in request params.');
                }
            }
            else
            {
                res.setError('Resource Not Found or unsupported operation.');
            }
        }
        catch(Exception e) 
        {
            res.setError(Constants.HTTP_RESPONSE_FAILED + Constants.CHAR_SPACE + Constants.CHAR_COLON + Constants.CHAR_SPACE + 
                         e.getMessage()+e.getLineNumber());
        }
        wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
        insert wsLog;
        return res;
    }
    
    private static List<Map<String, String>> getTeamsMap(List<Rosters__c> accs)
    {
        List<Map<String, String>> lst = new List<Map<String, String>>();
        Map<String, String> mp = FitFreedomMappings.mapOfTeamSQLAndSFDCFields;
        for(Integer i=0; i<accs.size(); i++)
        {
            Map<String, String> sc = new Map<String, String>();
            Sobject acc = accs[i];
            System.debug(acc.get('Name'));
            for(String s : mp.keySet())
            {
                sc.put(s , String.valueOf(acc.get(mp.get(s))));
            }
            lst.add(sc);
        }
        return lst;
    }
    
    global class TeamResponseWrapper 
    {
        global  List<Map<String, String>> teams {get;set;}
        global Integer statuscode {get;set;}
        global String status {get;set;}
        global String message {get;set;}
        global Rosters__c id {get;set;}
        global string tId {get;set;}
        global TeamResponseWrapper()
        {
            teams = new List<Map<String, String>>();
            statuscode = 200;
            status = Constants.HTTP_RESPONSEWRAPPER_STATUS_SUCCESS;
            message = Constants.HTTP_RESPONSEWRAPPER_STATUS_SUCCESS;
        }
        
        global void setSuccess(String str)
        {
            statuscode = 200;
            message = str;
            status = Constants.HTTP_RESPONSEWRAPPER_STATUS_SUCCESS;
        }
        
        
        global void setError(String str)
        {
            statuscode = 400;
            message = str;
            status = Constants.HTTP_RESPONSEWRAPPER_STATUS_FAIL;
        }
    }
}