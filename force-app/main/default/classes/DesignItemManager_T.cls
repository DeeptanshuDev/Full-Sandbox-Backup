@isTest
private class DesignItemManager_T {

  @TestSetup
  private static void setup() {
    Opportunity opp = TestData.opportunity(true);
    Design_Request__c dr = TestData.designRequest(new Design_Request__c(Opportunity__c = opp.Id),
      true);
    Design_Round__c round = TestData.designRound(new Design_Round__c(
      Design_Request__c = dr.Id,
      Version__c = '1'
    ), true);
    Design__c design = TestData.design(new Design__c(
      Design_Round__c = round.Id,
      Design_Request__c = dr.Id)
    , true);
  }


  @isTest
  private static void testDiscountAmount() {
    Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
    Custom_Item__c ci = TestData.customItem(new Custom_Item__c(
      Opportunity__c = opp.Id,
      Product_Style__c = 'Warmup'
    ), true);
    Design__c design = [SELECT Id FROM Design__c LIMIT 1];
    TestData.designItem(new Design_Item__c(
      Design__c = design.Id,
      Custom_Item__c = ci.Id,
      MSRP__c = 100,
      Price__c = 90
    ), true);

    Design_Item__c di = [SELECT Discount_Amount__c FROM Design_Item__c LIMIT 1];
    System.assertEquals(10, di.Discount_Amount__c);
  }

  @isTest
  private static void testShippingPriceForCustomItem() {
    Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
    Custom_Item__c ci = TestData.customItem(new Custom_Item__c(
      Opportunity__c = opp.Id,
      Product_Style__c = 'Warmup',
      Quantity__c = 1
    ),
      true);
    Design__c design = [SELECT Id FROM Design__c LIMIT 1];
    TestData.designItem(new Design_Item__c(
      Design__c = design.Id,
      Custom_Item__c = ci.Id,
      Price__c = 100,
      Wholesale_Price__c = 100
    ), true);

    Design_Item__c di = [SELECT Shipping_per_Item__c FROM Design_Item__c LIMIT 1];
    System.assertEquals(6.0, di.Shipping_per_Item__c);
  }

  @isTest
  private static void testShippingPriceForFreeShipping() {
    Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
    Custom_Item__c ci = TestData.customItem(new Custom_Item__c(
      Opportunity__c = opp.Id,
      Product_Style__c = 'Warmup',
      Quantity__c = 1
    ),
      true);
    Design__c design = [SELECT Id FROM Design__c LIMIT 1];
    TestData.designItem(new Design_Item__c(
      Design__c = design.Id,
      Custom_Item__c = ci.Id,
      Free_Shipping__c = true,
      Price__c = 100
    ), true);

    Design_Item__c di = [SELECT Shipping_per_Item__c FROM Design_Item__c LIMIT 1];
    System.assertEquals(0.0, di.Shipping_per_Item__c);
  }

  @isTest
  private static void testShippingPriceForStandardizedItem() {
    Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
    Product2 p1 = TestData.product(new Product2(
      List_Price__c = 100
    ), true);
    Standardized_Item__c si = TestData.standardizedItem(new Standardized_Item__c(
      Opportunity__c = opp.Id,
      Quantity__c = 1,
      Product__c = p1.Id
    ), true);
    Design__c design = [SELECT Id FROM Design__c LIMIT 1];
    TestData.designItem(new Design_Item__c(
      Design__c = design.Id,
      Standardized_Item__c = si.Id
    ), true);

    Design_Item__c di = [SELECT Shipping_per_Item__c FROM Design_Item__c LIMIT 1];
    System.assertEquals(6.0, di.Shipping_per_Item__c);
  }

  @isTest
  private static void testDoesntSetShippingForInternational() {
    Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
    opp.International_Pricing__c = true;
    update opp;

    Standardized_Item__c si = TestData.standardizedItem(new Standardized_Item__c(
      Opportunity__c = opp.Id,
      Quantity__c = 1
    ), true);
    Design__c design = [SELECT Id FROM Design__c LIMIT 1];
    TestData.designItem(new Design_Item__c(
      Design__c = design.Id,
      Standardized_Item__c = si.Id,
      Price__c = 100
      //Shipping_per_Item__c = 123.45
    ), true);

    Design_Item__c di = [SELECT Shipping_per_Item__c FROM Design_Item__c LIMIT 1];
    //System.assertEquals(6.0, di.Shipping_per_Item__c);
  }

  @isTest
  private static void testSetsPriceFromStandardizedItem() {
    Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

    Product2 prod1 = TestData.product(new Product2(
      Name = 'test',
      List_Price__c = 49
    ), true);

    Standardized_Item__c si = TestData.standardizedItem(new Standardized_Item__c(
      Opportunity__c = opp.Id,
      Quantity__c = 1,
      Product__c = prod1.Id
    ), true);

    Design__c design = [SELECT Id FROM Design__c LIMIT 1];

    TestData.designItem(new Design_Item__c(
      Design__c = design.Id,
      Standardized_Item__c = si.Id
    ), true);

    Design_Item__c di = [SELECT Price__c FROM Design_Item__c LIMIT 1];
    System.assertEquals(49, di.Price__c);
  }

}