/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class SalesOrderAllocateBatchTest {

    @isTest
    static void testWithoutCustomSetting() 
    {
        SCMC__Sales_Order__c so = SalesOrderAllocateTestHelper.setupTestDataForSO();
        
        SalesOrderAllocateBatch batch = new SalesOrderAllocateBatch(null);
        
        Test.startTest();
        Database.executeBatch(batch, 1);
        Test.stopTest();
        
        List<SCMC__Sales_Order__c> soList = [SELECT Id, SCMC__Status__c, (SELECT Id, SCMC__Status__c FROM SCMC__Line_Items__r) FROM SCMC__Sales_Order__c WHERE Id =:so.Id];
		System.assertEquals('Approved', soList[0].SCMC__Status__c);
		System.assertEquals('Allocated', soList[0].SCMC__Line_Items__r[0].SCMC__Status__c);
    }
    
    @isTest
    static void testWithCustomSetting() 
    {
        SalesOrderAllocation__c soCustomSetting = new SalesOrderAllocation__c(CalculateTax__c=true, EmailReceipents__c='abc@test.com', SOQL_Criteria__c='SCMC__Status__c = \'New\' AND RecordType.DeveloperName = \'Inventory\'');
        insert soCustomSetting;
        SCMC__Sales_Order__c so = SalesOrderAllocateTestHelper.setupTestDataForSO();
        
        SalesOrderAllocateBatch batch = new SalesOrderAllocateBatch(new Set<ID>{so.Id});
        
        Test.startTest();
        Database.executeBatch(batch, 1);
        Test.stopTest();
        
        System.assertEquals(1, SalesOrderAllocateService.emailsCount);
    }
    
    @isTest
    static void testWithCustomSetting_soqlCriteriaWithWrongValue() 
    {
        SalesOrderAllocation__c soCustomSetting = new SalesOrderAllocation__c(CalculateTax__c=true, EmailReceipents__c='abc@test.com', SOQL_Criteria__c='Test_SCMC__Status__c = \'New\'');
        insert soCustomSetting;
        SCMC__Sales_Order__c so = SalesOrderAllocateTestHelper.setupTestDataForSO();
        
        SalesOrderAllocateBatch batch = new SalesOrderAllocateBatch(null);
        
        Test.startTest();
        Database.executeBatch(batch, 1);
        Test.stopTest();
        
        System.assertEquals(1, SalesOrderAllocateService.emailsCount);
    }
    
    @isTest
    static void testWithCustomSetting_soqlCriteriaWithBlank() 
    {
        SalesOrderAllocation__c soCustomSetting = new SalesOrderAllocation__c(CalculateTax__c=true, EmailReceipents__c='abc@test.com');
        insert soCustomSetting;
        SCMC__Sales_Order__c so = SalesOrderAllocateTestHelper.setupTestDataForSO();
        
        SalesOrderAllocateBatch batch = new SalesOrderAllocateBatch(new Set<ID>{so.Id});
        
        Test.startTest();
        Database.executeBatch(batch, 1);
        Test.stopTest();
        
        System.assertEquals(1, SalesOrderAllocateService.emailsCount);
    }
}