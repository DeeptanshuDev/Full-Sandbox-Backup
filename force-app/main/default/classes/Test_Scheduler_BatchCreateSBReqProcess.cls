/**
*   Purpose         :   Test class for Scheduler_BatchCreateSBRequestProcess
*            
*   Create By       :   Abhinav Sharma
* 
*   Created Date    :   03/13/2020
*
*   Revision Log    :   V_1.0 - Created - Abhinav Sharma 
*   
*   Coverage        :   V_1.0
*
**/
@isTest(seeAllData = false)
private class Test_Scheduler_BatchCreateSBReqProcess 
{
    @testSetup static void testSetupData()
    {
        Util.BypassAllTriggers = true;
        Account acct = TestUtilities.CreateNewAccount(true);
        List<Create_Sandbox_Request__c> sandboxRefreshDetails = new List<Create_Sandbox_Request__c>();
        sandboxRefreshDetails.add(new Create_Sandbox_Request__c(Sandbox_Name__c = 'TestOnly',
                                                                Sandbox_Description__c = 'TestDes',
                                                                Selected_Account__c = acct.Id,
                                                                Auto_Activate__c = false));
        insert sandboxRefreshDetails;
        Util.BypassAllTriggers = false;
    }
    
    static testMethod void test_SchedulerBSBReqProcess()
    {
        List<SandboxCreateWrapper> listOfSandboxCreateResultsWrapper = new List<SandboxCreateWrapper>();
        
        List<Create_Sandbox_Request__c> createSBRequests = [SELECT Id FROM Create_Sandbox_Request__c];
        SandboxCreateWrapper sCW = new SandboxCreateWrapper();
        sCW.cSRequest.Id = createSBRequests[0].Id;
        listOfSandboxCreateResultsWrapper.add(sCW);
        Test.startTest();
        /*Scheduler_BatchCreateSBRequestProcess.scheduleAfterMinutesForPage(Integer.valueOf(System.Label.Time_Duration_Recursive_Sandbox_Process_Job_Status),
                                                                          true,listOfSandboxCreateResultsWrapper); */
        
        
        
        Test.stopTest();
    }
    
    static testMethod void test_SchedulerBSBReqProcessBatchContext()
    {
        List<SandboxCreateWrapper> listOfSandboxCreateResultsWrapper = new List<SandboxCreateWrapper>();
        List<SandboxCreateWrapper> listOfSandboxCreateResultsWrap = new List<SandboxCreateWrapper>();
        List<Create_Sandbox_Request__c> createSBRequests = [SELECT Id FROM Create_Sandbox_Request__c];
        SandboxCreateWrapper sCW = new SandboxCreateWrapper();
        sCW.cSRequest.Id = createSBRequests[0].Id;
        listOfSandboxCreateResultsWrapper.add(sCW);
        
        Test.startTest();
        
        Scheduler_BatchCreateSBRequestProcess.scheduleAfterMinutesForPage(Integer.valueOf(System.Label.Time_Duration_Recursive_Sandbox_Process_Job_Status),
                                                                          false,listOfSandboxCreateResultsWrapper);
        
        Test.stopTest();
    }
}