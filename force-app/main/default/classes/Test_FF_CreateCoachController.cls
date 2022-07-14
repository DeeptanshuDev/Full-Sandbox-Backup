/**
*  Description     :   Test class vf page controller class FF_CreateCoachController.
*            
*  Create By       :   
*
*  Created Date    :   31-07-2020
*
*  Revision Log    :   V_1.0 - Created - 31-07-2020
*
*  Coverage        :   
*
**/
@isTest(seeAllData = false)
public class Test_FF_CreateCoachController
{

     //Make testSetUp data for testing purpose
    @testSetUp 
    private static void testSetupData()
    {
        Account acc = new Account(Name = 'Test Acc', gym_id__c = '111-gym-111', FF_Create_Gym_Successful__c = TRUE);
        insert acc;
        
        List<Contact> cons = new List<Contact>();
        cons.add(new Contact(FirstName ='Test', LastName = 'Test Con1', Email = 'con1@con.com', Phone = '9876543210', AccountId = acc.Id));
        insert cons;
        
        //Insert Custom Setting data
        FF_Credentials__c ffCreds = new FF_Credentials__c();
        ffCreds.Endpoint__c = 'http://example.com/';
        ffCreds.User_Id__c = 'user@user.com';
        ffCreds.Password__c = 'user@123';
        insert ffCreds;
    }
    
    @isTest
    private static void positive1_save() 
    {
        Profile p = [select id 
                     from 
                     Profile 
                     where 
                     name='System Administrator']; 
        
        User bdeUser = new user(alias = 'test123', email='test123@noemail.com', 
                                emailencodingkey='UTF-8', firstName='Nahush', lastname='Testing', languagelocalekey='en_US',
                            localesidkey='en_IN', profileid = p.Id, country='India',
                            timezonesidkey='Asia/Kolkata', username='test_g'+math.random()+'@noemail.com'); 
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
        List<Account> accs = [SELECT Id FROM Account];
        System.assertEquals(1, accs.size());
        
        List<Contact> cons = [SELECT Id FROM Contact];
        System.assertEquals(1, cons.size());
        
        //Setting vf page reference
        Test.setCurrentPageReference(Page.FF_Create_Coach);
        System.currentPageReference().getParameters().put('Id', accs[0].Id);
        
        //Geting metadata
        List<HTTPCalloutConfiguration__mdt> createNewUserMDT = [Select EndPoint__c From HTTPCalloutConfiguration__mdt WHERE DeveloperName = 'FF3_0_Create_New_User' ];
        System.assertEquals(1, createNewUserMDT.size());
        System.assert(String.isNotBlank(createNewUserMDT[0].EndPoint__c));
        List<HTTPCalloutConfiguration__mdt> getUserByIdMDT = [Select EndPoint__c From HTTPCalloutConfiguration__mdt WHERE DeveloperName = 'FF3_0_Get_Users_By_Id' ];
        System.assertEquals(1, getUserByIdMDT.size());
        System.assert(String.isNotBlank(getUserByIdMDT[0].EndPoint__c));
        
        //Setting Mock 
        FF_GetAccessToken_Mock accessTokenMock = new FF_GetAccessToken_Mock();
        FF3_0_Create_New_User_Mock createNewUserMock = new FF3_0_Create_New_User_Mock();
        FF3_0_Get_Users_By_Id_Mock getUserByIdMock = new FF3_0_Get_Users_By_Id_Mock();
        Map<String, HttpCalloutMock> mapMock = new Map<String, HttpCalloutMock>();
        mapMock.put('http://example.com/',accessTokenMock);
        mapMock.put(createNewUserMDT[0].EndPoint__c ,createNewUserMock);
        mapMock.put(getUserByIdMDT[0].EndPoint__c ,getUserByIdMock);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(mapMock);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        //Start Test
        Test.startTest();
        FF_CreateCoachController ctrl = new FF_CreateCoachController();
       
        System.assertEquals(1, ctrl.contactData.size());
        
        //Calling Save Method
        ctrl.contactData[0].checked = TRUE;
        ctrl.save();
        
        //Stop Test
        Test.stopTest();
        
        List<Contact> conUpdated = [SELECT Id, user_id__c FROM Contact];
        System.debug('conUpdated = ' + conUpdated);
       
        }
    }
    
    @isTest
    private static void positive2_save() 
    {
        Profile p = [select id 
                     from 
                     Profile 
                     where 
                     name='System Administrator']; 
        
        User bdeUser = new user(alias = 'test123', email='test123@noemail.com', 
                                emailencodingkey='UTF-8', firstName='Nahush', lastname='Testing', languagelocalekey='en_US',
                            localesidkey='en_IN', profileid = p.Id, country='India',
                            timezonesidkey='Asia/Kolkata', username='test_g'+math.random()+'@noemail.com'); 
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
        List<Account> accs = [SELECT Id FROM Account];
        System.assertEquals(1, accs.size());
        
        List<Contact> cons = [SELECT Id FROM Contact];
        System.assertEquals(1, cons.size());
		delete cons;
        
        //Setting vf page reference
        Test.setCurrentPageReference(Page.FF_Create_Coach);
        System.currentPageReference().getParameters().put('Id', accs[0].Id);
        FF_CreateCoachController ctrl = new FF_CreateCoachController();
        FF_CreateCoachController.testCov();
            
        //Geting metadata
        List<HTTPCalloutConfiguration__mdt> createNewUserMDT = [Select EndPoint__c From HTTPCalloutConfiguration__mdt WHERE DeveloperName = 'FF3_0_Create_New_User' ];
        System.assertEquals(1, createNewUserMDT.size());
        System.assert(String.isNotBlank(createNewUserMDT[0].EndPoint__c));
        List<HTTPCalloutConfiguration__mdt> getUserByIdMDT = [Select EndPoint__c From HTTPCalloutConfiguration__mdt WHERE DeveloperName = 'FF3_0_Get_Users_By_Id' ];
        System.assertEquals(1, getUserByIdMDT.size());
        System.assert(String.isNotBlank(getUserByIdMDT[0].EndPoint__c));
        
        //Setting Mock 
        FF_GetAccessToken_Mock accessTokenMock = new FF_GetAccessToken_Mock();
        FF3_0_Create_New_User_Mock createNewUserMock = new FF3_0_Create_New_User_Mock();
        FF3_0_Get_Users_By_Id_Mock getUserByIdMock = new FF3_0_Get_Users_By_Id_Mock();
        Map<String, HttpCalloutMock> mapMock = new Map<String, HttpCalloutMock>();
        mapMock.put('http://example.com/',accessTokenMock);
        mapMock.put(createNewUserMDT[0].EndPoint__c ,createNewUserMock);
        //mapMock.put(getUserByIdMDT[0].EndPoint__c ,getUserByIdMock);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(mapMock);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        //Start Test
        Test.startTest();
        
        System.assertEquals(0, ctrl.contactData.size());
        
        
        
        //Calling Save Method
        ctrl.newContact.FirstName = 'Test';
		ctrl.newContact.LastName = 'Coach';
		ctrl.newContact.Email = 'con@test.com';
		ctrl.newContact.MobilePhone = '9876543210';
        ctrl.save();
        
        //Stop Test
        Test.stopTest();
        
        List<Contact> conUpdated = [SELECT Id, user_id__c FROM Contact];
        System.debug('conUpdated = ' + conUpdated);
      
        }
    }
    
    
    @isTest
    private static void test_cancel() 
    {
        List<Account> accs = [SELECT Id FROM Account];
        System.assertEquals(1, accs.size());
        
        accs[0].gym_id__c = '';
        accs[0].FF_Create_Gym_Successful__c = false;
        update accs;
        
        List<Contact> cons = [SELECT Id FROM Contact];
        System.assertEquals(1, cons.size());
		
        
        //Setting vf page reference
        Test.setCurrentPageReference(Page.FF_Create_Coach);
        System.currentPageReference().getParameters().put('Id', accs[0].Id);
        FF_CreateCoachController ctrl = new FF_CreateCoachController();
        
        //Calling cancel method
        ctrl.cancel();
        ctrl.cancel1();
        Test.setCurrentPageReference(Page.FF_Create_Coach);
        System.currentPageReference().getParameters().put('Id', null);
        FF_CreateCoachController ctrl1 = new FF_CreateCoachController();
        
        Test.setCurrentPageReference(Page.FF_Create_Coach);
        System.currentPageReference().getParameters().put('Id', '0013K00000Jpk90');
        FF_CreateCoachController ctrl3 = new FF_CreateCoachController();
    }
}