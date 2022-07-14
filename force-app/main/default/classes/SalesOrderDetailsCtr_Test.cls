/**
*	Description   	:   Test class to perform the testing of cloneOpportunity vf page.
* 
*  	Version			:   v1.1 - Created - CR - 00000068 - Abhinav Sharma         
**/ 
@isTest
private  class SalesOrderDetailsCtr_Test 
{
    @testSetup static void setup() 
    {
        Profile prof = [select id from profile where name = 'System Administrator'];
        User usr = new User(alias = 'standt', email = 'testFeedItemDeleteDummy@testorg.com', emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = prof.Id, timezonesidkey = 'America/Los_Angeles', username = 'testFeedItemDeleteDummy'+Integer.valueof(Math.random() * 100)+'@testorg.com');
        insert usr;
        
        Account acc = new Account(Name = 'Test Account'); 
        insert acc;
        
        Opportunity opp = TestData.opportunity(true);
        opp.AccountId = acc.Id;
        update opp;
        
        SCMC__Sales_Order__c so = SalesOrderAllocateTestHelper.setupTestDataForSO();
        so.Opportunity__c = opp.Id;
        so.SCMC__Customer_Account__c = acc.Id;
        update so;
        
    }
    
    @isTest
    private static void showSalesOrder() 
    {
        Account acc = [SELECT Id FROM Account Limit 1];
        Opportunity opp = [SELECT Id,Name,StageName,CloseDate FROM Opportunity];
        opp.AccountId = acc.Id;
        update opp;
        
        Test.startTest();
            SalesOrderDetailsCtr ctrl = new SalesOrderDetailsCtr(new ApexPages.StandardController(acc));
        Test.stopTest();
    }
}