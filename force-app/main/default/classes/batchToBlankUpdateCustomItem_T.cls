/** 
* 
* Description : Test class for testing Batch_ToBlankUpdateCustomItem Batch.
* 
* Created By : Deeptanshu Bharti
* 
* Created Date : 01/27/2022
* 
* Revision Logs : V1.0 - Created - Deeptanshu Bharti 
* 
**/
@isTest
private class batchToBlankUpdateCustomItem_T {
    /**
    *
    * @description : Test method for batch.
    *
    * @args :
    *
    * @return : void
    *
    * @revision Log : V1.1 - Created - 08/05/2021 - Deeptanshu Bharti
    *
    * coverage : 100%
    *
    **/    
	 @isTest
	private Static void testme(){
        
        Account acc = TestData.account(true);
        Opportunity opp = TestData.opportunity(new Opportunity(AccountId = acc.Id),true);
        
        
        
        
        Custom_Item__c cItem1 = new Custom_Item__c(Name='cItemTest1', FF_Reorder_Sizing__c=true, order_id__c='order1', 
                                                   FF_Create_Item_Successful__c=false, is_submitted__c='true', 
                                                   Style__c='Custom Kicks Shoe - High Top', Category__c='Gymnastics', 
                                                   Design_Status__c='Confirmed to Send', Gender__c='Boy', Fabric_Options__c='Mistique', 
                                                   Opportunity__c=opp.Id, Product_Style__c='Custom Bow', Quantity__c=8, 
                                                   Stated_Quantity__c=8, Price_per_item__c=500,Price_Expiration_Completed__c = false, Pricing_Expiration_Date__c = date.today());
        insert cItem1;
        
        String cron_exp = '0 * * * * ?';
        Test.startTest();
        Batch_ToBlankUpdateCustomItem myBatchObject = new Batch_ToBlankUpdateCustomItem();
    
        Id batchId = Database.executeBatch(myBatchObject);
        
        Test.stopTest();
        Custom_Item__c obj = [SELECT Id,Price_Expiration_Completed__c FROM Custom_Item__c WHERE Id=:cItem1.Id];
        System.debug('custom item is :' + obj);
        System.assertEquals(cItem1.Price_Expiration_Completed__c, obj.Price_Expiration_Completed__c);
    }
    

}