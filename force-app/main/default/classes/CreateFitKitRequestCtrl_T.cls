@isTest
private class CreateFitKitRequestCtrl_T {

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
  }

  @isTest
  private static void createsCustomItems() {
  CreateFitKitRequestCtrl ctrl = new CreateFitKitRequestCtrl(
      new ApexPages.StandardController(fkr));

    for (CreateFitKitRequestCtrl.ItemWrapper w : ctrl.ItemWrappers) {
      w.Selected = true;
    }

    for (CreateFitKitRequestCtrl.StandardizedItemWrapper w : ctrl.StandardizedItemWrappers) {
      w.Selected = true;
    }

    ctrl.Deposit = '*new-check';

    ctrl.createRequest();

    List<Fit_Kit_Request_Custom_Item__c> customItems = [SELECT Id
    FROM Fit_Kit_Request_Custom_Item__c];
    System.assertEquals(1, customItems.size());
  }

  @isTest
  private static void createsStandardizedItems() {
    CreateFitKitRequestCtrl ctrl = new CreateFitKitRequestCtrl(
      new ApexPages.StandardController(fkr));

    for (CreateFitKitRequestCtrl.ItemWrapper w : ctrl.ItemWrappers) {
      w.Selected = true;
    }

    for (CreateFitKitRequestCtrl.StandardizedItemWrapper w : ctrl.StandardizedItemWrappers) {
      w.Selected = true;
    }

    ctrl.Deposit = '*new-check';

    ctrl.createRequest();

    List<Fit_Kit_Request_Standardized_Item__c> standardizedItems = [SELECT Id
    FROM Fit_Kit_Request_Standardized_Item__c];
    System.assertEquals(1, standardizedItems.size());
  }

  @isTest
  private static void rendersDeposits() {
    CreateFitKitRequestCtrl ctrl = new CreateFitKitRequestCtrl(
      new ApexPages.StandardController(fkr));

    Boolean foundDeposit = false;
    for (SelectOption so: ctrl.DepositSelectOptions) {
      if (so.getValue().contains(deposit.Id)) {
        foundDeposit = true;
        break;
      }
    }
    System.assert(foundDeposit, 'Expected to find $1000 deposit');
  }

  @isTest
  private static void submitsApprovalForWaiverRequest() {
    CreateFitKitRequestCtrl ctrl = new CreateFitKitRequestCtrl(
      new ApexPages.StandardController(fkr));

    for (CreateFitKitRequestCtrl.ItemWrapper w : ctrl.ItemWrappers) {
      w.Selected = true;
    }

    ctrl.Deposit = '*waiver';
    fkr.Deposit_Waiver__c = 'Requested';

    ctrl.createRequest();

    List<ProcessInstance> pis = [SELECT Id FROM ProcessInstance];
    System.assertEquals(1, pis.size());
  }

}