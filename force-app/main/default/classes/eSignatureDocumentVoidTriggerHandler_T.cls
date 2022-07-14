@isTest
public class eSignatureDocumentVoidTriggerHandler_T {
    
    @TestSetup
    private static void setup() {
        Account acc = TestData.account(true);
        Opportunity opp = TestData.opportunity(new Opportunity(AccountId = acc.Id),true);
        Custom_Item__c ci = TestData.customItem(new Custom_Item__c(Opportunity__c = opp.Id),true);
        Design_Request__c dr = TestData.designRequest(new Design_Request__c(Account__c = acc.Id, Opportunity__c = opp.Id, Design_Request_Status__c = 'Open'),true);
        Design_Round__c dir = TestData.designRound(new Design_Round__c(Design_Request__c = dr.Id), true);
        Design__c design = TestData.design(new Design__c(Design_Request__c = dr.Id, Design_Round__c = dir.Id), true);
        Design_Item__c di = TestData.designItem(new Design_Item__c(Design__c = design.Id), true);
        
        Blob pdfData = Blob.valueOf('abc');
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = dir.Design_Request__r.Account__r.Name + ' - ' + dir.Name
            + '.pdf';//File title
        contentVersion.PathOnClient = dir.Design_Request__r.Account__r.Name + ' - ' + dir.Name
            + '.pdf'; //File name
        contentVersion.VersionData = pdfData ;//File body (Add content or body of uploaded file)
        //String itemIdsString =  itemIds.toString().replaceAll('[()]', '');
        contentVersion.ReasonForChange = di.Id+':'+dir.Id;
        insert contentVersion;
        
        ContentVersion cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:contentVersion.Id];
        System.debug('ContentDocumentId: ' + cv.ContentDocumentId);
        
        contentDocumentLink cdl = new contentDocumentLink();
        cdl.LinkedEntityid = dir.Id;
        cdl.ContentDocumentId = cv.ContentDocumentId;
        insert cdl;
        
    }
    
    @isTest
    private static void getChildRecordsList() {
        List<ContentVersion> contentVersionList = [SELECT Id, ContentDocumentId, ReasonForChange FROM ContentVersion LIMIT 1];
        test.startTest();
        eSignatureDocumentVoidTriggerHandler.deleteOldVersionWithSameDesignItem(contentVersionList);
        test.stopTest();
    }
    
}