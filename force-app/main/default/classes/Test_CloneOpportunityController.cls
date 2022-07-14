@isTest(seealldata = false)
public class Test_CloneOpportunityController {
    
    @isTest
    static void test_doClone() {
        CloneOpportunityController.ItemWrapper items = new CloneOpportunityController.ItemWrapper();
        
        
        Account newAcc = new Account(Name = 'Fexle', Type = 'Pro', Phone = '9685742563');
        insert newAcc;
        
        Contact newCon = new Contact(LastName = 'Gupta');
        insert newCon;
        
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', Type = 'Reorder',Event_Date_Old__c = System.today(),StageName = 'Open',
                                          AccountId = newAcc.id, Collection_Picklist__c ='Poly' , Category_Picklist__c = 'Pro', 
                                          Uniform_Style__c = 'Top', Primary_Contact__c = newCon.Id, CloseDate = System.today());
        
        insert opp;
        String oppDataWrap =  ' {"id":"'+opp.Id+'","Factory_Ship_To__c":"Rebel Dallas","CloseDate":"'+opp.CloseDate+'"}';
        
        Design_Request__c dR = new Design_Request__c(Account__c = newAcc.Id, Opportunity__c = opp.Id,
                                                     Design_Request_Status__c = 'Open', Primary_Contact__c = newCon.Id);
        insert dR;
        
        Opportunity opp1 = new Opportunity(Name = 'Test Opportunity2', Type = 'Reorder',Event_Date_Old__c = System.today(),StageName = 'Open',
                                           AccountId = newAcc.id, Collection_Picklist__c ='Poly' , Category_Picklist__c = 'Pro',Design_Request__c = dR.Id, 
                                           Uniform_Style__c = 'Top', Primary_Contact__c = newCon.Id, CloseDate = System.today());
        insert opp1;
      	String oppDataWrap1 =  ' {"id":"'+opp1.Id+'","Factory_Ship_To__c":"Rebel Dallas","CloseDate":"'+opp1.CloseDate+'"}';
        String oppDataWrap2 =  JSON.serialize(opp1);

        CustomOpportunity__c customOpps = new CustomOpportunity__c();
        customOpps.opportunityId__c = opp1.Id;
        customOpps.CloseDate__c = Date.today();
        customOpps.FactoryShipTo__c = 'testing';
        customOpps.JsonData__c = 'Test area';
        insert customOpps;
        String customItemWrap  = '[{"quantity":"9","Id":"'+customOpps.id+'"}]'; 
        String customItemWrap2 = JSON.serialize(customOpps);
        
        CustomOpportunity__c customOpps2 = new CustomOpportunity__c(opportunityId__c = opp.Id,CloseDate__c = System.today(), FactoryShipTo__c = 'testing2',JsonData__c = 'Test area2');
        insert customOpps2;
        
        Test.startTest();
        LightningResponseEntity response = CloneOpportunityController.doClone(oppDataWrap,customItemWrap);
        LightningResponseEntity response1 = CloneOpportunityController.doClone(oppDataWrap1,customItemWrap);
        LightningResponseEntity response2 = CloneOpportunityController.doClone(oppDataWrap2,customItemWrap2);
        Test.stopTest();  
    }
}