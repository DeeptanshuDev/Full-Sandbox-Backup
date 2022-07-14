public class ItemNumberAutoNumber {

  public static final String NEW_CUSTOM_ITEM_RECORD_TYPE_DEV_NAME = 'New_Custom_Item';

  private Id newCustomItemRecordTypeId;

  public ItemNumberAutoNumber() {
    newCustomItemRecordTypeId = recordTypeId();
  }

  public void autoNumber(List<Custom_Item__c> customItems) {
    List<Custom_Item__c> itemsNeedingNumber = new List<Custom_Item__c>();
    for (Custom_Item__c item : customItems) {
      if (item.RecordTypeId == newCustomItemRecordTypeId) {
        itemsNeedingNumber.add(item);
      }
    }
    if (itemsNeedingNumber.isEmpty()) {
      return;
    }
    Integer maxInteger = largestNewItemAutoNumber();
      List<Custom_Item__c> custToUpdate = new List<Custom_Item__c>();
    for (Custom_Item__c item : itemsNeedingNumber) {
        Custom_Item__c cc = new Custom_Item__c();
        cc.Id = item.Id;
        cc.New_Item_Auto_Number__c = ++maxInteger;
        custToUpdate.add(cc);
    }
      if(custToUpdate.size() > 0){
          update custToUpdate;
      }
  }

  private Integer largestNewItemAutoNumber() {
    Decimal max = (Decimal) [
      SELECT Max(New_Item_Auto_Number__c) biggest
      FROM Custom_Item__c
      WHERE RecordTypeId = :newCustomItemRecordTypeId
      AND CreatedDate = THIS_YEAR
    ][0].get('biggest');
    if (max == null) {
      max = 0;
    }
    Integer maxInteger = max.intValue();
    return maxInteger;
  }

  private Id recordTypeId() {
    return [
      SELECT Id
      FROM RecordType
      WHERE DeveloperName = :NEW_CUSTOM_ITEM_RECORD_TYPE_DEV_NAME
      AND SObjectType = 'Custom_Item__c'
      LIMIT 1
    ].Id;
  }
}