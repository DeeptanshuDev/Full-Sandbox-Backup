@isTest
public class RestrictMultipleDRTest {

    public TestMethod Static Void RestrictDRTest(){
        Opportunity opp = New Opportunity(Type='New Order',Name='Test',StageName='Open',CloseDate=date.newInstance(2022,09,20),
                                         Category__c='All Star',Collection__c='Purple Label',Uniform_Style__c='Top');
        insert opp;
        
        Design_Request__c dr1 = New Design_Request__c(Opportunity__c = opp.id);
        insert dr1;
        Design_Request__c dr2 = New Design_Request__c(Opportunity__c = opp.id);
        
        Test.startTest();
        
        try{
        	insert dr2;
        }
        catch(Exception d){
            System.assertEquals(true, d.getMessage().contains('There cannot be more than one Design Request'),'Blocked multiple DRs from being created');
        }
        Test.stopTest();
        
        
    }
}