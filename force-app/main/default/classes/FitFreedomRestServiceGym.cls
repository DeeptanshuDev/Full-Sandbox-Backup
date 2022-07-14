/**
*   Purpose         :   Class to have rest resources and services for Fit Freedom App.
*   Created By      :   Ayush Gupta
*   Created Date    :   03/30/2020
*   Revision Log    :   v1.0 - Created - 03/30/2020
**/
@RestResource(urlMapping='/fitfreedomv3Gym/*')
global with sharing class FitFreedomRestServiceGym
{
    //1) Get Gym By ID (GET)
    //2) Get Gym By Raw Query (GET)
    @HttpGet
    global static GymResponseWrapper getGymsFromSFDC() 
    {
        GymResponseWrapper res = new GymResponseWrapper();
        RestRequest req = RestContext.request;
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        try
        {   
            List<Account> accs = new List<Account>();
            String gymId = req.params.get(Constants.HTTP_HEADER_ID);
            if(String.isNotBlank(gymId))
            {
                wsLog.Operation_Name__c = 'Get Gym By ID';
                accs = [SELECT gym_id__c, team_id__c, active__c, Name, gym_type__c, location__c,
                        owner__c, Gym_Owner__c, owner_name__c, sales_rep_ids__c,Deleted_From_FF__c, 
                        created_at__c, modified_at__c
                        FROM Account 
                        WHERE gym_id__c =: gymId 
                        AND Deleted_From_FF__c = false
                       ];
                if(accs.size() > 0)
                {
                    res.setSuccess('Get Gym By ID Successful');
                    wsLog.Account__c = accs[0].Id;
                }
                else 
                {
                    res.setError('No gym found for the given id');        
                }
            }
            else
            {
                wsLog.Operation_Name__c = 'Get Gym By Raw Query';
                accs = [SELECT gym_id__c, team_id__c, active__c, Name, gym_type__c, location__c,
                        owner__c, Gym_Owner__c, owner_name__c, sales_rep_ids__c, Deleted_From_FF__c,
                        created_at__c, modified_at__c
                        FROM Account 
                        WHERE gym_id__c != null 
                        AND Deleted_From_FF__c = false
                       ];
                if(accs.size() > 0)
                {
                    res.setSuccess('Get All Gyms Successful');
                }
                else
                {
                    res.setError('No gym found.');    
                }
            }
            res.gyms = getGymsMap(accs);
        }
        catch(Exception e)
        {            
            res.setError(Constants.HTTP_RESPONSE_FAILED + Constants.CHAR_SPACE + Constants.CHAR_COLON + 
                         Constants.CHAR_SPACE + e.getMessage());
            wsLog.Operation_Name__c = 'Gym GET Requests - Exception';
        }
        wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
        insert wsLog;
        return res;
    }
     
    /* {
    "action" : "update",
    "id"     : "a17be2e7-1b49-4ffe-bba2-11db71f895"
    }*/
    //6) Add Rep From Gym (update)
    //7) Remove Rep From Gym (remove)
    @HttpPut
    global static GymResponseWrapper updateGym() 
    {
        GymResponseWrapper res = new GymResponseWrapper();
        RestRequest req = RestContext.request;
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        try
        {           
            Boolean isUpdate = false;
            Boolean isRemove = false;
            String userId = '';            
            String gymId = req.params.get(Constants.HTTP_HEADER_GYM_ID);
            List<Account> accounts = new List<Account>();
            if(String.isNotBlank(gymId)) 
            {
                accounts = [SELECT Id, sales_rep_ids__c, Sales_Rep_FF__c,Deleted_From_FF__c 
                            FROM Account 
                            WHERE gym_id__c= :gymId
                            AND Deleted_From_FF__c = false];
                Blob body = req.requestBody;
                
                if(body != null) 
                {
                    if(accounts.size() > 0)
                    {
                        wsLog.Account__c = accounts[0].Id;
                        String requestString = body.toString();
                        if(String.isNotBlank(requestString))
                        {
                            JSONParser parser = JSON.createParser(requestString);
                            while (parser.nextToken() != null)
                            {
                                if(parser.getCurrentName() != parser.getText())
                                {
                                    if(parser.getCurrentName() == 'action')
                                    {
                                        if(parser.getText() == 'update')
                                        {
                                            isUpdate=true;
                                        }
                                        else if(parser.getText() == 'remove')
                                        {
                                            isRemove = true;
                                        }
                                    }       
                                    if(parser.getCurrentName() == 'id')
                                    {
                                        userId = parser.getText();
                                    }
                                }
                            }
                            
                            if(String.isNotBlank(userId)) 
                            {
                                if(isRemove)
                                {
                                    accounts[0].sales_rep_ids__c = '';
                                    accounts[0].Sales_Rep_FF__c = null;
                                    res.setSuccess('Removed');
                                }
                                else if(isUpdate)
                                {
                                    accounts[0].sales_rep_ids__c = userId;
                                    res.setSuccess('Updated');
                                    //TODO - We need write out a logic here to fill out "Sales_Rep_FF__c" on account
                                    //by looking for matching User record with sales rep id
                                }
                                update accounts;
                            }
                            else 
                            {
                                res.setError('Please provide the sales rep id for add/remove.');
                            }
                        }
                        else
                        {
                            res.setError('Please provide the valid request body');
                        }    
                    }
                    else
                    {
                        res.setError('No gym found for the corresponding gym_Id');
                    }
                }
                else 
                {
                    res.setError('Please provide the valid request body');
                }
            }
            else 
            {
                res.setError('Please specify gym_id in the request params');
            }
        }
        catch(Exception e)
        {
            res.setError(Constants.HTTP_RESPONSE_FAILED + Constants.CHAR_SPACE + Constants.CHAR_COLON + Constants.CHAR_SPACE + 
                         e.getMessage());
        }
        wsLog.Operation_Name__c = 'Add/Remove Rep From Gym';
        wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
        insert wsLog;
        return res;
    }
    
    /*{
        "gym": {
            "gym_name":"5 Star Athletics",
            "gym_type": "All Star",
            "location": "Atlanta",
            "gym_Id": "545b5091-7f8b-404b-8d8a-4232",
            "active": "true",
            "owner": "m845b5091-7f8b-404b-8d8a-124",
            "owner_name": "alex",
            "Sales_rep_ids": "a17be2e7-1b49-4ffe-bba2-11db71f3881e",
            "Created_at": "2008-01-01 00:00:00",
            "modified_at": "2008-01-01 00:00:00"
        },
        "admin": {
            "email":"test@sdf.com",
            "first_name": "",
            "last_name": "Cathy",
            "gym_id": "545b5091-7f8b-404b-8d8a-4232",
            "member_id": "m845b5091-7f8b-404b-8d8a-124"
        },
        "team": {
            "team_id" : "d250330f-1906-4175-a874-67a608fef44e",
            "team_name": "Cheer Abilities",
            "gym_id" : "545b5091-7f8b-404b-8d8a-4232",
            "member_count" : "3",
            "created_at" : "",
            "modified_at" : ""
        }
    }*/
    //3) Create New Gym - Completed
    @HttpPost
    global static GymResponseWrapper insertGymAtSFDC()
    {
        Savepoint sp = Database.setSavepoint();
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        GymResponseWrapper res = new GymResponseWrapper();
        RestRequest req = RestContext.request;
        try 
        { 
            Blob body = req.requestBody;
            if(body != null) 
            {
                String requestString = body.toString();
                if(String.isNotBlank(requestString))
                {
                    JSONParser parser = JSON.createParser(requestString);           
                    Set<String> bypassValues = new Set<String>{null, '{' , '}' };
                    Set<String> setSQLObject = new Set<String>{'gym', 'admin', 'team' };
                    String currentObject = null;
                    
                    Boolean isGymNodeDoesNotExists = false;
                    Boolean isAdminNodeDoesNotExists = false;
                    Boolean isTeamNodeDoesNotExists = false;
                    
                    Sobject sobjGym = new Account();
                    Sobject sobjAdmin = new Contact();
                    Sobject sobjTeam = new Rosters__c();
                    
                    String sales_rep_id  ='';
                    String gym_owner_id  ='';
                    String gym_id = '';
                    String gym_name = '';
                    
                    String member_id = '';
                    String last_name = '';
                    String gym_id_owner = '';
                    
                    String team_id = '';
                    String team_name = '';
                    String gym_id_team = '';
                    
                   
                    
                    System.Debug('Parser = ' + String.valueOf(parser));
                    while (parser.nextToken() != null)
                    {
                        if(bypassValues.contains(parser.getCurrentName())  || bypassValues.contains(parser.getText()))
                        {
                            continue;
                        }
                        else if(parser.getCurrentName() == parser.getText() && setSQLObject.contains(parser.getCurrentName()))
                        {
                            currentObject = parser.getCurrentName();
                            continue;
                        }
                        
                        if(parser.getCurrentName() != parser.getText() && currentObject != null)
                        {                    
                            //Handling Gym
                            if(currentObject.equalsIgnoreCase(Constants.GYM_SQLOBJECT))
                            {
                                if(FitFreedomMappings.mapOfGymSQLAndSFDCFields.containskey(parser.getCurrentName()))
                                {
                                    if(parser.getCurrentName() == 'gym_id')
                                    {
                                        gym_id = parser.getText();
                                    }  
                                    
                                    if(parser.getCurrentName() == 'gym_name')
                                    {
                                        gym_name = parser.getText();
                                    }
                                    if(parser.getCurrentName() == 'owner')
                                    {
                                        gym_owner_id = parser.getText();
                                    }
                                    if(parser.getCurrentName() == 'sales_rep_ids')
                                    {
                                        sales_rep_id = parser.getText();
                                    }
                                    
                                    sobjGym.put(FitFreedomMappings.mapOfGymSQLAndSFDCFields.get(parser.getCurrentName()),parser.getText());
                                }
                            }
                            else 
                            {
                                isGymNodeDoesNotExists = true;    
                            }
                            
                            //Handling Admin
                            if(currentObject.equalsIgnoreCase(Constants.ADMIN_SQLOBJECT))
                            {
                                
                                if(FitFreedomMappings.mapOfAdminSQLAndSFDCFields.containskey(parser.getCurrentName()))
                                {
                                    if(parser.getCurrentName() == 'member_id')
                                    {
                                        member_id = parser.getText();
                                    }
                                    if(parser.getCurrentName() == 'last_name')
                                    {
                                        last_name = parser.getText();
                                    }
                                    if(parser.getCurrentName() == 'gym_id')
                                    {
                                        gym_id_owner = parser.getText();
                                    }
                                    sobjAdmin.put(FitFreedomMappings.mapOfAdminSQLAndSFDCFields.get(parser.getCurrentName()),parser.getText());
                                }
                            }
                            else 
                            {
                                isAdminNodeDoesNotExists = true;    
                            }
                            
                            //Handling Team
                            if(currentObject.equalsIgnoreCase(Constants.TEAM_SQLOBJECT))
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
                                        gym_id_team = parser.getText();
                                    }
                                    sobjTeam.put(FitFreedomMappings.mapOfTeamSQLAndSFDCFields.get(parser.getCurrentName()), parser.getText());  
                                }
                            }
                            else 
                            {
                                isTeamNodeDoesNotExists = true;    
                            }
                        }
                    }
                   
                    //Filling Defaualt Field Values
                    sobjAdmin.put('fit_freedom_Type__c', 'Owner'); 
                    
                    //Apply required and showing errors for negative use cases
                    if(String.isBlank(gym_id)) 
                    {
                        res.setError('please specify gym_id for the gym in the request body');
                        Database.rollback(sp);
                        return res;
                    }
                    if(String.isBlank(gym_name)) 
                    {
                        res.setError('please specify gym_name for the gym in the request body');
                        Database.rollback(sp);
                        return res;
                    }   
                    
                    if(String.isBlank(member_id)) 
                    {
                        res.setError('please specify member_id for gym owner in the request body');
                        Database.rollback(sp);
                        return res;
                    }
                    
                    if(String.isBlank(last_name))
                    {
                        res.setError('please specify last_name for gym owner in the request body');
                        Database.rollback(sp);
                        return res;
                    }
                    
                    if(String.isBlank(gym_owner_id))
                    {
                        res.setError('please specify ownerid for gym owner in the request body');
                        Database.rollback(sp);
                        return res;
                    }
                    
                    if(String.isBlank(gym_id_owner)) 
                    {
                        res.setError('please specify gym_id for gym owner in the request body');
                        Database.rollback(sp);
                        return res;
                    }   
                    
                    if(String.isBlank(team_id)) 
                    {
                        res.setError('please specify team_id for team in the request body');
                        Database.rollback(sp);
                        return res;
                    }
                    
                    if(String.isBlank(team_name)) 
                    {
                        res.setError('please specify team_name for team in the request body');
                        Database.rollback(sp);
                        return res;
                    } 
                    
                    if(String.isBlank(gym_id_team)) 
                    {
                        res.setError('please specify gym_id for team in the request body');
                        Database.rollback(sp);
                        return res;
                    }    
                    
                    List<Rosters__c> teams = new List<Rosters__c>();
                    List<Contact> contacts = new List<Contact>();
                    List<Account> accounts = new List<Account>();
                    List<Contact> conSales = new list<contact>();
                    if(String.isNotBlank(team_id)) 
                    {
                        teams = [SELECT Id,Deleted_From_FF__c 
                                 FROM Rosters__c 
                                 WHERE rosters_id__c =: team_id 
                                 AND Deleted_From_FF__c = false];
                    }
                    
                    if(String.isNotBlank(sales_rep_id)){
                        conSales = [SELECT Id,Deleted_From_FF__c,FF_Sales_Rep_FF__c 
                                    FROM Contact 
                                    WHERE user_Id__c =: sales_rep_id 
                                    AND Deleted_From_FF__c = false];
                    }
                    if(String.isNotBlank(member_id)) 
                    {
                        contacts = [SELECT Id,Deleted_From_FF__c 
                                    FROM Contact 
                                    WHERE Member_Id__c =: member_id 
                                    AND Deleted_From_FF__c = false];
                    }
                    
                    if(String.isNotBlank(gym_id)) 
                    {
                        accounts = [SELECT Id,Deleted_From_FF__c 
                                    FROM Account 
                                    WHERE Gym_Id__c =: gym_id 
                                    ];
                    }   
                    
                    if(accounts.size() > 0)
                    {
                        if(accounts[0].Deleted_From_FF__c == true)
                        {
                            res.setError('unable to find a gym for the gym_id');
                            return res;
                        }else{
                            sobjGym.put('Id', accounts[0].id);
                        }
                    }
                    
                    if(conSales.size() > 0){
                        sobjGym.put('Sales_Rep_FF__c', conSales[0].FF_Sales_Rep_FF__c);
                    }
                    upsert sobjGym;  
                    
                    wsLog.Account__c = sobjGym.Id; 
                    Map<String, Id> mapContact = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Contact', 'gym_id__c', new Set<String>{(String)sobjAdmin.get('gym_id__c')});
                    
                    if(mapContact != null && mapContact.values().size() > 0) 
                    {
                        sobjAdmin.put('AccountId', mapContact.get(String.valueOf(sobjGym.get('gym_id__c'))));        
                    }
                    else 
                    {
                        res.setError('unable to find a gym for the gym_id that we have in the request body');
                        Database.rollback(sp);
                        return res;
                    }
                    
                    if(contacts.size() > 0)
                    {
                        sobjAdmin.put('Id', contacts[0].id); 
                    }
                    upsert sobjAdmin; 
                    
                    if(String.isNotBlank(gym_owner_id))
                    { 
                        for(Contact cons : [Select id, Deleted_From_FF__c 
                                            FROM Contact 
                                            WHERE member_id__c =: gym_owner_id 
                                            AND Deleted_From_FF__c = false])
                        {
                            sobjGym.put('gym_owner__c',cons.Id);
                        }
                        update sobjGym;
                    }
                    Map<String, Id> mapTeam = ExternalIdFieldMetaDataMapping.getTargetObjectRecordIds('Rosters__c', 'gym_id__c', new Set<String>{(String)sobjTeam.get('gym_id__c')});
                    if(mapTeam != null && mapTeam.values().size() > 0) 
                    {
                        sobjTeam.put('Account__c', mapTeam.get(String.valueOf(sobjGym.get('gym_id__c'))));       
                    }
                    else 
                    {
                        res.setError('unable to find a gym for the gym_id that we have in the request body');
                        Database.rollback(sp);
                        return res;
                    }
                    if(teams.size() > 0)
                    {
                        sobjTeam.put('Id', teams[0].id);
                    }
                    /*sobjTeam.put('StageName', 'New');
                    sobjTeam.put('Type', 'New Order');
                    sobjTeam.put('Primary_Contact__c', null);
                    sobjTeam.put('Collection_Picklist__c', 'N/A');
                    sobjTeam.put('Category_Picklist__c', 'All Star');
                    sobjTeam.put('CloseDate', system.today() + 30);
                     */
                    upsert sobjTeam;
                    
                    res.setSuccess(Constants.HTTP_RESPONSE_CREATED + Constants.CHAR_SPACE + Constants.CHAR_COLON + 
                                   Constants.CHAR_SPACE + 'Gym Created Successful');  
                }
                else
                {
                    res.setError('Please Provide Valid Request Body');
                }
            }
            else
            {
                res.setError('Please Provide Valid Request Body');
            }
        }
        catch(Exception e) 
        {
            Database.rollback(sp);
            res.setError(e.getMessage() + e.getStackTraceString());
        }
        wsLog.Operation_Name__c = 'Create New Gym';
        wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
        insert wsLog;
        return res;
    }
    
    //5) Remove Gym By ID - Completed
    @HttpDelete
    global static GymResponseWrapper deleteGymByIdInSFDC() 
    {
        GymResponseWrapper res = new GymResponseWrapper();
        RestRequest req = RestContext.request;
        Web_Service_Log__c wsLog = new Web_Service_Log__c();
        try
        {
            List<Account> accToBeDelete = new List<Account>();
            String gymId = req.params.get(Constants.HTTP_HEADER_ID);
            if(String.isNotBlank(gymId))
            {
                accToBeDelete = [SELECT ID,Deleted_From_FF__c  
                                 FROM Account 
                                 WHERE Gym_Id__c =: gymId
                                 AND Deleted_From_FF__c = false
                                ];
                
                if(accToBeDelete.size() > 0)
                {
                    accToBeDelete[0].Deleted_From_FF__c = true;
                    update accToBeDelete;
                    wsLog.Account__c = accToBeDelete[0].Id;
                    res.setSuccess(constants.HTTP_GYM_DELETE_RESPONSE);
                }
                else
                {
                    res.setError('Unable to find gym to delete for the mentioned gym_id.');
                }
            }
            else
            {
                res.setError('Please specify a gym_id.');
            }
        }
        catch(Exception e)
        {
            res.setError(Constants.HTTP_RESPONSE_FAILED + Constants.CHAR_SPACE + Constants.CHAR_COLON + Constants.CHAR_SPACE + 
                         e.getMessage());
        }
        wsLog.Operation_Name__c = 'Remove Gym By ID';
        wsLog = WebServiceLogs.populateWebServiceLogDetails(req, JSON.serialize(res), wsLog);
        insert wsLog;
        return res;
    }
    
    private static List<Map<String, String>> getGymsMap(List<Account> accs)
    {
        List<Map<String, String>> lst = new List<Map<String, String>>();
        Map<String, String> mp = FitFreedomMappings.mapOfGymSQLAndSFDCFields;
        for(Integer i=0; i<accs.size(); i++)
        {
            Map<String, String> sc = new Map<String, String>();
            Sobject acc = accs[i];
            for(String s : mp.keySet())
            {
                sc.put(s , String.valueOf(acc.get(mp.get(s))));
            }
            lst.add(sc);
        }
        return lst;
    }
    
    global class GymResponseWrapper
    {
        global List<Map<String, String>> gyms {get;set;}
        global String status {get;set;}
        global Integer statuscode {get;set;}
        global String message {get;set;}
        
        global GymResponseWrapper()
        {
            gyms = new List<Map<String, String>>();
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