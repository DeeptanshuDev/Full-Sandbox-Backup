@isTest(SeeAllData=false)
public class Scheduler_Batch_UpdateGymName_Test {

    @isTest static void testSchedule()
    {
        test.startTest();
        String cron = '0 0 8 ? * MON *';
        System.schedule('TestSchedule', cron, new Scheduler_Batch_UpdateGymName());
        test.stopTest();
    }
    
}