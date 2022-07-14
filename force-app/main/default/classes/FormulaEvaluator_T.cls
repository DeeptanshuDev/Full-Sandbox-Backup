@isTest
private class FormulaEvaluator_T {

  @isTest
  private static void test() {
    Account account1 = TestData.account(new Account(Name = 'abc'), true);
    String result = FormulaEvaluator.evaluate(account1, 'test {{!Name}}. Yeah!{!Name}');
    System.assertEquals('test {abc}. Yeah!abc', result);
  }
}