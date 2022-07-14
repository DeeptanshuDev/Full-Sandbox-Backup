@isTest
private class SalesOrderAllocateControllerTest {

	@isTest
    static void withSelectionSOTest() {
        SCMC__Sales_Order__c so = SalesOrderAllocateTestHelper.setupTestDataForSO();
        
        ApexPages.Standardsetcontroller ssc = new ApexPages.Standardsetcontroller(new List<SCMC__Sales_Order__c>{so});
        ssc.setSelected(new List<SCMC__Sales_Order__c>{so});
        SalesOrderAllocateController stdController = new SalesOrderAllocateController(ssc);
        
        Test.startTest();
        PageReference p = stdController.allocate();
        Test.stopTest();
        
        Boolean message = false;
        
        for(ApexPages.Message msg: ApexPages.getMessages())
        {
            if(msg.getSummary().contains('Sales Order Allocation process is in progress. You will be notified by email when process is complete.'))
            {
                message = true;
                break;
            }
        }

        System.assertEquals(true, message);
    }
    
    @isTest
    static void withoutSelectionSOTest() {
        SCMC__Sales_Order__c so = SalesOrderAllocateTestHelper.setupTestDataForSO();
        
        ApexPages.Standardsetcontroller ssc = new ApexPages.Standardsetcontroller(new List<SCMC__Sales_Order__c>{so});
        SalesOrderAllocateController stdController = new SalesOrderAllocateController(ssc);
        
        System.assertEquals(1, ApexPages.getMessages().size());
        System.assertEquals('Please select at least one sales order', ApexPages.getMessages()[0].getDetail());
    }
}