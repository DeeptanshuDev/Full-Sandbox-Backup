/**
*	Description   	:   Test class to test the trigger 'TriggerAccountRecord' and its handler class 'TriggerAccountRecordHandler'.
* 
*  	Version			:   v1.0 - Created - CR - 000000161 - Chirag Soni 
*
*   Date            :   23/12/2020
**/ 


@isTest(seeAllData = false)
private class TriggerAccountRecordHandler_T {
    
    
    @isTest
    private static void TestupdateContractAddress()
    {        
        UserRole r = new UserRole(DeveloperName = 'Pod_Team_Member', Name = 'Pod Team Member');
        insert r;
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Rebel Sales User'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = r.Id
        );
        system.runAs(u){
        Account acc = TestData.account(new Account(
            Name = 'first Account',
            Type = 'All Star',
            Phone = '1234567890',
            Affiliate_Gym__c = true,
            Number_of_Production_Referral__c = 0),true);
        

        Contract contract1 = TestData.contract(new Contract(
            AccountId = acc.id,
            Status = 'Draft',
            StartDate = Date.today()+2,    
            ContractTerm = 2), true);
       
        
        Test.startTest();
        acc.BillingStreet = '2210 Fillmore Street';
        acc.BillingCity = 'San Francisco';
        acc.BillingState = 'California';
        acc.BillingCountry = 'United States';
        acc.BillingPostalCode = '94115'; 
        
        Util.BypassAllTriggers = true;
        update acc;
        
        acc.ShippingStreet = '1 Market Street';
        acc.ShippingCity = 'San Francisco';
        acc.ShippingState = 'Florida';
        acc.ShippingCountry = 'United States';
        acc.ShippingPostalCode = '94105' ;   
        update acc;
        
     
        Util.BypassAllTriggers = false;
        Contract contract = [SELECT BillingCity, BillingCountry, BillingStreet, BillingState, BillingPostalCode,
                             ShippingStreet, ShippingCity, ShippingState, ShippingCountry, ShippingPostalCode
                             FROM Contract WHERE AccountId =: acc.id LIMIT 1];
        Account account = [SELECT BillingCity, BillingCountry, BillingStreet, BillingState, BillingPostalCode,
                           ShippingStreet, ShippingCity, ShippingState, ShippingCountry, ShippingPostalCode
                           FROM Account WHERE Id =: acc.id];
        
        System.assertEquals(contract.BillingStreet,  account.BillingStreet);
        System.assertEquals(contract.BillingCity, account.BillingCity);
        System.assertEquals(contract.BillingState, account.BillingState);
        System.assertEquals(contract.BillingCountry, account.BillingCountry);
        System.assertEquals(contract.BillingPostalCode, account.BillingPostalCode);
        
        System.assertEquals(contract.ShippingStreet, account.ShippingStreet);
        System.assertEquals(contract.ShippingCity, account.ShippingCity);
        System.assertEquals(contract.ShippingState, account.ShippingState);
        System.assertEquals(contract.ShippingCountry, account.ShippingCountry);
        System.assertEquals(contract.ShippingPostalCode, account.ShippingPostalCode);
        
       
        Test.stopTest();
        }
    }
}