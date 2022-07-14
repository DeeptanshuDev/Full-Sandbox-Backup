/**
*	Description   	:   Test class for eSignatureEmailController class.
* 
*  	Version			:   v1.0 Chirag Soni 
*
*   Date            :   03/08/2021
**/ 

@isTest (seeAlldata = false)
private class eSignatureEmailController_T {
    
    @TestSetup
    private static void setup() {
        
        Account testAccount = TestData.account(new Account(Name = 'Test Account For Contact',
                                                           Type = 'Accounting Vendor',
                                                           Phone = '1234567890' ), true);
        
        Contact eSignRecipientContact = TestData.contact(new Contact (FirstName = 'Test',
                                                                      LastName = 'RecipientContact',
                                                                      AccountId = testAccount.id,
                                                                      Email = 'TestRecipient@invalid.com',
                                                                      Preferred_Phone__c = 'Phone'), true);
        
        Opportunity opp = TestData.opportunity(true);
        
        Design_Request__c designRequest = TestData.designRequest(new Design_Request__c(Opportunity__c = opp.Id),true);
        
        Design_Round__c designRound = TestData.designRound(new Design_Round__c(Design_Request__c = designRequest.Id,
                                                                               Version__c = '1'), true);
    }
    
    @isTest
    private static void sendEmailToRecipient(){
        
        Design_Round__c designRound = [SELECT Id, eSignature_Recipient_Contact__c FROM Design_Round__c LIMIT 1];
        Test.startTest();
        
        // Use case : when recipient contact is not selected page reference returns null 
        eSignatureEmailController eScontroller = new eSignatureEmailController(new ApexPages.StandardController(designRound));
        PageReference pr1 = eScontroller.sendEmailToRecipient();
        System.assert(pr1==null, 'Expected null because eSignature ');
        
        // update recipient contact on design round
        Contact recipientContact = [SELECT Id FROM Contact LIMIT 1];
        designRound.eSignature_Recipient_Contact__c  = recipientContact.id;
        update designRound;
        
        // Use case : when art approval document is not exist on design round
        Design_Round__c updatedDesignRoundWithContact = [SELECT Id, eSignature_Recipient_Contact__c FROM Design_Round__c LIMIT 1];
         
        eScontroller = new eSignatureEmailController(new ApexPages.StandardController(updatedDesignRoundWithContact));
        eSignatureEmailController.testData();
        PageReference pr2 = eScontroller.sendEmailToRecipient();
        System.assert(pr2==null, 'Expected null because art approval document has not been generated on design round');
        
        //insert art document on design round
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
        
        //Use case: throw exeception when setTargetObject id is not exist in single.email
         eScontroller = new eSignatureEmailController(new ApexPages.StandardController(updatedDesignRoundWithContact));
         PageReference pr3 = eScontroller.sendEmailToRecipient();
         System.assert(pr3 == null, 'Expected null because it throws setTargetObjectId Exception');      
         
        //update targetObjectId 
         Design_Request__c designRequest = [SELECT Id, Primary_Contact__c FROM Design_Request__c LIMIT 1];
         designRequest.Primary_Contact__c = recipientContact.id;
         update designRequest;
        
         // check expected page reference and check whether email sent or not 
         eScontroller = new eSignatureEmailController(new ApexPages.StandardController(updatedDesignRoundWithContact));
         PageReference pr4 = eScontroller.sendEmailToRecipient();
        
        Test.stopTest();
    }
    
}