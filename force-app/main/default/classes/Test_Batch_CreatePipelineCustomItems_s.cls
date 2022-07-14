@isTest(SeeAllData=false)
public class Test_Batch_CreatePipelineCustomItems_s {
 @isTest static void testSchedule()
    {
        test.startTest();
        String cron = '0 0 8 ? * MON *';
        System.schedule('TestSchedule', cron, new Batch_CreatePipelineCustomItems_s());
        
        String cron1 = '0 0 8 ? * MON *';
        System.schedule('TestSchedule1', cron, new Batch_CreatePipelineStandardItems_S());
        
        String cron2 = '0 0 8 ? * MON *';
        System.schedule('TestSchedule2', cron, new Batch_CreatePipelineReceivedOrderLine_S());
        test.stopTest();
    }
}