@isTest
private class DesignRoundTriggerHandler_T {

  @TestSetup
  private static void setup() {
    Opportunity opp = TestData.opportunity(true);
    Design_Request__c dr = TestData.designRequest(new Design_Request__c(Opportunity__c = opp.Id),
      true);
    Design_Round__c round = TestData.designRound(new Design_Round__c(
      Design_Request__c = dr.Id,
        Artwork_Approved__c= true,
        Uniform_Sold_as_Practicewear__c =true,
        Gender__c = 'Boy',
      Version__c = '1'
    ), true);
      Design_Round__c round1 = TestData.designRound(new Design_Round__c(
      Design_Request__c = dr.Id,
        Artwork_Approved__c= true,
        Uniform_Sold_as_Practicewear__c =true,
        Gender__c = 'Girl',
      Version__c = '1'
    ), true);
      
      Design_Round__c round2 = TestData.designRound(new Design_Round__c(
      Design_Request__c = dr.Id,
        Artwork_Approved__c= true,
        Uniform_Sold_as_Practicewear__c =false,
        Gender__c = 'Girl',
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
    
  }
}