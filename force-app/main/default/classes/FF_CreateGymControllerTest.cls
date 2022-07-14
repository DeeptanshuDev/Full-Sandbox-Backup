@isTest
public class FF_CreateGymControllerTest {
    
    /*private static final String CUSTOM_METADATA_NAME = 'TestMetadata';
    private static final String ENDPOINT = 'https://www.test.com';
    private static final String METHOD = 'POST';
    private static final String REQUEST_BODY = '{"input":"Test Input"}';
    private static final String REQUEST_BODY_XML = '<input>Test Input</input>';
    private static final String RESPONSE_BODY = '{"output":"Test Output"}';
    private static final Integer RESPONSE_SUCCESS = 200;
    private static final Integer TIMEOUT = 120000;
    private static final Boolean ISCOMPRESSED = true;
    private static final String KEY1 = 'key1';
    private static final String KEY2 = 'key2';
    private static final String VALUE1 = 'value1';
    private static final String VALUE2 = 'value2';
    private static final String CERTIFICATE = 'Test Certificate';*/

    @testsetup
    static void testSetup()
    {
        Id gymNo_01_Id = createGym('Gym1', '111-gym-111');
        //Id gymNo_02_Id = createGym('Gym2', '222-gym-222');
        createGymOwner(gymNo_01_Id,'Test','Con1','test1@gmail.com','919547812589','Test1');
        //createGymOwner(gymNo_01_Id,'Test','Con2','test2@gmail.com','919547832589','Test2');
        createTeam(gymNo_01_Id,'Test Team1');
        //createTeam(gymNo_01_Id,'Test Team2');
        
        //Insert Custom Setting data
        FF_Credentials__c ffCreds = new FF_Credentials__c();
        ffCreds.Endpoint__c = 'http://example.com/';
        ffCreds.User_Id__c = 'user@user.com';
        ffCreds.Password__c = 'user@123';
        insert ffCreds;
        
       
    }
    static Id createGym(String name,String gymId)
    {
        Account acc = new Account();
        acc.name = name;
        acc.gym_id__c = gymId;
        acc.Type = 'All Star';
        acc.ShippingCity = 'Test';
        insert acc;
        return acc.Id;
    }
    static Id  createGymOwner(Id accId, String fName, String lName, String email, String phone, String ffType)
    {
        Contact con = new Contact();
        if(accId != null)
            con.AccountId = accId;
        con.FirstName = fName;
        con.LastName = lName;
        con.Email = email;
        con.MobilePhone = phone;
        con.fit_freedom_Type__c = ffType;
        insert con;
        return con.Id;
    }   
    static Id  createTeam(Id accId, String name)
    {
        Rosters__c ros = new Rosters__c();
        ros.Name = name;
        ros.Account__c = accId;
        insert ros;
        return ros.Id;
    }
    
    @isTest
    static void callWizardToPerformTask_P()
    {
         Profile p = [select id 
                     from 
                     Profile 
                     where 
                     name='System Administrator']; 
        
        User bdeUser = new user(alias = 'test123', email='test123@noemail.com', 
                                emailencodingkey='UTF-8', firstName='Nahush', lastname='Testing', languagelocalekey='en_US',
                            localesidkey='en_IN', profileid = p.Id, country='India',
                            timezonesidkey='Asia/Kolkata', username='test_g@noemail.com'); 
        insert bdeUser;
        
        
        PermissionSet ps = new PermissionSet(Label = 'mockPs', Name = 'mockPs');
        insert ps;
        
        // Given custom permission associated to the mocked PermissionSet
        SetupEntityAccess sea = new SetupEntityAccess(
            ParentId = ps.Id,
            SetupEntityId = [SELECT Id FROM CustomPermission
                             WHERE DeveloperName = 'Fit_Freedom_User'][0].Id
        );
        insert sea;
        
        // Given mocked Permission Set assigned to user for test
        PermissionSetAssignment psa = new PermissionSetAssignment(
            AssigneeId = bdeUser.Id,
            PermissionSetId = ps.Id
        );
        insert psa;
        
        system.runAs(bdeUser){
        List<Account> gyms = [SELECT ID FROM Account];
        System.assertEquals(1, gyms.size());
        
        Test.setCurrentPageReference(Page.FF_Create_Gym);
        System.currentPageReference().getParameters().put('Id', gyms[0].Id);
        FF_CreateGymController ffCreateGymController = new FF_CreateGymController();
        
        List<HTTPCalloutConfiguration__mdt> createNewGymMDT = [Select EndPoint__c From HTTPCalloutConfiguration__mdt WHERE DeveloperName = 'FF3_Create_New_Gym' ];
        System.assertEquals(1, createNewGymMDT.size());
        System.assert(String.isNotBlank(createNewGymMDT[0].EndPoint__c));
        
        
        //Setting Mock 
        FF_GetAccessToken_Mock accessTokenMock = new FF_GetAccessToken_Mock();
        FF3_Create_New_Gym_Mock createNewGymMock = new FF3_Create_New_Gym_Mock();
        //FF3_0_Find_One_Team_Mock findOneTeamMock = new FF3_0_Find_One_Team_Mock();
        Map<String, HttpCalloutMock> mapMock = new Map<String, HttpCalloutMock>();
        mapMock.put('http://example.com/',accessTokenMock);
        //mapMock.put(endPoint ,createNewTeamMock);
        mapMock.put(createNewGymMDT[0].EndPoint__c ,createNewGymMock);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(mapMock);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        //Start Test
        Test.startTest();
        
        
        ffCreateGymController.goToTeam();
        ffCreateGymController.goToGymOwner();
        ffCreateGymController.goToGym();
        ffCreateGymController.goToReviewPage();
        
        ffCreateGymController.step1();
        ffCreateGymController.contact.FirstName = 'Test';
        ffCreateGymController.contact.LastName = 'Gym Owner';
        ffCreateGymController.contact.Email = 'test3@gmail.com';
        ffCreateGymController.contact.MobilePhone = '918645747834';
        ffCreateGymController.contact.AccountId = gyms[0].id;
        ffCreateGymController.step2();
        ffCreateGymController.roster.Name = 'New Roster';
        ffCreateGymController.step3();
        //ffCreateGymController.useDefaultGymOwner();
        
        
        ffCreateGymController.save();
        
        //Stop test
        Test.stopTest();
        
        List<Account> gymsUpdated = [SELECT gym_id__c, owner__c, owner_name__c, FF_Create_Gym_Successful__c, Gym_Owner__c FROM Account];
        System.assertNotEquals(null, gymsUpdated[0].gym_id__c);
        
        
        List<Contact> contactsUpdated = [SELECT member_id__c, gym_id__c, FF_Create_Owner_Successfully__c FROM Contact WHERE LastName = 'Gym Owner'];
        System.assertEquals(1, contactsUpdated.size());
        
        
        List<Rosters__c> rostersUpdated = [SELECT gym_id__c, rosters_id__c, FF_Create_Rosters_Successful__c FROM Rosters__c WHERE Name = 'New Roster'];
        System.assertEquals(1, rostersUpdated.size());
       
        }
    }
    
    @isTest
    static void callWizardToPerformTask_N(){
        List<Account> gyms = [SELECT ID FROM Account];
        List<Contact> gymOwner = [SELECT ID FROM Contact];
        List<Rosters__c> gymTeam = [SELECT ID FROM Rosters__c];
        
        Test.setCurrentPageReference(Page.FF_Create_Gym);
        System.currentPageReference().getParameters().put('Id', gyms[0].Id);
        FF_CreateGymController ctrl = new FF_CreateGymController();
        
        //Start Test
        Test.startTest();
     
		ctrl.step1();
		ctrl.step2();
		ctrl.step3();
		
		ctrl.useDefaultGymOwner();
		
		ctrl.selectedContactId = gymOwner[0].id;		
		ctrl.selectedContact();
		
		ctrl.selectedRosterId = gymTeam[0].id;
		ctrl.selectedRoster();
		
        
		//Stop Test
        Test.stopTest();
    }
    
}