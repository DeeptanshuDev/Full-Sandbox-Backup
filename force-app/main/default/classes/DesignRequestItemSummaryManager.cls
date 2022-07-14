public class DesignRequestItemSummaryManager {

  public void updateFromDesignRequestIds(List<Id> designRequestIds) {
      
      system.debug('dr ids --'+designRequestIds);
      
    delete [SELECT Id FROM Design_Request_Item_Summary__c
      WHERE Design_Request__c IN :designRequestIds];

    List<AggregateResult> aggregateResults = findDesignRequests(designRequestIds);

      system.debug('aggregateResults '+aggregateResults);
    List<Design_Request_Item_Summary__c> toCreate = new List<Design_Request_Item_Summary__c>();

    for (AggregateResult ar : aggregateResults) {
      Design_Request_Item_Summary__c s = new Design_Request_Item_Summary__c();
      s.Design_Request__c = (Id) ar.get('Design_Request__c');
      s.Design_Status__c = (String) ar.get('Design_Status__c');
      s.Number_of_Items__c = (Integer) ar.get('qty');
      toCreate.add(s);
    }

    if (!toCreate.isEmpty()) {
      insert toCreate;
    }
  }

  private List<AggregateResult> findDesignRequests(List<Id> designRequestIds) {
    return [
      Select Design_Request__c, Count(Id) qty, Design_Status__c
      FROM Custom_Item__c
      WHERE Design_Request__c IN :designRequestIds
      AND Design_Request__c != null
      GROUP BY Design_Request__c, Design_Status__c
    ];
  }
}