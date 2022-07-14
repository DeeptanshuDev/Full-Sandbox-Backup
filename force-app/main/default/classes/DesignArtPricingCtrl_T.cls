@isTest
private class DesignArtPricingCtrl_T {

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
  private static void test() {
    Design_Request__c dreq = [SELECT Id FROM Design_Request__c LIMIT 1];
    DesignArtPricingCtrl ctrl = new DesignArtPricingCtrl(new ApexPages.StandardController(dreq));

    System.assertEquals(1, ctrl.VersionSelectOptions.size());
    System.assertEquals(1, ctrl.Designs.size());

    ctrl.save();
      ctrl.redirectToDesignRounds();
     ctrl.redirectToDesignRequests();
      ctrl.getdynamiclist();
      ctrl.getcategorylist();
      ctrl.getdynamiclist3();
      ctrl.getdynamiclist2();
  }
}