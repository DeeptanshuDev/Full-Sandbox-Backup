@isTest
private class EssentialsConfiguratorCtrl_T {

  static Account account1;
  static Opportunity opportunity1;

  static {
    account1 = TestData.account();

    opportunity1 = TestData.opportunity(new Opportunity(
      AccountId = account1.Id
    ), true);

    TestData.customItem(new Custom_Item__c(
      Opportunity__c = opportunity1.Id
    ), true);
  }

  @isTest
  private static void test() {
    EssentialsConfiguratorCtrl ctrl = new EssentialsConfiguratorCtrl(
      new ApexPages.StandardController(opportunity1));
    System.assert(ctrl.HasItems);
  }
}