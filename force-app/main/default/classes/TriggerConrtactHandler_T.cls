/**
*	Description   	:   Test class to test the trigger 'TriggerContract' and its handler class 'TriggerContractHandler'.
* 
*  	Version			:   v1.0 - Created - CR - 000000161 - Chirag Soni 
*
*   Date            :   23/12/2020
**/ 


@isTest(seeAllData = false)
private class TriggerConrtactHandler_T {
     
    @isTest
    private static void addAddressOnContract()
    {
        
        Account acc = TestData.account(new Account(
            Name = 'first Account',
            Type = 'All Star',
            Phone = '1234567890',
            BillingStreet = '2210 Fillmore Street',
            BillingCity = 'San Francisco',
            BillingState = 'California',
            BillingCountry = 'United States',
            BillingPostalCode = '94115',
        
            ShippingStreet = '1 Market Street',
            ShippingCity = 'San Francisco',
            ShippingState = 'Florida',
            ShippingCountry = 'United States',
            ShippingPostalCode = '94105'),true);
        
        
            Contract contract1 = TestData.contract(new Contract( // Both Address will be populated from account
            AccountId = acc.id,
            Status = 'Draft',
            StartDate = Date.today()+2,    
            ContractTerm = 2), true);
            
            Contract contract2 = TestData.contract(new Contract(// shipping Address will be populated from account
            AccountId = acc.id,
            Status = 'Draft',
            StartDate = Date.today()+2,    
            ContractTerm = 2,
            BillingStreet = '2210 Fillmore Street',
            BillingCity = 'San Francisco',
            BillingState = 'California',
            BillingCountry = 'United States',
            BillingPostalCode = '94115'), true);
            
            Contract contract3 = TestData.contract(new Contract( // billing Address will be populated from account
            AccountId = acc.id,
            Status = 'Draft',
            StartDate = Date.today()+2,    
            ContractTerm = 2,
            ShippingStreet = '1 Market Street',
            ShippingCity = 'San Francisco',
            ShippingState = 'Florida',
            ShippingCountry = 'United States',
            ShippingPostalCode = '94105'), true);
        
        
           Test.startTest();
           List<Contract> contract = [SELECT BillingCity, BillingCountry, BillingStreet, BillingState, BillingPostalCode,
                                     ShippingStreet, ShippingCity, ShippingState, ShippingCountry, ShippingPostalCode
                                     FROM Contract WHERE AccountId =: acc.id];
           
         
          //------------------ Contract1 both address populate from account ------------------//
          System.assertEquals(contract.get(0).BillingStreet, acc.BillingStreet);
          System.assertEquals(contract.get(0).BillingCity, acc.BillingCity);
          System.assertEquals(contract.get(0).BillingState, acc.BillingState);
          System.assertEquals(contract.get(0).BillingCountry, acc.BillingCountry);
          System.assertEquals(contract.get(0).BillingPostalCode, acc.BillingPostalCode);
        
          System.assertEquals(contract.get(0).ShippingStreet, acc.ShippingStreet);
          System.assertEquals(contract.get(0).ShippingCity, acc.ShippingCity);
          System.assertEquals(contract.get(0).ShippingState, acc.ShippingState);
          System.assertEquals(contract.get(0).ShippingCountry, acc.ShippingCountry);
          System.assertEquals(contract.get(0).ShippingPostalCode, acc.ShippingPostalCode);
         
        
         //-------------- Contract2 Shipping address will be populate from account ------------//
          System.assertEquals(contract.get(1).ShippingStreet, acc.ShippingStreet);
          System.assertEquals(contract.get(1).ShippingCity, acc.ShippingCity);
          System.assertEquals(contract.get(1).ShippingState, acc.ShippingState);
          System.assertEquals(contract.get(1).ShippingCountry, acc.ShippingCountry);
          System.assertEquals(contract.get(1).ShippingPostalCode, acc.ShippingPostalCode);
          
        
          //-------------- Contract3 Billing address will be populate from account ------------//
          System.assertEquals(contract.get(2).BillingStreet, acc.BillingStreet);
          System.assertEquals(contract.get(2).BillingCity, acc.BillingCity);
          System.assertEquals(contract.get(2).BillingState, acc.BillingState);
          System.assertEquals(contract.get(2).BillingCountry, acc.BillingCountry);
          System.assertEquals(contract.get(2).BillingPostalCode, acc.BillingPostalCode);
          Test.stopTest();
    }   
}