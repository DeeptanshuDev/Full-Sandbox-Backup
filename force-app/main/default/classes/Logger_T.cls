@isTest
private class Logger_T {

  @isTest
  private static void test() {
    Logger.debug('test');
    Logger.error('test');
    Logger.fine('test');
    Logger.finer('test');
    Logger.finest('test');
    Logger.info('test');
    Logger.warn('test');
    ApplicationException ex = new ApplicationException();
    Logger.error(ex);
  }
}