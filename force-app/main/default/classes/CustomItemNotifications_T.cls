@isTest
private class CustomItemNotifications_T {

  @isTest(SeeAllData=true)
  private static void createsDesignRequestFeedItem() {
    Account acc = TestData.account(true);

    Opportunity opp = TestData.opportunity(new Opportunity(
      Name = 'test opp',
      AccountId = acc.Id,
      CloseDate = Date.today(),
      Amount = 200,
      StageName = 'Prototype'
    ), true);

    Design_Request__c designRequest = TestData.designRequest(new Design_Request__c(
      Account__c = acc.Id,
      Opportunity__c = opp.Id
    ), true);

    Custom_Item__c customItem = TestData.customItem(new Custom_Item__c(
      Design_Request__c = designRequest.Id,
      Opportunity__c = opp.Id,
      Price_per_item__c = 20,
      Quantity__c = 30,
      Style__c = 'U101 - Girls Full-length Top',
      Fabric_Options__c = 'Spandex',
      Design_Status__c = '(D) Initial Art Completed and Sent'
    ), true);

    List<Design_Request__Feed> feedItems = [Select Id, Body FROM Design_Request__Feed
      WHERE ParentId = :designRequest.Id];
    Logger.warn(feedItems);
    System.assertEquals(1, feedItems.size());
  }

  @isTest(SeeAllData=true)
  private static void doesntCreateDesignRequestFeedItemForSameStatus() {
    Account acc = TestData.account(true);

    Opportunity opp = TestData.opportunity(new Opportunity(
      Name = 'test opp',
      AccountId = acc.Id,
      CloseDate = Date.today(),
      Amount = 200,
      StageName = 'Prototype'
    ), true);

    Design_Request__c designRequest = TestData.designRequest(new Design_Request__c(
      Account__c = acc.Id,
      Opportunity__c = opp.Id
    ), true);

    Custom_Item__c customItem = TestData.customItem(new Custom_Item__c(
      Design_Request__c = designRequest.Id,
      Opportunity__c = opp.Id,
      Price_per_item__c = 20,
      Quantity__c = 30,
      Style__c = 'U101 - Girls Full-length Top',
      Fabric_Options__c = 'Spandex',
      Design_Status__c = '(D) Initial Art Completed and Sent'
    ), true);

    // testing that this doesnt not result in another feed post since we didn't change status
    update customItem;

    List<Design_Request__Feed> feedItems = [Select Id, Body FROM Design_Request__Feed
    WHERE ParentId = :designRequest.Id];
    Logger.warn(feedItems);
    System.assertEquals(1, feedItems.size());
  }

  @isTest(SeeAllData=true)
  private static void createsDesignRequestFeedItemForStatusChange() {
    Account acc = TestData.account(true);

    Opportunity opp = TestData.opportunity(new Opportunity(
      Name = 'test opp',
      AccountId = acc.Id,
      CloseDate = Date.today(),
      Amount = 200,
      StageName = 'Prototype'
    ), true);

    Design_Request__c designRequest = TestData.designRequest(new Design_Request__c(
      Account__c = acc.Id,
      Opportunity__c = opp.Id
    ), true);

    Custom_Item__c customItem = TestData.customItem(new Custom_Item__c(
      Design_Request__c = designRequest.Id,
      Opportunity__c = opp.Id,
      Price_per_item__c = 20,
      Quantity__c = 30,
      Style__c = 'U101 - Girls Full-length Top',
      Fabric_Options__c = 'Spandex',
      Design_Status__c = '(D) Initial Art Completed and Sent'
    ), true);

    customItem.Design_Status__c = '(S) Revision Comments Sent, Waiting for Revised Art';
    update customItem;

    List<Design_Request__Feed> feedItems = [Select Id, Body FROM Design_Request__Feed
    WHERE ParentId = :designRequest.Id];
    Logger.warn(feedItems);
    System.assertEquals(2, feedItems.size());
  }
}