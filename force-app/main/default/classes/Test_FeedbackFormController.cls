@isTest(seealldata = false)
public class Test_FeedbackFormController {
    
    @isTest
    static void test_saveFeedback() {
        Profile profile = [SELECT Id FROM Profile WHERE Name='Customer Community Login User (Rebel)' LIMIT 1];
        if(profile != null)  
        {
			List<User> users = [SELECT Id, FirstName, LastName, Email FROM User WHERE ProfileId =: profile.Id];
			if(users != null && users.size() > 0)
			{   
				Feedback__c newFeedRecord = new Feedback__c(Name__c ='Test', Email__c = 'test@gmail.com');
				insert newFeedRecord;
				
				newFeedRecord = new Feedback__c(Id =newFeedRecord.Id, Name__c ='Test', Email__c = 'test@gmail.com');
				update newFeedRecord;
				
				Test.startTest();
				System.runAs(users[0]) {
					FeedbackFormController.saveFeedback(newFeedRecord.Id);
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
					FeedbackFormController.getForm('Account','MC4SF__Account_Filter_Fields');
				} 
				Test.stopTest();
			}
		}		      
    }
}