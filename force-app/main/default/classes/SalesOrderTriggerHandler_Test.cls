@isTest(seealldata = false)
public class SalesOrderTriggerHandler_Test {
    
    @testsetup
    
    private static void newset(){
        
        Account acc = TestData.account(true);
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='testtesttest@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='testtesttest@testorg.com',
                          Commission_Override__c = 0);
        insert u;
        System.runAs(u)
        {
            
        
        Opportunity opp = TestData.opportunity(new Opportunity(AccountId = acc.Id),true);
        
        SCMC__Currency_Master__c cm = new SCMC__Currency_Master__c(SCMC__Active__c = true, SCMC__Corporate_Currency__c = true, SCMC__Number_of_decimals__c = 2);
        insert cm;
        SCMC__Sales_Order__c so = new SCMC__Sales_Order__c(SCMC__Sales_Order_Date__c = Date.today(), Opportunity__c = opp.Id, SCMC__Currency__c = cm.Id,Order_Type__c = 'Sponsor', SCMC__Customer_Account__c = acc.Id);
        insert so;
        SCMC__Item__c it = new SCMC__Item__c(Name  = 'Test', SCMC__Item_Description__c = 'tesing new');
        insert it;
		        
SCMC__Sales_Order_Line_Item__c so1 = new SCMC__Sales_Order_Line_Item__c(SCMC__Sales_Order__c = so.Id, SCMC__Item_Master__c = it.Id, SCMC__Quantity__c = 4, SCMC__Price__c = 5,Commission_Rate__c=3);
        insert so1;
        }
        
    }
     @isTest
    private static void setup() {
    
		Contact con = TestData.contact(true);
       
        List<SCMC__Sales_Order__c> sot = [select id,Opportunity__c,SCMC__Sales_Order_Date__c from SCMC__Sales_Order__c];
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Opportunity opp1 = [SELECT Id, Name, Business_Development__c FROM Opportunity LIMIT 1];
        
        sot[0].Order_Type__c = 'Sponsor';
        update sot;
        sot[0].Order_Type__c = 'Reorder';
        update sot;
        

        
    }
}