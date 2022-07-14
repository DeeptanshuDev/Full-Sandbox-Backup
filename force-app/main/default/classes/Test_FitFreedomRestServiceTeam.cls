/**
*   Description     :   Apex Test class for FitFreedomRestServiceTeam
*
*   Created By      :   
*
*   Created Date    :   05/20/2020
* 
*   Version         :   v1.0 - Created - 05/20/2020
*  
*   Coverage        :   98%
**/
@isTest
public class Test_FitFreedomRestServiceTeam
{

	//Valid Get All Team
    @isTest
    public static void valid_GetAllTeam()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_GET_ALL_TEAMS, 'GET', null, null, null);
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.getTeamFromSFDC();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        System.assertEquals(2, res.teams.size());
        
        Test.stopTest();
    }
	
	//inValid Get All Team
    @isTest
    public static void inValid_NoActionTypeSet_GetAllTeam()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(null, 'GET', null, null, null);
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.getTeamFromSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        Test.stopTest();
    }
	
	//inValid Get All Team
    @isTest
    public static void inValid_RandomActionTypeSet_GetAllTeam()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest('xyz', 'GET', null, null, null);
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.getTeamFromSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        Test.stopTest();
    }
	
	//inValid Get All Team
    @isTest
    public static void inValid_NoREcorInserted_GetAllTeam()
    {
        //Inserting Record
		//createRecord('1');
		//createRecord('2');
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_GET_ALL_TEAMS, 'GET', null, null, null);
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.getTeamFromSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        Test.stopTest();
    }
	
	//inValid Get All Team
    @isTest
    public static void inValid_RecordUpdatedToDeleted_GetAllTeam()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
		List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(2, teams.size());
		for(Rosters__c tm : teams)
		{
			tm.Deleted_From_FF__c = true;
		}
		update teams;
            
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_GET_ALL_TEAMS, 'GET', null, null, null);
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.getTeamFromSFDC();
        
        Test.stopTest();       
    }
	
	//Valid Get Team By ID
    @isTest
    public static void Valid_GetTeamById()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_GET_TEAM_BY_ID, 'GET', null, Constants.HTTP_TEAM_ID, '111-team-111');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.getTeamFromSFDC();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        System.assertEquals(1, res.teams.size());
        
        Test.stopTest();
    }
	
	//inValid Get Team By ID
    @isTest
    public static void inValid_BlankTeamId_GetTeamById()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_GET_TEAM_BY_ID, 'GET', null, Constants.HTTP_TEAM_ID, '');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.getTeamFromSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        Test.stopTest();
    }
	
	//inValid Get Team By ID
    @isTest
    public static void inValid_NullTeamID_GetTeamById()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_GET_TEAM_BY_ID, 'GET', null, null, null);
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.getTeamFromSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        Test.stopTest();
    }
	
	//inValid Get Team By ID
    @isTest
    public static void inValid_RandomTeamId_GetTeamById()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_GET_TEAM_BY_ID, 'GET', null, Constants.HTTP_TEAM_ID, 'xyz');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.getTeamFromSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        Test.stopTest();
    }
	
	//inValid Get Team By ID
    @isTest
    public static void inValid_RandomParam_GetTeamById()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_GET_TEAM_BY_ID, 'GET', null, 'xyz', '111-team-111');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.getTeamFromSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        Test.stopTest();
    }
	
	//inValid Get Team By ID
    @isTest
    public static void inValid_UpdatingDeleted_GetTeamById()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
		List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(2, teams.size());
		for(Rosters__c tm : teams)
		{
			tm.Deleted_From_FF__c = true;
		}
		update teams;
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_GET_TEAM_BY_ID, 'GET', null, Constants.HTTP_TEAM_ID, '111-team-111');
        
        //Calling Method
		Test.startTest();
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.getTeamFromSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
		Test.stopTest();
    }
	
	//inValid Get Team By ID
    @isTest
    public static void inValid_NoRecordInserted_GetTeamById()
    {
        //Inserting Record
		//createRecord('1');
		//createRecord('2');
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_GET_TEAM_BY_ID, 'GET', null, Constants.HTTP_TEAM_ID, '111-team-111');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.getTeamFromSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        Test.stopTest();
    }
    
    //Valid Get Team By Gym ID
    @isTest
    public static void Valid_GetTeamByGymID()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_GET_TEAM_BY_GYM_ID, 'GET', null, Constants.HTTP_GYM_ID, '111-gym-111');
        
        //Calling Method
		Test.startTest();
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.getTeamFromSFDC();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        System.assertEquals(1, res.teams.size());
        
        Test.stopTest();
    }
	
	//inValid Get Team By Gym ID
    @isTest
    public static void inValid_BlankTeamId_GetTeamByGymID()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_GET_TEAM_BY_GYM_ID, 'GET', null, Constants.HTTP_GYM_ID, '');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.getTeamFromSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        Test.stopTest();
    }
	
	//inValid Get Team By Gym ID
    @isTest
    public static void inValid_NullTeamID_GetTeamByGymID()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_GET_TEAM_BY_GYM_ID, 'GET', null, null, null);
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.getTeamFromSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        Test.stopTest();
    }
	
	//inValid Get Team By Gym ID
    @isTest
    public static void inValid_RandomTeamId_GetTeamByGymID()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_GET_TEAM_BY_GYM_ID, 'GET', null, Constants.HTTP_GYM_ID, 'xyz');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.getTeamFromSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        Test.stopTest();
    }
	
	//inValid Get Team By Gym ID
    @isTest
    public static void inValid_RandomParam_GetTeamByGymID()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_GET_TEAM_BY_GYM_ID, 'GET', null, 'xyz', '111-gym-111');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.getTeamFromSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        Test.stopTest();
    }
	
	//inValid Get Team By Gym ID
    @isTest
    public static void inValid_UpdatingDeleted_GetTeamByGymID()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
		List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(2, teams.size());
		for(Rosters__c tm : teams)
		{
			tm.Deleted_From_FF__c = true;
		}
		update teams;
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_GET_TEAM_BY_GYM_ID, 'GET', null, Constants.HTTP_GYM_ID, '111-gym-111');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.getTeamFromSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
		Test.stopTest();
    }
	
	//inValid Get Team By Gym ID
    @isTest
    public static void inValid_NoRecordInserted_GetTeamByGymID()
    {
        //Inserting Record
		//createRecord('1');
		//createRecord('2');
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_GET_TEAM_BY_GYM_ID, 'GET', null, Constants.HTTP_GYM_ID, '111-gym-111');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.getTeamFromSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        Test.stopTest();
    }
    
    //Valid Create Team
    @isTest
    public static void valid_CreateTeam()
    {
        //Inserting Record
        createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
        String body = '{"team_id":"111-team-111","gym_id":"111-gym-111","member_count":"3","team_name":"Junior3","created_at":"02.13.12","sales_rep_ids":"","coach_ids":"","modified_at":"1.02.123"}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.insertTeamAtSFDC();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(1, teams.size());
		Test.stopTest();
    }
	
	//inValid Create Team
    @isTest
    public static void invalid_InvalidBody_CreateTeam()
    {
        //Inserting Record
        createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
        String body = '=m-111","gym_id":"111-gym-111","member_count":"3","team_name":"Junior3","created_at":"02.13.12","sales_rep_ids":"","coach_ids":"","modified_at":"1.02.123"}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.insertTeamAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
		Test.stopTest();
    }
	
	//Valid Create Team
    @isTest
    public static void valid_UpdatingTeam_CreateTeam()
    {
        //Inserting Record
		createRecord('1');
        createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
        String body = '{"team_id":"111-team-111","gym_id":"111-gym-111","member_count":"3","team_name":"Junior3","created_at":"02.13.12","sales_rep_ids":"","coach_ids":"","modified_at":"1.02.123"}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.insertTeamAtSFDC();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(1, teams.size());
		Test.stopTest();
    }
	
	//inValid Create Team
    @isTest
    public static void invalid_NullBody_CreateTeam()
    {
        //Inserting Record
		//createRecord('1');
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
        RestContext.request = createRequest(null, 'POST', null, null, null);
        
        //Calling Method
		Test.startTest();
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.insertTeamAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(0, teams.size());
		Test.stopTest();
    }
    
	//inValid Create Team
    @isTest
    public static void invalid_BlankBody_CreateTeam()
    {
        //Inserting Record
		//createRecord('1');
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
        String body = '';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.insertTeamAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(0, teams.size());
		Test.stopTest();
    }
	
	//inValid Create Team
    @isTest
    public static void invalid_InValidGymId_CreateTeam()
    {
        //Inserting Record
        createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
        String body = '{"team_id":"111-team-111","gym_id":"123-gym-123","member_count":"3","team_name":"Junior3","created_at":"02.13.12","sales_rep_ids":"","coach_ids":"","modified_at":"1.02.123"}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.insertTeamAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(0, teams.size());
		Test.stopTest();
    }
	
	//inValid Create Team
    @isTest
    public static void invalid_BlankTeamId_CreateTeam()
    {
        //Inserting Record
		//createRecord('1');
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
        String body = '{"team_id":"","gym_id":"111-gym-111","member_count":"3","team_name":"Junior3","created_at":"02.13.12","sales_rep_ids":"","coach_ids":"","modified_at":"1.02.123"}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.insertTeamAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(0, teams.size());
		Test.stopTest();
    }
	
	//inValid Create Team
    @isTest
    public static void invalid_BlankGymId_CreateTeam()
    {
        //Inserting Record
		//createRecord('1');
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
        String body = '{"team_id":"111-team-111","gym_id":"","member_count":"3","team_name":"Junior3","created_at":"02.13.12","sales_rep_ids":"","coach_ids":"","modified_at":"1.02.123"}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.insertTeamAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(0, teams.size());
		Test.stopTest();
    }
	
	//inValid Create Team
    @isTest
    public static void invalid_BlankName_CreateTeam()
    {
        //Inserting Record
		//createRecord('1');
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
        String body = '{"team_id":"111-team-111","gym_id":"111-gym-111","member_count":"3","team_name":"","created_at":"02.13.12","sales_rep_ids":"","coach_ids":"","modified_at":"1.02.123"}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.insertTeamAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(0, teams.size());
		Test.stopTest();
    }
	
	//inValid Create Team
    @isTest
    public static void invalid_NoTeamIdNode_CreateTeam()
    {
        //Inserting Record
		//createRecord('1');
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
        String body = '{"gym_id":"111-gym-111","member_count":"3","team_name":"Junior3","created_at":"02.13.12","sales_rep_ids":"","coach_ids":"","modified_at":"1.02.123"}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.insertTeamAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(0, teams.size());
		Test.stopTest();
    }
	
	//inValid Create Team
    @isTest
    public static void invalid_NoGymIdNode_CreateTeam()
    {
        //Inserting Record
		//createRecord('1');
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
        String body = '{"team_id":"111-team-111","member_count":"3","team_name":"Junior3","created_at":"02.13.12","sales_rep_ids":"","coach_ids":"","modified_at":"1.02.123"}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.insertTeamAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(0, teams.size());
		Test.stopTest();
    }
	
	//inValid Create Team
    @isTest
    public static void invalid_NoNameNode_CreateTeam()
    {
        //Inserting Record
		//createRecord('1');
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
        String body = '{"team_id":"111-team-111","gym_id":"111-gym-111","member_count":"3","created_at":"02.13.12","sales_rep_ids":"","coach_ids":"","modified_at":"1.02.123"}';
        RestContext.request = createRequest(null, 'POST', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.insertTeamAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(0, teams.size());
		Test.stopTest();
    }
		
	//Put Request
    @isTest
    public static void inValid_AcctionType_PutRequest()
    {
        
        // Set up a test request
		Test.startTest();
		String body = 'zxy';
        RestContext.request = createRequest('xyz', 'PUT', body, Constants.HTTP_HEADER_ID, '111-team-111');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
		Test.stopTest();
    }
	
	//Valid Add CoachToTeam
    @isTest
    public static void valid_AddCoachToTeam()
    {
        //Inserting Record
		Id tmId = createRecord('1');
		createRecord('2');
		createCoach('1', false);
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
		String body = '{"member_id":"111-coach-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_ADD_COACH_TO_TEAM, 'PUT', body, Constants.HTTP_HEADER_ID, '111-team-111');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Contact> cons = [SELECT team_id__c, Team__c FROM Contact];
        System.assertEquals(1, cons.size());
     
		System.assertEquals('111-team-111', cons[0].team_id__c);
        //System.assertEquals(tmId, cons[0].Team__c);
		Test.stopTest();
    }
	
	//inValid Add CoachToTeam
    @isTest
    public static void invalid_InvalidTeamId_AddCoachToTeam()
    {
        //Inserting Record
		Id tmId = createRecord('1');
		createRecord('2');
		createCoach('1', false);
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
		String body = '{"member_id":"111-coach-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_ADD_COACH_TO_TEAM, 'PUT', body, Constants.HTTP_HEADER_ID, '123-team-123');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
		Test.stopTest();
    }
	
	
	//inValid Add CoachToTeam
    @isTest
    public static void inValid_BlankTeamId_AddCoachToTeam()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
		createCoach('1', false);
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
		String body = '{"member_id":"111-coach-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_ADD_COACH_TO_TEAM, 'PUT', body, Constants.HTTP_HEADER_ID, '');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Contact> cons = [SELECT team_id__c, Team__c FROM Contact];
        System.assertEquals(1, cons.size());
		System.assert(String.isBlank(cons[0].team_id__c));
		System.assert(String.isBlank(cons[0].Team__c));
		Test.stopTest();
    }
	
	//inValid Add CoachToTeam
    @isTest
    public static void inValid_NoParam_AddCoachToTeam()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
		createCoach('1', false);
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
		String body = '{"member_id":"111-coach-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_ADD_COACH_TO_TEAM, 'PUT', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Contact> cons = [SELECT team_id__c, Team__c FROM Contact];
        System.assertEquals(1, cons.size());
		System.assert(String.isBlank(cons[0].team_id__c));
		System.assert(String.isBlank(cons[0].Team__c));
		Test.stopTest();
    }
	
	//inValid Add CoachToTeam
    @isTest
    public static void inValid_InvalidCoachId_AddCoachToTeam()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
		createCoach('1', false);
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
		String body = '{"member_id":"123-coach-123"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_ADD_COACH_TO_TEAM, 'PUT', body, Constants.HTTP_HEADER_ID, '111-team-111');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Contact> cons = [SELECT team_id__c, Team__c FROM Contact];
        System.assertEquals(1, cons.size());
		System.assert(String.isBlank(cons[0].team_id__c));
		System.assert(String.isBlank(cons[0].Team__c));
		Test.stopTest();
    }
	
	//inValid Add CoachToTeam
    @isTest
    public static void inValid_InvalidPropertyInBody_AddCoachToTeam()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
		createCoach('1', false);
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
		String body = '{"coach":"111-coach-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_ADD_COACH_TO_TEAM, 'PUT', body, Constants.HTTP_HEADER_ID, '111-team-111');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Contact> cons = [SELECT team_id__c, Team__c FROM Contact];
        System.assertEquals(1, cons.size());
		System.assert(String.isBlank(cons[0].team_id__c));
		System.assert(String.isBlank(cons[0].Team__c));
		Test.stopTest();
    }
	
	
	
	//inValid Add CoachToTeam
    @isTest
    public static void inValid_BlankCoachId_AddCoachToTeam()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
		createCoach('1', false);
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
		String body = '{"member_id":""}';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_ADD_COACH_TO_TEAM, 'PUT', body, Constants.HTTP_HEADER_ID, '111-team-111');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Contact> cons = [SELECT team_id__c, Team__c FROM Contact];
        System.assertEquals(1, cons.size());
		System.assert(String.isBlank(cons[0].team_id__c));
		System.assert(String.isBlank(cons[0].Team__c));
		Test.stopTest();
    }
	
	//Valid Remove Coach From Team
    @isTest
    public static void valid_RemoveCoachFromTeam()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
		createCoach('1', true);
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
		String body = '{"member_id":"111-coach-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_REMOVE_COACH_FROM_TEAM, 'PUT', body, Constants.HTTP_HEADER_ID, '111-team-111');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Contact> cons = [SELECT team_id__c FROM Contact];
        System.assertEquals(1, cons.size());
		System.assert(String.isNotBlank(cons[0].team_id__c));
		Test.stopTest();
    }
	
	//inValid Remove Coach From Team
    @isTest
    public static void inValid_InvlaidCoachId_RemoveCoachFromTeam()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
		createCoach('1', true);
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
		String body = '{"member_id":"123-coach-123"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_REMOVE_COACH_FROM_TEAM, 'PUT', body, Constants.HTTP_HEADER_ID, '111-team-111');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Contact> cons = [SELECT team_id__c FROM Contact];
        System.assertEquals(1, cons.size());
		System.assert(String.isNotBlank(cons[0].team_id__c));
		Test.stopTest();
    }
	
	//inValid Remove Coach From Team
    @isTest
    public static void inValid_BlankBody_RemoveCoachFromTeam()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
		createCoach('1', true);
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
		String body = '';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_REMOVE_COACH_FROM_TEAM, 'PUT', body, Constants.HTTP_HEADER_ID, '111-team-111');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Contact> cons = [SELECT team_id__c FROM Contact];
        System.assertEquals(1, cons.size());
		System.assert(String.isNotBlank(cons[0].team_id__c));
		Test.stopTest();
    }
	
	//inValid Remove Coach From Team
    @isTest
    public static void inValid_NullBody_RemoveCoachFromTeam()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
		createCoach('1', true);
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_REMOVE_COACH_FROM_TEAM, 'PUT', null, Constants.HTTP_HEADER_ID, '111-team-111');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Contact> cons = [SELECT team_id__c FROM Contact];
        System.assertEquals(1, cons.size());
		System.assert(String.isNotBlank(cons[0].team_id__c));
		Test.stopTest();
    }
	
	//inValid Remove Coach From Team
    @isTest
    public static void inValid_TeamId_RemoveCoachFromTeam()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
		createCoach('1', true);
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
		String body = '{"member_id":"111-coach-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_REMOVE_COACH_FROM_TEAM, 'PUT', body, Constants.HTTP_HEADER_ID, '');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Contact> cons = [SELECT team_id__c FROM Contact];
        System.assertEquals(1, cons.size());
		System.assert(String.isNotBlank(cons[0].team_id__c));
		Test.stopTest();
    }
	
	//inValid Remove Coach From Team
    @isTest
    public static void inValid_NoParam_RemoveCoachFromTeam()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
		createCoach('1', true);
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
		String body = '{"member_id":"111-coach-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_REMOVE_COACH_FROM_TEAM, 'PUT', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Contact> cons = [SELECT team_id__c FROM Contact];
        System.assertEquals(1, cons.size());
		System.assert(String.isNotBlank(cons[0].team_id__c));
		Test.stopTest();
    }
	
	//inValid Remove Coach From Team
    @isTest
    public static void inValid_InvalidTeamId_RemoveCoachFromTeam()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
		createCoach('1', true);
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
		String body = '{"member_id":"111-coach-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_REMOVE_COACH_FROM_TEAM, 'PUT', body, Constants.HTTP_HEADER_ID, '123-team-123');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Contact> cons = [SELECT team_id__c FROM Contact];
        System.assertEquals(1, cons.size());
		System.assert(String.isNotBlank(cons[0].team_id__c));
		Test.stopTest();
    }
	
	//inValid Remove Coach From Team
    @isTest
    public static void inValid_InvalidBody_RemoveCoachFromTeam()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
		createCoach('1', true);
        //createValidRrcordForCreateTeamRequest('1');
            
        // Set up a test request
		Test.startTest();
		String body = '{"xyz":"111-coach-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_REMOVE_COACH_FROM_TEAM, 'PUT', body, Constants.HTTP_HEADER_ID, '111-team-111');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Contact> cons = [SELECT team_id__c FROM Contact];
        System.assertEquals(1, cons.size());
		System.assert(String.isNotBlank(cons[0].team_id__c));
		Test.stopTest();
    }
    
	//Valid Edit Team Name
    @isTest
    public static void valid_EditTeamName()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
            
        // Set up a test request
		Test.startTest();
		String body = '{"team_name":"NewName"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_EDIT_TEAM_NAME, 'PUT', body, Constants.HTTP_HEADER_ID, '111-team-111');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT Name, rosters_id__c FROM Rosters__c WHERE rosters_id__c = '111-team-111'];
        System.assertEquals(1, teams.size());
		System.assertEquals('111-team-111', teams[0].rosters_id__c);
		Test.stopTest();
    }
	
	//inValid Edit Team Name
    @isTest
    public static void inValid_BlankBody_EditTeamName()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
            
        // Set up a test request
		Test.startTest();
		String body = '';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_EDIT_TEAM_NAME, 'PUT', body, Constants.HTTP_HEADER_ID, '111-team-111');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT Name FROM Rosters__c WHERE rosters_id__c = '111-team-111'];
        System.assertEquals(1, teams.size());
		System.assertEquals('Team1', teams[0].Name);
		Test.stopTest();
    }
	
	//inValid Edit Team Name
    @isTest
    public static void inValid_NullBody_EditTeamName()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
            
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_EDIT_TEAM_NAME, 'PUT', null, Constants.HTTP_HEADER_ID, '111-team-111');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT Name FROM Rosters__c WHERE rosters_id__c = '111-team-111'];
        System.assertEquals(1, teams.size());
		System.assertEquals('Team1', teams[0].Name);
		Test.stopTest();
    }
	
	//inValid Edit Team Name
    @isTest
    public static void inValid_InvalidBody_EditTeamName()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
            
        // Set up a test request
		Test.startTest();
		String body = '_name":"NewName"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_EDIT_TEAM_NAME, 'PUT', body, Constants.HTTP_HEADER_ID, '111-team-111');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT Name FROM Rosters__c WHERE rosters_id__c = '111-team-111'];
        System.assertEquals(1, teams.size());
		System.assertEquals('Team1', teams[0].Name);
		Test.stopTest();
    }
	
	//inValid Edit Team Name
    @isTest
    public static void inValid_BlankTeamId_EditTeamName()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
            
        // Set up a test request
		Test.startTest();
		String body = '{"team_name":"NewName"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_EDIT_TEAM_NAME, 'PUT', body, Constants.HTTP_HEADER_ID, '');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT Name FROM Rosters__c WHERE rosters_id__c = '111-team-111'];
        System.assertEquals(1, teams.size());
		System.assertEquals('Team1', teams[0].Name);
		Test.stopTest();
    }
	
	//inValid Edit Team Name
    @isTest
    public static void inValid_NoParam_EditTeamName()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
            
        // Set up a test request
		Test.startTest();
		String body = '{"team_name":"NewName"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_EDIT_TEAM_NAME, 'PUT', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT Name FROM Rosters__c WHERE rosters_id__c = '111-team-111'];
        System.assertEquals(1, teams.size());
		System.assertEquals('Team1', teams[0].Name);
		Test.stopTest();
    }
	
	//inValid Edit Team Name
    @isTest
    public static void inValid_InvalidTeamId_EditTeamName()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
            
        // Set up a test request
		Test.startTest();
		String body = '{"team_name":"NewName"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_EDIT_TEAM_NAME, 'PUT', body, Constants.HTTP_HEADER_ID, '123-team-123');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT Name FROM Rosters__c WHERE rosters_id__c = '111-team-111'];
        System.assertEquals(1, teams.size());
		System.assertEquals('Team1', teams[0].Name);
		Test.stopTest();
    }
	
	//inValid ModifySalesRep
    @isTest
    public static void inValid_InvalidBody_ModifySalesRep()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
		List<Rosters__c> teamsold = [SELECT sales_rep_ids__c FROM Rosters__c WHERE rosters_id__c = '111-team-111'];
        teamsold[0].sales_rep_ids__c = '111-rep-111';
		update teamsold;
		
        // Set up a test request
		Test.startTest();
		String body = '{"action":"xyz","sales_rep_ids":"111-rep-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_MODIFY_SALES_REP, 'PUT', body, Constants.HTTP_HEADER_ID, '111-team-111');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT sales_rep_ids__c FROM Rosters__c WHERE rosters_id__c = '111-team-111'];
        System.assertEquals(1, teams.size());
		System.assertEquals('111-rep-111', teams[0].sales_rep_ids__c);
		Test.stopTest();
    }
	
	//inValid ModifySalesRep
    @isTest
    public static void inValid_InvaildRepProperty_ModifySalesRep()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
		List<Rosters__c> teamsold = [SELECT sales_rep_ids__c FROM Rosters__c WHERE rosters_id__c = '111-team-111'];
        teamsold[0].sales_rep_ids__c = '111-rep-111';
		update teamsold;
		
        // Set up a test request
		Test.startTest();
		String body = '{"action":"remove","sales_id":"111-rep-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_MODIFY_SALES_REP, 'PUT', body, Constants.HTTP_HEADER_ID, '111-team-111');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT sales_rep_ids__c FROM Rosters__c WHERE rosters_id__c = '111-team-111'];
        System.assertEquals(1, teams.size());
		System.assertEquals('111-rep-111', teams[0].sales_rep_ids__c);
		Test.stopTest();
    }
	
	//inValid ModifySalesRep
    @isTest
    public static void inValid_BlankBody_ModifySalesRep()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
		List<Rosters__c> teamsold = [SELECT sales_rep_ids__c FROM Rosters__c WHERE rosters_id__c = '111-team-111'];
        teamsold[0].sales_rep_ids__c = '111-rep-111';
		update teamsold;
		
        // Set up a test request
		Test.startTest();
		String body = '';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_MODIFY_SALES_REP, 'PUT', body, Constants.HTTP_HEADER_ID, '111-team-111');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT sales_rep_ids__c FROM Rosters__c WHERE rosters_id__c = '111-team-111'];
        System.assertEquals(1, teams.size());
		System.assertEquals('111-rep-111', teams[0].sales_rep_ids__c);
		Test.stopTest();
    }
	
	//inValid ModifySalesRep
    @isTest
    public static void inValid_NullBody_ModifySalesRep()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
		List<Rosters__c> teamsold = [SELECT sales_rep_ids__c FROM Rosters__c WHERE rosters_id__c = '111-team-111'];
        teamsold[0].sales_rep_ids__c = '111-rep-111';
		update teamsold;
		
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_MODIFY_SALES_REP, 'PUT', null, Constants.HTTP_HEADER_ID, '111-team-111');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT sales_rep_ids__c FROM Rosters__c WHERE rosters_id__c = '111-team-111'];
        System.assertEquals(1, teams.size());
		System.assertEquals('111-rep-111', teams[0].sales_rep_ids__c);
		Test.stopTest();
    }
	
	//inValid ModifySalesRep
    @isTest
    public static void inValid_InvalidAcotionProperty_ModifySalesRep()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
		List<Rosters__c> teamsold = [SELECT sales_rep_ids__c FROM Rosters__c WHERE rosters_id__c = '111-team-111'];
        teamsold[0].sales_rep_ids__c = '111-rep-111';
		update teamsold;
		
        // Set up a test request
		Test.startTest();
		String body = '{"aaa":"remove","sales_rep_ids":"111-rep-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_MODIFY_SALES_REP, 'PUT', body, Constants.HTTP_HEADER_ID, '111-team-111');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT sales_rep_ids__c FROM Rosters__c WHERE rosters_id__c = '111-team-111'];
        System.assertEquals(1, teams.size());
		System.assertEquals('111-rep-111', teams[0].sales_rep_ids__c);
		Test.stopTest();
    }
	
	//Valid Remove ModifySalesRep
    @isTest
    public static void valid_ModifySalesRep()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
		List<Rosters__c> teamsold = [SELECT sales_rep_ids__c FROM Rosters__c WHERE rosters_id__c = '111-team-111'];
        teamsold[0].sales_rep_ids__c = '111-rep-111';
		update teamsold;
		
        // Set up a test request
		Test.startTest();
		String body = '{"action":"remove","sales_rep_ids":"111-rep-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_MODIFY_SALES_REP, 'PUT', body, Constants.HTTP_HEADER_ID, '111-team-111');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT sales_rep_ids__c FROM Rosters__c WHERE rosters_id__c = '111-team-111'];
        System.assertEquals(1, teams.size());
		System.assert(String.isBlank(teams[0].sales_rep_ids__c));
		Test.stopTest();
    }
	
	//inValid Remove ModifySalesRep
    @isTest
    public static void inValid_BlankRepId_ModifySalesRep()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
		List<Rosters__c> teamsold = [SELECT sales_rep_ids__c FROM Rosters__c WHERE rosters_id__c = '111-team-111'];
        teamsold[0].sales_rep_ids__c = '111-rep-111';
		update teamsold;
		
        // Set up a test request
		Test.startTest();
		String body = '{"action":"remove","sales_rep_ids":""}';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_MODIFY_SALES_REP, 'PUT', body, Constants.HTTP_HEADER_ID, '111-team-111');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT sales_rep_ids__c FROM Rosters__c WHERE rosters_id__c = '111-team-111'];
        System.assertEquals(1, teams.size());
		System.assertEquals('111-rep-111', teams[0].sales_rep_ids__c);
		Test.stopTest();
    }
	
	//inValid Remove ModifySalesRep
    @isTest
    public static void inValid_BlankTeamId_ModifySalesRep()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
		List<Rosters__c> teamsold = [SELECT sales_rep_ids__c FROM Rosters__c WHERE rosters_id__c = '111-team-111'];
        teamsold[0].sales_rep_ids__c = '111-rep-111';
		update teamsold;
		
        // Set up a test request
		Test.startTest();
		String body = '{"action":"remove","sales_rep_ids":"111-rep-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_MODIFY_SALES_REP, 'PUT', body, Constants.HTTP_HEADER_ID, '');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT sales_rep_ids__c FROM Rosters__c WHERE rosters_id__c = '111-team-111'];
        System.assertEquals(1, teams.size());
		System.assertEquals('111-rep-111', teams[0].sales_rep_ids__c);
		Test.stopTest();
    }
	
	//inValid Remove ModifySalesRep
    @isTest
    public static void inValid_NoParam_ModifySalesRep()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
		List<Rosters__c> teamsold = [SELECT sales_rep_ids__c FROM Rosters__c WHERE rosters_id__c = '111-team-111'];
        teamsold[0].sales_rep_ids__c = '111-rep-111';
		update teamsold;
		
        // Set up a test request
		Test.startTest();
		String body = '{"action":"remove","sales_rep_ids":"111-rep-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_MODIFY_SALES_REP, 'PUT', body, null, null);
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT sales_rep_ids__c FROM Rosters__c WHERE rosters_id__c = '111-team-111'];
        System.assertEquals(1, teams.size());
		System.assertEquals('111-rep-111', teams[0].sales_rep_ids__c);
		Test.stopTest();
    }
	
	//Valid Add ModifySalesRep
    @isTest
    public static void valid_Add_ModifySalesRep()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
		
        // Set up a test request
		Test.startTest();
		String body = '{"action":"add","sales_rep_ids":"111-rep-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_MODIFY_SALES_REP, 'PUT', body, Constants.HTTP_HEADER_ID, '111-team-111');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT sales_rep_ids__c FROM Rosters__c WHERE rosters_id__c = '111-team-111'];
        System.assertEquals(1, teams.size());
		System.assertEquals('111-rep-111', teams[0].sales_rep_ids__c);
		Test.stopTest();
    }
	
	//inValid Add ModifySalesRep
    @isTest
    public static void inValid_Add_InvalidTeamId_ModifySalesRep()
    {
        //Inserting Record
		createRecord('1');
		createRecord('2');
		
        // Set up a test request
		Test.startTest();
		String body = '{"action":"add","sales_rep_ids":"111-rep-111"}';
        RestContext.request = createRequest(FitFreedomUrlMappings.TEAM_AT_MODIFY_SALES_REP, 'PUT', body, Constants.HTTP_HEADER_ID, '123-team-123');
        
        //Calling Method
        FitFreedomRestServiceTeam.TeamResponseWrapper res = new FitFreedomRestServiceTeam.TeamResponseWrapper();
        res = FitFreedomRestServiceTeam.updateTeam();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.teams.size());
        
        List<Rosters__c> teams = [SELECT sales_rep_ids__c FROM Rosters__c WHERE rosters_id__c = '111-team-111'];
        System.assertEquals(1, teams.size());
		System.assert(String.isBlank(teams[0].sales_rep_ids__c));
		Test.stopTest();
    }
	
    static RestRequest createRequest(String requestUrl, String method, String body, String paramKey, String paramValue)
    {
        RestRequest request = new RestRequest();
        if(requestUrl != null)
        {
           request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_TEAM + requestUrl + '/'; 
        }
        else
        {
            request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_TEAM; 
        }
        
        request.httpMethod = method.toUpperCase();
        
        if(body != null)
        {
            request.requestBody = Blob.valueof(body);
        }
        if(paramKey != null && paramValue != null)
        {
            request.addParameter(paramKey, paramValue);
        }
        return request;
    }
    
   
    
    static Id createRecord(String num)
    {
        String idNum = num + num + num;
        Sobject sobjTeam = new Rosters__c();
        sobjTeam.put('Name', 'Team' + num);
        sobjTeam.put('rosters_id__c', idNum + '-team-' + idNum);
        sobjTeam.put('gym_id__c', idNum + '-gym-' + idNum);        
        insert sobjTeam;
        return sobjTeam.Id;
        
    }
    
    
    static Id createCoach(String num, Boolean addTeamId)
    {
        String idNum = num + num + num;
        Contact record = new Contact();
        record.LastName = 'Coach' + num;
        record.member_id__c = idNum + '-coach-' + idNum;
		if(addTeamId)
		{
			record.team_id__c = idNum + '-team-' + idNum;
		}
        
        insert record;
        return record.Id;
    }
    
    static void createValidRrcordForCreateTeamRequest(String num)
    {
        String idNum = num + num + num;
        List<Sobject> sobjs = new List<Sobject>();
        
        Sobject sobjGym = new Account();
        sobjGym.put('Name', 'Gum' + num);
        sobjGym.put('gym_id__c', idNum + '-gym-' + idNum);
        sobjs.add(sobjGym);
        
        insert sobjs;
    }

}