@isTest(seeAlldata = false) 
private class DesignRequestRepo_T {

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
            Prototype_Status__c = 'PP Internal',
            Uniform_Style__c = 'Top' 
        ), true);
        
        designRequest = new Design_Request__c(
            Account__c = acc.Id,
            Opportunity__c = opp.Id,
            Primary_Contact__c = primaryContact.id
        );
        insert designRequest;
    }
        @isTest
    private static void approve() {
        
        Test.startTest();
        DesignRequestRepo cont = new DesignRequestRepo();
        cont.findOpenDesignRequests();
       cont.findById(designRequest.Id);
        cont.findByOpportunityIds(new set<Id>{opp.Id});
        cont.findByIds(new List<Id>{designRequest.Id});
        Test.stopTest();
    }
}