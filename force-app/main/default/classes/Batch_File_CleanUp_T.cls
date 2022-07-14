/**
*   Description     :   Test class to clean up garbage files created by custom mapping only.
* 
*   Version         :   v1.1 - Created - CR - 00000055 - Abhinav Sharma         
**/ 
@isTest
private  class Batch_File_CleanUp_T 
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
            Title = 'Custom_Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion; 
    }
    
    @isTest
    private static void toCallBatch() 
    {
       Database.executeBatch(new Batch_File_CleanUp('Custom'));
        
    }
}