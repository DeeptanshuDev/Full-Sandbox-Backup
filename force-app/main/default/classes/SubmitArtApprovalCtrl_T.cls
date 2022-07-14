@isTest
private class SubmitArtApprovalCtrl_T {

  static Account acc;
  static Opportunity opp;
  static Design_Request__c designRequest;
  static Design_Option__c designOption;

  static {
    acc = TestData.account(true);

    opp = TestData.opportunity(new Opportunity(
      Name = 'test opp',
      AccountId = acc.Id,
      CloseDate = Date.today(),
      Amount = 200,
      StageName = 'Prototype'
    ), true);

    designRequest = new Design_Request__c(
      Account__c = acc.Id,
      Opportunity__c = opp.Id
    );
    insert designRequest;

    designOption = new Design_Option__c(
      Design_Request__c = designRequest.Id,
      Options_for_Approval__c = 'Option 1'
    );
    insert designOption;

    insert new Custom_Item__c(
      Design_Request__c = designRequest.Id,
      Opportunity__c = opp.Id,
      Price_per_item__c = 20,
      Quantity__c = 30,
      Style__c = 'U101 - Girls Full-length Top'
    );
  }

  @isTest
  private static void doStuff() {
    SubmitArtApprovalCtrl cont = new SubmitArtApprovalCtrl(
      new ApexPages.StandardController(designOption));
    cont.doStuff();
    Design_Option__c designOption1 = [SELECT Submit_For_Art_Approval__c FROM Design_Option__c LIMIT 1];
    System.assert(designOption1.Submit_For_Art_Approval__c);
  }
}