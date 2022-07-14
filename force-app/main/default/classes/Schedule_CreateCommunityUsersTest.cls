//Test class of scheduler to create community users
@isTest
private class Schedule_CreateCommunityUsersTest 
{
    static testmethod void schedulerTest() 
    {
        String CRON_EXP = '0 0 0 15 3 ? *';
        
        Test.startTest();
        
        String jobId = System.schedule('Schedule Batch to create community users',  CRON_EXP, new Schedule_CreateCommunityUsers());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        
        Test.stopTest();
    }
}