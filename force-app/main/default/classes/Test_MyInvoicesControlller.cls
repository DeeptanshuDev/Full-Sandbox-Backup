@isTest(seealldata = false)
public class Test_MyInvoicesControlller {
    
    private static LightningResponseEntity responseString;
    
    @isTest(seealldata = true)
    static void test_getInit() {
        Profile profile = [SELECT Id FROM Profile WHERE Name='Customer Community Login User (Rebel)' LIMIT 1];
        if(profile != null)  
        {
			List<User> users = [Select Id, Contact.AccountId from User WHERE ProfileId =: profile.Id];
			if(users != null && users.size() > 0)
			{
				Test.startTest();
				System.runAs(users[0]){
					responseString = MyInvoicesController.getInit();
					System.assert(String.isNotBlank(String.valueOf(responseString.body)));
					MyInvoicesController.InitData response = (MyInvoicesController.InitData)JSON.deserialize(String.valueOf(responseString.body), MyInvoicesController.InitData.class);
					System.assert(String.isNotBlank(String.valueOf(response)));  
				}
				Test.stopTest();
			}
		}	
    }
}