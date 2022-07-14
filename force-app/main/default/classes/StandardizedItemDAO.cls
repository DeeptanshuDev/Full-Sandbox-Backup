public class StandardizedItemDAO {

    public static List<Standardized_Item__c> getStandardizedItem(Set<Id> oppIdsMale ){
        
        return [SELECT Id,Pushed_to_AFS__c FROM Standardized_Item__c WHERE Opportunity__c IN: oppIdsMale];
    }
    
    public static List<Standardized_Item__c> getStandardizedItemWithStyle(Set<Id> oppsId){
        
        return [select id,Style__c FROM Standardized_Item__c where Opportunity__c IN : oppsId];
    }
    
    public static List<Standardized_Item__c> getStandardizedItemAccLookup(Set<Id> itemIds){
        
        return [SELECT Id,Account_Lookup__c, Opportunity__r.Account.Id FROM Standardized_Item__c Where ID =: itemIds];
    }
    
    public static List<Standardized_Item__c> StandardizedItems(Set<Id> oppIds){
        
        return [SELECT Id, Opportunity__c, FF_Is_Submitted__c, order_id__c, FF_Create_Item_Successful__c
                FROM Standardized_Item__c
                WHERE Opportunity__c =: oppIds];
    }
    
    public static List<Standardized_Item__c> standardizedItemsInLineQuery(set<Id> custIds){
        
        return [SELECT Id,Name,Pushed_to_AFS__c,Opportunity__c,(SELECT Id,Gender__c FROM order_sizes__r) FROM Standardized_Item__c WHERE Id IN: custIds];
    }
    
    public static List<Standardized_Item__c> getStandardizedItemByTotalPrice(List<Id> listItemIds){
        
        return [SELECT Id, Total_Price_per_Item__c FROM Standardized_Item__c WHERE Id IN :listItemIds ];
    }
    
     public static List<Standardized_Item__c> getStandardizedItemOppRelation(Set<Id> setStandardItemId){
         
         return [SELECT Id, Opportunity__c,Opportunity__r.Is_Item_Finished__c FROM Standardized_Item__c where Id IN: setStandardItemId];
     }
    
    public static List<Standardized_Item__c> getStandardizedItemInLine(Set<Id> setStandardItemId ){
        
        return [SELECT Id, (SELECT Id, recommended_sizes__c FROM Order_Sizes__r) FROM Standardized_Item__c where Id IN: setStandardItemId];
    }
    
}