@isTest
private class SalesOrderAllocateSchedulerTest {

    @isTest
    static void testScheduler()   
    {
        Test.startTest();
        
        // Schedule the test job  
        String jobId = System.schedule('testBasicScheduledApex','0 0 0 3 9 ? 2022', new SalesOrderAllocateScheduler());
        // Get the information from the CronTrigger API object  
        CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        // Verify the expressions are the same  
        System.assertEquals('0 0 0 3 9 ? 2022', ct.CronExpression);
        // Verify the job has not run  
        System.assertEquals(0, ct.TimesTriggered);
        
        Test.stopTest();
    }
}