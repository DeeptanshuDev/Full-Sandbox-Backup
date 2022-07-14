@isTest(seealldata = false)
public class Test_Batch_CreatePipelineStandardItems {
    
    @isTest
    static void test_unitMethod() {
        
        Account accounts = new Account(name='Account', Type = 'Pro', Phone = '9685741452');
        insert accounts;
        
        Contact contacts = new Contact(LastName = 'Test');
        insert contacts;
        
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', Type = 'Reorder',Event_Date_Old__c = System.today(),StageName = 'Open',
                                          AccountId = accounts.id, Collection_Picklist__c ='Poly' , Category_Picklist__c = 'Pro', 
                                          Uniform_Style__c = 'Top', Primary_Contact__c = contacts.Id, CloseDate = System.today());
        insert opp;
        
        Design_Request__c dR = new Design_Request__c(Account__c = accounts.Id, Opportunity__c = opp.Id,
                                                     Design_Request_Status__c = 'Open', Primary_Contact__c = contacts.Id);
        insert dR;
        
        Design_Round__c designRound = new Design_Round__c(Design_Request__c = dR.Id,Version__c = '12');
        insert designRound;
        
        Custom_Item__c customItems = new Custom_Item__c(Name = 'Custom Item test', Design_Status__c = 'Waiting on Girl Items', 
                                                        Opportunity__c = opp.Id, Category__c = 'IEP', Gender__c = 'Girl', Quantity__c = 2, 
                                                        Product_Style__c ='Uniform', Price_per_item__c = 500,Fabric_Options__c = 'Mystique');
        
        insert customItems;

		//Records List of Standardized_Item__c to insert
        List<Standardized_Item__c> standardizedItemList = new List<Standardized_Item__c>();
        
        Standardized_Item__c stItem1 = new Standardized_Item__c(order_id__c='order1', FF_Create_Item_Successful__c=true, 
                                                                is_submitted__c='true', Opportunity__c=opp.Id, Quantity__c=8, Stated_Quantity__c=8);
        standardizedItemList.add(stItem1);
        insert standardizedItemList;
        
        Test.startTest();
        
        Batch_CreatePipelineStandardItems insertPubLink = new Batch_CreatePipelineStandardItems();
        Database.executeBatch(insertPubLink);
        
        Test.stopTest();
    }
}