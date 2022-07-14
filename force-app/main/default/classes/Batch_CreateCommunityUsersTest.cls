//Test class to programatically test out Batch_CreateCommunityUsers job associated positive and negative use cases
@isTest(SeeAllData=false)
public class Batch_CreateCommunityUsersTest 
{
    //Setup method to create the test data
    @testSetup static void testSetup() 
    {
        List<Profile> profiles = [SELECT Id FROM Profile 
                                  WHERE Name =: System.Label.System_Administrator_Profile_Name 
                                  OR Name =: System.Label.Rebel_Customer_Community_Profile_Name
                                  ORDER BY Name DESC
                                 ];
        System.assertEquals(2, profiles.size());
        List<UserRole> userRoles = new List<UserRole>();
        userRoles.add(new UserRole(Name = 'CEO'));
        insert userRoles;
        List<User> users = new List<User>();
        users.add(new User(Alias = 'standt', Email = 'test@gmail.com', 
                           EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey ='en_US', 
                           LocaleSidKey = 'en_US', ProfileId = profiles[0].Id, UserRoleId = userRoles[0].Id,
                           TimeZoneSidKey = System.Label.TimeZoneSidKey, UserName = 'test@gmail.com' + System.Label.User_Prefix));
        
        insert users;
        System.runAs(users[0])
        {
            List<Account> accounts = new List<Account>();
            for(Integer i = 0; i < 5; i++) 
            {
                accounts.add(new Account(Name = 'Test Account '+i));
            }
            insert accounts;
            List<Contact> contacts = new List<Contact>();
            contacts.add(new Contact(AccountId = accounts[0].Id, FirstName = 'Test1',LastName = 'MX',
                                     Email = 'test1@gmail.com', CreateCommunityUser__c = true, Primary__c = true));
            contacts.add(new Contact(AccountId = accounts[0].Id, FirstName = 'Test2',LastName = 'NX',
                                     Email = 'test2@gmail.com', CreateCommunityUser__c = true, Primary__c = true, Error_Message__c = 'Error Found'));
            contacts.add(new Contact(AccountId = accounts[0].Id, FirstName = 'Test3',LastName = 'OX',
                                     Email = 'test2@gmail.com', CreateCommunityUser__c = true, Primary__c = true));
            insert contacts;
            List<User> alreadyCommunityUsers = new List<User>();
            alreadyCommunityUsers.add(new User(Alias = 'testing', Email = 'test0@gmail.com', 
                                               EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', 
                                               LocaleSidKey = 'en_US', ProfileId = profiles[1].Id,
                                               TimeZoneSidKey = System.Label.TimeZoneSidKey, UserName = 'test0@gmail.com' + 
                                               System.Label.User_Prefix, ContactId = contacts[2].Id));
            
            insert alreadyCommunityUsers;
        }    
    }
    
    //Test Method to test out positive use cases
    @isTest static void testPositiveUseCases()
    {
        Util.processStringLiteral('TestTesting', 4, 'left');
        Util.processStringLiteral('TestTesting', 4, 'right');
        Util.processStringLiteral('Te', 4, 'left');
        Util.processStringLiteral('Te', 4, 'right');
        Util.processStringLiteral('Te', null, '');
        Util.processStringLiteral('TestTesting', 4, 'XYZ');
        
        Test.startTest();
        Database.executeBatch(new Batch_CreateCommunityUsers());
        Test.stopTest();
        
        /*Set<String> setOfLastNames = new Set<String>{'MX', 'NX'};
		List<User> users = [SELECT ID, Name FROM USER WHERE LastName IN : setOfLastNames];
        
        //Assert for generated community user
        System.assertEquals(2, users.size());   
        
        List<Contact> contacts = [SELECT ID, Community_User_Id__c FROM Contact WHERE Community_User_Id__c =: users[0].Id OR Community_User_Id__c =: users[1].Id];
        
        //Assert for updated contacts
        System.assertNotEquals(null, contacts[0].Community_User_Id__c);
        System.assertNotEquals(null, contacts[1].Community_User_Id__c);*/
    }
    
    //Test Method to test out negative use cases
    @isTest static void testNegativeUseCases()
    {
        List<Account> accounts = [SELECT Id FROM Account];
        List<Contact> duplicateContacts = new List<Contact>();
        
        duplicateContacts.add(new Contact(AccountId = accounts[0].Id, FirstName = 'Test4',LastName = 'PX',
                                          Email = 'test3@gmail.com', CreateCommunityUser__c = true, Primary__c = true));
        duplicateContacts.add(new Contact(AccountId = accounts[0].Id, FirstName = 'Test3',LastName = 'NX Other',
                                          Email = 'test2@gmail.com', CreateCommunityUser__c = true, Primary__c = true));
        insert duplicateContacts;   
        
        Test.startTest();
        Database.executeBatch(new Batch_CreateCommunityUsers());
        Test.stopTest();
        /*Set<String> setOfLastNames = new Set<String>{'MX', 'NX', 'PX'};
            
		List<User> users = [SELECT ID, Name 
                                FROM USER 
                                WHERE LastName IN : setOfLastNames];
        System.assertEquals(3, users.size());
        
        List<Contact> contacts = [SELECT ID, Community_User_Id__c FROM Contact WHERE Community_User_Id__c =: users[0].Id OR Community_User_Id__c =: users[1].Id
                                 OR Community_User_Id__c =: users[2].Id];
        
        //Assert for updated contacts
        System.assertNotEquals(null, contacts[0].Community_User_Id__c);
        System.assertNotEquals(null, contacts[1].Community_User_Id__c);
        System.assertNotEquals(null, contacts[2].Community_User_Id__c);
        
        users = [SELECT ID, Name FROM USER WHERE LastName =: 'NX Other'];
        System.assertEquals(0, users.size());
        
        contacts = [SELECT Id, Name, Error_Message__c FROM Contact WHERE AccountId =: accounts[0].Id];
        
        //Assert to see error message for failed user
        System.assertNotEquals(null, contacts[1].Error_Message__c);
        
        //Assert to see if email send out to admin user with error details
        Integer noOfEmail = Batch_CreateCommunityUsers.emailLimits;
        system.assertNotEquals(0, noOfEmail,'should have decreased');*/   
    }
}