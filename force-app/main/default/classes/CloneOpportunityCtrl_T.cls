/**
*	Description   	:   Test class to perform the testing of cloneOpportunity vf page.
* 
*  	Version			:   v1.1 - Created - CR - 00000066 - Abhinav Sharma         
**/ 
@isTest
private  class CloneOpportunityCtrl_T 
{
    
    static Opportunity opp;
    static Custom_Item__c customItem;
    static Standardized_Item__c standardItem;
    
    static 
    {
        opp = TestData.opportunity(true);
        customItem = TestData.customItem(new Custom_Item__c(Opportunity__c = opp.Id), true);
        standardItem = TestData.standardizedItem(new Standardized_Item__c(Opportunity__c = opp.Id),true);
    }
    
    @isTest
    private static void doClone() 
    {
        Test.startTest();
            CloneOpportunityCtrl ctrl = new CloneOpportunityCtrl(new ApexPages.StandardController(opp));
            ctrl.customItemList[0].Selected = True;
            ctrl.customItemList[0].customItem.Quantity__c = 1;
            
            ctrl.StandardizedItemList[0].Selected = True;
            ctrl.StandardizedItemList[0].standardItem.Quantity__c = 2;
            
            PageReference pr = ctrl.doClone();
            System.assert(pr != null, 'Expected a page reference');
        Test.stopTest();
    }
}