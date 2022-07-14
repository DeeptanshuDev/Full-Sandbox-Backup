/**
*   Purpose         :   Test class for Scheduler_CreateSBRequest
*            
*   Create By       :   Abhinav Sharma
* 
*   Created Date    :   03/12/2020
*
*   Revision Log    :   V_1.0 - Created - Abhinav Sharma 
*   
*   Coverage        :   V_1.0
*
**/
@isTest(seeAllData = false)
private class Test_Scheduler_CreateSBRequest 
{
    public static testMethod void testschedule() 
    {
        Test.StartTest();
        
        String sch = '0 0 23 * * ?'; 
        String jobId = System.schedule('Test_Scheduler_CreateSBRequest',  sch, new Scheduler_CreateSBRequest());
        
        Test.stopTest();
    }
}