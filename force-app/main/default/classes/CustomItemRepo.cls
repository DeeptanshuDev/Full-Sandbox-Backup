public with sharing class CustomItemRepo {

  public List<Custom_Item__c> findByOpportunity(Id opportunityId) {
    return [
      SELECT Id
        , Name
        , Quantity__c
        , Style__c
        , Style_Name__c
        , Style_Number__c
        , Category__c
        , Collection__c
        , New_Item_Auto_Number__c
        , Fabric_Options__c
        , Item_Number_Edit__c
        , Gender__c
        , Design_Status__c
        , Stage__c
      FROM Custom_Item__c
      WHERE Opportunity__c = :opportunityId
    ];
  }
}