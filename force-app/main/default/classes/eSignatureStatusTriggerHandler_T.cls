@isTest()
private class eSignatureStatusTriggerHandler_T {
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
    @IsTest
    static void doTest() {
        
        eSignature_Status__c eSignaturestaus = [SELECT Id,eSignature_Approved__c,Design_Round__c,Envelop_Status__c FROM eSignature_Status__c LIMIT 1];
      eSignaturestaus.Envelop_Status__c ='Approved';
        update eSignaturestaus;
        
        // Build a simple feed item
        ConnectApi.FeedElementPage testPage = new ConnectApi.FeedElementPage();
        List<ConnectApi.FeedItem> testItemList = new List<ConnectApi.FeedItem>();
        testItemList.add(new ConnectApi.FeedItem());
        testItemList.add(new ConnectApi.FeedItem());
        testPage.elements = testItemList;

        // Set the test data
        ConnectApi.ChatterFeeds.setTestGetFeedElementsFromFeed(null,
            ConnectApi.FeedType.News, 'me', testPage);

        // The method returns the test page, which we know has two items in it.
        Test.startTest();
        
        Test.stopTest();
    }
}