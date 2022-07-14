@isTest(seeAlldata = false)
public class Test_CloneOpportunityBatch {
    
    public static Opportunity opp;
    
    static {
        Account newAcc = new Account(Name = 'Fexle', Type = 'Pro', Phone = '9685742563');
        insert newAcc;
        
        Contact newCon = new Contact(LastName = 'Gupta');
        insert newCon;
        
        opp = new Opportunity(Name = 'Test Opportunity1', Type = 'Reorder',Event_Date_Old__c = System.today(),StageName = 'Open',
                              AccountId = newAcc.id, Collection_Picklist__c ='Poly' , Category_Picklist__c = 'Pro', 
                              Uniform_Style__c = 'Top', Primary_Contact__c = newCon.Id, CloseDate = System.today());
        insert opp;
        
        Design_Request__c dR = new Design_Request__c(Account__c = newAcc.Id, Opportunity__c = opp.Id,
                                                     Design_Request_Status__c = 'Open', Primary_Contact__c = newCon.Id);
        insert dR;
    }
    
    @isTest
    static void test_unitMethod() {  
        /*
        CustomOpportunity__c customOpps = new CustomOpportunity__c();
        customOpps.opportunityId__c = opp.Id;
        customOpps.CloseDate__c = Date.today();
        customOpps.FactoryShipTo__c = 'testing';
        insert customOpps;
        
        String customItemWrap  = ''; 
        String customItemWrapper = JSON.serialize(customOpps);
        
        customOpps.JsonData__c = customItemWrapper;
        */
        Test.startTest();
        
        // Executing batch.
        CloneOpportunityBatch cloneOpp = new CloneOpportunityBatch();
        Database.executeBatch(cloneOpp);
        
        Test.stopTest();
    }
}