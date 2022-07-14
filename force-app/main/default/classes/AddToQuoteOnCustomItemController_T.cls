/**
*	Description   	:   Test class to perform the testing of AddToQuoteOnCustomItem vf page.
* 
*  	Version			:   v1.1 - Created - CR - 00000027 - Abhinav Sharma         
**/ 
@isTest
private class AddToQuoteOnCustomItemController_T
{
    static Account account;
    static Opportunity opp;
    static Custom_Item__c customItem;
    static 
    {
        account = TestData.account(true);
        opp = TestData.opportunity(new Opportunity(
            AccountId = account.Id
        ), true);
        customItem = TestData.customItem(new Custom_Item__c(Opportunity__c = opp.Id), true);
    }
    
    @isTest
    private static void redirectBackToDetailPagePositive() 
    { 
        List<Custom_Item__c> customItems = [SELECT Id FROM Custom_Item__c WHERE Opportunity__c = :opp.Id];
        
        Test.StartTest(); 
        PageReference pageRef = Page.AddToQuoteOnCustomItem; // Add your VF page Name here
        pageRef.getParameters().put('id', String.valueOf(opp.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(customItems);
        stdSetController.setSelected(customItems);
        AddToQuoteOnCustomItemController addToQuoteOnCustomItemController = new AddToQuoteOnCustomItemController(stdSetController);
        Test.StopTest();
            
        system.assertNotEquals(null, addToQuoteOnCustomItemController.redirectBackToDetailPage());
        
        List<Custom_Item__c> updateCustomItems = [SELECT Id, Add_to_Quote__c FROM Custom_Item__c WHERE Opportunity__c = :opp.Id];
        system.assertEquals(true, updateCustomItems[0].Add_To_Quote__c);
    }
    @isTest
    private static void redirectBackToDetailPageNegative()
    {
        List<Custom_Item__c> customItems =new List<Custom_Item__c>();
        
        Test.StartTest(); 
        PageReference pageRef = Page.AddToQuoteOnCustomItem; // Add your VF page Name here
        pageRef.getParameters().put('id', String.valueOf(opp.Id));
        Test.setCurrentPage(pageRef);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(customItems);
        stdSetController.setSelected(customItems);
        AddToQuoteOnCustomItemController addToQuoteOnCustomItemController = new AddToQuoteOnCustomItemController(stdSetController);
        Test.StopTest();
            
        system.assertEquals(null, addToQuoteOnCustomItemController.redirectBackToDetailPage());
        
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        System.assertNotEquals(0, pageMessages.size());
        
    }
}