@isTest
public  class Test_Schedule_CloneOpportunityBatch{
    static testmethod void  testschedule(){
        Test.StartTest();
        Schedule_CloneOpportunityBatch sh1 = new Schedule_CloneOpportunityBatch();      
        String sch = '0  00 1 3 * ?';
        system.schedule('Test', sch, sh1);
        List<CustomOpportunity__c> customOppList = new List<CustomOpportunity__c>(); 
        Test.stopTest();
    }
}