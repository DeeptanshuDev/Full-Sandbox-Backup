/**
*	Description   	:   Test class for GenerateArtApprovalCtrl class.
* 
*  	Version			:   v1.0 Modified by Chirag Soni 
*
*   Date            :   03/15/2021
**/ 

@isTest (seeAlldata = false)
private class GenerateArtApprovalCtrl_T {
    
    static Account acc;
    static Opportunity opp;
    static Design_Request__c designRequest;
    static Design_Round__c designRound;
    static Design__c design;
    static Product2 product1;
    static Custom_Item__c customItem;
    static Design_Item__c designItem;
    
    static {
        acc = TestData.account(new Account(Name = 'Test Account For Contact',
                                           Type = 'Accounting Vendor',
                                           Phone = '1234567890'),true);
        
        Contact primaryContact = TestData.contact(new Contact (FirstName = 'Test',
                                                               LastName = 'RecipientContact',
                                                               AccountId = acc.id,
                                                               Email = 'TestRecipient@invalid.com',
                                                               Preferred_Phone__c = 'Phone'), true);
        
        opp = TestData.opportunity(new Opportunity(
            Name = 'test opp',
            AccountId = acc.Id,
            CloseDate = Date.today(),
            Amount = 200,
            StageName = 'Prototype',
            Primary_Contact__c = primaryContact.id,
            Uniform_Style__c = 'Accessory - Make-up Bag' 
        ), true);
        
        designRequest = new Design_Request__c(
            Account__c = acc.Id,
            Opportunity__c = opp.Id,
            Primary_Contact__c = primaryContact.id
        );
        insert designRequest;
        
        designRound = TestData.designRound(new Design_Round__c(
            Design_Request__c = designRequest.Id,
            Version__c = '1'
        ), true);
        
        design = TestData.design(new Design__c(
            Design_Round__c = designRound.Id
        ), true);
        
        Test.startTest();
        
        customItem = TestData.customItem(new Custom_Item__c(
            Design_Request__c = designRequest.Id,
            Opportunity__c = opp.Id,
            Price_per_item__c = 20,
            Quantity__c = 30,
            Style__c = 'U101 - Girls Full-length Top'
        ), true);
        
        designItem = TestData.designItem(new Design_Item__c(
            Design__c = design.Id,
            Custom_Item__c = customItem.Id
        ), true);
        
        product1 = TestData.product(true);
        TestData.standardizedItem(new Standardized_Item__c(
            Opportunity__c = opp.Id,
            Product__c = product1.Id
        ), true);
        
        Test.stopTest();
    }
    
    @isTest
    private static void approve() {
        GenerateArtApprovalCtrl cont = new GenerateArtApprovalCtrl(
            new ApexPages.StandardController(designRound));
        cont.DesignWrappers[0].Items[0].Selected = true;
        PageReference pr = cont.approve();
        
        System.assert(pr != null, 'Expected a page reference');
        design = [SELECT Sent_for_Approval__c FROM Design__c LIMIT 1];
        
    }
    
     @isTest
    private static void view() {
        GenerateArtApprovalCtrl cont = new GenerateArtApprovalCtrl(
            new ApexPages.StandardController(designRound));
        cont.DesignWrappers[0].Items[0].Selected = true;
        PageReference pr = cont.viewPdf(); 
    }
    
    @isTest
    private static void cancel() {
        GenerateArtApprovalCtrl cont = new GenerateArtApprovalCtrl(
            new ApexPages.StandardController(designRound));
        PageReference pr = cont.cancel();
        System.assert(pr != null, 'Expected a page reference');
    }
}