/**
*  Description     :   Test class for vf page controller class FF_Add_Athlete_To_Team.
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
public class Test_FF_Add_Athlete_To_Team
{

    //Make testSetUp data for testing purpose
    @testSetUp 
    private static void testSetupData()
    {
        Account acc = new Account(Name = 'Test Acc', gym_id__c = '111-gym-111', FF_Create_Gym_Successful__c = TRUE);
        insert acc;
        
        Rosters__c ros = new Rosters__c(Name = 'Test Rosters',rosters_id__c = '111-ros-111', FF_Create_Rosters_Successful__c = TRUE, Account__c = acc.Id);
        insert ros;
        
        List<Contact> cons = new List<Contact>();
        cons.add(new Contact(FirstName ='Test', LastName = 'Test Con1', Email = 'con1@con.com', Phone = '9876543210', AccountId = acc.Id));
        insert cons;
        
        //Insert Custom Setting data used for callout
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
        List<Account> accs = [SELECT Id FROM Account];
        System.assertEquals(1, accs.size());
        
        List<Rosters__c> ros = [SELECT Id FROM Rosters__c];
        System.assertEquals(1, ros.size());
        
        List<Contact> cons = [SELECT Id FROM Contact];
        System.assertEquals(1, cons.size());
        
        //Setting vf page reference
        Test.setCurrentPageReference(Page.FF_Add_Athlete_To_Team);
        System.currentPageReference().getParameters().put('Id', ros[0].Id);
        FF_Add_Athlete_To_Team ctrl = new FF_Add_Athlete_To_Team();
        
        //Geting metadata
        List<HTTPCalloutConfiguration__mdt> createNewAthleteMDT = [Select EndPoint__c From HTTPCalloutConfiguration__mdt WHERE DeveloperName = 'FF_3_0_Create_New_Athlete' ];
        System.assertEquals(1, createNewAthleteMDT.size());
        System.assert(String.isNotBlank(createNewAthleteMDT[0].EndPoint__c));
        
        //Setting Mock 
        FF_GetAccessToken_Mock accessTokenMock = new FF_GetAccessToken_Mock();
        FF_3_0_Create_New_Athlete_Mock createNewAthleteMock = new FF_3_0_Create_New_Athlete_Mock();
        Map<String, HttpCalloutMock> mapMock = new Map<String, HttpCalloutMock>();
        mapMock.put('http://example.com/',accessTokenMock);
        mapMock.put(createNewAthleteMDT[0].EndPoint__c ,createNewAthleteMock);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(mapMock);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        //Start Test
        Test.startTest();
        
        System.assertEquals(1, ctrl.contactData.size());
       
        //Calling Save Method
        ctrl.contactData[0].checked = TRUE;
        ctrl.save();
        
        //Stop Test
        Test.stopTest();
        
        List<Contact> conUpdated = [SELECT Id, Rosters__c FROM Contact];
        System.debug('conUpdated = ' + conUpdated);
        System.assertEquals(1, conUpdated.size());
        System.assertEquals(ros[0].id, conUpdated[0].Rosters__c);
        }
    }
    
    
    @isTest
    private static void test_cancel() 
    {
        List<Account> accs = [SELECT Id FROM Account];
        System.assertEquals(1, accs.size());
        
        List<Rosters__c> ros = [SELECT Id FROM Rosters__c];
        System.assertEquals(1, ros.size());
        
        List<Contact> cons = [SELECT Id FROM Contact];
        System.assertEquals(1, cons.size());
        
        //Setting vf page reference
        Test.setCurrentPageReference(Page.FF_Add_Athlete_To_Team);
        System.currentPageReference().getParameters().put('Id', ros[0].Id);
        FF_Add_Athlete_To_Team ctrl = new FF_Add_Athlete_To_Team();
        
        ctrl.cancel();
    }
    
    @isTest
    private static void test_negativeCases() 
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
        List<Account> accs = [SELECT Id FROM Account];
        System.assertEquals(1, accs.size());
        
        List<Rosters__c> ros = [SELECT Id FROM Rosters__c];
        System.assertEquals(1, ros.size());
        
        List<Contact> cons = [SELECT Id FROM Contact];
        System.assertEquals(1, cons.size());
        
        
        
        //Setting vf page reference
        Test.setCurrentPageReference(Page.FF_Add_Athlete_To_Team);
        
        //Calling Cunsturctor
        FF_Add_Athlete_To_Team ctrl = new FF_Add_Athlete_To_Team();
        System.assert(String.isNotBlank(ctrl.errorMessage));
        
        //Stting wrong record id and calling custructor
        Rosters__c newRos = new Rosters__c(Name = 'Test Rosters', FF_Create_Rosters_Successful__c = FALSE, Account__c = accs[0].Id);
        insert newRos;
        System.currentPageReference().getParameters().put('Id', newRos.id);
        
        FF_Add_Athlete_To_Team ctrl2 = new FF_Add_Athlete_To_Team();
        System.assert(String.isNotBlank(ctrl2.errorMessage));
        
        //Setting correct record id and calling new cunstructor
        System.currentPageReference().getParameters().put('Id', ros[0].Id);
        
        FF_Add_Athlete_To_Team ctrl3 = new FF_Add_Athlete_To_Team();
        
        //Calling save method without selected records
        ctrl3.save();
        System.assert(String.isNotBlank(ctrl3.errorMessage));
        }
    }
    
}