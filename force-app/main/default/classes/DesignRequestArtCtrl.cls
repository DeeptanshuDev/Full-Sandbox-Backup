public class DesignRequestArtCtrl {

  ApexPages.StandardController controller;

  public DesignRequestArtCtrl(ApexPages.StandardController ctrl) {
    this.controller = ctrl;
  }

  public Design_Request__c DesignRequest { get; set; }

  



}