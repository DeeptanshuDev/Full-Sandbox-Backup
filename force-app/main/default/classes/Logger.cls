public with sharing class Logger {


  // don't instantiate
  private  Logger() { }

  public static void error(Exception ex) {
    error(formatException(ex));
  }

  public static void error(Object obj) {
    log(LoggingLevel.ERROR, obj);
  }

  public static void warn(Object obj) {
    log(LoggingLevel.WARN, obj);
  }

  public static void info(Object obj) {
    log(LoggingLevel.INFO, obj);
  }

  public static void debug(Object obj) {
    log(LoggingLevel.DEBUG, obj);
  }

  public static void fine(Object obj) {
    log(LoggingLevel.FINE, obj);
  }

  public static void finer(Object obj) {
    log(LoggingLevel.FINER, obj);
  }

  public static void finest(Object obj) {
    log(LoggingLevel.FINEST, obj);
  }

  private static void log(LoggingLevel level, Object obj) {
    System.debug(level, obj);
  }

  private static String formatException(Exception e) {
    String msg = '';
    while (e != null) {
      if (msg != '') {
        msg += '\n';
      }
      msg += e.getMessage();
      msg += '\n' + e.getStackTraceString();
      e = e.getCause();
    }
    return msg;
  }
}