@isTest
private class CreateFitKitRequestRedirectCtrl_T {
  static Account acc;
  static Opportunity opp;
  static Design_Request__c designRequest;
  static Design_Option__c designOption;
  static Product2 product1;
  static Custom_Item__c customItem;
  static Fit_Kit_Request__c fkr;
  static Deposit__c deposit;

  static {
    acc = TestData.account(true);

    opp = TestData.opportunity(new Opportunity(
      Name = 'test opp',
      AccountId = acc.Id,
      CloseDate = Date.today(),
      Amount = 200,
      StageName = 'Prototype'
    ), true);

    designRequest = TestData.designRequest(new Design_Request__c(
      Account__c = acc.Id,
      Opportunity__c = opp.Id
    ), true);


    customItem = TestData.customItem(new Custom_Item__c(
      Design_Request__c = designRequest.Id,
      Opportunity__c = opp.Id,
      Price_per_item__c = 20,
      Quantity__c = 30,
      Style__c = 'U101 - Girls Full-length Top',
      Fabric_Options__c = 'Spandex'
    ), true);

    product1 = TestData.product(true);

    TestData.standardizedItem(new Standardized_Item__c(
      Opportunity__c = opp.Id,
      Product__c = product1.Id
    ), true);

    fkr = TestData.fitKitRequest(new Fit_Kit_Request__c(
      Opportunity__c = opp.Id
    ), false);

    TestData.customItemFitAttribute(new Custom_Item_Fit_Attribute__c(
      Style__c = 'U101',
      Fabric__c = 'Spandex'
    ), true);

    deposit = TestData.deposit(new Deposit__c(
      Account__c = acc.Id,
      Amount__c = 1000
    ), true);

    TestData.fitKitSettings(true);
  }

  @isTest
  private static void test() {
    CreateFitKitRequestRedirectCtrl ctrl = new CreateFitKitRequestRedirectCtrl(
      new ApexPages.StandardController(opp));
    PageReference pr = ctrl.redirect();
    System.assert(pr != null, 'Expected non-null page reference.');
  }
}