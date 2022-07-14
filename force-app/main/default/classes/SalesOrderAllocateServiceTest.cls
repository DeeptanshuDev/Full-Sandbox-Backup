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
private class SalesOrderAllocateServiceTest 
{
    @isTest
    static void allocateTest() 
    {
		SCMC__Sales_Order__c so = SalesOrderAllocateTestHelper.setupTestDataForSO();
		
		Test.startTest();
		SalesOrderAllocateService.allocateSalesOrders(new Set<ID>{so.Id});
		Test.stopTest();
		
		List<SCMC__Sales_Order_Line_Item__c> sol = [SELECT Id, SCMC__Status__c FROM SCMC__Sales_Order_Line_Item__c WHERE SCMC__Sales_Order__c=:so.Id];
		System.assertEquals('Allocated', sol[0].SCMC__Status__c);
	}
	
	@isTest
	static void approvalTest() 
    {
		SCMC__Sales_Order__c so = SalesOrderAllocateTestHelper.setupTestDataForSO();
		
		Test.startTest();
		SalesOrderAllocateService.allocateSalesOrders(new Set<ID>{so.Id});
		SalesOrderAllocateService.approveSalesOrders(new Set<ID>{so.Id});
		Test.stopTest();
		
		List<SCMC__Sales_Order__c> soList = [SELECT Id, SCMC__Status__c, (SELECT Id, SCMC__Status__c FROM SCMC__Line_Items__r) FROM SCMC__Sales_Order__c WHERE Id =:so.Id];
		System.assertEquals('Approved', soList[0].SCMC__Status__c);
		System.assertEquals('Allocated', soList[0].SCMC__Line_Items__r[0].SCMC__Status__c);
	}
	
	@isTest
	static void calculateTaxTest() 
    {
		SCMC__Sales_Order__c so = SalesOrderAllocateTestHelper.setupTestDataForSO();
		
		Test.startTest();
		Map<Id, String> error = SalesOrderAllocateService.calculateTaxForSalesOrders(new Set<Id>{so.Id});
		Test.stopTest();
		
		System.assert(error != null);
	}
	
	@isTest
	static void getIsCalculateTaxTest() 
    {
		Boolean status = SalesOrderAllocateService.getIsCalculateTax();
		System.assertEquals(false, status);
		
		SalesOrderAllocation__c soTax = SalesOrderAllocation__c.getOrgDefaults();
		soTax.CalculateTax__c = true;
		insert soTax;
		
		status = SalesOrderAllocateService.getIsCalculateTax();
		
		System.assertEquals(true, status);
	}
	
	@isTest
	static void getBatchSizeTest() 
    {
		Integer batchSize = SalesOrderAllocateService.getBatchSize();
		System.assertEquals(1, batchSize);
		
		SalesOrderAllocation__c soBatchSize = SalesOrderAllocation__c.getOrgDefaults();
		soBatchSize.BatchSize__c = -1;
		insert soBatchSize;
		
		batchSize = SalesOrderAllocateService.getBatchSize();
		System.assertEquals(1, batchSize);
		
		soBatchSize.BatchSize__c = 2;
		update soBatchSize;
		
		batchSize = SalesOrderAllocateService.getBatchSize();
		System.assertEquals(2, batchSize);
	}
	
	
	@isTest
	static void getSOQLCriteria() 
    {
		String soqlCriteria = SalesOrderAllocateService.getSOQLCriteria();
		System.assertEquals(null, soqlCriteria);
	}
}