/**
*	Description   	:   Test class for eSignatureUpdatesFromSite class.
* 
*  	Version			:   v1.0 Chirag Soni 
*
*   Date            :   03/08/2021
**/ 

@isTest (seeAlldata = false)
private class eSignatureUpdatesFromSite_T {
    
    @TestSetup
    private static void setup() {
        Opportunity opp = TestData.opportunity(true);
        
        Design_Request__c designRequest = TestData.designRequest(new Design_Request__c(Opportunity__c = opp.Id),true);
        
        Design_Round__c designRound = TestData.designRound(new Design_Round__c(Design_Request__c = designRequest.Id,
                                                                               Version__c = '1'), true);
        
        eSignature_Status__c eSignstaus = TestData.eSignatureStatus(new eSignature_Status__c( Design_Round__c = designRound.id
                                                                                             , Envelop_Status__c = 'Sent'
                                                                                             , Sender_Name__c = UserInfo.getName()), true);
    }
    
    @isTest
    private static void updateLastViewedAndEnevlopStatus() {
        
        eSignature_Status__c eSignaturestaus = [SELECT Id, Envelop_Status__c, Voided__c 
                                                , Approved__c, Last_Viewed__c FROM eSignature_Status__c LIMIT 1];
        
        Test.startTest();
        eSignatureUpdatesFromSite.updateLastViewedAndEnevlopStatus(eSignaturestaus.id);
        
        eSignature_Status__c eSignStatus = [SELECT Id, Envelop_Status__c, Voided__c 
                                            , Approved__c, Last_Viewed__c FROM eSignature_Status__c LIMIT 1];
        
        System.assertEquals('Delivered', eSignStatus.Envelop_Status__c);
        System.assertEquals(DateTime.now(), eSignStatus.Last_Viewed__c);
        System.assertEquals(false, eSignStatus.Approved__c);
        System.assertEquals(false, eSignStatus.Voided__c);
        Test.stopTest();
    }
}