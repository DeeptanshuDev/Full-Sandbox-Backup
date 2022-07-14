public class ItemNotifcationSettingRepo {

  public List<Item_Notification_Setting__mdt> findAll() {
    return [
      SELECT
        DeveloperName,
        Id,
        Label,
        Language,
        MasterLabel,
        Message__c,
        NamespacePrefix,
        QualifiedApiName,
        Status__c
      FROM Item_Notification_Setting__mdt
    ];
  }
}