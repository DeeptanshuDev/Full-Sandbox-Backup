/**
*	Description   	:   Test class for eSignatureNotificationTriggerHandler class.
* 
*  	Version			:   v1.0 Chirag Soni 
*
*   Date            :   03/10/2021
**/ 

@isTest (seeAlldata = false)
private class eSignatureNotificationTriggerHandler_T {
    
    @TestSetup
    private static void setup() {
        
        Opportunity opp = TestData.opportunity(true);
        Account acc = new Account(Name = 'Test Acc');
        insert acc;
        /*Test.startTest();
       	Opportunity opp1 = [SELECT Id, Name FROM Opportunity LIMIT 1];
        Account acc2 = [SELECT Id, Name FROM Account LIMIT 1];*/
        Design_Request__c designRequest = TestData.designRequest(new Design_Request__c(Opportunity__c = opp.Id,Account__c = acc.Id),true);
        
        Design_Round__c designRound = TestData.designRound(new Design_Round__c(Design_Request__c = designRequest.Id,
                                                                               Version__c = '1'), true);
        
        Design__c  designs = TestData.design(new Design__c(
            Design_Round__c = designRound.Id,Sent_for_Approval__c= true,Approved_Art__c = false
        ), true);
        
        Custom_Item__c customItem = TestData.customItem(new Custom_Item__c(Design_Request__c = designRequest.Id, Opportunity__c = opp.Id, Price_per_item__c = 20,
                                                       Quantity__c = 30,Stated_Quantity__c = 1,Product_Style__c = 'Logo/Add-on', Style__c = 'U101 - Girls Full-length Top', Fabric_Options__c = 'Spandex', Collection__c = 'Couture'), true);
        
        Design_Item__c designItem = TestData.designItem(new Design_Item__c(
            Design__c = designs.Id,
            Custom_Item__c = customItem.Id,
            Selected__c = true
        ), true);
        
        
        
        
        eSignature_Status__c eSignstaus = TestData.eSignatureStatus(new eSignature_Status__c(
            Design_Round__c = designRound.id,
            Last_Viewed__c = DateTime.now(),
            Envelop_Status__c = 'Delivered'), true);  
        String artDocument = 'test art approval document';
        
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.ContentLocation = 'S';           
        contentVersion.PathOnClient = 'testing.txt';   
        contentVersion.Title = 'Test Acc';  
        contentVersion.VersionData = EncodingUtil.base64Decode(artDocument);   
        insert contentVersion;                        
        
        // First get the Content Document Id from ContentVersion Object
        Id contentDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:contentVersion.Id].ContentDocumentId;
        
        //create ContentDocumentLink  record 
        ContentDocumentLink contentDocumentLink = New ContentDocumentLink();
        contentDocumentLink.LinkedEntityId =  designRound.id; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
        contentDocumentLink.ContentDocumentId = contentDocument;  //ContentDocumentId Id from ContentVersion
        contentDocumentLink.shareType = 'V';
        insert contentDocumentLink;
        
    }
    
    @isTest
    private static  void postApproveVoidChatterAndUpdateDesignRoundtest(){
        test.startTest();
        Design_Round__c designRound = [SELECT Id, Name FROM Design_Round__c LIMIT 1];
        eSignature_Status__c eSignaturestaus = [SELECT Id FROM eSignature_Status__c LIMIT 1];
        
        
        eSignature_Notification__e eSignatureNotification = new eSignature_Notification__e();
        eSignatureNotification.DesignRound_Id__c = designRound.id;
        eSignatureNotification.DesignRound_Name__c = designRound.Name;
        eSignatureNotification.eSignatureStatus_Id__c = eSignaturestaus.id;
        eSignatureNotification.Approved__c = true;
        eSignatureNotification.Voided__c = false;  
        Database.SaveResult saveResult = EventBus.publish(eSignatureNotification);
        test.stopTest();
        // Verify SaveResult value
        System.assertEquals(true, saveResult.isSuccess());
 
    }
}