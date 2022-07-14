@isTest(seealldata = false)
public class Test_CloneOpportunity {
    
    @isTest
    static void test_unitTest() {
        List<Account> accounts = new List<Account>();
        
        List<Contact> contacts = new List<Contact>();

        for (Integer i=0;i<10;i++) {
            accounts.add(new Account(name='Account '+i, Type = 'Pro', Phone = '9685741452'));
        }
        insert accounts;
        
        for (Integer i=0;i<10;i++) {
            contacts.add(new Contact(LastName = 'Test'));
        }
        insert contacts;
        
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', Type = 'Reorder',Event_Date_Old__c = System.today(),StageName = 'Open',
                                          AccountId = accounts[0].id, Collection_Picklist__c ='Poly' , Category_Picklist__c = 'Pro', 
                                          Uniform_Style__c = 'Top', Primary_Contact__c = contacts[0].Id, CloseDate = System.today());
        
        insert opp;
        
        Custom_Item__c items = new Custom_Item__c(Name = 'Custom Item test', Design_Status__c = 'Waiting on Girl Items', 
                                                  Opportunity__c = opp.Id, Category__c = 'IEP', Gender__c = 'Girl', Quantity__c = 2, 
                                                  Product_Style__c ='Uniform', Price_per_item__c = 500,Fabric_Options__c = 'Mystique');
        
        insert items;
        
        List<Custom_Item__c> listOfItems = new List<Custom_Item__c>();
        listOfItems.add(new Custom_Item__c(Name = 'Custom Item test1', Design_Status__c = 'Waiting on Girl Items', 
                                           Opportunity__c = opp.Id, Category__c = 'IEP', Gender__c = 'Girl', Quantity__c = 2, 
                                           Product_Style__c ='Uniform', Price_per_item__c = 500,Fabric_Options__c = 'Mystique'));
        listOfItems.add(new Custom_Item__c(Name = 'Custom Item test2', Design_Status__c = 'Waiting on Girl Items', 
                                           Opportunity__c = opp.Id, Category__c = 'IEP', Gender__c = 'Girl', Quantity__c = 3, 
                                           Product_Style__c ='Uniform', Price_per_item__c = 500,Fabric_Options__c = 'Mystique'));
        insert listOfItems;
        
        Test.startTest();
        
        CloneOpportunity clne = new CloneOpportunity(opp.id);
        clne.CloseDate = system.today();
        clne.doClone();
        clne.addCustomItem(items);
        clne.addCustomItems(listOfItems);
        
        Test.stopTest();
        
    }
}