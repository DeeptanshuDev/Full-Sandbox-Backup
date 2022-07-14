public with sharing class CreateFitKitRequestRedirectCtrl {

  private Opportunity opp;

  public CreateFitKitRequestRedirectCtrl(ApexPages.StandardController cont) {
    opp = (Opportunity) cont.getRecord();
  }

  public PageReference redirect() {
    FitKitSettings__c settings = FitKitSettings__c.getOrgDefaults();
    if (settings == null) {
      throw new ApplicationException('Unable to get org defaults for custom setting: ' +
        'FitKitSettings__c');
    }

    // The following code will GACK.
    /*
    ApexPages.Action action = new ApexPages.Action('Fit_Kit_Request__c.New');
    PageReference pr = action.invoke();
    */

    PageReference pr = Page.CreateFitKitRequest;
    pr.getParameters().put(settings.Opportunity_Field_id__c, opp.Id);
    pr.getParameters().put('sfdc.override', '1');

    return pr;
  }
}