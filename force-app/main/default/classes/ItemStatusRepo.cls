public with sharing class ItemStatusRepo {

  public Item_Status__mdt findByLabel(String label) {
    return [
      SELECT
        Id
        , Label
        , DeveloperName
        , Statuses__c
      FROM Item_Status__mdt
      WHERE Label = :label
    ];
  }

}