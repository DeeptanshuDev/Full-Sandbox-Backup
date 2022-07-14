@isTest(seealldata = false)
public class Test_ContactUsController {
    
    @isTest
    static void test_saveContact() {
		Profile profile = [SELECT Id FROM Profile WHERE Name='Customer Community Login User (Rebel)' LIMIT 1];
        if(profile != null) 
        {
			List<User> users = [SELECT Id, FirstName, LastName, Email FROM User WHERE ProfileId =: profile.Id];
			if(users != null && users.size() > 0) 
			{
				ContactUs__c newConUs = new ContactUs__c(First_Name__c ='Test', Last_Name__c = 'ContactUs', Email__c = 'test@gmail.com');
				insert newConUs;
				newConUs = new ContactUs__c(Id = newConUs.Id, First_Name__c ='Test1', Last_Name__c = 'ContactUs1', Email__c = 'test1@gmail.com');
				update newConUs;
				Test.startTest();
				System.runAs(users[0]) {
					ContactUsController.saveContact(newConUs.Id);
				}
				Test.stopTest();
			}  
		}
    } 
    
    @isTest
    static void test_getForm() {
        Profile profile = [SELECT Id FROM Profile WHERE Name='Customer Community Login User (Rebel)' LIMIT 1];
        if(profile != null) 
        {
			List<User> users = [SELECT Id FROM User WHERE ProfileId =: profile.Id];    
			if(users != null && users.size() > 0) 
			{
				Test.startTest();
				System.runAs(users[0]) {
					ContactUsController.getForm('Account','MC4SF__Account_Filter_Fields');
				} 
				Test.stopTest();
			}
		}
    }
}