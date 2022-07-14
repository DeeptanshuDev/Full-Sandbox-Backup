@isTest(seealldata = false)
public class Test_Batch_ShareFilesWithSFAdminUser {
    
    @isTest
    static void test_unitMethod() {
        
       ContentVersion contentVersionInsert = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true
        );
        insert contentVersionInsert;
 
        // Test INSERT
        ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionInsert.Id LIMIT 1];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        System.assertEquals(documents.size(), 1);
 
        Test.startTest();
        
        Batch_ShareFilesWithSFAdminUser  shareFiles = new Batch_ShareFilesWithSFAdminUser();
        Database.executeBatch(shareFiles);
        
        Test.stopTest();
    }
}