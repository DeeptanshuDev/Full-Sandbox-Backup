/**
*	Description   	:   Test class to perform the testing of CheckProcessSOLIOnStandardized vf page.
* 
*  	Version			:   v1.1 - Created - CR - 00000027 - Abhinav Sharma         
**/ 
@isTest
private class CheckProcessSOLIOnStandardized_T
{
    static Account account;
    static Opportunity opp;
    static Standardized_Item__c standardizedItem;
    static 
    {
        account = TestData.account(true);
        opp = TestData.opportunity(new Opportunity(
            AccountId = account.Id
        ), true);
        standardizedItem = TestData.standardizedItem(new Standardized_Item__c(Opportunity__c = opp.Id), true);
    }
    
    @isTest
    private static void redirectBackToDetailPagePositive() 
    { 
        List<Standardized_Item__c> standardizedItems = [SELECT Id FROM Standardized_Item__c WHERE Opportunity__c = :opp.Id];
        
        Test.StartTest(); 
        PageReference pageRef = Page.CheckProcessSOLIOnStandardizedItem; // Add your VF page Name here
        pageRef.getParameters().put('id', String.valueOf(opp.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(standardizedItems);
        stdSetController.setSelected(standardizedItems);
        CheckProcessSOLIOnStandardizedController checkProcessSOLIOnStandardizedController = new CheckProcessSOLIOnStandardizedController(stdSetController);
        Test.StopTest();
            
        system.assertNotEquals(null, checkProcessSOLIOnStandardizedController.redirectBackToDetailPage());
        
        List<Standardized_Item__c> updateStandardizedItems = [SELECT Id, Process_SOLI__c FROM Standardized_Item__c WHERE Opportunity__c = :opp.Id];
        system.assertEquals(true, updateStandardizedItems[0].Process_SOLI__c);
    }
    @isTest
    private static void redirectBackToDetailPageNegative()
    {
        List<Standardized_Item__c> standardizedItems =new List<Standardized_Item__c>();
        
        Test.StartTest(); 
        PageReference pageRef = Page.CheckProcessSOLIOnStandardizedItem; // Add your VF page Name here
        pageRef.getParameters().put('id', String.valueOf(opp.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(standardizedItems);
        stdSetController.setSelected(standardizedItems);
        CheckProcessSOLIOnStandardizedController checkProcessSOLIOnStandardizedController = new CheckProcessSOLIOnStandardizedController(stdSetController);
        Test.StopTest();
            
        system.assertEquals(null, checkProcessSOLIOnStandardizedController.redirectBackToDetailPage());
        
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        System.assertNotEquals(0, pageMessages.size());
        
    }
}