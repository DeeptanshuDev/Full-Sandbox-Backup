@isTest(seealldata = false)
private class Batch_UpdateCustomItem_Test {
/**
*	Description		:	Apex Test class for Batch_Temp_CleanUp. 
*
*	Created By		:   Abhinav Sharma
*
*	Created Date	:   10/12/2019
* 
*	Version			:   v1.0 - Created - CR - 00000046 - Abhinav Sharma         
**/
static Account acc;
    static Opportunity opp;
    static Design_Request__c designRequest;
    static Design_Round__c designRound;
    static Design__c design;
    static Product2 product1;
    static Custom_Item__c customItem;
    static Design_Item__c designItem;
   
    @TestSetup
    static void InsertExpItemWithduplicateBillNo() {
        acc = TestData.account(new Account(Name = 'Test Account For Contact',
                                           Type = 'Accounting Vendor',
                                           Phone = '1234567890'),true);
        
        Contact primaryContact = TestData.contact(new Contact (FirstName = 'Test',
                                                               LastName = 'RecipientContact',
                                                               AccountId = acc.id,
                                                               Email = 'TestRecipient@invalid.com',
                                                               Preferred_Phone__c = 'Phone'), true);
        
        opp = TestData.opportunity(new Opportunity(
            Name = 'test opp',
            AccountId = acc.Id,
            CloseDate = Date.today(),
            Amount = 200,
            StageName = 'Prototype',
            Primary_Contact__c = primaryContact.id,
            Uniform_Style__c = 'Accessory - Make-up Bag' 
        ), true);
        
        designRequest = new Design_Request__c(
            Account__c = acc.Id,
            Opportunity__c = opp.Id,
            Primary_Contact__c = primaryContact.id
        );
        insert designRequest;
        
        designRound = TestData.designRound(new Design_Round__c(
            Design_Request__c = designRequest.Id,
            Version__c = '1'
        ), true);
        
        design = TestData.design(new Design__c(
            Design_Round__c = designRound.Id
        ), true);
        
        
        customItem = TestData.customItem(new Custom_Item__c(
            Design_Request__c = designRequest.Id,
            Opportunity__c = opp.Id,
            Price_per_item__c = 20,
            Quantity__c = 30,
            Style__c = 'U101 - Girls Full-length Top'
        ), true);
    }
    
    @isTest
    Static void test_unitMethod(){

        Test.startTest();
        try{
        Batch_UpdateCustomItem batch = new Batch_UpdateCustomItem('select id,Style__c,ff_style__c,fit__c from custom_item__c');
        Database.executeBatch(batch); 
        }
        catch(Exception e){
 			system.assertEquals('Object is not eligible for deleting using this job.',e.getMessage());   
        }
       
       
        Test.stopTest();
        
        
    }
    
    

}