public class StandardizedItemRepo {

  public List<Standardized_Item__c> findByOpportunityId(Id oppId) {
    return [
      SELECT Id
        , Name
        , Opportunity__c
        , Quantity__c
        , Product__c
        , Product_Code__c
        , Product_Description__c
        , Product_Name__c
        , List_Price__c
        , Stage__c
      FROM Standardized_Item__c
      WHERE Opportunity__c = :oppId
    ];
  }
}