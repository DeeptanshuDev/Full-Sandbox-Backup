@isTest(seealldata = false)
public class Test_Batch_InsertPublicLinksForDesigns {
    
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
        
        ContentVersion contentVersionInsert = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true
        );
        insert contentVersionInsert;
        
        ContentDistribution cd = new ContentDistribution(Name = 'Test',ContentVersionId = contentVersionInsert.id, PreferencesAllowViewInBrowser= true,
                                                         PreferencesLinkLatestVersion = true,PreferencesNotifyOnVisit = false,PreferencesPasswordRequired = false, PreferencesAllowOriginalDownload = true);
        insert cd;
        
        Design__c design = new Design__c(Design_Request__c = dR.Id,Design_Round__c = designRound.Id, Content_Version_Id__c =contentVersionInsert.Id);
        insert design;
        
        
        List<Design__c> designs = [SELECT Id, Design_Request__c, Design_Round__c FROM Design__c];
        ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionInsert.Id LIMIT 1];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        System.assertEquals(documents.size(), 1);
        
        Test.startTest();
        
        Batch_InsertPublicLinksForDesigns insertPubLink = new Batch_InsertPublicLinksForDesigns();
        Database.executeBatch(insertPubLink);
        
        Test.stopTest();
    }
}