public with sharing class SubmitArtApprovalCtrl 
{
    private Design_Option__c designOption;
    private ApexPages.StandardController standardController;
    
    public SubmitArtApprovalCtrl(ApexPages.StandardController cont) 
    {
        this.standardController = cont;
        this.designOption = (Design_Option__c) cont.getRecord();
    }
    
    public PageReference doStuff() 
    {
        designOption.Submit_For_Art_Approval__c = true;
        update designOption;
        return standardController.view();
    }
}