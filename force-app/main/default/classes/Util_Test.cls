/**
*	Description		:	Apex Test class for . 
*
*	Created By		:   Abhinav Sharma
*
*	Created Date	:   10/12/2019
* 
*	Version			:   v1.0 - Created - CR - 00000046 - Abhinav Sharma         
**/
@isTest(seealldata = false)
private class Util_Test {

    @isTest
    static void testUtilUseCases()
    {
        Util.processStringLiteral('TestTesting', 4, 'left');
        Util.processStringLiteral('TestTesting', 4, 'right');
        Util.processStringLiteral('Te', 4, 'left');
        Util.processStringLiteral('Te', 4, 'right');
        Util.processStringLiteral('Te', null, '');
        Util.processStringLiteral('TestTesting', 4, 'XYZ');
        
         List<Profile> profiles = [SELECT Id FROM Profile 
                                  WHERE Name =: System.Label.System_Administrator_Profile_Name 
                                  OR Name =: System.Label.Rebel_Customer_Community_Profile_Name
                                  ORDER BY Name DESC
                                 ];
        
        List<User> users = new List<User>();
        users.add(new User(Alias = 'standt', Email = 'test@gmail.com', 
                           EmailEncodingKey = 'UTF-8', LastName = 'TestingUsr', LanguageLocaleKey ='en_US', 
                           LocaleSidKey = 'en_US', ProfileId = profiles[0].Id, 
                           TimeZoneSidKey = System.Label.TimeZoneSidKey, UserName = 'testU1@gmail.com' + System.Label.User_Prefix));
        
        insert users;
        
        Account acc = new Account();
        acc.Name = 'Test Record';
       
        Util.processSaveResults(Database.insert( new Account[]{acc}, false),users);
        
    }
}