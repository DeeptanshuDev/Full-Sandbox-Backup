/**
*	Description		:	Apex Test class for Scheduled_Batch_Temp_CleanUp. 
*
*	Created By		:   Abhinav Sharma
*
*	Created Date	:   10/12/2019
* 
*	Version			:   v1.0 - Created - CR - 00000046 - Abhinav Sharma         
**/
@isTest(seealldata = false)
private class Scheduled_Batch_TempCleanUp_Test {
   
    @TestSetup
    static void ClickLinkDataSetUp() {
        //Insert clickLinkLog record
        ffirule__IntegrationRuleLog__c clickLinkLog = new ffirule__IntegrationRuleLog__c();
        clickLinkLog.ffirule__Summary__c =  'Test data';
        insert clickLinkLog;
        
        Datetime lastWeekDate = Datetime.now().addDays(-20);
		Test.setCreatedDate(clickLinkLog.Id, lastWeekDate);
      
    }
    
    //Test method to test the negative use case
    @isTest
    Static void test_unitMethod(){

        Test.startTest();
        Scheduled_Batch_Temp_CleanUp scheduled = new Scheduled_Batch_Temp_CleanUp();  
        scheduled.query = '';
        scheduled.ObjectName = 'ffirule__IntegrationRuleLog__c';
        String sch = '0 30 12 ? * THU *';
        system.schedule('Test', sch, scheduled);
        Test.stopTest();
        
       
    }
    
    //Test method to test the positive use case
    @isTest
    Static void test_unitMethod1(){
        
        Test.startTest();
        Scheduled_Batch_Temp_CleanUp scheduled = new Scheduled_Batch_Temp_CleanUp();
        scheduled.query = 'Select Id From ffirule__IntegrationRuleLog__c';
        scheduled.ObjectName = 'ffirule__IntegrationRuleLog__c';
        String sch = '0 30 12 ? * THU *';
        system.schedule('Test', sch, scheduled);
        Test.stopTest();
        
       
    }
    
   
    
}