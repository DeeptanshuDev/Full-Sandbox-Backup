@isTest(seealldata = false)
public class Test_MyOrdersItemsController {
 
    private static LightningResponseEntity responseString;
    private static Opportunity opp;
    
    @isTest(seealldata = true)
    static void test_getUser() {
        Profile profile = [SELECT Id FROM Profile WHERE Name='Customer Community Login User (Rebel)' LIMIT 1];
        if(profile != null)
        {
			List<User> users = [SELECT Id, Contact.AccountId FROM User WHERE ProfileId =: profile.Id];
			if(users != null && users.size() > 0)
			{
				Account newAcc = new Account(Name = 'Fexle', Type = 'Pro', Phone = '9685742563');
				insert newAcc;
				
				Contact newCon = new Contact(LastName = 'Gupta', AccountId = newAcc.Id);
				insert newCon;
				
				
				opp = new Opportunity();
				opp.Name = 'Test Opportunity';
				opp.AccountId = newAcc.id;
				opp.Type = 'New Order';
				opp.Primary_Contact__c = newCon.Id;
				opp.Category_Picklist__c = 'All Star' ;
				opp.Collection_Picklist__c = 'N/A';
				opp.StageName = 'Open';
				opp.Amount = 3000;
				opp.CloseDate = Date.today() + 1; 
				insert opp;
				
				Test.startTest();
				System.runAs(users[0]) {
					// System.assert(String.isNotBlank(users[0].Contact.AccountId));
					responseString = MyOrdersItemsController.getDesigns(opp.Id);
					System.assert(String.isNotBlank(String.valueOf(responseString.body)));
					MyOrdersController.InitData response = (MyOrdersController.InitData)JSON.deserialize(String.valueOf(responseString.body), MyOrdersController.InitData.class);
					System.assert(String.isNotBlank(String.valueOf(response)));  
				}
				Test.stopTest();
			}
		}	
    }
    
    @isTest(seealldata = false)
    static void test_getDesigns() {
        Account newAcc = new Account(Name = 'Fexle', Type = 'Pro', Phone = '9685742563');
        insert newAcc;
        Contact newCon = new Contact(LastName = 'Gupta', AccountId = newAcc.Id);
        insert newCon;
        opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.AccountId = newAcc.id;
        opp.Type = 'New Order';
        opp.Primary_Contact__c = newCon.Id;
        opp.Category_Picklist__c = 'All Star' ;
        opp.Collection_Picklist__c = 'N/A';
        opp.StageName = 'Open';
        opp.Amount = 3000;
        opp.CloseDate = Date.today() + 1; 
        insert opp;
        Design_Request__c dRequest = new Design_Request__c();
        dRequest.Primary_Contact__c = newCon.Id;
        dRequest.Account__c = newAcc.id;
        dRequest.Opportunity__c = opp.Id;
        dRequest.Design_Request_Status__c = ' test Hold - Not Ready for Designer Assignment';
        insert dRequest;
        List<Design_Round__c> drList = new List<Design_Round__c> {
            new Design_Round__c(Design_Request__c = dRequest.Id, Artwork_Approved__c = true),
            new Design_Round__c(Design_Request__c = dRequest.Id, Artwork_Approved__c = false)
        };
        insert drList;
        
        Test.startTest();
        
        responseString = MyOrdersItemsController.getDesigns(opp.Id);
        System.assert(String.isNotBlank(String.valueOf(responseString.body)));
        MyOrdersController.InitData response = (MyOrdersController.InitData)JSON.deserialize(String.valueOf(responseString.body), MyOrdersController.InitData.class);
        System.assert(String.isNotBlank(String.valueOf(response)));  
        
        Test.stopTest();   
    }
}