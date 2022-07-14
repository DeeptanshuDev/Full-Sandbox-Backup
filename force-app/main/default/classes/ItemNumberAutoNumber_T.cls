@isTest
private class ItemNumberAutoNumber_T {

  static final String newItemRecordTypeId;

  static {
    newItemRecordTypeId = [
      SELECT Id
      FROM RecordType
      WHERE DeveloperName = :ItemNumberAutoNumber.NEW_CUSTOM_ITEM_RECORD_TYPE_DEV_NAME
      AND SObjectType = 'Custom_Item__c'
      LIMIT 1
    ].Id;
  }


  @isTest
  private static void startsWith1() {
    TestData.customItem(new Custom_Item__c(
      RecordTypeId = newItemRecordTypeId,
      Opportunity__c = TestData.opportunity(true).Id
    ), true);

    List<Custom_Item__c> items = [SELECT New_Item_Auto_Number__c from Custom_Item__c];
    System.assertEquals(1, items.size());
    System.assertEquals(1, items[0].New_Item_Auto_Number__c);

  }

  @isTest
  private static void consecutive() {
    for (Integer i = 0; i < 2; i++) {
      TestData.customItem(new Custom_Item__c(
        RecordTypeId = newItemRecordTypeId,
        Opportunity__c = TestData.opportunity(true).Id
      ), true);
    }

    List<Custom_Item__c> items = [SELECT New_Item_Auto_Number__c from Custom_Item__c];
    System.assertEquals(2, items.size());
    System.assertEquals(1, items[0].New_Item_Auto_Number__c);
    System.assertEquals(2, items[1].New_Item_Auto_Number__c);

  }

  @isTest
  private static void existing() {
    TestData.customItem(new Custom_Item__c(
      RecordTypeId = newItemRecordTypeId,
      Opportunity__c = TestData.opportunity(true).Id
    ), true);

    Test.startTest();
    TestData.customItem(new Custom_Item__c(
      RecordTypeId = newItemRecordTypeId,
      Opportunity__c = TestData.opportunity(true).Id
    ), true);
    Test.stopTest();

    List<Custom_Item__c> items = [SELECT New_Item_Auto_Number__c from Custom_Item__c];
    System.assertEquals(2, items.size());
    System.assertEquals(1, items[0].New_Item_Auto_Number__c);
    System.assertEquals(2, items[1].New_Item_Auto_Number__c);
  }
}