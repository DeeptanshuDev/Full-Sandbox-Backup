/**
*   Description     :   Apex Test class for FitFreedomRestServiceGym. 
*
*   Created By      :   
*
*   Created Date    :   05/18/2020
* 
*   Version         :   v1.0 - Created - 05/18/2020
*   
*   Coverage        :   93% 
**/
@isTest
private class Test_FitFreedomRestServiceGym 
{

    // Valid Get One Gym
    @isTest
    static void testValid_GetOneGym()
    {
        //Inserting Records
        createGym('Gym1', '111-gym-111');
        createGym('Gym2', '222-gym-222');
        List<Account> accs = [Select Id From Account];
        System.assert(accs.size() == 2);
        
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(null, 'GET', null, Constants.HTTP_HEADER_ID, '111-gym-111');
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.getGymsFromSFDC();
        System.assertEquals(200, res.statuscode);
        System.assertEquals(1, res.gyms.size());
        //system.assertEquals(true,res );
		Test.stopTest();
    }
    
    //Invalid Get One Gym
    @isTest
    static void testInValid_GetOneGym()
    {
        //Inserting Records
        createGym('Gym1', '111-gym-111');
        createGym('Gym2', '222-gym-222');
        
        List<Account> accs = [Select Id From Account];
        System.assert(accs.size() == 2);
		
        // Set up a test request
		Test.startTest();
        RestContext.request = createRequest(null, 'GET', null, Constants.HTTP_HEADER_ID, 'inValid');
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.getGymsFromSFDC();
        System.assertEquals(400, res.statuscode);
        //System.assertEquals(1, res.gyms.size());
        //system.assertEquals(true,res );
		Test.stopTest();
    }
    
    //Invalid Get One Gym
    //@@@@@@    Use case not covered
   /* @isTest
    static void testInValid_invalidParam_GetOneGym()
    {
        //Inserting Records
        createGym('Gym1', '111-gym-111');
        createGym('Gym2', '222-gym-222');
        
        List<Account> accs = [Select Id From Account];
        System.assert(accs.size() == 2);
		
        // Set up a test request
        Test.startTest();
        RestContext.request = createRequest(null, 'GET', null, 'xyz', 'inValid');
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.getGymsFromSFDC();
        System.assertEquals(400, res.statuscode);
        //System.assertEquals(1, res.gyms.size());
        //system.assertEquals(true,res );
		Test.stopTest();
    }*/
    
    //Valid Get All Gym
    @isTest
    static void testValid_FindAllGyms()
    {
        //Inserting Records
        createGym('Gym1', '111-gym-111');
        createGym('Gym2', '222-gym-222');
        
        // Set up a test request
		Test.startTest();
        RestContext.request =  createRequest(null, 'GET', null, null, null);
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.getGymsFromSFDC();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        System.assertEquals(2, res.gyms.size());
		Test.stopTest();
    }
    
    //inValid Get All Gym
    @isTest
    static void testinValid_FindAllGyms()
    {
        //Inserting Records
        createGym('Gym1', '111-gym-111');
        createGym('Gym2', '222-gym-222');
        
        List<Account> accs = [SELECT Id, Deleted_From_FF__c FROM Account  ];
        for(Account ac : accs)
        {
            ac.Deleted_From_FF__c = true;
        }
        update accs;
        
        // Set up a test request
		Test.startTest();
        RestContext.request =  createRequest(null, 'GET', null, null, null);
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.getGymsFromSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
		Test.stopTest();
    }
    
    //Valid Remove One Gym
    @isTest
    static void testValid_RemoveOneGym()
    {
        //Inserting Records
        createGym('Gym1', '111-gym-111');
        createGym('Gym2', '222-gym-222');
        
        // Set up a test request
		Test.startTest();
        RestContext.request =  createRequest(null, 'DELETE', null, Constants.HTTP_HEADER_ID, '111-gym-111');
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.deleteGymByIdInSFDC();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        List<Account> accs = [Select Id From Account WHERE Deleted_From_FF__c = true];
        System.assert(accs.size() == 1);
        List<Account> accs2 = [Select Id From Account WHERE Deleted_From_FF__c = false];
        System.assert(accs2.size() == 1);
		Test.stopTest();
    }

    //inValid Remove One Gym
    @isTest
    static void testinValid_NoIdSet_RemoveOneGym()
    {
        //Inserting Records
        createGym('Gym1', '111-gym-111');
        createGym('Gym2', '222-gym-222');
        
        // Set up a test request
        Test.startTest();
        //request.addParameter(Constants.HTTP_HEADER_ID, '111-gym-111');*/
        RestContext.request =  createRequest(null, 'DELETE', null, null, null);
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.deleteGymByIdInSFDC();
        
        //Asserts
        //System.assert(false, res);
        System.assertEquals(400, res.statuscode);
        Test.stopTest();
    }
    
    //inValid Remove One Gym
    @isTest
    static void testinValidId_RemoveOneGym()
    {
        //Inserting Records
        createGym('Gym1', '111-gym-111');
        createGym('Gym2', '222-gym-222');
        
        // Set up a test request
        Test.startTest();
        RestContext.request =  createRequest(null, 'DELETE', null, Constants.HTTP_HEADER_ID, '111');
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.deleteGymByIdInSFDC();
        
        //Asserts
        //System.assert(false, res);
        System.assertEquals(400, res.statuscode);
		Test.stopTest();
        
    }
    
    //Valid Add or Remove rep form Gym
    @isTest
    static void testValid_AddSalesRep()
    {
        //Inserting Records
        createGym('Gym1', '111-gym-111');
        createGym('Gym2', '222-gym-222');
        
        // Set up a test request
		Test.startTest();
        String body = '{ "action" : "update",  "id" : "111-rep-111"}';
        RestContext.request =  createRequest(null, 'PUT', body, Constants.HTTP_HEADER_GYM_ID, '111-gym-111');
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.updateGym();
        
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        List<Account> accs = [SELECT gym_id__c, sales_rep_ids__c FROM Account];
        for(Account ac : accs)
        {
            if(ac.gym_id__c == '111-gym-111')
            {
                System.assertEquals(ac.sales_rep_ids__c, '111-rep-111');
            }
            else
            {
                System.assert(String.isBlank(ac.sales_rep_ids__c));
            }
        }
		Test.stopTest();
    }
    
    //Valid Add or Remove rep form Gym
    @isTest
    static void testValid_RemoveSalesRep()
    {
        //Inserting Records
        createGym('Gym1', '111-gym-111');
        createGym('Gym2', '222-gym-222');
        List<Account> updateaccs = [SELECT gym_id__c, sales_rep_ids__c FROM Account];
        for(Account ac : updateaccs)
        {
            if(ac.gym_id__c == '111-gym-111')
            {
                ac.sales_rep_ids__c =  '111-rep-111';
            }
        }
        update updateaccs;
        
        // Set up a test request
		Test.startTest();
        String body = '{ "action" : "remove",  "id" : "111-rep-111"}';
        RestContext.request =  createRequest(null, 'PUT', body, Constants.HTTP_HEADER_GYM_ID, '111-gym-111');
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.updateGym();
        
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        List<Account> accs = [SELECT gym_id__c, sales_rep_ids__c FROM Account];
        for(Account ac : accs)
        {
            System.assert(String.isBlank(ac.sales_rep_ids__c));
        }
		Test.stopTest();
    }
    
    //inValid Add or Remove rep form Gym
    @isTest
    static void inValidGymID_AddSalesRep()
    {
        //Inserting Records
        createGym('Gym1', '111-gym-111');
        createGym('Gym2', '222-gym-222');
        
        // Set up a test request
		Test.startTest();
        String body = '{ "action" : "update",  "id" : "111-rep-111"}';
        RestContext.request =  createRequest(null, 'PUT', body, Constants.HTTP_HEADER_GYM_ID, '111-gym-123');
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.updateGym();
        
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.gyms.size());
        List<Account> accs = [SELECT gym_id__c, sales_rep_ids__c FROM Account];
        for(Account ac : accs)
        {
            System.assert(String.isBlank(ac.sales_rep_ids__c));
        }
		Test.stopTest();
    }
    
    //inValid Add or Remove rep form Gym
    @isTest
    static void inValidBodyAction_AddSalesRep()
    {
        //Inserting Records
        createGym('Gym1', '111-gym-111');
        createGym('Gym2', '222-gym-222');
        
        // Set up a test request
		Test.startTest();
        String body = '{ "action" : "xyz",  "id" : "111-rep-111"}';
        RestContext.request =  createRequest(null, 'PUT', body, Constants.HTTP_HEADER_GYM_ID, '111-gym-111');
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.updateGym();
        
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        System.assertEquals(0, res.gyms.size());
        List<Account> accs = [SELECT gym_id__c, sales_rep_ids__c FROM Account];
        for(Account ac : accs)
        {
            System.assert(String.isBlank(ac.sales_rep_ids__c));
        }
		Test.stopTest();
    }
    
    //inValid Add or Remove rep form Gym
    @isTest
    static void inValidBody_RepBlank_AddSalesRep()
    {
        //Inserting Records
        createGym('Gym1', '111-gym-111');
        createGym('Gym2', '222-gym-222');
        
        // Set up a test request
		Test.startTest();
        String body = '{ "action" : "update",  "id" : ""}';
        RestContext.request =  createRequest(null, 'PUT', body, Constants.HTTP_HEADER_GYM_ID, '111-gym-111');
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.updateGym();
        
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.gyms.size());
        List<Account> accs = [SELECT gym_id__c, sales_rep_ids__c FROM Account];
        for(Account ac : accs)
        {
            System.assert(String.isBlank(ac.sales_rep_ids__c));
        }
		Test.stopTest();
    }
    
    //inValid Add or Remove rep form Gym
    @isTest
    static void inValidBody_NoUserIdProperty_AddSalesRep()
    {
        //Inserting Records
        createGym('Gym1', '111-gym-111');
        createGym('Gym2', '222-gym-222');
        
        // Set up a test request
		Test.startTest();
        String body = '{ "action" : "update",  "xyz" : "111-rep-11"}';
        RestContext.request =  createRequest(null, 'PUT', body, Constants.HTTP_HEADER_GYM_ID, '111-gym-111');
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.updateGym();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.gyms.size());
        List<Account> accs = [SELECT gym_id__c, sales_rep_ids__c FROM Account];
        for(Account ac : accs)
        {
            System.assert(String.isBlank(ac.sales_rep_ids__c));
        }
		Test.stopTest();
    }
    
    //inValid Add or Remove rep form Gym
    @isTest
    static void inValidBodyBlank_AddSalesRep()
    {
        //Inserting Records
        createGym('Gym1', '111-gym-111');
        createGym('Gym2', '222-gym-222');
        
        // Set up a test request
		Test.startTest();
        String body = '';
        RestContext.request =  createRequest(null, 'PUT', body, Constants.HTTP_HEADER_GYM_ID, '111-gym-111');
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.updateGym();
        
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.gyms.size());
        List<Account> accs = [SELECT gym_id__c, sales_rep_ids__c FROM Account];
        for(Account ac : accs)
        {
            System.assert(String.isBlank(ac.sales_rep_ids__c));
        }
		Test.stopTest();
    }
    
    //inValid Add or Remove rep form Gym
    @isTest
    static void inValidBodyNull_AddSalesRep()
    {
        //Inserting Records
        createGym('Gym1', '111-gym-111');
        createGym('Gym2', '222-gym-222');
        
        // Set up a test request
		Test.startTest();
        RestContext.request =  createRequest(null, 'PUT', null, Constants.HTTP_HEADER_GYM_ID, '111-gym-111');
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.updateGym();
        
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.gyms.size());
        List<Account> accs = [SELECT gym_id__c, sales_rep_ids__c FROM Account];
        for(Account ac : accs)
        {
            System.assert(String.isBlank(ac.sales_rep_ids__c));
        }
		Test.stopTest();
    }
    
    //Valid Create New Gym
    @isTest
    static void testValid_CreateNewGym()
    {
        //Inserting Records
        //createGym('Gym1', '111-gym-111');
        //createGym('Gym2', '222-gym-222');
        
        // Set up a test request
		Test.startTest();
        String body = '{"gym":{"gym_name":"Gym1","gym_type":"AllStar","location":"Atlanta","gym_id":"111-gym-111","active":"true","owner":"111-mem-111","owner_name":"Cathy Mendes","Sales_rep_ids":"111-rep-111","Created_at":"2008-01-0100:00:00","modified_at":"2008-01-0100:00:00"},"admin":{"age":"25","gender":"Female","team_id":"","measured":"false","dob":"13/02/2010","Phone":"55553236","first_login":"true","device_ids":"2356-1245","is_active":"false","is_deleted":"false","pass":"test","role":"owner","social_handles":"false","created_at":"02.15.2020","modified_at":"02.15.2021","email":"cathy@test.com","first_name":"Mendes","last_name":"Cathy","gym_id":"111-gym-111","member_id":"111-mem-111"},"team":{"team_id":"111-team-111","team_name":"CheerAbilities","gym_id":"111-gym-111","member_count":"4","created_at":"02.15.2021","modified_at":"02.11.2020","sales_rep_ids":"","coach_ids":""}}';
        RestContext.request =  createRequest(null, 'POST', body, null, null);
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.insertGymAtSFDC();
        
        //Asserts
        System.assertEquals(200, res.statuscode);
        System.assertEquals(0, res.gyms.size());
        
        List<Account> accs = [SELECT ID FROM Account];
        List<Contact> cons = [SELECT ID FROM Contact];
        List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(1, accs.size());
        System.assertEquals(1, cons.size());
        System.assertEquals(1, teams.size());
		Test.stopTest();
    }
    
    //inValid Create New Gym
    @isTest
    static void inValid_DuplicateGymId_CreateNewGym()
    {
        //Inserting Records
        createGym('Gym1', '111-gym-111');
        List<Account> accsQuery = [SELECT Deleted_From_FF__c FROM Account];
        System.assertEquals(1, accsQuery .size());
        accsQuery [0].Deleted_From_FF__c = true;
        update accsQuery ;
        //createGym('Gym2', '222-gym-222');
        
        // Set up a test request
		Test.startTest();
        String body = '{"gym":{"gym_name":"Gym1","gym_type":"AllStar","location":"Atlanta","gym_id":"111-gym-111","active":"true","owner":"111-mem-111","owner_name":"Cathy Mendes","Sales_rep_ids":"111-rep-111","Created_at":"2008-01-0100:00:00","modified_at":"2008-01-0100:00:00"},"admin":{"age":"25","gender":"Female","team_id":"","measured":"false","dob":"13/02/2010","Phone":"55553236","first_login":"true","device_ids":"2356-1245","is_active":"false","is_deleted":"false","pass":"test","role":"owner","social_handles":"false","created_at":"02.15.2020","modified_at":"02.15.2021","email":"cathy@test.com","first_name":"Mendes","last_name":"Cathy","gym_id":"111-gym-111","member_id":"111-mem-111"},"team":{"team_id":"111-team-111","team_name":"CheerAbilities","gym_id":"111-gym-111","member_count":"4","created_at":"02.15.2021","modified_at":"02.11.2020","sales_rep_ids":"","coach_ids":""}}';
        RestContext.request =  createRequest(null, 'POST', body, null, null);
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.insertGymAtSFDC();
        
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.gyms.size());
        
        List<Account> accs = [SELECT ID FROM Account];
        List<Contact> cons = [SELECT ID FROM Contact];
        List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(1, accs.size());
        System.assertEquals(0, cons.size());
        System.assertEquals(0, teams.size());
		Test.stopTest();
    }
    
    //inValid Create New Gym
    @isTest
    static void inValid_GymIdBlank_CreateNewGym()
    {
        //Inserting Records
        //createGym('Gym1', '111-gym-111');
        //createGym('Gym2', '222-gym-222');
        
        // Set up a test request
		Test.startTest();
        String body = '{"gym":{"gym_name":"Gym1","gym_type":"AllStar","location":"Atlanta","gym_id":"","active":"true","owner":"111-mem-111","owner_name":"Cathy Mendes","Sales_rep_ids":"111-rep-111","Created_at":"2008-01-0100:00:00","modified_at":"2008-01-0100:00:00"},"admin":{"age":"25","gender":"Female","team_id":"","measured":"false","dob":"13/02/2010","Phone":"55553236","first_login":"true","device_ids":"2356-1245","is_active":"false","is_deleted":"false","pass":"test","role":"owner","social_handles":"false","created_at":"02.15.2020","modified_at":"02.15.2021","email":"cathy@test.com","first_name":"Mendes","last_name":"Cathy","gym_id":"111-gym-111","member_id":"111-mem-111"},"team":{"team_id":"111-team-111","team_name":"CheerAbilities","gym_id":"111-gym-111","member_count":"4","created_at":"02.15.2021","modified_at":"02.11.2020","sales_rep_ids":"","coach_ids":""}}';
        RestContext.request =  createRequest(null, 'POST', body, null, null);
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.insertGymAtSFDC();
        
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.gyms.size());
        
        List<Account> accs = [SELECT ID FROM Account];
        List<Contact> cons = [SELECT ID FROM Contact];
        List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(0, accs.size());
        System.assertEquals(0, cons.size());
        System.assertEquals(0, teams.size());
		Test.stopTest();
    }
    
    //inValid Create New Gym
    @isTest
    static void inValid_NoGymName_CreateNewGym()
    {
        //Inserting Records
        //createGym('Gym1', '111-gym-111');
        //createGym('Gym2', '222-gym-222');
        
        // Set up a test request
		Test.startTest();
        String body = '{"gym":{"gym_name":"","gym_type":"AllStar","location":"Atlanta","gym_id":"111-gym-111","active":"true","owner":"111-mem-111","owner_name":"Cathy Mendes","Sales_rep_ids":"111-rep-111","Created_at":"2008-01-0100:00:00","modified_at":"2008-01-0100:00:00"},"admin":{"age":"25","gender":"Female","team_id":"","measured":"false","dob":"13/02/2010","Phone":"55553236","first_login":"true","device_ids":"2356-1245","is_active":"false","is_deleted":"false","pass":"test","role":"owner","social_handles":"false","created_at":"02.15.2020","modified_at":"02.15.2021","email":"cathy@test.com","first_name":"Mendes","last_name":"Cathy","gym_id":"111-gym-111","member_id":"111-mem-111"},"team":{"team_id":"111-team-111","team_name":"CheerAbilities","gym_id":"111-gym-111","member_count":"4","created_at":"02.15.2021","modified_at":"02.11.2020","sales_rep_ids":"","coach_ids":""}}';
        RestContext.request =  createRequest(null, 'POST', body, null, null);
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.insertGymAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.gyms.size());
        
        List<Account> accs = [SELECT ID FROM Account];
        List<Contact> cons = [SELECT ID FROM Contact];
        List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(0, accs.size());
        System.assertEquals(0, cons.size());
        System.assertEquals(0, teams.size());
		Test.stopTest();
    }
    
    //inValid Create New Gym
    @isTest
    static void inValid_NoMemId_CreateNewGym()
    {
        //Inserting Records
        //createGym('Gym1', '111-gym-111');
        //createGym('Gym2', '222-gym-222');
        
        // Set up a test request
		Test.startTest();
        String body = '{"gym":{"gym_name":"Gym1","gym_type":"AllStar","location":"Atlanta","gym_id":"111-gym-111","active":"true","owner":"111-mem-111","owner_name":"Cathy Mendes","Sales_rep_ids":"111-rep-111","Created_at":"2008-01-0100:00:00","modified_at":"2008-01-0100:00:00"},"admin":{"age":"25","gender":"Female","team_id":"","measured":"false","dob":"13/02/2010","Phone":"55553236","first_login":"true","device_ids":"2356-1245","is_active":"false","is_deleted":"false","pass":"test","role":"owner","social_handles":"false","created_at":"02.15.2020","modified_at":"02.15.2021","email":"cathy@test.com","first_name":"Mendes","last_name":"Cathy","gym_id":"111-gym-111","member_id":""},"team":{"team_id":"111-team-111","team_name":"CheerAbilities","gym_id":"111-gym-111","member_count":"4","created_at":"02.15.2021","modified_at":"02.11.2020","sales_rep_ids":"","coach_ids":""}}';
        RestContext.request =  createRequest(null, 'POST', body, null, null);
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.insertGymAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.gyms.size());
        
        List<Account> accs = [SELECT ID FROM Account];
        List<Contact> cons = [SELECT ID FROM Contact];
        List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(0, accs.size());
        System.assertEquals(0, cons.size());
        System.assertEquals(0, teams.size());
        Test.stopTest();
    }
    
    //inValid Create New Gym
    @isTest
    static void inValid_BlankLastName_CreateNewGym()
    {
        //Inserting Records
        //createGym('Gym1', '111-gym-111');
        //createGym('Gym2', '222-gym-222');
        
        // Set up a test request
		Test.startTest();
        String body = '{"gym":{"gym_name":"Gym1","gym_type":"AllStar","location":"Atlanta","gym_id":"111-gym-111","active":"true","owner":"111-mem-111","owner_name":"Cathy Mendes","Sales_rep_ids":"111-rep-111","Created_at":"2008-01-0100:00:00","modified_at":"2008-01-0100:00:00"},"admin":{"age":"25","gender":"Female","team_id":"","measured":"false","dob":"13/02/2010","Phone":"55553236","first_login":"true","device_ids":"2356-1245","is_active":"false","is_deleted":"false","pass":"test","role":"owner","social_handles":"false","created_at":"02.15.2020","modified_at":"02.15.2021","email":"cathy@test.com","first_name":"Mendes","last_name":"","gym_id":"111-gym-111","member_id":"111-mem-111"},"team":{"team_id":"111-team-111","team_name":"CheerAbilities","gym_id":"111-gym-111","member_count":"4","created_at":"02.15.2021","modified_at":"02.11.2020","sales_rep_ids":"","coach_ids":""}}';
        RestContext.request =  createRequest(null, 'POST', body, null, null);
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.insertGymAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.gyms.size());
        
        List<Account> accs = [SELECT ID FROM Account];
        List<Contact> cons = [SELECT ID FROM Contact];
        List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(0, accs.size());
        System.assertEquals(0, cons.size());
        System.assertEquals(0, teams.size());
		Test.stopTest();
    }
    
	//inValid Create New Gym
    @isTest
    static void inValid_BlankOwnerInGym_CreateNewGym()
    {
        //Inserting Records
        //createGym('Gym1', '111-gym-111');
        //createGym('Gym2', '222-gym-222');
        
        // Set up a test request
		Test.startTest();
        String body = '{"gym":{"gym_name":"Gym1","gym_type":"AllStar","location":"Atlanta","gym_id":"111-gym-111","active":"true","owner":"","owner_name":"Cathy Mendes","Sales_rep_ids":"111-rep-111","Created_at":"2008-01-0100:00:00","modified_at":"2008-01-0100:00:00"},"admin":{"age":"25","gender":"Female","team_id":"","measured":"false","dob":"13/02/2010","Phone":"55553236","first_login":"true","device_ids":"2356-1245","is_active":"false","is_deleted":"false","pass":"test","role":"owner","social_handles":"false","created_at":"02.15.2020","modified_at":"02.15.2021","email":"cathy@test.com","first_name":"Mendes","last_name":"Cathy","gym_id":"111-gym-111","member_id":"111-mem-111"},"team":{"team_id":"111-team-111","team_name":"CheerAbilities","gym_id":"111-gym-111","member_count":"4","created_at":"02.15.2021","modified_at":"02.11.2020","sales_rep_ids":"","coach_ids":""}}';
        RestContext.request =  createRequest(null, 'POST', body, null, null);
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.insertGymAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.gyms.size());
        
        List<Account> accs = [SELECT ID FROM Account];
        List<Contact> cons = [SELECT ID FROM Contact];
        List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(0, accs.size());
        System.assertEquals(0, cons.size());
        System.assertEquals(0, teams.size());
		Test.stopTest();
    }
	
    //inValid Create New Gym
    @isTest
    static void inValid_BlankGymIdInAdmin_CreateNewGym()
    {
        //Inserting Records
        //createGym('Gym1', '111-gym-111');
        //createGym('Gym2', '222-gym-222');
        
        // Set up a test request
		Test.startTest();
        String body = '{"gym":{"gym_name":"Gym1","gym_type":"AllStar","location":"Atlanta","gym_id":"111-gym-111","active":"true","owner":"111-mem-111","owner_name":"Cathy Mendes","Sales_rep_ids":"111-rep-111","Created_at":"2008-01-0100:00:00","modified_at":"2008-01-0100:00:00"},"admin":{"age":"25","gender":"Female","team_id":"","measured":"false","dob":"13/02/2010","Phone":"55553236","first_login":"true","device_ids":"2356-1245","is_active":"false","is_deleted":"false","pass":"test","role":"owner","social_handles":"false","created_at":"02.15.2020","modified_at":"02.15.2021","email":"cathy@test.com","first_name":"Mendes","last_name":"Cathy","gym_id":"","member_id":"111-mem-111"},"team":{"team_id":"111-team-111","team_name":"CheerAbilities","gym_id":"111-gym-111","member_count":"4","created_at":"02.15.2021","modified_at":"02.11.2020","sales_rep_ids":"","coach_ids":""}}';
        RestContext.request =  createRequest(null, 'POST', body, null, null);
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.insertGymAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.gyms.size());
        
        List<Account> accs = [SELECT ID FROM Account];
        List<Contact> cons = [SELECT ID FROM Contact];
        List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(0, accs.size());
        System.assertEquals(0, cons.size());
        System.assertEquals(0, teams.size());
		Test.stopTest();
    }
	
	
    
    //inValid Create New Gym
    @isTest
    static void inValid_BlankTeamId_CreateNewGym()
    {
        //Inserting Records
        //createGym('Gym1', '111-gym-111');
        //createGym('Gym2', '222-gym-222');
        
        // Set up a test request
		Test.startTest();
        String body = '{"gym":{"gym_name":"Gym1","gym_type":"AllStar","location":"Atlanta","gym_id":"111-gym-111","active":"true","owner":"111-mem-111","owner_name":"Cathy Mendes","Sales_rep_ids":"111-rep-111","Created_at":"2008-01-0100:00:00","modified_at":"2008-01-0100:00:00"},"admin":{"age":"25","gender":"Female","team_id":"","measured":"false","dob":"13/02/2010","Phone":"55553236","first_login":"true","device_ids":"2356-1245","is_active":"false","is_deleted":"false","pass":"test","role":"owner","social_handles":"false","created_at":"02.15.2020","modified_at":"02.15.2021","email":"cathy@test.com","first_name":"Mendes","last_name":"Cathy","gym_id":"111-gym-111","member_id":"111-mem-111"},"team":{"team_id":"","team_name":"CheerAbilities","gym_id":"111-gym-111","member_count":"4","created_at":"02.15.2021","modified_at":"02.11.2020","sales_rep_ids":"","coach_ids":""}}';
        RestContext.request =  createRequest(null, 'POST', body, null, null);
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.insertGymAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.gyms.size());
        
        List<Account> accs = [SELECT ID FROM Account];
        List<Contact> cons = [SELECT ID FROM Contact];
        List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(0, accs.size());
        System.assertEquals(0, cons.size());
        System.assertEquals(0, teams.size());
		Test.stopTest();
    }
    
    //inValid Create New Gym
    @isTest
    static void inValid_BlankTeamName_CreateNewGym()
    {
        //Inserting Records
        //createGym('Gym1', '111-gym-111');
        //createGym('Gym2', '222-gym-222');
        
        // Set up a test request
		Test.startTest();
        String body = '{"gym":{"gym_name":"Gym1","gym_type":"AllStar","location":"Atlanta","gym_id":"111-gym-111","active":"true","owner":"111-mem-111","owner_name":"Cathy Mendes","Sales_rep_ids":"111-rep-111","Created_at":"2008-01-0100:00:00","modified_at":"2008-01-0100:00:00"},"admin":{"age":"25","gender":"Female","team_id":"","measured":"false","dob":"13/02/2010","Phone":"55553236","first_login":"true","device_ids":"2356-1245","is_active":"false","is_deleted":"false","pass":"test","role":"owner","social_handles":"false","created_at":"02.15.2020","modified_at":"02.15.2021","email":"cathy@test.com","first_name":"Mendes","last_name":"Cathy","gym_id":"111-gym-111","member_id":"111-mem-111"},"team":{"team_id":"111-team-111","team_name":"","gym_id":"111-gym-111","member_count":"4","created_at":"02.15.2021","modified_at":"02.11.2020","sales_rep_ids":"","coach_ids":""}}';
        RestContext.request =  createRequest(null, 'POST', body, null, null);
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.insertGymAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.gyms.size());
        
        List<Account> accs = [SELECT ID FROM Account];
        List<Contact> cons = [SELECT ID FROM Contact];
        List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(0, accs.size());
        System.assertEquals(0, cons.size());
        System.assertEquals(0, teams.size());
		Test.stopTest();
    }
    
    //inValid Create New Gym
    @isTest
    static void inValid_BlankGymIdInTeam_CreateNewGym()
    {
        //Inserting Records
        //createGym('Gym1', '111-gym-111');
        //createGym('Gym2', '222-gym-222');
        
        // Set up a test request
		Test.startTest();
        String body = '{"gym":{"gym_name":"Gym1","gym_type":"AllStar","location":"Atlanta","gym_id":"111-gym-111","active":"true","owner":"111-mem-111","owner_name":"Cathy Mendes","Sales_rep_ids":"111-rep-111","Created_at":"2008-01-0100:00:00","modified_at":"2008-01-0100:00:00"},"admin":{"age":"25","gender":"Female","team_id":"","measured":"false","dob":"13/02/2010","Phone":"55553236","first_login":"true","device_ids":"2356-1245","is_active":"false","is_deleted":"false","pass":"test","role":"owner","social_handles":"false","created_at":"02.15.2020","modified_at":"02.15.2021","email":"cathy@test.com","first_name":"Mendes","last_name":"Cathy","gym_id":"111-gym-111","member_id":"111-mem-111"},"team":{"team_id":"111-team-111","team_name":"CheerAbilities","gym_id":"","member_count":"4","created_at":"02.15.2021","modified_at":"02.11.2020","sales_rep_ids":"","coach_ids":""}}';
        RestContext.request =  createRequest(null, 'POST', body, null, null);
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.insertGymAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.gyms.size());
        
        List<Account> accs = [SELECT ID FROM Account];
        List<Contact> cons = [SELECT ID FROM Contact];
        List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(0, accs.size());
        System.assertEquals(0, cons.size());
        System.assertEquals(0, teams.size());
		Test.stopTest();
    }
	
	//inValid Create New Gym
    @isTest
    static void inValid_InvalidGymIDInAdmin_CreateNewGym()
    {
        //Inserting Records
        //createGym('Gym1', '111-gym-111');
        //createGym('Gym2', '222-gym-222');
        
        // Set up a test request
		Test.startTest();
        String body = '{"gym":{"gym_name":"Gym1","gym_type":"AllStar","location":"Atlanta","gym_id":"111-gym-111","active":"true","owner":"111-mem-111","owner_name":"Cathy Mendes","Sales_rep_ids":"111-rep-111","Created_at":"2008-01-0100:00:00","modified_at":"2008-01-0100:00:00"},"admin":{"age":"25","gender":"Female","team_id":"","measured":"false","dob":"13/02/2010","Phone":"55553236","first_login":"true","device_ids":"2356-1245","is_active":"false","is_deleted":"false","pass":"test","role":"owner","social_handles":"false","created_at":"02.15.2020","modified_at":"02.15.2021","email":"cathy@test.com","first_name":"Mendes","last_name":"Cathy","gym_id":"123-gym-123","member_id":"111-mem-111"},"team":{"team_id":"111-team-111","team_name":"CheerAbilities","gym_id":"111-gym-111","member_count":"4","created_at":"02.15.2021","modified_at":"02.11.2020","sales_rep_ids":"","coach_ids":""}}';
        RestContext.request =  createRequest(null, 'POST', body, null, null);
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.insertGymAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.gyms.size());
        
        List<Account> accs = [SELECT ID FROM Account];
        List<Contact> cons = [SELECT ID FROM Contact];
        List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(0, accs.size());
        System.assertEquals(0, cons.size());
        System.assertEquals(0, teams.size());
		Test.stopTest();
    }
	
	//inValid Create New Gym
    @isTest
    static void inValid_InvalidGymIDInTeam_CreateNewGym()
    {
        //Inserting Records
        //createGym('Gym1', '111-gym-111');
        //createGym('Gym2', '222-gym-222');
        
        // Set up a test request
		Test.startTest();
        String body = '{"gym":{"gym_name":"Gym1","gym_type":"AllStar","location":"Atlanta","gym_id":"111-gym-111","active":"true","owner":"111-mem-111","owner_name":"Cathy Mendes","Sales_rep_ids":"111-rep-111","Created_at":"2008-01-0100:00:00","modified_at":"2008-01-0100:00:00"},"admin":{"age":"25","gender":"Female","team_id":"","measured":"false","dob":"13/02/2010","Phone":"55553236","first_login":"true","device_ids":"2356-1245","is_active":"false","is_deleted":"false","pass":"test","role":"owner","social_handles":"false","created_at":"02.15.2020","modified_at":"02.15.2021","email":"cathy@test.com","first_name":"Mendes","last_name":"Cathy","gym_id":"111-gym-111","member_id":"111-mem-111"},"team":{"team_id":"111-team-111","team_name":"CheerAbilities","gym_id":"123-gym-123","member_count":"4","created_at":"02.15.2021","modified_at":"02.11.2020","sales_rep_ids":"","coach_ids":""}}';
        RestContext.request =  createRequest(null, 'POST', body, null, null);
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.insertGymAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.gyms.size());
        
        List<Account> accs = [SELECT ID FROM Account];
        List<Contact> cons = [SELECT ID FROM Contact];
        List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(0, accs.size());
        System.assertEquals(0, cons.size());
        System.assertEquals(0, teams.size());
		Test.stopTest();
    }
	
	//inValid Create New Gym
    @isTest
    static void inValid_NullBody_CreateNewGym()
    {
        //Inserting Records
        //createGym('Gym1', '111-gym-111');
        //createGym('Gym2', '222-gym-222');
        
        // Set up a test request
		Test.startTest();
        //String body = '{"gym":{"gym_name":"Gym1","gym_type":"AllStar","location":"Atlanta","gym_id":"111-gym-111","active":"true","owner":"111-mem-111","owner_name":"Cathy Mendes","Sales_rep_ids":"111-rep-111","Created_at":"2008-01-0100:00:00","modified_at":"2008-01-0100:00:00"},"admin":{"age":"25","gender":"Female","team_id":"","measured":"false","dob":"13/02/2010","Phone":"55553236","first_login":"true","device_ids":"2356-1245","is_active":"false","is_deleted":"false","pass":"test","role":"owner","social_handles":"false","created_at":"02.15.2020","modified_at":"02.15.2021","email":"cathy@test.com","first_name":"Mendes","last_name":"Cathy","gym_id":"111-gym-111","member_id":"111-mem-111"},"team":{"team_id":"111-team-111","team_name":"CheerAbilities","gym_id":"123-gym-123","member_count":"4","created_at":"02.15.2021","modified_at":"02.11.2020","sales_rep_ids":"","coach_ids":""}}';
        RestContext.request =  createRequest(null, 'POST', null, null, null);
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.insertGymAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.gyms.size());
        
        List<Account> accs = [SELECT ID FROM Account];
        List<Contact> cons = [SELECT ID FROM Contact];
        List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(0, accs.size());
        System.assertEquals(0, cons.size());
        System.assertEquals(0, teams.size());
		Test.stopTest();
    }
	
	//inValid Create New Gym
    @isTest
    static void inValid_BlankBody_CreateNewGym()
    {
        //Inserting Records
        //createGym('Gym1', '111-gym-111');
        //createGym('Gym2', '222-gym-222');
        
        // Set up a test request
		Test.startTest();
        String body = '';
        RestContext.request =  createRequest(null, 'POST', body, null, null);
        
        FitFreedomRestServiceGym.GymResponseWrapper res = new FitFreedomRestServiceGym.GymResponseWrapper();
        res = FitFreedomRestServiceGym.insertGymAtSFDC();
        
        //Asserts
        System.assertEquals(400, res.statuscode);
        System.assertEquals(0, res.gyms.size());
        
        List<Account> accs = [SELECT ID FROM Account];
        List<Contact> cons = [SELECT ID FROM Contact];
        List<Rosters__c> teams = [SELECT ID FROM Rosters__c];
        System.assertEquals(0, accs.size());
        System.assertEquals(0, cons.size());
        System.assertEquals(0, teams.size());
		Test.stopTest();
    }
    
    
    
    static RestRequest createRequest(String requestUrl, String method, String body, String paramKey, String paramValue)
    {
        RestRequest request = new RestRequest();
        if(requestUrl != null)
        {
           request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_GYM + requestUrl; 
        }
        else
        {
            request.requestUri = FitFreedomUrlMappings.BASE_URL + FitFreedomUrlMappings.REST_SERVICE_INSTANCE + FitFreedomUrlMappings.URLMAPPING_GYM; 
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
    
    static Id createGym(String name,String gymId)
    {
        Account acc = new Account();
        acc.name = name;
        acc.gym_id__c = gymId;
        insert acc;
        return acc.Id;
    }
}