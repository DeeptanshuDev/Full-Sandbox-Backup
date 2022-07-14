/** 
* 
* Description : Test class for testing schedularOfBatchToUpdateCustomItem class.
* 
* Created By : Deeptanshu Bharti
* 
* Created Date : 02/02/2022
* 
* Revision Logs : V1.0 - Created - Deeptanshu Bharti 
* 
**/
 
@isTest
private class schedularOfBatchToUpdateCustomItem_Test {
    private static String CRON_EXP = '0 0 0 ? * * *';
 
    /**
    *
    * @description : Test method for scheduling.
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
 
    public static testMethod void method1(){
        List<Custom_Item__c > listOfCustomItem = [SELECT Id, Price_Expiration_Completed__c, Custom_Item_Reorder__c, Pricing_Expiration_Date__c FROM Custom_Item__c WHERE Custom_Item_Reorder__c= NULL AND Pricing_Expiration_Date__c <= TODAY];
        if(listOfCustomItem != NULL)
        {
            update listOfCustomItem;
        }
        Test.startTest();
        String JobId = System.schedule('Test For schedular', CRON_EXP, new schedularOfBatchToUpdateCustomItem());
        Test.stopTest();
        List<Custom_Item__c > listOfCustomItem2 = [SELECT Id, Price_Expiration_Completed__c, Custom_Item_Reorder__c, Pricing_Expiration_Date__c FROM Custom_Item__c WHERE Custom_Item_Reorder__c= NULL AND Pricing_Expiration_Date__c <= TODAY];
        System.assertEquals(listOfCustomItem.size(),listOfCustomItem2.size());

    }

}