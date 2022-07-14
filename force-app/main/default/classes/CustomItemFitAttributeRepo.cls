public with sharing class CustomItemFitAttributeRepo {

  public Custom_Item_Fit_Attribute__c findByStyleAndFabric(String style, String fabric) {
    List<Custom_Item_Fit_Attribute__c> records = [
      Select Id
        , Style__c
        , Fabric__c
        , Product__c
      FROM Custom_Item_Fit_Attribute__c
      WHERE Style__c = :style
        AND Fabric__c = :fabric
    ];

    if (records.size() > 1) {
      throw new ApplicationException('Style and Fabric matched more than one Fit Kit: ' + style
        + ', ' + fabric);
    }
    if (records.isEmpty()) {
      throw new ApplicationException('No Fit Kit found for style and fabric combination: ' + style
          + ', ' + fabric);
    }
    return records[0];
  }

}