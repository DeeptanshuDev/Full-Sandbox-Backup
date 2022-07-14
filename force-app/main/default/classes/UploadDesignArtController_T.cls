/**
*   Description     :   Test class to perform the testing of Upload Design Art lightning component.
* 
*   Version         :   v1.1 - Created - CR - 00000055 - Abhinav Sharma         
**/ 
@isTest
private  class UploadDesignArtController_T 
{
    
    static Opportunity opp;
    static Custom_Item__c customItem;
    static Standardized_Item__c standardItem;
    static Design_Request__c designRequest;
    static Design_Round__c designRound;
    static ContentVersion contentVersion;
    static 
    {
        opp = TestData.opportunity(true);
        designRequest = TestData.designRequest(new Design_Request__c(Opportunity__c = opp.Id), true);
        designRound = TestData.designRound(new Design_Round__c(Design_Request__c = designRequest.Id), true);
        customItem = TestData.customItem(new Custom_Item__c(Opportunity__c = opp.Id, Design_Request__c = designRequest.Id), true);
        standardItem = TestData.standardizedItem(new Standardized_Item__c(Opportunity__c = opp.Id, Design_Request__c = designRequest.Id),true);
        contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion; 
    }
    
    @isTest
    private static void getCustomStandardizedItemsWrapper() 
    {
        Test.startTest();
        List<UploadDesignArtController.CustomStandardizedItemWrapper> customStandardizedItemWrappers = UploadDesignArtController.getCustomStandardizedItemsWrapper(designRequest.Id);
        System.assertEquals(true, customStandardizedItemWrappers.size() > 0); 
        Test.stopTest();
    }
    
    @isTest
    private static void getFieldSet() 
    {
        Test.startTest();
        String fieldJson = UploadDesignArtController.getFieldSet('Design__c','Design_Field_For_Upload_Design_Art');
        System.assertNotEquals(null, fieldJson); 
        Test.stopTest();
    }
    @isTest
    private static void cleanUp() 
    {
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument LIMIT 1];
        List<ContentDocumentLink> contentDocLinks = new List<ContentDocumentLink>();
        ContentDocumentLink cDe = new ContentDocumentLink(ContentDocumentId =documents[0].Id,
                                                          LinkedEntityId = designRequest.Id,
                                                          ShareType = 'I', Visibility = 'AllUsers');
        
        contentDocLinks.add(cDe);
        insert contentDocLinks;
        
        List<String> docIds = new List<String>();
        docIds.add(documents[0].Id);
        
        Test.startTest();
        List<ContentDocument> contentDocuments = UploadDesignArtController.cleanUp(designRequest.Id, docIds);
        System.assertEquals(true, contentDocuments.size()> 0); 
        Test.stopTest();    
    }
    @isTest
    private static void recordsSave() 
    {
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument LIMIT 1];
        String allDetailsOfDesignRoundJson = '[[\n'+
        +'{"key" : "Version__c",'+'"value" : "2"},\n'+ 
        +'{"key" : "Gender__c",'+'"value" : "Boy"},\n'+ 
        +'{"key" : "Reason_for_Revision__c",'+'"value" : "Design issue"}\n' +
        + ']]';
        List<List<Map<String,String>>> allDetailsOfDesignRound = (List<List<Map<String,String>>>)JSON.deserialize(allDetailsOfDesignRoundJson, List<List<Map<String,String>>>.class);
        
        String allDetailsOfDesignJson = '[[\n'+
        +'{"seQ" : "1",'+'"key":"DocumentId",'+'"value" : "'+documents[0].Id+'"},\n' +
        +'{"seQ" : "1",'+'"key":"DocumentName",'+'"value" : "'+documents[0].Title+'"},\n' + 
        +'{"seQ" : "1",'+'"key":"Option_Number__c",'+'"value":"1"},\n' + 
        +'{"seQ" : "1",'+ '"key":"Needs_Pricing__c",'+'"value":"true"},\n' + 
        +'{"seQ" : "1",'+'"key":"Notes__c",'+'"value":""}\n' +
        + ']]';   
        List<List<Map<String,String>>> allDetailsOfDesign = (List<List<Map<String,String>>>)JSON.deserialize(allDetailsOfDesignJson, List<List<Map<String,String>>>.class);
         
        String selectedCustomItemsIdsJson = '["'+customItem.Id+'"]';
        List<String> selectedCustomItemsIds = (List<String>)JSON.deserialize(selectedCustomItemsIdsJson, List<String>.class);

        Test.startTest();
        
        List<UploadDesignArtController.SobjectRecordsWithError> sobjectRecordsWithErrors = 
            UploadDesignArtController.recordsSave(designRequest.Id, 
                                                  'Design_Request__c', 
                                                  'Design_Round__c', 
                                                   allDetailsOfDesignRound, 
                                                  'Design__c', 
                                                   allDetailsOfDesign, 
                                                   selectedCustomItemsIds
                                                 );
        
        System.assertNotEquals(null,sobjectRecordsWithErrors);
        Test.stopTest();
    }
}