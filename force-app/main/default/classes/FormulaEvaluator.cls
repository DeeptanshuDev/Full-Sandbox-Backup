/*
 * Evalutes a text string with embedded expressions such as {!Account.Name}.
 * Expressions are evaluated against the context SObject.
 */
public class FormulaEvaluator {

  private static Pattern EMBEDDED_EXPRESSION = Pattern.compile('\\{!\\s*(\\S+?)\\s*}');

  public static String evaluate(SObject context, String formula) {
    Matcher m = EMBEDDED_EXPRESSION.matcher(formula);
    while (m.find()) {
      String expression = m.group(1);
      Logger.warn(expression);
      String evaluated = String.valueOf(SobjectExpressionEvaluator.evaluate(context, expression));
      if (evaluated == null) {
        evaluated = '';
      }
      formula = formula.replace(m.group(), evaluated);
    }
    return formula;
  }
}