/**
*	Description   	:   Test class to perform the testing of cloneOpportunity vf page.
* 
*  	Version			:   v1.1 - Created - CR - 00000066 - Abhinav Sharma         
**/ 
@isTest
private class CloneOpportunity_T 
{
    
    static Opportunity opp;
    static Custom_Item__c customItem;
    static Standardized_Item__c standardItem;
    static Contact contact1;
    
    static 
    {
        contact1 = TestData.contact(true);
        opp = TestData.opportunity(new Opportunity(
            Primary_Contact__c = contact1.Id
        ), true);
        customItem = TestData.customItem(new Custom_Item__c(Opportunity__c = opp.Id), true);
        standardItem = TestData.standardizedItem(new Standardized_Item__c(Opportunity__c = opp.Id),true);
    }
    
    @isTest
    private static void doClone() 
    { 
        Custom_Item__c item = customItem.clone();
        Standardized_Item__c stndrdItem = standardItem.clone();
        
        Test.startTest();
        CloneOpportunity cloneOpp = new CloneOpportunity(opp.Id);
        cloneOpp.CloseDate = Date.today().addDays(5);
        cloneOpp.FactoryShipTo = 'shipto';
        cloneOpp.addCustomItem(item);
        cloneOpp.addStandardizedItem(stndrdItem);  
        Opportunity newOpp = cloneOpp.doClone();
        Test.stopTest();
        
        System.assert(newOpp != null);
        System.assertEquals(cloneOpp.CloseDate, newOpp.CloseDate);
        System.assertEquals(cloneOpp.FactoryShipTo, newOpp.Factory_Ship_To__c);
        System.assertEquals(contact1.Id, newOpp.Primary_Contact__c);
        
        List<Custom_Item__c> customItems = [SELECT Id FROM Custom_Item__c WHERE Opportunity__c = :newOpp.Id];
        List<Standardized_Item__c> standardItems = [SELECT Id FROM Standardized_Item__c WHERE Opportunity__c = :newOpp.Id];
        
        System.assertEquals(1, customItems.size());
        System.assertEquals(1, standardItems.size());
    }
}