/*
 * Evaluates a formula expression, such as "Account__r.Name" against an SObject.
 */
public class SobjectExpressionEvaluator {

  public static Object evaluate(SObject sob, String expression) {
    List<String> expressions = expression.split('\\.');
    SObject currentSob = sob;
    Object value;
    for (Integer i = 0; i < expressions.size(); i++) {
      Logger.warn(expressions[i]);
      if (i != expressions.size() - 1) {
        currentSob = currentSob.getSObject(expressions[i]);
      }
      else {
        value = currentSob.get(expressions[i]);
      }
    }
    return value;
  }
}