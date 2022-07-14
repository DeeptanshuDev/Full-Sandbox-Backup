@isTest
private class DesignRequestItemSummaryManager_T {

  @TestSetup
  private static void setup() {
    Opportunity opp = TestData.opportunity(true);
    Design_Request__c dr = TestData.designRequest(new Design_Request__c(Opportunity__c = opp.Id),
      true);
  }
  
  @isTest
  private static void test() {
    Design_Request__c designRequest = [SELECT Id FROM Design_Request__c LIMIT 1];
    Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
    Custom_Item__c customItem = TestData.customItem(new Custom_Item__c(
      Opportunity__c = opp.Id,
      Design_Request__c = designRequest.Id,
      Price_per_item__c = 0,
      Design_Status__c = '(D) In Pricing'
    ),
      true);

    List<Design_Request_Item_Summary__c> summaries =
      [SELECT Id, Design_Status__c, Number_of_Items__c FROM Design_Request_Item_Summary__c];

    System.assertEquals(1, summaries.size());
    System.assertEquals('(D) In Pricing', summaries[0].Design_Status__c);
    System.assertEquals(1, summaries[0].Number_of_Items__c);
  }
}