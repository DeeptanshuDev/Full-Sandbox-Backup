//Testing POC for CR-20210323-15018 - created by - chirag soni - 05/12/2021

@isTest(seeAllData = false)
private class Test_LookupfieldController1 {
    
    @testSetup static void testSetupData()
    {
        Util.BypassAllTriggers = true;
        Account acct = TestUtilities.CreateNewAccount(true);
        
        List<c2g__codaDimension1__c> dimensionRecords = new List<c2g__codaDimension1__c>();
        dimensionRecords.add(new c2g__codaDimension1__c(Name = 'test 1 dimension', c2g__ReportingCode__c = 'c2G_001'));
        dimensionRecords.add(new c2g__codaDimension1__c(Name = 'test 2 dimension',  c2g__ReportingCode__c = 'c2G_002'));
        dimensionRecords.add(new c2g__codaDimension1__c(Name = 'test 3 dimension',  c2g__ReportingCode__c = 'c2G_003'));
        
        insert dimensionRecords;
        
        List<Create_Sandbox_Request__c> sandboxRefreshDetails = new List<Create_Sandbox_Request__c>();
        sandboxRefreshDetails.add(new Create_Sandbox_Request__c(Sandbox_Name__c = 'TestOnly',
                                                                Sandbox_Description__c = 'TestDes',
                                                                Selected_Account__c = acct.Id,
                                                                Auto_Activate__c = false));
        insert sandboxRefreshDetails;
        Util.BypassAllTriggers = false;
    }
    
    static testMethod void testGetResults(){
        
        Test.startTest();
        
        List<LookupfieldController1.SObJectResult> sObjectResultList = new List<LookupfieldController1.SObJectResult>();
        
        sObjectResultList = LookupfieldController1.getResults('c2g__codaDimension1__c', 'Name', 'test');
        
        // search results 
        System.assertEquals('test 1 dimension', sObjectResultList[0].recName);
        System.assertEquals('c2G_001', sObjectResultList[0].recCode);
        
        System.assertEquals('test 2 dimension', sObjectResultList[1].recName);
        System.assertEquals('c2G_002', sObjectResultList[1].recCode);
        
        System.assertEquals('test 3 dimension', sObjectResultList[2].recName);
        System.assertEquals('c2G_003', sObjectResultList[2].recCode);
        
        Test.stopTest();
    }
    
    static testMethod void testSaveAndUpdateEABEvent(){
        
        Create_Sandbox_Request__c createSandBoxRequest = [SELECT Id FROM Create_Sandbox_Request__c];
        
        Test.startTest();
        boolean isSucess =  LookupfieldController1.saveAndUpdateEABEvent(createSandBoxRequest.Id, 'c2G_002');
        
        createSandBoxRequest = [SELECT Id, Budgeted_Cost_Center__c FROM Create_Sandbox_Request__c];
        
        System.assertEquals(true, isSucess);
        System.assertEquals('c2G_002', createSandBoxRequest.Budgeted_Cost_Center__c);
        
        Test.stopTest();
    }
}