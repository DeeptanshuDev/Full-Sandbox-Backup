/**
*	Description   	:   Test class for ArtApprovalProtoPdfCtrl class.
* 
*  	Version			:   v1.0 Created by Chirag Soni sir
*
*   Date            :   03/16/2021
**/ 
@isTest (seeAlldata = false)
private class ArtApprovalProtoPdfCtrl_T {
    
    static Account acc;
    static Opportunity opp;
    static Design_Request__c designRequest;
    static Design_Round__c designRound;
    static Design__c design;
    static Product2 product1;
    static Custom_Item__c customItem;
    static Design_Item__c designItem;
    static Design_Option__c designOption;
    static Standardized_Item__c standardizedItem;
    
    static {
        acc = TestData.account(new Account(Name = 'Test Account',
                                           Type = 'Accounting Vendor',
                                           Phone = '1234567890'),true);
        
        opp = TestData.opportunity(new Opportunity(
            Name = 'test opp',
            AccountId = acc.Id,
            CloseDate = Date.today(),
            Amount = 200,
            StageName = 'Prototype',
            Prototype_Status__c = 'Proto',
            Uniform_Style__c = 'Practicewear' 
        ), true);
        
        designRequest = new Design_Request__c(
            Account__c = acc.Id,
            Opportunity__c = opp.Id
        );
        insert designRequest;
        
        customItem = TestData.customItem(new Custom_Item__c(
            Design_Request__c = designRequest.Id,
            Opportunity__c = opp.Id,
            Price_per_item__c = 20,
            Price__c = 16,
            Quantity__c = 50,
            Style__c = 'U101 - Girls Full-length Top'
        ), true);
        
        Product2 product1 = TestData.product(true);
        standardizedItem = TestData.standardizedItem(new Standardized_Item__c(
            Opportunity__c = opp.Id,
            Product__c = product1.Id
        ), true);
        
        designRound = TestData.designRound(new Design_Round__c(
            Design_Request__c = designRequest.Id,
            Version__c = '1'
        ), true);
        
        
        design = TestData.design(new Design__c(
            Design_Round__c = designRound.Id
        ), true);
        
        designItem = TestData.designItem(new Design_Item__c(
            Design__c = design.Id,
            Custom_Item__c = customItem.Id
        ), true);
        
  }
    
    @isTest
    private static void test() {
        PageReference pr = Page.ArtApprovalPdf;
        pr.getParameters().put('items', customItem.Id);
        pr.getParameters().put('stditems', standardizedItem.Id);
        Test.setCurrentPage(pr);		
        ArtApprovalProtoPdfCtrl cont = new ArtApprovalProtoPdfCtrl(new ApexPages.StandardController(designRound));
        cont.formatCurrency(3.335);
        cont.fetchOptionNumbers();
        cont.fetchDesignItems();
        cont.getPromoCode();
        cont.fetchVersion();
        System.assert(cont.Today != null, 'Expected non-null date.');
        System.assertEquals('Test Account', cont.Customer);
        System.assertEquals(null, cont.Designer);
        System.assert(cont.OwnerName != 'abc');
    }
}