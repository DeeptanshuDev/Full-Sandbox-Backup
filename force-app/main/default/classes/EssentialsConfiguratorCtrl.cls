public with sharing class EssentialsConfiguratorCtrl {

  private ApexPages.StandardController ctrl;
  private Opportunity opp;

  public Boolean HasItems { get {
    return !opp.Custom_Items__r.isEmpty();
  }}
  
  public EssentialsConfiguratorCtrl(ApexPages.StandardController ctrl) {
    this.ctrl = ctrl;
    this.opp = (Opportunity) ctrl.getRecord();
    this.opp = [SELECT Collection_Picklist__c,
      (SELECT Id FROM Custom_Items__r)
      FROM Opportunity WHERE Id = :opp.Id
    ];
  }
}