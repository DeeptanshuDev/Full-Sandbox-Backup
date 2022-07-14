@isTest
private class DesignRequestManager_T {

  @TestSetup
  private static void setup() {
    Opportunity opp = TestData.opportunity(true);
    Design_Request__c dr = TestData.designRequest(new Design_Request__c(Opportunity__c = opp.Id),
      true);
    Custom_Item__c customItem = TestData.customItem(new Custom_Item__c(
      Opportunity__c = opp.Id,
      Design_Request__c = dr.Id,
      Price_per_item__c = 0,
      Product_Style__c = 'Uniform'
    ),
      true);
  }

  @isTest
  private static void oneDesignItem() {
    Custom_Item__c ci = [SELECT id, Price_per_item__c FROM Custom_Item__c LIMIT 1];
    Design_Request__c dr = [SELECT Id FROM Design_Request__c LIMIT 1];

    Test.startTest();
    Design_Round__c round = TestData.designRound(new Design_Round__c(
      Design_Request__c = dr.Id,
      Version__c = '1'
    ), true);

    Design__c design = TestData.design(new Design__c(
      Design_Request__c = dr.Id,
      Design_Round__c = round.Id
    ), true);

    TestData.designItem(new Design_Item__c(
      Custom_Item__c = ci.Id,
      Design__c = design.Id,
      Price__c = 200,
      Wholesale_Price__c = 199
    ), true);
	
    test.stopTest();
      
    ci = [SELECT id, Price__c, Price_per_item__c, Shipping__c FROM Custom_Item__c LIMIT 1];

    System.assertEquals(200, ci.Price__c);
    // Cuz a trigger sets Design Items shipping amount to Price * .03 (for uniforms)
    System.assertEquals(5.97, ci.Shipping__c);
  }

  @isTest
  private static void twoDesignItemsSameRound() {
    Custom_Item__c ci = [SELECT id, Price_per_item__c FROM Custom_Item__c LIMIT 1];
    Design_Request__c dr = [SELECT Id FROM Design_Request__c LIMIT 1];

    test.startTest();
    Design_Round__c round1 = TestData.designRound(new Design_Round__c(
      Design_Request__c = dr.Id,
      Version__c = '1'
    ), true);

    Design__c design1 = TestData.design(new Design__c(
      Design_Request__c = dr.Id,
      Design_Round__c = round1.Id
    ), true);

    TestData.designItem(new Design_Item__c(
      Custom_Item__c = ci.Id,
      Design__c = design1.Id,
      Price__c = 100,
      Wholesale_Price__c = 99

    ), true);

    Design__c design2 = TestData.design(new Design__c(
      Design_Request__c = dr.Id,
      Design_Round__c = round1.Id
    ), true);

    TestData.designItem(new Design_Item__c(
      Custom_Item__c = ci.Id,
      Design__c = design2.Id,
      Price__c = 200,
      Wholesale_Price__c = 199
    ), true);

    test.stopTest();
    ci = [SELECT id, Price__c, Price_per_item__c FROM Custom_Item__c LIMIT 1];

    System.assertEquals(100, ci.Price__c);
  }

  @isTest
  private static void twoDesignItemsDifferentRounds() {
    Custom_Item__c ci = [SELECT id, Price_per_item__c FROM Custom_Item__c LIMIT 1];
    Design_Request__c dr = [SELECT Id FROM Design_Request__c LIMIT 1];

    test.startTest();
    Design_Round__c round1 = TestData.designRound(new Design_Round__c(
      Design_Request__c = dr.Id,
      Version__c = '1'
    ), true);

    Design__c design1 = TestData.design(new Design__c(
      Design_Request__c = dr.Id,
      Design_Round__c = round1.Id
    ), true);

    TestData.designItem(new Design_Item__c(
      Custom_Item__c = ci.Id,
      Design__c = design1.Id,
      Price__c = 200,
      Wholesale_Price__c = 199
    ), true);

    Design_Round__c round2 = TestData.designRound(new Design_Round__c(
      Design_Request__c = dr.Id,
      Version__c = '2'
    ), true);

    Design__c design2 = TestData.design(new Design__c(
      Design_Request__c = dr.Id,
      Design_Round__c = round2.Id
    ), true);

    TestData.designItem(new Design_Item__c(
      Custom_Item__c = ci.Id,
      Design__c = design2.Id,
      Price__c = 100,
      Wholesale_Price__c = 99
    ), true);

    test.stopTest();
    ci = [SELECT id, Price__c, Price_per_item__c FROM Custom_Item__c LIMIT 1];

    System.assertEquals(100, ci.Price__c);
  }

  @isTest
  private static void twoDesignItemsWithApprovedArtwork() {
    Custom_Item__c ci = [SELECT id, Price_per_item__c FROM Custom_Item__c LIMIT 1];
    Design_Request__c dr = [SELECT Id FROM Design_Request__c LIMIT 1];

    test.startTest();
    Design_Round__c round1 = TestData.designRound(new Design_Round__c(
      Design_Request__c = dr.Id,
      Version__c = '1'
    ), true);

    Design__c design1 = TestData.design(new Design__c(
      Design_Request__c = dr.Id,
      Design_Round__c = round1.Id,
      Approved_Art__c = true
    ), true);

    TestData.designItem(new Design_Item__c(
      Custom_Item__c = ci.Id,
      Design__c = design1.Id,
      Price__c = 200,
      Wholesale_Price__c = 199
    ), true);

    Design_Round__c round2 = TestData.designRound(new Design_Round__c(
      Design_Request__c = dr.Id,
      Version__c = '2'
    ), true);

    Design__c design2 = TestData.design(new Design__c(
      Design_Request__c = dr.Id,
      Design_Round__c = round2.Id
    ), true);

    TestData.designItem(new Design_Item__c(
      Custom_Item__c = ci.Id,
      Design__c = design2.Id,
      Price__c = 100,
      Wholesale_Price__c = 99
    ), true);

    test.stopTest();
    ci = [SELECT id, Price__c, Price_per_item__c FROM Custom_Item__c LIMIT 1];

    System.assertEquals(200, ci.Price__c);
  }

  @isTest
  private static void nullPriceIsNotUsed() {
    Custom_Item__c ci = [SELECT id, Price_per_item__c FROM Custom_Item__c LIMIT 1];
    Design_Request__c dr = [SELECT Id FROM Design_Request__c LIMIT 1];

    test.startTest();
    Design_Round__c round1 = TestData.designRound(new Design_Round__c(
      Design_Request__c = dr.Id,
      Version__c = '1'
    ), true);

    Design__c design1 = TestData.design(new Design__c(
      Design_Request__c = dr.Id,
      Design_Round__c = round1.Id
    ), true);

    TestData.designItem(new Design_Item__c(
      Custom_Item__c = ci.Id,
      Design__c = design1.Id,
      Price__c = 200,
      Wholesale_Price__c = 199
    ), true);

    Design_Round__c round2 = TestData.designRound(new Design_Round__c(
      Design_Request__c = dr.Id,
      Version__c = '2'
    ), true);

    Design__c design2 = TestData.design(new Design__c(
      Design_Request__c = dr.Id,
      Design_Round__c = round2.Id
    ), true);

    Design_Item__c di =  TestData.designItem(new Design_Item__c(
      Custom_Item__c = ci.Id,
      Design__c = design2.Id,
      Price__c = null
    ), true);

      
    test.stopTest();
    ci = [SELECT id, Price__c, Price_per_item__c FROM Custom_Item__c LIMIT 1];

    System.assertEquals(200, ci.Price__c);
  }
}