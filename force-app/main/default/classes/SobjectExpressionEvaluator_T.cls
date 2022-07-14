@isTest
private class SobjectExpressionEvaluator_T {

  @isTest
  private static void evaluatesOnePartExpression() {
    Account acc = TestData.account(new Account(Name = 'ttt'), true);
    Opportunity opp = TestData.opportunity(new Opportunity(AccountId = acc.Id), true);

    System.assertEquals('ttt', SobjectExpressionEvaluator.evaluate(acc, 'Name'));
  }

  @isTest
  private static void evaluatesTwoPartExpression() {
    Account acc = TestData.account(new Account(Name = 'ttt'), true);
    Opportunity opp = TestData.opportunity(new Opportunity(AccountId = acc.Id), true);
    opp = [SELECT Name, AccountId, Account.Name FROM Opportunity WHERE Id = :opp.Id];
    System.assertEquals('ttt', SobjectExpressionEvaluator.evaluate(opp, 'Account.Name'));
  }
}