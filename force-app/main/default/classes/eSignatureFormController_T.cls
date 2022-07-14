/**
*	Description   	:   Test class for eSignatureFormController class.
* 
*  	Version			:   v1.0 Chirag Soni 
*
*   Date            :   03/08/2021
**/ 

@isTest (seeAlldata = false)
private class eSignatureFormController_T {
    
    @TestSetup
    private static void setup() {
        Opportunity opp = TestData.opportunity(true);
        
        Design_Request__c designRequest = TestData.designRequest(new Design_Request__c(Opportunity__c = opp.Id),true);
        
        Design_Round__c designRound = TestData.designRound(new Design_Round__c(Design_Request__c = designRequest.Id,
                                                                               Version__c = '1'), true);
        
        eSignature_Status__c eSignstaus = TestData.eSignatureStatus(new eSignature_Status__c(
                                                                    Design_Round__c = designRound.id,
                                                                    Last_Viewed__c = DateTime.now(),
                                                                    Envelop_Status__c = 'Delivered'), true);  
        
        String artDocument = 'test art approval document';
        
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.ContentLocation = 'S';           
        contentVersion.PathOnClient = 'testing.txt';   
        contentVersion.Title = 'artApprovalDocument';  
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
        
        AuthSetting__c ast = new AuthSetting__c();
        ast.CLIENT_ID__c = '3MVG9Fy_1ZngbXqN8.I_rerkG1_YErAB2qOC6549V.t4I4FFuZqloa3ZEcXK20LZvMqhS3YzLObkION.QPDXU';
            ast.CLIENT_SECRET__c = 'DB041E9093086FF9FDBBCC2780021CC79EBCB2DFC3858D4419AB4ED99928F504';
            ast.PASSWORD__c = 'Fexle$3312#';
            ast.USERNAME__c = 'abhinav@rebelathletic.com.full';
        ast.End_Point__c ='https://test.salesforce.com/services/oauth2/token';
        
        insert ast;
    }
    
    @isTest
    private static void saveSignatureAndSubmit(){
        
        eSignature_Status__c eSignaturestaus = [SELECT Id FROM eSignature_Status__c LIMIT 1];
        ContentVersion contentVersion = [SELECT Id, Title FROM ContentVersion Limit 1];
        
        String RecipientNameAndEmailForURL = 'Test Contact :testcontact@gmail.com';
        Blob blobNameEmailRecipient = Blob.valueOf(RecipientNameAndEmailForURL);
        String encodedNameAndEmailOfRecipient = EncodingUtil.base64Encode(blobNameEmailRecipient);
        Test.startTest();
        
        PageReference pr = Page.eSignatureForm;
        pr.getParameters().put('id', eSignaturestaus.id);
        pr.getParameters().put('docId', contentVersion.id);
        pr.getParameters().put('user', encodedNameAndEmailOfRecipient);
        Test.setCurrentPage(pr);
        
        eSignatureFormController esignatureForm = new eSignatureFormController();
        esignatureForm.documentStatus = 'Approved';
        esignatureForm.signatureUrl = 'Test User Signature Image';
        esignatureForm.fetchURLforIframe();
        
        PageReference pageRef = esignatureForm.saveSignatureAndSubmit();
        System.assert( pageRef!=null , 'Expected page reference');
        
        eSignature_Recipient__c esignatureRecipient = [SELECT Id, Recipient_Name__c
                                                       , Recipient_Email__c
                                                       , Recipient_Status__c
                                                       , Document_Approved__c 
                                                       FROM eSignature_Recipient__c
                                                       WHERE eSignature_Status__c = :eSignaturestaus.id];
        
        System.assertEquals('Test Contact', esignatureRecipient.Recipient_Name__c);
        System.assertEquals('testcontact@gmail.com', esignatureRecipient.Recipient_Email__c);
        System.assertEquals(true, esignatureRecipient.Document_Approved__c);
        System.assertEquals('Approved', esignatureRecipient.Recipient_Status__c);
        
        Attachment attachment = [SELECT Id, Name FROM Attachment WHERE parentId = :eSignaturestaus.Id];
        
        System.assertEquals('Test_Contact_.jpg', attachment.Name);
        
        Test.stopTest();
    }
}