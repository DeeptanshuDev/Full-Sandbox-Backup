/**
*  Description     :   Test class for vf page controller class FF_Create_FF_Order_Controller.
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
public class Test_FF_Create_FF_Order_Controller
{

    //Make testSetUp data for testing purpose
    @testSetUp 
    private static void testSetupData()
    {
        System.debug('Inside Setup');
        Account acc = new Account(Name = 'Test Acc', gym_id__c = '111-gym-111', FF_Create_Gym_Successful__c = TRUE);
        System.debug('acc = ' + acc);
        insert acc;
        List<Account> accounts = [SELECT Id FROM Account];
        System.debug('accounts = '  +accounts.size());
        
        Rosters__c ros = new Rosters__c(Name = 'Test Rosters', Account__c = acc.Id);
        insert ros;
        List<Rosters__c> rost = [SELECT Id FROM Rosters__c];
        System.debug('rost = '  +rost[0].id);
        System.debug('rost = '  +rost.size());
        
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

        System.debug('Inside save');
        List<Rosters__c> ros = [SELECT Id FROM Rosters__c];
        System.debug('ros = '  +ros[0].id);
        System.debug('ros = '  +ros.size());
        System.assertEquals(1, ros.size());
        
        List<Account> accounts = [SELECT Id FROM Account];
        System.debug('accounts = '  +accounts.size());
        System.assertEquals(1, accounts.size());
        
        //Setting vf page reference
        Test.setCurrentPageReference(Page.FF_Create_Order_Page);
        System.currentPageReference().getParameters().put('Id', accounts[0].Id);
        FF_Create_FF_Order_Controller ctrl = new FF_Create_FF_Order_Controller();
        
        //Geting metadata
        List<HTTPCalloutConfiguration__mdt> createTeamMDT = [Select EndPoint__c From HTTPCalloutConfiguration__mdt WHERE DeveloperName = 'FF3_0_Create_Team' ];
        System.assertEquals(1, createTeamMDT.size());
        System.assert(String.isNotBlank(createTeamMDT[0].EndPoint__c));
        //String endPoint = 'http://ec2-34-207-252-139.compute-1.amazonaws.com:3001/v/1/team'; //this should be replaced with metadata record
        List<HTTPCalloutConfiguration__mdt> findOneTeamMDT = [Select EndPoint__c From HTTPCalloutConfiguration__mdt WHERE DeveloperName = 'FF3_0_Find_One_Team' ];
        System.assertEquals(1, findOneTeamMDT.size());
        System.assert(String.isNotBlank(findOneTeamMDT[0].EndPoint__c));
        
        
        //Setting Mock 
        FF_GetAccessToken_Mock accessTokenMock = new FF_GetAccessToken_Mock();
        FF3_0_Create_New_Team_Mock createNewTeamMock = new FF3_0_Create_New_Team_Mock();
        FF3_0_Find_One_Team_Mock findOneTeamMock = new FF3_0_Find_One_Team_Mock();
        Map<String, HttpCalloutMock> mapMock = new Map<String, HttpCalloutMock>();
        mapMock.put('http://example.com/',accessTokenMock);
        mapMock.put(createTeamMDT[0].EndPoint__c ,createNewTeamMock);
        mapMock.put(findOneTeamMDT[0].EndPoint__c ,findOneTeamMock);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(mapMock);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        //Start Test
        Test.startTest();
        
        System.assertEquals(1, ctrl.teamDetails.size());
        
        //Calling cancel method
        ctrl.navigateToAccountDetailPage();
        
        //Calling Save Method
        //ctrl.roster.Name = 'New Roster';
        ctrl.teamDetails[0].isSelected = TRUE;
        ctrl.save();
        
        //Stop Test
        Test.stopTest();
        List<Rosters__c> rosUpdated = [SELECT Id, Rosters_id__c FROM Rosters__c];
        System.debug('rosUpdated = ' + rosUpdated);
        System.assertEquals(1, ros.size());
        System.assertNotEquals(null, rosUpdated[0].Rosters_id__c);
        
    }
    
    
}