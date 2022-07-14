/**
*   Purpose         :   Test class for Batch_CreateSBRequest
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
private class Test_Batch_CreateSBRequest 
{
    @TestSetup
    static void testSetup() 
    {
        List<Create_Sandbox_Request__c> listOfCSR = new List<Create_Sandbox_Request__c>();
        for(Integer i = 0 ; i < 5 ; i++)
        {
            Create_Sandbox_Request__c csR = new Create_Sandbox_Request__c();
            csR.Sandbox_Name__c = 'Testing Sandbox ' + i;
            csR.Sandbox_Description__c = 'Test';
            csR.Auto_Activate__c = true;
            csR.Status__c = System.Label.Sandbox_Request_Awaiting_Sandbox_Creation;
            listOfCSR.add(csR);
        }   
        insert listOfCSR;
    }
    
    @isTest
    static void batchTest()
    {
        Test.startTest();
        Database.executeBatch(new Batch_CreateSBRequest());
        Test.stopTest();
    }
}