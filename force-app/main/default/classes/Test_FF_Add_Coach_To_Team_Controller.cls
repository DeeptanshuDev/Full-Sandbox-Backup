/**
*  Description     :   Test class vf page controller class FF_Add_Coach_To_Team_Controller.
*            
*  Create By       :   
*
*  Created Date    :   03-07-2020
*
*  Revision Log    :   V_1.0 - Created - 03-07-2020
*
*  Coverage        :   
*
**/

@isTest(seeAllData = false)
private class Test_FF_Add_Coach_To_Team_Controller
{
    //Make testSetUp data for testing purpose
    @testSetUp 
    private static void testSetupData()
    {
        Account acc = new Account(Name = 'Test Acc', gym_id__c = '111-gym-111', FF_Create_Gym_Successful__c = TRUE);
        insert acc;
        
        Rosters__c ros = new Rosters__c(Name = 'Test Rosters', FF_Create_Rosters_Successful__c = TRUE, rosters_id__c = '111-ros-111', Account__c = acc.Id);
        insert ros;
        
        List<Contact> cons = new List<Contact>();
        cons.add(new Contact(LastName = 'Test Con1', Email = 'con1@con.com', MobilePhone = '9876543210', fit_freedom_Type__c = 'Coach', 
                             FF_Create_Owner_Successfully__c = TRUE, user_id__c = '111-coach-111', AccountId = acc.Id));
        cons.add(new Contact(LastName = 'Test Con2', Email = 'con2@con.com', MobilePhone = '9876543211', 
                             FF_Create_Owner_Successfully__c = TRUE, user_id__c = '222-coach-222', AccountId = acc.Id));
        cons.add(new Contact(LastName = 'Test Con3', Email = 'con3@con.com', MobilePhone = '9876543212', 
                             FF_Create_Owner_Successfully__c = false, user_id__c = '333-coach-333', AccountId = acc.Id));
        insert cons;
        
        //Insert Custom Setting data
        FF_Credentials__c ffCreds = new FF_Credentials__c();
        ffCreds.Endpoint__c = 'http://example.com/';
        ffCreds.User_Id__c = 'user@user.com';
        ffCreds.Password__c = 'user@123';
        insert ffCreds;
    }
    
    @isTest
    private static void positive_save() 
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
        List<Rosters__c> rosters = [SELECT Id FROM Rosters__c];
        System.assertEquals(1, rosters.size());
        
        //Setting vf page reference
        Test.setCurrentPageReference(Page.FF_Add_Coach_To_Team_Page);
        System.currentPageReference().getParameters().put('Id', rosters[0].Id);
        FF_Add_Coach_To_Team_Controller ctrl = new FF_Add_Coach_To_Team_Controller();
        
        //Geting metadata
        List<HTTPCalloutConfiguration__mdt> mdt = [Select EndPoint__c From HTTPCalloutConfiguration__mdt WHERE DeveloperName = 'FF3_0_Add_Coach_To_Team' ];
        System.assertEquals(1, mdt.size());
        System.assert(String.isNotBlank(mdt[0].EndPoint__c));
        
        //Setting Mock 
        FF_GetAccessToken_Mock accessTokenMock = new FF_GetAccessToken_Mock();
        FF3_0_Add_Coach_To_Team_Mock addCoachMock = new FF3_0_Add_Coach_To_Team_Mock();
        Map<String, HttpCalloutMock> mapMock = new Map<String, HttpCalloutMock>();
        mapMock.put('http://example.com/',accessTokenMock);
        mapMock.put(mdt[0].EndPoint__c ,addCoachMock);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(mapMock);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        //Start Test
        Test.startTest();
        
        System.assertEquals(2, ctrl.contactData.size());
       
        //Calling cancel method
        ctrl.cancel();
        
        //Calling Save Method
        ctrl.contactData[0].checked = TRUE;
		ctrl.contactData[1].checked = TRUE;
        ctrl.save();
        
        Set<ID> conIds = new Set<ID>{ctrl.contactData[0].con.Id, ctrl.contactData[1].con.Id};
            
        List<Contact> cons = [SELECT Id FROM Contact WHERE ID IN: conIds];
        System.assertEquals(2, cons.size());
       
        //Stop Test
        Test.stopTest();
        }
    }
    
    @isTest
    private static void neg_Controller_Errors()
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
        List<Rosters__c> rosters = [SELECT Id, Name, rosters_id__c, FF_Create_Rosters_Successful__c, Deleted_From_FF__c, 
                                    Account__c, Account__r.gym_id__c, Account__r.FF_Create_Gym_Successful__c, Account__r.Deleted_From_FF__c
                                    FROM Rosters__c];
        System.assertEquals(1, rosters.size());
        
        //Setting vf page reference
        Test.setCurrentPageReference(Page.FF_Add_Coach_To_Team_Page);
        FF_Add_Coach_To_Team_Controller ctrl;
        
       
        
        //Valid url id
        System.currentPageReference().getParameters().put('Id', rosters[0].Id);
        
        List<Contact> cons = [SELECT Id FROM CONTACT];
        delete cons;
        
        //Error - no contact inserted
        ctrl = new FF_Add_Coach_To_Team_Controller();
        System.assertEquals('There are no eligible Coach for FF or they are already in FF.', ctrl.errorMessage);
        
        //Error - blank rosters_id
        rosters[0].rosters_id__c = '';
        update rosters;
        ctrl = new FF_Add_Coach_To_Team_Controller();
        System.assertEquals('This Team doesn\'t exist on FF side. First add this Team on FF side.', ctrl.errorMessage);
        
        //Error - false FF_Create_Rosters_Successful__c 
        rosters[0].FF_Create_Rosters_Successful__c = FALSE;
        update rosters;
        ctrl = new FF_Add_Coach_To_Team_Controller();
        System.assertEquals('This Team doesn\'t exist on FF side. First add this Team on FF side.', ctrl.errorMessage);
        
		//Udating acc
        List<Account> accs = [SELECT gym_id__c, Deleted_From_FF__c, FF_Create_Gym_Successful__c FROM Account];
        System.assertEquals(1, accs.size());
        
		//Error - blank gym_id 
        accs[0].gym_id__c = '';
        update accs;
        ctrl = new FF_Add_Coach_To_Team_Controller();
        System.assertEquals('This Gym doesn\'t exist on FF side. First add this Gym and Team on FF side.', ctrl.errorMessage);
		
		//Error - FF_Create_Gym_Successful__c =false
        accs[0].FF_Create_Gym_Successful__c = FALSE;
        update accs;
        ctrl = new FF_Add_Coach_To_Team_Controller();
        System.assertEquals('This Gym doesn\'t exist on FF side. First add this Gym and Team on FF side.', ctrl.errorMessage);       
        
        
        //Error - Deleted_From_FF__c rosters
        rosters[0].Deleted_From_FF__c = TRUE;
        update rosters;
        ctrl = new FF_Add_Coach_To_Team_Controller();
        System.assertEquals('This Team is deleted.', ctrl.errorMessage);
        
        //Error - Deleted_From_FF__c gym
        accs[0].Deleted_From_FF__c = TRUE;
        update accs;
        ctrl = new FF_Add_Coach_To_Team_Controller();
        System.assertEquals('This Gym is deleted.', ctrl.errorMessage);
        }
    }
    
    @isTest
    private static void neg_saveMethod_Errors()
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
        List<Rosters__c> rosters = [SELECT Id FROM Rosters__c];
        System.assertEquals(1, rosters.size());
        
        //Setting vf page reference
        Test.setCurrentPageReference(Page.FF_Add_Coach_To_Team_Page);
        System.currentPageReference().getParameters().put('Id', rosters[0].Id);
        FF_Add_Coach_To_Team_Controller ctrl = new FF_Add_Coach_To_Team_Controller();
       
        //Error - no contact selected
        ctrl.save();
        System.assertEquals('Please select atleast 1 contact.', ctrl.errorMessage);
        
        //Error - catch block
        ctrl = new FF_Add_Coach_To_Team_Controller();
        ctrl.contactData[0].checked = TRUE;
		ctrl.save();
        
        //Geting endpoint from metadata
        List<HTTPCalloutConfiguration__mdt> mdt = [Select EndPoint__c From HTTPCalloutConfiguration__mdt WHERE DeveloperName = 'FF3_0_Add_Coach_To_Team' ];
        System.assertEquals(1, mdt.size());
        System.assert(String.isNotBlank(mdt[0].EndPoint__c));
        
        //Setting Mock 
        FF_GetAccessToken_Mock accessTokenMock = new FF_GetAccessToken_Mock();
        FF3_0_Add_Coach_To_Team_Mock addCoachMock = new FF3_0_Add_Coach_To_Team_Mock('success_WrongMsg');
        Map<String, HttpCalloutMock> mapMock = new Map<String, HttpCalloutMock>();
        mapMock.put('http://example.com/',accessTokenMock);
        mapMock.put(mdt[0].EndPoint__c ,addCoachMock);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(mapMock);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        //Error - wrong response message for successful callout
        ctrl = new FF_Add_Coach_To_Team_Controller();
        ctrl.save();
        
        //Error - error response
        /*addCoachMock = new FF3_0_Add_Coach_To_Team_Mock('error');
        mapMock = new Map<String, HttpCalloutMock>();
        mapMock.put('http://example.com/',accessTokenMock);
        mapMock.put(mdt[0].EndPoint__c ,addCoachMock);
        multiCalloutMock = new MultiRequestMock(mapMock);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        ctrl = new FF_Add_Coach_To_Team_Controller();
        ctrl.save();*/
    }
    }
}