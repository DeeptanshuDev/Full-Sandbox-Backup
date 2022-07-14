/**
*	Description   	:   Test class for eSignatureRecipientTriggerHandler class.
* 
*  	Version			:   v1.0 Chirag Soni 
*
*   Date            :   03/04/2021
**/ 


@isTest (seeAlldata = false)
private class eSignatureRecipientTriggerHandler_T {
    
  @TestSetup
  private static void setup() {
       Opportunity opp = TestData.opportunity(true);
       
       Design_Request__c designRequest = TestData.designRequest(new Design_Request__c(Opportunity__c = opp.Id),true);
       
       Design_Round__c designRound = TestData.designRound(new Design_Round__c(Design_Request__c = designRequest.Id,
                                                                              Version__c = '1'), true);
            
       eSignature_Status__c eSignstaus = TestData.eSignatureStatus(new eSignature_Status__c(
                                                                              Design_Round__c = designRound.id,
                                                                              Last_Viewed__c = DateTime.now(),eSignature_Approved__c=true,
                                                                              Envelop_Status__c = 'Delivered'), true);
  }
    
    @isTest
    private static void updateEsignStatusAndAttachmentInsertEsignatureNotification(){
        
       eSignature_Status__c eSignaturestaus = [SELECT Id,eSignature_Approved__c,Design_Round__c,Envelop_Status__c FROM eSignature_Status__c LIMIT 1];
      
       Test.startTest();
    
        Attachment testAttachment =new Attachment(); 
        testAttachment.Name = 'Unit Test Attachment'; 
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body'); 
        testAttachment.body = bodyBlob; 
        testAttachment.parentId = eSignaturestaus.Id; 
        insert testAttachment;
        
        eSignature_Recipient__c eSignRecipient = TestData.eSignatureRecipient(new eSignature_Recipient__c(
                                                                            eSignature_Status__c = eSignaturestaus.Id,
                                                                            Recipient_Status__c = 'Approved',
                                                                            Document_Approved__c = true,
                                                                            Approved_Date__c = DateTime.now()),true);
        
        eSignature_Status__c updatedEsignStatus = [SELECT Id, SignatureAttachment_Id__c 
                                                        , Approved__c, Voided__c, Envelop_Status__c
                                                          FROM eSignature_Status__c WHERE Id = :eSignaturestaus.Id];
        
        Attachment attachment = [SELECT Id FROM Attachment WHERE parentId = :updatedEsignStatus.Id];
        
        System.assertEquals(attachment.id , updatedEsignStatus.SignatureAttachment_Id__c); //check updated attachment Id on Esignature Status 
        System.assertEquals('Approved', updatedEsignStatus.Envelop_Status__c);// check updated envelop status on esignature status
        System.assertEquals(true, updatedEsignStatus.Approved__c);// check approved checkbox on esignature status
        System.assertEquals(false, updatedEsignStatus.Voided__c);// check voided checkbox on esignature status
        
       Test.stopTest(); 
  }
}