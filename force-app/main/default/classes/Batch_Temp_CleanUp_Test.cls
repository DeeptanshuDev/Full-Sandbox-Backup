/**
*	Description		:	Apex Test class for Batch_Temp_CleanUp. 
*
*	Created By		:   Abhinav Sharma
*
*	Created Date	:   10/12/2019
* 
*	Version			:   v1.0 - Created - CR - 00000046 - Abhinav Sharma         
**/
@isTest(seealldata = false)
private class Batch_Temp_CleanUp_Test {
    
    @TestSetup
    static void InsertExpItemWithduplicateBillNo() {
        //Insert clickLinkLog record
        ffirule__IntegrationRuleLog__c clickLinkLog = new ffirule__IntegrationRuleLog__c();
        clickLinkLog.ffirule__Summary__c =  'Test data';
        insert clickLinkLog;
        
        Datetime lastWeekDate = Datetime.now().addDays(-20);
		Test.setCreatedDate(clickLinkLog.Id, lastWeekDate);
      
    }
    
    @isTest
    Static void test_unitMethod(){

        Test.startTest();
        try{
        Batch_Temp_CleanUp batch = new Batch_Temp_CleanUp('','ffirule__IntegrationRuleLog__c');
        Database.executeBatch(batch); 
        }
        catch(Exception e){
 			system.assertEquals('Object is not eligible for deleting using this job.',e.getMessage());   
        }
       
        try{
        Batch_Temp_CleanUp batch1 = new Batch_Temp_CleanUp('Select Id From ffirule__IntegrationRuleLog__c','ffirule__IntegrationRuleLog__c');
        Database.executeBatch(batch1);
         }
        catch(Exception e){
			system.assertEquals('Object is not eligible for deleting using this job.',e.getMessage()); 
        }
       
        
        try{
            Batch_Temp_CleanUp batch2 = new Batch_Temp_CleanUp('Select Id From ffirule__IntegrationRuleLogLineItem__c','ffirule__IntegrationRuleLog__c');
            Database.executeBatch(batch2);
        }
        catch(Exception e){
            system.assertEquals('Mismatching exists in between mentioned query and object.',e.getMessage());
        }
        
        try{
            Batch_Temp_CleanUp batch3 = new Batch_Temp_CleanUp('Select Id From ffirule__IntegrationRuleLogLineItem__c','');
            Database.executeBatch(batch3);
        }
        catch(Exception e){
            system.assertEquals('Please specify a valid object name.',e.getMessage());
        }
        
        try{
            Batch_Temp_CleanUp batch4 = new Batch_Temp_CleanUp('Select Id From ffirule__IntegrationRuleLogLineItem__c','ffirule__IntegrationRuleLogLineItem__c');
            Database.executeBatch(batch4);
        }
        catch(Exception e){
            system.assertEquals('Object is not eligible for deleting using this job.',e.getMessage());
        }
        
        Test.stopTest();
        
        
    }
    
    
}